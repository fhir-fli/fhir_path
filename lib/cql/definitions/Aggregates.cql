
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'


/*
Aggregate functions in CQL allow calculations to be performed on collections of
values such as Sum, Min, Max, and Avg. CQL also includes several statistical aggregate
functions such as StdDev and PopulationVariance.

In general, these aggregate functions operate on collections of _values_, in
particular, ignoring null elements in the input. For example:
*/



/*
If the list of elements contains no values (i.e. is empty or has all null elements), the result
is null:
*/



/*
An exception to this rule is the Count function, which will return 0 in this case:
*/


/*
This is the key difference between the Count function and the Length function for lists.
Length counts all the elements, regardless of whether they are null, where Count
behaves like the other aggregates and ignores nulls:
*/
