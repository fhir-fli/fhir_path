
/*
This content is a work in progress and should not be considered a final specification
or recommendation for guidance.
*/

/*
The purpose of these functions is to constrain FHIR resource elements for measures authored by NCQA, 
based on QICore to QDM Mapping (http://build.fhir.org/ig/HL7/fhir-qi-core/qdm-to-qicore.html).
*/

using QICore version '4.1.1'

include FHIRHelpers version '4.2.000' called FHIRHelpers

codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'

code "laboratory": 'laboratory' from "ObservationCategoryCodes" display 'laboratory'
code "exam": 'exam' from "ObservationCategoryCodes" display 'exam'
code "survey": 'survey' from "ObservationCategoryCodes" display 'survey'
code "vital-signs": 'vital-signs' from "ObservationCategoryCodes" display 'vital-signs'
code "active": 'active' from "ConditionClinicalStatusCodes"
