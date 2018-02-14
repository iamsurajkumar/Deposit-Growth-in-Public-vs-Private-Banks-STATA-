//////// PROBLEM 4 /////////////////////////////////////////


///////// 1: DATA EXTRACTION /////////////////////////////

clear // clearing the memory of the program

//// 1.1: Importing and cleaning the PRIVATE SECTOR BANKS Data ////

import excel "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\sbi.xlsx", sheet("As per Census 2001") cellrange(D5:V558)

/// 1.1.1: Data Cleaning

// Renaming 

rename D region
rename E state
rename F district

// For Q5
rename H deposit_private_2009_10Q4
rename I credit_private_2009_10Q4

// For Q4
rename K deposit_private_2009_10Q3
rename L credit_private_2009_10Q3

// For Q3
rename N deposit_private_2009_10Q2
rename O credit_private_2009_10Q2

// For Q2
rename R deposit_private_2009_10Q1
rename S credit_private_2009_10Q1

// For Q1
rename U deposit_private_2008_9Q4
rename V credit_private_2008_9Q4

// Droping Variables
drop G J M P Q T // droping reporting variables


// Droping unnecessary observattions
drop in 1/3 // deleting first 3 observation of empty cells

// Droping cumulative sum of distric rows(that is state rows) from the dataset
drop if region == ""
drop if state == "" & district == ""

// Creating a variable for to showcase that it is for private sector

// Destring data 
destring, replace

// Labelling the entire data
label data "Private Sector Banks Data"

//

describe

// Saving the data
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\private.dta", replace


/// 1.2 Data 

/*

reshape long ht, i(famid birth) j(age)
reshape long ht wt, i(famid birth) j(age)
reshape long name  inc, i(famid) j(dadmom) string 

*/

//////////////////////////////////////////////////////////////////////////////
//// 1.2: Importing and cleaning the SBI AND ITS ASSOCIATES Data ////
clear 


import excel "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\sbi.xlsx", sheet("As per Census 2001") cellrange(D5:V675)


/// 1.1.1: Data Cleaning

// Renaming 

rename D region
rename E state
rename F district

// For Q5
rename H deposit_sbi_2009_10Q4
rename I credit_sbi_2009_10Q4

// For Q4
rename K deposit_sbi_2009_10Q3
rename L credit_sbi_2009_10Q3

// For Q3
rename N deposit_sbi_2009_10Q2
rename O credit_sbi_2009_10Q2

// For Q2
rename R deposit_sbi_2009_10Q1
rename S credit_sbi_2009_10Q1

// For Q1
rename U deposit_sbi_2008_9Q4
rename V credit_sbi_2008_9Q4

// Droping Variables
drop G J M P Q T // droping reporting variables


// Droping unnecessary observattions
drop in 1/3 // deleting first 3 observation of empty cells

// Droping cumulative sum of distric rows(that is state rows) from the dataset
drop if region == ""
drop if state == "" & district == ""

// Creating a variable for to showcase that it is for private sector

// Destring data 
destring, replace

// Labelling the entire data
label data "SBI and Its ASSOCIATE Banks Data"

//

describe

// Saving the data
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\sbi.dta", replace


//////////////////////////////////////////////////////////////////////////////
//// 1.3: Importing and cleaning the NATIONALIZED Banks Data ////
clear 


import excel "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\nationalised.xlsx", sheet("As per Census 2001") cellrange(D5:V645)



/// 1.1.1: Data Cleaning

// Renaming 

rename D region
rename E state
rename F district

// For Q5
rename H deposit_national_2009_10Q4
rename I credit_national_2009_10Q4

// For Q4
rename K deposit_national_2009_10Q3
rename L credit_national_2009_10Q3

// For Q3
rename N deposit_national_2009_10Q2
rename O credit_national_2009_10Q2

// For Q2
rename R deposit_national_2009_10Q1
rename S credit_national_2009_10Q1

// For Q1
rename U deposit_national_2008_9Q4
rename V credit_national_2008_9Q4

// Droping Variables
drop G J M P Q T // droping reporting variables

// Droping unnecessary observattions
drop in 1/3 // deleting first 3 observation of empty cells

// Droping cumulative sum of distric rows(that is state rows) from the dataset
drop if region == ""
drop if state == "" & district == ""

// Creating a variable for to showcase that it is for private sector

// Destring data 
destring, replace

// Labelling the entire data
label data "NATIONALISED Banks Data"

//

describe

// Saving the data
save "E:\Mega\DSE\PhD\Jobs\CAFRAL\Programming Assignment\national.dta", replace

