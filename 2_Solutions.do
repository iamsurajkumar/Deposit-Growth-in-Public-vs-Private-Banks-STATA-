//////////////////////////////////////////////////////////////////////////
//////////////////////////// DATA AGGREGATIONS ///////////////////////////


/// Begining with data 
clear


// Load Private Bank Data
use "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\private.dta", clear

// Mergiing SBI Data
merge 1:1 region state district using "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\sbi.dta"
drop _merge

// Merging National Data
merge 1:1 region state district using "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\national.dta"
drop _merge

// Changing the Labels
label data "Total Banks Data"

// Saving and Outputing the district data
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\total.dta", replace

/////////////////////////////////////////////////////////////////////////////
///////////////////////// Creating Variables for PUBLIC SECTOR BANKS //////////

clear
use "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\total.dta"
// Droping all the credit variables
//drop credit*



//2009-10 Quarters Deposit variables

egen deposit_public_2009_10Q4 = rowtotal(deposit_sbi_2009_10Q4 deposit_national_2009_10Q4)
egen deposit_public_2009_10Q3 = rowtotal(deposit_sbi_2009_10Q3 deposit_national_2009_10Q3)
egen deposit_public_2009_10Q2 = rowtotal(deposit_sbi_2009_10Q2 deposit_national_2009_10Q2)
egen deposit_public_2009_10Q1 = rowtotal(deposit_sbi_2009_10Q1 deposit_national_2009_10Q1)

//2008-9 Quater Deposit Variable
egen deposit_public_2008_9Q4 = rowtotal(deposit_sbi_2008_9Q4 deposit_national_2008_9Q4)

//////////////////////////////////////////////////////////////////////////////
///////////////////////// SOLVING OUT PROBLEMS FROM ASSIGNMENT /////////////

/////////////////////////////// PART A  /////////////////////////////////////

// Calculating Private Deposit Growth Rate
gen deposit_private_growth_rate = (deposit_private_2009_10Q4 - deposit_private_2008_9Q4)/deposit_private_2008_9Q4
// missing values are generate for those districs which don't have any private banks


// Calculating Public Deposit Growth Rate
gen deposit_public_growth_rate = (deposit_public_2009_10Q4 - deposit_public_2008_9Q4)/deposit_public_2008_9Q4
/* Tiruppur district in tamil nadu doesn't have any data available for deposit_publi_2008_9Q4, thus stata generate
a missing value for it. It also dosn't have any private bank data. So It can be ignored for the analysis*/

// Dropping individual public sector banks variable such as deposit_sbi_2009_10Q2, deposit_national_2009_10Q2
//drop deposit_sbi* deposit_na*
/// Droping the SBI and National Banks
drop deposit_sbi* deposit_nat*



/////////////////////////////// PART B///////////////////////////////////////

// First lets drop those observations for which there is no private growth rate data available
drop if deposit_private_growth_rate == .


// Lets create Tercile Variables in Stata
sort deposit_private_growth_rate
xtile tercile = deposit_private_growth_rate, nquantiles(3) 

// Lets create panic flow variable, here 1 means panic flow is there, 0 otherwise
gen panic_flow = 1 if tercile == 1
replace panic_flow = 0 if tercile != 1
drop tercile

/////////////////////////////// PART C ///////////////////////////////////////



summarize deposit_public_growth_rate if panic_flow == 1, meanonly
scalar g1 = r(mean)
display(g1)

summarize deposit_public_growth_rate if panic_flow == 0, meanonly
scalar g2 = r(mean)
display(g2)



/////////////////////////////// PART D ///////////////////////////////////////


////// Creating graph with Panic Flows
twoway (line deposit_public_growth_rate deposit_private_growth_rate, sort) if panic_flow == 1, ytitle(Public Sector Banks Deposit Growth Rate) ytitle(, size(medlarge) color(black)) ylabel(-0.4(.1)0.3) ymtick(-0.3(0.05)0.4, nolabels grid) xtitle(Private Sector Banks Deposit Growth Rate) xtitle(, size(medlarge) color(black) margin(small)) xlabel(-0.4(.05).16, grid) title(Growth Rate Comparison) subtitle(contains only those districts which had panic flows) legend(off)
// Exporting Graph
graph export "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison with panic flows.png", as(png) replace

////// Creating graph with out Panic Flows
twoway (line deposit_public_growth_rate deposit_private_growth_rate, sort) if panic_flow == 0 & deposit_private_growth_rate < 0.7, ytitle(Public Sector Banks Deposit Growth Rate) ytitle(, size(medlarge) color(black)) ylabel(-0.3(.1)0.7) ymtick(-0.3(0.05)0.7, nolabels grid) xtitle(Private Sector Banks Deposit Growth Rate) xtitle(, size(medlarge) color(black) margin(small)) xlabel(0.1(.05)0.7, grid) title(Growth Rate Comparison) subtitle(contains those districts which did not had panic flows) note(Two sets of observations with growth rates more than 1 has been ignored) legend(off)
// Exporting Graph
graph save Graph "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison without panic flows.gph"
graph export "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison without panic flows.png", as(png) replace

