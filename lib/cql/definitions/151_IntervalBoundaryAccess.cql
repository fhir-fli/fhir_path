
/*
This issue is related to [CQM-4013](https://oncprojectracking.healthit.gov/support/browse/CQM-4013)

CMS111v9
Consider the following restriction on the end of the locationPeriod:
*/

  /*Constrains the inpatient encounter to having an ED visit with a decision to admit (assessment or order) to inpatient and ED facility location period is not null*/
  from
    Global."Inpatient Encounter" EncounterInpatient
    let LastEDVisit: LastEDEncounter(EncounterInpatient)
    where ( "AdmitDecisionUsingAssessmentDuringLastEDBeforeDeparture"(EncounterInpatient).relevantDatetime during LastEDVisit.relevantPeriod
        or "AdmitDecisionUsingEncounterOrderDuringLastEDandBeforeDeparture"(EncounterInpatient).authorDatetime during LastEDVisit.relevantPeriod
    )
      and exists ( LastEDVisit.facilityLocations Location
          where Location.code in "Emergency Department Visit"
            and
            end of Location.locationPeriod != maximum DateTime
      )

/*
Question:
What is the intended meaning of "end of Location.locationPeriod != maximum Datetime"
*/

/*
Answer:
Within CQL, interval boundaries can be _open_ or _closed_. Following the standard
mathematical definitions for intervals, an _open_ boundary means that the boundary
point is _excluded_ from the interval, whereas a _closed_ boundary means that the
point is _included_.

For example:
*/


/*
The closed interval [1, 10] means that the boundary points, 1 and 10, are included
in the range the interval covers.

Whereas the open interval:
*/


/*
excludes them, so this interval includes only the integers 2, 3, 4, ..., 9.

When CQL boundary points are _null_, the interpretation of the boundary depends
on whether the boundary is open or closed. An open null boundary indicates that the
null boundary means "unknown", whereas a closed null boundary indicates that the
null boundary means the interval continues to the beginning or end of the domain
of the point type.

The `start of` and `end of` operations for intervals return the beginning and
ending point of the interval. When the boundary point is null, the above interpretation
means in particular that:
*/


/*
For `ClosedNullBoundary`, the `end of` will return the maximum Integer, but
for `OpenNullBoundary` the `end of` will return null, or "unknown":
*/


/*
So looking at the expression:

`end of Location.locationPeriod != maximum Datetime`

is effectively asking whether the ending boundary of the interval is null and closed.

In this particular measure, the intent is to ensure that there is a value present
for the end of the locationPeriod, because that value is used subsequently to
calculate the admit decision time.

An alternative formulation to make that intent more clear would be to define
functions for HasEnd and HasStart:
*/

/*Given an interval, return true if the interval has an ending boundary specified (i.e. the end of the interval is not null and not the maximum DateTime value)*/
  not (end of period is null or end of period = maximum DateTime)

/* Given an interval, return true if the interval has a starting boundary specified (i.e. the start of the interval is not null and not the minimumDateTime value)*/
  not (start of period is null or start of period = minimum DateTime)

/*
These functions can then be used to more clearly communicate the intent of
ensuring that the interval has a value for the boundary.

Using this function in the original expression:
*/

  /*Constrains the inpatient encounter to having an ED visit with a decision to admit (assessment or order) to inpatient and ED facility location period is not null*/
  from
    Global."Inpatient Encounter" EncounterInpatient
    let LastEDVisit: LastEDEncounter(EncounterInpatient)
    where ( "AdmitDecisionUsingAssessmentDuringLastEDBeforeDeparture"(EncounterInpatient).relevantDatetime during LastEDVisit.relevantPeriod
        or "AdmitDecisionUsingEncounterOrderDuringLastEDandBeforeDeparture"(EncounterInpatient).authorDatetime during LastEDVisit.relevantPeriod
    )
      and exists ( LastEDVisit.facilityLocations Location
          where Location.code in "Emergency Department Visit"
            and HasEnd(Location.locationPeriod)
      )

  if (HasEnd(period)) then
    end of period
  else
    start of period

  if (HasStart(period)) then
    start of period
  else
    end of period

//Latest(NormalizeInterval(Procedure.relevantDateTime, Procedure.relevantPeriod))

  Latest(NormalizeInterval(pointInTime, period))
