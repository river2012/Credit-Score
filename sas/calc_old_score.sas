

*------------------------------------------------ dividing into clusters and assigning score----------------------------------------------;
%macro calc_old_score(raw_file, scored_file);

	data &scored_file.;
		set &raw_file.;

	/*			if Loan_Funded_date<='31mar2011'd then 	segment="Pre-TU"; else*/
	/*			 if Loan_Sub_Counter=1 then 			segment="New   "; else*/
	/*			 										segment="Exist ";*/

		if segment="NEW" then 
		do;

		if AT01=.  then  sc_new_at01=-0.10281; else
		if AT01<=6 then  sc_new_at01= 0.22937; else
		if AT01<=12 then sc_new_at01=-0.01081; else
						 sc_new_at01=-0.33562;

		if AT71_chg__12mago=.  		then  sc_new_AT71_chg__12mago= 0.08928; else
		if AT71_chg__12mago<=252	then  sc_new_AT71_chg__12mago=-0.48266; else
						 				  sc_new_AT71_chg__12mago= 0.08928;

		if new_efsscore=.  then  	sc_new_efsscore=0.01408; else
		if new_efsscore<=765 then  	sc_new_efsscore=0.31519; else
		if new_efsscore<=889 then  	sc_new_efsscore=-0.17528; else
						 				sc_new_efsscore=-0.65906;


		if GO04_v2_chgp__12mago=.  then  			sc_new_GO04_v2_chgp__12mago=-0.00943; else
		if GO04_v2_chgp__12mago<=-0.154  then  	sc_new_GO04_v2_chgp__12mago=-0.57503; else
		if GO04_v2_chgp__12mago<=0.048  then  		sc_new_GO04_v2_chgp__12mago=-0.00943; else
		if GO04_v2_chgp__12mago<=0.3  then  		sc_new_GO04_v2_chgp__12mago=0.36680; else
												sc_new_GO04_v2_chgp__12mago=-0.32476;

		if GO116=.  then  			sc_new_GO116=0.06028; else
		if GO116<=1  then  			sc_new_GO116=-0.14916; else
		if GO116<=8  then  			sc_new_GO116=0.42313; else
									sc_new_GO116=0.06028;

		if GO127=.  then  			sc_new_GO127=-0.08658; else
		if GO127<=0  then  			sc_new_GO127=-0.02071; else
		if GO127<=1946  then  		sc_new_GO127=0.28011; else
									sc_new_GO127=-0.08332;

		if GO17_v2<=1  then  			sc_new_GO17=-0.06092; else
									sc_new_GO17=0.35441;

		if GO29_max_recency=.   then  	sc_new_GO29_max_recency=0.43720; else
		if GO29_max_recency<=0  then  	sc_new_GO29_max_recency=0.02468; else
										sc_new_GO29_max_recency=-0.10596;

		if IN33_chg__6mago=.   	then 	 	sc_new_IN33_chg__6mago=-0.00552; else
		if IN33_chg__6mago<=-651   then  	sc_new_IN33_chg__6mago=-0.13132; else
		if IN33_chg__6mago<=-366   then  	sc_new_IN33_chg__6mago=0.04140; else
		if IN33_chg__6mago<=823   then  	sc_new_IN33_chg__6mago=0.43945; else
											sc_new_IN33_chg__6mago=-0.00552;

		if Loan_LPPFlag=0   then  	sc_new_Loan_LPPFlag=-0.38998; else
									sc_new_Loan_LPPFlag=0.03111;

		if Loan_Pmt_Freq="semimonthly"   then  	sc_new_Loan_Pmt_Freq=-0.36726; else
												sc_new_Loan_Pmt_Freq=0.03683;

		if PR42=.   then  	sc_new_PR42=-0.07161; else
		if PR42<=0   then  	sc_new_PR42=-0.20347; else
		if PR42<=1   then  	sc_new_PR42=0.07560; else
		if PR42<=2   then  	sc_new_PR42=0.26586; else
							sc_new_PR42=0.45027;

		if _12m_pydown_chg=.      then  	sc_new_12m_pydown_chg=-0.00978; else
		if _12m_pydown_chg<=-0.603   then  	sc_new_12m_pydown_chg=-0.47952; else
		if _12m_pydown_chg<=-0.516   then  	sc_new_12m_pydown_chg=-0.23716; else
		if _12m_pydown_chg<=-0.361   then  	sc_new_12m_pydown_chg=0.33717; else
		if _12m_pydown_chg<=-0.208   then  	sc_new_12m_pydown_chg=0.53077; else
											sc_new_12m_pydown_chg=0.33095;

		if _3m_pydown_chg=.      then  			sc_new_3m_pydown_chg=-0.01937; else
		if _3m_pydown_chg<= -0.1424      then  	sc_new_3m_pydown_chg=-0.21730; else
		if _3m_pydown_chg<= -0.0729      then  	sc_new_3m_pydown_chg=-0.12656; else
		if _3m_pydown_chg<= -0.0291      then  	sc_new_3m_pydown_chg=0.03866; else
											  	sc_new_3m_pydown_chg=0.52893; 

		if cCreditInquiries_v2<=0      then  		sc_new_CreditInquiries=-0.21500; else
		if cCreditInquiries_v2<=2      then  		sc_new_CreditInquiries=-0.07052; else
		if cCreditInquiries_v2<=4      then  		sc_new_CreditInquiries=0.14258; else
												sc_new_CreditInquiries=0.36937;

		if cHomeMortgageOrRentAmount=.      then  		sc_new_HomeMortgageOrRentAmount=-0.20114; else
		if cHomeMortgageOrRentAmount<=349      then  		sc_new_HomeMortgageOrRentAmount=0.18281; else
		if cHomeMortgageOrRentAmount<=498      then  		sc_new_HomeMortgageOrRentAmount=-0.20114; else
		if cHomeMortgageOrRentAmount<=960      then  		sc_new_HomeMortgageOrRentAmount=0.07528; else
															sc_new_HomeMortgageOrRentAmount=-0.16740;

		if cResidenceLocation='NS'      then  				sc_new_cResidenceLocation=-0.23783; else
		if cResidenceLocation in ('NL','','NB','SK') then	sc_new_cResidenceLocation=-0.11527; else
															sc_new_cResidenceLocation=0.05810;

		if cs_life_num_min_pymnt<=0      then  			sc_new_cs_life_num_min_pymnt=-0.01414; else
														sc_new_cs_life_num_min_pymnt=0.46199;

		if cs_nsf_life_times<=0      then  			sc_new_cs_nsf_life_times=-0.36479; else
		if cs_nsf_life_times<=1      then  			sc_new_cs_nsf_life_times=0.10984; else
		if cs_nsf_life_times<=2      then  			sc_new_cs_nsf_life_times=0.51758; else
														sc_new_cs_nsf_life_times=0.84704;

		if cur_paydown<=0.356      then  			sc_new_cur_paydown=-0.67289; else
		if cur_paydown<=0.912      then  			sc_new_cur_paydown=-0.02970; else
													sc_new_cur_paydown=0.21520; 

		if cur_util_fi_chg__3mago=.     		 then  			sc_new_cur_util_fi_chg__3mago=-0.00509; else
		if cur_util_fi_chg__3mago<=-0.2336      then  			sc_new_cur_util_fi_chg__3mago=-0.17712; else
		if cur_util_fi_chg__3mago<=-0.1390      then  			sc_new_cur_util_fi_chg__3mago=-0.05988; else
																sc_new_cur_util_fi_chg__3mago=0.05465;

		if cur_util_rev_chg__6mago=.     			 then  			sc_new_cur_util_rev_chg__6mago=0.04223; else
		if cur_util_rev_chg__6mago<=-0.014     		 then  			sc_new_cur_util_rev_chg__6mago=-0.79749; else
		if cur_util_rev_chg__6mago<=0.002     		 then  			sc_new_cur_util_rev_chg__6mago=0.04223; else
		if cur_util_rev_chg__6mago<=0.213     		 then  			sc_new_cur_util_rev_chg__6mago=-0.38321; else
																	sc_new_cur_util_rev_chg__6mago=0.26348; 

		if recency_1_more=.     			 then  			sc_new_recency_1_more=-0.23253; else
		if recency_1_more<=0     			 then  			sc_new_recency_1_more=1.04614; else
		if recency_1_more<=4     			 then  			sc_new_recency_1_more=0.34798; else
															sc_new_recency_1_more=0.11707; 

		if recency_30_more=.     			 then  			sc_new_recency_30_more=-0.10252; else
		if recency_30_more<=0     			 then  			sc_new_recency_30_more=1.43181; else
															sc_new_recency_30_more=0.76328;

		sc_new=
		 sc_new_recency_30_more +
		 sc_new_recency_1_more+
		 sc_new_cur_util_rev_chg__6mago+
		 sc_new_cur_util_fi_chg__3mago+
		 sc_new_cur_paydown+
		 sc_new_cs_nsf_life_times+
		 sc_new_cs_life_num_min_pymnt+
		 sc_new_cResidenceLocation+
		 sc_new_HomeMortgageOrRentAmount+
		 sc_new_CreditInquiries+
		 sc_new_3m_pydown_chg+
		 sc_new_12m_pydown_chg+
		 sc_new_PR42+
		 sc_new_Loan_Pmt_Freq+
		 sc_new_IN33_chg__6mago+
		 sc_new_Loan_LPPFlag+
		 sc_new_GO29_max_recency+
		 sc_new_GO17+
		 sc_new_GO127+
		 sc_new_GO116+
		 sc_new_GO04_v2_chgp__12mago+
		 sc_new_efsscore+
		 sc_new_AT71_chg__12mago+
		 sc_new_at01+
		-1.6358
		;

		end;



		if segment="EXIST" then 
		do;

		if AT191_max_cur_chg=.  	then   sc_ex_AT191_max_cur_chg=-0.22159; else 
		if AT191_max_cur_chg<= -1.0  then   sc_ex_AT191_max_cur_chg=0.62823; else 
											sc_ex_AT191_max_cur_chg=-0.01492; 


		if AT22=.		 	then   sc_ex_AT22=0.21625; else 
		if AT22<= 2.0  		then   sc_ex_AT22=-0.03573; else 
								   sc_ex_AT22=0.23349; 


		if AT70=.  then  	 sc_ex_AT70=0.06215; else 
		if AT70<= 0  then   sc_ex_AT70=-0.01301; else 
							 sc_ex_AT70=0.26709; 


		if FI60_chgp__6mago=.  then   		sc_ex_FI60_chgp__6mago=0.09853; else 
		if FI60_chgp__6mago<= -0.001  then   sc_ex_FI60_chgp__6mago=0.15231; else 
		if FI60_chgp__6mago<= 0.352  then   sc_ex_FI60_chgp__6mago=0.01909; else 
		if FI60_chgp__6mago<= 0.9  then   sc_ex_FI60_chgp__6mago=0.09853; else 
		if FI60_chgp__6mago<= 1.163  then   sc_ex_FI60_chgp__6mago=-0.01979; else 
		if FI60_chgp__6mago<= 2.081  then   sc_ex_FI60_chgp__6mago=-0.10939; else 
											sc_ex_FI60_chgp__6mago=-0.03251;  



		if GO04_v2=.  then   sc_ex_GO04_v2=0.12944; else 
		if GO04_v2<= 6  then   sc_ex_GO04_v2=-0.23724; else 
		if GO04_v2<= 10  then   sc_ex_GO04_v2=-0.09090; else 
		if GO04_v2<= 17  then   sc_ex_GO04_v2=0.02311; else 
		if GO04_v2<= 22  then   sc_ex_GO04_v2=0.12944; else 
							 sc_ex_GO04_v2=0.26263;

		if GO127_std=.  then   sc_ex_GO127_std=0.22309; else 
		if GO127_std<=0  then   sc_ex_GO127_std=-0.04243; else 
		  						sc_ex_GO127_std=0.09734; 

		if GO132=.  then   sc_ex_GO132=0.05381; else 
		if GO132<= 7  then   sc_ex_GO132=0.14402; else 
		if GO132<=15  then   sc_ex_GO132=0.05381; else 
		if GO132<= 55  then   sc_ex_GO132=-0.04789; else 
		  						sc_ex_GO132=-0.13904;


		if GO28=.  then   sc_ex_GO28=0.01803; else 
		if GO28<= 0  then   sc_ex_GO28=0.17548; else 
		if GO28<=2  then   sc_ex_GO28=-0.03766; else 
		if GO28<= 14  then   sc_ex_GO28=0.08123; else 
		if GO28<= 22  then   sc_ex_GO28=0.01803; else 
							sc_ex_GO28=-0.03208; 

		if IN01<= 4  then   sc_ex_IN01=0.18491; else 
		if IN01<= 7  then   sc_ex_IN01=0.05334; else 
		if IN01<= 9  then   sc_ex_IN01=-0.12036; else 
		  sc_ex_IN01=-0.25412; 

		if Loan_Cust_Marital in ('Married','')  then   sc_ex_Loan_Cust_Marital=-0.11966; else 
		/*if Loan_Cust_Marital='Single'  then*/   sc_ex_Loan_Cust_Marital=0.07043; 

		if PR09=.  then   sc_ex_PR09=0.05607; else 
		if PR09<=0  then   sc_ex_PR09=-0.10902; else 
		if PR09<=1  then   sc_ex_PR09=-0.00658; else 
		if PR09<= 2  then   sc_ex_PR09=0.07697; else 
		if PR09<= 3  then   sc_ex_PR09=0.12756; else 
		  sc_ex_PR09=0.19199; 

		if PR42_chg__3mago=.  then   sc_ex_PR42_chg__3mago=-0.04617; else 
		if PR42_chg__3mago<= -1  then   sc_ex_PR42_chg__3mago=0.08802; else 
		if PR42_chg__3mago<=0 then   sc_ex_PR42_chg__3mago=-0.04617; else 
		  sc_ex_PR42_chg__3mago=0.20243; 


		if RE33_chgp__3mago=.  then   sc_ex_RE33_chgp__3mago=0.14235; else 
		if RE33_chgp__3mago<= -0.003  then   sc_ex_RE33_chgp__3mago=-0.33063; else 
		if RE33_chgp__3mago<=0  then   sc_ex_RE33_chgp__3mago=0.05202; else 
		if RE33_chgp__3mago<=0.007  then   sc_ex_RE33_chgp__3mago=-0.28058; else 
		if RE33_chgp__3mago<=0.278  then   sc_ex_RE33_chgp__3mago=0.02290; else 
		   sc_ex_RE33_chgp__3mago=-0.17747; 

		if RE66_std_3m<=0  then   sc_ex_RE66_std_3m=-0.01418; else 
		  sc_ex_RE66_std_3m=0.19494; 

		if RI_FrequencyofApps=.  then   sc_ex_RI_FrequencyofApps=-0.00893; else 
		if RI_FrequencyofApps<= 4.652  then   sc_ex_RI_FrequencyofApps=0.59038; else 
										   sc_ex_RI_FrequencyofApps=0.14652; 



		if _3m_bal_chgp=.  then   sc_ex__3m_bal_chgp=-0.16130; else 
		if _3m_bal_chgp<=-0.591  then   sc_ex__3m_bal_chgp=-0.15297; else 
		if _3m_bal_chgp<=-0.053  then   sc_ex__3m_bal_chgp=0.17003; else 
		if _3m_bal_chgp<=0.022  then   sc_ex__3m_bal_chgp=0.54324; else 
		if _3m_bal_chgp<=0.076  then   sc_ex__3m_bal_chgp=-0.06601; else 
		if _3m_bal_chgp<=0.126  then   sc_ex__3m_bal_chgp=-0.15955; else 
		if _3m_bal_chgp<=0.193  then   sc_ex__3m_bal_chgp=-0.18264; else 
									   sc_ex__3m_bal_chgp=-0.37782;

		if avg_mnth_between_loans<= 4.9  then   sc_ex_avg_mnth_between_loans=0.20451; else 
		if avg_mnth_between_loans<= 6  then   sc_ex_avg_mnth_between_loans=0.01604; else 
		  										sc_ex_avg_mnth_between_loans=-0.09190;  


		if cMonthlyNetIncome=.  then   sc_ex_cMonthlyNetIncome=-0.12178; else 
		if cMonthlyNetIncome<= 1457  then   sc_ex_cMonthlyNetIncome=0.21466; else 
		if cMonthlyNetIncome<= 2400  then   sc_ex_cMonthlyNetIncome=0.06358; else 
		if cMonthlyNetIncome<=3439  then   sc_ex_cMonthlyNetIncome=-0.01207; else 
		  									sc_ex_cMonthlyNetIncome=-0.12178;  


		if cs_12m_15_30_times<=0  then   sc_ex_cs_12m_15_30_times=-0.07650; else 
										  sc_ex_cs_12m_15_30_times=0.39122; 

		if cs_life_refi_rej_apps<=0  then   sc_ex_cs_life_refi_rej_apps=-0.01234; else 
		  sc_ex_cs_life_refi_rej_apps=0.42309; 


		if cs_nsf_12m_times=0  then   sc_ex_cs_nsf_12m_times=-0.39286; else 
		if cs_nsf_12m_times<=1  then   sc_ex_cs_nsf_12m_times=-0.07474; else 
		if cs_nsf_12m_times<=2  then   sc_ex_cs_nsf_12m_times=0.12111; else 
		if cs_nsf_12m_times<=4  then   sc_ex_cs_nsf_12m_times=0.32526; else 
		  sc_ex_cs_nsf_12m_times=0.56753; 

		if cur_util_fi_chg__3mago=. then   sc_ex_cur_util_fi_chg__3mago=0.01670; else 
		if cur_util_fi_chg__3mago<= -0.1358  then   sc_ex_cur_util_fi_chg__3mago=-0.18292; else 
		if cur_util_fi_chg__3mago<= -0.0955  then   sc_ex_cur_util_fi_chg__3mago=-0.05662; else 
		if cur_util_fi_chg__3mago<= -0.0583  then   sc_ex_cur_util_fi_chg__3mago=0.01670; else 
		if cur_util_fi_chg__3mago<= -0.0406  then   sc_ex_cur_util_fi_chg__3mago=-0.08591; else 
		if cur_util_fi_chg__3mago<= -0.0193  then   sc_ex_cur_util_fi_chg__3mago=0.08103; else 
		if cur_util_fi_chg__3mago<= 0.0131  then   sc_ex_cur_util_fi_chg__3mago=0.20923; else 
		if cur_util_fi_chg__3mago<=0.0957  then   sc_ex_cur_util_fi_chg__3mago=0.10986; else 
		   sc_ex_cur_util_fi_chg__3mago=-0.03809; 

		if max_dpd_mnth_3m<=4  then   sc_ex_max_dpd_mnth_3m=-0.05102; else 
		   sc_ex_max_dpd_mnth_3m=0.59425;
		 
		if max_sub<= 3  then   sc_ex_max_sub=0.06777; else 
		  sc_ex_max_sub=-0.14603; 


		if max_util_fin_inst=.  then   sc_ex_max_util_fin_inst=0.08028; else 
		if max_util_fin_inst<= 0.805  then   sc_ex_max_util_fin_inst=-0.11364; else 
		if max_util_fin_inst<= 0.982  then   sc_ex_max_util_fin_inst=-0.03539; else 
		if max_util_fin_inst<= 1  then   sc_ex_max_util_fin_inst=0.08028; else 
									   sc_ex_max_util_fin_inst=0.38883; 

		if recency_45_more=.  then   sc_ex_recency_45_more=-0.17432; else 
		if recency_45_more=0  then   sc_ex_recency_45_more=2.00880; else 
		if recency_45_more<=3  then   sc_ex_recency_45_more=1.12580; else 
		if recency_45_more<=5  then   sc_ex_recency_45_more=0.88678; else 
		  							 sc_ex_recency_45_more=0.44986;  

		if tu_risk_2009_sc_chg__6mago=.  then   sc_ex_risk_2009_score_chg__6mago=0.09771; else 
		if tu_risk_2009_sc_chg__6mago<= -84  then   sc_ex_risk_2009_score_chg__6mago=0.17481; else 
		if tu_risk_2009_sc_chg__6mago<=-19  then   sc_ex_risk_2009_score_chg__6mago=0.09771; else 
		if tu_risk_2009_sc_chg__6mago<= -6  then   sc_ex_risk_2009_score_chg__6mago=-0.00070; else 
		   											sc_ex_risk_2009_score_chg__6mago=-0.09756;

		sc_ex=
		sc_ex_risk_2009_score_chg__6mago+
		sc_ex_recency_45_more+
		sc_ex_max_util_fin_inst+
		sc_ex_max_sub+
		sc_ex_max_dpd_mnth_3m+
		sc_ex_cur_util_fi_chg__3mago+
		sc_ex_cs_nsf_12m_times+
		sc_ex_cs_life_refi_rej_apps+
		sc_ex_cs_12m_15_30_times+
		sc_ex_cMonthlyNetIncome+
		sc_ex_avg_mnth_between_loans+
		sc_ex__3m_bal_chgp+
		sc_ex_RI_FrequencyofApps+
		sc_ex_RE66_std_3m+
		sc_ex_AT191_max_cur_chg+
		sc_ex_AT22+
		sc_ex_AT70+
		sc_ex_FI60_chgp__6mago+
		sc_ex_GO04_v2+
		sc_ex_GO127_std+
		sc_ex_GO132+
		sc_ex_GO28+
		 sc_ex_IN01+
		sc_ex_Loan_Cust_Marital+
		sc_ex_PR09+
		sc_ex_PR42_chg__3mago+
		sc_ex_RE33_chgp__3mago+
		-1.6704
		; 
		end;
		if segment="EXIST"  then b_score=-1*round(sc_ex*70)+470   ; else b_score=-1*round(sc_new*70)+470  ;
		if segment="EXIST"  then b_score_log=sc_ex   ; else b_score_log=sc_new  ;
		*score bands;
		array score_bands[21] _TEMPORARY_/*(0 419 491 529 555 575 589 603 614 624 634 643 651 660 668 677 686 698 711 733 926)*/
		(0 413 489 530 555 574 589 601 612 622 632 641 650 658 667 676 686 697 711 734 1009); 
		length b_score_group $ 10;
		if b_score=. then 
			b_score_group='';
		else if b_score < score_bands[1] then 
			b_score_group = cats('<',score_bands[1]);
		else if b_score>=score_bands[dim(score_bands)] then 
			b_score_group = cats(score_bands[dim(score_bands)],"+");
		else
			do i=1 to dim(score_bands)-1;
				if (b_score>=score_bands[i] and b_score<score_bands[i+1]) then
					b_score_group=cats(score_bands[i],"-",score_bands[i+1]-1);
			end;

		*risk groups;
		array risk_bands[6] _TEMPORARY_ /*(0 529 589 614 668 711)*/
												(0 530 589 632 667 711);
		length RiskGroup $ 12;

		if b_score=. then 
			RiskGroup = '';
		else if b_score < risk_bands[1] then
			RiskGroup = cats("Risk Group-",dim(risk_bands)+1);
		else
			do i=1 to dim(risk_bands);
				if (b_score>=risk_bands[i]) then do;
					RiskGroup = cats("Risk Group-",dim(risk_bands)-i+1);
				end;
			end;

		length b_risk_group $ 12;
		b_risk_group = translate(RiskGroup,' ','-');


		predict = 1/(1+exp(-b_score_log));

		drop i;

	run; %errchk;

%mend calc_old_score;
