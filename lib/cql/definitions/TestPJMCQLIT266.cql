
/*testing only*/

//using QDM version '5.5'

include MATGlobalCommonFunctions version '6.2.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'

parameter "Measurement Period" Interval<DateTime>

/*

  ["Patient Characteristic Ethnicity": "Ethnicity"]

  ["Patient Characteristic Payer": "Payer"]

  ["Patient Characteristic Race": "Race"]

  ["Patient Characteristic Sex": "ONC Administrative Sex"]

  exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
      where Global."CalendarAgeInYearsAt" ( BirthDate.birthDatetime, start of "Measurement Period" ) in Interval[18, 75 )
  )

  "Initial Population"

  "TargetPop"
    and (  exists ( "Question1x" )
        or exists ( "Question2x" )
        or exists ( "Question3x" )
        or exists ( "Question3x2" )
        or exists ( "Question3x3" )
        or exists ( "Question4x" )
        or exists ( "Question4x2" )
        or exists ( "Question4x3" )
        or exists ( "Question4x4" )
        or exists ( "Question4x5" )
        or exists ( "Question4x6" )
        or exists ( "Question5x" )
        or exists ( "Question5x2" )
        or exists ( "Question5x3" )
        or exists ( "Question6x" )
        or exists ( "Question6x1" )
        or exists ( "Question6x2" )
        or exists ( "Question6x3" )
        or exists ( "Question6x4" )
        or exists ( "Question6x5" )
        or exists ( "Question6x6" )
        or exists ( "Question7x" )
        or exists ( "Question8x" )
        or exists ( "Question9xA" )
    )

  exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
      where Global."CalendarAgeInYearsAt" ( BirthDate.birthDatetime, start of "Measurement Period" ) in Interval[65, 75 )
  )
*/

// Integer defaults to per 1
// Interval as Integer, closed
  expand { Interval [ 1, 5 ] }

// Interval as Integer, open HI
  expand { Interval [ 1, 5 ) }

// Decimal defaults to per 1
// Interval as Decimal, closed HI
  expand { Interval [ 1.0, 5.0 ] }

  expand { Interval [ 1.0, 5.0 ] } per 2.0

  expand { Interval [ 1.0, 5.0 ] } per 0.1

// Interval as Decimal, open HI
  expand { Interval [ 1.0, 5.0 ) }

  expand { Interval [ 1.0, 5.0 ) } per 2.0

  expand { Interval [ 1.0, 5.0 ) } per 0.1

  expand { Interval [ 1.00, 5.00 ) } per 0.1

  expand { Interval [ 1.50, 5.50 ) } per 0.1

  expand { Interval [ 1.55, 5.55 ) } per 0.1

// Interval as Decimal, open LO
  expand { Interval ( 1.0, 5.0] }

  expand { Interval ( 1.0, 5.0] } per 2.0

  expand { Interval ( 1.0, 5.0] } per 0.1

// Interval as Decimal, open LO HI
  expand { Interval ( 1.0, 5.0 ) }

  expand { Interval ( 1.00, 5.00 ) }

  expand { Interval ( 1.0, 5.0 ) } per 2.0

  expand { Interval ( 1.0, 5.0 ) } per 0.1

  expand { Interval ( 1.00, 5.00 ) } per 0.1

  expand { Interval ( 1.50, 5.50 ) } per 0.1

  expand { Interval ( 1.55, 5.55 ) } per 0.1

// Interval as Date
  expand { Interval[@2018-01-01, @2018-01-05]} per day

  expand { Interval[@2018-01-01T01:30:00, @2018-01-05T18:30:00]} per day
