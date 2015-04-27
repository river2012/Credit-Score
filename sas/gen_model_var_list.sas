%macro gen_model_var_list(reg_coef=reg_coef,exclude_vars=,output_list=custom_var_list,sep=%str( ));
	%local exclude_var_list;
	%global &output_list.;
	%let exclude_var_list = 'Intercept'%sysfunc(ifc(&exclude_vars^=,%str(,)%list_format(list=&exclude_vars.,sep=%str( ),new_sep=%str(,),pref=%str(%'),suff=%str(_woe%')),));

	proc sql noprint;
		select
			variable
		into: &output_list. separated by "&sep."
		from &reg_coef.
		where variable not in (&exclude_var_list.)
	;
	quit; %errchk;
%mend gen_model_var_list;

