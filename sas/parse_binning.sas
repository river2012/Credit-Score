%echo(**** Parsing SPSS output ****);

%echo(Parsing SQL code);
data binning_expr;
	infile csv_in("&bin_file_name.") dlm=',' dsd truncover;
	retain varno 0 node;
	length var $ 50 expr_sql $ 1000 expr_sql_nonull $ 1000 expr_sas $ 1000 grp_sql $ 1000;
	informat line $1000.;
	input line $;
	* Parsing Node number;
	if substr(line,1,7) = '/* Node' then do;
		node = input(scan(substr(line,lengthc('/* Node '),length(line)-lengthc('/* Node ')+1),1),10.);
		if node=1 then varno+1;
	end;
	* Extracting SQL expression;
	if substr(line,1,5) = 'WHERE' then do;
		* Excluding 'WHERE';
		expr_sql = compress(tranwrd(substr(line,lengthc('WHERE (')+1,length(line)-(lengthc('WHERE (')+1)+1),');',''),'@');
		* Extracting variable name;
		var = scan(compress(tranwrd(expr_sql,'NOT',''),'('),1);
		* Deleting 'IS NULL' expressions if <blank> is present for character variable;
		if find(expr_sql,"''") then
			expr_sql_nonull =
				transtrn(
					transtrn(
						transtrn(
							transtrn(
								transtrn(
									expr_sql
									, trim(var)||' IS NULL'
									, trimn('')
								)
								, 'NOT() OR '
								, trimn('')
							)
							, 'NOT() AND '
							, trimn('')
						)
						, '() OR'
						, trimn('')
					)
					, '() AND'
					, trimn('')
				)
			;
		else
			expr_sql_nonull = expr_sql;

		* Changing SQL sytax to SAS;
		expr_sas = 
			tranwrd(
				tranwrd(
					expr_sql_nonull
					,trim(var)||' IS NULL'
					,'missing('||trim(var)||')'
				)
				,'<>'
				,'^='
			)
		;
		* Generating group name from SQL expression;
		grp_sql = put(node,z2.)||'. '||transtrn(transtrn(transtrn(expr_sql,trim(var)||' = ',trimn('')),trim(var)||' ',trimn('')),"''","<blank>");
		
		output;
	end;
run; %errchk;

%echo(Parsing group names);
data binning_grp;
	infile csv_in("&bin_file_name.") dlm=',' dsd truncover;
	retain varno 0 out_flag 0 node;
	length var $ 50 split_val $ 1000 grp $ 1000;
	informat p_tot p1 p0 percent8.3;
	input node n0 p0 n1 p1 n_tot p_tot pred par_node var $ sig_a chisq df split_val $;

	var = compress(var,'@');
	if lag2(split_val) = 'Split Values' then do;
		varno + 1;
		out_flag = 1;
	end; else;
	if missing(node) then do;
		out_flag = 0;
	end;

	if out_flag then do;
		grp = put(node,z2.)||'. '||split_val;
		output;
	end;
	
	keep varno node var split_val grp p1 p_tot n0 n1;
run; %errchk;

%echo(Combining parsed data);
proc sql;
	create table binning
	as select
		binning_expr.varno
	,	binning_expr.var as var
	,	binning_expr.node
	,	binning_expr.expr_sql
	,	binning_expr.expr_sas
	,	binning_expr.grp_sql
	,	binning_grp.split_val
	,	binning_grp.grp
	,	binning_grp.p_tot as p_tot
	,	binning_grp.p1 as pd
	,	binning_grp.n0 as n_good
	,	binning_grp.n1 as n_bad

	from binning_expr
	
	left join binning_grp
		on  binning_expr.var = binning_grp.var
			and binning_expr.node = binning_grp.node

	order by
		binning_expr.varno
	,	binning_expr.node
;
quit; %errchk;

%echo(Searching for empty groups);
proc sql noprint;
	select
		count(*)>0 as err_empty_grp
	into :err_empty_grp
	from binning
	where missing(binning.grp)
;
quit; %errchk;

%put &=err_empty_grp;
%echo(Checking if there are empty groups);
%errchk(err_var=&err_empty_grp.);
%echo(OK);


%echo(Searching for duplicate variables);
proc sql noprint;
	select
		count(*)>0 as err_dup_var
	into :err_dup_var
	from (select var from binning group by var, node having count(*)>1) as dup_vars
;
quit; %errchk;

%put &=err_dup_var;
%echo(Checking if there are duplicate variables);
%errchk(err_var=&err_dup_var.);
%echo(OK);