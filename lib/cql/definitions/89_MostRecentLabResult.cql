
/*
This example is based on CMS122v7 - Diabetes: Hemoglobin A1c (HbA1c) Poor Control (> 9%).
The example illustrates finding a most recent lab result.
*/

using QDM version '5.3'

valueset "HbA1c Laboratory Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1013'

parameter "Measurement Period" Interval<DateTime>

