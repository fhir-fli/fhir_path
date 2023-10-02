
/*
  Based on CMS9v4
  Exclusive Breast Milk Feeding

  Episode-of-Care-Based Proportion Measure with multiple populations

  NOTE: This example is purposefully based on version 4 of the measure to allow
  for exploration of the expression of the "intention to breastfeed" concept.

  This example is a work in progress and should not be considered a final specification
  or recommendation for guidance. This example will help guide and direct the process
  of finding conventions and usage patterns that meet the needs of the various stakeholders
  in the measure development community.

*/

using QDM version '5.0'

// Can include this with or without a version specification
// Without a version specification, the implementations just use the most recent version of the BPS library
include EXM9_BPS called Vx
// include EXM9_BPS version '4.0.0' called Vx

parameter "Measurement Period" Interval<DateTime>
