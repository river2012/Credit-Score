%let working_path=\\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program;

%let routine_path=&working_path.\sas;
%let csv_in_path=&working_path.\csv_in;

%let save_path=&working_path.\saved_datasets;

filename routines "&routine_path.";
filename csv_in "&csv_in_path.";

libname save "&save_path.";

*filename snippets 'C:\Work\Misc\Snippets';

%include snippets(errchk);
%include snippets(echo);
%include snippets(list_loop);
%include snippets(list_format);



* dataset options;
%let calc_grp_auto_postf = new;
%let bin_file_name = bin_&calc_grp_auto_postf._*.csv;
%let dev_ds_name = dev_&calc_grp_auto_postf.;
%let val_ds_name = val_&calc_grp_auto_postf.;
%let target_var = bad_cs_acct;
%let id_var = cohort_date loan_cust_num;
%let calc_grp_auto_filename = routines(calc_grp_auto_&calc_grp_auto_postf..sas);
%symdel &calc_grp_auto_postf._done_flag;

****** BULIDING THE SCORE ******;

* parse SPSS binning;
%include routines(parse_binning);

* generate list of all binned variables;
%include routines(gen_var_list);

* generate grouping code;
%include routines(gen_grp_code);

* calculate groups based on generated code;
%include routines(calc_grp);
%calc_grp(ungrouped_file_name=save.&dev_ds_name.(keep=&id_var. &target_var. &var_list.)
		,	grouped_file_name = &dev_ds_name._grp
		,	calc_grp_auto_filename=&calc_grp_auto_filename.
);

* calculate woe;
%include routines(calc_woe);
%calc_woe(data=&dev_ds_name._grp,data_woe=&dev_ds_name._woe,id_var=&id_var.,target_var=&target_var.,var_list=&var_list.);

* calculating groups for validation dataset;
%calc_grp(
		ungrouped_file_name=save.&val_ds_name.(keep=&id_var. &target_var. &var_list.)
	,	grouped_file_name = &val_ds_name._grp
	,	calc_grp_auto_filename=&calc_grp_auto_filename.
);
* woe for validation dataset;
%calc_woe(data=&val_ds_name._grp,data_dev=&dev_ds_name._grp,data_woe=&val_ds_name._woe,id_var=&id_var.,target_var=&target_var.,var_list=&var_list.);

proc copy in=work out=save;
	select &dev_ds_name._woe 
			&val_ds_name._woe 
;
run; %errchk;

/*
proc copy in=save out=work;
	select &dev_ds_name._woe &val_ds_name._woe est_out_&calc_grp_auto_postf. devscore_&calc_grp_auto_postf. valscore_&calc_grp_auto_postf.;
run; %errchk;
*/

* stepwise regression;
%include routines(logistic_regression);
%logistic_regression(data=&dev_ds_name._woe,target_var=&target_var.,var_list=&var_list.,var_sgnf=0.005,est_out=est_out_&calc_grp_auto_postf.,corr_out=corr_out_&calc_grp_auto_postf.);

* Manual adjustments: specify variables to exclude from regression;
/*%let exclude_vars = RE33 cs_12m_15_30_times cHomeMortgageOrRentAmount cResidenceLocation;*/
%let exclude_vars = _3m_pydown_chg max_dpd_mnth_cur /*max_dpd_mnth_3m*/ cs_nsf_life_times recency_1_more recency_15_more;

%include routines(gen_model_var_list);
%gen_model_var_list(reg_coef=est_out_&calc_grp_auto_postf.,exclude_vars=&exclude_vars.,output_list=custom_var_list);
%put &=custom_var_list.;

%logistic_regression(data=&dev_ds_name._woe,target_var=&target_var.,var_list=&custom_var_list.,select=no,est_out=est_out_&calc_grp_auto_postf._man,corr_out=corr_out_&calc_grp_auto_postf._man);

* calculating logits for validation dataset;
%include routines(calc_pd_val);
%calc_pd_val(val_ds=&val_ds_name._woe,reg_coef=est_out_&calc_grp_auto_postf._man,logit_out=valscore_&calc_grp_auto_postf.);


*plotks;
%include routines(plotks);
%include routines(giniconc);
title "%sysfunc(upcase(&calc_grp_auto_postf.)): Development";
%plotks(data=devscore_&calc_grp_auto_postf., y=&target_var., score=predict);
%giniconc2(data=devscore_&calc_grp_auto_postf., score=predict, y=&target_var.);
title;

title "%sysfunc(upcase(&calc_grp_auto_postf.)): Validation";
%plotks(data=valscore_&calc_grp_auto_postf., y=&target_var., score=predict);
%giniconc2(data=valscore_&calc_grp_auto_postf., score=predict, y=&target_var.);
title;


proc copy in=work out=save;
	select 	est_out_&calc_grp_auto_postf. 
			est_out_&calc_grp_auto_postf._man
			devscore_&calc_grp_auto_postf. 
			valscore_&calc_grp_auto_postf. 
			corr_out_&calc_grp_auto_postf.
			corr_out_&calc_grp_auto_postf._man
;
run; %errchk;

%let &calc_grp_auto_postf._done_flag = 1;

/*
proc copy in=save out=work;
	select devscore_exist valscore_exist; 
;
run; %errchk;

%let exist_done_flag = 1;
*/


* Combined. Will be run only after new and exist are finished;

%sysfunc(ifc(
	%symexist(new_done_flag) and %symexist(exist_done_flag)
,	%nrstr(
		;
		data devscore_comb;
			set devscore_new(in=in_new) devscore_exist(in=in_exist);
			length segment $ 6;
			if in_new then segment='New';
			else if in_exist then segment='Exist';
			else segment='';
		run; %errchk;

		data valscore_comb;
			set valscore_new(in=in_new) valscore_exist(in=in_exist);
			length segment $ 6;
			if in_new then segment='New';
			else if in_exist then segment='Exist';
			else segment='';
		run; %errchk;

		proc copy in=work out=save;
			select valscore_comb devscore_comb;
		run; %errchk;



		title "ALL: Development";
		%plotks(data=devscore_comb, y=&target_var., score=predict);
		%giniconc2(data=devscore_comb, score=predict, y=&target_var.);
		title;

		title "ALL: Validation";
		%plotks(data=valscore_comb, y=&target_var., score=predict);
		%giniconc2(data=valscore_comb, score=predict, y=&target_var.);
		title;
	)
,	%nrstr(
		%echo(Combined statistics will not be produced since New or Existing segment is not finished);
	)
));
