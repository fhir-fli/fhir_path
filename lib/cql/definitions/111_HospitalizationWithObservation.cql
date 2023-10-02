
// This question was submitted in:
// [CQLIT-170](https://oncprojectracking.healthit.gov/support/browse/CQLIT-170) - Hospitalization with Observation
// And relates to CMS104v8 - Discharged on Antithrombotic Therapy

/*
1. Intervention comfort measure should be between start date of ED and end date of IP
2. Intervention comfort measure should be between start date of Observation Services and end date of IP
3. Intervention comfort measure should be between start date of IP and end date of IP
*/

using QDM version '5.4'

include MATGlobalCommonFunctions version '4.0.000' called Global


  ["Encounter, Performed"]

	["Intervention, Order"]
		union ["Intervention, Performed"]

	"Ischemic Stroke Encounter" IschemicStrokeEncounter
		with "Intervention Comfort Measures" ComfortMeasure
			such that Coalesce(start of ComfortMeasure.relevantPeriod, ComfortMeasure.authorDatetime)
			  during Global."HospitalizationWithObservation"(IschemicStrokeEncounter)

// Looking at the HospitalizationWithObservation function:
/*Hospitalization with Observation returns the total interval from the start of any immediately prior emergency department visit through the observation visit to the discharge of the given encounter*/