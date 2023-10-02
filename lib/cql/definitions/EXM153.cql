
/*
*  based on NQF33/CMS153v3, July 2014 EP;
*  this is v1 of the CQL library to implement;
*  report percentage of women 16-24 years of age
*      who were identified as sexually active
*      and who had at least one test for chlamydia during the measurement period;
*/

/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QUICK

/*
*  data criteria = value sets
*  names listed in alphabetical order
*  grouped by QDM data model
*/
valueset "Diagnosis, Active: Chlamydia": '2.16.840.1.113883.3.464.1003.112.12.1003'
valueset "Diagnosis, Active: Complications of Pregnancy, Childbirth and the Puerperium": '2.16.840.1.113883.3.464.1003.111.12.1012'
valueset "Diagnosis, Active: Genital Herpes": '2.16.840.1.113883.3.464.1003.110.12.1049'
valueset "Diagnosis, Active: Genococcal Infections and Venereal Diseases": '2.16.840.1.113883.3.464.1003.112.12.1001'
valueset "Diagnosis, Active: HIV": '2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Diagnosis, Active: Inflammatory Diseases of Female Reproductive Organs": '2.16.840.1.113883.3.464.1003.112.12.1004'
valueset "Diagnosis, Active: Other Female Reproductive Conditions": '2.16.840.1.113883.3.464.1003.111.12.1006'
valueset "Diagnosis, Active: Syphilis": '2.16.840.1.113883.3.464.1003.112.12.1002'

valueset "Diagnostic Study, Order: Diagnostic Studies During Pregnancy": '2.16.840.1.113883.3.464.1003.111.12.1008'
valueset "Diagnostic Study, Order: X-Ray Study (all inclusive)": '2.16.840.1.113883.3.464.1003.198.12.1034'

valueset "Encounter, Performed: Face-to-Face Interaction": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Encounter, Performed: Home Healthcare Services": '2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Encounter, Performed: Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Encounter, Performed: Preventive Care Services - Established Office Visit, 0 to 17": '2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Encounter, Performed: Preventive Care Services - Initial Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Encounter, Performed: Preventive Care Services - Initial Office Visit, 0 to 17": '2.16.840.1.113883.3.464.1003.101.12.1022'

valueset "Laboratory Test, Order: Lab Tests During Pregnancy": '2.16.840.1.113883.3.464.1003.111.12.1007'
valueset "Laboratory Test, Order: Lab Tests for Sexually Transmitted Infections": '2.16.840.1.113883.3.464.1003.110.12.1051'
valueset "Laboratory Test, Order: Pap Test": '2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Laboratory Test, Order: Pregnancy Test": '2.16.840.1.113883.3.464.1003.111.12.1011'

valueset "Laboratory Test, Result: Chlamydia Screening": '2.16.840.1.113883.3.464.1003.110.12.1052'

valueset "Medication, Active: Contraceptive Medications": '2.16.840.1.113883.3.464.1003.196.12.1080'

valueset "Medication, Order: Contraceptive Medications": '2.16.840.1.113883.3.464.1003.196.12.1080'
valueset "Medication, Order: Isotretinoin": '2.16.840.1.113883.3.464.1003.196.12.1143'

valueset "Patient Characteristic Birthdate: birth date": '2.16.840.1.113883.3.560.100.4'
valueset "Patient Characteristic Sex: Female": '2.16.840.1.113883.3.560.100.2'

valueset "Procedure, Performed: Delivery Live Births": '2.16.840.1.113883.3.464.1003.111.12.1015'
valueset "Procedure, Performed: Procedures During Pregnancy": '2.16.840.1.113883.3.464.1003.111.12.1009'
valueset "Procedure, Performed: Procedures Involving Contraceptive Devices": '2.16.840.1.113883.3.464.1003.111.12.1010'

/*
*  measurement period = 20xx Jan 1 to 20xx Dec 31;
*  default to prior full calendar year;
*  Measurement Year = ((year of today()) - 1)
*/
parameter MeasurementPeriod default Interval[DateTime( ((year from Today()) - 1), 1, 1 ), DateTime( ((year from Today()) - 1), 12, 31 )]
