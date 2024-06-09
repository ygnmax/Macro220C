clear all

/* (a) */
import delimited "romerromershocks.csv", clear
gen qdate = quarterly(date, "YQ")
format qdate %tq
keep qdate romerromer 
tempfile rrshock
save `rrshock'


set fredkey d181f62eeff05aa20f202bb442ba84a5 , permanently
import fred FEDFUNDS GDPC1 GDPPOT CPIAUCSL, clear aggregate(quarterly) //aggregate method is avg
gen qdate = qofd(daten)
format qdate %tq
keep qdate FEDFUNDS GDPC1 GDPPOT CPIAUCSL


/* (b) */
merge 1:1 qdate using `rrshock', nogen keep(1 3)
order qdate FEDFUNDS GDPC1 GDPPOT CPIAUCSL

/* (c) */
gen pi = 400 * (log(CPIAUCSL) - log(CPIAUCSL[_n-4]))

/* (d) */
gen gap = 100 * (log(GDPC1) - log(GDPPOT))

/* (e) */
keep if inrange(qdate, quarterly("1970Q1", "YQ"), quarterly("2007Q4", "YQ"))

/* (f) */
rename (FEDFUNDS romerromer) (i RR)
keep qdate i gap pi RR
label var i "Federal Funds rate"
label var RR "Romer-Romer Shock"
label var gap "Output gap"
label var pi "CPI inflation rate annualized"

tsset qdate, quarterly

cap graph drop ffr
tsline i, aspect(0.5) name(ffr) legend(position(6) cols(3))
graph export "q2_f_ffr.pdf", replace
cap graph drop outputgap
tsline gap, aspect(0.5) name(outputgap) legend(position(6) cols(3))
graph export "q2_f_outputgap.pdf", replace
cap graph drop cpiinflation
tsline pi, aspect(0.5) name(cpiinflation) legend(position(6) cols(3))
graph export "q2_f_cpiinflation.pdf", replace
cap graph drop rrshock
tsline RR, aspect(0.5) name(rrshock) legend(position(6) cols(3))
graph export "q2_f_rrshock.pdf", replace
// combine together
gr combine ffr outputgap cpiinflation rrshock, col(2) iscale(0.6) altshrink imargin(tiny)
graph export "q2_f_combined.pdf", replace


/* (g) */
var gap pi, lags(1/8)  exog(L(0/12).i)
irf create q2_g_var_irf, set(q2_g_var_irf, replace) step(16) replace
irf graph dm, impulse(i) irf(q2_g_var_irf)
graph export "q2_g_var_irf.pdf",   replace



/* (g) */
var gap pi, lags(1/8)  exog(L(0/12).RR)
irf create q2_h_var_irf, set(q2_h_var_irf, replace) step(16) replace
irf graph dm, impulse(RR) irf(q2_h_var_irf)
graph export "q2_h_var_irf.pdf",   replace

