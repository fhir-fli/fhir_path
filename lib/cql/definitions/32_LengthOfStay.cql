
// NOTE: This is a proposed resolution for BONNIE-301
// https://oncprojectracking.healthit.gov/support/browse/BONNIE-301

using QDM version '5.0.2'

// As we've been discussing, LengthOfStay is a "calculated" value and that 
// presents some challenges when used as an attribute in QDM. An alternative
// is to define a function to calculate the LengthOfStay
// of an encounter or hospitalization.

// The approaches we've been considering this far have used duration: