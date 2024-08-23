********************************************************************************
********************************************************************************
     ********************* Data Analysis - Double Difference  **************************
						* Created: December 15, 2021 *
					   * Creator: Mohammed ElDesouky *
						* mohammed.reda.amin@gmail.com *

********************************************************************************
*Outline:  
*---------
	/*
	1- To be updated 
	
	
	
Supporting resources: 

	- The World Bank HandBook on Impact Evaluation : https://documents1.worldbank.org/curated/en/650951468335456749/pdf/520990PUB0EPI1101Official0Use0Only1.pdf 
	- Impact evaluation using Difference-in-Differences https://www.emerald.com/insight/content/doi/10.1108/RAUSP-05-2019-0112/full/html
	- Differences-in-Differences (using STATA) by Princeton University : https://www.princeton.edu/~otorres/DID101.pdf
	- Panel Data Anlysis: Fixed and Random Effects using STATA by Princeton University: https://www.princeton.edu/~otorres/Panel101.pdf
	- Other


*/

*-------------------------------------------------------------------------------
*Setting up the workspace and directory:
*---------------------------------------
clear
capture log close
set more off, permanently

pwd 
cd"C:\Users\DELL\Downloads\Save the Children\SC\Data_clean"

*------------------------------------------------------------------------------*
*Importing data:
*--------------------------------

use "full_dataCGA.dta"

*------------------------------------------------------------------------------*
*calculating attrition:
*--------------------------------

by cgid, sort: egen in_base = max(period == 0)
by cgid: egen in_end = max(period == 1)
egen flag = tag(cgid) // SELECT ONE OBSERVATION PER hhid


gen attri =0
replace attri= 1 if in_end==0 & in_base==1 & flag== 1
tab attri treatment if period ==0

reg attri locid nfamily cgsex spouseage spouselive reside bcked ses if period==0, cluster(hhid)
	/* Our observed variables explain only 3% of the variance on attrition. 
	However, attrition is 12.5% higher for community 2 (statitically significant at 5%)
	than in community 1---> something to investigate. 
	
	*/
*------------------------------------------------------------------------------*
*Data exploration:
*--------------------------------

**Checking for mean differences between location 1 & 2

sort locid
by locid: sum carechildrel_score if period==0,
by locid: sum teachplay_score	 if period==0,
by locid: sum caregiverres_score if period==0,
by locid: sum cgpse_score		 if period==0,
by locid: sum g_attitude_score 	 if period==0,
by locid: sum g_practice_score 	 if period==0,
by locid: sum pss 			 	 if period==0,


	* running a regression to check if the means differences are significant 
	reg carechildrel_score locid nfamily cgsex spouseage spouselive reside bcked ses if period==0 	& attri==0, cluster(hhid)	//significant means difference at 1%
	reg teachplay_score	   locid nfamily cgsex spouseage spouselive reside bcked ses if period==0	& attri==0, cluster(hhid)	//significant means difference at 10%
	reg caregiverres_score locid nfamily cgsex spouseage spouselive reside bcked ses if period==0 	& attri==0, cluster(hhid)	//significant means difference at 5%
	reg cgpse_score		   locid nfamily cgsex spouseage spouselive reside bcked ses if period==0	& attri==0, cluster(hhid)	//significant means difference at 1%
	reg g_attitude_score   locid nfamily cgsex spouseage spouselive reside bcked ses if period==0	& attri==0, cluster(hhid)	//Not significant means difference
	reg g_practice_score   locid nfamily cgsex spouseage spouselive reside bcked ses if period==0	& attri==0, cluster(hhid)	//significant means difference at 1%
	reg pss 			   locid nfamily cgsex spouseage spouselive reside bcked ses if period==0	& attri==0, cluster(hhid)	//Not significant means difference

		/* 5 outcomes are predicted by location, suggesting that the level of outcomes 
		achievement for these four outcomes is expected to change for individuals based 
		on their locations (camp1 or camp2.)*/
		
	* checking control-treatment assignment 
	tab treatment locid if period==0 & attri==0
			
		/* control ratio is 23% in site 1, and 34% in site 2 --> unbalanced control-treatment assignment. the diff-in-diff should account for means differences
		*/
	
	
