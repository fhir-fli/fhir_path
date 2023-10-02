
using FHIR version '3.0.0'

parameter "Measurement Period" Interval<DateTime>

/*
Blood transfusion event
*/

  ["Procedure": "Blood Transfusion"] P
    where P.performed ends during "Measurement Period"
      and P.status = 'completed'

/*
CHF Diagnosis
*/

  ["Condition": "CHF"] C
    where C.clinicalStatus = 'active'
      and C.verificationStatus = 'confirmed'

/*
Chest X-ray
*/

  ["Procedure": "Chest X-ray"] P
    where P.status = 'completed'

/*
Reduced pulse oximetry
*/

  ["Observation": "Oxygen Saturation"] P // Using LOINC 59408-5 
    where P.status in { 'final', 'amended' }
      and P.value < 90 '%'

/*
Adverse event within 24 hours of blood transfusion
*/
