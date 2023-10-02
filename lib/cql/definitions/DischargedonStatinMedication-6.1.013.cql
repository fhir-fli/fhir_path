
using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global
include TJC_Overall version '1.4.000' called TJC

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "LDL-c": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.215'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Statin Allergen": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.423'
valueset "Statin Grouper": 'urn:oid:2.16.840.1.113762.1.4.1110.19'


	["Patient Characteristic Ethnicity": "Ethnicity"]

	["Patient Characteristic Payer": "Payer"]

	["Patient Characteristic Race": "Race"]

	["Patient Characteristic Sex": "ONC Administrative Sex"]

	["Allergy/Intolerance": "Statin Allergen"]

	["Medication, Discharge": "Statin Grouper"]

	["Medication, Not Discharged": "Statin Grouper"] NoStatinDischarge
		where NoStatinDischarge.negationRationale in "Medical Reason"
			or NoStatinDischarge.negationRationale in "Patient Refusal"

	TJC."Ischemic Stroke Encounter"

	TJC."Encounter with Principal Diagnosis and Age"

	( ( TJC."Ischemic Stroke Encounters with Discharge Status" )
			union TJC."Comfort Measures during Hospitalization"
	)

	TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Statin at Discharge" DischargeStatin
			such that DischargeStatin.authorDatetime during IschemicStrokeEncounter.relevantPeriod

	( ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
				with "Statin Not Given at Discharge" NoDischargeStatin
					such that NoDischargeStatin.authorDatetime during IschemicStrokeEncounter.relevantPeriod
		)
			union ( TJC."Ischemic Stroke Encounter" IschemicStrokeEncounter
					with "Statin Allergy" StatinAllergy
						such that StatinAllergy.prevalencePeriod starts on or before end of IschemicStrokeEncounter.relevantPeriod
			)
			union "Encounter with Max LDL less than 70 mg per dL"
	)
