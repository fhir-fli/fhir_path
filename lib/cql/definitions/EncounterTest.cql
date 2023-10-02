
using QICore version '4.1.1'

include FHIRHelpers version '4.2.000'

codesystem "Concept Codes": 'http://example.org/fhir/CodeSystem/concept-codes'

valueset "Inpatient Encounters": 'http://hl7.org/fhir/ValueSet/inpatient-encounters'

code "Inpatient": 'inpatient' from "Concept Codes"


/*
[CQLIT-368](https://oncprojectracking.healthit.gov/support/browse/CQLIT-368)
[Translator Issue #1181](https://github.com/cqframework/clinical_quality_language/issues/1181)
[Encounter Authoring Patterns](https://github.com/cqframework/CQL-Formatting-and-Usage-Wiki/wiki/Authoring-Patterns---QICore-v4.1.1#accessing-encounters-with-a-direct-reference-code)
*/

  ["Encounter": "Inpatient Encounters"]

  ["Encounter": "Inpatient"]

  ["Encounter": "Inpatient Encounters"] E
    where case
      when exists ((E.type) T where T ~ "Inpatient") then getThreshold(E) > 10
      else getThreshold(E) > 15
    end

