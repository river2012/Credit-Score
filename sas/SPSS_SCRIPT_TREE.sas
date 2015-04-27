**** INPUT ****;
* path with sas modeling dataset;
%let model_ds_path = \\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program\saved_datasets;
* Modeling dataset name;
%let ds_name = dev_exist;
* Target variable;
%let targer_var = bad_cs_acct;
* Dummy variable;
%let dummy_var = existing_efs_cs;

* Output path for the script;
%let script_path = \\10.17.192.40\Risk_Data\~Projects\2014-12 Behavior Score Development (Automated)\SAS Program\spss_script;
* Script name;
%let script_name = spss_script_auto;

***** PROGRAM ******;

libname mod_ds "&model_ds_path.";

proc sql;
	create table varnames
	as select
		*
	from dictionary.columns
	where 
		libname='MOD_DS'
		and memname = "%upcase(&ds_name.)"
		and name not in ("&targer_var.","&dummy_var.")
;
quit;

data _null_;
	set varnames;
	file "&script_path.\&script_name..sps";
	if _n_=1 then do;
		put "GET";
		put "	SAS DATA='&model_ds_path.\&ds_name..sas7bdat'.";
	end;
	put;
	length name_pref $1;
	name_pref = ifc(substr(name,1,1)='_','@','');
	put "* Decision Tree for" name +(-1)".";
	put "TREE &targer_var. [n] BY &dummy_var. [n]" name_pref +(-1) name "FORCE=" name_pref +(-1) name;
	put "/TREE DISPLAY=TOPDOWN NODES=STATISTICS BRANCHSTATISTICS=YES NODEDEFS=YES SCALE=AUTO";
	put "/DEPCATEGORIES USEVALUES=[VALID]";
	put "/PRINT MODELSUMMARY CLASSIFICATION RISK TREETABLE";
	put "/RULES NODES=TERMINAL SYNTAX=SQL TYPE=SCORING";
	put "/METHOD TYPE=CHAID";
	put "/GROWTHLIMIT MAXDEPTH=1 MINPARENTSIZE=400 MINCHILDSIZE=200";
	put "/VALIDATION TYPE=NONE OUTPUT=BOTHSAMPLES";
	put "/CHAID ALPHASPLIT=0.05 ALPHAMERGE=0.05 SPLITMERGED=NO CHISQUARE=PEARSON CONVERGE=0.001 MAXITERATIONS=100 ADJUST=BONFERRONI INTERVALS=10";
	put "/COSTS EQUAL";
	put "/MISSING NOMINALMISSING=MISSING.";
run;

