
/*
define "Single Live Birth Encounter With Gestational Age 37 Weeks or More"
  "Single Live Birth Encounter" SingleLiveBirthEncounter
    with ["Assessment, Performed": "Gestational age--at birth"] GestationalAge
      such that GestationalAge.result >= 37 weeks
        and Global."EarliestOf" ( GestationalAge.relevantDatetime, GestationalAge.relevantPeriod ) during SingleLiveBirthEncounter.relevantPeriod
*/
