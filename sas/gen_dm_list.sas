%macro gen_dm_list(start_mon,end_mon,list_name=);
/*	data _null_;*/
/*		dm_mon_start = intnx('month',input("&dm_mon_start.01",yymmdd10.),0,'e');*/
/*		dm_mon_end = intnx('month',input("&dm_mon_end.01",yymmdd10.),0,'e');*/
/*		length dm_stamp_list $ 1000;*/
/*		dm_mon_cur = dm_mon_start;*/
/*		do while (dm_mon_cur <= dm_mon_end);*/
/*			dm_stamp_list = trim(dm_stamp_list)||' '||put(dm_mon_cur,yymmddn.);*/
/*			dm_mon_cur = intnx('month',dm_mon_cur,1,'e');*/
/*		end;*/
/*		call symput("&list_name.",dm_stamp_list);*/
/*	run; %errchk;*/
	%let cur_stamp = %sysfunc(putn(%sysfunc(intnx(month,%sysfunc(inputn(&start_mon.01,yymmdd8.)),0,e)),yymmddn.));
	%if &list_name.^= %then %do;
		%let ___dm_list___ = ;
	%end;
	%do %while (%substr(&cur_stamp.,1,6) <= &end_mon.);
		%if &list_name.= %then %do;
&cur_stamp.
		%end; %else %do;
			%let ___dm_list___ = &___dm_list___.&cur_stamp.%str( );
		%end;
		%let cur_stamp = %sysfunc(putn(%sysfunc(intnx(month,%sysfunc(inputn(&cur_stamp.,yymmdd8.)),1,e)),yymmddn.));
	%end;
	%if &list_name.^= %then %do;
		%global &list_name.;
		%let &list_name. = &___dm_list___.;
	%end;
%mend gen_dm_list;

/*%put %gen_dm_list(201401,201403);*/
/**/
/*%gen_dm_list(201201,201204,list_name=dm_stamp_list);*/
/*%put &dm_stamp_list.;*/
/**/
/*%symdel dm_stamp_list;*/