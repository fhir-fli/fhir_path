
using QDM version '5.0'

valueset "Palliative Care": 'Palliative Care'
valueset "Care Services in Long-Term Residential Facility": 'Care Services in Long-Term Residential Facility'
valueset "Bipolar Disorder": 'Bipolar Disorder'
valueset "Personality Disorder": 'Personality Disorder'

parameter "Measurement Period" Interval<DateTime>

  ["Intervention, Order": "Palliative Care"] Order
    where Order.relevantPeriod starts 1 years or less before end of "Measurement Period"

  ["Encounter, Performed": "Care Services in Long-Term Residential Facility"] Order
    where Order.relevantPeriod starts 1 years or less before end of "Measurement Period"

  ["Patient Characteristic Expired"] Expired
    where Expired.expiredDateTime before end of "Measurement Period"

  ["Diagnosis": "Bipolar Disorder"] Diagnosis
    where Diagnosis.prevalencePeriod starts before end of "Measurement Period"

["Diagnosis": "Personality Disorder"] Diagnosis
  where Diagnosis.prevalencePeriod starts before end of "Measurement Period"
