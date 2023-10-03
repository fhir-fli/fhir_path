
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include MATGlobalCommonFunctionsFHIR4 called Common

code "Birth date": '21112-8' from Common."LOINC" display 'Birth date'
code "Blood pressure": '85354-9' from Common."LOINC" display 'blood pressure'
code "Diastolic blood pressure": '8462-4' from Common."LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from Common."LOINC" display 'Systolic blood pressure'

parameter "Measurement Period" Interval<DateTime>default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0]