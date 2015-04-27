%macro plotks( data=, y=, score=, sort=descending, tbin=0.05, gbin=0.001);

	data _temp_;
		set &data.(keep=&y. &score.);
	run; %errchk;

	proc sort data=_temp_;
		by &sort. &score.;
	run; %errchk;



	proc sql noprint;
		select count(*) into: tot_n from _temp_;
		select count(*) into: tot_good from _temp_     where &y.=0;
		select count(*) into: tot_bad from _temp_     where &y.=1;
	quit; %errchk;



	data _t_ (keep=depth min_score max_score &score. bin_&score. bin_bad_rt bintot bin_bad cumtot cum_bad cum_&score. cum_bad_rt prop_bad prop_good ks max_ks)
			_g_ (keep=depth prop_bad prop_good bin_bad_rt cum_bad_rt cum_&score. bin_&score.)
			;
		set _temp_ end=eof;
		retain min_score . cum_bad 0 cumtot 0 max_ks . cum_scoresum 0
		    bin_bad 0  max_score . bintot tsize gsize bin_scoresum		
			;
		if _n_ = 1 then do;
			depth=0;
			prop_bad=0;
			prop_good=0;

			tsize = ceil(&tbin. * &tot_n.);
			gsize = ceil(&gbin. * &tot_n.);
			output _g_;
		end;

		depth = _n_/&tot_n.;

		bin_bad + &y.;
		bintot + 1;
		bin_scoresum + &score.;



		cum_bad + &y.;
		cumtot + 1;
		cum_scoresum + &score.;

		prop_bad = cum_bad / &tot_bad.;
		prop_good = (cumtot - cum_bad ) / &tot_good.;

		ks =  abs(prop_good - prop_bad) ;
		max_ks = max(max_ks, ks);

		min_score =min( min_score, &score.);
		max_score =max( max_score, &score.);

		* end of tbin;
		if mod(_n_, tsize)=0 or depth=1 then do;
			bin_bad_rt = bin_bad / bintot;
			bin_&score. = bin_scoresum / bintot;
			cum_bad_rt = cum_bad / cumtot;
			cum_&score. = cum_scoresum / cumtot;
			output _t_;
			bin_bad = 0;
			bintot = 0;
			bin_scoresum = 0;
			min_score = .;
			max_score = .;
		end;

		* end of gbin;
		if mod(_n_, gsize)=0 or depth=1 then do;
		 output _g_;
		end;

		if eof then call symput('max_ks', put(max_ks, 8.6) );

	run; %errchk;


	data _g_;
		set _g_;
		Cumulative_bad=prop_bad;
		Cumulative_good=prop_good;
	run; %errchk;


	title2 "Max_KS is [&max_ks]";
	proc print data=_t_;
		var depth min_score max_score  bin_&score bintot bin_bad bin_bad_rt cum_&score cumtot cum_bad cum_bad_rt prop_bad prop_good ks max_ks /*&score.*/;
		format depth percent6.
		bin_bad_rt cum_bad_rt prop_bad prop_good ks max_ks percent8.2;
	run; %errchk;

	* Deleting temp datasets;
	proc datasets lib=work memtype=data nolist;
		delete _temp_ _t_ _g_;
	run; 
	quit; %errchk;

	title;
	title2;
%mend;
