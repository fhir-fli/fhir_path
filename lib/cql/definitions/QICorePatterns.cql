
using QICore version '4.1.1'

include FHIRHelpers version '4.1.000'

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



  Patient P
    where P.gender = 'male'

  Patient P
    where P.active is true

  Patient P
    where P.birthDate before Today()

  Patient P
    where P.maritalStatus in "Marital Status"

  Patient P
    where P.maritalStatus ~ "Marital Status - Married"

  Patient P
    where P.deceased is false

  Patient P
    where P.deceased before Today()

  ["observation-bp"] BP
    where BP.SystolicBP.value < 140 'mm[Hg]'
      and BP.DiastolicBP.value < 90 'mm[Hg]'

  Patient P
    where P.birthsex = 'M'

  Patient P
    where exists (P.race.ombCategory C where C ~ "American Indian or Alaska Native")
      and exists (P.race.detailed C where C ~ "Alaska Native")

// Validate Encounter.diagnosis cardinality
    exists (First([Encounter] E where exists (E.diagnosis)).diagnosis)

// Validate ProcedureNotDone elements
    [ProcedureNotDone] P
      where P.performed is null
        and P.recorded on or before day of Today()
        //and exists (P.identifier)
        and P.status = 'not-done'
        and P.statusReason is not null
        //and P.category is not null
        and P.code is not null

// Validate NotDone...

/**
 * CommunicationNotDone
 */

/*
    ["CommunicationNotDone": CommunicationCode]

// TODO: Support this case, need to introduce a terminology contains operator
//define TestSpecificCommunicationNotDoneActual:
//    ["CommunicationNotDone": reasonCode ~ CommunicationCode]
//      union ["CommunicationNotDone": reasonCode contains CommunicationCode]

    ["CommunicationNotDone"] C
      where C.reasonCode ~ CommunicationCode
        or CommunicationCode in C.reasonCode

// NOTE: Consider using topic rather than reasonCode as the negation focus?
//define TestSpecificCommunicationNotDoneExplicit:
//    [Communication] C
//      where (C.reasonCode ~ CommunicationCode
//          or CommunicationCode in ValueSet { id: C.reasonCode.extension("http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-notDoneValueSet").value as String }
//        )
//        and C.status = 'not-done'
//        and C.recorded on or before day of Today()
//        and C.statusReason in NegationReasonCodes

    ["CommunicationNotDone": CommunicationCodes]

    ["CommunicationNotDone": reasonCode in CommunicationCodes]
      union ["CommunicationNotDone": reasonCode ~ CommunicationCodes]

// TODO: Fix CommunicationNotDone
    // Attempting to use results in "Could not resolve call to operator ''ToConcept(java.util.List)'' in library ''FHIRHelpers''"
    // This is because the underlying reasonCode element is 0..*, but the CommunicationNotDone profile constrains it to 1..1
    // So the ModelInfo presents it as a singular element, but is plural in the model
    // Not sure where best to address that discrepancy
    ["CommunicationNotDone"] C
      where C.reasonCode in CommunicationCodes
        or C.reasonCode ~ CommunicationCodes

//define TestGeneralCommunicationNotDoneExplicit:
//    [Communication] C
//      where (C.reasonCode in CommunicationCodes
//          or CommunicationCodes ~ ValueSet { id: C.reasonCode.extension("http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-notDoneValueSet").value as String }
//        )
//        and C.status = 'not-done'
//        and C.recorded on or before day of Today()
//        and C.statusReason in NegationReasonCodes
*/

/**
 * DeviceNotRequested
 */

// TODO: Because DeviceRequest.code[x] is a choice, even though the DeviceNotRequested profile constraints out the reference choice type,
    // the underlying DeviceRequest instance may still have code represented as a reference, and the ToConcept invocation will fail...
    // Changed the DeviceRequest/example instance to have a codeCodeableConcept instead of a codeReference as a temporary work around
    // Note also that the inclusion of "trusted" profile filtering in the data access layer addresses this issue
