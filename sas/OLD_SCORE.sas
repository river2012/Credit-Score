%let working_path=\\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program;

%let routine_path=&working_path.\sas;
%let csv_in_path=&working_path.\csv_in;

%let save_path=&working_path.\saved_datasets;
%let old_score_path=&save_path.\old_score;
%let old_old_score_path=&save_path.\old_old_score;

filename routines "&routine_path.";
filename csv_in "&csv_in_path.";

libname save "&save_path.";

libname old_sc "&old_score_path.";
libname old_old "&old_old_score_path.";


%let target_var = bad_cs_acct;
%let id_var = cohort_date loan_cust_num;


*filename snippets 'C:\Work\Misc\Snippets';

%include snippets(errchk);
%include snippets(echo);
/*%include snippets(list_loop);*/
/*%include snippets(list_format);*/

* list of inquiry variables (subject to change);
/*%include routines(gen_inq_var_list);*/
* macro for renaming inquiry variables;
/*%include routines(rename_inq_vars);*/

data raw_dev_comb;
	set save.dev_new(in=in_new) save.dev_exist(in=in_exist);
	length segment $ 6;
	if in_new then segment='NEW';
	else if in_exist then segment='EXIST';
	else segment='';
run; %errchk;

data raw_val_comb;
	set save.val_new(in=in_new) save.val_exist(in=in_exist);
	length segment $ 6;
	if in_new then segment='NEW';
	else if in_exist then segment='EXIST';
	else segment='';
run; %errchk;

%include routines(calc_old_score);
%calc_old_score(raw_file=raw_dev_comb, scored_file=old_sc.old_score_dev_comb);
%calc_old_score(raw_file=raw_val_comb, scored_file=old_sc.old_score_val_comb);

proc copy in=efs_data out=work;
	select b_score_combined;
quit; %errchk;

%include routines(calc_old_old_score);
%calc_old_old_score(raw_file=raw_dev_comb, scored_file=old_old.old_old_score_dev_comb, b_score_file=work.b_score_combined);
%calc_old_old_score(raw_file=raw_val_comb, scored_file=old_old.old_old_score_val_comb, b_score_file=work.b_score_combined);

* breaking old_score;
data old_sc.old_score_dev_new;
	set old_sc.old_score_dev_comb;
	where segment='NEW';
run; %errchk;

data old_sc.old_old_score_dev_exist;
	set old_sc.old_score_dev_comb;
	where segment='EXIST';
run; %errchk;

data old_sc.old_score_val_new;
	set old_sc.old_score_val_comb;
	where segment='NEW';
run; %errchk;

data old_sc.old_score_val_exist;
	set old_sc.old_score_val_comb;
	where segment='EXIST';
run; %errchk;

* breaking old_old_score;
data old_old.old_old_score_dev_new;
	set old_old.old_old_score_dev_comb;
	where segment='NEW';
run; %errchk;

data old_old.old_old_score_dev_exist;
	set old_old.old_old_score_dev_comb;
	where segment='EXIST';
run; %errchk;

data old_old.old_old_score_val_new;
	set old_old.old_old_score_val_comb;
	where segment='NEW';
run; %errchk;

data old_old.old_old_score_val_exist;
	set old_old.old_old_score_val_comb;
	where segment='EXIST';
run; %errchk;


%include routines(plotks);
%include routines(giniconc);


title "ALL: Development";
%plotks(data=old_sc.old_score_dev_comb, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_dev_comb, score=predict, y=&target_var.);
title;

title "ALL: Validation";
%plotks(data=old_sc.old_score_val_comb, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_val_comb, score=predict, y=&target_var.);
title;

* new segment;
title "NEW: Development";
%plotks(data=old_sc.old_score_dev_new, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_dev_new, score=predict, y=&target_var.);
title;

title "NEW: Validation";
%plotks(data=old_sc.old_score_val_new, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_val_new, score=predict, y=&target_var.);
title;

* Existing segment;
title "EXIST: Development";
%plotks(data=old_sc.old_score_dev_exist, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_dev_exist, score=predict, y=&target_var.);
title;

title "EXIST: Validation";
%plotks(data=old_sc.old_score_val_exist, y=&target_var., score=predict);
%giniconc2(data=old_sc.old_score_val_exist, score=predict, y=&target_var.);
title;







title "ALL: Development";
%plotks(data=old_old.old_old_score_dev_comb, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_dev_comb, score=b_score, y=&target_var., sort=);
title;

title "ALL: Validation";
%plotks(data=old_old.old_old_score_val_comb, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_val_comb, score=b_score, y=&target_var., sort=);
title;

* new segment;
title "NEW: Development";
%plotks(data=old_old.old_old_score_dev_new, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_dev_new, score=b_score, y=&target_var., sort=);
title;

title "NEW: Validation";
%plotks(data=old_old.old_old_score_val_new, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_val_new, score=b_score, y=&target_var., sort=);
title;

* Existing segment;
title "EXIST: Development";
%plotks(data=old_old.old_old_score_dev_exist, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_dev_exist, score=b_score, y=&target_var., sort=);
title;

title "EXIST: Validation";
%plotks(data=old_old.old_old_score_val_exist, y=&target_var., score=b_score, sort=);
%giniconc2(data=old_old.old_old_score_val_exist, score=b_score, y=&target_var., sort=);
title;
