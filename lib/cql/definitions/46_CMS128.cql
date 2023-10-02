
// This example is an excerpt of CMS128
// Only the relevant logic is included

using QDM version '5.3'

valueset "Antidepressant Medication": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1213'
valueset "Major Depression": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1007'

parameter "Measurement Period" Interval<DateTime>


// Consider using an Interval expression here to make the range more clear
	First(["Medication, Dispensed": "Antidepressant Medication"] DepMedDisp
			//where DepMedDisp.authorDatetime 270 days or less before start of "Measurement Period"
				//or DepMedDisp.authorDatetime 90 days or less after start of "Measurement Period"
				//or DepMedDisp.authorDatetime same as start of "Measurement Period"
			where DepMedDisp.authorDatetime in Interval[start of "Measurement Period" - 270 days, start of "Measurement Period" + 90 days]
			sort by authorDatetime
  )

// Use a within to make the range more clear