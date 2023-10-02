
using QDM version '5.0'

valueset "Encounter Inpatient": 'Encounter Inpatient'
valueset "Emergency Department Visit": 'Emergency Department Visit'
valueset "Hospital Settings": '2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Patient": 'Psychiatric/Mental Health Patient'

parameter "Measurement Period" Interval<DateTime>

/*
Initial Population =
  AND: "Occurrence A of Encounter, Performed: Emergency Department Visit"
    <= 1 hour(s) ends before or concurrent with start of Occurrence A of $EncounterInpatient
*/

  "Inpatient Encounter" E
    with ["Encounter, Performed": "Emergency Department Visit"] ED
      such that ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod

/*
Measure Population =
  AND: Initial Population
*/

  "Initial Population"

/*
Measure Population Exclusions =
  OR: "Transfer From: Hospital Settings" <= 6 hour(s)
    ends before or concurrent with start of "Occurrence A of Encounter, Performed: Emergency Department Visit"
*/

  "Inpatient Encounter" E
    with ["Encounter, Performed": "Emergency Department Visit"] ED
      such that ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod
        and ED.admissionSource in "Hospital Settings"

/*
Measure Observation =
  Median:
    Datetimediff:
      "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"
      "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location arrival datetime)"
*/

  Last(
    ["Encounter, Performed": "Emergency Department Visit"] ED
      where ED.relevantPeriod ends 1 hour or less before start of Encounter.relevantPeriod
      sort by start of ED.relevantPeriod
  )

  duration in minutes of "Related ED Visit"(Encounter).locationPeriod

/*
Stratifications =
*/

/*
  Stratification 1 =
    AND NOT: Intersection of:
      Occurrence A of $EncounterInpatient
      "Encounter, Performed: Encounter Inpatient (principal diagnosis: Psychiatric/Mental Health Patient)"
*/

  "Inpatient Encounter" E
    where not (E.principalDiagnosis in "Psychiatric/Mental Health Patient")

/*
  Stratification 2 =
    AND: Intersection of:
      Occurrence A of $EncounterInpatient
      "Encounter, Performed: Encounter Inpatient (principal diagnosis: Psychiatric/Mental Health Patient)"
*/

  "Inpatient Encounter" E
    where E.principalDiagnosis in "Psychiatric/Mental Health Patient"

  "Inpatient Encounter" E
    where E.principalDiagnosis is null

/*
$EncounterInpatient =
  "Encounter, Performed: Encounter Inpatient" satisfies all:
    (length of stay <= 120 day(s))
    ends during "Measurement Period"
*/
