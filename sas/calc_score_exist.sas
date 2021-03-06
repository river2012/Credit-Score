%macro calc_score_exist(raw_file_name,scored_file_name);
data &scored_file_name.;
	set &raw_file_name.;
	
	* Logit for Intercept;
		sc_ex_Intercept = -1.784749399;
	
	* Logit for cs_nsf_12m_times;
	if (missing(cs_nsf_12m_times)) OR (cs_nsf_12m_times <= 0) then do;
		sc_ex_cs_nsf_12m_times = -0.170340769;
	end;
	if NOT(missing(cs_nsf_12m_times))  AND  (cs_nsf_12m_times > 0  AND  cs_nsf_12m_times <= 1) then do;
		sc_ex_cs_nsf_12m_times = -0.022607875;
	end;
	if NOT(missing(cs_nsf_12m_times))  AND  (cs_nsf_12m_times > 1  AND  cs_nsf_12m_times <= 2) then do;
		sc_ex_cs_nsf_12m_times = 0.106315857;
	end;
	if NOT(missing(cs_nsf_12m_times))  AND  (cs_nsf_12m_times > 2  AND  cs_nsf_12m_times <= 3) then do;
		sc_ex_cs_nsf_12m_times = 0.1794814331;
	end;
	if NOT(missing(cs_nsf_12m_times))  AND  (cs_nsf_12m_times > 3  AND  cs_nsf_12m_times <= 5) then do;
		sc_ex_cs_nsf_12m_times = 0.2417122977;
	end;
	if NOT(missing(cs_nsf_12m_times))  AND  (cs_nsf_12m_times > 5) then do;
		sc_ex_cs_nsf_12m_times = 0.3206838664;
	end;
	
	* Logit for New_EFSScore;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore <= 577) then do;
		sc_ex_New_EFSScore = 0.0705835944;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 577  AND  New_EFSScore <= 641) then do;
		sc_ex_New_EFSScore = 0.0528676089;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 641  AND  New_EFSScore <= 679) then do;
		sc_ex_New_EFSScore = 0.0415136982;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 679  AND  New_EFSScore <= 732) then do;
		sc_ex_New_EFSScore = 0.0289244209;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 732  AND  New_EFSScore <= 771) then do;
		sc_ex_New_EFSScore = 0.0177700038;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 771  AND  New_EFSScore <= 802) then do;
		sc_ex_New_EFSScore = 0.0099000297;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 802  AND  New_EFSScore <= 841) then do;
		sc_ex_New_EFSScore = -0.0033967;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 841  AND  New_EFSScore <= 853) then do;
		sc_ex_New_EFSScore = -0.012171109;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 853  AND  New_EFSScore <= 890) then do;
		sc_ex_New_EFSScore = -0.020508088;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 890  AND  New_EFSScore <= 903) then do;
		sc_ex_New_EFSScore = -0.034827531;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 903  AND  New_EFSScore <= 934) then do;
		sc_ex_New_EFSScore = -0.04802658;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 934) then do;
		sc_ex_New_EFSScore = -0.084077256;
	end;
	if missing(New_EFSScore) then do;
		sc_ex_New_EFSScore = -0.030228962;
	end;
	
	* Logit for AT22;
	if NOT(missing(AT22))  AND  (AT22 <= 0) then do;
		sc_ex_AT22 = -0.216533697;
	end;
	if (missing(AT22)) OR (AT22 > 0  AND  AT22 <= 1) then do;
		sc_ex_AT22 = -0.085432658;
	end;
	if NOT(missing(AT22))  AND  (AT22 > 1  AND  AT22 <= 2) then do;
		sc_ex_AT22 = 0.1018667891;
	end;
	if NOT(missing(AT22))  AND  (AT22 > 2  AND  AT22 <= 3) then do;
		sc_ex_AT22 = 0.1960126853;
	end;
	if NOT(missing(AT22))  AND  (AT22 > 3) then do;
		sc_ex_AT22 = 0.4870324362;
	end;
	
	* Logit for AT28;
	if NOT(missing(AT28))  AND  (AT28 <= 2633) then do;
		sc_ex_AT28 = 0.1409820568;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 2633  AND  AT28 <= 4227) then do;
		sc_ex_AT28 = 0.080888423;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 4227  AND  AT28 <= 4975) then do;
		sc_ex_AT28 = 0.0448755229;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 4975  AND  AT28 <= 10033) then do;
		sc_ex_AT28 = -0.052202025;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 10033  AND  AT28 <= 13329) then do;
		sc_ex_AT28 = 0.0227423472;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 13329  AND  AT28 <= 16444) then do;
		sc_ex_AT28 = 0.0567811458;
	end;
	if (missing(AT28)) OR (AT28 > 16444  AND  AT28 <= 22934) then do;
		sc_ex_AT28 = 0.0203681889;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 22934  AND  AT28 <= 44396) then do;
		sc_ex_AT28 = -0.062971361;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 44396  AND  AT28 <= 57002) then do;
		sc_ex_AT28 = -0.14459527;
	end;
	if NOT(missing(AT28))  AND  (AT28 > 57002) then do;
		sc_ex_AT28 = -0.260105263;
	end;
	
	* Logit for GO04_v2;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 <= 4) then do;
		sc_ex_GO04_v2 = -0.044386366;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 4  AND  GO04_v2 <= 7) then do;
		sc_ex_GO04_v2 = -0.09744559;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 7  AND  GO04_v2 <= 9) then do;
		sc_ex_GO04_v2 = -0.053374902;
	end;
	if (missing(GO04_v2)) OR (GO04_v2 > 9  AND  GO04_v2 <= 13) then do;
		sc_ex_GO04_v2 = -0.003179646;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 13  AND  GO04_v2 <= 14) then do;
		sc_ex_GO04_v2 = 0.0521256699;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 14  AND  GO04_v2 <= 23) then do;
		sc_ex_GO04_v2 = 0.1108987766;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 23) then do;
		sc_ex_GO04_v2 = 0.1752148851;
	end;
	
	* Logit for GO132;
	if NOT(missing(GO132))  AND  (GO132 <= 5) then do;
		sc_ex_GO132 = 0.1130624814;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 5  AND  GO132 <= 9) then do;
		sc_ex_GO132 = 0.0888868374;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 9  AND  GO132 <= 19) then do;
		sc_ex_GO132 = 0.0377064219;
	end;
	if (missing(GO132)) OR (GO132 > 19  AND  GO132 <= 30) then do;
		sc_ex_GO132 = -0.011605381;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 30  AND  GO132 <= 52) then do;
		sc_ex_GO132 = -0.064482202;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 52  AND  GO132 <= 77) then do;
		sc_ex_GO132 = -0.092101776;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 77  AND  GO132 <= 141) then do;
		sc_ex_GO132 = -0.118269226;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 141) then do;
		sc_ex_GO132 = -0.164435012;
	end;
	
	* Logit for GO17_v2;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 <= 0) then do;
		sc_ex_GO17_v2 = -0.032311123;
	end;
	if (missing(GO17_v2)) OR (GO17_v2 > 0  AND  GO17_v2 <= 1) then do;
		sc_ex_GO17_v2 = 6.8188938E-6;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 1  AND  GO17_v2 <= 2) then do;
		sc_ex_GO17_v2 = 0.0574448577;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 2) then do;
		sc_ex_GO17_v2 = 0.1238237376;
	end;
	
	* Logit for PR42;
	if NOT(missing(PR42))  AND  (PR42 <= 0) then do;
		sc_ex_PR42 = -0.118627848;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 0  AND  PR42 <= 1) then do;
		sc_ex_PR42 = 0.0563635722;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 1  AND  PR42 <= 2) then do;
		sc_ex_PR42 = 0.1136589502;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 2  AND  PR42 <= 3) then do;
		sc_ex_PR42 = 0.1900767699;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 3) then do;
		sc_ex_PR42 = 0.2584485773;
	end;
	if missing(PR42) then do;
		sc_ex_PR42 = -0.003295347;
	end;
	
	* Logit for Loan_Pmt_Freq;
	if Loan_Pmt_Freq = 'monthly' then do;
		sc_ex_Loan_Pmt_Freq = 0.2148175304;
	end;
	if (missing(Loan_Pmt_Freq)) OR Loan_Pmt_Freq ^= 'monthly' then do;
		sc_ex_Loan_Pmt_Freq = -0.071355568;
	end;
	
	* Logit for tu_risk_2009_score_v2;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 <= 459) then do;
		sc_ex_tu_risk_2009_score_v2 = 0.0968847196;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 459  AND  tu_risk_2009_score_v2 <= 472) then do;
		sc_ex_tu_risk_2009_score_v2 = 0.0665003181;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 472  AND  tu_risk_2009_score_v2 <= 493) then do;
		sc_ex_tu_risk_2009_score_v2 = 0.0427861899;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 493  AND  tu_risk_2009_score_v2 <= 508) then do;
		sc_ex_tu_risk_2009_score_v2 = 0.0247112649;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 508  AND  tu_risk_2009_score_v2 <= 540) then do;
		sc_ex_tu_risk_2009_score_v2 = 0.0009885048;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 540  AND  tu_risk_2009_score_v2 <= 554) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.016267501;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 554  AND  tu_risk_2009_score_v2 <= 630) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.03878542;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 630  AND  tu_risk_2009_score_v2 <= 643) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.05526852;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 643  AND  tu_risk_2009_score_v2 <= 653) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.072923351;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 653  AND  tu_risk_2009_score_v2 <= 670) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.09857477;
	end;
	if NOT(missing(tu_risk_2009_score_v2))  AND  (tu_risk_2009_score_v2 > 670) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.115885149;
	end;
	if missing(tu_risk_2009_score_v2) then do;
		sc_ex_tu_risk_2009_score_v2 = -0.004067532;
	end;
	
	* Logit for cur_paydown;
	if NOT(missing(cur_paydown))  AND  (cur_paydown <= 0.3615111111111111) then do;
		sc_ex_cur_paydown = -0.080028431;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.3615111111111111  AND  cur_paydown <= 0.5560193548387097) then do;
		sc_ex_cur_paydown = -0.047961705;
	end;
	if (missing(cur_paydown)) OR (cur_paydown > 0.5560193548387097  AND  cur_paydown <= 0.8927705882352941) then do;
		sc_ex_cur_paydown = -0.024129614;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.8927705882352941  AND  cur_paydown <= 0.9462474523438437) then do;
		sc_ex_cur_paydown = -0.007317393;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.9462474523438437  AND  cur_paydown <= 0.9780760330578512) then do;
		sc_ex_cur_paydown = 0.0195881191;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.9780760330578512  AND  cur_paydown <= 0.9892666088721613) then do;
		sc_ex_cur_paydown = 0.0317061876;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.9892666088721613) then do;
		sc_ex_cur_paydown = 0.0850743815;
	end;
	
	* Logit for recency_1_more;
	if NOT(missing(recency_1_more))  AND  (recency_1_more <= 0) then do;
		sc_ex_recency_1_more = 0.7246984566;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 0  AND  recency_1_more <= 1) then do;
		sc_ex_recency_1_more = 0.3727812113;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 1  AND  recency_1_more <= 2) then do;
		sc_ex_recency_1_more = 0.2586878375;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 2  AND  recency_1_more <= 4) then do;
		sc_ex_recency_1_more = 0.1881725001;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 4  AND  recency_1_more <= 5) then do;
		sc_ex_recency_1_more = 0.1308451934;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 5  AND  recency_1_more <= 7) then do;
		sc_ex_recency_1_more = 0.0790614755;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 7  AND  recency_1_more <= 9) then do;
		sc_ex_recency_1_more = 0.0108801232;
	end;
	if NOT(missing(recency_1_more))  AND  (recency_1_more > 9) then do;
		sc_ex_recency_1_more = -0.053118004;
	end;
	if missing(recency_1_more) then do;
		sc_ex_recency_1_more = -0.206587031;
	end;
	
	* Logit for recency_15_more;
	if NOT(missing(recency_15_more))  AND  (recency_15_more <= 0) then do;
		sc_ex_recency_15_more = 0.5126297605;
	end;
	if NOT(missing(recency_15_more))  AND  (recency_15_more > 0  AND  recency_15_more <= 1) then do;
		sc_ex_recency_15_more = 0.2914994875;
	end;
	if NOT(missing(recency_15_more))  AND  (recency_15_more > 1  AND  recency_15_more <= 3) then do;
		sc_ex_recency_15_more = 0.2158678599;
	end;
	if NOT(missing(recency_15_more))  AND  (recency_15_more > 3  AND  recency_15_more <= 5) then do;
		sc_ex_recency_15_more = 0.1690813613;
	end;
	if NOT(missing(recency_15_more))  AND  (recency_15_more > 5  AND  recency_15_more <= 7) then do;
		sc_ex_recency_15_more = 0.138228059;
	end;
	if NOT(missing(recency_15_more))  AND  (recency_15_more > 7) then do;
		sc_ex_recency_15_more = 0.083779481;
	end;
	if missing(recency_15_more) then do;
		sc_ex_recency_15_more = -0.074484922;
	end;
	
	* Logit for recency_60_more;
	if NOT(missing(recency_60_more))  AND  (recency_60_more <= 0) then do;
		sc_ex_recency_60_more = 0.9286969684;
	end;
	if NOT(missing(recency_60_more))  AND  (recency_60_more > 0  AND  recency_60_more <= 2) then do;
		sc_ex_recency_60_more = 0.4819524736;
	end;
	if NOT(missing(recency_60_more))  AND  (recency_60_more > 2  AND  recency_60_more <= 7) then do;
		sc_ex_recency_60_more = 0.4200029568;
	end;
	if NOT(missing(recency_60_more))  AND  (recency_60_more > 7) then do;
		sc_ex_recency_60_more = 0.2874609184;
	end;
	if missing(recency_60_more) then do;
		sc_ex_recency_60_more = -0.028526841;
	end;
	
	* Logit for max_dpd_mnth_3m;
	if (missing(max_dpd_mnth_3m)) OR (max_dpd_mnth_3m <= 0) then do;
		sc_ex_max_dpd_mnth_3m = -0.160004498;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 0  AND  max_dpd_mnth_3m <= 2) then do;
		sc_ex_max_dpd_mnth_3m = -0.044226046;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 2  AND  max_dpd_mnth_3m <= 6) then do;
		sc_ex_max_dpd_mnth_3m = 0.0212863095;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 6  AND  max_dpd_mnth_3m <= 10) then do;
		sc_ex_max_dpd_mnth_3m = 0.1249445027;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 10  AND  max_dpd_mnth_3m <= 14) then do;
		sc_ex_max_dpd_mnth_3m = 0.1744423857;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 14  AND  max_dpd_mnth_3m <= 30) then do;
		sc_ex_max_dpd_mnth_3m = 0.3163950772;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 30) then do;
		sc_ex_max_dpd_mnth_3m = 0.5750586338;
	end;
	
	* Logit for Loan_Firstpaydefault;
	if (missing(Loan_Firstpaydefault)) OR Loan_Firstpaydefault ^= 1 then do;
		sc_ex_Loan_Firstpaydefault = -0.016189818;
	end;
	if Loan_Firstpaydefault = 1 then do;
		sc_ex_Loan_Firstpaydefault = 0.1423054829;
	end;
	
	* Logit for avg_mnth_between_loans;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans <= 2.857142857142857) then do;
		sc_ex_avg_mnth_between_loans = 0.2716417646;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 2.857142857142857  AND  avg_mnth_between_loans <= 3.666666666666667) then do;
		sc_ex_avg_mnth_between_loans = 0.1896096156;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 3.666666666666667  AND  avg_mnth_between_loans <= 4.727272727272728) then do;
		sc_ex_avg_mnth_between_loans = 0.1052109193;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 4.727272727272728  AND  avg_mnth_between_loans <= 6.444444444444445) then do;
		sc_ex_avg_mnth_between_loans = 0.0254031899;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 6.444444444444445  AND  avg_mnth_between_loans <= 6.909090909090909) then do;
		sc_ex_avg_mnth_between_loans = -0.013917109;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 6.909090909090909  AND  avg_mnth_between_loans <= 7.5) then do;
		sc_ex_avg_mnth_between_loans = -0.054429716;
	end;
	if (missing(avg_mnth_between_loans)) OR (avg_mnth_between_loans > 7.5  AND  avg_mnth_between_loans <= 14.5) then do;
		sc_ex_avg_mnth_between_loans = -0.103561936;
	end;
	if NOT(missing(avg_mnth_between_loans))  AND  (avg_mnth_between_loans > 14.5) then do;
		sc_ex_avg_mnth_between_loans = -0.170899903;
	end;
	
	* Logit for _3m_bal_chgp;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp <= -0.3196196390452164) then do;
		sc_ex__3m_bal_chgp = -0.105515145;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > -0.3196196390452164  AND  _3m_bal_chgp <= -0.05019901237014646) then do;
		sc_ex__3m_bal_chgp = 0.1980600547;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > -0.05019901237014646  AND  _3m_bal_chgp <= 0) then do;
		sc_ex__3m_bal_chgp = 0.4074058474;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0  AND  _3m_bal_chgp <= 0.0101757805179715) then do;
		sc_ex__3m_bal_chgp = 0.1612112821;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.0101757805179715  AND  _3m_bal_chgp <= 0.02506389329165766) then do;
		sc_ex__3m_bal_chgp = 0.1180851005;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.02506389329165766  AND  _3m_bal_chgp <= 0.07893798554720262) then do;
		sc_ex__3m_bal_chgp = -0.07736362;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.07893798554720262  AND  _3m_bal_chgp <= 0.1725039042165539) then do;
		sc_ex__3m_bal_chgp = -0.122784731;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.1725039042165539  AND  _3m_bal_chgp <= 0.2748651699485765) then do;
		sc_ex__3m_bal_chgp = -0.147402556;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.2748651699485765) then do;
		sc_ex__3m_bal_chgp = -0.268310984;
	end;
	if missing(_3m_bal_chgp) then do;
		sc_ex__3m_bal_chgp = -0.114028414;
	end;
	
	* Logit for cur_util_rev;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev <= 0.003) then do;
		sc_ex_cur_util_rev = 0.0043127999;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.003  AND  cur_util_rev <= 0.1729282199484496) then do;
		sc_ex_cur_util_rev = -0.028592576;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.1729282199484496  AND  cur_util_rev <= 0.497) then do;
		sc_ex_cur_util_rev = -0.067649672;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.497  AND  cur_util_rev <= 0.9173478655767484) then do;
		sc_ex_cur_util_rev = -0.089157888;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.9173478655767484  AND  cur_util_rev <= 1.008615384615385) then do;
		sc_ex_cur_util_rev = -0.068196694;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 1.008615384615385  AND  cur_util_rev <= 1.030875) then do;
		sc_ex_cur_util_rev = -0.030632187;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 1.030875) then do;
		sc_ex_cur_util_rev = 0.0086892933;
	end;
	if missing(cur_util_rev) then do;
		sc_ex_cur_util_rev = 0.0407108503;
	end;
	
	* Logit for GO29_max_recency;
	if NOT(missing(GO29_max_recency))  AND  (GO29_max_recency <= 7) then do;
		sc_ex_GO29_max_recency = 0.0080732381;
	end;
	if (missing(GO29_max_recency)) OR (GO29_max_recency > 7) then do;
		sc_ex_GO29_max_recency = -0.139198116;
	end;
	
	* Logit for GO127_std;
	if NOT(missing(GO127_std))  AND  (GO127_std <= 0) then do;
		sc_ex_GO127_std = -0.037554039;
	end;
	if (missing(GO127_std)) OR (GO127_std > 0) then do;
		sc_ex_GO127_std = 0.0963951009;
	end;
	
	* Logit for cur_util_fi_chg__3mago;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago <= -0.1594827586206896) then do;
		sc_ex_cur_util_fi_chg_3mago = -0.070141371;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.1594827586206896  AND  cur_util_fi_chg__3mago <= -0.1003225806451613) then do;
		sc_ex_cur_util_fi_chg_3mago = -0.047728988;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.1003225806451613  AND  cur_util_fi_chg__3mago <= -0.04142469996128539) then do;
		sc_ex_cur_util_fi_chg_3mago = -0.033218397;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.04142469996128539  AND  cur_util_fi_chg__3mago <= -0.03359654715778115) then do;
		sc_ex_cur_util_fi_chg_3mago = -0.018558181;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.03359654715778115  AND  cur_util_fi_chg__3mago <= -0.02609756097560978) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.0132514234;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.02609756097560978  AND  cur_util_fi_chg__3mago <= -0.01779811495836237) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.0323907527;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.01779811495836237  AND  cur_util_fi_chg__3mago <= -0.006849887984890613) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.065326516;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.006849887984890613  AND  cur_util_fi_chg__3mago <= 0.001164779412614281) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.1297443125;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > 0.001164779412614281  AND  cur_util_fi_chg__3mago <= 0.06983180753672558) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.0616886073;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > 0.06983180753672558  AND  cur_util_fi_chg__3mago <= 0.1209642857142858) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.0017692438;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > 0.1209642857142858) then do;
		sc_ex_cur_util_fi_chg_3mago = -0.034949298;
	end;
	if missing(cur_util_fi_chg__3mago) then do;
		sc_ex_cur_util_fi_chg_3mago = 0.0122303096;
	end;
	
	* Logit for cur_util_fi_chg__6mago;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago <= -0.3322580645161291) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.135773198;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > -0.3322580645161291  AND  cur_util_fi_chg__6mago <= -0.2375833951074871) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.071464655;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > -0.2375833951074871  AND  cur_util_fi_chg__6mago <= -0.06979999999999997) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.036199958;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > -0.06979999999999997  AND  cur_util_fi_chg__6mago <= -0.02716312899573159) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.0131930017;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > -0.02716312899573159  AND  cur_util_fi_chg__6mago <= -0.01206680929689785) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.0533490333;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > -0.01206680929689785  AND  cur_util_fi_chg__6mago <= 0.002449486930520384) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.093969714;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > 0.002449486930520384  AND  cur_util_fi_chg__6mago <= 0.02309572825527539) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.0582474409;
	end;
	if (missing(cur_util_fi_chg__6mago)) OR (cur_util_fi_chg__6mago > 0.02309572825527539  AND  cur_util_fi_chg__6mago <= 0.04537202380952377) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.0360698357;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > 0.04537202380952377  AND  cur_util_fi_chg__6mago <= 0.1056) then do;
		sc_ex_cur_util_fi_chg_6mago = 0.0044566198;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > 0.1056  AND  cur_util_fi_chg__6mago <= 0.2231345125462773) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.013437943;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > 0.2231345125462773  AND  cur_util_fi_chg__6mago <= 0.3677067692133078) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.028685621;
	end;
	if NOT(missing(cur_util_fi_chg__6mago))  AND  (cur_util_fi_chg__6mago > 0.3677067692133078) then do;
		sc_ex_cur_util_fi_chg_6mago = -0.067170128;
	end;
	
	* Logit for AT71_chg__6mago;
	if NOT(missing(AT71_chg__6mago))  AND  (AT71_chg__6mago <= -10) then do;
		sc_ex_AT71_chg_6mago = 0.0575261611;
	end;
	if NOT(missing(AT71_chg__6mago))  AND  (AT71_chg__6mago > -10  AND  AT71_chg__6mago <= 0) then do;
		sc_ex_AT71_chg_6mago = -0.019283372;
	end;
	if NOT(missing(AT71_chg__6mago))  AND  (AT71_chg__6mago > 0  AND  AT71_chg__6mago <= 451) then do;
		sc_ex_AT71_chg_6mago = 0.089817172;
	end;
	if NOT(missing(AT71_chg__6mago))  AND  (AT71_chg__6mago > 451) then do;
		sc_ex_AT71_chg_6mago = 0.1174960946;
	end;
	if missing(AT71_chg__6mago) then do;
		sc_ex_AT71_chg_6mago = 0.0239564636;
	end;
	
	* Logit for tu_risk_2009_sc_chg__12mago;
	if NOT(missing(tu_risk_2009_sc_chg__12mago))  AND  (tu_risk_2009_sc_chg__12mago <= -140) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = 0.1524235057;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__12mago))  AND  (tu_risk_2009_sc_chg__12mago > -140  AND  tu_risk_2009_sc_chg__12mago <= -96) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = 0.099515704;
	end;
	if (missing(tu_risk_2009_sc_chg__12mago)) OR (tu_risk_2009_sc_chg__12mago > -96  AND  tu_risk_2009_sc_chg__12mago <= -14) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = 0.0498367628;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__12mago))  AND  (tu_risk_2009_sc_chg__12mago > -14  AND  tu_risk_2009_sc_chg__12mago <= -1) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = -0.020777966;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__12mago))  AND  (tu_risk_2009_sc_chg__12mago > -1  AND  tu_risk_2009_sc_chg__12mago <= 56) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = -0.073264593;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__12mago))  AND  (tu_risk_2009_sc_chg__12mago > 56) then do;
		sc_ex_tu_risk_2009_sc_chg_12mago = -0.105510627;
	end;
	
	* Logit for cMonthlyNetIncome;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome <= 1514) then do;
		sc_ex_cMonthlyNetIncome = 0.1211987724;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 1514  AND  cMonthlyNetIncome <= 1799) then do;
		sc_ex_cMonthlyNetIncome = 0.0665736045;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 1799  AND  cMonthlyNetIncome <= 2306) then do;
		sc_ex_cMonthlyNetIncome = 0.0447988777;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 2306  AND  cMonthlyNetIncome <= 2906) then do;
		sc_ex_cMonthlyNetIncome = 0.0170871934;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 2906  AND  cMonthlyNetIncome <= 3362) then do;
		sc_ex_cMonthlyNetIncome = -0.016185298;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 3362  AND  cMonthlyNetIncome <= 4157) then do;
		sc_ex_cMonthlyNetIncome = -0.043978174;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 4157) then do;
		sc_ex_cMonthlyNetIncome = -0.080813379;
	end;
	if missing(cMonthlyNetIncome) then do;
		sc_ex_cMonthlyNetIncome = -0.110283095;
	end;
	
	* Logit for GO116;
	if NOT(missing(GO116))  AND  (GO116 <= 1) then do;
		sc_ex_GO116 = -0.036175721;
	end;
	if NOT(missing(GO116))  AND  (GO116 > 1  AND  GO116 <= 2) then do;
		sc_ex_GO116 = 0.0718144103;
	end;
	if NOT(missing(GO116))  AND  (GO116 > 2  AND  GO116 <= 8) then do;
		sc_ex_GO116 = 0.0975207427;
	end;
	if NOT(missing(GO116))  AND  (GO116 > 8) then do;
		sc_ex_GO116 = 0.0494475871;
	end;
	if missing(GO116) then do;
		sc_ex_GO116 = 0.0136556102;
	end;
	
	* Logit for IN01;
	if NOT(missing(IN01))  AND  (IN01 <= 3) then do;
		sc_ex_IN01 = 0.1336763489;
	end;
	if NOT(missing(IN01))  AND  (IN01 > 3  AND  IN01 <= 4) then do;
		sc_ex_IN01 = 0.1206092877;
	end;
	if NOT(missing(IN01))  AND  (IN01 > 4  AND  IN01 <= 5) then do;
		sc_ex_IN01 = 0.0680926778;
	end;
	if (missing(IN01)) OR (IN01 > 5  AND  IN01 <= 8) then do;
		sc_ex_IN01 = 0.0252277731;
	end;
	if NOT(missing(IN01))  AND  (IN01 > 8  AND  IN01 <= 12) then do;
		sc_ex_IN01 = -0.072664721;
	end;
	if NOT(missing(IN01))  AND  (IN01 > 12  AND  IN01 <= 17) then do;
		sc_ex_IN01 = -0.165585986;
	end;
	if NOT(missing(IN01))  AND  (IN01 > 17) then do;
		sc_ex_IN01 = -0.314266097;
	end;
	
	* Logit for RE33_chgp__3mago;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago <= -1.32890365448505e-005) then do;
		sc_ex_RE33_chgp_3mago = -0.099102558;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > -1.32890365448505e-005  AND  RE33_chgp__3mago <= 0.02072368421052631) then do;
		sc_ex_RE33_chgp_3mago = 0.003936916;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > 0.02072368421052631  AND  RE33_chgp__3mago <= 0.03732809430255403) then do;
		sc_ex_RE33_chgp_3mago = 0.0240215047;
	end;
	if (missing(RE33_chgp__3mago)) OR (RE33_chgp__3mago > 0.03732809430255403  AND  RE33_chgp__3mago <= 0.07487091222030981) then do;
		sc_ex_RE33_chgp_3mago = 0.0456252299;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > 0.07487091222030981  AND  RE33_chgp__3mago <= 0.2366666666666667) then do;
		sc_ex_RE33_chgp_3mago = 0.0232703443;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > 0.2366666666666667) then do;
		sc_ex_RE33_chgp_3mago = -0.064895638;
	end;
	
	* Logit for RE33_chgp__12mago;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago <= -0.5700136095569334) then do;
		sc_ex_RE33_chgp_12mago = -0.039303051;
	end;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago > -0.5700136095569334  AND  RE33_chgp__12mago <= -2.75027502750275e-005) then do;
		sc_ex_RE33_chgp_12mago = -0.07934928;
	end;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago > -2.75027502750275e-005  AND  RE33_chgp__12mago <= 0.05983641842445114) then do;
		sc_ex_RE33_chgp_12mago = -0.013442381;
	end;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago > 0.05983641842445114  AND  RE33_chgp__12mago <= 0.2223320158102767) then do;
		sc_ex_RE33_chgp_12mago = 0.0161856633;
	end;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago > 0.2223320158102767  AND  RE33_chgp__12mago <= 0.7760932944606414) then do;
		sc_ex_RE33_chgp_12mago = -0.008064977;
	end;
	if NOT(missing(RE33_chgp__12mago))  AND  (RE33_chgp__12mago > 0.7760932944606414) then do;
		sc_ex_RE33_chgp_12mago = -0.057248537;
	end;
	if missing(RE33_chgp__12mago) then do;
		sc_ex_RE33_chgp_12mago = 0.0303780434;
	end;
	
	* Total logit;
	sc_ex_Total =		
