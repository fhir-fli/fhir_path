
/*
CQLIT-247_CMS156_Collapsing date time intervals with an undefined end point-20210109:

# Question:
When collapse is called on a set of intervals where one of the intervals has an
undefined end point, what is the expected result?

For example:
  collapse(
    { [@2021-01-06 - @2021-01-08], [@2021-01-08 - null] }
  )

Collapse is defined in terms of overlaps and meets, which themselves use
predecessor and successor.  Both predecessor and successor indicate that a run
time error should be thrown if the value is already the minimum or maximum
allowed. End semantics indicate that the if the interval is closed then null
should be interpreted as the maximum value. Our implementation is throwing the
run time when we call successor from meets.

This question arises from interpreting EHR data for Medication, Order's for
CMS156 where the end point for the order is not defined. When I recreated this
issue in Bonnie, no error was thrown. When I dug into Bonnie's javascript I do
not see the javascript calling Overlaps or Meets. It appears to me that the
javascript is doing something custom.
*/

/*
Answer: re Collapse Operator
As background, here are links to relevant sections of the CQL documentation:
References:
* [Collapse](https://cql.hl7.org/09-b-cqlreference.html#collapse)
* [DateTime](https://cql.hl7.org/09-b-cqlreference.html#datetime)
* [Developer's Guide](https://cql.hl7.org/03-developersguide.html)
* [Time Interval Calculations](https://cql.hl7.org/15-h-timeintervalcalculations.html)

Regarding Collapse(), as noted in the Section 9.3 of Appendix B of the CQL Reference Guide:
“The collapse operator returns the unique set of intervals that completely covers
the ranges present in the given list of intervals. In other words, adjacent intervals
within a sorted list are merged if they either overlap or meet. Note that because the
semantics for overlaps and meets are themselves defined in terms of the interval
successor and predecessor operators, sets of Date-, DateTime-, or Time-based intervals
that are only defined to a particular precision will calculate meets and overlaps at
that precision. For example, a list of DateTime-based intervals where the boundaries
are all specified to the hour will collapse at the hour precision, unless the collapse
precision is overridden with the per argument. Conceptually, the per argument to the
collapse operator partitions the value-space for the operation into units of size 'per',
and the intervals will be collapsed aligning with those partitions. Note that the 'per'
partitions start from the starting boundary of the first input interval, ordered.”

To summarize, the list of "Medication, Order" relevant periods contained as the
Collapse(attributes) would be sorted chronologically by the start (lo) datetime
then the current item end (hi) datetime would be compared as equal to or greater
than the subsequent item start (lo) datetime for adjacent members of the list.
If true, the adjacent members would be combined as [start datetime (i), end datetime (i+1)].

The following snippets are from the CMS156 v9.0.003 cql file for 2021 Measurement Period:
