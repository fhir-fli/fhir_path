
using QDM

valueset "Inpatient": 'X.Y.Z.1'
valueset "DepressionAssessment": 'X.Y.Z.2'

parameter "Measurement Period" Interval<DateTime>

/*
  For patient-based ratio measures, each criteria must return true or false (or null).

  The measure score calculation is described by the "Denominator Membership",
  "Numerator Membership" and "Measure Ratio Numerator" and "Measure Ratio Denominator"
  expressions.
*/


  exists (
    ["Encounter, Performed": "Inpatient"] Encounter
      where Encounter.startDateTime during "Measurement Period"
  )

  exists (
    ["Procedure, Performed": "Depression Assessment"] Procedure
      where Procedure.startDateTime during "Measurement Period"
  )


// Measure score definition starts here
// NOTE: This is the formal description of the measure score calculation for
// this type of measure. It is the same for all measures of this type, and is
// provided here for reference. It is NOT expected that this calculation be
// included in each measure.

  "Initial Population"
    and "Denominator"
    and not "Denominator Exclusion"

  "Initial Population"
    and "Numerator"
    and not "Numerator Exclusion"


  Count("Numerator Membership" IsMember where IsMember is true)
