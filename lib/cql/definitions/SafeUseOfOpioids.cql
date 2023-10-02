
using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'
codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1' 
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836' 
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837' 
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591' 
valueset "Benzodiazepines": 'urn:oid:2.16.840.1.113762.1.4.1125.1' 
valueset "Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.1010' 
valueset "Encounter ED and Observation Stay": 'urn:oid:2.16.840.1.113883.3.3157.1002.81' 
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 
valueset "Palliative care": 'urn:oid:2.16.840.1.113762.1.4.1125.3' 
valueset "Schedule II and Schedule III Opioids": 'urn:oid:2.16.840.1.113762.1.4.1125.2' 

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
