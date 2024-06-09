clear all

import delimited "simulated.csv", clear
rename v1 t
tsset t


ivreg2 y (i = ibar), first savefirst 
est store m1
esttab m1 using "ivreg2_q1k.csv", ///
	   replace scalar(r2 N wiv) compress nobaselevels nogaps star(* 0.1 ** 0.05 *** 0.01) ///
	   b(%6.3f) se(%6.3f) 
	 