**checking for random assignment (checking balance) 		
reg carechildrel_score treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg teachplay_score	   treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg caregiverres_score treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg cgpse_score		   treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg g_attitude_score   treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg g_practice_score   treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg pss				   treatment locid nfamily cgsex spouseage spouselive reside bcked ses if period ==0 & attri==0, cluster(hhid)
reg cgsex			   treatment locid nfamily spouseage spouselive reside bcked ses 	   if period ==0 & attri==0, cluster(hhid)
reg nfamily			   treatment locid cgsex spouseage spouselive reside bcked ses 		   if period ==0 & attri==0, cluster(hhid)
reg bcked			   treatment locid nfamily cgsex spouseage spouselive reside ses 	   if period ==0 & attri==0, cluster(hhid)
reg reside			   treatment locid nfamily cgsex spouseage spouselive bcked ses 	   if period ==0 & attri==0, cluster(hhid)
reg ses				   treatment locid nfamily cgsex spouseage spouselive reside bcked     if period ==0 & attri==0, cluster(hhid)

		/* balance on some charactrstics is sustained, but it is not sustianed for the outcomes
		varibales. In otherwords, there is no indication of random assignment. this is an additional
		argument favoring the double difference method*/

		
		
*______________________________________________________________________________*

*-*-*-*-*-*-* 1- Diff-in-Diff estimation for Caregiver outcomes *-*-*-*-*-*-*-*																		
*______________________________________________________________________________*		

**Exploratory Analysis
ssc install asdoc

asdoc ttest carechildrel_score if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p)
asdoc ttest teachplay_score if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p) rowappend
asdoc ttest caregiverres_score if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p) rowappend
asdoc ttest cgpse_score if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p) rowappend
asdoc ttest pss if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p) rowappend
asdoc ttest g_attitude_score if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p) rowappend
asdoc c, stat(obs mean dif p) rowappend

** Diff-in-Diff key assumptions

		* 1) Parallel trends 

		/*the untreated units provide the appropriate counterfactual of the trend that the 
		treated units would have followed if they had not been treated – that is, 
		the two groups would have had parallel trends.	

		since parallel trend assumption is a counterfactual assumption, there is no way to test it, 
		however, in the presence of historical data (more than one pre-inntervention data) some methods
		could be used to provide some evidence supporting the parallel trends:

				a- placebo test, where DiD is administered on two pre-intervention periods, to
					establish that there is no significant effect size
				b- a visual inspection using the code below:
							
						preserve
						collapse (mean)g_practice_score, by(treatment period)
						reshape wide g_practice_score, i(period) j(treatment)
						graph twoway connect g_practice_score* period if period < 0
						restore		
				
					If the two curves also appear to be more or less straight lines, then we can 
					quantify this with:
						
						xtreg g_practice_score i.treatment##c.period if period < 0
						margins UBI, dydx(year)	
				
					The -margins- output will then give us estimated time trends for g-practice in 
					each group prior to baseline, and we can make a judgment whether they are 
					close enough for practical purposes.

		in our case, it is not possible to do so, therefore, any estimation of effect size must be
		cautiously interpreted and reported(not interpreted as a causual relation-- maybe as
		a correlation) and list it as a study limitation. the reason for that is the violation of 
		parallel trends biases effect sizes. 
			
		Additionally, we can increase the internal validity of our diff-in-diff estimation
		through gathering other evidence to make a case for the parallel trends existence as follows:
					
					a- checking for differences in observable charachtrstics between treatment
					   and control -- if the differences is insignificant, we can assume that
					   both groups are similar and will be affected by treatment in the same way. 
					   
					   ->>>The check supports the assumption that the two groups are similar to some
							extent, but doesn't rule out entierly the possibility of latent variable/
							unobserved variables especially time variant ones (a study limitation with
							the diff-in-diff model).
					   
					b- Gathering evidence to support the common shocks assumption-- discussed below
					

		* 2) Common Shocks 

		In the post-intervention period, exogenous forces affect treated and control groups equally.			
					
		Can we gather evidence to prove:
					a- Evidence to support that observable charctstics between treat and control are
						similar
					b- Evidence to approximately equal/close proportions of treatment to control
					C- proximity between the two camps in terms of location, demographics
					   and administration?
					d- Evidence suggesting no big changes/schocks have occured during the study period
					   
							
		* 3) Stable unit treatment value assumption (No spillovers)
		The treatment status of anyone unit must not affect the outcomes of any other unit.

		This assumption is challenging to test as treatment and control groups come from the same two
		camps, and there is no evidence that treated people don't have connection with those in the control
		, and could comunicate the treatment's effect to them. Additionally, there is no an observed varibale in 
		our data that could be used to measure spillover effect. If spillover exists, the effect size
		estimation could be biased. We can just be open about this by including it in the study limitations.
		*/


