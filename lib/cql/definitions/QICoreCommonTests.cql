
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include QICoreCommon called Common

codesystem "Marital Status Codes": 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus'
codesystem "CDC Race and Ethnicity Codes": 'urn:oid:2.16.840.1.113883.6.238'

valueset "Marital Status": 'http://hl7.org/fhir/ValueSet/marital-status'

code "Marital Status - Married": 'M' from "Marital Status Codes"
code "American Indian or Alaska Native": '1002-5' from "CDC Race and Ethnicity Codes"
code "Alaska Native": '1735-0' from "CDC Race and Ethnicity Codes"
code "Blood pressure": '85354-9' from Common."LOINC" display 'Blood pressure panel with all children optional'
code "Diastolic blood pressure": '8462-4' from Common."LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from Common."LOINC" display 'Systolic blood pressure'
