
using QDM // version '4.2'

codesystem "LOINC": 'http://loinc.org'
valueset "Depression Encounter": 'OID'
code "Ideation": 'L90815-2' from "LOINC" display 'Ideation'

parameter "Measurement Period" Interval<DateTime>
