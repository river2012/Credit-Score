%let working_path=\\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program;

%let routine_path=&working_path.\sas;
%let csv_in_path=&working_path.\csv_in;

%let save_path=&working_path.\saved_datasets;

filename routines "&routine_path.";
filename csv_in "&csv_in_path.";

libname save "&save_path.";

*filename snippets 'C:\Work\Misc\Snippets';

%include snippets(errchk);
%include snippets(echo);
%include snippets(list_loop);
%include snippets(list_format);

%let start_mon = 201212;
%let end_mon = 201311;

%put &=start_mon. &=end_mon.;

****** BUILDING MODELING DATASET ******;

* list of inquiry variables (subject to change);
%include routines(gen_inq_var_list);

* macro for renaming inquiry variables;
%include routines(rename_inq_vars);

* list of score timestamps;
%include routines(gen_dm_list);

* macro for calculating raw varables;
%include routines(calc_raw_vars);

* calculating raw variables;
%list_loop(
	list=%gen_dm_list(
			start_mon=&start_mon.
		,	end_mon=&end_mon.
		)
,	run=%nrstr(
			%calc_raw_vars(
				score_date = %sysfunc(putn(%sysfunc(inputn(&cur_list_item.,yymmdd8.)),date9.))
			,	outfile_raw = save.raw_%substr(&cur_list_item.,1,6)
			,	outfile_perf = save.perf_%substr(&cur_list_item.,1,6)
			,	refr_attached = yes
			,	inq_var_list = &inq_var_list.
			);
		)
);

* combining raw variables and performance in one modeling dataset;
%include routines(comb_raw_perf);

******* RAW CALCULATION FINISHED *******;
