
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
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


using QUICK

valueset "Asthma": '2.16.840.1.113883.3.117.1.7.1.271'
valueset "Asthma Management Plan": '2.16.840.1.113883.3.117.1.7.1.131'
valueset "Home Discharge Disposition": 'TBD'
valueset "Doctor": 'TBD'

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0)]