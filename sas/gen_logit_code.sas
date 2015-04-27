%macro gen_logit_code(logit_ds=var_grp_logit,calc_score_auto_filename=calc_score.sas,macro_name=calc_score,logit_var_template=###_logit,score_transf=-1*round(###*70)+470);
	%echo(**** Generating code for grouping ****);
	data _null_;
		file &calc_score_auto_filename.;
		set &logit_ds. end=end_flag;
		by varno node;
		where ^missing(logit);
		length logit_formula $ 10000 logit_var_name $ 60;
		retain logit_formula '' logit_var_name '';
		if _n_ = 1 then do;
			put '%macro ' "&macro_name." '(raw_file_name,scored_file_name);';
			put 'data &scored_file_name.;';
			put '	set &raw_file_name.;';
		end;

		if first.varno then do;
			put '	';
			put '	* Logit for ' var +(-1)';';
			logit_var_name = tranwrd("&logit_var_template.",'###',tranwrd(trimn(var),'__','_'));
			logit_formula = trimn(logit_formula)||'0909'x||'0A'x||'+'||trimn(logit_var_name);
		end;

		if ^missing(expr_sas) then
			put '	if ' expr_sas 'then do;';
		put '		' logit_var_name '= ' logit +(-1) ';';
		if ^missing(expr_sas) then
			put '	end;';

		if end_flag then do;
			logit_total_name = tranwrd("&logit_var_template.",'###',trimn('Total'));
			put '	';
			put '	* Total logit;';
			put '	' logit_total_name '=' logit_formula +(-1) ';';
			put '	';
			put '	' 'b_score_logit = ' logit_total_name +(-1) ';';
			put '	';
			put '	* Score;';
			score_transf_formula = tranwrd("&score_transf.",'###','b_score_logit');
			put '	' 'b_score = ' score_transf_formula +(-1) ';';
			put '	';
			put '	* PD;';
			put '	' 'prob_def = 1/(1+exp(-b_score_logit));';
			put '	';
			put '	* Risk Group;';
			put '	' 'length b_risk_group $ 12;';
			put '	' 'if missing(b_score) then b_risk_group = "";';
			put '	' 'else if b_score <=557 then b_risk_group = "Risk Group 6";';
			put '	' 'else if b_score <=595 then b_risk_group = "Risk Group 5";';
			put '	' 'else if b_score <=634 then b_risk_group = "Risk Group 4";';
			put '	' 'else if b_score <=658 then b_risk_group = "Risk Group 3";';
			put '	' 'else if b_score <=697 then b_risk_group = "Risk Group 2";';
			put '	' 'else b_risk_group = "Risk Group 1";';
			put '	';
			put 'run; %errchk;';
			put '%mend ' "&macro_name." ';';
		end;
	run; %errchk;
%mend gen_logit_code;