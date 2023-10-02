
/*
CMS 32: Median Time from ED Arrival to ED Departure for Discharged ED Patients
Continuous Variable Episode-of-Care Measure

Median elapsed time from emergency department arrival to emergency room departure
for patients discharged from the emergency department.
*/

using QDM version '5.0.2'

valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Acute care hospital": '2.16.840.1.113883.3.666.5.684'
valueset "Patient Expired": '2.16.840.1.113883.3.117.1.7.1.309'
valueset "Psychiatric/Mental Health Patient": '2.16.840.1.113883.3.117.1.7.1.299'

parameter "Measurement Period" Interval<DateTime>
