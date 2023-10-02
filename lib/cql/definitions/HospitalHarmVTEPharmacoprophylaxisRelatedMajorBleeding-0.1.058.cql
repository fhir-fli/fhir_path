
using QDM version '5.5'

include MATGlobalCommonFunctions version '6.2.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Anticoagulants for Indications Other than VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1147.131'
valueset "Anticoagulants for VTE Prophylaxis": 'urn:oid:2.16.840.1.113762.1.4.1147.130'
valueset "Bleeding at Critical Site": 'urn:oid:2.16.840.1.113762.1.4.1147.135'
valueset "Bleeding at Non Critical Site": 'urn:oid:2.16.840.1.113762.1.4.1147.125'
valueset "Blood Transfusion Administration": 'urn:oid:2.16.840.1.113762.1.4.1029.209'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hemoglobin lab test": 'urn:oid:2.16.840.1.113762.1.4.1045.131'
valueset "Hospital based dialysis services": 'urn:oid:2.16.840.1.113762.1.4.1179.4'
valueset "Obstetrics": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.263'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>
