
using QDM version '5.0'

valueset "Rehabilitation Assessment": 'Rehabilitation Assessment'
valueset "Rehabilitation Therapy": 'Rehabilitation Therapy'
valueset "Patient Refusal": 'Patient Refusal'
valueset "Medical Reason": 'Medical Reason'
valueset "Non-Elective Inpatient Encounter": 'Non-Elective Inpatient Encounter'
valueset "Discharged to Rehabilitation Facility": 'Discharged to Rehabilitation Facility'

parameter "Measurement Period" Interval<DateTime>

  ["Encounter, Performed": "Non-Elective Inpatient Encounter"] Encounter
    where Encounter.lengthOfStay <= 120 days
      and Encounter.relevantPeriod ends during "Measurement Period"

  distinct (
    ["Procedure, Performed": "Rehabilitation Assessment"]
      union ["Procedure, Performed": "Rehabilitation Therapy"]
      union (
        ["Procedure, Not Performed": "Rehabilitation Assessment"] Procedure
          where Procedure.negationRationale in "Patient Refusal"
            or Procedure.negationRationale in "Medical Reason"
      )
  )
