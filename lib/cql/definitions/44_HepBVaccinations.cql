
// This example comes from Child Immunization Status from NCQA
// Only the Hepatitis B vaccination criteria is presented here

using QDM version '5.3'

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'
codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

valueset "Hepatitis B Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1042'
valueset "Hepatitis B Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1216'
valueset "Hepatitis B Antigen Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1031'
valueset "Hepatitis B": 'urn:oid:2.16.840.1.113883.3.464.1003.110.12.1025'
valueset "Anaphylactic Reaction to Hepatitis B Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.199.12.1029'
valueset "Anti Hepatitis B Virus Surface Ab": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1073'
valueset "Hepatitis B Antigen Test Positive": 'urn:oid:2.16.840.1.113762.1.4.1116.11'
valueset "Newborn Hepatitis Vaccine Administered": 'urn:oid:2.16.840.1.113883.3.464.1004.1397'

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
