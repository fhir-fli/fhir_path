
// Warfarin time in therapeutic range

/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QUICK

valueset "Flutter Diagnosis": '2.16.840.1.113883.3.117.1.7.1.202'
valueset "Warfarin Medication": '2.16.840.1.113883.3.117.1.7.1.232'
valueset "Face-to-face Encounter": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Valvular Heart Disease": '2.16.840.1.113883.3.464.1003.104.12.1017'
valueset "INR Lab Result": '2.16.840.1.113883.3.117.1.7.1.213'

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0))



	AgeInYearsAt(start of MeasurementPeriod) >= 18



	WarfarinMedications M where M.effectiveTimePeriod overlaps LookbackInterval

	collapse
		ActiveWarfarinDuringLookback M
			return M.effectiveTimePeriod intersect LookbackInterval


	INRLabResults R
		where not exists (InpatientEncounters E where duration in hours of E.period > 23 and R.appliesDateTime occurs during E.period)

	INROutpatientLabResult L
		where L.valueQuantity.value > 0.8 // TODO: Units?
		return
			Tuple
			{
				resultDate: date from L.appliesDateTime,
				result: if L.valueQuantity.value > 10.0 then 10.0 else L.valueQuantity.value, // TODO: Units?
				distanceFromMidpoint: Abs(2.5 - L.valueQuantity.value) // TODO: Units?
			}

	(
	    (distinct INRResultsByDay X return X.resultDate) D
		    return First(INRResultsByDay R where R.resultDate = D sort by R.distanceFromMidpoint)
    ) X
	sort by X.resultDate


	(INRResultsPerDay S return Tuple { startResult: S, endResult: First(INRResultsPerDay E where S.resultDate > E.resultDate) }) X
		return
			Tuple
			{
				startDate: X.startResult.resultDate,
				endDate: X.endResult.resultDate,
				resultDays: days between X.startResult.resultDate and X.endResult.resultDate,
				resultDifference: X.endResult.result - X.startResult.result,
				resultsWithinBounds: X.startResult.result in TherapeuticRange and X.endResult.result in TherapeuticRange,
				boundedDifference:
					if X.endResult.result >= X.startResult.result
						then
						(
							if X.startResult.result > end of TherapeuticRange or X.endResult.result < start of TherapeuticRange
								then null
								else Min({X.endResult.result, end of TherapeuticRange}) - Max({X.startResult.result, start of TherapeuticRange})
						)
						else
						(
							if X.endResult.result > end of TherapeuticRange or X.startResult.result < start of TherapeuticRange
								then null
								else Min({X.startResult.result, end of TherapeuticRange}) - Max({X.endResult.result, start of TherapeuticRange})
						),
				isValid: days between X.startResult.resultDate and X.endResult.resultDate <= 56
			}

	INRIntervals I
		return
			Tuple
			{
				startDate: I.startDate,
				endDate : I.endDate,
				isValid : I.isValid,
				resultDays : I.resultDays,
				daysInRange :
					if I.resultsWithinBounds
						then I.resultDays
						else Coalesce(I.resultDays * Abs(I.boundedDifference / (if I.resultDays = 0 then null else I.resultDays)), 0)
			}

	Round(100 * (Sum(TherapeuticDays X return X.daysInRange) / Sum(TherapeuticDays X return X.resultDays)))



	InDemographic
		and exists (InpatientEncounters)
		and exists (ActiveFlutterDiagnoses)
		and WarfarinUsage >= 180
		and not exists (ActiveValvularHeartDiseaseDiagnoses)

	HasValidIntervals

	TherapeuticTimeInRange

