
/*
CMS 111 - Median Admit Decision Time to ED Departure Time for Admitted Patients
Continuous Variable Episode-of-Care Measure

Median time (in minutes) from admit decision time to time of discharge from the
emergency department for emergency department patients admitted to inpatient status.
*/

using QDM version '5.0.2'

valueset "Decision to Admit to Hospital Inpatient": '2.16.840.1.113883.3.117.1.7.1.295'
valueset "Emergency Department Visit": '2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Hospital Settings": '2.16.840.1.113762.1.4.1111.126'
valueset "Psychiatric/Mental Health Patient": '2.16.840.1.113883.3.117.1.7.1.299'

parameter "Measurement Period" Interval<DateTime>
