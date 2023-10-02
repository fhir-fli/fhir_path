
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QUICK // version '1'

codesystem "SNOMED-CT": '2.16.840.1.113883.6.96' version '2016A'

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

parameter MeasurementPeriod Interval<DateTime>


  [Encounter: "Encounter Inpatient"] E
    where duration in days of E.period <= 120
      and end of E.period in MeasurementPeriod

  [Observation: "Gestational Age At Birth"] O
    where (singleton from O.component).valueQuantity >= 259 days // 37 weeks

  [Condition: "Single Live Birth"]
    union [Condition: "Single Live Born Newborn Born in Hospital"]

  [Procedure: "Parenteral Nutrition"]

  [Condition: "Galactosemia"]

  EncounterInpatient E
    with "Gestational Age at Birth <= 37 weeks" G such that G.effectiveDateTime in E.period
    with "Single Live Birth" B such that B.onsetDateTime in E.period
    without "Galactosemia" D such that D.onsetDateETime in E.period
    without "Parenteral Nutrition" P such that P.performedDateTime in E.period

// Region: Initial Population 1

  "Live Birth Infants without Parenteral Nutrition"

// EndRegion: Initial Population 1

// Region: Denominator 1

  InitialPopulation1

// EndRegion: Denominator 1

// Region: Denominator Exclusions 1

  EncounterInpatient E
    where exists (E.Location L where L.type in "Neonatal Intensive Care Unit (NICU)")
      or exists (E.hospitalization H where H.dischargeDisposition in "Patient Expired")
      or exists (E.hospitalization H where H.dischargeDisposition in "Discharge To Acute Care Facility")

// EndRegion: Denominator Exclusions 1

// Region: Numerator 1

// TODO: Are these really "MedicationAdministration"?
// Seems like a stretch but I don't see any other resource in FHIR/QUICK that would be a better fit...
  [MedicationAdministration: "Breast Milk"]

  [MedicationAdministration: "Dietary Intake Other than Breast Milk"]

  EncounterInpatient E
    with "Breast Milk Feeding" F such that F.effectiveDateTime in E.period
    without "Other Than Breast Milk Feeding" O such that O.effectiveDateTime in E.period
    //SCTID: 289081008 Unable to perform breast-feeding (finding)

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
  ["Patient Characteristic": "Birthdate"]

// Assuming a value set exists
  EncounterInpatient E
    with [RiskAssessment: "Feeding Intention-Not-To-Breastfeed"] R
      such that R.date in E.period


// Using the specific code
  EncounterInpatient E
    with [RiskAssessment: "$Breastfeeding Intention"] R
      such that R.date in E.period

/* Other options for representing negative breastfeeding intention
// NOTE: In the QDM, this is expressed as the "absence of an intention to breast feed",
// but this is not the same as the intended "presence of intention not to breast feed"
  EncounterInpatient E
    with [Communication] C
      such that C.sender is Patient
        and exists (C.recipient R where R is Practitioner)
        and C.sent <= 1 hour after start of "Infant Birth Date"
        // NOTE: This code may be temporary (situational?)
        // Could potentially relate it to the procedure as an assertion to overcome that? May need to be a different code altogether
        and C.category contains Code '636111000124114' from "SNOMED-CT" display: 'Mother refuses to breastfeed (situation)'

// Single Code Value-set versus inline Code
  EncounterInpatient E
    with [Communication: "Feeding Intention-Not-To-Breastfeed"]
      such that C.sender is Patient
        and exists (C.recipient R where R is Practitioner)
        and C.sent <= 1 hour after start of "Infant Birth Date"

  EncounterInpatient E
    with [Communication] C
      such that C.sender is Patient
        and C.category contains Code '636111000124114' from "SNOMED-CT" display: 'Mother refuses to breastfeed (situation)'
        and exists (C.recipient R where R is Practitioner)
        and C.sent <= 1 hour after start of "Infant Birth Date"
*/

  DenominatorExclusions1
    union "Intention Not To Breast Feed"

// EndRegion: Denominator Exclusions 2

// Region: Numerator 2
