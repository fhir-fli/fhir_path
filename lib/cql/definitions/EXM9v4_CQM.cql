
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using FHIR // version '1.4'

codesystem "Example Data Elements": 'http://example.org/dataelements'

valueset "Feeding Intention-Breast": '2.16.840.1.113762.1.4.1045.29'
valueset "Feeding Intention-Not-To-Breast": 'TBD' // Code '636111000124114' from "SNOMED-CT" display: 'Mother refuses to breastfeed (situation)'
valueset "Galactosemia": '2.16.840.1.113883.3.117.1.7.1.35'
valueset "Single Live Birth": '2.16.840.1.113883.3.117.1.7.1.25'
valueset "Single Live Born Newborn Born in Hospital": '2.16.840.1.113883.3.117.1.7.1.26'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Estimated Gestational Age at Birth": '2.16.840.1.113762.1.4.1045.47'
valueset "Parenteral Nutrition": '2.16.840.1.113883.3.117.1.7.1.38'
valueset "Breast Milk": '2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk": '2.16.840.1.113883.3.117.1.7.1.27'
valueset "Neonatal Intensive Care Unit (NICU)": '2.16.840.1.113883.3.117.1.7.1.75'
valueset "Patient Expired": '2.16.840.1.113883.3.117.1.7.1.309'
valueset "Discharge To Acute Care Facility": '2.16.840.1.113883.3.117.1.7.1.87'

valueset "Ethnicity CDCREC": '2.16.840.1.114222.4.11.837'
valueset "Payer SOP": '2.16.840.1.114222.4.11.3591'
valueset "Race CDCREC": '2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex AdministrativeGender": '2.16.840.1.113762.1.4.1'

parameter "Measurement Period" Interval<DateTime>

// NOTE: The patient in context is the infant, not the mother

    Interval[period."start".value, period."end".value]

    System.Quantity { value: quantity.value.value, unit: quantity.unit.value }

    System.Concept {
        codes: concept.coding C return System.Code { code: C.code.value, system: C.system.value, version: C.version.value, display: C.display.value },
        display: concept.text.value
    }

  [Encounter: "Encounter Inpatient"] Encounter
    where Encounter.status.value = 'finished'
      and duration in days of ToInterval(Encounter.period) <= 120
      and Encounter.period."end".value in "Measurement Period"

  [Observation: "Estimated Gestational Age at Birth"] Observation
    where Observation.status.value in { 'final', 'amended' }
      and ToQuantity(Observation.valueQuantity) >= 37 weeks

  ([Condition: "Single Live Birth"]
    union [Condition: "Single Live Born Newborn Born in Hospital"]) Condition
    where Condition.clinicalStatus.value = 'active'
      and Condition.verificationStatus.value = 'confirmed'

  [Procedure: "Parenteral Nutrition"] Procedure
    where Procedure.status.value = 'completed'

  [Condition: "Galactosemia"] Condition
    where Condition.clinicalStatus.value = 'active'
      and Condition.verificationStatus.value = 'confirmed'

  "Inpatient Encounter" Encounter
    with "Gestational Age at Birth <= 37 weeks" GestationalAge such that GestationalAge.effectiveDateTime.value in ToInterval(Encounter.period)
    with "Single Live Birth Condition" Birth such that Birth.onsetDateTime.value in ToInterval(Encounter.period)
    without "Galactosemia Diagnosis" Galactosemia such that Galactosemia.onsetDateTime.value in ToInterval(Encounter.period)
    without "Parenteral Nutrition Procedure" Nutrition such that Nutrition.performedDateTime.value in ToInterval(Encounter.period)

// Region: Initial Population 1

  "Live Birth Infants without Parenteral Nutrition"

// EndRegion: Initial Population 1

// Region: Denominator 1

  true

// EndRegion: Denominator 1

// Region: Denominator Exclusions 1

  "Inpatient Encounter" Encounter
    // TODO: Cannot perform this Location.type traversal because we cannot resolve references yet
    //where exists (Encounter.location Location where ToConcept(Location.type) in "Neonatal Intensive Care Unit (NICU)")
    where ((Encounter.hospitalization Hospitalization where ToConcept(Hospitalization.dischargeDisposition) in "Patient Expired") is not null)
      or ((Encounter.hospitalization Hospitalization where ToConcept(Hospitalization.dischargeDisposition) in "Discharge To Acute Care Facility") is not null)

// EndRegion: Denominator Exclusions 1

// Region: Numerator 1

  [MedicationAdministration: "Breast Milk"] Feeding
    where Feeding.status.value = 'completed'

  [MedicationAdministration: "Dietary Intake Other than Breast Milk"] OtherFeeding
    where OtherFeeding.status.value = 'completed'

  "Inpatient Encounter" Encounter
    with "Breast Milk Feeding" Feeding such that Feeding.effectiveTimeDateTime.value in ToInterval(Encounter.period)
    without "Other Than Breast Milk Feeding" OtherFeeding such that OtherFeeding.effectiveTimeDateTime.value in ToInterval(Encounter.period)

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

// NOTE: This assumes a value set exists, but since we are using the "Assessment" pattern in the connect-a-thon,
// we switch to the specific code definition below
//define "Intention Not To Breastfeed":
//  "Inpatient Encounter" Encounter
//    with [RiskAssessment: "Feeding Intention-Not-To-Breastfeed"] RiskAssessment
//      such that RiskAssessment.date in Encounter.period

// Using the specific code
  Code 'breastfeeding-intention' from "Example Data Elements"

  "Inpatient Encounter" Encounter
    with [RiskAssessment: "Intention Not To Breastfeed Code"] RiskAssessment
      such that RiskAssessment.date.value in ToInterval(Encounter.period)

  "Denominator Exclusions 1"
    union "Intention Not To Breastfeed"

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

// Region: Supplemental Data

/* TODO: Update these for FHIR, these are the QDM data elements...