%macro calc_score_new(raw_file_name,scored_file_name);
data &scored_file_name.;
	set &raw_file_name.;
	
	* Logit for Intercept;
		sc_new_Intercept = -1.679633669;
	
	* Logit for New_EFSScore;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore <= 653) then do;
		sc_new_New_EFSScore = 0.4958810548;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 653  AND  New_EFSScore <= 719) then do;
		sc_new_New_EFSScore = 0.3901003589;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 719  AND  New_EFSScore <= 758) then do;
		sc_new_New_EFSScore = 0.2422458293;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 758  AND  New_EFSScore <= 802) then do;
		sc_new_New_EFSScore = 0.0681408459;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 802  AND  New_EFSScore <= 837) then do;
		sc_new_New_EFSScore = -0.060035008;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 837  AND  New_EFSScore <= 848) then do;
		sc_new_New_EFSScore = -0.201671847;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 848  AND  New_EFSScore <= 904) then do;
		sc_new_New_EFSScore = -0.288123246;
	end;
	if NOT(missing(New_EFSScore))  AND  (New_EFSScore > 904) then do;
		sc_new_New_EFSScore = -0.52379051;
	end;
	if missing(New_EFSScore) then do;
		sc_new_New_EFSScore = 0.1041827307;
	end;
	
	* Logit for cHomeMortgageOrRentAmount;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount <= 381) then do;
		sc_new_cHomeMortgageOrRentAmount = 0.0048450573;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 381  AND  cHomeMortgageOrRentAmount <= 462) then do;
		sc_new_cHomeMortgageOrRentAmount = -0.073819884;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 462  AND  cHomeMortgageOrRentAmount <= 499) then do;
		sc_new_cHomeMortgageOrRentAmount = -0.158398909;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 499  AND  cHomeMortgageOrRentAmount <= 500) then do;
		sc_new_cHomeMortgageOrRentAmount = 0.0381610597;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 500  AND  cHomeMortgageOrRentAmount <= 525) then do;
		sc_new_cHomeMortgageOrRentAmount = -0.143825877;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 525  AND  cHomeMortgageOrRentAmount <= 779) then do;
		sc_new_cHomeMortgageOrRentAmount = -0.012185462;
	end;
	if NOT(missing(cHomeMortgageOrRentAmount))  AND  (cHomeMortgageOrRentAmount > 779) then do;
		sc_new_cHomeMortgageOrRentAmount = -0.048674741;
	end;
	if missing(cHomeMortgageOrRentAmount) then do;
		sc_new_cHomeMortgageOrRentAmount = 0.0806281721;
	end;
	
	* Logit for cMonthlyNetIncome;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome <= 1748) then do;
		sc_new_cMonthlyNetIncome = 0.1487721257;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 1748  AND  cMonthlyNetIncome <= 1883) then do;
		sc_new_cMonthlyNetIncome = 0.0256809943;
	end;
	if (missing(cMonthlyNetIncome)) OR (cMonthlyNetIncome > 1883  AND  cMonthlyNetIncome <= 2006) then do;
		sc_new_cMonthlyNetIncome = 0.1198087719;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 2006  AND  cMonthlyNetIncome <= 3069) then do;
		sc_new_cMonthlyNetIncome = -0.005143013;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 3069  AND  cMonthlyNetIncome <= 4109) then do;
		sc_new_cMonthlyNetIncome = -0.066376707;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 4109  AND  cMonthlyNetIncome <= 5484) then do;
		sc_new_cMonthlyNetIncome = -0.1987147;
	end;
	if NOT(missing(cMonthlyNetIncome))  AND  (cMonthlyNetIncome > 5484) then do;
		sc_new_cMonthlyNetIncome = -0.288480358;
	end;
	
	* Logit for AT01;
	if NOT(missing(AT01))  AND  (AT01 <= 3) then do;
		sc_new_AT01 = 0.1003561688;
	end;
	if NOT(missing(AT01))  AND  (AT01 > 3  AND  AT01 <= 7) then do;
		sc_new_AT01 = 0.0456525432;
	end;
	if (missing(AT01)) OR (AT01 > 7  AND  AT01 <= 8) then do;
		sc_new_AT01 = 0.0069990173;
	end;
	if NOT(missing(AT01))  AND  (AT01 > 8  AND  AT01 <= 16) then do;
		sc_new_AT01 = -0.03883338;
	end;
	if NOT(missing(AT01))  AND  (AT01 > 16) then do;
		sc_new_AT01 = -0.137139602;
	end;
	
	* Logit for AT22;
	if NOT(missing(AT22))  AND  (AT22 <= 1) then do;
		sc_new_AT22 = -0.077163392;
	end;
	if (missing(AT22)) OR (AT22 > 1  AND  AT22 <= 2) then do;
		sc_new_AT22 = 0.0215910068;
	end;
	if NOT(missing(AT22))  AND  (AT22 > 2  AND  AT22 <= 3) then do;
		sc_new_AT22 = 0.2274644992;
	end;
	if NOT(missing(AT22))  AND  (AT22 > 3) then do;
		sc_new_AT22 = 0.5358816712;
	end;
	
	* Logit for AT70;
	if NOT(missing(AT70))  AND  (AT70 <= 0) then do;
		sc_new_AT70 = -0.014602349;
	end;
	if NOT(missing(AT70))  AND  (AT70 > 0) then do;
		sc_new_AT70 = 0.2420871572;
	end;
	if missing(AT70) then do;
		sc_new_AT70 = 0.0049550067;
	end;
	
	* Logit for GO132;
	if NOT(missing(GO132))  AND  (GO132 <= 5) then do;
		sc_new_GO132 = 0.1519158456;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 5  AND  GO132 <= 7) then do;
		sc_new_GO132 = 0.0860159199;
	end;
	if (missing(GO132)) OR (GO132 > 7  AND  GO132 <= 12) then do;
		sc_new_GO132 = 0.0171876163;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 12  AND  GO132 <= 22) then do;
		sc_new_GO132 = -0.015284708;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 22  AND  GO132 <= 59) then do;
		sc_new_GO132 = -0.089827229;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 59  AND  GO132 <= 135) then do;
		sc_new_GO132 = -0.1492819;
	end;
	if NOT(missing(GO132))  AND  (GO132 > 135) then do;
		sc_new_GO132 = -0.206214824;
	end;
	
	* Logit for GO17_v2;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 <= 0) then do;
		sc_new_GO17_v2 = -0.069627733;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 0  AND  GO17_v2 <= 1) then do;
		sc_new_GO17_v2 = -0.027101261;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 1  AND  GO17_v2 <= 2) then do;
		sc_new_GO17_v2 = 0.0698344114;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 2  AND  GO17_v2 <= 3) then do;
		sc_new_GO17_v2 = 0.1770458595;
	end;
	if NOT(missing(GO17_v2))  AND  (GO17_v2 > 3) then do;
		sc_new_GO17_v2 = 0.3991533893;
	end;
	if missing(GO17_v2) then do;
		sc_new_GO17_v2 = 0.0107171747;
	end;
	
	* Logit for PR42;
	if NOT(missing(PR42))  AND  (PR42 <= 0) then do;
		sc_new_PR42 = -0.135451381;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 0  AND  PR42 <= 1) then do;
		sc_new_PR42 = 0.0658799818;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 1  AND  PR42 <= 2) then do;
		sc_new_PR42 = 0.1402107442;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 2  AND  PR42 <= 3) then do;
		sc_new_PR42 = 0.2539185636;
	end;
	if NOT(missing(PR42))  AND  (PR42 > 3) then do;
		sc_new_PR42 = 0.3366275583;
	end;
	if missing(PR42) then do;
		sc_new_PR42 = 0.0077099895;
	end;
	
	* Logit for Loan_LPPFlag;
	if (missing(Loan_LPPFlag)) OR Loan_LPPFlag ^= 0 then do;
		sc_new_Loan_LPPFlag = 0.0214834834;
	end;
	if Loan_LPPFlag = 0 then do;
		sc_new_Loan_LPPFlag = -0.290126798;
	end;
	
	* Logit for Loan_Pmt_Freq;
	if (missing(Loan_Pmt_Freq)) OR Loan_Pmt_Freq ^= 'monthly' then do;
		sc_new_Loan_Pmt_Freq = -0.020491931;
	end;
	if Loan_Pmt_Freq = 'monthly' then do;
		sc_new_Loan_Pmt_Freq = 0.0731546379;
	end;
	
	* Logit for RI_FrequencyofApps;
	if NOT(missing(RI_FrequencyofApps))  AND  (RI_FrequencyofApps <= 2.812603101286704) then do;
		sc_new_RI_FrequencyofApps = 0.3258659222;
	end;
	if NOT(missing(RI_FrequencyofApps))  AND  (RI_FrequencyofApps > 2.812603101286704  AND  RI_FrequencyofApps <= 4.869679973606071) then do;
		sc_new_RI_FrequencyofApps = 0.2229154685;
	end;
	if NOT(missing(RI_FrequencyofApps))  AND  (RI_FrequencyofApps > 4.869679973606071  AND  RI_FrequencyofApps <= 15.34147146156384) then do;
		sc_new_RI_FrequencyofApps = 0.1353348265;
	end;
	if (missing(RI_FrequencyofApps)) OR (RI_FrequencyofApps > 15.34147146156384) then do;
		sc_new_RI_FrequencyofApps = -0.012458687;
	end;
	
	* Logit for AT71;
	if NOT(missing(AT71))  AND  (AT71 <= 0) then do;
		sc_new_AT71 = -0.028232043;
	end;
	if NOT(missing(AT71))  AND  (AT71 > 0) then do;
		sc_new_AT71 = 0.1284091239;
	end;
	if missing(AT71) then do;
		sc_new_AT71 = 0.0058560948;
	end;
	
	* Logit for recency_45_more;
	if NOT(missing(recency_45_more))  AND  (recency_45_more <= 0) then do;
		sc_new_recency_45_more = 0.548382864;
	end;
	if NOT(missing(recency_45_more))  AND  (recency_45_more > 0) then do;
		sc_new_recency_45_more = 0.2814416799;
	end;
	if missing(recency_45_more) then do;
		sc_new_recency_45_more = -0.024144538;
	end;
	
	* Logit for max_dpd_mnth_3m;
	if (missing(max_dpd_mnth_3m)) OR (max_dpd_mnth_3m <= 2) then do;
		sc_new_max_dpd_mnth_3m = -0.432800298;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 2  AND  max_dpd_mnth_3m <= 6) then do;
		sc_new_max_dpd_mnth_3m = 0.1748873621;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 6  AND  max_dpd_mnth_3m <= 12) then do;
		sc_new_max_dpd_mnth_3m = 0.4353104039;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 12  AND  max_dpd_mnth_3m <= 28) then do;
		sc_new_max_dpd_mnth_3m = 0.9308722962;
	end;
	if NOT(missing(max_dpd_mnth_3m))  AND  (max_dpd_mnth_3m > 28) then do;
		sc_new_max_dpd_mnth_3m = 2.0720198045;
	end;
	
	* Logit for Loan_Firstpaydefault;
	if (missing(Loan_Firstpaydefault)) OR Loan_Firstpaydefault ^= 1 then do;
		sc_new_Loan_Firstpaydefault = -0.029457668;
	end;
	if Loan_Firstpaydefault = 1 then do;
		sc_new_Loan_Firstpaydefault = 0.3125035834;
	end;
	
	* Logit for _3m_bal_chgp;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp <= 0) then do;
		sc_new__3m_bal_chgp = 0.643352996;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0  AND  _3m_bal_chgp <= 0.0226684250140996) then do;
		sc_new__3m_bal_chgp = 0.2483440912;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.0226684250140996  AND  _3m_bal_chgp <= 0.0620241201422969) then do;
		sc_new__3m_bal_chgp = -0.015294625;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.0620241201422969  AND  _3m_bal_chgp <= 0.09608863262307928) then do;
		sc_new__3m_bal_chgp = -0.077950183;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.09608863262307928  AND  _3m_bal_chgp <= 0.31509) then do;
		sc_new__3m_bal_chgp = -0.116246483;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.31509  AND  _3m_bal_chgp <= 0.4797112025120517) then do;
		sc_new__3m_bal_chgp = -0.219412984;
	end;
	if NOT(missing(_3m_bal_chgp))  AND  (_3m_bal_chgp > 0.4797112025120517) then do;
		sc_new__3m_bal_chgp = -0.480163946;
	end;
	if missing(_3m_bal_chgp) then do;
		sc_new__3m_bal_chgp = -0.00239669;
	end;
	
	* Logit for GO127_std;
	if NOT(missing(GO127_std))  AND  (GO127_std <= 0) then do;
		sc_new_GO127_std = -0.050836333;
	end;
	if NOT(missing(GO127_std))  AND  (GO127_std > 0  AND  GO127_std <= 40.5493526458808) then do;
		sc_new_GO127_std = 0.2543250265;
	end;
	if NOT(missing(GO127_std))  AND  (GO127_std > 40.5493526458808  AND  GO127_std <= 192.3330444827409) then do;
		sc_new_GO127_std = 0.1287492635;
	end;
	if (missing(GO127_std)) OR (GO127_std > 192.3330444827409  AND  GO127_std <= 1130.881367194043) then do;
		sc_new_GO127_std = 0.0133070543;
	end;
	if NOT(missing(GO127_std))  AND  (GO127_std > 1130.881367194043) then do;
		sc_new_GO127_std = 0.1330539123;
	end;
	
	* Logit for cur_util_fi_chg__3mago;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago <= -0.1459259259259259) then do;
		sc_new_cur_util_fi_chg_3mago = -0.060510274;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.1459259259259259  AND  cur_util_fi_chg__3mago <= -0.04803921568627445) then do;
		sc_new_cur_util_fi_chg_3mago = -0.028764469;
	end;
	if (missing(cur_util_fi_chg__3mago)) OR (cur_util_fi_chg__3mago > -0.04803921568627445  AND  cur_util_fi_chg__3mago <= -0.03327256153144936) then do;
		sc_new_cur_util_fi_chg_3mago = 0.005009908;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.03327256153144936  AND  cur_util_fi_chg__3mago <= -0.01355886087429714) then do;
		sc_new_cur_util_fi_chg_3mago = 0.0391063012;
	end;
	if NOT(missing(cur_util_fi_chg__3mago))  AND  (cur_util_fi_chg__3mago > -0.01355886087429714) then do;
		sc_new_cur_util_fi_chg_3mago = 0.1174876938;
	end;
	
	* Logit for RE33_chgp__3mago;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago <= -2.247898215168817e-005) then do;
		sc_new_RE33_chgp_3mago = -0.12029939;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > -2.247898215168817e-005  AND  RE33_chgp__3mago <= 0.02447916666666667) then do;
		sc_new_RE33_chgp_3mago = -0.004236554;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > 0.02447916666666667  AND  RE33_chgp__3mago <= 0.05534009060391748) then do;
		sc_new_RE33_chgp_3mago = 0.0781892643;
	end;
	if (missing(RE33_chgp__3mago)) OR (RE33_chgp__3mago > 0.05534009060391748  AND  RE33_chgp__3mago <= 0.191512513601741) then do;
		sc_new_RE33_chgp_3mago = 0.0174101386;
	end;
	if NOT(missing(RE33_chgp__3mago))  AND  (RE33_chgp__3mago > 0.191512513601741) then do;
		sc_new_RE33_chgp_3mago = -0.073522003;
	end;
	
	* Logit for GO04_v2;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 <= 3) then do;
		sc_new_GO04_v2 = -0.060866814;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 3  AND  GO04_v2 <= 6) then do;
		sc_new_GO04_v2 = -0.051585103;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 6  AND  GO04_v2 <= 8) then do;
		sc_new_GO04_v2 = -0.01784236;
	end;
	if (missing(GO04_v2)) OR (GO04_v2 > 8  AND  GO04_v2 <= 10) then do;
		sc_new_GO04_v2 = 0.0078123534;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 10  AND  GO04_v2 <= 16) then do;
		sc_new_GO04_v2 = 0.049891263;
	end;
	if NOT(missing(GO04_v2))  AND  (GO04_v2 > 16) then do;
		sc_new_GO04_v2 = 0.0993263782;
	end;
	
	* Logit for GO116;
	if NOT(missing(GO116))  AND  (GO116 <= 1) then do;
		sc_new_GO116 = -0.067845503;
	end;
	if NOT(missing(GO116))  AND  (GO116 > 1  AND  GO116 <= 5) then do;
		sc_new_GO116 = 0.1607731721;
	end;
	if NOT(missing(GO116))  AND  (GO116 > 5) then do;
		sc_new_GO116 = 0.0742104598;
	end;
	if missing(GO116) then do;
		sc_new_GO116 = 0.0109600699;
	end;
	
	* Logit for GO04_v2_chgp__12mago;
	if NOT(missing(GO04_v2_chgp__12mago))  AND  (GO04_v2_chgp__12mago <= -0.1702127659574468) then do;
		sc_new_GO04_v2_chgp_12mago = -0.30881544;
	end;
	if NOT(missing(GO04_v2_chgp__12mago))  AND  (GO04_v2_chgp__12mago > -0.1702127659574468  AND  GO04_v2_chgp__12mago <= 0) then do;
		sc_new_GO04_v2_chgp_12mago = -0.117316554;
	end;
	if (missing(GO04_v2_chgp__12mago)) OR (GO04_v2_chgp__12mago > 0  AND  GO04_v2_chgp__12mago <= 0.1666666666666667) then do;
		sc_new_GO04_v2_chgp_12mago = 0.0075149977;
	end;
	if NOT(missing(GO04_v2_chgp__12mago))  AND  (GO04_v2_chgp__12mago > 0.1666666666666667) then do;
		sc_new_GO04_v2_chgp_12mago = 0.1524326577;
	end;
	
	* Logit for cur_paydown;
	if NOT(missing(cur_paydown))  AND  (cur_paydown <= 0.44290625) then do;
		sc_new_cur_paydown = -0.561914262;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.44290625  AND  cur_paydown <= 0.7442) then do;
		sc_new_cur_paydown = -0.116943777;
	end;
	if (missing(cur_paydown)) OR (cur_paydown > 0.7442  AND  cur_paydown <= 0.901458064516129) then do;
		sc_new_cur_paydown = -0.019641317;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.901458064516129  AND  cur_paydown <= 0.9879791937146986) then do;
		sc_new_cur_paydown = 0.1230959436;
	end;
	if NOT(missing(cur_paydown))  AND  (cur_paydown > 0.9879791937146986) then do;
		sc_new_cur_paydown = 0.3138624124;
	end;
	
	* Logit for _12m_pydown_chg;
	if NOT(missing(_12m_pydown_chg))  AND  (_12m_pydown_chg <= -0.5749047619047619) then do;
		sc_new__12m_pydown_chg = -0.56558138;
	end;
	if NOT(missing(_12m_pydown_chg))  AND  (_12m_pydown_chg > -0.5749047619047619  AND  _12m_pydown_chg <= -0.5356975609756097) then do;
		sc_new__12m_pydown_chg = -0.304081186;
	end;
	if (missing(_12m_pydown_chg)) OR (_12m_pydown_chg > -0.5356975609756097  AND  _12m_pydown_chg <= -0.470406) then do;
		sc_new__12m_pydown_chg = 0.0030589338;
	end;
	if NOT(missing(_12m_pydown_chg))  AND  (_12m_pydown_chg > -0.470406  AND  _12m_pydown_chg <= -0.216618) then do;
		sc_new__12m_pydown_chg = 0.1334579926;
	end;
	if NOT(missing(_12m_pydown_chg))  AND  (_12m_pydown_chg > -0.216618) then do;
		sc_new__12m_pydown_chg = 0.3004957301;
	end;
	
	* Logit for tu_risk_2009_sc_chg__6mago;
	if NOT(missing(tu_risk_2009_sc_chg__6mago))  AND  (tu_risk_2009_sc_chg__6mago <= -52) then do;
		sc_new_tu_risk_2009_sc_chg_6mago = 0.1474897161;
	end;
	if (missing(tu_risk_2009_sc_chg__6mago)) OR (tu_risk_2009_sc_chg__6mago > -52  AND  tu_risk_2009_sc_chg__6mago <= -7) then do;
		sc_new_tu_risk_2009_sc_chg_6mago = 0.012439349;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__6mago))  AND  (tu_risk_2009_sc_chg__6mago > -7  AND  tu_risk_2009_sc_chg__6mago <= 17) then do;
		sc_new_tu_risk_2009_sc_chg_6mago = -0.106873586;
	end;
	if NOT(missing(tu_risk_2009_sc_chg__6mago))  AND  (tu_risk_2009_sc_chg__6mago > 17) then do;
		sc_new_tu_risk_2009_sc_chg_6mago = -0.1816267;
	end;
	
	* Logit for IN33_chg__6mago;
	if NOT(missing(IN33_chg__6mago))  AND  (IN33_chg__6mago <= -700) then do;
		sc_new_IN33_chg_6mago = -0.09343988;
	end;
	if (missing(IN33_chg__6mago)) OR (IN33_chg__6mago > -700  AND  IN33_chg__6mago <= -423) then do;
		sc_new_IN33_chg_6mago = 0.0049147702;
	end;
	if NOT(missing(IN33_chg__6mago))  AND  (IN33_chg__6mago > -423  AND  IN33_chg__6mago <= -8) then do;
		sc_new_IN33_chg_6mago = 0.1570324664;
	end;
	if NOT(missing(IN33_chg__6mago))  AND  (IN33_chg__6mago > -8  AND  IN33_chg__6mago <= 3172) then do;
		sc_new_IN33_chg_6mago = 0.0310703816;
	end;
	if NOT(missing(IN33_chg__6mago))  AND  (IN33_chg__6mago > 3172) then do;
		sc_new_IN33_chg_6mago = -0.008021879;
	end;
	
	* Logit for cur_util_rev;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev <= 0.02111553784860558) then do;
		sc_new_cur_util_rev = -0.031471527;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.02111553784860558  AND  cur_util_rev <= 0.3374315969014285) then do;
		sc_new_cur_util_rev = -0.097979948;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.3374315969014285  AND  cur_util_rev <= 0.959811320754717) then do;
		sc_new_cur_util_rev = -0.135867792;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 0.959811320754717  AND  cur_util_rev <= 1.011) then do;
		sc_new_cur_util_rev = -0.093799139;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 1.011  AND  cur_util_rev <= 1.078222222222222) then do;
		sc_new_cur_util_rev = -0.016569633;
	end;
	if (missing(cur_util_rev)) OR (cur_util_rev > 1.078222222222222  AND  cur_util_rev <= 1.407463823305408) then do;
		sc_new_cur_util_rev = 0.0612011845;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 1.407463823305408  AND  cur_util_rev <= 3.396666666666667) then do;
		sc_new_cur_util_rev = -0.0018242;
	end;
	if NOT(missing(cur_util_rev))  AND  (cur_util_rev > 3.396666666666667) then do;
		sc_new_cur_util_rev = -0.060383232;
	end;
	
	* Total logit;
	sc_new_Total =		
+sc_new_Intercept		
+sc_new_New_EFSScore		
+sc_new_cHomeMortgageOrRentAmount		
+sc_new_cMonthlyNetIncome		
+sc_new_AT01		
+sc_new_AT22		
+sc_new_AT70		
+sc_new_GO132		
+sc_new_GO17_v2		
+sc_new_PR42		
+sc_new_Loan_LPPFlag		
+sc_new_Loan_Pmt_Freq		
+sc_new_RI_FrequencyofApps		
+sc_new_AT71		
+sc_new_recency_45_more		
+sc_new_max_dpd_mnth_3m		
+sc_new_Loan_Firstpaydefault		
+sc_new__3m_bal_chgp		
+sc_new_GO127_std		
+sc_new_cur_util_fi_chg_3mago		
+sc_new_RE33_chgp_3mago		
+sc_new_GO04_v2		
+sc_new_GO116		
+sc_new_GO04_v2_chgp_12mago		
+sc_new_cur_paydown		
+sc_new__12m_pydown_chg		
+sc_new_tu_risk_2009_sc_chg_6mago		
+sc_new_IN33_chg_6mago		
+sc_new_cur_util_rev;
	
	b_score_logit = sc_new_Total;
	
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
%mend calc_score_new;
