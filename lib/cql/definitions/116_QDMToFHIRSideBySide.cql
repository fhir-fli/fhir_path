
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