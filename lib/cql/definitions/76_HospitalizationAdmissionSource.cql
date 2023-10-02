
/*
This example is drawn from an adjusted version of AMI8a/CMS53
For more discussion see [CQLIT-136](https://oncprojectracking.healthit.gov/support/browse/CQLIT-136)
*/

using QDM version '5.4'

include MATGlobalCommonFunctions version '3.0.000' called Global

valueset "Acute or Evolving MI": 'urn:oid:2.16.840.1.113883.3.666.5.3022'
valueset "Ambulatory surgical center": 'urn:oid:2.16.840.1.113883.3.666.5.687'
valueset "Aortic balloon pump insertion": 'urn:oid:2.16.840.1.113883.3.666.5.1151'
valueset "Cardiopulmonary arrest": 'urn:oid:2.16.840.1.113883.3.666.5.748'
valueset "Electrocardiogram (ECG)": 'urn:oid:2.16.840.1.113883.3.666.5.735'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Endotracheal Intubation": 'urn:oid:2.16.840.1.113762.1.4.1045.69'
valueset "Fibrinolytic Therapy": 'urn:oid:2.16.840.1.113883.3.666.5.736'
valueset "PCI": 'urn:oid:2.16.840.1.113762.1.4.1045.67'
valueset "Transfer From Emergency Department (ED) Locations": 'urn:oid:2.16.840.1.113883.3.666.5.3006'
valueset "Transfer From Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.3013'
valueset "Transfer From Outpatient": 'urn:oid:2.16.840.1.113883.3.67.1.101.950'
valueset "Ventricular Assist Device placement": 'urn:oid:2.16.840.1.113883.3.666.5.3015'

parameter "Measurement Period" Interval<DateTime>
