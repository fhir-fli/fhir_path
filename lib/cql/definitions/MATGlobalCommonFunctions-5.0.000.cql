
/*This is an interim version for use prior to AU 2020 release.  We anticipate another release for inclusion with the program measures in Spring 2020*/

using QDM version '5.5'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292' 
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206' 
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143' 
valueset "Outpatient Surgery Service": 'urn:oid:2.16.840.1.113762.1.4.1110.38' 

parameter "Measurement Period" Interval<DateTime>
