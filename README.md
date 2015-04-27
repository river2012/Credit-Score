# Credit-Score
###SAS Program for building a Credit Score
#### 1. Create Modeling Dataset
This part calculates variables that are going to be used for score building. <br>
Program to run: *CREATE_MODELING_DS.sas* <br>
The actual variable calculation happens in the macro *calc_raw_vars_routine*. This macro was written not by me, is very messy, and has couple dozens of parameters. I've created a convenient wrapper *calc_raw_vars* that automatically calculates all necessary parameters for *calc_raw_vars_routine* and executes it.

#### 2. Variable Binning
This part creates an SPSS script allowing to bin all variables of the Modeling dataset using SPSS decision trees. This script should be run in SPSS and the output should be saved to *./csv_in/* folder<br>
Program to run: *SPSS_SCRIPT_TREE.sas*<br>
*Note:* this script doesn't build actual *trees*, but rather uses SPSS for determining bins (groups) for each variable. This bins will later be used for calculating Weight of Evidence.

#### 3. Logistic Regression
This part fits Logistic Regression to create a score. Although the code for this part is designed to be fully automated, for a good model it requires some manual work regarding variable selection. <br>
Program to run: *REGRESSION.sas* <br>
The program will run stepwise and backward logistic regression to determine significant variables, and by default will include all of them in the model. After that you may specify the variables to exclude, in order to fight overfitting and remove highly correlated inputs.<br>
After regression, the program will produce the KS table for both training (development) and testing (validation) dataset.

#### 4. Creating Production Scoring Code
This part creates a production scoring code based on the model developed during the previous step.<br>
Program to run: *NEW_SCORE.sas*<br>
