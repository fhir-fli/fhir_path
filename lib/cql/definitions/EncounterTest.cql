
using QICore version '4.1.1'

include FHIRHelpers version '4.2.000'

codesystem "Concept Codes": 'http://example.org/fhir/CodeSystem/concept-codes'

valueset "Inpatient Encounters": 'http://hl7.org/fhir/ValueSet/inpatient-encounters'

code "Inpatient": 'inpatient' from "Concept Codes"
