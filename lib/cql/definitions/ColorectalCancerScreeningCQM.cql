
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers

// Proposed change to CQL to support binding of parameters of included libraries:
// https://jira.hl7.org/browse/FHIR-33126
include ColorectalCancerElements called CCE // bind { AsOf: end of "Measurement Period" }

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2022-01-01T00:00:00.0-06:00, @2023-01-01T00:00:00.0-06:00)


/*
NOTE: Removed qualifying encounters criteria to simplify for demonstration purposes
*/
  AgeInYearsAt(start of "Measurement Period") in Interval[50, 75]

  "Initial Population"

  CCE."Has Appropriate Colorectal Cancer Screening"

/*
NOTE: Removed hospice, advanced illness, and frailty exclusions to simplify for demonstration purposes
*/