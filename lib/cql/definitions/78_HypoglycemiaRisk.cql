
// Working definition of a denonimator for this measure:

/*
Patients 65 and older with type 2 diabetes whose diabetes started at least 90 days 
before the start of the measurement period (MP) who are on an antihyperglycemic 
medication other than metformin monotherapy and who have complex clinical status* 
or risks for hypoglycemia with a visit during the MP

*Complex clinical status includes having at least one of the conditions listed below:

****       Taking at least two antihyperglycemics including insulin or sulfonylureas in MP
·          Blindness in MP
·          Diabetic peripheral neuropathy in MP,
·          History of amputation of lower extremity
·          History of coronary artery bypass grafting, percutaneous coronary intervention, myocardial infarction, or stroke
·          Ischemic vascular disease in MP
****       At least three chronic conditions in MP: chronic heart failure, chronic kidney disease, dementia without complications, arthritis, cancer, depression, falls, hypertension
·          Oxygen dependent lung disease in MP
·          Chronic kidney disease requiring dialysis, or end state renal disease in MP
·          Hospice care in MP
·          Dementia and/or cognitive impairment with complications in MP
·          History of hypoglycemia requiring treatment
·          Last A1c >8.6% in year prior to MP
·          Last A1c >9.1% in year prior to MP
·          BMI < 26 in MP
·          Identified with macroalbuminuria (albumin to creatinine ratio > 300) in MP
·          Last serum creatinine concentration > 114.9 uMol/l in MP 
*/


/*
1. Taking at least two antihyperglycemics including insulin or sulfonylureas in MP
*/

valueset "Insulin": 'XXX'
valueset "Sulfonylureas": 'XXX'
valueset "Antihyperglycemics": 'XXX' // Including Insulin and Sulfonylureas
valueset "Antihyperglycemics Other Than Insulin or Sulfonylureas": 'XXX'

// Two potential approaches:

// 1) Define value sets that exclude the concepts and use that to identify: