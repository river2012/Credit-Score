*******************************************************
** Requires library DATAMART to be defined
*******************************************************;

*%calc_raw_vars(score_date='31jan2013'd, outfile_raw = save.raw_201301, outfile_perf = save.perf_201301, inq_var_list=&inq_var_list.);

*user-friendly macro for calculating raw variables;
%macro calc_raw_vars(score_date, outfile_raw, outfile_perf, refr_attached=yes, inq_var_list=);
/*	%let score_date='31dec2012'd;*/
/*	%let outfile_raw=save.raw_201212;*/
/*	%let outfile_perf=save.perf_201212;*/
/*	%let refr_attached=yes;*/

	%put &=score_date.;
	
	%let restate_start_date = 20121031;
	%let restate_end_date = 20141031;

	%let inq_var_template=###_v2;

	data _null_;
		nxt = intnx('day',"&score_date."d,1);
		array rdate_array[*] rdate0-rdate3;
		do i=1 to dim(rdate_array);
			rdate_array[i] = intnx('quarter',nxt,-i,'e');
			call symputx(cats('rdate',(i-1)), rdate_array[i]);
			call symput(cats('rdate',(i-1),'_stamp'),put(rdate_array[i],yymmddn.));
		end;
		call symput('cur_stamp',put("&score_date."d,yymmddn.));
		nxt_yr = intnx('month',"&score_date."d,12,'e');
		call symput('nxt_yr_stamp',put(nxt_yr,yymmddn.));
		call symput('score_postf',put("&score_date."d,yymmn.));
		_12ago = intnx('month',"&score_date."d,-11,'e');
		_6ago = intnx('month',"&score_date."d,-5,'e');
		_3ago = intnx('month',"&score_date."d,-2,'e');
		call symputx('_12ago',_12ago);
		call symputx('_6ago',_6ago);
		call symputx('_3ago',_3ago);
		call symput('loop_start',put(_12ago,yymmn.));
		call symput('loop_end',put("&score_date."d,yymmn.));
	run; %errchk;

	%echo(**** Cleaning up the WORK library ****);
	%* temporary dataset. will be deleted later;
	data efs_dm_tmp;
		x=0;
	run; %errchk;
	proc datasets library=work noprint memtype=data;
		* Deletes EVERYTHING EXCEPT files starting with "efs_dm_";
		save efs_dm_:;
		delete efs_dm_tmp;
	quit; %errchk;

	* downloading last 12 datamarts;
	%echo(**** Downloading datamarts ****);
	data _null_;
		start_date = intnx('month',input("&loop_start.01",yymmdd8.),0,'e');
		end_date = intnx('month',input("&loop_end.01",yymmdd8.),0,'e');
		put start_date= yymmdd10. end_date= yymmdd10.;
		cur_date = start_date;
		length dm_dl_list $ 1000 dm_name $ 20;
		dm_dl_list = '';
		dm_dl_list_len = 0;
		* previous datamarts;
		do while (cur_date <= end_date);
			dm_stamp = put(cur_date,yymmddn.);
			dm_name = trimn('efs_dm_')||dm_stamp;
			if ^exist(trim(dm_name)) then do;
				dm_dl_list = trim(dm_dl_list)||' '||trim(dm_stamp);
				dm_dl_list_len + 1;
				put dm_name "doesn't exist";
			end; else do;
				put dm_name "exists";
			end;
			cur_date = intnx('month',cur_date,1,'e');
		end;
		* datamart with outcome;
		dm_stamp = &nxt_yr_stamp.;
		dm_name = trimn('efs_dm_')||dm_stamp;
		if ^exist(trim(dm_name)) then do;
			dm_dl_list = trim(dm_dl_list)||' '||trim(dm_stamp);
			dm_dl_list_len + 1;
			put dm_name "doesn't exist";
		end; else do;
			put dm_name "exists";
		end;

		call symput('dm_dl_list',dm_dl_list);
		call symputx('dm_dl_list_len',dm_dl_list_len);
	run; %errchk;

	%put &=dm_dl_list.;

	%sysfunc(
		ifc(
			&dm_dl_list.=
			,%nrstr(%echo(%str(All datamarts are already downloaded, no download needed));)
			,%nrstr(
				%echo(%str(Downloading &dm_dl_list_len. datamart(s): &dm_dl_list.));
				%list_loop(&dm_dl_list.,run=%nrstr(
					%let dm_stamp=&cur_list_item.;
					%let dm_or_restate = %sysfunc(ifc(&dm_stamp.>=&restate_start_date. and &dm_stamp.<=&restate_end_date.,restate,dm));
					%echo(Downloading datamart efs_&dm_or_restate._&dm_stamp.);
					data efs_dm_&dm_stamp.;
						set datamart.efs_&dm_or_restate._&dm_stamp.;
					run;%errchk;
					)
				);
			)
		)
	);
	%sysfunc(ifc( 
		&refr_attached.=yes
		/* Refresh is attached - use datamart*/
	,	%nrstr(
			%let dm_refr_file=efs_dm_&cur_stamp.;
		)
		/* Attach Refresh manually*/
	,	%nrstr(
			proc sql;
				create table dm_refr
				as select 
					bureau.*, datamart.*
				from efs_dm_&cur_stamp as datamart
				left join efs_data.bureau as bureau
					on input(datamart.loan_cust_num,12.) = bureau.new_cust_nbr
				where bureau.score_date = &rdate0.;
			quit; %errchk;
			%let dm_refr_file=dm_refr;
		)
	));

	%let routine_call=
					rdate0=&rdate0.
				,	infile=&dm_refr_file.
				,	infile_outcome=efs_dm_&nxt_yr_stamp.
				,	infile_1ago=efs_dm_&rdate1_stamp.
				,	rdate1=&rdate1.
				,	infile_2ago=efs_dm_&rdate2_stamp.
				,	rdate2=&rdate2.
				,	infile_3ago=efs_dm_&rdate3_stamp.
				,	rdate3=&rdate3.
				,	snapshot="&score_date."d
				,	snapshot12=&_12ago.
				,	snapshot6=&_6ago.
				,	snapshot3=&_3ago.
				,	outfile_raw=&outfile_raw.
				,	outfile_perf=&outfile_perf.
				,	star=&loop_start.
				,	end1=&loop_end.
				,	inq_var_list=&inq_var_list.
				,	inq_var_template=&inq_var_template.
		;
	%calc_raw_vars_routine(&routine_call.);
