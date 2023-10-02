
/*
  Based on CMS146v3
  Appropriate Testing for Children with Pharyngitis

  Episode-Of-Care-Based Proportion Measure

  This example is a work in progress and should not be considered a final specification
  or recommendation for guidance. This example will help guide and direct the process
  of finding conventions and usage patterns that meet the needs of the various stakeholders
  in the measure development community.
*/

using QDM version '5.0.2'

include Common version '1' called Common

valueset "Acute Pharyngitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1011'
valueset "Acute Tonsillitis": 'urn:oid:2.16.840.1.113883.3.464.1003.102.12.1012'
valueset "Ambulatory/ED Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1061'
valueset "Antibiotic Medications": 'urn:oid:2.16.840.1.113883.3.464.1003.196.12.1001'
valueset "Group A Streptococcus Test": 'urn:oid:2.16.840.1.113883.3.464.1003.198.12.1012'

parameter "Measurement Period" Interval<DateTime>
