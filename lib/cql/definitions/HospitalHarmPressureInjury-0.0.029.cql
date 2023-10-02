
using QDM version '5.4'

codesystem "SNOMEDCT:2017-09": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2017-09'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pressure Ulcer Stage": 'urn:oid:2.16.840.1.113883.11.20.9.35'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Nonstageable pressure ulcer (disorder)": '421594008' from "SNOMEDCT:2017-09" display 'Nonstageable pressure ulcer (disorder)'
code "Pressure injury of deep tissue (disorder)": '723071003' from "SNOMEDCT:2017-09" display 'Pressure injury of deep tissue (disorder)'
code "Pressure ulcer stage 2 (disorder)": '420324007' from "SNOMEDCT:2017-09" display 'Pressure ulcer stage 2 (disorder)'
code "Pressure ulcer stage 3 (disorder)": '421927004' from "SNOMEDCT:2017-09" display 'Pressure ulcer stage 3 (disorder)'
code "Pressure ulcer stage 4 (disorder)": '420597008' from "SNOMEDCT:2017-09" display 'Pressure ulcer stage 4 (disorder)'

parameter "Measurement Period" Interval<DateTime>
