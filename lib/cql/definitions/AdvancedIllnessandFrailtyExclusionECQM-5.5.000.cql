
/*
Update to 5.6. to get class attribute
*/
using QDM version '5.6'

include MATGlobalCommonFunctions version '6.2.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Acute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1083'
valueset "Advanced Illness": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1082'
valueset "Care Services in Long-Term Residential Facility": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1014'
valueset "Dementia Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1510'
valueset "ED": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1085'
valueset "Frailty Device": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1300'
valueset "Frailty Diagnosis": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1074'
valueset "Frailty Encounter": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1088'
valueset "Frailty Symptom": 'urn:oid:2.16.840.1.113883.3.464.1003.113.12.1075'
valueset "Nonacute Inpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1084'
valueset "Nursing Facility Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1012'
valueset "Observation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1086'
valueset "Outpatient": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1087'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>
