
using QDM version '5.3'

parameter "Measurement Period" Interval<DateTime>

/*
Blood transfusion event
*/

  ["Procedure, Performed": "Blood Transfusion"] P
    where P.relevantPeriod ends during "Measurement Period"

/*
CHF Diagnosis
*/

  ["Diagnosis": "CHF"]

/*
Chest X-ray
*/

  ["Procedure, Performed": "Chest X-ray"]

/*
Reduced pulse oximetry
*/

  ["Physical Exam, Performed": "Oxygen Saturation"] P
    where P.result < 90 '%'
    
/*
Adverse Events
Potentially could use adverse event, but there are terminology questions here
*/

  ["Adverse Event"]

/*
Adverse event within 24 hours of blood transfusion
*/
