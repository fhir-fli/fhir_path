
using QICore version '5.0.0'

include FHIRHelpers version '4.0.1'
include QICoreCommon version '2.0.000'
include CQMCommon version '2.0.000'

codesystem "Marital Status Codes": 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus'
codesystem "CDC Race and Ethnicity Codes": 'urn:oid:2.16.840.1.113883.6.238'
codesystem "CommunicationCategoryCodeSystem": 'http://terminology.hl7.org/CodeSystem/communication-category'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "CVX": 'http://hl7.org/fhir/sid/cvx'
codesystem "LOINC": 'http://loinc.org'
codesystem "TaskCodeSystem": 'http://hl7.org/fhir/CodeSystem/task-code'

valueset "Marital Status": 'http://hl7.org/fhir/ValueSet/marital-status'
valueset "CommunicationCodes": 'http://hl7.org/fhir/ValueSet/communication-category'
valueset "DeviceCodes": 'http://example.org/fhir/ValueSet/device-codes' // Random set of device codes from 'http://hl7.org/fhir/ValueSet/device-type'
valueset "Venous Foot Pumps (VFP)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.230'
valueset "ImmunizationCodes": 'http://example.org/fhir/ValueSet/immunization-codes' // Random set of immunization codes from 'http://hl7.org/fhir/us/core/ValueSet/us-core-vaccines-cvx'
valueset "MedicationCodes": 'http://example.org/fhir/ValueSet/medication-codes' // Random set of medication codes from 'http://hl7.org/fhir/ValueSet/medication-codes'
valueset "ObservationCodes": 'http://example.org/fhir/ValueSet/observation-codes' // Random set of observation codes from 'http://hl7.org/fhir/ValueSet/observation-codes'
valueset "ProcedureCodes": 'http://example.org/fhir/ValueSet/procedure-codes' // Random set of procedure codes from 'http://hl7.org/fhir/us/core/ValueSet/us-core-procedure-code'
valueset "Application of intermittent pneumatic compression devices (IPC)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.65'
valueset "TaskCodes": 'http://hl7.org/fhir/ValueSet/task-code'
valueset "NegationReasonCodes": 'http://hl7.org/fhir/us/qicore/ValueSet/qicore-negation-reason'

valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Non-Elective Inpatient Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.424'
valueset "Comfort Measures": 'http://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1001'
valueset "Present on Admission or Clinically Undetermined": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1147.197'
valueset "Pap Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Frailty Device": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.118.12.1300'
valueset "Statin Allergen": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.42'
valueset "Inactivated Polio Vaccine (IPV)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1219'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.39'
valueset "Dementia Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1510'
valueset "Antithrombotic Therapy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.62'
valueset "Medical Reason": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.473'
valueset "Patient Refusal": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.93'
valueset "Application of Intermittent Pneumatic Compression Devices (IPC)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.65'
valueset "Macular Edema Absent Findings": 'http://example.org/fhir/ValueSet/macular-edema-absent-findings'

code "Marital Status - Married": 'M' from "Marital Status Codes"
code "American Indian or Alaska Native": '1002-5' from "CDC Race and Ethnicity Codes"
code "Alaska Native": '1735-0' from "CDC Race and Ethnicity Codes"
code "CommunicationCode": 'alert' from "CommunicationCategoryCodeSystem" display 'Alert'
code "DeviceCode": '156009' from "SNOMED-CT" display 'Spine board'
code "ImmunizationCode": '01' from "CVX" display 'diphtheria, tetanus toxoids and pertussis vaccine'
code "MedicationCode": '26100' from "SNOMED-CT" display 'Codeine phosphate'
code "ObservationCode": '1-8' from "LOINC" display 'Acyclovir [Susceptibility]'
code "ProcedureCode": '7138802' from "SNOMED-CT" display 'Procedure'
code "TaskCode": 'approve' from "TaskCodeSystem" display 'Activate/approve the focal resource'
code "Macular edema absent (situation)": '428341000124108' from "SNOMED-CT" display 'Macular edema absent (situation)'

