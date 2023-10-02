
/*
@description: Determines whether failed conversions will result in a run-time error or a null result with a warning
@comments: With this parameter set to 'Error', failed conversions will result in a runtime error.
With this parameter set to 'Warning' failed conversions will result in a Warning and the function returning 'null'.
*/
parameter ErrorSeverity String default 'Warning'

/*
@description: Returns the value of the given Quantity, interpreted as an Integer if it is safe to do so.
@comments: A Quantity value can be safely interpreted as an integer if it has no decimal component (i.e. zeros after the decimal),
and it has the default UCUM unit of '1'
*/