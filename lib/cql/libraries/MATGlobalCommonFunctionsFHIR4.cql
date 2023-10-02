/*
@update: BTR 2020-03-31 ->
Incremented version to 5.0.000
Updated FHIR version to 4.0.1
Changed timezone keyword to timezoneoffset for use with CQL 1.4
Removed Normalize Onset in favor of more general Normalize Interval
Updated CodeSystems for ConditionVerificationStatusCodes and RoleCodes

@update: BTR 2021-05-13 ->
Added ActiveCondition Codes and Inactive Condition Codes value sets
Added function documentation throughout
Fixed EDVisit not using Last
Updated prevalence period to use an inclusive boundary if the condition is active
Added HasStart, HasEnd, Earliest, and Latest functions
Removed ToDate and Age calculation functions

@update: BTR 2021-06-25 ->
Added GetBaseExtension overloads for Element

@update: BTR 2022-05-24 ->
Update for 2022 AU content
Refactor to use CQF.FHIRCommon
*/
library MATGlobalCommonFunctionsFHIR4 version '7.0.000'