parameter "Measurement Period" Interval<DateTime> default Interval[@2023-01-01T00:00:00.000, @2024-01-01T00:00:00.000)


  AgeInYearsAt(start of "Measurement Period") between 50 and 75

  Patient.gender = 'male'

  Patient P
    where exists (P.race.ombCategory C where C ~ "American Indian or Alaska Native")
      and exists (P.race.detailed C where C ~ "Alaska Native")

  [Encounter: "Office Visit"]

  [Encounter: class ~ QICoreCommon."virtual"]

  [Encounter: "Office Visit"] OfficeVisit
    where OfficeVisit.status = 'finished'
      and OfficeVisit.period during "Measurement Period"

  ["Encounter": "Non-Elective Inpatient Encounter"] NonElectiveEncounter
    where NonElectiveEncounter.period.lengthInDays() <= 120

  ["Encounter": "Non-Elective Inpatient Encounter"] NonElectiveEncounter
    where duration in hours of NonElectiveEncounter.period >= 24

    ["Procedure": "Comfort Measures"] InterventionPerformed
        where InterventionPerformed.status in { 'completed', 'in-progress' }

  "Non-Elective Inpatient Encounter Less Than 120 Days" Encounter
    with "Comfort Measures Performed" ComfortMeasure
      such that start of ComfortMeasure.performed.toInterval() during Encounter.hospitalizationWithObservation()

  [ConditionProblemsHealthConcerns: Diabetes] Condition
    where Condition.isActive()

  [ConditionEncounterDiagnosis: Diabetes] Condition

  "Active Diabetes Conditions" Diabetes
    where Diabetes.prevalenceInterval() starts during "Measurement Period"

  "Non-Elective Inpatient Encounter Less Than 120 Days" IPEncounter
    where exists (IPEncounter.diagnosis D
      where D.condition.getCondition().code in "Diabetes"
        and D.diagnosisPresentOnAdmission in "Present on Admission or Clinically Undetermined"
    )

