
proc sql;
	create table __grp_woe__
	as select
		data.&var._grp
	,	sum(data.&target_var.) as n_bad
	,	sum(sum(1,-data.&target_var.)) as n_good
	,	ifn(
			calculated n_bad=0
			,1
			,log( 
				(calculated n_good/total.n_good) 
				/ (calculated n_bad/total.n_bad) 
			)
		) as &var._woe
	from &data_dev. as data

	cross join (
		select
			sum(tot.&target_var.) as n_bad
		,	sum(sum(1,-tot.&target_var.)) as n_good
		from &data_dev. as tot
	) as total

	group by
		data.&var._grp

	order by
		data.&var._grp
;
quit; %errchk;

proc sql;
	create table __data_woe__
	as select
		/* replacing blanks with commas */
		%list_format(&id_var.,new_sep=%str(,),pref=data.)
	,	__grp_woe__.&var._woe

	from &data. as data

	left join __grp_woe__
		on data.&var._grp = __grp_woe__.&var._grp

	order by
		%list_format(&id_var.,new_sep=%str(,),pref=data.)

;
quit; %errchk;

data &data_woe.(sortedby=&id_var.);
	merge &data_woe. __data_woe__;
	by &id_var.;
run; %errchk;