
// Related JIRA Ticket:
// https://oncprojectracking.healthit.gov/support/browse/CQLIT-31?page=com.atlassian.jira.plugin.system.issuetabpanels%3Aall-tabpanel
// Markup submission here:
// C:\Users\Bryn\Documents\Src\SS\Docs\CQL Example Submissions\CMS72v5 CQL Markup.docx

// Example based on CMS72v5 - Antithrombotic Therapy By End of Hospital Day 2
// Encounter-based Proportion Measure

using QDM version '5.0.2'

/*
Data Criteria (QDM Data Elements)

    "Encounter, Performed: Emergency Department Visit" using "Emergency Department Visit SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.292)"
    "Encounter, Performed: Non-Elective Inpatient Encounter" using "Non-Elective Inpatient Encounter SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.424)"
    "Intervention, Order: Comfort Measures" using "Comfort Measures SNOMEDCT Value Set (1.3.6.1.4.1.33895.1.3.0.45)"
    "Intervention, Performed: Comfort Measures" using "Comfort Measures SNOMEDCT Value Set (1.3.6.1.4.1.33895.1.3.0.45)"
    "Medication, Administered: Antithrombotic Therapy" using "Antithrombotic Therapy RXNORM Value Set (2.16.840.1.113883.3.117.1.7.1.201)"
    "Medication, Administered: Thrombolytic (t-PA) Therapy" using "Thrombolytic (t-PA) Therapy RXNORM Value Set (2.16.840.1.113883.3.117.1.7.1.226)"
    "Medication, Administered not done: Medical Reason" using "Medical Reason SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.473)"
    "Medication, Administered not done: Patient Refusal" using "Patient Refusal SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.93)"
    "Medication, Order: Antithrombotic ingredient specific" using "Antithrombotic ingredient specific RXNORM Value Set (2.16.840.1.113762.1.4.1021.8)"
    "Medication, Order not done: Medical Reason" using "Medical Reason SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.473)"
    "Medication, Order not done: Patient Refusal" using "Patient Refusal SNOMEDCT Value Set (2.16.840.1.113883.3.117.1.7.1.93)"
    "Procedure, Performed: Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy" using "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy Grouping Value Set (2.16.840.1.113762.1.4.1045.21)"
    Attribute: "Principal diagnosis: Ischemic Stroke" using "Ischemic Stroke Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.247)"
    Attribute: "Principal diagnosis: Hemorrhagic Stroke" using "Hemorrhagic Stroke Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.212)"

Supplemental Data Elements

    "Patient Characteristic Ethnicity: Ethnicity" using "Ethnicity CDCREC Value Set (2.16.840.1.114222.4.11.837)"
    "Patient Characteristic Payer: Payer" using "Payer SOP Value Set (2.16.840.1.114222.4.11.3591)"
    "Patient Characteristic Race: Race" using "Race CDCREC Value Set (2.16.840.1.114222.4.11.836)"
    "Patient Characteristic Sex: ONC Administrative Sex" using "ONC Administrative Sex AdministrativeGender Value Set (2.16.840.1.113762.1.4.1)"
*/

codesystem "SNOMED-CT": ''
codesystem "RXNORM": ''

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'
valueset "Non-Elective Inpatient Encounter": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.424'
valueset "Comfort Measures": 'urn:oid:1.3.6.1.4.1.33895.1.3.0.45'
valueset "Antithrombotic Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.201'
valueset "Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.226'
valueset "Medical Reason": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.473'
valueset "Patient Refusal": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.93'
valueset "Antithrombotic ingredient specific": 'urn:oid:2.16.840.1.113762.1.4.1021.8'
valueset "Intravenous or Intra-arterial Thrombolytic (t-PA) Therapy": 'urn:oid:2.16.840.1.113762.1.4.1045.21'
valueset "Ischemic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.247'
valueset "Hemorrhagic Stroke": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.212'

parameter "Measurement Period" Interval<DateTime>
