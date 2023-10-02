
using QDM version '5.3'

parameter "Measurement Period" Interval<DateTime>

/*
Current blood pressure criteria in CMS22 takes the most recent encounter with
a blood pressure reading, and then the most recent reading from that encounter.

New guidelines determine a reference reading as the average of all blood pressure
readings taken during the most recent encounter.
*/

/* identify qualifying encounters */