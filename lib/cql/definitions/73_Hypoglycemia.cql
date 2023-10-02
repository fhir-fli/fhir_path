
/*
This example is taken from the following JIRA ticket:
https://oncprojectracking.healthit.gov/support/browse/CQLIT-126
*/

using QDM version '5.3'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Glucose Lab Test": 'urn:oid:2.16.840.1.113762.1.4.1045.134' version 'urn:hl7:version:20180706'
valueset "Diabetes": 'urn:oid:2.16.840.1.113883.3.464.1003.103.12.1001' version 'urn:hl7:version:20180706'
valueset "Antidiabetics": 'urn:oid:2.16.840.1.113883.3.1260.1.1978'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' version 'urn:hl7:version:eCQM%20Update%202018-05-04'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292' version 'urn:hl7:version:eCQM%20Update%202018-05-04'
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143' version 'urn:hl7:version:eCQM%20Update%202018-05-04'

parameter "Measurement Period" Interval<DateTime>
