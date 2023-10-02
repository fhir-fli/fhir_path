/*
@description: This library provides cumulative medication duration calculation
logic for use with Quality Data Model prescription, discharge, administration,
and dispensing events. The logic here follows the guidance provided as part of
the 5.6 version of Quality Data Model.
@comment: Note that the logic here assumes single-instruction dosing information.
Split-dosing, tapering, and other more complex dosing instructions are not handled.
@changelog:
v0.3.000
Fixed Quantity handling in duration calculations
Fixed authorDatetime null handling
Changed to provide Date-level calculation, rather than DateTime
*/
library CumulativeMedicationDuration version '0.3.000'