%mend calc_raw_vars;

* actual calculations of raw variables;
%macro calc_raw_vars_routine(rdate0, infile,infile_outcome,infile_1ago,rdate1,infile_2ago,rdate2,infile_3ago,rdate3,snapshot,snapshot12,snapshot6,snapshot3,outfile_raw,outfile_perf,star, end1, inq_var_list,inq_var_template);

/*%let rdate0=&rdate0.;*/
/*%let infile=efs_dm_&cur_stamp;*/
/*%let infile_outcome=efs_dm_&nxt_yr_stamp.;*/
/*%let infile_1ago=efs_dm_&rdate1_stamp;*/
/*%let rdate1=&rdate1.;*/
/*%let infile_2ago=efs_dm_&rdate2_stamp;*/
/*%let rdate2=&rdate2.;*/
/*%let infile_3ago=efs_dm_&rdate3_stamp;*/
/*%let rdate3=&rdate3.;*/
/*%let snapshot=&score_date;*/
/*%let snapshot12=&_12ago;*/
/*%let snapshot6=&_6ago;*/
/*%let snapshot3=&_3ago;*/
/*%let outfile_raw=&outfile_raw.;*/
/*%let outfile_perf=&outfile_perf.;*/
/*%let star=&loop_start;*/
/*%let end1=&loop_end;*/
/*%let inq_var_list=&inq_var_list.;*/
/*%let inq_var_template=&inq_var_template.;*/

