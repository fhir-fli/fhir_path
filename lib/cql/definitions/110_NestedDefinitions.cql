
/*
This example is taken from CMS31v7 - Hearing Screening Prior To Hospital Discharge
The Denominator Exclusions in this measure exclude live birth encounters where the patient expired
and a complete hearing screening was not performed (because we don't want to exclude patients that 
expired where a complete hearing screening _was_ performed).

The issue is that the check for complete hearing screening is not restricted to the relevant
encounter, so if there are multiple encounters, an encounter that meets the criteria that the
patient expired but doesn't have an associated complete hearing screening might still not be
excluded if there is another encounter that doesn't meet the patient expired criteria but _does_
have an associated complete hearing screening.
*/


using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "SNOMEDCT:2017-09": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2017-09'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Live Birth Newborn Born in Hospital": 'urn:oid:2.16.840.1.113762.1.4.1046.6'
valueset "Medical Reasons": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.7'
valueset "Newborn Hearing Screen Left": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.3'
valueset "Newborn Hearing Screen Right": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.4'
valueset "Pass Or Refer": 'urn:oid:2.16.840.1.114222.4.1.214079.1.1.6'

code "Patient deceased during stay (discharge status = dead) (finding)": '371828006' from "SNOMEDCT:2017-09" display 'Patient deceased during stay (discharge status = dead) (finding)'

parameter "Measurement Period" Interval<DateTime>
