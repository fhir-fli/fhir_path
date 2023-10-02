
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon called FC

include CURBConcepts called Cx


  [Condition: Cx."Community Acquired Pneumonia"] C
    where C.clinicalStatus in FC."Active Condition"
      and C.verificationStatus ~ FC."confirmed"

// Confusion
  [Observation: Cx."Confusion"] O
    where O.status in { 'final', 'amended', 'corrected' }

// Blood urea nitrogen
  [Observation: Cx."Blood urea nitrogen"] O
    where O.status in { 'final', 'amended', 'corrected' }

// Respiratory rate
  [Observation: Cx."Respiratory rate"] O
    where O.status in { 'final', 'amended', 'corrected' }

// Blood pressure
  [Observation: Cx."Blood pressure"] O
    where O.status in { 'final', 'amended', 'corrected' }

//define "Most recent blood pressure observation":

// Systolic blood pressure
//define "Systolic blood pressure":
//  "Blood Pressure Observations" O
//    return singleton from (O.component C where C.code in Cx."Systolic blood pressure").value

  (observation.component C where C.code ~ Cx."Systolic blood pressure").single().value

// Diastolic blood pressure
//define "Diatolic blood pressure":
//  "Blood Pressure Observations" O
//    return singleton from (O.component C where C.code in Cx."Diastolic blood pressure").value
