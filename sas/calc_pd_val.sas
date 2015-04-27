%macro calc_pd_val(val_ds=,reg_coef=reg_coef, logit_out=logit_out);
	data _null_;
		length logit_eqn predict_eqn $10000;
		retain logit_eqn '';
		set &reg_coef. end=eof;	
		if variable = 'Intercept' then variable='1';
		logit_eqn = trimn(logit_eqn)||'+'||estimate||'*'||trimn(variable);
		if eof then do;
			logit_eqn = tranwrd(logit_eqn,'+-','-');
			predict_eqn = '1/(1+exp(-('||trimn(logit_eqn)||')))';
			call symput('logit_eqn',logit_eqn);
			call symput('predict_eqn',predict_eqn);
		end;
	run; %errchk;

	%put &=logit_eqn.; 
	%put &=predict_eqn.;

	data &logit_out.;
	  set &val_ds.;
	  logit = &logit_eqn.;
	  predict = &predict_eqn.;
	run; %errchk;
%mend calc_pd_val;
