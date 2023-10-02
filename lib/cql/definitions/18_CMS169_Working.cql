
using QDM version '5.0.2'

/*
Data Criteria (QDM Data Elements)
  "Diagnosis: BH Condition Involving Bipolar Disorder" using "BH Condition Involving Bipolar Disorder Grouping Value Set (2.16.840.1.113883.3.1257.1.1504)"
  "Diagnosis: BH Condition Involving Unipolar Depression" using "BH Condition Involving Unipolar Depression Grouping Value Set (2.16.840.1.113883.3.1257.1.1505)"
  "Encounter, Performed: BH Outpatient encounter" using "BH Outpatient encounter Grouping Value Set (2.16.840.1.113883.3.464.1.49)"
  "Encounter, Performed: BH Outpatient Psychotherapy" using "BH Outpatient Psychotherapy Grouping Value Set (2.16.840.1.113883.3.1257.1.973)"
  "Medication, Active: BH Antidepressant Medication" using "BH Antidepressant Medication Grouping Value Set (2.16.840.1.113883.3.1257.1.972)"
  "Medication, Active: BH Mood Stabilizer Medication" using "BH Mood Stabilizer Medication Grouping Value Set (2.16.840.1.113883.3.1257.1.950)"
  "Medication, Order: BH Antidepressant Medication" using "BH Antidepressant Medication Grouping Value Set (2.16.840.1.113883.3.1257.1.972)"
  "Medication, Order: BH Mood Stabilizer Medication" using "BH Mood Stabilizer Medication Grouping Value Set (2.16.840.1.113883.3.1257.1.950)"
  "Procedure, Order: BH Counseling for Depression" using "BH Counseling for Depression Grouping Value Set (2.16.840.1.113883.3.1257.1.1616)"
  "Procedure, Order: BH Electroconvulsive Therapy" using "BH Electroconvulsive Therapy Grouping Value Set (2.16.840.1.113883.3.1257.1.1533)"
  "Procedure, Performed: BH Assessment for Alcohol or Other Drugs" using "BH Assessment for Alcohol or Other Drugs Grouping Value Set (2.16.840.1.113883.3.1257.1.1604)"
  "Procedure, Performed: BH Counseling for Depression" using "BH Counseling for Depression Grouping Value Set (2.16.840.1.113883.3.1257.1.1616)"
  "Procedure, Performed: BH Electroconvulsive Therapy" using "BH Electroconvulsive Therapy Grouping Value Set (2.16.840.1.113883.3.1257.1.1533)"

*/

valueset "BH Outpatient Psychotherapy": 'urn:oid:2.16.840.1.113883.3.1257.1.973'
valueset "BH Antidepressant Medication": 'urn:oid:2.16.840.1.113883.3.1257.1.972'
valueset "BH Assessment for Alcohol or Other Drugs": 'urn:oid:2.16.840.1.113883.3.1257.1.1604'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "BH Electroconvulsive Therapy": 'urn:oid:2.16.840.1.113883.3.1257.1.1533'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "BH Counseling for Depression": 'urn:oid:2.16.840.1.113883.3.1257.1.1616'
valueset "BH Mood Stabilizer Medication": 'urn:oid:2.16.840.1.113883.3.1257.1.950'
valueset "BH Condition Involving Bipolar Disorder": 'urn:oid:2.16.840.1.113883.3.1257.1.1504'
valueset "BH Outpatient encounter": 'urn:oid:2.16.840.1.113883.3.464.1.49'
valueset "BH Condition Involving Unipolar Depression": 'urn:oid:2.16.840.1.113883.3.1257.1.1505'

parameter "Measurement Period" Interval<DateTime>
