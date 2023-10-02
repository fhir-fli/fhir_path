
// NOTE: This issue is a proposed resolution to BONNIE-311: https://oncprojectracking.healthit.gov/support/browse/BONNIE-311
// More generally, it is a proposed resolution for timing phrases and calculation expressions throughout the measures

using QDM version '5.0.2'

  ["Encounter, Performed"]
  
  ["Intervention, Performed"]

// The issue is that the intent of the measure is to consider comfort measures that occurred within a calendar day, regardless of the time component.
// Using the phrase "1 day or less on or after start" uses duration calculations which take the time components into account.
// However, by adding the "day of" qualifier to the timing phrase, we can perform the comparisons at the day precision:

  "Encounter with Principal Diagnosis of Ischemic Stroke" NonElectiveEncounter 
    with "Intervention Comfort Measures" ComfortMeasure 
      such that ComfortMeasure.authorDatetime 1 day or less on or after day of start of NonElectiveEncounter.relevantPeriod

  // The timing phrase in the above such that clause renders to the machine readable as:
    // ComfortMeasure.authorDatetime 
      // in (using day) Interval[start of NonElectiveEncounter.relevantPeriod, start of NonElectiveEncounter.relevantPeriod + 1 day]

  // which is defined to evaluate using comparisons at the specified level of precision against the interval boundaries
      
// So, as a specific example, if E is the encounter start time, and A is the intervention author time, we have:


// So this approach returns true, and allows us to express the desired intent but still using the timing phrases.

// And another example of a comfort measure occurring on the same day