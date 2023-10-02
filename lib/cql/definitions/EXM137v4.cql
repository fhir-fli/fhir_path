
/*
  Based on CMS 137v4
  Initiation and Engagement of Alcohol and Other Drug Dependence Treatment

  Patient-based Proportion Measure

  This example is a work in progress and should not be considered a final specification
  or recommendation for guidance. This example will help guide and direct the process
  of finding conventions and usage patterns that meet the needs of the various stakeholders
  in the measure development community.
*/

using QDM version '5.0'

valueset "Alcohol and Drug Dependence": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1001'
valueset "Alcohol and Drug Dependence Treatment": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1005'
valueset "Detoxification Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1059'
valueset "Discharge Services - Hospital Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1007'
valueset "Discharge Services - Hospital Inpatient Same Day Discharge": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1006'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1010'
valueset "Face-to-Face Interaction": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Hospital Inpatient Visit - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1004'
valueset "Hospital Observation Care - Initial": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1002'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'

valueset "Ethnicity CDCREC": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer SOP": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race CDCREC": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex AdministrativeGender": 'urn:oid:2.16.840.1.113762.1.4.1'

parameter "Measurement Period" Interval<DateTime>


  AgeInYearsAt(start of "Measurement Period") >= 13

  distinct (
    ["Encounter, Performed": "Office Visit"]
      union ["Encounter, Performed": "Emergency Department Visit"]
      union ["Encounter, Performed": "Detoxification Visit"]
      union ["Encounter, Performed": "Hospital Observation Care - Initial"]
      union ["Encounter, Performed": "Hospital Inpatient Visit - Initial"]
      union ["Encounter, Performed": "Discharge Services - Hospital Inpatient Same Day Discharge"]
      union ["Encounter, Performed": "Discharge Services - Hospital Inpatient"]
      union ["Encounter, Performed": "Face-to-Face Interaction"]
  )

  "Valid Encounters" Encounter
    where Encounter.relevantPeriod during "Measurement Period"

    ["Diagnosis": "Alcohol and Drug Dependence"]

  Interval[start of "Measurement Period", start of "Measurement Period" + 10 months]

  { First(
    "Alcohol and Drug Dependence Diagnosis" Diagnosis
      where Diagnosis.prevalencePeriod starts during "First Alcohol Drug Dependence Interval"
      sort by start of Diagnosis.prevalencePeriod
   )
 }

  "First Alcohol Drug Dependence" Diagnosis
    with "Encounters During Measurement Period" Encounter
      such that Diagnosis.prevalencePeriod starts during Encounter.relevantPeriod

  "In Demographic"
    and exists ("First Alcohol Drug Dependence Dx")

  "Initial Population 1"

  ["Encounter, Performed": "Alcohol and Drug Dependence Treatment"]
    union ["Encounter, Performed": "Psych Visit - Psychotherapy"]

  "Drug Dependence Treatment Or Psych Encounters" Encounter
    with "First Alcohol Drug Dependence Dx" Diagnosis
      such that Diagnosis.prevalencePeriod starts 14 days or less after start of Encounter.relevantPeriod

  ["Diagnosis": "Alcohol and Drug Dependence"] Diagnosis
    with "First Alcohol Drug Dependence Dx" FirstDiagnosis
      such that Diagnosis.prevalencePeriod starts 60 days or less after start of FirstDiagnosis.prevalencePeriod

  exists ("Drug Dependence Treatment Or Psych Visit")

  AgeInYearsAt(start of "Measurement Period") >= 13
    and AgeInYearsAt(start of "Measurement Period") < 18

  AgeInYearsAt(start of "Measurement Period") >= 18

  "In Demographic"
    and exists ("First Alcohol Drug Dependence Dx")

  "Initial Population 2"

  ["Diagnosis": "Alcohol and Drug Dependence"] Diagnosis
    with "First Alcohol Drug Dependence Dx" FirstDiagnosis
      such that Diagnosis.prevalencePeriod starts 60 days or less after start of FirstDiagnosis.prevalencePeriod

  "Drug Dependence Treatment Or Psych Encounters" Encounter
    with "Drug Dependence Treatment Or Psych Visit" Visit
      such that Visit.relevantPeriod starts 30 days or less after start of Encounter.relevantPeriod

  "Numerator 1"
    and Count("Drug Dependence Treatment Encounters A Month After Diagnosis") >= 2

  ["Patient Characteristic Ethnicity": "Ethnicity CDCREC"] Characteristic
    return Characteristic.code

  ["Patient Characteristic Payer": "Payer SOP"] Characteristic
    return Characteristic.code

  ["Patient Characteristic Race": "Race CDCREC"] Characteristic
    return Characteristic.code
