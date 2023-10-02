
/*
Update to 5.6 to get class attribute
*/
using QDM version '5.6'

include Adult_Outpatient_Encounters version '1.3.000' called AdultOutpatientEncounters
include MATGlobalCommonFunctions version '6.2.000' called Global
include Hospice version '2.2.000' called Hospice
include AdvancedIllnessandFrailtyExclusionECQM version '5.5.000' called FrailtyLTI

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Chronic Kidney Disease, Stage 5": 'urn:oid:2.16.840.1.113883.3.526.3.1002'
valueset "Dialysis Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1013'
valueset "ED": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1085'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "End Stage Renal Disease": 'urn:oid:2.16.840.1.113883.3.526.3.353'
valueset "ESRD Monthly Outpatient Services": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1014'
valueset "Essential Hypertension": 'urn:oid:2.16.840.1.113883.3.464.1003.104.12.1011'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Kidney Transplant": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1012'
valueset "Kidney Transplant Recipient": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1029'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pregnancy": 'urn:oid:2.16.840.1.113883.3.526.3.378'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Vascular Access for Dialysis": 'urn:oid:2.16.840.1.113883.3.464.1003.109.12.1011'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'

parameter "Measurement Period" Interval<DateTime>


  ["Patient Characteristic Ethnicity": "Ethnicity"]

  ["Patient Characteristic Payer": "Payer"]

  ["Patient Characteristic Race": "Race"]

  ["Patient Characteristic Sex": "ONC Administrative Sex"]

  "Has Diastolic Blood Pressure Less Than 90"
    and "Has Systolic Blood Pressure Less Than 140"

  ( ["Diagnosis": "Pregnancy"]
    union ["Diagnosis": "End Stage Renal Disease"]
    union ["Diagnosis": "Kidney Transplant Recipient"]
    union ["Diagnosis": "Chronic Kidney Disease, Stage 5"] ) PregnancyESRDDiagnosis
    where PregnancyESRDDiagnosis.prevalencePeriod overlaps "Measurement Period"

  "Initial Population"

  ["Encounter, Performed": "ESRD Monthly Outpatient Services"] ESRDEncounter
    where ESRDEncounter.relevantPeriod starts before
    end of "Measurement Period"

/*
Then you can combine specific type codes with the class codes:
*/
  ["Encounter, Performed": class in Global."Ambulatory Encounter Class"] ESRDEncounter
    where ESRDEncounter.code in "ESRD Monthly Outpatient Services"
      and ESRDEncounter.relevantPeriod starts before end of "Measurement Period"

  ( ["Procedure, Performed": "Vascular Access for Dialysis"]
    union ["Procedure, Performed": "Kidney Transplant"]
    union ["Procedure, Performed": "Dialysis Services"] ) ESRDProcedure
    where ESRDProcedure.relevantPeriod starts before
    end of "Measurement Period"

  "Lowest Diastolic Reading on Most Recent Blood Pressure Day".result < 90 'mm[Hg]'

  "Lowest Systolic Reading on Most Recent Blood Pressure Day".result < 140 'mm[Hg]'

  First("Qualifying Diastolic Blood Pressure Reading" DBPReading
      where DBPReading.relevantDatetime same day as "Most Recent Blood Pressure Day"
      sort by(result as Quantity)
  )

  First("Qualifying Systolic Blood Pressure Reading" SBPReading
      where SBPReading.relevantDatetime same day as "Most Recent Blood Pressure Day"
      sort by(result as Quantity)
  )

  ( ( "Qualifying Diastolic Blood Pressure Reading" DBPExam
        return date from DBPExam.relevantDatetime
    )
      intersect ( "Qualifying Systolic Blood Pressure Reading" SBPExam
          return date from SBPExam.relevantDatetime
      )
  )

  exists ["Patient Characteristic Birthdate": "Birth date"] BirthDate
    where Global."CalendarAgeInYearsAt" ( BirthDate.birthDatetime, start of "Measurement Period" ) in Interval[18, 85 )
      and exists "Essential Hypertension Diagnosis"
      and exists AdultOutpatientEncounters."Qualifying Encounters"

  ["Physical Exam, Performed": "Diastolic blood pressure"] DiastolicBP
    without ( ["Encounter, Performed": "Encounter Inpatient"]
      union ["Encounter, Performed": "ED"] ) DisqualifyingEncounter
      such that DiastolicBP.relevantDatetime during DisqualifyingEncounter.relevantPeriod
    where DiastolicBP.result.unit = 'mm[Hg]'
  //	and DiastolicBP.result is Quantity
      and DiastolicBP.relevantDatetime during "Measurement Period"

  ["Physical Exam, Performed": "Systolic blood pressure"] SystolicBP
    without ( ["Encounter, Performed": "Encounter Inpatient"]
      union ["Encounter, Performed": "ED"] ) DisqualifyingEncounter
      such that SystolicBP.relevantDatetime during DisqualifyingEncounter.relevantPeriod
    where SystolicBP.result.unit = 'mm[Hg]'
  //	and SystolicBP.result is Quantity
      and SystolicBP.relevantDatetime during "Measurement Period"

  Hospice."Has Hospice"
    or exists ( "Pregnancy Or Renal Diagnosis Exclusions" )
    or ( exists ( "End Stage Renal Disease Procedures" )
        or exists ( "End Stage Renal Disease Encounter" )
    )
    or ( exists ( ["Patient Characteristic Birthdate": "Birth date"] BirthDate
          where Global."CalendarAgeInYearsAt" ( BirthDate.birthDatetime, start of "Measurement Period" ) >= 65
      )
        and ( FrailtyLTI."Long Term Care Periods Longer Than 90 Consecutive Days" )
    )
    or FrailtyLTI."Advanced Illness and Frailty Exclusion Including Over Age 80"

  Last("Blood Pressure Days" BPDays
      sort ascending
  )
