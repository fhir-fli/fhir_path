
using QDM version '5.5'

/*
Consider the example of a "mother-infant" measure that requires data from both a mother
and the infant. If we think about the measure as written from the infants perspective,
then we need some way to be able to access the data from the mother's record.
*/


codesystem "SNOMED": '1.2.3.4.5'

valueset "Estimated Due Date Exam": 'TBD'
valueset "Live Delivery": 'TBD'

code "Mother Relationship": 'Mother' from "SNOMED"

context Patient