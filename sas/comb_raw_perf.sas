data raw_comb(index=(id_idx=(&id_var.) / unique));
	set save.raw_:;
	qtr = 'Q'||put(QTR(cohort_date),1.);
/*	recency_1_more = coalesce(recency_1_more,999);*/
/*	recency_15_more = coalesce(recency_15_more,999);*/
/*	recency_30_more = coalesce(recency_30_more,999);*/
/*	recency_45_more = coalesce(recency_45_more,999);*/
/*	recency_60_more = coalesce(recency_60_more,999);*/
/*	GO29_max_recency = coalesce(GO29_max_recency,999);*/
/*	RI_FrequencyofApps = coalesce(RI_FrequencyofApps,999);*/
run; %errchk;

data perf_comb(index=(id_idx=(&id_var.) / unique));
	set save.perf_:;
run; %errchk;

data save.modeling_ds(index=(id_idx=(&id_var.) / unique));
	merge raw_comb(in=raw_in) perf_comb(in=perf_in keep=&id_var. &target_var.);
	by &id_var.;
	if raw_in and perf_in;
run; %errchk;



data save.dev_new save.val_new save.dev_exist save.val_exist;
	set save.modeling_ds;
	if existing_efs_cs then do;
		if ranuni(12345) < 0.6 then 
			output save.dev_exist;
	  	else
			output save.val_exist;
	end; else do;
		if ranuni(12345) < 0.6 then 
			output save.dev_new;
		else
			output save.val_new;
	end;
run; %errchk;

title All new;
proc freq data=save.Modeling_ds;
	table bad_cs_acct;
	where ^existing_efs_cs;
quit;

title Dev new;
proc freq data=save.dev_new;
	table bad_cs_acct;
quit;

title Val new;
proc freq data=save.val_new;
	table bad_cs_acct;
quit;

title All exist;
proc freq data=save.modeling_ds;
	table bad_cs_acct;
	where existing_efs_cs;
quit;

title Dev exist;
proc freq data=save.dev_exist;
	table bad_cs_acct;
quit;

title Val exist;
proc freq data=save.val_exist;
	table bad_cs_acct;
quit;

title;
