
using QDM version '5.3'

include AnnualWellness version '1.0.000' called AWV

valueset "Depression or Bipolar Disorder": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1040'
valueset "PHQ 2 Total Score (in points)": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1013'


	exists ( AWV."Annual Wellness Encounters" )

	"Initial Population"

	exists ( ["Diagnosis": "Depression or Bipolar Disorder"] Bipolar
			with AWV."Annual Wellness Encounters" AWV
				such that Bipolar.prevalencePeriod overlaps before AWV.relevantPeriod
	)
