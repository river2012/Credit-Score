%macro logistic_regression(data,target_var,var_list,var_sgnf=.05,est_out=est,corr_out=corr,select=yes);
/*%let est_out=est_out_&calc_grp_auto_postf.;*/
/*%let corr_out=corr_out_&calc_grp_auto_postf.;*/
/*%let data=&dev_ds_name._woe;*/
	%local sgnf_var_list;
	%if &select.=yes %then %do;
		%echo(Logistic stepwise regression);
		ods output ParameterEstimates=&est_out._stepw;
		proc logistic data=&data. desc namelen=60;
			model &target_var. = %list_format(&var_list.,suff=_woe)
				/ selection=stepwise stb corrb lackfit slstay=&var_sgnf.
			;
			output out=devscore_&calc_grp_auto_postf._stepw pred=predict;
		run; %errchk;
		ods output close;

		%echo(Logistic backwards regression);
		ods output ParameterEstimates=&est_out._backw;
		proc logistic data=&data. desc namelen=60;
			model &target_var. = %list_format(&var_list.,suff=_woe)
				/ selection=backward stb corrb lackfit slstay=&var_sgnf.
			;
			output out=devscore_&calc_grp_auto_postf._backw pred=predict;
		run; %errchk;
		ods output close;

		proc sql noprint;
			create table sgnf_var_list
			as select variable
			from (
				select
					variable
				from &est_out._stepw
				where variable ^= 'Intercept'
				union
				select
					variable
				from &est_out._backw
				where variable ^= 'Intercept'
			) sgnf_var
		;
			select 
				variable
			into :sgnf_var_list separated by ' '
			from sgnf_var_list
		;

		quit; %errchk;
	%end; %else %do;
		%let sgnf_var_list=&var_list.;
	%end;

	%put &=sgnf_var_list.;

	%echo(Logistic regression: combined vars);
	ods output ParameterEstimates=&est_out. CorrB=&corr_out.;
	proc logistic data=&data. desc namelen=60;
		model &target_var. = &sgnf_var_list.
			/ selection=none stb corrb lackfit
		;
		output out=devscore_&calc_grp_auto_postf. pred=predict;
	run; %errchk;
	ods output close;

%mend logistic_regression;