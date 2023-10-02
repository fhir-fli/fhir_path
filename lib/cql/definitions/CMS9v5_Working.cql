
using QDM version '5.0'

valueset "Galactosemia Grouping Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.35'
valueset "Single Live Birth SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.25'
valueset "Single Live Born Newborn Born in Hospital Grouping Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.26'
valueset "Encounter Inpatient SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Estimated Gestational Age at Birth SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113762.1.4.1045.47'
valueset "Parenteral Nutrition Grouping Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.38'
valueset "Breast Milk SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.27'
valueset "Neonatal Intensive Care Unit (NICU) SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.75'
valueset "Patient Expired SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.309'
valueset "Discharge To Acute Care Facility SNOMEDCT Value Set": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.87'
valueset "Ethnicity CDCREC Value Set": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer SOP Value Set": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race CDCREC Value Set": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex AdministrativeGender Value Set": 'urn:oid:2.16.840.1.113762.1.4.1'

parameter "Measurement Period" Interval<DateTime>

/*
  $EncounterInpatient =
      "Encounter, Performed: Encounter Inpatient" satisfies all:
          (length of stay <= 120 day(s))
          ends during "Measurement Period"
*/
