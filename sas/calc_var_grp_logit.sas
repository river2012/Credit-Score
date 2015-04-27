%macro calc_var_grp_logit(data_dev=,data_binning=binning,data_reg_coef=,target_var=,var_list=,out_logit=var_grp_logit);

%local tot_n_bad tot_n_good;

proc sql noprint;
	select
		sum(tot.&target_var.) as n_bad
	,	sum(sum(1,-tot.&target_var.)) as n_good

	into :tot_n_bad
	,	:tot_n_good

	from &data_dev. as tot
;
quit; %errchk;

data var_grp_woe(index=(var_grp=(var node)));
	set &data_binning.;
	n_good_bin = n_good;
	n_bad_bin = n_bad;
	woe_bin = ifn(
				n_bad = 0
			,	1
			,	log( 
					(n_good_bin/&tot_n_good.)
					/ (n_bad_bin/&tot_n_bad.) 
				)
		);
	n_good = .;
	n_bad = .;
	woe = .;
run; %errchk;

%list_loop(
	list=&var_list.
,	run=%nrstr(
		%let current_var = &cur_list_item.;
		%echo(Variable: &current_var.);

		proc sql;
			create table __grp_woe__
			as select
				"&current_var." as var
			,	data.&current_var._gno as node
			,	sum(data.&target_var.) as n_bad
			,	sum(sum(1,-data.&target_var.)) as n_good
			,	ifn(
					calculated n_bad=0
					,1
					,log( 
						(calculated n_good/&tot_n_good.)
						/ (calculated n_bad/&tot_n_bad.) 
					)
				) as woe
			from &data_dev. as data

			group by
				data.&current_var._gno

			order by
				calculated var
			,	data.&current_var._gno
		;
		quit; %errchk;

		data var_grp_woe;
			modify var_grp_woe __grp_woe__;
			by var node;
		run; %errchk;
	)
);

proc sql;
	create table woe_noneq
	as select
		*
	from var_grp_woe
	
	where woe ^= woe_bin
;
quit; %errchk;

/*%let out_logit=var_grp_logit;*/

proc sql;
	create table &out_logit.
	as select
		coalescec(var_grp_woe.var,reg_coef.variable) as var
	,	var_grp_woe.*
	,	ifn(calculated var='Intercept',reg_coef.estimate,reg_coef.estimate * var_grp_woe.woe) as logit

	from var_grp_woe

	full join &data_reg_coef. as reg_coef
		on  trim(var_grp_woe.var)||'_woe' = reg_coef.variable
	
	order by
		var_grp_woe.varno
	,	var_grp_woe.node
;
quit; %errchk;

%mend calc_var_grp_logit;