** Diff-in-Diff estimation
label var locid "Location" 
label var nfamily "Family size" 
label var cgsex "Caregiver sex" 
label var spouseage "age of spouse" 
label var spouselive "live with spouse"
label var reside "lenght of residence"
label var bcked "Highest education" 
label var ses "living conditions"

		*(1) creating an interaction variable between period and treatment (the coefficient of 
		*	 this is the effects size)

		gen did=period*treatment

		*(1) Diff-in-Diff for caregiver outcomes 
			/* Diff-in-Diff could be estimated by an OLS estimator in a regression. The OLS
			   could be regular (pooled) regression or Fixed effect. Fixed effect is suitable to the data
			   type we have (panel) as the assumption that error terms in all observations are independent 
			   is most likely violated (the error term dependent on time). The pooled regression is suitable
			   when the data is repeated crosssection. 
			   
			   However, I would still use OLS pooled regression to avoid the fixed effects to omit
			   gender varibale (as it is time invariant, and time invariant vars are omitted in FE). 
			   I would use fixed effects as a roboustness check instead. 
			   */

		xtset cgid period	//Tells stata we are dealing with panel data

		*(2) Run a regression for each outcome varibale and a fixed effect to test roboustness. 

		eststo: reg carechildrel_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid) 					//Positive significant effect			
			xtreg carechildrel_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid)	//Positive significant effect - Robust estimate			
			
			predict cc
			by cgsex: sum cc  				//Disaggregation of effect size by gender
			
			
		eststo: reg teachplay_score    period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Positive significant effect	
			xtreg teachplay_score 	 period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid)	//Positive significant effect - Robust estimate	
			
			predict tp
			by cgsex: sum tp  				//Disaggregation of effect size by gender

			
		eststo: reg caregiverres_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Positive significant effect
			xtreg caregiverres_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid) 	//Positive significant effect - Robust estimate			

			predict cgs
			by cgsex: sum cgs  				//Disaggregation of effect size by gender
			
			
		eststo: reg cgpse_score 	   period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Positive significant effect
			xtreg cgpse_score 		 period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid)	//Positive significant effect - Robust estimate				

			predict ps
			by cgsex: sum ps  				//Disaggregation of effect size by gender
			
			
		eststo: reg g_attitude_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Negative in-significant very small effect	
			xtreg g_attitude_score 	 period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid) 	//Negative in-significant very small effect - Robust estimate		

			predict gt
			by cgsex: sum gt 				//Disaggregation of effect size by gender

			
		eststo: reg g_practice_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Positive in-significant very small effect		
			xtreg g_practice_score   period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid)	//Positive in-significant very small effect		

			predict gp
			by cgsex: sum gp  				//Disaggregation of effect size by gender

			
		eststo: reg pss				 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid)					//Negative in-significant effect
			xtreg pss 				 period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, fe i(cgid) cluster(hhid) 	//Negative in-significant effect		
			
			predict p
			by cgsex: sum p  				//Disaggregation of effect size by gender
			
	
		esttab using CGOs.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
			eststo clear
			
**Hetregenous effect size (by gender)
					
					eststo clear
		eststo: reg carechildrel_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1								
		eststo: reg carechildrel_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0								
					esttab using CGOs_O1.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

			eststo clear
		eststo: reg teachplay_score    period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1						
		eststo: reg teachplay_score    period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0						
					esttab using CGOs_o2.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

			eststo clear
		eststo: reg caregiverres_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1					
		eststo: reg caregiverres_score period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0					
					esttab using CGOs_o3.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

			eststo clear
		eststo: reg cgpse_score 	   period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1					
		eststo: reg cgpse_score 	   period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0					
					esttab using CGOs_o4.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
		
			eststo clear
		eststo: reg g_attitude_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1					
		eststo: reg g_attitude_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0						
					esttab using CGOs_o5.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

			eststo clear
		eststo: reg g_practice_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==1							
		eststo: reg g_practice_score 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid), if cgsex==0							
					esttab using CGOs_o6.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

			eststo clear
		eststo: reg pss				 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid),  if cgsex==1					
		eststo: reg pss				 	period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses, cluster(hhid),  if cgsex==0					
					esttab using CGOs_o7.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

		
** Here is a Stata written command to perform diff-in-diff automatically -- double checking the numbers produced by the regressions
	ssc install diff 		
	diff carechildrel_score, t(treatment) p(period)

** Here is additional commands for subgroup analysis (checking mean outcome difference between subgroups)	
	bysort period: sum(g_practice_score)

	tab period cgsex, sum(g_practice_score)

** Session termination	
	clear
	capture log close

		
*______________________________________________________________________________*

*-*-*-*-*-*-* 2- Diff-in-Diff estimation for children outcomes *-*-*-*-*-*-*-*																		
*______________________________________________________________________________*		
clear
use "full_data.dta"


** Data labeling 
label var locid "Location" 
label var nfamily "Family size" 
label var cgsex "Caregiver sex" 
label var spouseage "age of spouse" 
label var spouselive "live with spouse"
label var reside "lenght of residence"
label var bcked "Highest education" 
label var ses "living conditions"

