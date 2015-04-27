%macro rename_inq_vars(var_list, inq_var_list, template=###);
/*	%put &=var_list.;*/

	%* separating list by colon (:);
/*	%let var_list_col = %list_format(%quote(&var_list.),sep=%quote(,),new_sep=:);*/
	%let var_list_col = &var_list.;

/*	%put &=var_list_col;*/

	%* renaming variables appearing on the inq_var_list (e.g. renaming "GO04" to "GO04_v2");
	%list_loop(
		list=%bquote(&inq_var_list.)
	,	run=%nrstr(%let var_list_col = %sysfunc(tranwrd(%bquote(&var_list_col.),%bquote(&cur_list_item.),%sysfunc(tranwrd(%bquote(&template.),###,%bquote(&cur_list_item.)))));)
	,	echo=no
	)
/*	%put &=var_list_col;*/

/*	%let refr_var_call=%list_format(*/
/*		list=&var_list_col.*/
/*	,	sep=:*/
/*	,	new_sep=%str(,)*/
/*	);*/

	%let refr_var_call = &var_list_col.;

/*	%unquote(&refr_var_call.)*/
	%unquote(&refr_var_call.)
%mend rename_inq_vars;

* validation;
/*data _null_;*/
/*	str = "%rename_inq_vars(%quote(GO04,AT115,123,hahaha,bla-bla,1/(2*pi)*sqrt(GO04^2+GO07^2)),&inq_var_list.)";*/
/*	put str=;*/
/*run;*/