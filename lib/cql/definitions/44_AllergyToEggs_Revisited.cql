
using QDM version '5.3'

valueset "Allergy to Eggs": 'urn:oid:2.16.840.1.113883.3.526.3.1253'

//parameter "Measurement Period" Interval<DateTime>


	["Diagnosis": "Allergy to Eggs"] Dx
		where Dx.prevalencePeriod overlaps "Measurement Period"
			and not ( Dx.prevalencePeriod starts 90 days or more after start of "Measurement Period" )
			and not ( Dx.prevalencePeriod ends 89 days or less after start of "Measurement Period" )

  ["Diagnosis": "Allergy to Eggs"] Dx
    where Dx.prevalencePeriod overlaps Date(year from "Measurement Period", 3, 31) //start of "Measurement Period" + 89 days
    


  { id: 'Allergy Starts Before, Continues Past', period: Interval[@2012-01-01, null] },
  { id: 'Allergy Starts Before, Ends Before', period: Interval[@2012-01-01, @2016-01-01] },
  { id: 'Allergy Starts Before, Ends During', period: Interval[@2012-01-01, @2017-02-21] },
  { id: 'Allergy Starts During, Continues Past', period: Interval[@2017-02-01, null] },
  { id: 'Allergy Starts During, Ends During', period: Interval[@2017-02-01, @2017-02-23] },
  { id: 'Allergy Starts During, Ends After', period: Interval[@2017-02-01, @2017-06-01] },
  { id: 'Allergy Starts After', period: Interval[@2017-04-01, null] },
  { id: 'Allergy Starts After, Ends After', period: Interval[@2017-04-01, @2017-08-01] }
}

  "Allergy Test Data" A
    where A.period overlaps after "Flu Season"
