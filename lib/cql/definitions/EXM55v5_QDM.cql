
/*
	Based on CMS55v5/NQF0495
	Median Time from ED Arrival to ED Departure for Admitted ED Patients

	Episode-of-Care-Based Continuous Variable Measure with stratification

	This example is a work in progress and should not be considered a final specification
	or recommendation for guidance. This example will help guide and direct the process
	of finding conventions and usage patterns that meet the needs of the various stakeholders
	in the measure development community.
*/

using QDM version '5.0.2'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.293'
valueset "Hospital Settings": 'urn:oid:2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Patient": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.299'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'

parameter "Measurement Period" default Interval[@2014-01-01T00:00:00.0, @2015-01-01T00:00:00.0)
