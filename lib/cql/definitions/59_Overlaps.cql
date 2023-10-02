
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