/////////////////////////////// PART E ///////////////////////////////////////


egen district_dummy = group(district), label
drop district
rename district_dummy district 

/* Assumption: Since Heat Maps required 3 dimensional data. I assumed following points
x = growth rate 
y = district
z = district
*/

// Growth rate calcualtions of all banks

* Lets first calculate the combined deposit of private and public banks for each quater
egen deposit_2008_9Q4 = rowtotal(deposit_private_2008_9Q4 deposit_public_2008_9Q4)
egen deposit_2009_10Q4 = rowtotal(deposit_private_2009_10Q4 deposit_public_2009_10Q4)


* Now lets calculate the growth rate
gen all_growth_rate = (deposit_2009_10Q4-deposit_2008_9Q4)/deposit_2008_9Q4

/* Now Could not proceed further as no STATA went into infinite loop*/

/////////////////////////////// PART F///////////////////////////////////////

/// DISTRICTS THAT HAD PANIC FLOWS
ttest deposit_private_growth_rate == deposit_public_growth_rate if panic_flow == 1

/// DISTRICTS THAT HAD NO PANIC FLOWS
texsave ttest deposit_private_growth_rate == deposit_public_growth_rate if panic_flow == 0

/*
Regarding the part c of the problem. I am not able to understand the meaning of it. As subparts
of the problem are bullets not a and b. Also its not clear what is the meaning of the difference in the problem. 
However by guess it seems like a difference-in-difference approach.
*/

////////////////////////////// PART G //////////////////////////////////////

clear
use "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\total.dta"


////////////// First creating the required variables

// Temporary dropping deposit varialbes
//drop dep*
 
//2009-10 Quarters Credit variables

egen credit_public_2009_10Q4 = rowtotal(credit_sbi_2009_10Q4 credit_national_2009_10Q4)
egen credit_public_2009_10Q3 = rowtotal(credit_sbi_2009_10Q3 credit_national_2009_10Q3)
egen credit_public_2009_10Q2 = rowtotal(credit_sbi_2009_10Q2 credit_national_2009_10Q2)
egen credit_public_2009_10Q1 = rowtotal(credit_sbi_2009_10Q1 credit_national_2009_10Q1)

//2008-9 Quater credit Variable
egen credit_public_2008_9Q4 = rowtotal(credit_sbi_2008_9Q4 credit_national_2008_9Q4)


// Calculating Private credit Growth Rate
gen credit_private_growth_rate = (credit_private_2009_10Q4 - credit_private_2008_9Q4)/credit_private_2008_9Q4
// missing values are generate for those districs which don't have any private banks


// Calculating Public credit Growth Rate
gen credit_public_growth_rate = (credit_public_2009_10Q4 - credit_public_2008_9Q4)/credit_public_2008_9Q4
/* Tiruppur district in tamil nadu doesn't have any data available for credit_publi_2008_9Q4, thus stata generate
a missing value for it. It also dosn't have any private bank data. So It can be ignored for the analysis*/

// Dropping individual public sector banks variable such as credit_sbi_2009_10Q2, credit_national_2009_10Q2
drop credit_sbi* credit_na*



// Making Catogorical Variables
* For Districts
egen district_dummy = group(district), label
drop district
rename district_dummy district 

* For States
egen state_dummy = group(state), label
drop state
rename state_dummy state 

* For region
egen region_dummy = group(region), label
drop region
rename region_dummy region 


order state district 
order region

// Saving the output
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\main.dta", replace

clear
use "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\main.dta"

// Temporarily d deposit variables
order dep*
//drop dep*

///////////Part D   of this sub part tha is ploting the public sector bank and private sector bank growth rates 


////// Creating graph with Panic Flows
twoway (line credit_public_growth_rate credit_private_growth_rate, sort) if panic_flow == 1, ytitle(Public Sector Banks Credit Growth Rate) ytitle(, size(medlarge) color(black)) ylabel(-0.4(.1)0.7) ymtick(-0.4(0.05)0.7, nolabels grid) xtitle(Private Sector Banks Credit Growth Rate) xtitle(, size(medlarge) color(black) margin(small)) xlabel(-0.4(.1).9, grid) title(Growth Rate Comparison) subtitle(contains only those districts which had panic flows) legend(off)
// Exporting Graph
graph export "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison with panic flows_CREDIT.png", as(png) replace

////// Creating graph with out Panic Flows 
twoway (line credit_public_growth_rate credit_private_growth_rate, sort) if panic_flow == 0 & credit_private_growth_rate < 1 , ytitle(Public Sector Banks Deposit Growth Rate) ytitle(, size(medlarge) color(black)) ylabel(-0.3(.1)0.8) ymtick(-0.3(0.05)0.8, nolabels grid) xtitle(Private Sector Banks Deposit Growth Rate) xtitle(, size(medlarge) color(black) margin(small)) xlabel(-0.3(.1)1, grid) title(Growth Rate Comparison) subtitle(contains those districts which did not had panic flows) note(A set of observations with growth rates more than 1 has been ignored) legend(off)
// Exporting Graph
graph save Graph "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison without panic flows_CREDIT.gph", replace
graph export "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\Growth Comparison without panic flows_CREDIT.png", as(png) replace

