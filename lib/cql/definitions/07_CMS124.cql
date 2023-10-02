
using QDM version '5.0'

valueset "Pap Test": 'Pap Test'
valueset "HPV Test": 'HPV Test'

parameter "Measurement Period" Interval<DateTime>

  ["Laboratory Test, Performed": "Pap Test"] LabTest
    where LabTest.result is not null

  "Pap Test With Results" Test
    where Test.resultDatetime 3 years or less before end of "Measurement Period"

["Laboratory Test, Performed": "HPV Test"] LabTest
  where LabTest.result is not null

  "Pap Test With Results" Test
    with "HPV Test With Results" HPVTest
      such that HPVTest.resultDatetime within 1 day of Test.resultDatetime
    where CalculateAgeInYearsAt(Test.resultDatetime) >= 30
      and Test.resultDatetime 5 years or less before end of "Measurement Period"
