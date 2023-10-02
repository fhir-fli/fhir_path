
using QDM version '5.3'


/*
Functions are "expressions" that take "arguments"
*/

  ["Encounter, Performed": "Inpatient"]

/*calculates the difference in calendar days between the start and end of the given interval.*/
	difference in days between start of Value and end of Value

  "Inpatient Encounters" InpatientEncounter
    where "LengthInDays"(InpatientEncounter.relevantPeriod) < 120
    
  Encounter E
    let
      EDVisit: Last(["Encounter, Performed": "Emergency Department Visit"] ED
          where ED.relevantPeriod ends 1 hour or less on or before start of E.relevantPeriod
            sort by end of relevantPeriod
        )
    return Interval[Coalesce(start of EDVisit.relevantPeriod, start of E.relevantPeriod), end of E.relevantPeriod]
