
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include FHIRCommon version '4.0.1' called FC

codesystem "SNOMED": 'http://snomed.info/sct'
codesystem "LOINC": 'http://loinc.org'

valueset "Lung Cancer":  'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1116.89'
valueset "Smoking Status": 'http://hl7.org/fhir/us/core/ValueSet/us-core-observation-smokingstatus'
valueset "Current Smoker": 'http://example.org/fhir/ValueSet/currentsmoker'
valueset "Chest CT": 'http://example.org/fhir/ValueSet/chest-ct-procedure'
valueset "Condition Clinical Status Active": 'http://example.org/fhir/ValueSet/conditionclinicalstatusactive'

code "Tobacco Smoking Status": '72166-2' from "LOINC"
code "Former Smoker": '8517006' from "SNOMED"
code "PACKS A DAY": '8663-7' from "LOINC" display 'packs per day'


/*
Build expressions for the required data elements:

Patient age in years based on date of birth
Smoking status observation
Lung cancer diagnosis
Chest CT procedure
*/

/* Data Elements */
  AgeInYears()

  [Observation: "Tobacco Smoking Status"] O
    where O.status in { 'final', 'amended' }

  [Condition: "Lung Cancer"] C
    where C.clinicalStatus in "Condition Clinical Status Active"

  [Procedure: "Chest CT"] P
    where P.status = 'completed'

/* Intermediate Data Elements */
  AgeInYears() >= 55 and AgeInYears() <= 80

  Last("Smoking status observation" O
    sort by (FHIRHelpers.ToDateTime(issued))
  )

  "Most recent smoking status observation" O
    where (O.value as CodeableConcept) in "Current Smoker"

  "Most recent smoking status observation" O
    where (O.value as CodeableConcept) ~ "Former Smoker"

  "Current smoker observation" is not null

  ("Former smoker observation" O
    where O.effective ends 15 years or less before Today()
  ) is not null

  "Most recent smoking status observation" O
    let PacksPerDay: singleton from (O.component C where C.code ~ "PACKS A DAY").value,
    DurationInDays: duration in days of O.effective
    return System.Quantity { value: Round((PacksPerDay * (DurationInDays / 365.25)).value), unit: '{Pack-years}' }

  "Pack-years" >= 30 '{Pack-years}'

  exists ("Lung cancer diagnosis")

  exists ("Chest CT procedure" P
    where FC.ToInterval(P.performed) ends 1 year or less before Today()
  )


/*
Inclusion criteria:
Patient is 55 through 80
Patient is a current smoker
Patient is a former smoker who quit within the past 15 years
Patient has a 30 pack-year smoking history

Exclusion criteria
Patient has lung cancer
Patient had a chest-ct within the last year
*/

/* Inclusion Criteria */
  "55 through 80"
    and ("Is current smoker" or "Is former smoker who quit within past 15 years")
    and "Has 30 pack-year smoking history"
    and not "Has lung cancer"
    and not "Had chest CT in past year"

/* Exclusion Criteria */