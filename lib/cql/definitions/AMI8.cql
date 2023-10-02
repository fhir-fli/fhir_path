
using QDM version '5.0.2'

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'

codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1' 

valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836' 

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837' 

valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591' 

valueset "Cardiopulmonary arrest": 'urn:oid:2.16.840.1.113883.3.666.5.748' 

valueset "Electrocardiogram (ECG)": 'urn:oid:2.16.840.1.113883.3.666.5.735' 

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292' 

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307' 

valueset "Fibrinolytic Therapy": 'urn:oid:2.16.840.1.113883.3.666.5.736' 

valueset "Aortic balloon pump insertion": 'urn:oid:2.16.840.1.113883.3.666.5.1151' 

valueset "Endotracheal Intubation": 'urn:oid:2.16.840.1.113762.1.4.1045.69' 

valueset "PCI": 'urn:oid:2.16.840.1.113762.1.4.1045.67' 

valueset "Ventricular Assist Device placement": 'urn:oid:2.16.840.1.113883.3.666.5.3015' 

valueset "Ambulatory surgical center": 'urn:oid:2.16.840.1.113883.3.666.5.687' 

valueset "Transfer From Emergency Department (ED) Locations": 'urn:oid:2.16.840.1.113883.3.666.5.3006' 

valueset "Transfer From Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.3013' 

valueset "Transfer From Outpatient": 'urn:oid:2.16.840.1.113883.3.67.1.101.950' 

valueset "STEMI Exclusions": 'urn:oid:2.16.840.1.113762.1.4.1045.36' 

valueset "Acute Myocardial Infarction (AMI)": 'urn:oid:2.16.840.1.113883.3.666.5.3011' 

valueset "Acute or Evolving MI": 'urn:oid:2.16.840.1.113883.3.666.5.3022' 

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'

code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
