
using QDM version '5.0'

valueset "Blood Pressure Visit": 'Blood Pressure Visit'
valueset "Delta systolic blood pressure": 'Delta systolic blood pressure'
valueset "Systolic Blood Pressure": 'Systolic Blood Pressure'

parameter "Measurement Period" Interval<DateTime>

  ["Encounter, Performed": "Blood Pressure Visit"] Encounter
    with ["Physical Exam, Performed": "Systolic Blood Pressure"] Systolic
      such that Systolic.relevantPeriod during Encounter.relevantPeriod
    where Encounter.relevantPeriod ends during "Measurement Period"
