
using QDM version '5.6'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143'
valueset "Outpatient Surgery Service": 'urn:oid:2.16.840.1.113762.1.4.1110.38'

parameter "Measurement Period" Interval<DateTime>


  ["Encounter, Performed": "Emergency Department Visit"]

  ["Encounter, Performed": "Encounter Inpatient"] EncounterInpatient
    where "LengthInDays"(EncounterInpatient.relevantPeriod)<= 120
      and EncounterInpatient.relevantPeriod ends during day of "Measurement Period"

/*@description: Returns an interval of date values extracted from the input interval of date-time values
@comment: This function returns an interval constructed using the `date from` extractor on the start
and end values of the input date-time interval. Note that using a precision specifier as part of a
timing phrase is preferred to communicate intent to perform day-level comparison, as well as for
general readability.*/
  Interval[date from start of period, date from end of period]

/*calculates the difference in calendar days between the start and end of the given interval.*/
  difference in days between start of Value and end of Value

/*returns list of all locations within an encounter, including locations for immediately prior ED visit.*/
  Encounter Visit
  	let EDVisit: Last(["Encounter, Performed": "Emergency Department Visit"] LastED
  			where LastED.relevantPeriod ends 1 hour or less on or before start of Visit.relevantPeriod
  			sort by
  			end of relevantPeriod
  	)
  	return if EDVisit is null then Visit.facilityLocations
  		else flatten { EDVisit.facilityLocations, Visit.facilityLocations }

/*Returns the arrival time in the ED for the encounter.*/
  start of First(("HospitalizationLocations"(Encounter))HospitalLocation
  		where HospitalLocation.code in "Emergency Department Visit"
  		sort by start of locationPeriod
  ).locationPeriod

/*Returns admission time for an encounter or for immediately prior emergency department visit.*/
  start of "Hospitalization"(Encounter)

/*Returns earliest arrival time for an encounter including any prior ED visit.*/
  start of First(("HospitalizationLocations"(Encounter))HospitalLocation
  		sort by start of locationPeriod
  ).locationPeriod

/*Hospitalization returns the total interval for admission to discharge for the given encounter, or for the admission of any immediately prior emergency department visit to the discharge of the given encounter.*/
  Encounter Visit
  	let EDVisit: Last(["Encounter, Performed": "Emergency Department Visit"] LastED
  			where LastED.relevantPeriod ends 1 hour or less on or before start of Visit.relevantPeriod
  			sort by
  			end of relevantPeriod
  	)
  	return Interval[Coalesce(start of EDVisit.relevantPeriod, start of Visit.relevantPeriod),
  	end of Visit.relevantPeriod]

/*Returns the length of stay in days (i.e. the number of days between admission and discharge) for the given encounter, or from the admission of any immediately prior emergency department visit to the discharge of the encounter*/
  LengthInDays("Hospitalization"(Encounter))

/*Returns the latest departure time for encounter including any prior ED visit.*/
  end of Last(("HospitalizationLocations"(Encounter))HospitalLocation
  		sort by start of locationPeriod
  ).locationPeriod

/*Hospital Discharge Time returns the discharge time for an encounter*/
  end of Encounter.relevantPeriod

/*Hospitalization with Observation and Outpatient Surgery Service returns the total interval from the start of any immediately prior emergency department visit, outpatient surgery visit or observation visit to the discharge of the given encounter.*/
  Encounter Visit
  	let ObsVisit: Last(["Encounter, Performed": "Observation Services"] LastObs
  			where LastObs.relevantPeriod ends 1 hour or less on or before start of Visit.relevantPeriod
  			sort by
  			end of relevantPeriod
  	),
  	VisitStart: Coalesce(start of ObsVisit.relevantPeriod, start of Visit.relevantPeriod),
  	EDVisit: Last(["Encounter, Performed": "Emergency Department Visit"] LastED
  			where LastED.relevantPeriod ends 1 hour or less on or before VisitStart
  			sort by
  			end of relevantPeriod
  	),
  	VisitStartWithED: Coalesce(start of EDVisit.relevantPeriod, VisitStart),
  	OutpatientSurgeryVisit: Last(["Encounter, Performed": "Outpatient Surgery Service"] LastSurgeryOP
  			where LastSurgeryOP.relevantPeriod ends 1 hour or less on or before VisitStartWithED
  			sort by
  			end of relevantPeriod
  	)
  	return Interval[Coalesce(start of OutpatientSurgeryVisit.relevantPeriod, VisitStartWithED),
  	end of Visit.relevantPeriod]

/*Hospitalization with Observation returns the total interval from the start of any immediately prior emergency department visit through the observation visit to the discharge of the given encounter*/
  Encounter Visit
  	let ObsVisit: Last(["Encounter, Performed": "Observation Services"] LastObs
  			where LastObs.relevantPeriod ends 1 hour or less on or before start of Visit.relevantPeriod
  			sort by
  			end of relevantPeriod
  	),
  	VisitStart: Coalesce(start of ObsVisit.relevantPeriod, start of Visit.relevantPeriod),
  	EDVisit: Last(["Encounter, Performed": "Emergency Department Visit"] LastED
  			where LastED.relevantPeriod ends 1 hour or less on or before VisitStart
  			sort by
  			end of relevantPeriod
  	)
  	return Interval[Coalesce(start of EDVisit.relevantPeriod, VisitStart),
  	end of Visit.relevantPeriod]

/*Hospitalization with Observation Length of Stay returns the length in days from the start of any immediately prior emergency department visit through the observation visit to the discharge of the given encounter*/
  "LengthInDays"("HospitalizationWithObservation"(Encounter))

/*First Inpatient Intensive Care Unit returns the first intensive care unit for the given encounter, without considering any immediately prior emergency department visit.*/
  First((Encounter.facilityLocations)HospitalLocation
      where HospitalLocation.code in "Intensive Care Unit"
        and HospitalLocation.locationPeriod during Encounter.relevantPeriod
      sort by start of locationPeriod
  )

/*Given a datetime and a period, returns the period (if a period is provided) or the interval beginning and ending on the datetime (if a datetime is provided)*/
  if pointInTime is not null then Interval[pointInTime, pointInTime]
    else if period is not null then period
    else null as Interval<DateTime>

/*Given an interval, return true if the interval has a starting boundary specified (i.e. the start of the interval is not null and not the minimum DateTime value)*/
  not ( start of period is null
      or start of period = minimum DateTime
  )

/*Given an interval, return true if the interval has an ending boundary specified (i.e. the end of the interval is not null and not the maximum DateTime value)*/
  not (
    end of period is null
      or
      end of period = maximum DateTime
  )

/*Given an interval, return the ending point if the interval has an ending boundary specified, otherwise, return the starting point*/
  if ( HasEnd(period)) then
  end of period
    else start of period

/*Given an interval, return the starting point if the interval has a starting boundary specified, otherwise, return the ending point*/
  if ( HasStart(period)) then start of period
    else
  end of period

/*Given a pointInTime or period, if the pointInTime is specified, returns the pointInTime, returns the ending point of the period if the period has an ending boundary specified, otherwise returns the starting point of the interval*/
  Latest(NormalizeInterval(pointInTime, period))

/*Given a pointInTime or period, if the pointInTime is specified, returns the pointInTime, returns the starting point of the period if the period has a starting boundary specified, otherwise returns the ending point of the period*/