+sc_ex_Intercept		
+sc_ex_cs_nsf_12m_times		
+sc_ex_New_EFSScore		
+sc_ex_AT22		
+sc_ex_AT28		
+sc_ex_GO04_v2		
+sc_ex_GO132		
+sc_ex_GO17_v2		
+sc_ex_PR42		
+sc_ex_Loan_Pmt_Freq		
+sc_ex_tu_risk_2009_score_v2		
+sc_ex_cur_paydown		
+sc_ex_recency_1_more		
+sc_ex_recency_15_more		
+sc_ex_recency_60_more		
+sc_ex_max_dpd_mnth_3m		
+sc_ex_Loan_Firstpaydefault		
+sc_ex_avg_mnth_between_loans		
+sc_ex__3m_bal_chgp		
+sc_ex_cur_util_rev		
+sc_ex_GO29_max_recency		
+sc_ex_GO127_std		
+sc_ex_cur_util_fi_chg_3mago		
+sc_ex_cur_util_fi_chg_6mago		
+sc_ex_AT71_chg_6mago		
+sc_ex_tu_risk_2009_sc_chg_12mago		
+sc_ex_cMonthlyNetIncome		
+sc_ex_GO116		
+sc_ex_IN01		
+sc_ex_RE33_chgp_3mago		
+sc_ex_RE33_chgp_12mago;
	
	b_score_logit = sc_ex_Total;
	
	* Score;
	b_score = -1*round(b_score_logit*70)+470;
	
	* PD;
	prob_def = 1/(1+exp(-b_score_logit));
	
	* Risk Group;
	length b_risk_group $ 12;
	if missing(b_score) then b_risk_group = "";
	else if b_score <=557 then b_risk_group = "Risk Group 6";
	else if b_score <=595 then b_risk_group = "Risk Group 5";
	else if b_score <=634 then b_risk_group = "Risk Group 4";
	else if b_score <=658 then b_risk_group = "Risk Group 3";
	else if b_score <=697 then b_risk_group = "Risk Group 2";
	else b_risk_group = "Risk Group 1";
	
run; %errchk;
%mend calc_score_exist;
