
/*
What are / where can I find rules for dealing with precision for operators such as SameOrAfter?

For example does precision="Day" mean that we zero the days, or does it mean within 24 hours of.
*/

/*
The semantics for precision-based comparison are discussed in section 2.5.4.2 
of the specification: http://cql.hl7.org/02-authorsguide.html#comparing-dates-and-times

In a nutshell, the comparison is performed at the precision specified. For example:
*/
