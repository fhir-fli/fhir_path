
using QDM version '5.3'

valueset "Ingredients": 'TBD'
valueset "Reaction Type": 'TBD'


  ["Allergy/Intolerance": "Ingredients"] A
    where A.type in "Reaction Type"
    
// CMS147:

  ["Allergy/Intolerance": "Influenza Vaccine"] ImmunizationAllergyIntolerance
    where ImmunizationAllergyIntolerance.prevalencePeriod overlaps "Measurement Period"
      and not (ImmunizationAllergyIntolerance.prevalencePeriod starts 90 days or more after start of "Measurement Period")
      and not (ImmunizationAllergyIntolerance.prevalencePeriod ends 89 days or less after start of "Measurement Period") 
