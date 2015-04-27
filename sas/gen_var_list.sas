%echo(**** Generating list of binned variables ****);
proc sql noprint;
	select distinct
		binning.var
	into 
		:var_list separated by " "

	from binning

;
quit; %errchk;