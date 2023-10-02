
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include QICoreCommon


// Profiles

// QICoreAdverseEvent
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-adverseevent
  [AdverseEvent]

// QICoreAllergyIntolerance
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-allergyintolerance
  [AllergyIntolerance]

// QICoreBodyStructure
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-bodystructure
  [BodyStructure]

// QICoreCarePlan
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-careplan
  [CarePlan]

// QICoreCareTeam
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-careteam
  [CareTeam]

// QICoreClaim
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-claim
  [Claim]

// QICoreCommunication
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-communication
  [Communication] C
    where C.status in { 'preparation', 'in-progress', 'on-hold', 'completed' }

// QICoreCommunicationNotDone
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-communicationnotdone
  [Communication] C
    where C.status = 'not-done'

// QICoreCommunicationRequest
// @profile: 	http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-communicationrequest
  [CommunicationRequest]

// QICore 4.1.1
//// QICoreCondition
//// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-condition
//define Condition:
//  [Condition]

// QICore 5.0.0
// QICoreConditionProblemsHealthConcerns
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-condition-problems-health-concerns
  [Condition] Condition
    where Condition.hasCategory("problem-list-item")
      or Condition.hasCategory("health-concern")

// QICore 5.0.0
// QICoreConditionEncounterDiagnosis
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-condition-encounter-diagnosis
  [Condition] Condition
    where Condition.hasCategory("encounter-diagnosis")

// QICoreCoverage
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-coverage
  [Coverage]

// QICoreDevice
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-device
  [Device]

// QICoreDeviceNotRequested
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-devicenotrequested
  [DeviceRequest] D
    where D.status = 'completed'
      and D.doNotPerform() is true

// QICoreDeviceRequest
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-devicerequest
  [DeviceRequest] D
    where D.status in { 'draft', 'active', 'on-hold', 'revoked', 'completed' }
      and D.doNotPerform() is not true

// QICoreDeviceUseStatement
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-deviceusestatement
  [DeviceUseStatement]

// QICoreDiagnosticReportLab
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-diagnosticreport-lab
  [DiagnosticReport] D
    //where D.category ~ "http://terminology.hl7.org/CodeSystem/v2-0074#LAB"

// QICoreDiagnosticReportNote
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-diagnosticreport-note
  [DiagnosticReport] D

// QICoreEncounter
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter
  [Encounter]

  Encounter E
    where E.status = 'finished'

// QICoreFamilyMemberHistory
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-familymemberhistory
  [FamilyMemberHistory]

// QICoreFlag
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-flag
  [Flag]

// QICoreGoal
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-goal
  [Goal]

// QICoreImagingStudy
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-imagingstudy
  [ImagingStudy]

// QICoreImmunization
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-immunization
  [Immunization] I
    where I.status = 'completed'

// QICoreImmunizationEvaluation
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-immunizationevaluation
  [ImmunizationEvaluation]

// QICoreImmunizationNotDone
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-immunizationnotdone
  [Immunization] I
    where I.status = 'not-done'

// QICoreImmunizationRecommendation
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-immunizationrec
  [ImmunizationRecommendation]

// USCoreImplantableDevice
// @profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
  [Device]

// QICoreLocation
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-location
  [Location]

// QICoreMedication
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medication
  [Medication]

// QICoreMedicationAdministration
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationadministration
  [MedicationAdministration] M
    where M.status in { 'in-progress', 'on-hold', 'completed' }

// QICoreMedicationAdministrationNotDone
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-mednotadministered
  [MedicationAdministration] M
    where M.status = 'not-done'

// QICoreMedicationDispense
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationdispense
  [MedicationDispense] D
    where D.status in { 'preparation', 'in-progress', 'on-hold', 'completed' }

// QICoreMedicationDispenseDeclined
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationdispensedeclined
  [MedicationDispense] D
    where D.status in { 'cancelled', 'declined' }

// QICoreMedicationNotRequested
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-mednotrequested
  [MedicationRequest] R
    where R.status = 'completed'
      and R.doNotPerform is true

