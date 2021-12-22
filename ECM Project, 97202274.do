*** Final Project, Marziyeh Aghaei, 97202274
*Initialization
clear
import excel "C:\Users\Asus\Desktop\Sample.xlsx", sheet("Sheet1") firstrow
destring Time Return Dummy MReturn MReturn_Dummy, replace force
* Line plot for winner-loser portfo return
egen Return_mean= mean(Return)
line Return Time || connected Return_mean Time
* Summary Statistic
asdoc sum Return MReturn
* Basic regression
regress Return Dummy MReturn MReturn_Dummy 
outreg2 using myreg.doc, replace ctitle(Model 2.1)
* Testing fot Heteroskedasticity
asdoc estat hettest
* Testing for autocorrelation
tsset Time
corrgram Return
ac Return
asdoc varsoc Return, maxlag(10)
* Testing for cross-correlations
xcorr Return MReturn
asdoc varsoc Return, exog(MReturn)
* Unit root test
tsset Time
asdoc dfuller Return, drift regress
asdoc dfuller MReturn, drift regress
* Durbin-Watson test
asdoc estat dwatson
* Brusch-Godfrey Teest
asdoc estat bgodfrey, lag(1)

* Structural-Break Test
regress Return Dummy MReturn MReturn_Dummy 
tsset Time
asdoc estat sbknown, break(37)

* Ramsey Test for Over-identification
asdoc ovtest

* Error term normality test
regress Return Dummy MReturn MReturn_Dummy 
predict Return_hat if e(sample)
predict Return_hat_res, res
asdoc sktest Return_hat_res

* Model Prediction
twoway lfitci Return_hat Time, stdf || scatter Return_hat Time