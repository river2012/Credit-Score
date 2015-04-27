* Refresh Variables;
proc contents data=efs_data.bureau_inq_201412 
			out=varnames_refr 
			noprint
		;
run; %errchk;


proc sql noprint;
	select
		varnames.name
	into
		:refr_var_list separated by ' '

	from varnames_refr as varnames

	where
		varnames.name in ('hit_flag','tu_risk_2009_score')
		or substr(varnames.name,1,2) in ('AS','GO')
	order by
		varnames.varnum
;
quit; %errchk;

* Application variables;
proc contents data=efs_data.app_inq_vars_201409 
			out=varnames_app
			noprint
		;
run; %errchk;


proc sql noprint;
	select
		varnames.name
	into
		:app_var_list separated by ' '

	from varnames_app as varnames

	where
		varnames.name in ('cCreditInquiries')
		or substr(varnames.name,1,4) in ('App_')
	order by
		varnames.varnum
;
quit; %errchk;

%let inq_var_list = &app_var_list. &refr_var_list.;

%put &=inq_var_list.;