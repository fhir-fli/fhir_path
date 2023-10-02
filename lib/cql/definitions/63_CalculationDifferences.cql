
using QDM version '5.3'


// Date/Time Calculation differences between QDM Logic and CQL

// CQL Time Interval Calculations Appendix, for reference:
// http://cql.hl7.org/15-h-timeintervalcalculations.html

// Date/Time Precision

// In QDM, when date/time values are not known to a specific precision, the
// guidance specifies that zeroes should be used

// In CQL, date/time values can be "partial", meaning that the value is only
// known to some specific precision such as to the day or to the minute.

// This results in different behavior for timing comparisons
// For example:

  ["Encounter, Performed"] E
    with ["Procedure, Performed"] P
      such that P starts before end of E
      
// In QDM, if the end date of the encounter is unknown, this would return false
// In CQL, the end date is unknown with a closed interval, meaning it continues to the end of time,
// which results in true

@2018-05-01 < null // null

@2018-05-01 in [@2018-01-01, null] // true
@2018-05-01 in [@2018-01-01, null) // null


// Comparisons when No Unit is Given

// In QDM, when no precision is given, guidance specifies that the minute precision is assumed
// This resulted in seconds being ignored if they are present
// In CQL, when no precision is specified, the comparison is performed to the millisecond
// If the comparison should be performed at a specific precision, CQL allows a precision to be specified

  ["Encounter, Performed"] E
    with ["Procedure, Performed"] P
      such that P starts before end of minute of E

// Duration Calculations

// Calculating duration in years

// March 10th, 2012 to February 2nd, 2013
// QDM Result: 0
// CQL Result: 0

// March 10th, 2012 at 10:05:09PM to March 10th 2013 at 8:01:59AM
// QDM Result: 1
// CQL Result: 0

// March 10th, 2012 at 10:05:09PM to March 10th 2013 at 10:05:09PM
// QDM Result: 1
// CQL Result: 1

// March 10th, 2012 at 10:05:09PM to March 20th 2013 at 4:01:30AM
// QDM Result: 1
// CQL Result: 1

// QDM Result: 1
// CQL Result: 1

// NOTE: Because there is no Feburary 29th in 2014, the number of years can only 
// change when the date reaches March 1, the first date in 2014 that surpasses the
// month and day of date 1

// QDM Result: 1
// CQL Result: 1

// QDM Result: 2
// CQL Result: 2

// Calculating duration in months

// QDM Result: 0
// CQL Result: 0

// QDM Result: 15
// CQL Result: 15

// QDM Result: 9
// CQL Result: 9

// Calculating duration in weeks

// QDM Result: 1
// CQL Result: 1

// NOTE: As with the other precision, this operator only returns whole weeks, so even 
// though the difference in days is 10 days, the difference in weeks is the truncated 
// result, 1

// Calculating duration in days

// QDM Result: 1
// CQL Result: 0

// NOTE: This is a different result because QDM's day calculation ignores time
// In CQL, the _difference_ operator can be used to count the number of boundaries
// crossed, as opposed to the _duration_ operator, which returns the number of whole
// days (i.e. 24 hour periods)


// QDM Result: 1
// CQL Result: 1

// Calculating duration in hours

// QDM Result: 1
// CQL Result: 1

// QDM Result: 2
// CQL Result: 1

// NOTE: This is a different result because QDM hour duration calculations ignore seconds.

// QDM Result: 1
// CQL Result: 1

// QDM Result: 0
// CQL Result: 0

// Calculating duration in minutes

// QDM Result: 130
// CQL Result: 130

