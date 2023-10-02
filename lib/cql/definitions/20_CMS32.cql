
/*
CMS 32: Median Time from ED Arrival to ED Departure for Discharged ED Patients
Continuous Variable Episode-of-Care Measure

Median elapsed time from emergency department arrival to emergency room departure
for patients discharged from the emergency department.
*/

using QDM version '5.0.2'

valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Acute care hospital": '2.16.840.1.113883.3.666.5.684'
valueset "Patient Expired": '2.16.840.1.113883.3.117.1.7.1.309'
valueset "Psychiatric/Mental Health Patient": '2.16.840.1.113883.3.117.1.7.1.299'

parameter "Measurement Period" Interval<DateTime>


/*
Population Criteria
*/

/*
    Initial Population =
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" during "Measurement Period"
*/

  ["Encounter, Performed": "Emergency Department Visit"] ED
    where ED.relevantPeriod during "Measurement Period"

  "ED Visit"

/*
    Measure Population =
        AND: Initial Population
*/

  "Initial Population"

/*
    Measure Population Exclusions =
        OR: "Occurrence A of Encounter, Performed: Emergency Department Visit (discharge status: Patient Expired)"
        OR: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before or concurrent with start of "Encounter, Performed: Encounter Inpatient"
*/

  (
    "ED Visit" ED
      where ED.dischargeDisposition in "Patient Expired"
  )
    union (
      "ED Visit" ED
        with ["Encounter, Performed": "Encounter Inpatient"] E
          such that ED.relevantPeriod ends 1 hour or less before start of E.relevantPeriod
    )

/*
    Measure Observation =
        Median:
            Datetimediff:
                "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"
                "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location arrival datetime)"
*/

  duration in minutes of Encounter.locationPeriod

/*
    Stratifications =
*/

/*
        Stratification 1 =
            AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (principal diagnosis: Psychiatric/Mental Health Patient)"
*/

  "ED Visit" ED
    where ED.principalDiagnosis in "Psychiatric/Mental Health Patient"

/*
        Stratification 2 =
            AND: "Transfer To: Acute care hospital" <= 6 hour(s) starts after or concurrent with end of "Occurrence A of Encounter, Performed: Emergency Department Visit"
*/

  "ED Visit" ED
    where ED.dischargeDisposition in "Acute care hospital"

/*
        Stratification 3 =
            AND NOT: "Occurrence A of Encounter, Performed: Emergency Department Visit (principal diagnosis: Psychiatric/Mental Health Patient)"
            AND NOT: "Transfer To: Acute care hospital" <= 6 hour(s) starts after or concurrent with end of "Occurrence A of Encounter, Performed: Emergency Department Visit"
*/
