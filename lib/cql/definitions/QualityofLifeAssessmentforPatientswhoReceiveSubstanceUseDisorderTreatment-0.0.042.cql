
using QDM version '5.5'

include MATGlobalCommonFunctions version '4.0.000' called Global

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Alcohol and Drug Dependence": 'urn:oid:2.16.840.1.113883.3.464.1003.106.12.1001'
valueset "Alcohol and Drug Dependence Treatment": 'urn:oid:2.16.840.1.113762.1.4.1145.15'
valueset "Eligible Clinician Outpatient Encounters with Telehealth": 'urn:oid:2.16.840.1.113762.1.4.1046.150'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospice for the Terminally Ill": 'urn:oid:2.16.840.1.113762.1.4.1046.147'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "PROMIS 10 Global Mental Health Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.11.1138'
valueset "PROMIS 10 Global Physical Health Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1139'
valueset "Psych Visit - Diagnostic Evaluation": 'urn:oid:2.16.840.1.113883.3.526.3.1492'
valueset "Psych Visit - Psychotherapy": 'urn:oid:2.16.840.1.113883.3.526.3.1496'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "VR 36 Mental Component Summary (MCS) Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1225'
valueset "VR 36 Physical Component Summary (PCS) Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1226'
valueset "VR12 Mental Component T Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1177'
valueset "VR12 Physical Component T Score": 'urn:oid:2.16.840.1.113883.3.464.1003.118.12.1176'

code "Dead (finding)": '419099009' from "SNOMEDCT" display 'Dead (finding)'

parameter "Measurement Period" Interval<DateTime>
