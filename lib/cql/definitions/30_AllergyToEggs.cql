
using QDM version '5.0.2'

valueset "Allergy to Eggs": 'X.Y.Z'

parameter "Measurement Period" Interval<DateTime>

/*
  QDM:
    OR:
      AND: "Occurrence A of Diagnosis: Allergy to Eggs" overlaps "Measurement Period"
      AND NOT: "Occurrence A of Diagnosis: Allergy to Eggs" > 89 day(s) starts after start of "Measurement Period"
      AND NOT: "Occurrence A of Diagnosis: Allergy to Eggs" <= 89 day(s) ends after start of "Measurement Period"
*/

// NOTE: The issue here is that the "not" is being invoked around both conditions, which changes the logic