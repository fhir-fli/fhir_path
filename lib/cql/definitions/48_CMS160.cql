
// This example is an excerpt of CMS160
// Only the relevant logic is included

using QDM version '5.3'

valueset "Dysthymia": 'urn:oid:2.16.840.1.113883.3.67.1.101.1.254'
valueset "Major Depression Including Remission": 'urn:oid:2.16.840.113883.3.67.1.101.3.2444'
valueset "Psych Visit": 'urn:oid:2.16.840.113883.3.67.1.101.3.2445'

parameter "Measurement Period" Interval<DateTime>