//define TestSpecificDeviceNotRequested:
//    ["DeviceNotRequested": DeviceCode]

// TODO: Support this use case
//define TestSpecificDeviceNotRequestedActual:
//    ["DeviceNotRequested": code ~ DeviceCode]
//      union ["DeviceNotRequested": code contains DeviceCode]

    [DeviceNotRequested] D
      where D.code ~ DeviceCode
        or DeviceCode in D.code

  ["DeviceNotRequested": "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested": code in "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested": code ~ "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested": code in "Venous Foot Pumps (VFP)"]
      union ["DeviceNotRequested": code ~ "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested"] D
      where D.code in "Venous Foot Pumps (VFP)"
        or D.code ~ "Venous Foot Pumps (VFP)"

    ["DeviceNotRequested"] D
      where D.code in "Venous Foot Pumps (VFP)"

    ["DeviceNotRequested"] D
      where D.code ~ "Venous Foot Pumps (VFP)"

/**
 * ImmunizationNotDone
 */

//define TestSpecificImmunizationNotDone:
//    ["ImmunizationNotDone": ImmunizationCode]

// TODO: Support this use case
//define TestSpecificImmunizationNotDoneActual:
//    ["ImmunizationNotDone": vaccineCode ~ ImmunizationCode]
//      union ["ImmunizationNotDone": vaccineCode contains ImmunizationCode]

    ["ImmunizationNotDone"] I
      where I.vaccineCode ~ ImmunizationCode
        or ImmunizationCode in I.vaccineCode

    ["ImmunizationNotDone": ImmunizationCodes]

    ["ImmunizationNotDone": vaccineCode in ImmunizationCodes]
      union ["ImmunizationNotDone": vaccineCode ~ ImmunizationCodes]

    ["ImmunizationNotDone"] I
      where I.vaccineCode in ImmunizationCodes
        or I.vaccineCode ~ ImmunizationCodes

/**
 * MedicationAdministrationNotDone
 */

//define TestSpecificMedicationAdministrationNotDone:
//    ["MedicationAdministrationNotDone": MedicationCode]

// TODO: Support this use case
//define TestSpecificMedicationAdministrationNotDoneActual:
//    ["MedicationAdministrationNotDone": medication ~ MedicationCode]
//      union ["MedicationAdministrationNotDone": medication contains MedicationCode]

    ["MedicationAdministrationNotDone"] I
      where I.medication ~ MedicationCode
        or MedicationCode in I.medication

    ["MedicationAdministrationNotDone": MedicationCodes]

    ["MedicationAdministrationNotDone": medication in MedicationCodes]
      union ["MedicationAdministrationNotDone": medication ~ MedicationCodes]

    ["MedicationAdministrationNotDone"] I
      where I.medication in MedicationCodes
        or I.medication ~ MedicationCodes


/**
 * MedicationDispenseNotDone
 */

/*
** Missing Valueset: http://cts.nlm.nih.gov/fhir/1.3.6.1.4.1.6997.4.1.2.268.13.35211.1.13.1.999.321 (Ophthalmic Antihistamines)

//define TestSpecificMedicationDispenseNotDone:
//    ["MedicationDispenseNotDone": MedicationCode]

// TODO: Support this use case
//define TestSpecificMedicationDispenseNotDoneActual:
//    ["MedicationDispenseNotDone": medication ~ MedicationCode]
//      union ["MedicationDispenseNotDone": medication contains MedicationCode]

    ["MedicationDispenseNotDone"] I
      where I.medication ~ MedicationCode
        or MedicationCode in I.medication

    ["MedicationDispenseNotDone": MedicationCodes]

    ["MedicationDispenseNotDone": medication in MedicationCodes]
      union ["MedicationDispenseNotDone": medication ~ MedicationCodes]

    ["MedicationDispenseNotDone"] I
      where I.medication in MedicationCodes
        or I.medication ~ MedicationCodes
*/

/**
 * MedicationNotRequested
 */

//define TestSpecificMedicationNotRequested:
//    ["MedicationNotRequested": MedicationCode]

