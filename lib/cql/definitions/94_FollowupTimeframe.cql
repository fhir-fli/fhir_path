
/*
This example is based on CMS159v7 - Depression Remission at Twelve Months
This example illustrates definning a followup timeframe and looking for events within that timeframe
*/

using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Contact or Office Visit": 'urn:oid:2.16.840.1.113762.1.4.1080.5'
valueset "Dysthymia": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.254'
valueset "Major Depression Including Remission": 'urn:oid:2.16.840.113883.3.67.1.101.3.2444'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]": '44261-6' 
  from "LOINC" display 'Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]'

parameter "Measurement Period" Interval<DateTime>
