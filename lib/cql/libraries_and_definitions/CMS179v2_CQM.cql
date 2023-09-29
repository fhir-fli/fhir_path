library CMS179 version '2'

// Warfarin time in therapeutic range

/* CMS 146v2
 *
 * ============================================================================
 * QDM Logic
 * ============================================================================
 * Initial Patient Population =
 *     AND: "Patient Characteristic Birthdate: birth date" >= 2 year(s) starts before start of "Measurement Period"
 *     AND: "Patient Characteristic Birthdate: birth date" < 18 year(s) starts before start of "Measurement Period"
 *     AND:
 *         AND: "Occurrence A of Encounter, Performed: Ambulatory/ED Visit" during "Measurement Period"
 *         AND: "Medication, Order: Antibiotic Medications" <= 3 day(s) starts after start of "Occurrence A of Encounter, Performed: Ambulatory/ED Visit"
 *         AND:
 *             OR: "Occurrence A of Encounter, Performed: Ambulatory/ED Visit" during
 *                 OR: "Occurrence A of Diagnosis, Active: Acute Pharyngitis"
 *                 OR: "Occurrence A of Diagnosis, Active: Acute Tonsillitis"
 *             OR:
 *                 OR: "Occurrence A of Diagnosis, Active: Acute Pharyngitis"
 *                 OR: "Occurrence A of Diagnosis, Active: Acute Tonsillitis"
 *                 starts during "Occurrence A of Encounter, Performed: Ambulatory/ED Visit"
 *
 * Denominator =
 *     AND: "Initial Patient Population"
 *
 * Denominator Exclusions =
 *     AND: "Medication, Active: Antibiotic Medications" <= 30 day(s) starts before start of
 *         OR: "Occurrence A of Diagnosis, Active: Acute Pharyngitis"
 *         OR: "Occurrence A of Diagnosis, Active: Acute Tonsillitis"
 *
 * Numerator =
 *     AND:
 *         OR: "Laboratory Test, Result: Group A Streptococcus Test (result)" <= 3 day(s) starts before or during "Occurrence A of Encounter, Performed: Ambulatory/ED Visit"
 *         OR: "Laboratory Test, Result: Group A Streptococcus Test (result)" <= 3 day(s) starts after end of "Occurrence A of Encounter, Performed: Ambulatory/ED Visit"
 *
 * Denominator Exceptions =
 *     None
 * ============================================================================
 */

/*
 * This take differs from the original in that it uses a function for the
 * repeated timing logic between the encounter and pharyngitis.
 */

/*
	CMS55v1 NQF0495
	Median Time from ED Arrival to ED Departure for Admitted ED Patients

Population criteria

    Initial Patient Population =
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge datetime)" during "Measurement Period"
    Measure Population =
        AND: "Initial Patient Population"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"

Measure observations

    Median of:Time difference of:
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location arrival datetime)"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"

Data criteria (QDM Data Elements)

    "Diagnosis, Active: Psychiatric/Mental Health Patient" using "Psychiatric/Mental Health Patient Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.299)"
    "Encounter, Performed: Emergency Department Visit" using "Emergency Department Visit Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.293)"
    "Encounter, Performed: Encounter Inpatient" using "Encounter Inpatient SNOMED-CT Value Set (2.16.840.1.113883.3.666.5.307)"
    Attribute: "Ordinality: Principal Diagnosis" using "Principal Diagnosis SNOMED-CT Value Set (2.16.840.1.113883.3.117.2.7.1.14)"

Reporting Stratification

    Reporting Stratum 1 =
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
    Reporting Stratum 2 =
        AND NOT: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"
    Reporting Stratum 3 =
        AND: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"

Supplemental Data Elements

    "Patient Characteristic Ethnicity: Ethnicity" using "Ethnicity CDC Value Set (2.16.840.1.114222.4.11.837)"
    "Patient Characteristic Payer: Payer" using "Payer Source of Payment Typology Value Set (2.16.840.1.114222.4.11.3591)"
    "Patient Characteristic Race: Race" using "Race CDC Value Set (2.16.840.1.114222.4.11.836)"
    "Patient Characteristic Sex: ONC Administrative Sex" using "ONC Administrative Sex Administrative Sex Value Set (2.16.840.1.113762.1.4.1)"

*/

