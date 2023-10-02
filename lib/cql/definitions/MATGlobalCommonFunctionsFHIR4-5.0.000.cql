
/*@update: @@BTR 2020-03-31 ->
Incremented version to 5.0.000
Updated FHIR version to 4.0.1
Changed timezone keyword to timezoneoffset for use with CQL 1.4
Removed Normalize Onset in favor of more general Normalize Interval
@@@*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.001' called FHIRHelpers

codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
codesystem "AllergyIntoleranceClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical'
codesystem "AllergyIntoleranceVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification'
codesystem "Diagnosis Role": 'http://terminology.hl7.org/CodeSystem/diagnosis-role'
codesystem "LOINC": 'http://loinc.org'
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'
codesystem "ConditionVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-verification'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "RoleCode": 'http://hl7.org/fhir/v3/RoleCode'

valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Observation Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'

code "active": 'active' from "ConditionClinicalStatusCodes" display 'active'
code "allergy-active": 'active' from "AllergyIntoleranceClinicalStatusCodes" display 'allergy-active'
code "allergy-confirmed": 'confirmed' from "AllergyIntoleranceVerificationStatusCodes" display 'allergy-confirmed'
code "allergy-inactive": 'inactive' from "AllergyIntoleranceClinicalStatusCodes" display 'allergy-inactive'
code "allergy-refuted": 'refuted' from "AllergyIntoleranceVerificationStatusCodes" display 'allergy-refuted'
code "allergy-resolved": 'resolved' from "AllergyIntoleranceClinicalStatusCodes" display 'allergy-resolved'
code "allergy-unconfirmed": 'unconfirmed' from "AllergyIntoleranceVerificationStatusCodes" display 'allergy-unconfirmed'
code "Billing": 'billing' from "Diagnosis Role" display 'Billing'
code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Community": 'community' from "MedicationRequestCategory" display 'Community'
code "confirmed": 'confirmed' from "ConditionVerificationStatusCodes" display 'confirmed'
code "Dead": '419099009' from "SNOMEDCT" display 'Dead'
code "differential": 'differential' from "ConditionVerificationStatusCodes" display 'differential'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'
code "entered-in-error": 'entered-in-error' from "ConditionVerificationStatusCodes" display 'entered-in-error'
code "ER": 'ER' from "RoleCode" display 'Emergency room'
code "ICU": 'ICU' from "RoleCode" display 'Intensive care unit'
code "inactive": 'inactive' from "ConditionClinicalStatusCodes" display 'inactive'
code "provisional": 'provisional' from "ConditionVerificationStatusCodes" display 'provisional'
code "recurrence": 'recurrence' from "ConditionClinicalStatusCodes" display 'recurrence'
code "refuted": 'refuted' from "ConditionVerificationStatusCodes" display 'refuted'
code "relapse": 'relapse' from "ConditionClinicalStatusCodes" display 'relapse'
code "remission": 'remission' from "ConditionClinicalStatusCodes" display 'remission'
code "resolved": 'resolved' from "ConditionClinicalStatusCodes" display 'resolved'
code "unconfirmed": 'unconfirmed' from "ConditionVerificationStatusCodes" display 'unconfirmed'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)


  [Encounter: "Encounter Inpatient"] EncounterInpatient
  		where EncounterInpatient.status = 'finished'
  		    and "LengthInDays"(EncounterInpatient.period) <= 120
  			and EncounterInpatient.period ends during "Measurement Period"

  DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezoneoffset from Value)

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

  TheEncounter Visit
  		let ObsVisit: Last([Encounter: "Observation Services"] LastObs
  				where LastObs.period ends 1 hour or less on or before start of Visit.period
  				sort by end of period
  			),
  			VisitStart: Coalesce(start of ObsVisit.period, start of Visit.period),
  			EDVisit: Last([Encounter: "Emergency Department Visit"] LastED
  				where LastED.period ends 1 hour or less on or before VisitStart
  				sort by end of period
  			)
  		return Interval[Coalesce(start of EDVisit.period, VisitStart), end of Visit.period]

  "LengthInDays"("HospitalizationWithObservation"(Encounter))

  // TODO - fix these (must fetch Location resources and compare id to reference)
  /*define function "Hospital Departure Time"(TheEncounter FHIR.Encounter):
  	end of FHIRHelpers.ToInterval(Last(
  	    ( "Hospitalization Locations"(TheEncounter) ) HospitalLocation
  			sort by start of FHIRHelpers.ToInterval(period)
  	).period)
  define function "Emergency Department Arrival Time"(TheEncounter FHIR.Encounter):
  	start of FHIRHelpers.ToInterval((
  	    singleton from (
  	        ( "Hospitalization Locations"(TheEncounter) ) HospitalLocation
  				where HospitalLocation.type ~ "ER"
  		)
  	).period)
  define function "First Inpatient Intensive Care Unit"(TheEncounter FHIR.Encounter):
  	First(
  	    ( TheEncounter.location ) HospitalLocation
  			where HospitalLocation.type ~ "ICU"
  				and HospitalLocation.period during TheEncounter.period
  			sort by start of FHIRHelpers.ToInterval(period)
  	)*/

