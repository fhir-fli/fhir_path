
using QDM version '5.3'

include AnnualWellness version '1.0.000' called AWV
include MATGlobalCommonFunctions version '2.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Mammography": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1018'
valueset "Female": 'urn:oid:2.16.840.1.113883.3.560.100.2'
valueset "Bilateral Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1005'
valueset "Unilateral Mastectomy": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1020'

code "Birth date": '21112-8' from "LOINC" display 'Birthdate'

parameter "Measurement Period" Interval<DateTime>
