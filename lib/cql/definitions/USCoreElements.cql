
using USCore version '3.1.1'

include FHIRHelpers version '4.0.1'
include USCoreCommon version '0.1.0'

valueset "Common allergy substances": 'http://hl7.org/fhir/us/core/ValueSet/us-core-allergy-substance'

code "No known allergy (situation)": '716186003' from USCoreCommon.SNOMEDCT