*cumulating performance;
proc sql;
	create table perf as select 
	Loan_Cust_Num, 
	Loan_Loss_Amt,  
	Loan_Sub_Counter, 
	max(Loan_Sub_Counter) as max_sub,
	&snapshot. as cohort_date,
	Loan_Up_To_Date,
	(case when Loan_Loss_Amt^=. and Loan_Loss_Amt>1.5*Loan_Pmt_Amt then 1 else 0 end) as bad_flag_acct,
	REV_LTD_fees+REV_LTD_insurance+REV_LTD_interest  as rev_LTD_last_loan,
	REV_12m_fees+REV_12m_insurance+REV_12m_interest as  rev_12_m

	from &infile_outcome.
	where Loan_Branch not in ('2902','4500','4501','4502')
	group by Loan_Cust_Num
	;
quit; %errchk;

proc sql;
	create table all_cs_perf as select 

	Loan_Cust_Num,
	cohort_date,
	sum(Loan_Loss_Amt) as  write_off_amt,
	max(bad_flag_acct) as bad_cs_acct,

	sum(case when Loan_Sub_Counter=max_sub then rev_LTD_last_loan else 0 end) as rev_LTD_last_loan,
	sum(case when Loan_Sub_Counter=max_sub then rev_12_m else 0 end) as rev_12m_last_loan,
	sum(rev_12_m) as cs_12m_rev
	from perf
	group by Loan_Cust_Num,cohort_date;
quit; %errchk;


*choosing customers to be included into the model;


proc sql;
	create table cs_for_model_list as select 

	Loan_Cust_Num

	from &infile.
	where 
		Loan_Curr_Status="ACTIVE" 
		and (
			Loan_Branch not in ('2902','4500','4501','4502')
/*			or (Loan_Branch = '2902' and loan_funded_date>='01jan2011'd)*/
		)
;
quit; %errchk;

proc sql;
	create table cs_for_model as select 

	Loan_Cust_Num,
	Loan_Acctnbr,
	Loan_Sub_Counter,
	max(Loan_Sub_Counter) as max_sub,
	&snapshot. format date9. as cohort_date,
	sum(TX_LTD_MINIMUM_PAYMENTS) as cs_life_num_min_pymnt,
	sum(DELQ_12m_15_30) as cs_12m_15_30_times,
	sum(TX_LTD_NSF) as cs_nsf_life_times,
	sum(TX_12m_NSF) as cs_nsf_12m_times,
	sum(RI_RefiLoan_Applications) as cs_life_refi_rej_apps

	from &infile.
	where Loan_Cust_Num in (select Loan_Cust_Num from cs_for_model_list)
	group by Loan_Cust_Num
	;
quit; %errchk;

proc sql;
	create table list_of_active_cs as select *
	from cs_for_model
	where max_sub=Loan_Sub_Counter
	;
quit; %errchk;

proc sql;
	create table cs_with_outcome as select a.*, b.*
	from list_of_active_cs a, all_cs_perf b
	where a.Loan_Cust_Num=b.Loan_Cust_Num
	;
quit; %errchk;

*==========================================================================================================================================================;
*----------------------------------------------Cumulating variables---------------------------------------------------------------------------------------;
* application, last refresh, loan snapshot variables;
Proc sql;
	create table app_refresh_loansnapshot_vars as select 
	%rename_inq_vars(
		var_list=%quote(
			Loan_Cust_Num,
			Loan_Acctnbr,

/*			Old_TURiskScore,*/
			New_TURiskScore,

/*			Old_EFSScore,*/
			New_EFSScore,

			CCLogisticScore,
			cCreditInquiries,
			cHomeMortgageOrRentAmount,
			cMonthlyNetIncome,
			cResidenceLocation,
			Loan_Current_Balance, 
			Loan_Origination_Amt,
			AT01,
			AT22,
			AT28,
			AT70,
			GO04,
			GO116,
			GO127,
			GO132,
			GO17,
			GO28,
			IN01,
			PR09,
			PR42,
			Loan_LPPFlag,
			Loan_Pmt_Freq,
			Loan_Cust_Marital,
			Loan_Type,
			Delq_Max_DPD_In_CurrentM as  max_dpd_mnth_cur,
			RI_FrequencyofApps,

			AT191, AT71, FI28, FI33, FI60, GO29, IN33, RE28,
			       RE33, RE66, score_date, tu_risk_2009_score
		)
	,	inq_var_list = &inq_var_list.
	,	template=&inq_var_template.
	)
	from &infile.;
