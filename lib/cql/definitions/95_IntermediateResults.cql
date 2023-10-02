
/*
This example is based on CMS53v7 - Primary PCI Received Within 90 Minutes of Hospital Arrival
The example illustrates calculation of intermediate results within a query
*/

using QDM version '5.3'

include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Acute or Evolving MI": 'urn:oid:2.16.840.1.113883.3.666.5.3022'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Fibrinolytic Therapy": 'urn:oid:2.16.840.1.113883.3.666.5.736'
valueset "PCI": 'urn:oid:2.16.840.1.113762.1.4.1045.67'
valueset "Electrocardiogram (ECG)": 'urn:oid:2.16.840.1.113883.3.666.5.735'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>
