%macro calc_grp(ungrouped_file_name,grouped_file_name,calc_grp_auto_filename=);
	%echo(**** Calculating group variables ****);
	%include &calc_grp_auto_filename.;
%mend calc_grp;

