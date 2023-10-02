
/*
  Based on CMS9v4
  Exclusive Breast Milk Feeding

  Episode-of-Care-Based Proportion Measure with multiple populations

  NOTE: This example is purposefully based on version 4 of the measure to allow
  for exploration of the expression of the "intention to breastfeed" concept.

  This example is a work in progress and should not be considered a final specification
  or recommendation for guidance. This example will help guide and direct the process
  of finding conventions and usage patterns that meet the needs of the various stakeholders
  in the measure development community.

*/

using QDM version '5.0'

valueset "Feeding Intention-Breast": 'urn:oid:2.16.840.1.113762.1.4.1045.29'
valueset "Galactosemia": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.35'
valueset "Single Live Birth": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.25)'
valueset "Single Live Born Newborn Born in Hospital": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.26'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Estimated Gestational Age at Birth": 'urn:oid:2.16.840.1.113762.1.4.1045.47'
valueset "Parenteral Nutrition": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.38'
valueset "Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.27'
valueset "Neonatal Intensive Care Unit (NICU)": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.75'
valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'

code "Normative No": 'No' from "SNOMED-CT"

parameter "Measurement Period" Interval<DateTime>


  ["Encounter, Performed": "Encounter Inpatient"] Encounter
    where duration in days of Encounter.relevantPeriod <= 120
      and end of Encounter.relevantPeriod in "Measurement Period"

  ["Physical Exam, Performed": "Estimated Gestational Age at Birth"] Age
    where (Age.result as Quantity) >= 259 days // 37 weeks

// NOTE: Gestational age may be calculated using the ACOG ReVITALize guidelines with
// Estimated Due Date (EDD)
// http://www.acog.org/about_acog/acog_departments/patient_safety_and_quality_improvement/~/media/departments/patient%20safety%20and%20quality%20improvement/201213issuesandrationale-gestationalageterm.pdf
// Needs to be the most recent exam associated with this pregnancy
/*
  Last(
    ["Physical Exam, Performed": "Estimated Due Date"] Exam
      sort by start of relevantPeriod
  ).result as DateTime

  (280 - (duration in days between "Estimated Due Date" and "Birth Date")) div 7
*/

  distinct (
    ["Diagnosis": "Single Live Birth"]
      union ["Diagnosis": "Single Live Born Newborn Born in Hospital"]
  )

  ["Diagnosis": "Galactosemia"]

  ["Procedure, Performed": "Parenteral Nutrition"]

  "Inpatient Encounter" Encounter
    with "Gestational Age at Birth <= 37 weeks" Age
      such that Age.relevantPeriod starts during Encounter.relevantPeriod
    with "Live Birth" Birth
      such that Birth.prevalencePeriod starts during Encounter.relevantPeriod
    without "Galactosemia Diagnosis" Diagnosis
      such that Diagnosis.prevalencePeriod starts during Encounter.relevantPeriod
    without "Parenteral Nutrition Procedure" Procedure
      such that Procedure.relevantPeriod starts during Encounter.relevantPeriod

// Region: Initial Population 1

  "Live Birth Infants without Parenteral Nutrition"

// EndRegion: Initial Population 1

// Region: Denominator 1

  "Initial Population 1"

// EndRegion: Denominator 1

// Region: Denominator Exclusions 1

  "Inpatient Encounter" Encounter
    where Encounter.facilityLocation in "Neonatal Intensive Care Unit (NICU)"
      or Encounter.dischargeDisposition in "Patient Expired"
      or Encounter.dischargeDisposition in "Discharge To Acute Care Facility"

// EndRegion: Denominator Exclusions 1

// Region: Numerator 1

  ["Substance, Administered": "Breast Milk"]

  ["Substance, Administered": "Dietary Intake Other than Breast Milk"]

  "Inpatient Encounter" Encounter
    with "Breast Milk Feeding" Feeding
      such that Feeding.relevantPeriod starts during Encounter.relevantPeriod
    without "Other Than Breast Milk Feeding" OtherFeeding
      such that OtherFeeding.relevantPeriod starts during Encounter.relevantPeriod

// EndRegion: Numerator 1

// Region: Numerator Exclusions 1
// NONE
// End Region: Numerator Exclusions 1

// Region: Denominator Exceptions 1
// NONE
// End Region: Denominator Exceptions 1

// Region: Stratification 1
// NONE
// End Region: Stratification 1

// Region: Initial Population 2

  "Live Birth Infants without Parenteral Nutrition"

// EndRegion: Initial Population 2

// Region: Denominator 2

// EndRegion: Denominator 2

// Region: Denominator Exclusions 2

// TODO: How do we indicate that this is the infant's birth date, not the mother's?
  (singleton from (["Patient Characteristic Birthdate"])).birthDatetime

// TODO: In the source measure, this is expressed as the "absence of an intention to breast feed",
// but this is not the same as the intended "presence of intention not to breast feed"
  "Inpatient Encounter" Encounter
    without ["Communication: From Patient To Provider": "Feeding Intention-Breast"] Communication
      such that Communication.authorDatetime 1 hour or less after "Infant Birth Date"

// NOTE: There is a LOINC concept for an Obstetrics Admission Note. We could potentially
// request an addition (with support from the American College of Obstetrics and Gynecology - ACOG)
// to the required assessment questions such as "Intent to breast feed" with normative answers of "yes" or "no"
// Then we could address the question posed in the measure with the following define:
// 78718-4 	Obstetrics and Gynecology Admission history and physical note
/*
  ["Assessment": "Obstetrics and Gynecology Admission"] Assessment
    where exists (
      Assessment.component Question
        where Question.code in "Intent to breast feed"
          and Question.result in "Normative No"
    )
*/

  "Denominator Exclusions 1"
    union "Intention Not To Breast Feed"

// EndRegion: Denominator Exclusions 2

// Region: Numerator 2

  "Numerator 1"

// EndRegion: Numerator 2

// Region: Numerator Exclusions 2
// NONE
// End Region: Numerator Exclusions 2

// Region: Denominator Exceptions 2
// NONE
// End Region: Denominator Exceptions 2

// Region: Stratification 2
// NONE
// End Region: Stratification 2

// Region: Supplemental Data Elements

  ["Patient Characteristic Ethnicity": "Ethnicity"] Characteristic
    return Characteristic.code

  ["Patient Characteristic Payer": "Payer"] Characteristic
    return Characteristic.code

  ["Patient Characteristic Race": "Race"] Characteristic
    return Characteristic.code
