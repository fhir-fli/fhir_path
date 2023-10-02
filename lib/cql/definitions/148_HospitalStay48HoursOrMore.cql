
using QDM version '5.5'

/*
Problem Statement:
Given an episode of care based measure with the IPP / Denominator defined as:

    All inpatient encounters discharged during the measurement period for
    patients 18 years or older at the start of the encounter.

    An encounter is considered an inpatient admission, including time spent in
    the emergency department or in observation status when the patients are
    ultimately admitted to inpatient status.

We would like assistance with expressing in CQL that the qualifying encounter
length of stay must be at least 48 hours.

This could be applied as either:
    1. A denominator exclusion, where we would exclude encounters (including
    time spent in the emergency dept or in observation prior to admission) with
    length of stay < 48 hours
Or:
    2. A condition of the qualifying encounter where the length of stay
    (including time spent in the emergency dept or in observation prior to
    admission) must be > = 48 hours.

*/

/*
Attempted solution:

Change "Qualifying Encounter" from:
*/
