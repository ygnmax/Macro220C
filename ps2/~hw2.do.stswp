clear all
/* Mac and Win */
global datapath "/Users/ygnmax/Dropbox (Personal)/Library/Economics/UCSD/Econ210/C00/Macro220C/ps2/"

/* Linux */
// global datapath "/home/ygnmax/Dropbox/Library/Economics/UCSD/Econ210/C00/Macro220C/ps2/"
cd "$datapath"

****************
** Question 1 **
****************
/* a */
* fed funds rate
import delimited "${datapath}FEDFUNDS.csv", clear 
gen date_m = monthly(substr(date, 1, 7), "YM")
format date_m %tm
tsset date_m
tsline fedfunds
// graph export "q1_a_fedfunds.pdf",   replace



* unemployment rate
import delimited "${datapath}UNRATE.csv", clear 
gen date_m = monthly(substr(date, 1, 7), "YM")
format date_m %tm
tsset date_m
tsline unrate
// graph export "q1_a_unrate.pdf",   replace



* GDP deflator inflation rate
import delimited "${datapath}A191RI1Q225SBEA.csv", clear 
rename a191ri1q225sbea gdpdft
label variable gdpdft "GDPDFT"
gen date_m = monthly(substr(date, 1, 7), "YM")
format date_m %tm
tsset date_m
tsline gdpdft
// graph export "q1_a_gdpdft.pdf",   replace



/* b */
import delimited "${datapath}FEDFUNDS.csv", clear 
generate yr = substr(date,1,4)
generate mo = substr(date,6,2)
destring mo, replace
generate qt = "1" if inlist(mo, 1, 2, 3)
replace qt = "2" if inlist(mo, 4, 5, 6)
replace qt = "3" if inlist(mo, 7, 8, 9) 
replace qt = "4" if inlist(mo, 10, 11, 12) 
gen quarter = yr + "Q" + qt
keep quarter fedfunds
collapse (mean) fedfunds, by(quarter)
label variable fedfunds "FEDFUNDS"
tempfile fedfunds
save `fedfunds'

import delimited "${datapath}UNRATE.csv", clear 
generate yr = substr(date,1,4)
generate mo = substr(date,6,2)
destring mo, replace
generate qt = "1" if inlist(mo, 1, 2, 3)
replace qt = "2" if inlist(mo, 4, 5, 6)
replace qt = "3" if inlist(mo, 7, 8, 9) 
replace qt = "4" if inlist(mo, 10, 11, 12) 
gen quarter = yr + "Q" + qt
keep quarter unrate
collapse (mean) unrate, by(quarter)
label variable unrate "UNRATE"
tempfile unrate
save `unrate'

import delimited "${datapath}A191RI1Q225SBEA.csv", clear 
rename a191ri1q225sbea gdpdft
label variable gdpdft "GDPDFT"
generate yr = substr(date,1,4)
generate mo = substr(date,6,2)
destring mo, replace
generate qt = "1" if inlist(mo, 1, 2, 3)
replace qt = "2" if inlist(mo, 4, 5, 6)
replace qt = "3" if inlist(mo, 7, 8, 9) 
replace qt = "4" if inlist(mo, 10, 11, 12) 
gen quarter = yr + "Q" + qt
keep quarter gdpdft
tempfile gdpdft
save `gdpdft'



use `gdpdft', clear
merge 1:1 quarter using `unrate', nogen keep(3)
merge 1:1 quarter using `fedfunds', nogen keep(3)
label variable quarter "QUARTER"
order quarter gdpdft unrate fedfunds
keep if  "1960" <= substr(quarter, 1, 4) &  substr(quarter, 1, 4) <= "2007"

/* c */
import delimited "${datapath}series.csv", clear
gen date_q = quarterly(quarter, "YQ")
format date_q %tq

tsset date_q

var gdpdft unrate fedfunds, lags(1/4)
irf create q1_b_var_irf, set(q1_b_var_irf, replace) step(20) replace
irf graph oirf, impulse(gdpdft unrate fedfunds) response(gdpdft unrate fedfunds) byopts(yrescale)
// graph export "q1_b_var_irf.pdf",   replace

/* d */
matrix A = (.,0,0 \ .,.,0 \ .,.,.)
matrix B = (1,0,0 \ 0,1,0 \ 0,0,1)

svar gdpdft unrate fedfunds, lags(1/4) aeq(A) beq(B)
irf create q1_d_svar_irf, set(q1_d_svar_irf, replace) step(20) replace
irf graph sirf, irf(q1_d_svar_irf) impulse(gdpdft unrate fedfunds) response(gdpdft unrate fedfunds) byopts(yrescale)
// graph export "q1_d_svar_irf.pdf",   replace
	
/* f */
* residuals: monetary shock
predict resid_monetary, residuals equation(fedfunds)
tsline resid_monetary, graphregion(fcolor(white)) 
// graph export "q1_f_monetary_shock.pdf",   replace
	
****************
** Question 2 **
****************
/* a */
rename date_q date
merge 1:1 date using "Monetary_shocks/RR_monetary_shock_quarterly.dta", keep(1 3) nogen

gen year = substr(quarter, 1, 4)
destring year, replace
replace resid = 0 if year<1969
replace resid_romer = 0 if year<1969
replace resid_full = 0 if year<1969

tsset date

/* b */
var gdpdft unrate fedfunds, lags(1/8)  exog(L(0/12).resid_full)

irf create q2_b_var_irf, set(q2_b_var_irf, replace) step(20) replace
irf graph dm, impulse(resid_full) irf(q2_b_var_irf)
// graph export "q2_b_var_irf.pdf",   replace

/* c */

matrix A = (.,0,0,0 \ .,.,0,0 \ .,.,.,0 \ .,.,.,.)
matrix B = (1,0,0,0 \ 0,1,0,0 \ 0,0,1,0 \ 0,0,0,1)

svar resid_full gdpdft unrate fedfunds, lags(1/4) aeq(A) beq(B)
irf create q2_c_svar, set(q2_c_svar) step(20) replace
	
irf graph sirf, irf(q2_c_svar) impulse(resid_full gdpdft unrate fedfunds) response(resid_full gdpdft unrate fedfunds) // byopts(yrescale)
graph export "q2_c_svar_irf.pdf",   replace


