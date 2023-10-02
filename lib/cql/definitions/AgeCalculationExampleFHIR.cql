
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include MATGlobalCommonFunctionsFHIR4 version '5.0.000' called Global
include MATGlobalCommonFunctionsFHIR4 version '6.0.000' called Global6
include AdultOutpatientEncountersFHIR4 called AdultOutpatientEncounters

/* CMS165 Supporting Definitions */
valueset "Essential Hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.104.12.1011'

/* CMS74 Supporting Definitions */
valueset "Clinical Oral Evaluation": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.125.12.1003'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care - Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'

/* CMS124 Supporting Definitions */
valueset "HPV Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1059'

parameter "Measurement Period" Interval<DateTime> default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0)


// From CMS165 - Controlling Blood Pressure

// With CalendarAgeInYearsAt
  Global.CalendarAgeInYearsAt(FHIRHelpers.ToDate(Patient.birthDate), start of "Measurement Period") between 18 and 84
      and exists "Essential Hypertension Diagnosis"
      and exists AdultOutpatientEncounters."Qualifying Encounters"

  AgeInYearsAt(date from start of "Measurement Period") between 18 and 84
      and exists "Essential Hypertension Diagnosis"
      and exists AdultOutpatientEncounters."Qualifying Encounters"

// From CMS74 - Primary Caries Prevention

  exists ( ["Patient"] BirthDate
    where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 6
      and Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) <= 4
  )

  AgeInMonthsAt(date from start of "Measurement Period" ) >= 6
    and AgeInYearsAt(date from start of "Measurement Period" ) <= 4

  exists ["Patient"] BirthDate
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[5, 11]

  AgeInYearsAt(date from start of "Measurement Period" ) in Interval[5, 11]

  exists ["Patient"] BirthDate
    where Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) in Interval[12, 20 )

  AgeInYearsAt(date from start of "Measurement Period" ) in Interval[12, 20 )

  exists ( ["Patient"] BirthDate
    where Global."CalendarAgeInMonthsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) >= 6
      and Global."CalendarAgeInYearsAt" ( FHIRHelpers.ToDate(BirthDate.birthDate), start of "Measurement Period" ) < 20
  )
    and exists ( "Qualifying Encounters" )

  exists ( "Qualifying Encounters" )
    and AgeInMonthsAt(date from start of "Measurement Period" ) >= 6
    and AgeInYearsAt(date from start of "Measurement Period" ) < 20

// From CMS124 - Cervical Cancer Screening

  [Observation: "HPV Test"] HPVTest
    where HPVTest.value is not null
      and HPVTest.status in { 'final', 'amended', 'corrected', 'preliminary' }
      and Global."CalendarAgeInYearsAt"(FHIRHelpers.ToDate(Patient.birthDate), start of Global."Normalize Interval"(HPVTest.effective)) >= 30
      and Global."Normalize Interval"(HPVTest.effective) ends 5 years or less on or before end of "Measurement Period"

  [Observation: "HPV Test"] HPVTest
    where HPVTest.value is not null
      and HPVTest.status in { 'final', 'amended', 'corrected', 'preliminary' }
      and AgeInYearsAt(date from start of Global6."Normalize Interval"(HPVTest.effective)) >= 30
      and Global6."Normalize Interval"(HPVTest.effective) ends 5 years or less on or before end of "Measurement Period"



/*
CMS165 Supporting definitions
*/

  [Condition: "Essential Hypertension"] Hypertension
     where Hypertension.verificationStatus ~ ToConcept(Global."confirmed")
       and (Global."Prevalence Period"(Hypertension) overlaps Interval[start of "Measurement Period" - 1 year, end of "Measurement Period"])

/*
CMS74 Supporting definitions
*/