// TODO: Support this use case
//define TestSpecificMedicationNotRequestedActual:
//    ["MedicationNotRequested": medication ~ MedicationCode]
//      union ["MedicationNotRequested": medication contains MedicationCode]

    ["MedicationNotRequested"] I
      where I.medication ~ MedicationCode
        or MedicationCode in I.medication

    ["MedicationNotRequested": MedicationCodes]

    ["MedicationNotRequested": medication in MedicationCodes]
      union ["MedicationNotRequested": medication ~ MedicationCodes]

    ["MedicationNotRequested"] I
      where I.medication in MedicationCodes
        or I.medication ~ MedicationCodes

/**
 * ObservationNotDone
 */

//define TestSpecificObservationNotDone:
//    ["ObservationNotDone": ObservationCode]

// TODO: Support this use case
//define TestSpecificObservationNotDoneActual:
//    ["ObservationNotDone": code ~ ObservationCode]
//      union ["ObservationNotDone": code contains ObservationCode]

    ["ObservationNotDone"] I
      where I.code ~ ObservationCode
        or ObservationCode in I.code

    ["ObservationNotDone": ObservationCodes]

    ["ObservationNotDone": code in ObservationCodes]
      union ["ObservationNotDone": code ~ ObservationCodes]

    ["ObservationNotDone"] I
      where I.code in ObservationCodes
        or I.code ~ ObservationCodes

/**
 * ProcedureNotDone
 */

//define TestSpecificProcedureNotDone:
//    ["ProcedureNotDone": ProcedureCode]

// TODO: Support this use case
//define TestSpecificProcedureNotDoneActual:
//    ["ProcedureNotDone": code ~ ProcedureCode]
//      union ["ProcedureNotDone": code contains ProcedureCode]

    ["ProcedureNotDone"] I
      where I.code ~ ProcedureCode
        or ProcedureCode in I.code

    ["ProcedureNotDone": "Application of intermittent pneumatic compression devices (IPC)"]

    ["ProcedureNotDone": code in "Application of intermittent pneumatic compression devices (IPC)"]
      union ["ProcedureNotDone": code ~ "Application of intermittent pneumatic compression devices (IPC)"]

    ["ProcedureNotDone"] I
      where I.code as Concept in "Application of intermittent pneumatic compression devices (IPC)"
        or I.code as ValueSet ~ "Application of intermittent pneumatic compression devices (IPC)"

/**
 * ServiceNotRequested
 */

//define TestSpecificServiceNotRequested:
//    ["ServiceNotRequested": ProcedureCode]

// TODO: Support this use case
//define TestSpecificServiceNotRequestedActual:
//    ["ServiceNotRequested": code ~ ProcedureCode]
//      union ["ServiceNotRequested": code contains ProcedureCode]

    ["ServiceNotRequested"] I
      where I.code ~ ProcedureCode
        or ProcedureCode in I.code

    ["ServiceNotRequested": "Application of intermittent pneumatic compression devices (IPC)"]

    ["ServiceNotRequested": code in "Application of intermittent pneumatic compression devices (IPC)"]
      union ["ServiceNotRequested": code ~ "Application of intermittent pneumatic compression devices (IPC)"]

    ["ServiceNotRequested"] I
      where I.code in "Application of intermittent pneumatic compression devices (IPC)"
        or I.code ~ "Application of intermittent pneumatic compression devices (IPC)"

/**
 * TaskNotDone
 */

//define TestSpecificTaskNotDone:
//    ["TaskNotDone": TaskCode]

// TODO: Support this use case
//define TestSpecificTaskNotDoneActual:
//    ["TaskNotDone": code ~ TaskCode]
//      union ["TaskNotDone": code contains TaskCode]

    ["TaskNotDone"] I
      where I.code ~ TaskCode
        or TaskCode in I.code

    ["TaskNotDone": TaskCodes]

    ["TaskNotDone": code in TaskCodes]
      union ["TaskNotDone": code ~ TaskCodes]