** summary statitsics 
bysort treatment: tab period cgsex, row col
bysort treatment: tab period, sum (cgage)
bysort treatment: tab period, sum (bcked)
bysort treatment: tab period, sum (reside)
bysort treatment: tab period, sum (nfamily)
bysort treatment: tab period spouse, row col
bysort treatment: tab period spouselive, row col
bysort treatment: tab period, sum (ses)

asdoc ttest idelapct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p)
asdoc ttest motorpct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) rowappend
asdoc ttest litpct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	rowappend
asdoc ttest numpct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	rowappend
asdoc ttest soepct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	rowappend
asdoc ttest efpct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	rowappend
asdoc ttest atlpct if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p)	rowappend
	
	asdoc ttest idelapct if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p)  rowappend

asdoc ttest OVERALL if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) rowappend
asdoc ttest MOT if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	   rowappend
asdoc ttest COG if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p)     rowappend
asdoc ttest LANG if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p)    rowappend
asdoc ttest SEM if treatment==1 & period==1 , by(childsex_b), stat(obs mean dif p) 	   rowappend

	asdoc ttest OVERALL if treatment==1 & period==1 , by(cgsex), stat(obs mean dif p)  rowappend

	
** Checking for correlation between caregivers' outcomes and children's outcomes
xtset hhid period

eststo: xtreg idelapct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)								
eststo: xtreg motorpct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)						
eststo: xtreg litpct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)							
eststo: xtreg numpct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)								
eststo: xtreg soepct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)								
eststo: xtreg efpct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)					
eststo: xtreg atlpct period treatment locid nfamily cgsex spouseage spouselive reside bcked ses childage_b nt_cg carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)								
	esttab using IDELA_caregiver.rtf, label not r2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace			

eststo clear 

xtset hhid period
eststo: xtreg OVERALL period treatment locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg chilage2 carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)								
eststo: xtreg MOT period treatment locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg chilage2 carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)						
eststo: xtreg COG period treatment locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg chilage2 carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)						
eststo: xtreg LANG period treatment locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg chilage2 carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)							
eststo: xtreg SEM period treatment locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg chilage2 carechildrel_score teachplay_score caregiverres_score cgpse_score pss g_attitude_score g_practice_score, fe i(hhid)							

	esttab using CREDI_caregiver.rtf, label not r2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace			
	
eststo clear	
	
** Diff-in-Diff estimation

		*(1) creating an interaction variable between period and treatment (the coefficient of 
		*	 this is the effects size)

		gen did=period*treatment

		xtset hhid period	
		
		*(2) Run a regression for each outcome varibale and a fixed effect to test roboustness. 

		// For IDELA
		eststo: reg idelapct period treatment did																								//Large positive significant effect			
		eststo: reg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg 					//Positive significant effect			
			xtreg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg, fe i(hhid) 	//Positive significant effect - Robust estimate			

		esttab using IDELA_Overall.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
			eststo clear
			
		eststo: reg motorpct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg				//Positive In significant effect			
		eststo: reg litpct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg					//Positive In significant effect			
		eststo: reg numpct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg					//Positive significant effect			
		eststo: reg soepct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg					//Positive significant effect			
		eststo: reg efpct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg					//Positive In significant effect			
		eststo: reg atlpct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childsex_b eccd chilage1 nt_cg					//Negative In significant effect			

		esttab using IDELA_split.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
			eststo clear

		
		// For CREDI
		eststo: reg OVERALL period treatment did																					//positive in significant effect			
		eststo: reg OVERALL period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg					//Positive in significant effect			
			xtreg OVERALL period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg, fe i(hhid)			//Positive significant effect - Robustness issue	

		esttab using CREDI_Overall.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
			eststo clear

	
	
		eststo: reg MOT period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg					//Positive in significant effect			
		eststo: reg COG period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg					//Positive in significant effect			
		eststo: reg LANG period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg					//Positive in significant effect			
		eststo: reg SEM period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses nt_cg					//Positive in significant effect			

				esttab using CREDI_Split.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace
			eststo clear


** Heteregenous effect size (by caregiver sex)

	eststo clear
			eststo: reg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses chilage1  eccd nt_cg if childsex_b ==1
			eststo: reg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses chilage1  eccd nt_cg if childsex_b ==0
				esttab using IDELA_het_chsex.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

				
		eststo clear
			eststo: reg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childage_b eccd nt_cg if cgsex ==1
			eststo: reg idelapct period treatment did locid nfamily cgsex spouseage spouselive reside bcked ses childage_b eccd nt_cg if cgsex ==0
				esttab using IDELA_het_cgsex.rtf, label not ar2 varwidth(8) modelwidth(6) compress noconstant noobs scalars(F) starlevels(* 0.10 ** 0.05 *** 0.01) replace

					
** Session termination	
	clear
	capture log close





