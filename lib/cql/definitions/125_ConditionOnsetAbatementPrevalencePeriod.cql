
/*
Based on EXM135
Illustrates determining Onset/Abatement and PrevalencePeriod for a Condition
*/

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'

parameter "Measurement Period" Interval<DateTime>default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0]