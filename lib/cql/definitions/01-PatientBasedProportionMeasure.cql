
using QDM

valueset "Inpatient": 'X.Y.Z.1'
valueset "DepressionAssessment": 'X.Y.Z.2'

parameter "Measurement Period" Interval<DateTime>

/*
  For patient-based proportion measures, each criteria must return true or false (or null).

  The measure score calculation is described by the "Denominator Membership",
  "Numerator Membership" and "Measure Score" expressions.
*/