/////////// Part E
/*Once again due to unclearity on the variables to be used for creating the heat maps. Also
some sample heatmap either took a lot of of time or went into infinite loops or were just a single point.
So I have decided not to try this part of the problem
*/

///////////////////////// REGRESSION  Model ////////////////////////////

/*
Assumptions:

1. Since the variable that is modelled is Credit Growth over the entire horizon of 5 Quarters. 
   It is assumed that this problem is of cross-sectional type rather than panel data or time series type.
2. Controls are assumed to be of the state in which the district belongs to, bank type (PSB or Private)
   and panic flow.
3. Since the private bank data are not availble for 112 districts. They have been ignored from the analysis
4. The effect quarter-wise variable has been ignored as the varible that is predicted is cumulative growth of 
	entire 5 quarters. So variables such as deposit_private_2008_9Q4 or deposit_public_2009_10Q4 effect has been
	ignored. It can also be be argued that growth_rate_deposit_ contains the effect all these quarter wise variable

*/


// Renaming variables for the transformation
rename deposit_private_growth_rate growth_rate_deposit_private
rename deposit_public_growth_rate growth_rate_deposit_public
rename credit_private_growth_rate growth_rate_credit_private
rename credit_public_growth_rate growth_rate_credit_public

/* Renaming can be done for quarter wise variable as well
rename deposit_private_2008_9Q4 deposit_2008_9Q4private
rename deposit_private_2009_10Q1 
rename deposit_private_2009_10Q2 
rename deposit_private_2009_10Q3 
rename deposit_private_2009_10Q4 
rename deposit_public_2009_10Q4 
rename deposit_public_2009_10Q3 
rename deposit_public_2009_10Q2 
rename deposit_public_2009_10Q1 
rename deposit_public_2008_9Q4
*/



//// Making Catogorical Variables
* For banktype
egen banktype_dummy = group(banktype), label
drop banktype
rename banktype_dummy banktype 

order growth* deposit* credit*

// Converting the data from wide format into long format
reshape long growth_rate_deposit_ growth_rate_credit_ , i(region state district) j(banktype) string
reshape wide


// Converting Model data to Regression Data
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\reg.dta"
use "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\reg.dta", clear

// Regression Models
reg growth_rate_credit_ growth_rate_deposit_ banktype state panic_flow
reg growth_rate_credit_ growth_rate_deposit_ banktype state panic_flow, robust
reg growth_rate_credit_ growth_rate_deposit_ banktype state panic_flow, robust


////////////////////////////////JUNK CODE BEGINS /////////////////////////////////////////////////
/*


// Growth rate calculations for Private Sector Banks
gen private_Q1 = (deposit_private_2009_10Q1 - deposit_private_2008_9Q4)/deposit_private_2008_9Q4
gen private_Q2 = (deposit_private_2009_10Q2 - deposit_private_2009_10Q1)/deposit_private_2009_10Q1
gen private_Q3 = (deposit_private_2009_10Q3 - deposit_private_2009_10Q2)/deposit_private_2009_10Q2 
gen private_Q4 = (deposit_private_2009_10Q4 - deposit_private_2009_10Q3)/deposit_private_2009_10Q3 

* Mean growth rate for private sector as follows
drop *_2
egen deposit_private_growth_rate_2 = rowtotal(private_Q*) 


// Growth rate calculations for Public sector Banks
gen public_Q1 = (deposit_public_2009_10Q1 - deposit_public_2008_9Q4)/deposit_public_2008_9Q4
gen public_Q2 = (deposit_public_2009_10Q2 - deposit_public_2009_10Q1)/deposit_public_2009_10Q1
gen public_Q3 = (deposit_public_2009_10Q3 - deposit_public_2009_10Q2)/deposit_public_2009_10Q2 
gen public_Q4 = (deposit_public_2009_10Q4 - deposit_public_2009_10Q3)/deposit_public_2009_10Q3 

// All banks
egen deposit_2009_10Q1 = rowtotal(deposit_private_2009_10Q1 deposit_public_2009_10Q1)
egen deposit_2009_10Q2 = rowtotal(deposit_private_2009_10Q2 deposit_public_2009_10Q2)
egen deposit_2009_10Q3 = rowtotal(deposit_private_2009_10Q3 deposit_public_2009_10Q3)

// All banks Growth Rate
gen all_Q1 = (deposit_2009_10Q1 - deposit_2008_9Q4)/deposit_2008_9Q4 
gen all_Q2 = (deposit_2009_10Q2 - deposit_2009_10Q1)/deposit_2009_10Q1
gen all_Q3 = (deposit_2009_10Q3 - deposit_2009_10Q2)/deposit_2009_10Q2 
gen all_Q4 = (deposit_2009_10Q4 - deposit_2009_10Q3)/deposit_2009_10Q3 



gen id = _n
replace id2 = -_n

hmap district id deposit_private_growth_rate





