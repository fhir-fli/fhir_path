
 

using QDM version '5.3'

 

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'

codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'

codesystem "SNOMEDCT:2017-09": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2017-09'

codesystem "SNOMEDCT:2013-09": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2013-09'

 

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'

valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'

valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'

valueset "Discharge To Acute Care Facility": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'

valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'

valueset "Patient Expired": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'

valueset "Psychiatric/Mental Health Diagnosis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.299'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'

valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143'

 

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'

code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

code "Patient deceased during stay (discharge status = dead) (finding)": '371828006' from "SNOMEDCT:2013-09" display 'Patient deceased during stay (discharge status = dead) (finding)'

 

parameter "Measurement Period" Interval<DateTime>

 
