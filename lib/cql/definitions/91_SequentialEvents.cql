
/*
This example is based on CMS117v7 - Childhood Immunization Status
The example illustrates finding sequential events
*/

using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "DTaP Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1214'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>


// NOTE: Simplified the union as not relevant to the example
	["Immunization, Administered": "DTaP Vaccine"] DTaPVaccination
		with ["Patient Characteristic Birthdate": "Birthdate"] BirthDate
			such that Global."CalendarAgeInDaysAt"(BirthDate.birthDatetime, DTaPVaccination.authorDatetime) 
        between 42 and 730
