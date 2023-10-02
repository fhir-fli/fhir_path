
/*
This content is a work in progress and should not be considered a final specification
or recommendation for guidance.
*/

/*
The purpose of these functions is to constrain FHIR resource elements for measures authored by NCQA, 
based on QICore to QDM Mapping (http://build.fhir.org/ig/HL7/fhir-qi-core/qdm-to-qicore.html).
*/

using QICore version '4.1.1'

include FHIRHelpers version '4.2.000' called FHIRHelpers

codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'

code "laboratory": 'laboratory' from "ObservationCategoryCodes" display 'laboratory'
code "exam": 'exam' from "ObservationCategoryCodes" display 'exam'
code "survey": 'survey' from "ObservationCategoryCodes" display 'survey'
code "vital-signs": 'vital-signs' from "ObservationCategoryCodes" display 'vital-signs'
code "active": 'active' from "ConditionClinicalStatusCodes"


//Condition - Diagnosis
//Use this function when you need to constrain status to "active" only, otherwise when use in combination with QICoreCommon."ToPrevalenceInterval" where the defualt constraints are "active", "recurrence" and "relapse"
  Condition C
    where C.clinicalStatus ~ "active"
       
//Encounter - Encounter, Performed
  Enc E
    where E.status ~ 'finished'

  Enc E
    where E.status in { 'finished', 'in-progress' }

//Immunization - Immunization, Administered
  Immunization I
    where I.status ~ 'completed'

//MedicationDispense - Medication, Dispensed
  Med M
    where M.status ~ 'completed'

//Observation - Symptom
  Obs O
    where O.status in { 'preliminary', 'final', 'amended', 'corrected' }

//Observation - Diagnostic Study, Performed
  Obs O
    where O.status in { 'preliminary', 'final', 'amended', 'corrected' }

//Observation - Laboratory Test, Performed
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
    and exists ( O.category ObservationCategory
              where ( ObservationCategory ) ~ "laboratory"
          )

//Observation - Physical Exam, Performed
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
    and exists ( O.category ObservationCategory
              where ( ObservationCategory ) ~ "exam"
          )     

//Observation - Assessment, Performed
  Obs O
    where O.status in { 'final', 'amended', 'corrected' }
    and exists ( O.category ObservationCategory
              where ( ObservationCategory ) ~ "survey"
          )

//Procedure - Intervention, Performed; Procedure, Performed 
//No constraint on category to differentiate between intervention and procedure yet
  Proc P
    where P.status ~ 'completed'

//ServiceRequest - Intervention, Order; Diagnostic Study, Order; Laboratory Test, Order
  ServiceRequest S
    where S.status in { 'active', 'completed'}
    and S.intent = 'order'

//DeviceRequest - Device, Order
  DeviceRequest D
    where D.status in { 'active', 'completed'}
    and D.intent = 'order'

// MedicationRequest - Medication, Active
  MedicationRequest M
    where M.status = 'active'
    and M.intent = 'order' or M.intent = 'plan'
    // No constraints on M.requester yet
    // No constraints on M.category yet
    // No constraints on M.reported yet

// MedicationRequest - Medication, Order