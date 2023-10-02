
using QDM version '5.3'

// TODO: Given guidance from VSAC on not using versions, should these be versionless references to the code systems?
codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'
codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

// TODO: Location value sets for determining locations within a hospital system
// VSAC has the following relevant value sets already defined:
  // ICU Locations - 2.16.840.1.113883.3.666.5.2486 (SNOMED-CT (environment))
  // HealthCareServiceLocations - 2.16.840.1.113883.1.11.20275 (HL7 CDA R2.1 2017-06-09)
// In addition, HL7 V3/FHIR defines the following valueset:
  // http://build.fhir.org/v3/ServiceDeliveryLocationRoleType/vs.html
// TODO: These facility value sets should be compared/contrasted with 
// value sets such as Inpatient Encounter that are being used to determine location
// to ensure that measures will identify the appropriate set of encounters
valueset "Inpatient Facility": 'TBD'
valueset "Emergency Department": 'TBD'
valueset "Intensive Care Unit": 'TBD'

// TODO: This valueset currently contains a single code, should we use a direct-reference code instead?
// TODO: Need to reconcile with other emergency department visits
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
