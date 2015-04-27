%echo(**** Generating code for grouping ****);
data _null_;
	file &calc_grp_auto_filename.;
	set binning nobs=nobs;
	if _n_ = 1 then do;
		put 'data &grouped_file_name.;';
		put '	set &ungrouped_file_name.;';
	end;

	if var ^= lag(var) then do;
		put '	';
		put '	* Grouping ' var +(-1)';';
		put '	length ' var +(-1) '_grp' ' $ 1000;';
	end;
	
	put '	if ' expr_sas 'then do;';
	put '		' var +(-1) '_grp = "' grp +(-1) '";';
	put '		' var +(-1) '_gno = ' node +(-1) ';';
	put '	end;';

	if _n_ = nobs then do;
		put 'run; %errchk;';
	end;
run; %errchk;