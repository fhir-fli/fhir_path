
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0' called FHIRHelpers

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct/731000124108'
codesystem "RoleCode": 'http://hl7.org/fhir/v3/RoleCode'
codesystem "Diagnosis Role": 'http://hl7.org/fhir/diagnosis-role'

valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Observation Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT" display 'Dead'
code "ER": 'ER' from "RoleCode" display 'Emergency room'
code "ICU": 'ICU' from "RoleCode" display 'Intensive care unit'
code "Billing": 'billing' from "Diagnosis Role" display 'Billing'

parameter "Measurement Period" Interval<DateTime>


	[Encounter: "Encounter Inpatient"] EncounterInpatient
		where EncounterInpatient.status = 'finished'
		    and "LengthInDays"(EncounterInpatient.period) <= 120
			and EncounterInpatient.period ends during "Measurement Period"

	DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezone from Value)

	days between ToDate(BirthDateTime)and ToDate(AsOf)

	CalendarAgeInDaysAt(BirthDateTime, Today())

	months between ToDate(BirthDateTime)and ToDate(AsOf)

	CalendarAgeInMonthsAt(BirthDateTime, Today())

	years between ToDate(BirthDateTime)and ToDate(AsOf)

	CalendarAgeInYearsAt(BirthDateTime, Today())

	difference in days between start of Value and end of Value

    singleton from (
        [Encounter: "Emergency Department Visit"] EDVisit
            where EDVisit.status = 'finished'
                and EDVisit.period ends 1 hour or less on or before start of FHIRHelpers.ToInterval(TheEncounter.period)
    )

	( "ED Visit"(TheEncounter) ) X
    return
        if X is null then TheEncounter.period
        else Interval[start of FHIRHelpers.ToInterval(X.period), end of FHIRHelpers.ToInterval(TheEncounter.period)]

	( "ED Visit"(TheEncounter) ) EDEncounter
    return
        if EDEncounter is null then TheEncounter.location
        else flatten { EDEncounter.location, TheEncounter.location }

	LengthInDays("Hospitalization"(TheEncounter))

	start of "Hospitalization"(TheEncounter)

	end of FHIRHelpers.ToInterval(TheEncounter.period)

	start of FHIRHelpers.ToInterval(First(
	    ( "Hospitalization Locations"(TheEncounter) ) HospitalLocation
			sort by start of FHIRHelpers.ToInterval(period)
	).period)

// TODO - fix these (must fetch Location resources and compare id to reference)
/*define function "Hospital Departure Time"(TheEncounter FHIR.Encounter):
	end of FHIRHelpers.ToInterval(Last(
	    ( "Hospitalization Locations"(TheEncounter) ) HospitalLocation
			sort by start of FHIRHelpers.ToInterval(period)
	).period)

	start of FHIRHelpers.ToInterval((
	    singleton from (
	        ( "Hospitalization Locations"(TheEncounter) ) HospitalLocation
				where HospitalLocation.type ~ "ER"
		)
	).period)

	First(
	    ( TheEncounter.location ) HospitalLocation
			where HospitalLocation.type ~ "ICU"
				and HospitalLocation.period during TheEncounter.period
			sort by start of FHIRHelpers.ToInterval(period)
	)*/




/*
*
*    CQFMeasures Common Logic
*
*/

  if onset is FHIR.dateTime then Interval[onset.value, onset.value]
	else if onset is FHIR.Period then FHIRHelpers.ToInterval(onset as FHIR.Period)
	else null

	if performed is FHIR.dateTime then Interval[performed.value, performed.value]
	else FHIRHelpers.ToInterval(performed as FHIR.Period)

	Last(Split(uri, '/'))

  Encounter.diagnosis D
    return singleton from ([Condition: id in "GetId"(D.condition.reference)])

// Returns the condition that is specified as the principal diagnosis for the encounter
	(singleton from (Encounter.diagnosis D where D.role ~ ToConcept("Billing") and D.rank = 1)) PD
		return singleton from ([Condition: id in "GetId"(PD.condition.reference)])

// Returns the location for the given location reference