%macro calc_old_old_score(raw_file, scored_file, b_score_file=efs_data.b_score_combined);

	proc sql;
		create table &scored_file.
		as select
			raw_file.*
		,	old_old_score.b_score
		,	old_old_score.b_risk_group
		from &raw_file. as raw_file
		left join b_score_combined as old_old_score
			on  raw_file.cohort_date = old_old_score.cohort_date
				and raw_file.loan_cust_num = old_old_score.loan_cust_num
	;
	quit; %errchk;

%mend calc_old_old_score;