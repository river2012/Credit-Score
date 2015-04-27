%let working_path=\\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program;

%let routine_path=&working_path.\sas;
%let csv_in_path=&working_path.\csv_in;

%let save_path=&working_path.\saved_datasets;
%let old_score_path=&save_path.\old_score;

filename routines "&routine_path.";
filename csv_in "&csv_in_path.";

libname save "&save_path.";
libname old_sc "&old_score_path.";

%include snippets(errchk);
%include snippets(echo);
%include snippets(list_loop);
%include snippets(list_format);

* dataset options;
%let calc_grp_auto_postf = exist;
%let bin_file_name = bin_&calc_grp_auto_postf._*.csv;
%let dev_ds_name = dev_&calc_grp_auto_postf.;
%let val_ds_name = val_&calc_grp_auto_postf.;
%let target_var = bad_cs_acct;
%let id_var = cohort_date loan_cust_num;
%let calc_grp_auto_filename = routines(calc_grp_auto_&calc_grp_auto_postf..sas);


* parse SPSS binning;
%include routines(parse_binning);

* generate list of all binned variables;
%include routines(gen_var_list);

* calculate groups based on generated code;
%include routines(calc_grp);
%calc_grp(ungrouped_file_name=save.&dev_ds_name.(keep=&id_var. &target_var. &var_list.)
		,	grouped_file_name = &dev_ds_name._grp
		,	calc_grp_auto_filename=&calc_grp_auto_filename.
);

* calculate logits for each variable group;
%include routines(calc_var_grp_logit);
%calc_var_grp_logit(
		data_dev=&dev_ds_name._grp
	,	data_binning=binning
	,	data_reg_coef=save.est_out_&calc_grp_auto_postf._man
	,	target_var=&target_var.
	,	var_list=&var_list.
	,	out_logit=var_grp_logit_&calc_grp_auto_postf.
);

proc copy in=work out=save;
	select var_grp_logit_&calc_grp_auto_postf.;
run; %errchk;

%include routines(gen_logit_code);
%gen_logit_code(
		logit_ds=var_grp_logit_&calc_grp_auto_postf.
	,	calc_score_auto_filename=routines(calc_score_&calc_grp_auto_postf..sas)
	,	macro_name=calc_score_&calc_grp_auto_postf.
	,	logit_var_template=sc_%sysfunc(ifc(&calc_grp_auto_postf.=new,new,ex))_###
	,	score_transf=-1*round(###*70)+470
);

******* NEED RUN NEW AND EXIST BEFORE *******;

data raw;
	set save.val_new(in=in_new) save.val_exist(in=in_exist);
	if in_exist then
		segment = 'EXIST';
	else if in_new then
		segment = 'NEW  ';
run; %errchk;

%include routines(calc_score_new);
%include routines(calc_score_exist);
%calc_score_new(raw_file_name=raw(where=(segment='NEW')),scored_file_name=val_scored_new);
%calc_score_exist(raw_file_name=raw(where=(segment='EXIST')),scored_file_name=val_scored_exist);

data val_scored_comb(index=(id_idx=(&id_var.)));
	retain &id_var. segment b_score_logit b_score b_risk_group;
	set val_scored_new val_scored_exist;
run; %errchk;

proc copy in=work out=save;
	select val_scored_comb;
run; %errchk;


%include routines(plotks);
%plotks(data=save.val_scored_comb, y=&target_var., score=b_score, sort=, tbin=0.01);
/*
proc sql;
	create table old_score_rg_summary
	as select
		old_score.b_risk_group
	,	count(*) as volume
	,	sum(old_score.&target_var.) as n_bad
	,	sum(sum(1,-old_score.&target_var.)) as n_good
	,	calculated n_bad / calculated volume as bad_rt
	,	min(old_score.b_score) as min_score
	,	max(old_score.b_score) as max_score

	from old_sc.old_score_val_comb as old_score

	group by b_risk_group

	order by b_risk_group desc
;
quit; %errchk;
*/
proc sql;
	create table old_score_rg_summary
	as select
		old_score.b_risk_group
	,	count(*) as volume
	,	sum(old_score.&target_var.) as n_bad
	,	sum(sum(1,-old_score.&target_var.)) as n_good
	,	calculated n_bad / calculated volume as bad_rt
	,	min(old_score.b_score) as min_score
	,	max(old_score.b_score) as max_score

	from old_old.old_old_score_val_comb as old_score

	group by b_risk_group

	order by b_risk_group desc
;
quit; %errchk;

proc sql;
	create table missing_score
	as select
		b_score.*
	from old_old.old_old_score_val_comb as old_score
	left join b_score_combined as b_score
		on  old_score.cohort_date = b_score.cohort_date
			and old_score.loan_cust_num = b_score.loan_cust_num
	where missing(old_score.b_risk_group)
;
quit;

proc freq data=missing_score;
	table segment;
run;

proc print data=old_score_rg_summary;
run; %errchk;

proc sql;
	create table new_score_rg_summary
	as select
		case
			when missing(b_score) then 'Missing'
			when b_score <=557 then 'Risk Group 6'
			when b_score <=595 then 'Risk Group 5'
			when b_score <=634 then 'Risk Group 4'
			when b_score <=658 then 'Risk Group 3'
			when b_score <=697 then 'Risk Group 2'
			else 'Risk Group 1'
		end as b_risk_group
/*		b_risk_group*/
	,	min(b_score) as min_score
	,	max(b_score) as max_score
	,	count(*) as volume
	,	sum(&target_var.) as n_bad
	,	sum(sum(1,-&target_var.)) as n_good
	,	calculated n_bad / calculated volume as bad_rt

	from val_scored_comb

	group by
		calculated b_risk_group

	order by
		b_risk_group desc

;
quit; %errchk;

proc print data=new_score_rg_summary;
run; %errchk;