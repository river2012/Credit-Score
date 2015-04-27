%macro calc_woe_onevar(data,data_dev=&data.,data_woe=&data._woe,id_var=,target_var=,var=);
	%echo(Variable: &var.);
	%include routines(calc_woe_onevar);
%mend calc_woe_onevar;

%macro calc_woe(data,data_dev=&data.,data_woe=&data._woe,id_var=,target_var=,var_list=);
	%echo(**** Calculating WOE ****);

	%echo(Initializing WOE file);
	data &data_woe.;
		set &data.(keep=&id_var. &target_var. %list_format(&var_list.,suff=_grp) );
	run; %errchk;

	proc datasets lib=work noprint;
		modify &data_woe.;
		index create id_ind=(&id_var.);
	quit; %errchk;

	data &data_woe.(sortedby=&id_var.);
		set &data_woe.;
		by &id_var.;
	run; %errchk;

/*	%echo(Sorting by id variables);*/
/*	proc sort data=&data_woe.;*/
/*		by &id_var.;*/
/*	run;*/
	
	%echo(Calculating WOE for all grouped variables);
	%list_loop(
			list=&var_list.
		,	run=%nrstr(
					%calc_woe_onevar(data=&data.,data_dev=&data_dev.,data_woe=&data_woe.,id_var=&id_var.,target_var=&target_var.,var=&cur_list_item.);
				)
	);
%mend calc_woe;

