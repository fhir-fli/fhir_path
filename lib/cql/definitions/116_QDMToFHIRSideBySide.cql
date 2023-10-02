
/*
CQL was designed from the start to support multiple data models. Various groups 
have been exploring the use of FHIR as the data model for quality measures, so 
this example will look at what some of the most commonly used data types in 
QDM could potentially look like in a FHIR-based measure.
*/

using QDM version '5.4'
using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'

valueset "Active Condition": 'TBD' // include 'active', 'recurrence', 'relapse' from ConditionClinicalStatusCodes
valueset "Comfort Measures": 'TBD'
valueset "Encounter Inpatient": 'TBD'
valueset "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival": 'TBD'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'TBD'

/*
Diagnosis

Example is from CMS72v8:
*/

// QDM:
  [Diagnosis: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"]

// FHIR Equivalent:
	[FHIR.Condition: "Intravenous or Intra arterial Thrombolytic (tPA) Therapy Prior to Arrival"] PriorTPA
	  where PriorTPA.clinicalStatus in "Active Condition"
		
// NOTE: onset and abatement need to be considered, and there is an outstanding question as to whether the
// clinical status element would always be consistent with onset and abatement.

/*
Encounter, Performed

Example is from MATGlobalCommonFunctions
*/

	["Encounter, Performed": "Encounter Inpatient"]

	[Encounter: "Encounter Inpatient"] EncounterInpatient
		where EncounterInpatient.status = 'finished'

// NOTE: Encounter, Performed in QDM can include "in progress" encounter, so it's
// not necessarily always just 'finished', the point is status needs to be checked
// consistent with measure intent.		
	
/*
Medication, Order

Example is from VTE-1
*/

  ["Medication, Order": "Low Dose Unfractionated Heparin for VTE Prophylaxis"]
	
  ["MedicationRequest": "Low Dose Unfractionated Heparin for VTE Prophylaxis"] M
	  where M.intent = 'order'

/*
Procedure, Performed

Example is from VTE-1
*/

  ["Procedure, Performed": "Comfort Measures"]