// Warfarin time in therapeutic range

/*
	CMS55v1 NQF0495
	Median Time from ED Arrival to ED Departure for Admitted ED Patients

Population criteria

    Initial Patient Population =
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge datetime)" during "Measurement Period"
    Measure Population =
        AND: "Initial Patient Population"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"

Measure observations

    Median of:Time difference of:
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location arrival datetime)"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"

Data criteria (QDM Data Elements)

    "Diagnosis, Active: Psychiatric/Mental Health Patient" using "Psychiatric/Mental Health Patient Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.299)"
    "Encounter, Performed: Emergency Department Visit" using "Emergency Department Visit Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.293)"
    "Encounter, Performed: Encounter Inpatient" using "Encounter Inpatient SNOMED-CT Value Set (2.16.840.1.113883.3.666.5.307)"
    Attribute: "Ordinality: Principal Diagnosis" using "Principal Diagnosis SNOMED-CT Value Set (2.16.840.1.113883.3.117.2.7.1.14)"

Reporting Stratification

    Reporting Stratum 1 =
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
    Reporting Stratum 2 =
        AND NOT: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"
    Reporting Stratum 3 =
        AND: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"

Supplemental Data Elements

    "Patient Characteristic Ethnicity: Ethnicity" using "Ethnicity CDC Value Set (2.16.840.1.114222.4.11.837)"
    "Patient Characteristic Payer: Payer" using "Payer Source of Payment Typology Value Set (2.16.840.1.114222.4.11.3591)"
    "Patient Characteristic Race: Race" using "Race CDC Value Set (2.16.840.1.114222.4.11.836)"
    "Patient Characteristic Sex: ONC Administrative Sex" using "ONC Administrative Sex Administrative Sex Value Set (2.16.840.1.113762.1.4.1)"

*/

/* ============================================================================
 * QDM Logic
 * ============================================================================
 * Initial Patient Population =
 *     AND: "Diagnosis, Active: Asthma (ordinality: 'Principal')" starts during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" >= 2 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" <= 17 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient" ends during "Measurement Period"
 *
 * Denominator =
 *     AND: "Initial Patient Population"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge status: 'Discharge To Home Or Police Custody')"
 *
 * Denominator Exclusions =
 *     None
 *
 * Numerator =
 *     AND:
 *         OR: "Communication: From Provider to Patient: Asthma Management Plan"
 *         OR: "Communication: From Provider to Patient not done: Patient Refusal" for "Asthma Management Plan"
 *         during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *
 * Denominator Exceptions =
 *     None
 * ============================================================================
 */








using

/*
	CMS55v1 NQF0495
	Median Time from ED Arrival to ED Departure for Admitted ED Patients

Population criteria

    Initial Patient Population =
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
        AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge datetime)" during "Measurement Period"
    Measure Population =
        AND: "Initial Patient Population"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"

Measure observations

    Median of:Time difference of:
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location arrival datetime)"
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit (facility location departure datetime)"

Data criteria (QDM Data Elements)

    "Diagnosis, Active: Psychiatric/Mental Health Patient" using "Psychiatric/Mental Health Patient Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.299)"
    "Encounter, Performed: Emergency Department Visit" using "Emergency Department Visit Grouping Value Set (2.16.840.1.113883.3.117.1.7.1.293)"
    "Encounter, Performed: Encounter Inpatient" using "Encounter Inpatient SNOMED-CT Value Set (2.16.840.1.113883.3.666.5.307)"
    Attribute: "Ordinality: Principal Diagnosis" using "Principal Diagnosis SNOMED-CT Value Set (2.16.840.1.113883.3.117.2.7.1.14)"

Reporting Stratification

    Reporting Stratum 1 =
        AND: "Occurrence A of Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
    Reporting Stratum 2 =
        AND NOT: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"
    Reporting Stratum 3 =
        AND: "Diagnosis, Active: Psychiatric/Mental Health Patient (ordinality: 'Principal Diagnosis')" starts during "Occurrence A of Encounter, Performed: Emergency Department Visit"

Supplemental Data Elements

    "Patient Characteristic Ethnicity: Ethnicity" using "Ethnicity CDC Value Set (2.16.840.1.114222.4.11.837)"
    "Patient Characteristic Payer: Payer" using "Payer Source of Payment Typology Value Set (2.16.840.1.114222.4.11.3591)"
    "Patient Characteristic Race: Race" using "Race CDC Value Set (2.16.840.1.114222.4.11.836)"
    "Patient Characteristic Sex: ONC Administrative Sex" using "ONC Administrative Sex Administrative Sex Value Set (2.16.840.1.113762.1.4.1)"

*/

