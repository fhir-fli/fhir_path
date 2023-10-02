
using QDM

valueset "Inpatient": 'X.Y.Z.1'
valueset "AMI": 'X.Y.Z.3'
valueset "Patient Expired": 'X.Y.Z.4'
valueset "Statin": 'X.Y.Z.5'

parameter "Measurement Period" Interval<DateTime>

/*
  For non-patient-based proportion measures, each criteria must return the
  same type. The type can be any data element, such as an Encounter, Procedure,
  or Medication.

  The measure score is described in the population context section below.
*/