quit; %errchk;

proc sql;
	create table match1 as select a.*, b.*
	from 
	list_of_active_cs a,
	app_refresh_loansnapshot_vars b
	where a.Loan_Cust_Num=b.Loan_Cust_Num and a.Loan_Acctnbr=b.Loan_Acctnbr;
quit; %errchk;


*--------------------------------------------;


proc sql;
	create table calc1 as select * ,
	(case when Loan_Sub_Counter>1 then 1 else 0 end) as existing_efs_cs,
	Loan_Current_Balance/Loan_Origination_Amt as cur_paydown
	from match1;
quit; %errchk;


/*=========================EFS performance============================================*/

proc sql;   
	create table data_pull as select 
	Loan_Cust_Num,Loan_Funded_date,
	Loan_Type, Loan_Sub_Counter,Loan_Origination_Amt,Loan_Pmt_Amt,Loan_User_Paid_PCT_PO,Loan_System_Paid_PO,Loan_Firstpaydefault
	from  &infile. where Loan_Cust_Num in (select Loan_Cust_Num from calc1)
	;
quit; %errchk;



proc sql;
create table cs_life_metrics as select 
*,

max(Loan_Sub_Counter) as max_sub,
max(Loan_Funded_date) format date9. as max_funded_date

from  data_pull 
group by Loan_Cust_Num
order by Loan_Cust_Num,Loan_Funded_date;
quit; %errchk;



data cs_life_metrics2;
	set cs_life_metrics;
	by Loan_Cust_Num;
	temp= INTCK('MONTH',lag(Loan_Funded_date),Loan_Funded_date);
	if first.Loan_Cust_Num then do loan_distance=.;  end;
	else loan_distance=temp;
	drop temp ;
run; %errchk;

proc sort data= cs_life_metrics2;
	by Loan_Cust_Num  descending Loan_Funded_date;
run; %errchk;

data cs_life_metrics2;
	set cs_life_metrics2;
	by Loan_Cust_Num;

	temp2= lag(Loan_Funded_date);
	if first.Loan_Cust_Num then do next_fund_date=.;  end;
	else next_fund_date=temp2;
	format next_fund_date date9. ;
	drop  temp2;

run; %errchk;


proc sql;
	create table calc3 as select 
	*, 
	mean(loan_distance) as avg_mnth_between_loans

	from cs_life_metrics2
	group by Loan_Cust_Num;
quit; %errchk;



/* going through monthly files to identify delinquency */

Proc sql;
	create table cumul as select 
	Loan_Cust_Num, 
	. as recency_1_more,
	. as recency_15_more,
	. as recency_30_more,
	. as recency_45_more,
	. as recency_60_more,
	0 as max_dpd_mnth_3m,
	. as _12mago_paydown,
	. as _3mago_paydown,
	. as _3mago_bal

	from match1;
quit; %errchk;



