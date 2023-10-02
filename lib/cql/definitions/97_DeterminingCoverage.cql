
/*
This examples demonstrates the use of the QDM Participation type to determine coverage
The examples here are based on coverage and participation content developed by NCQA
Many thanks for the contribution!
*/

using QDM version '5.3'

valueset "Commercial": 'urn:oid:2.16.840.1.113762.1.4.1165.46'
valueset "Medicaid": 'urn:oid:2.16.840.1.113762.1.4.1165.45'
valueset "Medicare": 'urn:oid:2.16.840.1.113762.1.4.1165.44'

parameter "Measurement Period" Interval<DateTime>
