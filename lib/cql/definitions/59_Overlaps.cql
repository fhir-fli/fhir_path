
using QDM version '5.3'

/*
What is the expected result of an Overlaps when one of the intervals contains a null boundary?
*/

/*
http://cql.hl7.org/09-b-cqlreference.html#overlaps

If the:
  "ending point of the first interval is greater than or equal to the starting point of the second"
  and
  "starting point of the first interval is less than or equal to the ending point of the second"
  
In other words:

A overlaps B =>
  end of A >= start of B 
    and start of A <= end of B

A overlaps before B =>
  end of A >= start of B
    and start of A < start of B
    
A overlaps after B =>
  start of A <= end of B
    and end of A > end of B
*/



/*
Visually, we can depict this as:

I                   |-------|

T1    |-------|
T2    |-----------------------------------|
T3              |-------|
T4                  |-------|
T5                    |---|
T6                      |-------|
T7                                |-------|
*/

/*
When interval boundaries are not present, there are two possible interpretations:
1) When a boundary is not present and the boundary is _closed_:
*/


/*
In this case, the interval is considered to continue indefinitely in the
direction of the boundary.

I                   |-------|

T8    <-----------------|
T9                      |----------------->
*/

/*
2) Whan a boundary is not present and the boundary is _open_:
*/
