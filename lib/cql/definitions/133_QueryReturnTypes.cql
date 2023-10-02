
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include TJCOverall version '5.0.000' called TJC
include MATGlobalCommonFunctions version '5.0.000' called Global

codesystem "LOINC": 'http://loinc.org'

valueset "Pap Test": 'TBD'
valueset "Antithrombotic Therapy": 'TBD'
valueset "Medical Reason": 'TBD'
valueset "Patient Refusal": 'TBD'

code "Blood pressure": '85354-9' from "LOINC" display 'blood pressure'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
