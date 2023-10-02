
/*
This example is taken from the NCQA Prenatal Immunization Status measure
It illustrates calculation of gestational age from assessments and diagnoses,
as well as the use of a function to calculate conception date
*/

using QDM version '5.3'

codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Deliveries": 'urn:oid:2.16.840.1.113883.3.464.1004.1072'
valueset "Adult Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1475'
valueset "37 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1880'
valueset "38 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1881'
valueset "39 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1882'
valueset "40 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1883'
valueset "41 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1884'
valueset "42 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1885'
valueset "43 Gestational Weeks": 'urn:oid:2.16.840.1.113883.3.464.1003.1886'

code "Length of gestation at birth (observable entity)": '412726003' from "SNOMEDCT" display 'Length of gestation at birth (observable entity)'

parameter "Measurement Period" Interval<DateTime>
