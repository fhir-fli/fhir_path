
using QDM version '5.0'

valueset "BP Screening Encounter Codes": 'BP Screening Encounter Codes'
valueset "Diastolic Blood Pressure": 'Diastolic Blood Pressure'
valueset "Systolic Blood Pressure": 'Systolic Blood Pressure'

parameter "Measurement Period" Interval<DateTime>

  Last(
    ["Encounter, Performed": "BP Screening Encounter Codes"] Encounter
      with ["Physical Exam, Performed": "Diastolic Blood Pressure"] Diastolic
        such that Encounter.relevantPeriod overlaps Diastolic.relevantPeriod and Diastolic.result is not null
      with ["Physical Exam, Performed": "Systolic Blood Pressure"] Systolic
        such that Encounter.relevantPeriod overlaps Systolic.relevantPeriod and Systolic.result is not null
      sort by start of Encounter.relevantPeriod
  )

  Last(
    ["Physical Exam, Performed": "Systolic Blood Pressure"] Systolic
      with "Most Recent BP Screening Encounter" Encounter
        such that Systolic.relevantPeriod during Encounter.relevantPeriod
      sort by start of Systolic.relevantPeriod
  )

  Last(
    ["Physical Exam, Performed": "Diastolic Blood Pressure"] Diastolic
      with "Most Recent BP Screening Encounter" Encounter
        such that Diastolic.relevantPeriod during Encounter.relevantPeriod
      sort by start of Diastolic.relevantPeriod
  )
