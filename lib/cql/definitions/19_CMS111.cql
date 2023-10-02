
/*
CMS 111 - Median Admit Decision Time to ED Departure Time for Admitted Patients
Continuous Variable Episode-of-Care Measure

Median time (in minutes) from admit decision time to time of discharge from the
emergency department for emergency department patients admitted to inpatient status.
*/

using QDM version '5.0.2'

valueset "Decision to Admit to Hospital Inpatient": '2.16.840.1.113883.3.117.1.7.1.295'
valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Hospital Settings": '2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Patient": '2.16.840.1.113883.3.117.1.7.1.299'

parameter "Measurement Period" Interval<DateTime>


/*
Population Criteria
*/

/*
    Initial Population =
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before or concurrent with start of Occurrence A of $EncounterInpatient
        AND: "Occurrence A of Encounter, Order: Decision to Admit to Hospital Inpatient" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"
*/

  ["Encounter, Performed": "Emergency Department Visit"] ED
    with ["Encounter, Order": "Decision to Admit to Hospital Inpatient"] O
      such that O.authorDatetime during ED.relevantPeriod

  "Inpatient Encounter" E
    with "ED Visit" ED
      such that ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod

/*
    Measure Population =
        AND: Initial Population
*/

  "Initial Population"

/*
    Measure Population Exclusions =
        OR: "Transfer From: Hospital Settings" <= 6 hour(s) ends before or concurrent with start of "Occurrence A of Encounter, Performed: Emergency Department Visit"
*/

  "Inpatient Encounter" E
    with "ED Visit" ED
      such that ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod
        and ED.admissionSource in "Hospital Settings"

/*
    Measure Observation =
        Median:
            Datetimediff:
                "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"
                "Occurrence A of Encounter, Order: Decision to Admit to Hospital Inpatient (start datetime)"
*/

  Last(
    "ED Visit" ED
      where ED.relevantPeriod ends 1 hour or less before start of Encounter.relevantPeriod
    sort by start of ED.relevantPeriod
  )

  Last(
    ["Encounter, Order": "Decision to Admit to Hospital Inpatient"] O
      where O.authorDatetime during "Related ED Visit"(Encounter).relevantPeriod
      sort by authorDatetime
  )

  minutes between "Admit Decision"(Encounter).authorDatetime
    and end of "Related ED Visit"(Encounter).locationPeriod

// As a single "from" query
/*
  duration in minutes of
    Last(
      from
        Encounter E,
        "ED Visit" ED,
        ["Encounter, Order": "Decision to Admit to Hospital Inpatient"] O
      where ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod
        and O.authorDatetime during ED.relevantPeriod
      return { admitDecisionDatetime: O.authorDatetime, departureDatetime: end of ED.locationPeriod }
      sort by admitDecisionDatetime
    )
*/

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
Data Criteria (QDM Variables)
*/

/*
    $EncounterInpatient =
        "Encounter, Performed: Encounter Inpatient" satisfies all:
            (length of stay <= 120 day(s))
            ends during "Measurement Period"
*/
