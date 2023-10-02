
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QDM

valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Hospital Settings": '2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Patient": '2.16.840.1.113883.3.117.1.7.1.299'

parameter "MeasurementPeriod" default Interval [@2012-01-01T00:00:00.0, @20113-01-01T00:00:00.0]


  ["Encounter, Performed": "Encounter Inpatient"] E
    where E.lengthOfStay <= 120 days
      and E.dischargeDatetime during "MeasurementPeriod"

  ["Encounter, Performed": "Emergency Department Visit"] ED
    with "Inpatient Encounter" E
      such that ED.facilityLocationDepartureDatetime 1 hour or less before E.facilityLocationArrivalDatetime

   exists "Inpatient Encounter"
    and exists "Emergency Department Encounters"

  ["Transfer From": "Hospital Settings"]T
   ["Encounter, Performed": "Emergency Department Visit"]ED
    with "Emergency Department Visit" ED
      such that T.stopDatetime <= 6 hours before ED.facilityLocationArrivalDatetime

                "Transfer From Hospital Setting"



     "Initial Population"

  "Emergency Department Encounters" E
    where E.facilityLocationDepartureDatetime is not null
        and E.facilityLocationArrivalDatetime is not null
    return minutes between E.facilityLocationArrivalDatetime and E.facilityLocationDepartureDatetime

  (["Encounter, Performed": "Encounter Inpatient"] E where NOT E.principalDiagnosis is "psychiatric/Mental Health Patient")
    and exists  "Inpatient Encounter"
