
// This example is an excerpt of CMS128
// Only the relevant logic is included

using QDM version '5.3'

valueset "Antidepressant Medication": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1213'
valueset "Major Depression": 'urn:oid:2.16.840.1.113883.3.464.1003.105.12.1007'

parameter "Measurement Period" Interval<DateTime>
