
using QDM version '5.0'

valueset "Psych Visit - Diagnostic Evaluation": 'Psych Visit - Diagnostic Evaluation'
valueset "Nursing Facility Visit": 'Nursing Facility Visit'
valueset "Care Services in Long-Term Residential Facility": 'Care Services in Long-Term Residential Facility'
valueset "Home Healthcare Services": 'Home Healthcare Services'
valueset "Face-to-Face Interaction": 'Face-to-Face Interaction'
valueset "Psych Visit - Psychotherapy": 'Psych Visit - Psychotherapy'
valueset "Behavioral/Neuropsych Assessment": 'Behavioral/Neuropsych Assessment'
valueset "Occupational Therapy Evaluation": 'Occupational Therapy Evaluation'
valueset "Office Visit": 'Office Visit'
valueset "Outpatient Consultation": 'Outpatient Consultation'
valueset "Standardized Tools for Assessment of Cognition": 'Standardized Tools for Assessment of Cognition'
valueset "Cognitive Assessment": 'Cognitive Assessment'

parameter "Measurement Period" Interval<DateTime>

  ["Assessment, Performed": "Standardized Tools for Assessment of Cognition"] Assessment
    where Assessment.result is not null

  ["Intervention, Performed": "Cognitive Assessment"] Intervention

  "DEM Encounters 149" Encounter
    where exists (
        "Cognition Risk Assessment" Assessment
          where Assessment.authorDatetime 12 months or less before end of Encounter.relevantPeriod
      )
      or exists (
        "Cognitive Intervention" Intervention
          where Intervention.relevantPeriod starts 12 months or less before end of Encounter.relevantPeriod
      )

/*
Numerator =
  AND: Union of:
    "Risk Category Assessment: Standardized Tools for Assessment of Cognition (result)"
    "Intervention, Performed: Cognitive Assessment"
    <= 12 month(s) starts before end of Occurrence A of $DEMEncounters149
*/