%macro month_process(infile1);

	Proc sql;
		create table last_loan as select
		Loan_Current_Balance,
		Loan_Origination_Amt,
		Loan_Pmt_Amt,
		Datamart_Date ,
		Loan_Cust_Num, 
		DELQ_Curr_DPD,
		Delq_Max_DPD_In_CurrentM,
		Loan_Sub_Counter, 
		max(Loan_Sub_Counter) as max_sub
		from &infile1. 
		where Loan_Cust_Num in (select Loan_Cust_Num from cumul)
		group by Loan_Cust_Num;
	quit; %errchk;

	proc sql;
		create table addit1 as select 
		a.Loan_Cust_Num,
		(case when DELQ_Curr_DPD>=1 then INTCK('MONTH',a.Datamart_Date,&snapshot.) else b.recency_1_more end)as recency_1_more,
		(case when DELQ_Curr_DPD>=15 then INTCK('MONTH',a.Datamart_Date,&snapshot.) else b.recency_15_more  end)as recency_15_more,
		(case when DELQ_Curr_DPD>=30 then INTCK('MONTH',a.Datamart_Date,&snapshot.) else b.recency_30_more  end)as recency_30_more,
		(case when DELQ_Curr_DPD>=45 then INTCK('MONTH',a.Datamart_Date,&snapshot.) else b.recency_45_more  end)as recency_45_more,
		(case when DELQ_Curr_DPD>=60 then INTCK('MONTH',a.Datamart_Date,&snapshot.) else b.recency_60_more  end)as recency_60_more,


		(case when  a.Datamart_Date >= &snapshot3. then   max(a.Delq_Max_DPD_In_CurrentM,b.max_dpd_mnth_3m) else 0 end) as max_dpd_mnth_3m,
		(case when a.Datamart_Date = &snapshot3. then  a.Loan_Current_Balance else b._3mago_bal end) as _3mago_bal,


		/*(case when a.Datamart_Date = &snapshot12. then  a.Loan_Pmt_Amt else  b._12mago_pymnt end) as _12mago_pymnt,*/
		/*(case when a.Datamart_Date = &snapshot6. then   a.Loan_Pmt_Amt else  b._6mago_pymnt end)  as _6mago_pymnt,*/
		/*(case when a.Datamart_Date = &snapshot3. then   a.Loan_Pmt_Amt else  b._3mago_pymnt end)  as _3mago_pymnt,*/


		(case when a.Datamart_Date = &snapshot12. then  a.Loan_Current_Balance/a.Loan_Origination_Amt else  b._12mago_paydown end)  as _12mago_paydown,
		(case when a.Datamart_Date = &snapshot3. then   a.Loan_Current_Balance/a.Loan_Origination_Amt else  b._3mago_paydown end)  as _3mago_paydown


		from last_loan a, cumul b
		where a.Loan_Cust_Num=b.Loan_Cust_Num and a.Loan_Sub_Counter=a.max_sub;
	quit; %errchk;

	proc sql;
		create table addit2 as select * 
		from cumul where Loan_Cust_Num not in (select Loan_Cust_Num from addit1);
	quit; %errchk;

	data cumul;
		set addit1 addit2;
	run; %errchk;
%mend month_process;


%macro process_all_month(start=, end=);
  %let mth=&start;

  %do %while (%sysevalf(&mth <= &end) );

  data _null_;
  d = input("&mth"||'01', yymmdd8.);
  z = intnx('month',d,1)-1;
  Call symput('procd', put(z,yymmddn8.));
  format z date9.;
  put z;
   run; %errchk;
 %month_process(efs_dm_&procd) ;
   data _null_;
      y = input("&mth"||'01', yymmdd8.);
      z=intnx('month', y, +1, 'e');
      call symput('mth', put(z, yymmn6.));
    run; %errchk;
  %end;
%mend process_all_month;


%process_all_month(start=&star, end=&end1 );   /* CHANGE!!!!*/



*=============================== aggregation of all pieces=====================================================;

proc sql;
	create table all_vars1 as select a.*,b.* 
	from calc1 a, cumul b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;


proc sql;
	create table all_vars2 as select a.*,b.*
	from all_vars1 a,calc3 b
	where a.Loan_Cust_Num=b.Loan_Cust_Num and b.Loan_Sub_Counter=b.max_sub;
quit; %errchk;

/**/
/**/
/*proc sql;*/
/*create table out.che3 as select * from efs_dm_20120131*/
/*where Loan_Cust_Num='000000492504';*/
/*quit; %errchk;*/

/* ================some additional variables====================================================================*/

