
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QDM

// Valueset definitions allow local names to be used within the artifact
valueset "Care Services in Long-Term Residential Facility": '...'
valueset "Heart Failure": '...'

// Parameters allow for evaluation-time values to be provided to the artifact
parameter "Measurement Period" default Interval[@2014-01-01T00:00:00.0, @2015-01-01T00:00:00.0)

// Identifiers can include spaces and punctuation to make logic more readable
// Because the result is a set, rather than a criteria definition, the notion of occurrencing is not required