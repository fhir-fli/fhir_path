
using QICore version '4.1.1'

include FHIRHelpers version '4.1.000'

include QICoreCommon version '1.3.000'

valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001' 
valueset "Warfarin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.232'
valueset "Parenteral Anticoagulant": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.266'
valueset "INR": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.213'

parameter "Measurement Period" Interval<DateTime> default Interval[@2023-01-01T00:00:00.0Z, @2023-12-31T23:59:59.999Z]


/*
## Retrieve
*/

// https://hl7.org/fhir/us/qicore/profiles.html

  [Encounter]

  [Encounter: "Office Visit"]

  [Encounter: class ~ QICoreCommon."inpatient encounter"]

/*
## Where
*/

// https://cql.hl7.org/02-authorsguide.html#queries

  [Encounter] E
    where E.status = 'finished'

  [Encounter: "Office Visit"] E
    where E.status = 'finished'

  [Encounter: class ~ QICoreCommon."inpatient encounter"] E
    where E.status = 'in-progress'

  [Encounter] E
    where E.period during "Measurement Period"

/*
## With
*/

  ["Observation Blood Pressure Profile"]

// NOTE: Should be able to use during here, issue logged with the evaluator
  [Encounter] E
    with ["Observation Blood Pressure Profile"] O
      such that O.effective on or after start E.period
        and O.effective on or before end E.period

/*
## Without
*/

  [Encounter] E
    without ["Observation Blood Pressure Profile"] O
      such that O.effective on or after start E.period
        and O.effective on or before end E.period

/*
## Sort
*/


  "Numbers" N
    sort asc

  [Encounter] E
    sort by start of period

/*
## From
*/

/*
Patients who received warfarin and parenteral anticoagulation:
  * Five or more days, with an INR greater than or equal to 2 prior to discontinuation of parenteral therapy
  * OR: Five or more days, with an INR less than 2 and discharged on overlap therapy
  * OR: Less than five days and discharged on overlap therapy
*/

  [Encounter: class ~ QICoreCommon."inpatient encounter"] E
    where E.status in { 'completed', 'in-progress' }

  [MedicationAdministration: medication in Warfarin] M
    where M.status = 'completed'

  [MedicationAdministration: medication in "Parenteral Anticoagulant"] M
    where M.status = 'completed'

  ["US Core Laboratory Result Observation Profile": "INR"] O
    where O.status in { 'final', 'amended', 'corrected' }

/*
Patients who received warfarin and parenteral anticoagulation for five or more days 
with an INR greater than or equal to 2 prior to discontinuation of parenteral therapy
*/

/*
Requires that we can talk about the Encounter, the Warfarin Therapy and the Parenteral Anticoagulant Therapy, all at the same time
i.e. more than two sources at once
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P

/*
Next bring in the limitation that we want only warfarin and parenteral administrations that started during the encounter:
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  where W.effective starts during E.period
    and P.effective starts during E.period

/*
Next, we want to make sure that those two therapies overlap by at least 5 days:
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  where W.effective starts during E.period
    and P.effective starts during E.period
    and duration in days of (W.effective intersect P.effective) >= 5

/*
## Sub-queries
*/

/*
And finally, we want to make sure that the INR was greater than or equal to two prior to stopping parenteral anticoagulation
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  where W.effective starts during E.period
    and P.effective starts during E.period
    and duration in days of (W.effective intersect P.effective) >= 5
    and Last("INR Observations" I 
      where I.effective on or after start P.effective 
        and I.effective on or before end P.effective 
      sort by effective
    ).value >= 2

/*
This is the first of the criteria, but there are two other criteria that talk about the same values:

Patients who received warfarin and parenteral anticoagulation:
  * Five or more days, with an INR greater than or equal to 2 prior to discontinuation of parenteral therapy
  * OR: Five or more days, with an INR less than 2 and discharged on overlap therapy
  * OR: Less than five days and discharged on overlap therapy

*/

/*
## Let
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  let overlapDuration: duration in days of (W.effective intersect P.effective),
    endingINR: Last("INR Observations" I 
      where I.effective on or after start P.effective 
        and I.effective on or before end P.effective 
      sort by effective
    ).value
  where W.effective starts during E.period
    and P.effective starts during E.period
    and overlapDuration >= 5
    and endingINR >= 2
  return { overlapDuration: overlapDuration, endingINR: endingINR }


/*
## Return
*/

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  let overlapDuration: duration in days of (W.effective intersect P.effective),
    endingINR: Last("INR Observations" I 
      where I.effective on or after start P.effective 
        and I.effective on or before end P.effective 
      sort by effective
    ).value
  where W.effective starts during E.period
    and P.effective starts during E.period
    and overlapDuration >= 5
    and endingINR >= 2
  return E

  from "Inpatient Encounters" E,
    "Warfarin Administrations" W,
    "Parenteral Anticoagulant Administrations" P
  let overlapDuration: duration in days of (W.effective intersect P.effective),
    endingINR: Last("INR Observations" I 
      where I.effective on or after start P.effective 
        and I.effective on or before end P.effective 
      sort by effective
    ).value
  where W.effective starts during E.period
    and P.effective starts during E.period
    and (
      (overlapDuration >= 5 and endingINR >= 2)
        or (overlapDuration >= 5 and endingINR < 2 and P.effective overlaps after E.period)
        or (overlapDuration < 5 and P.effective overlaps after E.period)
    )
  return E


  Last("INR Observations" I 
      sort by effective
  )

  "Most Recent INR" I
    where I.value < 2

  from "Inpatient Encounters" E,
    "Most Recent INR" I

  "Inpatient Encounters" E
    with "Most Recent INR" I such that I.effective on or after start E.period

  "Most Recent INR" I
    with "Inpatient Encounters" E such that I.effective on or after start E.period