/**
*    CQFMeasures Common Logic
**/
  case
  	  when choice is FHIR.dateTime then
    	Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
  		when choice is FHIR.Period then
  		FHIRHelpers.ToInterval(choice as FHIR.Period)
  		when choice is FHIR.instant then
  			Interval[FHIRHelpers.ToDateTime(choice as FHIR.instant), FHIRHelpers.ToDateTime(choice as FHIR.instant)]
  		when choice is FHIR.Age then
  		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age),
  			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age) + 1 year)
  		when choice is FHIR.Range then
  		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).low),
  			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).high) + 1 year)
  		when choice is FHIR.Timing then
  		  Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute a single interval from a Timing type')
    when choice is FHIR.string then
      Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
  		else
  			null as Interval<DateTime>
  	end

  if condition.abatement is FHIR.dateTime then
  	  Interval[FHIRHelpers.ToDateTime(condition.abatement as FHIR.dateTime), FHIRHelpers.ToDateTime(condition.abatement as FHIR.dateTime)]
  	else if condition.abatement is FHIR.Period then
  	  FHIRHelpers.ToInterval(condition.abatement as FHIR.Period)
  	else if condition.abatement is FHIR.string then
    Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
  	else if condition.abatement is FHIR.Age then
  		Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(condition.abatement as FHIR.Age),
  			FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(condition.abatement as FHIR.Age) + 1 year)
  	else if condition.abatement is FHIR.Range then
  	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((condition.abatement as FHIR.Range).low),
  		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((condition.abatement as FHIR.Range).high) + 1 year)
  	else if condition.abatement is FHIR.boolean then
  	  Interval[end of "Normalize Interval"(condition.onset), condition.recordedDate)
  	else null

  Interval[start of "Normalize Interval"(condition.onset), end of "Normalize Abatement"(condition))

  Last(Split(uri, '/'))

  Encounter.diagnosis D
    return singleton from ([Condition] C where C.id = "GetId"(D.condition.reference))

  // Returns the condition that is specified as the principal diagnosis for the encounter
  // TODO: BTR 2019-07-30: Shouldn't need the FHIRHelpers reference here, investigate

  (singleton from (Encounter.diagnosis D where FHIRHelpers.ToInteger(D.rank) = 1)) PD
  		return singleton from ([Condition] C where C.id = "GetId"(PD.condition.reference))
  // Returns the location for the given location reference

  singleton from (
    [Location] L where L.id = GetId(reference.reference)
  )

/*NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the
CQL model info.*/
  domainResource.extension E
  	  where E.url = ('http://hl7.org/fhir/us/qicore/StructureDefinition/' + url)
  		return E

  singleton from "GetExtensions"(domainResource, url)

/*NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the
CQL model info.*/
  element.extension E
  	  where E.url = (url)
  		return E

  singleton from "GetExtensions"(element, url)

/*NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the
CQL model info.*/
  domainResource.extension E
  	  where E.url = ('http://hl7.org/fhir/StructureDefinition/' + url)
  		return E

  singleton from "GetBaseExtensions"(domainResource, url)

/*NOTE: Provenance is not the preferred approach, this is provided only as an illustration
for what using Provenance could look like, and is not a tested pattern*/
  singleton from ([Provenance: target in resource.id])