/*
  ["MedicationRequest": medication in "Antithrombotic Therapy"] NoAntithromboticDischarge
    where NoAntithromboticDischarge.doNotPerform is true
			and (NoAntithromboticDischarge.reasonCode in "Medical Reason"
				or NoAntithromboticDischarge.reasonCode in "Patient Refusal")
      and exists (NoAntithromboticDischarge.category C where FHIRHelpers.ToConcept(C) ~ FC."Community" or FHIRHelpers.ToConcept(C) ~ FC."Discharge")
      and NoAntithromboticDischarge.status = 'completed'
      and NoAntithromboticDischarge.intent = 'order'

  QICore.MedicationNotRequested NoAntithromboticDischarge
    where NoAntithromboticDischarge.medication in "Antithrombotic Therapy"
      and (NoAntithromboticDischarge.reasonCode in "Medical Reason"
        or NoAntithromboticDischarge.reasonCode in "Patient Refusal")
      and (NoAntithromboticDischarge.isCommunity() or NoAntithromboticDischarge.isDischarge())
      and NoAntithromboticDischarge.intent = 'order'

  ["MedicationNotRequested": medication in "Antithrombotic Therapy"] NoAntithromboticDischarge
    where (NoAntithromboticDischarge.reasonCode in "Medical Reason"
        or NoAntithromboticDischarge.reasonCode in "Patient Refusal")
      and (NoAntithromboticDischarge.isCommunity() or NoAntithromboticDischarge.isDischarge())
      and NoAntithromboticDischarge.intent = 'order'
*/

// QICoreMedicationRequest
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationrequest
  [MedicationRequest] R
    where R.status in { 'active', 'on-hold', 'completed', 'draft' }
      and R.doNotPerform is not true

/*
  ["MedicationRequest": medication in "Antithrombotic Therapy"] Antithrombotic
    where exists (Antithrombotic.category C where FHIRHelpers.ToConcept(C) in { Global."Community", Global."Discharge" })
      and Antithrombotic.status in { 'active', 'completed' }
      and Antithrombotic.intent.value = 'order'

  QICore.MedicationRequest Antithrombotic
    where Antithrombotic.medication in "Antithrombotic Therapy"
      and (Antithrombotic.isCommunity() or Antithrombotic.isDischarge())
      and Antithrombotic.status in { 'active', 'completed' }
      and Antithrombotic.intent = 'order'

  [MedicationRequest: medication in "Antithrombotic Therapy"] Antithrombotic
    where (Antithrombotic.isCommunity() or Antithrombotic.isDischarge())
      and Antithrombotic.status in { 'active', 'completed' }
      and Antithrombotic.intent = 'order'
*/

// QICoreMedicationStatement
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-medicationstatement
  [MedicationStatement]

// QICoreNutritionOrder
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-nutritionorder
  [NutritionOrder]

// QICoreObservation
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation
  [Observation] O
    where O.status in { 'registered', 'preliminary', 'final', 'amended', 'corrected' }

// QICoreObservationCancelled
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observationcancelled
  [Observation] O
    where O.status = 'cancelled'

// QICoreLaboratoryResultObservation
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation-lab
  [Observation] O
    where O.status in { 'registered', 'preliminary', 'final', 'amended', 'corrected' }
      and O.isLaboratory()

// QICoreObservationClinicalTestResult
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation-clinical-test
  [Observation] O
    where O.status in { 'registered', 'preliminary', 'final', 'amended', 'corrected' }
      and O.isClinicalTest()

// QICoreObservationImagingResult
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation-imaging
  [Observation] O
    where O.status in { 'registered', 'preliminary', 'final', 'amended', 'corrected' }
      and O.isImaging()

// QICoreObservationSurvey
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-observation-survey
  [Observation] O
    where O.status in { 'registered', 'preliminary', 'final', 'amended', 'corrected' }
      and O.isSurvey()

// USCoreVitalSigns

// USCoreBloodPressure

// USCoreBMI

// USCoreBodyHeight

// USCoreBodyTemperature

// USCoreBodyWeight

// USCoreHeadCircumference

// USCoreHeartRate

// USCorePediatricBMIForAgeObservation

// USCorePediatricHeadOccipitalFrontCircumferencePercentile

// USCorePediatricWeightForHeightObservation

// USCore Pulse Oximetry

// USCoreRespiratoryRate

// USCoreSmokingStatus

// USCoreObservationSexualOrientation

// USCoreObservationSocialHistory

// USCoreObservationSDOHAssessment

