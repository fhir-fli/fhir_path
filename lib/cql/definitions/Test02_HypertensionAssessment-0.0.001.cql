
using QDM version '5.3'

include AnnualWellness version '1.0.000' called AWV

valueset "Diastolic Blood Pressure": 'urn:oid:2.16.840.1.113883.3.526.3.1033'
valueset "Systolic Blood Pressure": 'urn:oid:2.16.840.1.113883.3.526.3.1032'

parameter "Measurement Period" Interval<DateTime>


	exists ( AWV."Annual Wellness Encounters" )

	"Initial Population"
