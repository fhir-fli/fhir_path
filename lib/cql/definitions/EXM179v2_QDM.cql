
// Warfarin time in therapeutic range

/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QDM //version '4.1.2'

valueset "Atrial Fibrillation/Flutter": '2.16.840.1.113883.3.117.1.7.1.202'
valueset "Warfarin": '2.16.840.1.113883.3.117.1.7.1.232'
valueset "Face-to-face Encounter": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Valvular Heart Disease": '2.16.840.1.113883.3.464.1003.104.12.1017'
valueset "INR": '2.16.840.1.113883.3.117.1.7.1.213'
valueset "birth date": '2.16.840.1.113883.3.560.100.4'
valueset "Computed Value INR percent TTR": '2.16.840.1.113883.3.464.1003.104.12.1018'

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0))



	AgeInYearsAt(start of MeasurementPeriod) >= 18


	FlutterDiagnoses F where Interval[F."onsetDatetime", F."abatementDatetime"] overlaps before MeasurementPeriod
	ValvularHeartDiseaseDiagnoses D where Interval[D."onsetDatetime", D."abatementDatetime"] overlaps before MeasurementPeriod


	// QUICK: WarfarinMedications M where M.effectiveTimePeriod overlaps LookbackInterval
	WarfarinMedications M where Interval[M."startDatetime", M."stopDatetime"] overlaps LookbackInterval

	collapse
		ActiveWarfarinDuringLookback M
			// QUICK: return M.effectiveTimePeriod intersect LookbackInterval
			return Interval[M."startDatetime", M."stopDatetime"] intersect LookbackInterval


	INRLabResults R
		// QUICK: where not exists (InpatientEncounters E where duration in hours of Interval[E."admissionDatetime", E."dischargeDatetime"] > 23 and R.appliesDateTime occurs during Interval[E."admissionDatetime", E."dischargeDatetime"])
		where not exists (InpatientEncounters E where duration in hours of Interval[E."admissionDatetime", E."dischargeDatetime"] > 23 and Interval[R."startDatetime", R."stopDatetime"] occurs during Interval[E."admissionDatetime", E."dischargeDatetime"])

	INROutpatientLabResult L
		// QUICK: L.valueQuantity.value > 0.8
		where L."quantitativeResult".value > 0.8 // TODO: Units?
		return
			Tuple
			{
				// QUICK: resultDate: date from L.appliesDateTime
				resultDate: date from L."startDatetime",
				// QUICK: result: if L.valueQuantity.value > 10.0 then 10.0 else L.valueQuantity.value
				result: if L."quantitativeResult".value > 10.0 then 10.0 else L."quantitativeResult".value, // TODO: Units?
				// QUICK: distanceFromMidpoint: Abs(2.5 - L.valueQuantity.value)
				distanceFromMidpoint: Abs(2.5 - L."quantitativeResult".value) // TODO: Units?
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