// QICoreOrganization
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-organization
  [Organization]

// QICorePatient
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-patient
  [Patient]

// QICorePractitioner
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-practitioner
  [Practitioner]

// QICorePractitionerRole
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-practitionerrole
  [PractitionerRole]

// QICoreProcedure
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-procedure
  [Procedure] P
    where P.status in { 'preparation', 'in-progress', 'on-hold', 'completed' }

  Procedure P
    where P.status = 'completed'

/*
 [Procedure: "Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
	 where FlexibleSigmoidoscopy.status = 'completed'
		 and Global."Normalize Interval"(FlexibleSigmoidoscopy.performed) ends 5 years or less on or before end of "Measurement Period"

  QICore.ProcedurePerformed FlexibleSigmoidoscopy
    where FlexibleSigmoidoscopy.code in "Flexible Sigmoidoscopy"
      and FlexibleSigmoidoscopy.performed.toInterval() ends 5 years or less on or before end of "Measurement Period"
*/

// QICoreProcedureNotDone
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-procedurenotdone
  [Procedure] P
    where P.status = 'not-done'

/*
  ["Procedure": "Device Application"] DeviceApplied
    let DeviceNotDoneTiming: Global.GetExtension(DeviceApplied, 'qicore-recorded').value
    where (DeviceApplied.usedCode in "Intermittent pneumatic compression devices (IPC)"
      or DeviceApplied.usedCode in "Venous foot pumps (VFP)"
      or DeviceApplied.usedCode in "Graduated compression stockings (GCS)"
    )
      and  DeviceApplied.status = 'not-done'
    return {id: DeviceApplied.id, requestStatusReason: DeviceApplied.statusReason, authoredOn: DeviceNotDoneTiming}

  QICore.ProcedureNotDone DeviceApplied
    where DeviceApplied.code in "Device Application"
      and (DeviceApplied.usedCode in "Intermittent pneumatic compression devices (IPC)"
        or DeviceApplied.usedCode in "Venous foot pumps (VFP)"
        or DeviceApplied.usedCode in "Graduated compression stockings (GCS)")
    return {
      id: DeviceApplied.id,
      requestStatusReason: DeviceApplied.statusReason,
      authoredOn: DeviceApplied.recorded()
    }

*/

// QICoreRelatedPerson
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-relatedperson
  [RelatedPerson]

// QICoreServiceNotRequested
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-servicenotrequested
  [ServiceRequest] SR
    where SR.status = 'completed'
      and SR.doNotPerform is true

/*
  (["ServiceRequest": "Venous foot pumps (VFP)"]
    union ["ServiceRequest": "Intermittent pneumatic compression devices (IPC)"]
    union ["ServiceRequest": "Graduated compression stockings (GCS)"]
  ) DeviceOrder
    where DeviceOrder.status = 'completed'
      and DeviceOrder.doNotPerform is true

  QICore.ServiceNotRequested DeviceOrder
    where DeviceOrder.code in "Venous foot pumps (VFP)"
      or DeviceOrder.code in "Intermittent pneumatic compression devices (IPC)"
      or DeviceOrder.code in "Graduated compression stockings (GCS)"
*/

// QICoreServiceRequest
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-servicerequest
  [ServiceRequest] SR
    where SR.status in { 'draft', 'active', 'on-hold', 'completed' }
      and SR.doNotPerform is not true

/*
  (["ServiceRequest": "Comfort Measures"] P
    where P.intent = 'order'
  )
    union (["Procedure": "Comfort Measures"] InterventionPerformed
      where InterventionPerformed.status in {'completed', 'in-progress'}
    )

  (QICore.ServiceRequest SR
    where SR.code in "Comfort Measures"
      and SR.intent = 'order'
  )
    union (
      QICore.Procedure InterventionPerformed
        where InterventionPerformed.code in "Comfort Measures"
          and InterventionPerformed.status in { 'completed', 'in-progress' }
    )
*/

// QICoreSpecimen
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-specimen
  [Specimen]

// QICoreSubstance
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-substance
  [Substance]

// QICoreTask
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-task
  [Task] T
    where T.status in { 'draft', 'requested', 'received', 'accepted', 'ready', 'in-progress', 'on-hold', 'completed' }

// QICoreTaskRejected
// @profile: http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-taskrejected