
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'


/*
I recently came across an interesting observation while testing months calculation
and was wondering if this could be added to the agenda for this week’s session.
For one of my measures I am testing that the patient be 3 months of age or older
as of their episode date.

A patient who’s birthdate is on 3/30/2022 as of their episode date (06/30/2022)
should be exactly 3 months of age. When testing this in the CQL engine, the engine
displays that this patient is 2 months old. It seems that the engine is optimized
to ensure 2 months with the same date are always a whole number apart. For example,
January 15 to February 15 would be exactly one month. Below are a few more test
case examples testing this behavior.

Test cases examples:
*/

  Tuple {
    MarchToJune30: CalculateAgeInMonthsAt(Date(2022, 3, 31), Date(2022, 6, 30)),
    //MarchToJune31: CalculateAgeInMonthsAt(Date(2022, 3, 31), Date(2022, 6, 31)), // This is a run-time error, invalid date
    MarchToJuly1: CalculateAgeInMonthsAt(Date(2022, 3, 31), Date(2022, 7, 1)),
    MarchToJuly31: CalculateAgeInMonthsAt(Date(2022, 3, 31), Date(2022, 7, 31)),
    AprilToJune30: CalculateAgeInMonthsAt(Date(2022, 4, 30), Date(2022, 6, 30))//,
    //AprilToJune31: CalculateAgeInMonthsAt(Date(2022, 4, 30), Date(2022, 6, 31)) // This is a run-time error, invalid date
  }
}

/*
Test=[Tuple {
	"MarchToJune30": 2
	"MarchToJuly1": 3
	"MarchToJuly31": 4
	"AprilToJune30": 2
}]
*/