proc sql;
	create table all_vars3 as select *,

	(_3mago_bal-Loan_Current_Balance)/_3mago_bal as _3m_bal_chgp,
	Loan_Current_Balance/Loan_Origination_Amt-_12mago_paydown as _12m_pydown_chg,
	Loan_Current_Balance/Loan_Origination_Amt-_3mago_paydown as _3m_pydown_chg

	from all_vars2;
quit; %errchk;



/* =======================Creating refresh changes==============================================*/
/*===============================================================================================*/

/*===============================================================================================*/

/*===============================================================================================*/

proc sql;
	create table refr_cur  /*refr_cumul*/ as select 
	%rename_inq_vars(
		var_list=%quote(
			Loan_Cust_Num,
			score_date,
			RE33/RE28 as cur_util_rev, 
			FI33/FI28 as cur_util_fin_inst, 
			tu_risk_2009_score,
			AT191,
			AT71,
			FI60,
			GO04,
			GO127,
			GO29,
			IN33,
			PR42,
			RE33,
			RE66,
			re28,
			fi33,
			fi28
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from all_vars3
	where score_date=&rdate0 ;
quit; %errchk;


%macro refresh (fi,date1,outf);

proc sql;
	create table add_up as select 
	%rename_inq_vars(
		var_list=%quote(
			Loan_Cust_Num,
			Loan_Sub_Counter,
			max(Loan_Sub_Counter) as max_sub,
			score_date,
			tu_risk_2009_score,
			RE33/RE28 as cur_util_rev, 
			FI33/FI28 as cur_util_fin_inst, 
			AT191,
			AT71,
			FI60,
			GO04,
			GO127,
			GO29,
			IN33,
			PR42,
			RE33,
			RE66,
			re28,
			fi33,
			fi28
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from  &fi. 
	where score_date=&date1. and Loan_Cust_Num in (select Loan_Cust_Num from all_vars3)
	group by Loan_Cust_Num
	;
quit; %errchk;

proc sql;
create table &outf. as select *
from add_up
where Loan_Sub_Counter=max_sub;
quit; %errchk;

%mend refresh;


%refresh(&infile_1ago.,&rdate1.,refr_1ago);
%refresh(&infile_2ago.,&rdate2.,refr_2ago);
%refresh(&infile_3ago.,&rdate3.,refr_3ago);


data refr_cumul;
set refr_cur;
run; %errchk;

%macro refresh2 (fi,date1);

proc sql;
	create table add_up as select 
	%rename_inq_vars(
		var_list=%quote(
			Loan_Cust_Num,
			Loan_Sub_Counter,
			max(Loan_Sub_Counter) as max_sub,
			score_date,
			tu_risk_2009_score,
			In33/in28 as cur_util_inst, 
			RE33/RE28 as cur_util_rev, 
			FI33/FI28 as cur_util_fin_inst, 
			AT191,
			AT71,
			FI60,
			GO04,
			GO127,
			GO29,
			IN33,
			PR42,
			RE33,
			RE66,
			RE28,
			FI33,
			FI28
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from 
	&fi.
	where score_date=&date1. and Loan_Cust_Num in (select Loan_Cust_Num from all_vars3)
	group by Loan_Cust_Num
;
quit; %errchk;

proc sql;
	create table add_up2 as select *
	from add_up
	where Loan_Sub_Counter=max_sub;
quit; %errchk;

data refr_cumul;
	set refr_cumul add_up2;
run; %errchk;


%mend refresh2;


%refresh2(&infile_1ago.,&rdate1.);
%refresh2(&infile_2ago.,&rdate2.);
%refresh2(&infile_3ago.,&rdate3.);

%macro change(ref,mago);

proc sql;
	create table refresh_metrics&mago as select 
	%rename_inq_vars(
		var_list=%quote(
			a.Loan_Cust_Num,
			a.re33/a.re28-b.re33/b.re28 as cur_util_rev_chg_&mago.,
			a.fI33/a.fi28-b.fi33/b.fi28 as cur_util_fi_chg_&mago.,
			a.PR42-b.PR42 as PR42_chg_&mago.,
			(a.GO04-b.GO04)/b.GO04 as GO04_chgp_&mago.,
			a.tu_risk_2009_score-b.tu_risk_2009_score as tu_risk_2009_sc_chg_&mago.,
			(a.RE33-b.RE33)/b.RE33 as RE33_chgp_&mago.,
			a.IN33-b.IN33 as IN33_chg_&mago.,
			(a.FI60-b.FI60)/b.FI60 as FI60_chgp_&mago.,
			a.AT71-b.AT71 as AT71_chg_&mago.
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)

	from refr_cur a, &ref. b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;

%mend change;

%change(refr_3ago,_12mago);
%change(refr_2ago,_6mago);
%change(refr_1ago,_3mago);

data refr_cumul;
	set  refr_cumul (drop = max_sub Loan_Sub_Counter);
run; %errchk;

proc sql;
	create table refresh_summary1 as select 
	%rename_inq_vars(
		var_list=%quote(
			*,
			min(score_date) format date9. as oldest_pull,
			max(score_date) format date9. as newest_pull,
			max(FI33/FI28) as max_util_fin_inst, 
			max(AT191) as  AT191_max,
			max(GO29) as  GO29_max
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from refr_cumul
	group by Loan_Cust_Num;
quit; %errchk;

/*options mfile mprint;*/
/*filename mprint 'C:\Work\Projects\Scorecard Development Automation\tmp\debugmac';*/
proc sql;
	create table refresh_summary3 as select 
	%rename_inq_vars(
		var_list=%str(
			Loan_Cust_Num,
			min(case when GO29=GO29_max then INTCK('MONTH',score_date,&snapshot.) end) as GO29_max_recency,
			min(case when score_date=&rdate0. then AT191-AT191_max end) as AT191_max_cur_chg
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from refresh_summary1
	group by Loan_Cust_Num;
quit; %errchk;
/*options nomfile nomprint;*/

proc sql;
	create table refresh_summary2 as select 
	%rename_inq_vars(
		var_list=%quote(
			Loan_Cust_Num,
			std(case when score_date>=&rdate1. then RE66 end) as RE66_std_3m,
			std(GO127) as GO127_std
		)
	,	inq_var_list=&inq_var_list.
	,	template=&inq_var_template.
	)
	from refresh_summary1
	group by Loan_Cust_Num;
quit; %errchk;

proc sql;
	create table refresh_summary4 as select 
	*
	from 
	refresh_summary1 
	where
	score_date = newest_pull;
quit; %errchk;




/*============================ combining refresh variables together ===========================================*/

proc sql;
	create table comb1 as select 
	a.*,b.*
	from refresh_summary4 a, refresh_summary3 b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;

proc sql;
	create table comb2 as select 
	a.*,b.*
	from comb1 a, refresh_summary2 b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;

%macro combin (infilem);

proc sql;
	create table comb as select 
	a.*,b.*
	from  comb2 a, &infilem. b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;

proc sql;
	create table addit as select * from comb2
	where Loan_Cust_Num not in (select Loan_Cust_Num from comb);
quit; %errchk;

data comb2;
	set addit comb;
run; %errchk;

%mend combin;

%combin (refresh_metrics_3mago);
%combin (refresh_metrics_6mago);
%combin (refresh_metrics_12mago);



/*======================= combining with a main dataset=====================================*/

proc sql;
	create table modeling_ds as select
	a.*,b.*
	from all_vars3 a, comb2 b
	where a.Loan_Cust_Num=b.Loan_Cust_Num;
quit; %errchk;

proc sql;
	create table additional as select * from all_vars3 
	where Loan_Cust_Num not in (select Loan_Cust_Num from modeling_ds) ;
quit; %errchk;

data raw_vars;
	set modeling_ds additional;
run; %errchk;

**************** Saving datasets ***************************;
data &outfile_raw.;
	set raw_vars;
run; %errchk;

data &outfile_perf.;
	set cs_with_outcome;
run; %errchk;

%mend  calc_raw_vars_routine;

*rdate0, infile,/*infile_outcome,*/infile_1ago,rdate1,infile_2ago,rdate2,infile_3ago,rdate3,snapshot,snapshot12,snapshot6,snapshot3,outfile_raw,star, end1;

/*%calc_raw_vars_routine('31Mar2012'd,in.efs_dm_20120331,in.efs_dm_20130331,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,in.efs_dm_20110630,'30jun2011'd,	'31may2012'd , '30apr2011'd ,'31oct2011'd,'31jan2012'd,   out.scored_201203,201104,201203);*/
/*%calc_raw_vars_routine('31Mar2012'd,in.efs_dm_20120430,in.efs_dm_20130431,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,in.efs_dm_20110630,'30jun2011'd,	'30apr2012'd , '31may2011'd ,'30nov2011'd,'29feb2012'd,   out.scored_201204,201105,201204);*/
/*%calc_raw_vars_routine('31Mar2012'd,in.efs_dm_20120531,in.efs_dm_20130531,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,in.efs_dm_20110630,'30jun2011'd,	'31may2012'd , '30jun2011'd ,'31dec2011'd,'31mar2012'd,   out.scored_201205,201106,201205);*/
/**/
/*%calc_raw_vars_routine('30Jun2012'd,in.efs_dm_20120630,in.efs_dm_20130630,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,	'30jun2012'd , '31jul2011'd ,'31jan2012'd,'30apr2012'd,   out.scored_201206,201107,201206);*/
/*%calc_raw_vars_routine('30Jun2012'd,in.efs_dm_20120731,in.efs_dm_20130731,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,	'31jul2012'd , '31aug2011'd ,'29feb2012'd,'31may2012'd,   out.scored_201207,201108,201207);*/
/*%calc_raw_vars_routine('30Jun2012'd,in.efs_dm_20120831,in.efs_dm_20130831,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,in.efs_dm_20110930,'30sep2011'd,	'31Aug2012'd , '30sep2011'd ,'31Mar2012'd,'30JUn2012'd,   out.scored_201208,201109,201208);*/


/*%calc_raw_vars_routine('30Sep2012'd,in.efs_dm_20120930,in.efs_dm_20130930,in.efs_dm_20120630,'30jun2012'd,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,	'30SEP2012'd , '31OCT2011'd ,'30APR2012'd,'31JUL2012'd,   out.scored_201209,201110,201209);*/
/*%calc_raw_vars_routine('30Sep2012'd,in.efs_dm_20121031,in.efs_dm_20131031,in.efs_dm_20120630,'30jun2012'd,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,	'31OCT2012'd ,'30nov2011'd ,'31may2012'd,'31aug2012'd,   out.scored_201210,201111,201210);*/
/*%calc_raw_vars_routine('30Sep2012'd,in.efs_dm_20121130,in.efs_dm_20131130,in.efs_dm_20120630,'30jun2012'd,in.efs_dm_20120331,'31mar2012'd,in.efs_dm_20111231,'31dec2011'd,	'30nov2012'd ,'31dec2011'd ,'30jun2012'd,'30sep2012'd,   out.scored_201211,201112,201211);*/
/**/
/*%calc_raw_vars_routine('31Dec2012'd,in.efs_dm_20121231,in.efs_dm_20131231,in.efs_dm_20120930,'30sep2012'd,in.efs_dm_20120630,'30jun2012'd,in.efs_dm_20120331,'31mar2012'd,	'31dec2012'd ,'31jan2012'd ,'31jul2012'd,'31oct2012'd,   out.scored_201212,201201,201212);*/
/*%calc_raw_vars_routine('31Dec2012'd,in.efs_dm_20130131,in.efs_dm_20140131,in.efs_dm_20120930,'30sep2012'd,in.efs_dm_20120630,'30jun2012'd,in.efs_dm_20120331,'31mar2012'd,	'31jan2013'd ,'29feb2012'd ,'31aug2012'd,'30nov2012'd,   out.scored_201301,201202,201301);*/
