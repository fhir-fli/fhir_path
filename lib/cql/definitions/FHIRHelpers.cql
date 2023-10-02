
using FHIR version '4.0.1'

/*
@description: Converts the given [Period](https://hl7.org/fhir/datatypes.html#Period)
value to a CQL DateTime Interval
@comment: If the start value of the given period is unspecified, the starting
boundary of the resulting interval will be open (meaning the start of the interval
is unknown, as opposed to interpreted as the beginning of time).
*/