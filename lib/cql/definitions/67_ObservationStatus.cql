
/*
Measures need to account for care delivered in "observation" status

To do this, the notion of episode-of-care needs to account for the possibility of observation status

But like emergency department visits, EHRs may account for observation status differently

An example of the issue can be found here:
https://oncprojectracking.healthit.gov/support/browse/CQM-1608
*/

/*
Episode-of-care, conceptual scenarios, beginning with Arrival to the hospital, 
and ending with discharge from inpatient care:
*/

1: Inpatient
2: ED -> Inpatient
3: ED -> Observation -> Inpatient
4: Observation -> Inpatient
5: Outpatient -> Observation -> Inpatient
6: Outpatient -> Inpatient

/*
Question: We don't currently account for Outpatient -> Inpatient, what is different
about observation that means we need to account for Outpatient in that case?

Answer: Yes, for example in the case of complications arising from outpatient surgeries
that result in patients placed in observation followed by admission. In addition, the
possibility exists for an admission directly from an outpatient setting.
*/

/*
ED visits are currently handled in two ways:

A) As a different type of Encounter, separate from the Inpatient Encounter:
*/
