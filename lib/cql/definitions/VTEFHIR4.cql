
using FHIR version '4.0.1'

include MATGlobalCommonFunctionsFHIR4 version '6.1.000' called Global
include FHIRHelpers version '4.0.1' called FHIRHelpers

valueset "Intensive Care Unit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1029.206'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)


  start of "FirstICULocationPeriod"(Encounter)

  "FirstInpatientIntensiveCareUnit"(Encounter).period

  First((Encounter.location)HospitalLocation
  	where Global.GetLocation(HospitalLocation.location).type in "Intensive Care Unit"
  		and HospitalLocation.period during Encounter.period
  	sort by start of period
	)

  Interval[date from ( StartValue ), date from ( StartValue ) + 1 day]

  Interval[date from ( start of Global."HospitalizationWithObservation" ( Encounter ) ), date from ( start of Encounter.period ) + 1 day]
