/* 
@description: This library provides cumulative medication duration calculation
logic for use with FHIR medication prescription, administration, and dispensing
resources. The logic here follows the guidance provided as part of the 5.6
version of Quality Data Model.
@comment: Note that the logic here assumes single-instruction dosing information.
Split-dosing, tapering, and other more complex dosing instructions are not handled.
@update:
v0.2.000
Fixed Quantity handling in duration calculations
Fixed authorDatetime null handling
Changed to provide Date-level calculation, rather than DateTime
v2.0.000
Updated as part of 2022 AU refresh
Refactored to use QICoreCommon
v2.0.001
Fixed invalid unit error evaluating RolloutIntervals
Fixed RolloutIntervals incorrectly eliminating duplicates
v3.1.000
updated to reflect changes from AU2022 QDM library changes _JKR
*/
library CumulativeMedicationDuration version '3.1.000'