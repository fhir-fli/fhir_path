
/*
There are numerous uses of the timing phrase "ends 1 hour or less on or before start of"
to identify an emergency department visit immediately prior to an inpatient encounter.
One such example is from CMS111 - Median Admit Decision Time to ED Departure Time for Admitted Patients
*/

using QDM version '5.4'


  ["Encounter, Performed"]
	
  ["Encounter, Performed"]

/*
// CQL (CMS111v8)
*/
	/*Emergency Department visit with a Decision to Admit inpatient followed by an Inpatient encounter within or at an hour of the ED Visit*/
	"Inpatient Encounter" Encounter
		with "ED Visit with Admit Order" EDAdmitOrder
			such that EDAdmitOrder.relevantPeriod ends 1 hour or less before or on start of Encounter.relevantPeriod

/*
QDM (CMS111v6)
AND: 
  "Occurrence A of Encounter, Performed: Emergency Department Visit" 
		<= 1 hour(s) ends before or concurrent with start of Occurrence A of $EncounterInpatient 
*/

/*
In QDM, this comparison is performed by calculating the difference between the end of the
emergency department visit and the start of the inpatient encounter, and comparing that
to the quantity in the timing phrase. Since the duration calculation rounds, this results in
durations of 1 hour and 59 minutes still being considered "1 hour".
*/

/*
In CQL, the timing phrase "ends 1 hour or less before or on start of" is evaluated using
an interval calculation:

relevantPeriod.end in Interval[start - 1 hour, start]

So the comparison occurs at the millisecond, rather than at the hour as in QDM.

You can still achieve the same behavior in CQL by specifying the comparison precision:

"ends 1 hour or less before or on hour of start of"
*/
