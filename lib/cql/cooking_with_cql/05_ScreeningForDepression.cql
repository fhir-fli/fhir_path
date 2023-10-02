library ScreeningForDepression

using QDM

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Initial Population":
  "In Demographic"
    and exists ( "Valid Encounter During Measurement Period" )

define "Denominator":
  true

define "Numerator":
  exists ( "Screening For Depression" )

/*
    Initial Population =
        AND: Age>= 18 year(s) at: "Measurement Period"
        AND: "Occurrence A of Encounter, Performed: Medications Encounter Code Set" during "Measurement Period"
*/

/*
    Denominator =
        AND: Initial Population
*/

/*
    Numerator Exclusions =
        None
*/

/*
    Numerator =
        AND: "Procedure, Performed: Current Medications Documented SNMD" during "Occurrence A of Encounter, Performed: Medications Encounter Code Set"
*/

/*
    Denominator Exclusions =
        None
*/

/*
    Denominator Exceptions =
        OR: "Procedure, Performed not done: Medical or Other reason not done" for "Current Medications Documented SNMD" during "Occurrence A of Encounter, Performed: Medications Encounter Code Set"
*/

/*
    Stratification =
        None
*/

// Supplemental Data:

/*
    Initial Population =
        AND: Age>= 18 year(s) at: "Measurement Period"
        AND: "Occurrence A of Encounter, Performed: BP Screening Encounter Codes" during "Measurement Period"
*/

/*
    Denominator =
        AND: Initial Population
*/

/*
    Numerator =
        AND: Most Recent:
            "Occurrence A of Encounter, Performed: BP Screening Encounter Codes" satisfies all:
                overlaps "Physical Exam, Performed: Diastolic Blood Pressure (result)"
                overlaps "Physical Exam, Performed: Systolic Blood Pressure (result)"
        AND:
            OR:
                AND: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                    Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    (result < 120 mmHg)
                AND: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                    Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    (result < 80 mmHg)
            OR:
                AND:
                    OR:
                        AND: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                            Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result >= 120 mmHg)
                            (result < 140 mmHg)
                        AND: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                            Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result < 90 mmHg)
                    OR:
                        AND: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                            Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result >= 80 mmHg)
                            (result < 90 mmHg)
                        AND: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                            Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result < 140 mmHg)
                AND:
                    OR: "Intervention, Order: Referral to Alternative Provider / Primary Care Provider (reason: Finding of Hypertension)" <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    OR:
                        AND: $HypertensionRecommendations <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        AND: "Intervention, Order: Followup within one year (reason: Finding of Hypertension)" <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
            OR:
                AND:
                    OR:
                        AND NOT: "Physical Exam, Performed: Systolic Blood Pressure (result)" < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        AND NOT: "Physical Exam, Performed: Diastolic Blood Pressure (result)" < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    OR:
                        AND: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                            Most Recent: < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result < 140 mmHg)
                        AND: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                            Most Recent: < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                            (result < 90 mmHg)
                AND:
                    OR: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                        Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 140 mmHg)
                    OR: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                        Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 90 mmHg)
                AND:
                    OR: "Intervention, Order: Referral to Alternative Provider / Primary Care Provider (reason: Finding of Hypertension)" <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    OR:
                        AND: $HypertensionRecommendations <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        AND: "Intervention, Order: Followup within 4 weeks (reason: Finding of Hypertension)" <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
            OR:
                AND:
                    OR: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                        Most Recent: < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 140 mmHg)
                    OR: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                        Most Recent: < 1 year(s) starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 90 mmHg)
                AND:
                    OR: "Physical Exam, Performed: Systolic Blood Pressure" satisfies all:
                        Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 140 mmHg)
                    OR: "Physical Exam, Performed: Diastolic Blood Pressure" satisfies all:
                        Most Recent: during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        (result >= 90 mmHg)
                AND:
                    OR: "Intervention, Order: Referral to Alternative Provider / Primary Care Provider (reason: Finding of Hypertension)" <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                    OR:
                        AND: $HypertensionRecommendations <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
                        AND: Union of:
                            "Medication, Order: Anti-Hypertensive Pharmacologic Therapy"
                            "Laboratory Test, Order: Laboratory Tests for Hypertension"
                            "Diagnostic Study, Order: ECG 12 lead or study order"
                            <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
*/

/*
    $HypertensionRecommendations =
        Union of:
            "Intervention, Order: Lifestyle Recommendation"
            "Intervention, Order: Weight Reduction Recommended"
            "Intervention, Order: Dietary Recommendations"
            "Intervention, Order: Physical Activity Recommendation"
            "Intervention, Order: Moderation of ETOH Consumption Recommendation"
*/

/*
    Denominator Exceptions =
        OR: Union of:
            "Physical Exam, Performed not done: Medical or Other reason not done" for "Diastolic Blood Pressure"
            "Physical Exam, Performed not done: Patient Reason refused" for "Diastolic Blood Pressure"
            "Physical Exam, Performed not done: Medical or Other reason not done" for "Systolic Blood Pressure"
            "Physical Exam, Performed not done: Patient Reason refused" for "Systolic Blood Pressure"
            starts during "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
        OR: Union of:
            "Intervention, Order not done: Patient Reason refused" for "Referral to Alternative Provider / Primary Care Provider"
            "Intervention, Order not done: Patient Reason refused" for "Lifestyle Recommendation"
            "Intervention, Order not done: Patient Reason refused" for "Weight Reduction Recommended"
            "Intervention, Order not done: Patient Reason refused" for "Dietary Recommendations"
            "Intervention, Order not done: Patient Reason refused" for "Physical Activity Recommendation"
            "Intervention, Order not done: Patient Reason refused" for "Moderation of ETOH Consumption Recommendation"
            "Medication, Order not done: Patient Reason refused" for "Anti-Hypertensive Pharmacologic Therapy"
            "Laboratory Test, Order not done: Patient Reason refused" for "Laboratory Tests for Hypertension"
            "Diagnostic Study, Order not done: Patient Reason refused" for "ECG 12 lead or study order"
            <= 1 day(s) starts after or concurrent with start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
*/

/*
    Denominator Exclusions =
        OR: "Diagnosis: Diagnosis of hypertension" starts before start of "Occurrence A of Encounter, Performed: BP Screening Encounter Codes"
*/

/*
    Numerator Exclusions =
        None
*/

/*
    Stratification =
        None
*/

// Supplemental Data