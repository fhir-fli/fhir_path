
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include FHIRCommon version '4.0.1' called FC

codesystem "SNOMEDCT:2017-09": 'http://snomed.info/sct/731000124108' version 'http://snomed.info/sct/731000124108/version/201709'

valueset "Hysterectomy with No Residual Cervix": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1014'
valueset "Pap Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "HPV Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1059'

code "Congenital absence of cervix (disorder)": '37687000' from "SNOMEDCT:2017-09" display 'Congenital absence of cervix (disorder)'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)


/*
Build expressions for the
* Initial Population
* Denominator
* Denominator Exclusion
* Numerator

HINT: Express the intermediates first:
* Cervical Cytology Within 3 Years
* HPV Test Within 5 Years For Women Age 30 and Older
*/

  ([Procedure: "Hysterectomy with No Residual Cervix"] NoCervixProcedure
    where FC.ToInterval(NoCervixProcedure.performed) ends on or before end of "Measurement Period"
      and NoCervixProcedure.status = 'completed'
  )
    union [Condition : "Congenital absence of cervix (disorder)"] NoCervixBirth
  		where FC.ToInterval(NoCervixBirth.onset) starts on or before end of "Measurement Period"

	[Observation: "Pap Test"] CervicalCytology
		where CervicalCytology.value is not null
			and CervicalCytology.status in { 'final', 'amended', 'corrected', 'preliminary' }
		  and FC.ToInterval(CervicalCytology.effective) ends 3 years or less on or before end of "Measurement Period"

	[Observation: "HPV Test"] HPVTest
    where HPVTest.value is not null
      and HPVTest.status in { 'final', 'amended', 'corrected', 'preliminary' }
      and AgeInYearsAt(start of FC.ToInterval(HPVTest.effective)) >= 30
      and FC.ToInterval(HPVTest.effective) ends 5 years or less on or before end of "Measurement Period"

	Patient.gender = 'female'
		and AgeInYearsAt(start of "Measurement Period") in Interval[23, 64]

	"Initial Population"

		exists "Absence of Cervix"
