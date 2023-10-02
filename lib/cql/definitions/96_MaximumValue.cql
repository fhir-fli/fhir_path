
/*
This example is based on CMS105v7 - Discharged on Statin Medication
The illustrates finding the maximum value of a type of laboratory test
*/

using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

valueset "Hemorrhagic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.212'
valueset "Ischemic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.247'
valueset "LDL-c": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.215'
valueset "Non-Elective Inpatient Encounter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.424'

parameter "Measurement Period" Interval<DateTime>