/* ============================================================================
 * QDM Logic
 * ============================================================================
 * Initial Patient Population =
 *     AND: "Diagnosis, Active: Asthma (ordinality: 'Principal')" starts during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" >= 2 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" <= 17 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient" ends during "Measurement Period"
 *
 * Denominator =
 *     AND: "Initial Patient Population"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge status: 'Discharge To Home Or Police Custody')"
 *
 * Denominator Exclusions =
 *     None
 *
 * Numerator =
 *     AND:
 *         OR: "Communication: From Provider to Patient: Asthma Management Plan"
 *         OR: "Communication: From Provider to Patient not done: Patient Refusal" for "Asthma Management Plan"
 *         during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *
 * Denominator Exceptions =
 *     None
 * ============================================================================
 */

QUICK

/* ============================================================================
 * QDM Logic
 * ============================================================================
 * Initial Patient Population =
 *     AND: "Diagnosis, Active: Asthma (ordinality: 'Principal')" starts during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" >= 2 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" <= 17 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient" ends during "Measurement Period"
 *
 * Denominator =
 *     AND: "Initial Patient Population"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge status: 'Discharge To Home Or Police Custody')"
 *
 * Denominator Exclusions =
 *     None
 *
 * Numerator =
 *     AND:
 *         OR: "Communication: From Provider to Patient: Asthma Management Plan"
 *         OR: "Communication: From Provider to Patient not done: Patient Refusal" for "Asthma Management Plan"
 *         during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *
 * Denominator Exceptions =
 *     None
 * ============================================================================
 */


valueset

/* ============================================================================
 * QDM Logic
 * ============================================================================
 * Initial Patient Population =
 *     AND: "Diagnosis, Active: Asthma (ordinality: 'Principal')" starts during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" >= 2 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Patient Characteristic Birthdate: birth date" <= 17 year(s) starts before start of "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (length of stay <= 120 day(s))"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient" ends during "Measurement Period"
 *
 * Denominator =
 *     AND: "Initial Patient Population"
 *     AND: "Occurrence A of Encounter, Performed: Encounter Inpatient (discharge status: 'Discharge To Home Or Police Custody')"
 *
 * Denominator Exclusions =
 *     None
 *
 * Numerator =
 *     AND:
 *         OR: "Communication: From Provider to Patient: Asthma Management Plan"
 *         OR: "Communication: From Provider to Patient not done: Patient Refusal" for "Asthma Management Plan"
 *         during "Occurrence A of Encounter, Performed: Encounter Inpatient"
 *
 * Denominator Exceptions =
 *     None
 * ============================================================================
 */
"Flutter Diagnosis": '2.16.840.1.113883.3.117.1.7.1.202'
valueset "Warfarin Medication": '2.16.840.1.113883.3.117.1.7.1.232'
valueset "Face-to-face Encounter": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Valvular Heart Disease": '2.16.840.1.113883.3.464.1003.104.12.1017'
valueset "INR Lab Result": '2.16.840.1.113883.3.117.1.7.1.213'

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0)]