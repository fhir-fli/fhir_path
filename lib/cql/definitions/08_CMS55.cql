
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
