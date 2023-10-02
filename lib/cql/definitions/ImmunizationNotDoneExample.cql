
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include MATGlobalCommonFunctionsFHIR4 version '6.0.000' called Global

valueset "Influenza Vaccination Declined": 'urn:oid:2.16.840.1.113883.3.526.3.1255'
valueset "Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.526.3.1254'

valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1007'
valueset "Patient Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1008'
valueset "System Reason": 'urn:oid:2.16.840.1.113883.3.526.3.1009'

/* Contains all codes in:
  http://cts.nlm.nih.gov/fhir/2.16.840.1.113762.1.4.1021.56
  http://cts.nlm.nih.gov/fhir/2.16.840.1.113762.1.4.1021.58
  http://cts.nlm.nih.gov/fhir/2.16.840.1.113883.3.526.3.1009
*/
valueset "Negation Reason Codes": 'http://hl7.org/fhir/us/qicore/ValueSet/qicore-negation-reason'

/*
2021 AU also has valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
*/

parameter "Measurement Period" Interval<DateTime> default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)
