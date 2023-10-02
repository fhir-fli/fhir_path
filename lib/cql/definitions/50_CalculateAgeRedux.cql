
using QDM version '5.4'

include MATGlobalCommonFunctions version '3.0.000' called Global

parameter "Measurement Period" Interval<DateTime>


// There are two different ways to access the birthDate of a patient with CQL and QDM

// 1) Using the Patient Characteristic Birthdate:

  ["Patient Characteristic Birthdate"] BirthDate 
    where Global.CalendarAgeInYearsAt(BirthDate.birthDatetime, start of "Measurement Period") >= 2
	
// 2) Using the Patient.birthDatetime attribute:

  Global.CalendarAgeInYearsAt(Patient.birthDatetime, start of "Measurement Period") >= 2

// When relating birthdate to another source using a with, Patient Characteristic is reasonable, though still a bit more verbose:

  Global."Inpatient Encounter" Encounter
    with ["Patient Characteristic Birthdate"] BirthDate
      such that Global.CalendarAgeInYearsAt(BirthDate.birthDatetime, start of Encounter.relevantPeriod) >= 2

  Global."Inpatient Encounter" Encounter
    where Global.CalendarAgeInYearsAt(Patient.birthDatetime, start of Encounter.relevantPeriod) >= 2

// When referencing Patient Characteristic Birthdate in the initial population of a Patient-Based measure, it requires an exists:

  exists (
    ["Patient Characteristic Birthdate"] BirthDate
      where Global.CalendarAgeInYearsAt(BirthDate.birthDatetime, start of "Measurement Period") >= 2
  )
  
// Could be simplified to:
  Global.CalendarAgeInYearsAt(Patient.birthDatetime, start of "Measurement Period") >= 2
  
// Note that the reason for the Global.CalendarAgeInYearsAt function is to ensure that time is not considered.
// As of CQL 1.3, because CQL has a Date type, the AgeInYearsAt function, if called with a Date, will ignore
// the time component if it is present for the patient
// As a result, patient age calculations can all be simplified:

  Global."Inpatient Encounter" Encounter
    where AgeInYearsAt(ToDate(start of Encounter.relevantPeriod)) >= 2
	

// Note that the ToDate function is necessary to convert the start of the relevant period to a date.
// Otherwise, the AgeInYearsAt will use the full DateTime calculation.

// You could also use "date from" instead of ToDate() to get this behavior:

  Global."Inpatient Encounter" Encounter
    where AgeInYearsAt(date from start of Encounter.relevantPeriod) >= 2
	

  duration in years between Patient.dateTime and AsOf
	
  duration in years between date from Patient.dateTime and AsOf
	
  ["Related Person"] R
	  return CalculateAgeInYearsAt(R.birthDate, start of "Measurement Period")
	
  AgeInYearsAt(start of "Measurement Period")
		
  CalculateAgeInYearsAt(Patient.birthDatetime, start of "Measurement Period")

  CalculateAgeInYearsAt(date from Patient.birthDatetime, date from start of "Measurement Period")






The AgeAt operators calculate the age of the patient as of the given date/time in the precision named in the operator.

Separate these definitions to clarify that when a Date argument is provided the calculation is based on Dates only (time is ignored). Don't use the date/time to describe the semantics.

Also clarify that usage (date/time) throughout the specification.

Also clarify difference between AgeInYearsAt versus CalculateAgeInYearsAt: (as in, patient is a teenage girl, what the age at menarche of the mother)

  ["Related Person"] R
	  return CalculateAgeInYearsAt(R.birthDate, start of "Measurement Period")
	
  AgeInYearsAt(start of "Measurement Period")
		
  CalculateAgeInYearsAt(Patient.birthDatetime, start of "Measurement Period")