// Respiratory rate - 9279-1
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate
  [USCoreRespiratoryRateProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Heart rate - 8867-4
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate
  [USCoreHeartRateProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Oxygen saturation - 2708-6
// @profile: http://hl7.org/fhir/StructureDefinition/oxygensat
  ["observation-oxygensat"] O
    where O.status in { 'final', 'amended', 'corrected' }

// Body temperature - 8310-5
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature
  [USCoreBodyTemperatureProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Body height - 8302-2
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height
  [USCoreBodyHeightProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Head circumference - 9843-4
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference
  [USCoreHeadCircumferenceProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Body weight - 29463-7
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight
  [USCoreBodyWeightProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Body mass index - 39156-5
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi
  [USCoreBMIProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Blood pressure systolic and diastolic - 85354-9
// Systolic blood pressure - 8480-6
// Diastolic blood pressure - 8462-4
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure
  [USCoreBloodPressureProfile] BP
    where BP.status in { 'final', 'amended', 'corrected' }
      and BP.systolic.value < 140 'mm[Hg]'
      and BP.diastolic.value < 90 'mm[Hg]'

// USCore Smoking Status
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus
  ["USCoreSmokingStatusProfile"] O
    where O.status in { 'final', 'amended', 'corrected' }

// USCore Pediatric BMI for Age - 59576-9
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age
  [USCorePediatricBMIforAgeObservationProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// USCore Pediatric Weight for Height - 77606-2
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height
  [USCorePediatricWeightForHeightObservationProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// USCore Pulse Oximetry - 59408-5
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry
  [USCorePulseOximetryProfile] O
    where O.status in { 'final', 'amended', 'corrected' }

// Laboratory Result
  [LaboratoryResultObservation] O
    where O.status in { 'final', 'amended', 'corrected' }

// Clinical Test Result
  [ObservationClinicalTestResult] O
    where O.status in { 'final', 'amended', 'corrected' }

// Imaging Result
  [ObservationImagingResult] O
    where O.status in { 'final', 'amended', 'corrected' }

// Survey
  [ObservationSurvey] O
    where O.status in { 'final', 'amended', 'corrected' }

  [Observation: "Pap Test"] PapTest
    where PapTest.value is not null
      and PapTest.status in { 'final', 'amended', 'corrected', 'preliminary' }

  ["ObservationCancelled": "Pap Test"] PapTest
    where PapTest.notDoneReason in "Patient Refusal"

  ["MedicationAdministration": medication in "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
    where VTEMedication.status = 'completed'
      and VTEMedication.category ~ QICoreCommon."Inpatient"

  ["MedicationAdministrationNotDone": "Low Dose Unfractionated Heparin for VTE Prophylaxis"] VTEMedication
    where VTEMedication.category ~ QICoreCommon."Inpatient"
      and (VTEMedication.reasonCode in "Medical Reason" or VTEMedication.reasonCode in "Patient Refusal")

  ["MedicationRequest": medication in "Antithrombotic Therapy"] Antithrombotic
    where (Antithrombotic.isCommunity() or Antithrombotic.isDischarge())
      and Antithrombotic.status in { 'active', 'completed' }
      and Antithrombotic.intent = 'order'

  ["MedicationNotRequested": "Antithrombotic Therapy"] NoAntithromboticDischarge
    where (NoAntithromboticDischarge.reasonCode in "Medical Reason"
      or NoAntithromboticDischarge.reasonCode in "Patient Refusal")
      and (NoAntithromboticDischarge.isCommunity() or NoAntithromboticDischarge.isDischarge())
      and NoAntithromboticDischarge.status in { 'active', 'completed' }
      and NoAntithromboticDischarge.intent = 'order'

  ["MedicationDispense": "Dementia Medications"] MedicationDispense
    where MedicationDispense.status in { 'active', 'completed', 'on-hold' }

    ["MedicationDispenseDeclined": "Dementia Medications"] MedicationDispense
      where MedicationDispense.statusReason in "Medical Reason"
        or MedicationDispense.statusReason in "Patient Refusal"

  ["Procedure": "Application of Intermittent Pneumatic Compression Devices (IPC)"] DeviceApplied
    where DeviceApplied.status = 'completed'

  [ProcedureNotDone: "Application of Intermittent Pneumatic Compression Devices (IPC)"] DeviceNotApplied
    where DeviceNotApplied.statusReason in "Medical Reason"
      or DeviceNotApplied.statusReason in "Patient Refusal"

  ["ServiceRequest": "Application of intermittent pneumatic compression devices (IPC)"] DeviceOrdered
    where DeviceOrdered.status in { 'active', 'completed', 'on-hold' }

  ["ServiceNotRequested": "Application of intermittent pneumatic compression devices (IPC)"] DeviceNotOrdered
    where DeviceNotOrdered.reasonRefused in "Medical Reason"
      or DeviceNotOrdered.reasonRefused in "Patient Refusal"

  [DeviceRequest: "Frailty Device"] FrailtyDeviceOrder
    where FrailtyDeviceOrder.status in { 'active', 'on-hold', 'completed' }
      and FrailtyDeviceOrder.intent in { 'order', 'original-order', 'reflex-order', 'filler-order', 'instance-order' }

  ["DeviceNotRequested": "Venous Foot Pumps (VFP)"] DeviceNotOrdered
    where (DeviceNotOrdered.doNotPerformReason in "Medical Reason"
      or DeviceNotOrdered.doNotPerformReason in "Patient Refusal")
      and DeviceNotOrdered.status in { 'active', 'on-hold', 'completed' }

  ["AllergyIntolerance": "Statin Allergen"] StatinAllergyIntolerance
    where StatinAllergyIntolerance.clinicalStatus is null
      or StatinAllergyIntolerance.clinicalStatus ~ QICoreCommon."allergy-active"

 ["Immunization": "Inactivated Polio Vaccine (IPV)"] PolioVaccination
     where PolioVaccination.status = 'completed'

  ["ImmunizationNotDone": "Inactivated Polio Vaccine (IPV)"] PolioVaccination
    where PolioVaccination.statusReason in "Medical Reason"
      or PolioVaccination.statusReason in "Patient Refusal"

  ["Communication": "Macular edema absent (situation)"] MacularEdemaAbsentCommunicated
    with "Office Visit Encounters" EncounterDiabeticRetinopathy
      such that MacularEdemaAbsentCommunicated.sent after start of EncounterDiabeticRetinopathy.period

//> NOTE: This expression uses a _direct-reference code_ of "Macular edema absent (situation)" (i.e. referencing a specific code from a code system, rather than a value set consisting of multiple codes). For more information on using direct-reference codes in CQL expressions, refer to the [Codes](https://hl7.org/fhir/us/cqfmeasures/using-cql.html#codes) topic in the Quality Measure IG.

  ["CommunicationNotDone": "Macular Edema Absent Findings"] MacularEdemaAbsentNotCommunicated
    with "Office Visit Encounters" EncounterDiabeticRetinopathy
      such that MacularEdemaAbsentNotCommunicated.sent during EncounterDiabeticRetinopathy.period
    where MacularEdemaAbsentNotCommunicated.statusReason in "Medical Reason"
        or MacularEdemaAbsentNotCommunicated.statusReason in "Patient Refusal"

//> NOTE: The positive counterpart for this statement (Macular Edema Absence Communicated) uses a direct-reference code, and ideally the negative statement would as well. However, at this time, direct-reference codes cannot be used as the terminology target of a retrieve. Available workarounds for this issue are to either create a value set with the single required code, or to use the long-hand expression of the negation statement, as shown in the following example:
