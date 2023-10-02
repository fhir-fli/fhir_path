
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


	"Ischemic Stroke Encounter" IschemicStrokeEncounter
		where Max(["Laboratory Test, Performed": "LDL-c"] Ldl
				where Ldl.resultDatetime during Interval[Global."ToDate"(start of IschemicStrokeEncounter.relevantPeriod - 30 days), end of IschemicStrokeEncounter.relevantPeriod]
				return Ldl.result as Quantity
		)< 70 'mg/dL'

	"Encounter with Principal Diagnosis and Age" EncounterWithAge
		where EncounterWithAge.principalDiagnosis in "Ischemic Stroke"
    
	"All Stroke Encounter" AllStrokeEncounter
		with ["Patient Characteristic Birthdate"] BirthDate
			such that Global."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of AllStrokeEncounter.relevantPeriod)>= 18

	"Non Elective Inpatient Encounter" NonElectiveEncounter
		where NonElectiveEncounter.principalDiagnosis in "Hemorrhagic Stroke"
			or NonElectiveEncounter.principalDiagnosis in "Ischemic Stroke"
      