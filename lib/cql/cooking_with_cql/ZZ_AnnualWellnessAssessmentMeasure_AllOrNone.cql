library ZZ_AnnualWellnessAssessmentMeasure_AllOrNone

using QDM

include 01_ScreeningForAlcoholMisuse called "Screening For Alcohol Misuse"
include 02_HypertensionAssessment called "Hypertension Assessment"
include 03_ScreeningForBreastCancer called "Screening For Breast Cancer"
include 04_ScreeningForColorectalCancer called "Screening For Colorectal Cancer"
include 05_ScreeningForDepression called "Screening For Depression"

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Initial Population":
  // True if any initial population is true
  "Screening For Alcohol Misuse"."Initial Population"
    or "Hypertension Assessment"."Initial Population"
    or "Screening For Breast Cancer"."Initial Population"
    or "Screening For Colorectal Cancer"."Initial Population"
    or "Screening For Depression"."Initial Population"

define "Denominator":
  // True if any denominator is true
  "Screening For Alcohol Misuse"."Denominator"
    or "Hypertension Assessment"."Denominator"
    or "Screening For Breast Cancer"."Denominator"
    or "Screening For Colorectal Cancer"."Denominator"
    or "Screening For Depression"."Denominator"

define "Numerator":
  // True if and only if all numerators are true
  "Screening For Alcohol Misuse"."Numerator"
    and "Hypertension Assessment"."Numerator"
    and "Screening For Breast Cancer"."Numerator"
    and "Screening For Colorectal Cancer"."Numerator"
    and "Screening For Depression"."Numerator"

