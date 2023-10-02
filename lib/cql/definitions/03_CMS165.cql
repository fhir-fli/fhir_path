
using QDM version '5.0'

valueset "Adult Outpatient Visit": 'Adult Outpatient Visit'
valueset "Essential Hypertension": 'Essential Hypertension'
valueset "Diastolic Blood Pressure": 'Diastolic Blood Pressure'
valueset "Systolic Blood Pressure": 'Systolic Blood Pressure'

parameter "Measurement Period" Interval<DateTime>

  ["Encounter, Performed": "Adult Outpatient Visit"] Encounter
    with ["Diagnosis": "Essential Hypertension"] Diagnosis
      such that Encounter.relevantPeriod overlaps Diagnosis.prevalencePeriod
    with ["Physical Exam, Performed": "Diastolic Blood Pressure"] Diastolic
      such that Encounter.relevantPeriod overlaps Diastolic.relevantPeriod
        and Diastolic.result is not null
    with ["Physical Exam, Performed": "Systolic Blood Pressure"] Systolic
      such that Encounter.relevantPeriod overlaps Systolic.relevantPeriod
        and Systolic.result is not null

  First("Outpatient Visit" Visit sort by end of relevantPeriod desc)
