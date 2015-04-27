%macro giniconc2(data=, score=,y=, group=n, sort=descending);
  %**** Calculating Concordance ****;
/*     proc sort data=&data out=_temp_;*/
/*        by &sort &score.;*/
/*     run;*/

	 data _temp_;
		set &data.(keep=&y. &score.);
	run; %errchk;

	proc sort data=_temp_;
		by &sort. &score.;
	run; %errchk;
   
     proc summary data=_temp_; by &sort &score;
     output out=_temp1_ n(&y)=n_obs sum(&y)=n_target;
     run;
   
     data _temp2_;set _temp1_(keep=&score n_obs n_target) END=eof;
       n_nont=n_obs-n_target;
       retain tot_targ tot_nont conc disc ties n_pair 0;
       ties=ties + n_nont*n_target;
       conc= conc+n_nont * tot_targ;
       disc=disc+n_target*tot_nont;
       tot_targ=tot_targ+n_target;
       tot_nont=tot_nont+n_nont;
     
       if eof then do;
         n_pair=tot_targ*tot_nont;
         prop_conc = conc/n_pair;
         prop_disc = disc/n_pair;
         prop_ties = ties/n_pair;
         output;
         put prop_conc = prop_disc = prop_ties = ;
         call symput('prop_conc', put(prop_conc, 8.6) );
         call symput('prop_ties', put(prop_ties, 8.6) );
       end;
     run;

  %**** Calculating GINI & KS  ****;

    proc sql noprint;
    select count(*) into: total_pos from &data. where &y=1;
    select count(*) into: total_neg from &data. where &y=0;
    quit;

    %put total events: &total_pos non-events: &total_neg;
    %if "&group." ^= "y" %then %do;
/*         proc sort data=&data. out=_tempsort_;*/
/*           by &sort &score;*/
/*         run;*/
		 data _tempsort_;
			set &data.(keep=&y. &score.);
		run; %errchk;

		proc sort data=_tempsort_;
			by &sort. &score.;
		run; %errchk;

         data _ks_;
         set _tempsort_;
         retain pos_pcnt neg_pcnt tot_pcnt 0;
         if &y=1 then pos_pcnt+1/&total_pos;
         if &y=0 then neg_pcnt+1/&total_neg;
         tot_pcnt+1/(&total_pos + &total_neg);
         ks=pos_pcnt- neg_pcnt;
         nobsg=1;
         run;
    %end;
    %else %do;
/*         proc sort data=&data. out=_tempsort_;*/
/*          by &sort &score;*/
/*         run;*/
		 data _tempsort_;
			set &data.(keep=&y. &score.);
		run; %errchk;

		proc sort data=_tempsort_;
			by &sort. &score.;
		run; %errchk;

         proc summary data=_tempsort_; by &score;
         var &y.;
         output out=_tempgroup_ sum(&y)=n_event n(&y)=nobsg;
         run;

         data _tempgroup_;
           set _tempgroup_;
           n_none=nobsg-n_event;
           keep &score n_event n_none nobsg;
         run;

         proc sort data=_tempgroup_;by &sort &score.;run;

         data _zero_;pos_pcnt=0;run;

         data _ks_;
           retain pos_pcnt neg_pcnt tot_pcnt 0;
           set _zero_ _tempgroup_;
           pos_pcnt+n_event/&total_pos;
           neg_pcnt+n_none/&total_neg;
           tot_pcnt+nobsg/(&total_pos + &total_neg);
           ks=pos_pcnt- neg_pcnt;
         run;
    %end;
         proc sql noprint;
           select max(ks) into:max_ks from _ks_;
           select tot_pcnt into:ks_at from _ks_ where abs(ks-&max_ks)<0.000001;
         quit;
    /*
         proc gplot data=_ks_; plot1 pos_pcnt*tot_pcnt;plot2 neg_pcnt*tot_pcnt;
           symbol1 interpol=join;
         run;*/

		 title2 "MAX_KS is [&max_ks]";
		 	proc sgplot data = _ks_;
		 	xaxis label = 'False Positive rate' values = (0 to 1 by .001);
		 	yaxis label = 'True Positive Rate' values = (0 to 1 by .001);
		 	vector x=pos_pcnt y=pos_pcnt/ xorigin=0 yorigin=0 NOARROWHEADS LINEATTRS=(pattern=34);
		 	series y=pos_pcnt x=neg_pcnt;
		 run;
		 quit;




         data _null_;set _ks_ end=eof;
           retain ap roc last_pos last_neg 0;
           last_pos=lag(pos_pcnt);
           last_neg=lag(neg_pcnt);
           if _n_>1 then do;
           ap=ap+(pos_pcnt+last_pos)*nobsg/(&total_pos + &total_neg);
           roc=roc+ (pos_pcnt+last_pos)*(neg_pcnt-last_neg)/2;
           end;
           if eof then do;gini=(ap-1)/(1- &total_pos/(&total_pos + &total_neg));
             call symput('gini',gini);
             call symput('auc',roc);
           end;
         run;

   %**** Generate statistics for logs and prints ****;
      %put Concordance = [&prop_conc];
      %put Prop_Ties = [&prop_ties];
      %put The GINI Coefficient = &gini;
      %put maximum of KS Statistic = &max_ks at &ks_at;
      %put AUC=&auc;

        data _temp_;
          Concordance=&prop_conc;
          Pct_ties = &prop_ties;
          Gini=&gini;
          Max_KS = &max_ks;
          AUC = &auc;
          dataset="&data";
        run;

        proc print data=_temp_ noobs;
          var dataset Concordance Gini Max_KS AUC Pct_ties;
          format Concordance Gini Max_KS AUCPct_ties  8.4;
        run;

        proc datasets lib=work memtype=data nolist;
          delete _temp_
                 _temp1_ _temp2_ _tempsort_ _tempgroup_
                 _ks_
                 ;
        run;
        quit;

%mend giniconc2;
