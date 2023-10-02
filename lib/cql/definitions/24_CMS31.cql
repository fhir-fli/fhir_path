
using QDM version '5.0.2'

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'

codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1' 

valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836' 

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837' 

valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591' 

valueset "Live Birth Newborn Born in Hospital": 'urn:oid:2.16.840.1.113762.1.4.1046.6' 

valueset "Newborn Hearing Screen Left": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.3' 

valueset "Newborn Hearing Screen Right": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.4' 

valueset "Medical Reasons": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.7' 

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 

valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309' 

valueset "Pass Or Refer": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.6' 

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'

code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
