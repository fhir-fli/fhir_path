
using QDM

valueset "Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.293'

parameter "Measurement Period" Interval<DateTime>

/*
  For continuous variable measures, the measure observation is defined as a
  function that takes a single parameter of the type of elements returned by
  the population criteria.

  Each population criteria other than the measure observation must return the
  same type.

  The measure score is described in the population context section below.
*/
