
using QDM version '5.5'

include MATGlobalCommonFunctions version '5.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Anticoagulant Medications, Injection": 'urn:oid:2.16.840.1.113762.1.4.1206.21'
valueset "Anticoagulant Medications, Oral": 'urn:oid:2.16.840.1.113762.1.4.1206.20'
valueset "Atrial Fibrillation": 'urn:oid:2.16.840.1.113883.17.4077.3.1001'
valueset "Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.1010'
valueset "Coagulation Disorder Conditions": 'urn:oid:2.16.840.1.113762.1.4.1206.17'
valueset "Comorbidity Risk Factors": 'urn:oid:2.16.840.1.113762.1.4.1206.13'
valueset "Current Smoking Tobacco User": 'urn:oid:2.16.840.1.113762.1.4.1111.99'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Fracture Exclusions For Hip And Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.2'
valueset "General Surgery": 'urn:oid:2.16.840.1.113762.1.4.1206.15'
valueset "Left Against Medical Advice": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.308'
valueset "Malignant Neoplasm Complications Related To Hip and Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.7'
valueset "Mechanical Complications Related To Hip and Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.1'
valueset "Nonprimary Total Hip, Total Knee Replacement": 'urn:oid:2.16.840.1.113762.1.4.1206.5'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Pulmonary Embolism or DVT": 'urn:oid:2.16.840.1.113883.17.4077.3.1036'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Renal insufficiency": 'urn:oid:2.16.840.1.113883.3.3157.1330'
valueset "Tobacco Use Screening": 'urn:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Total Hip, Total Knee Replacement": 'urn:oid:2.16.840.1.113762.1.4.1029.96'
valueset "Transfer From Acute Care Hospital": 'urn:oid:2.16.840.1.113883.13.190.5.43'
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279'

code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "Hospital-based outpatient emergency care center (environment)": '73770003' from "SNOMEDCT" display 'Hospital-based outpatient emergency care center (environment)'
code "Outpatient surgery service (qualifier value)": '2621000175106' from "SNOMEDCT" display 'Outpatient surgery service (qualifier value)'

parameter "Measurement Period" Interval<DateTime>


  "Initial Population"

  ["Diagnosis": "Atrial Fibrillation"] AFDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that AFDiagnosis.prevalencePeriod starts 365 days or less on or before start of QP.QProcedure.relevantPeriod

  ["Diagnosis": "Cancer"] CancerDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that CancerDiagnosis.prevalencePeriod starts 365 days or less on or before start of QP.QProcedure.relevantPeriod

  ["Diagnosis": "Coagulation Disorder Conditions"] CoagulationDisorderDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that CoagulationDisorderDiagnosis.prevalencePeriod starts 365 days or less on or before start of QP.QProcedure.relevantPeriod

  ( ["Diagnosis": "Malignant Neoplasm Complications Related To Hip and Knee Procedures"]
    union ["Diagnosis": "Mechanical Complications Related To Hip and Knee Procedures"]
    union ["Diagnosis": "Fracture Exclusions For Hip And Knee Procedures"] ) ExistingConditions
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
      such that ExistingConditions.prevalencePeriod starts 90 days or less on or before start of QE.QEncounter.relevantPeriod

  ["Diagnosis": "Renal insufficiency"] RenalDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that RenalDiagnosis.prevalencePeriod starts 365 days or less on or before start of QP.QProcedure.relevantPeriod

  ( ["Diagnosis": "Venous Thromboembolism"]
    union ["Diagnosis": "Pulmonary Embolism or DVT"] ) VTEDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
      such that VTEDiagnosis.prevalencePeriod starts 30 days or less before start of QE.QEncounter.relevantPeriod

  ( ["Diagnosis": "Venous Thromboembolism"]
    union ["Diagnosis": "Pulmonary Embolism or DVT"] ) DVTDiagnosis
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
      such that DVTDiagnosis.prevalencePeriod starts during QE.QEncounter.relevantPeriod

  Global."ED Encounter" EDVisit
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that EDVisit.relevantPeriod ends 35 days or less after start of QP.QProcedure.relevantPeriod

  "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
    with ["Patient Characteristic Birthdate"] PatientBirthday
      such that Global."CalendarAgeInYearsAt" ( PatientBirthday.birthDatetime, start of QE.QEncounter.relevantPeriod ) >= 18

  ["Diagnosis": "Comorbidity Risk Factors"] Comorbidities
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QualifyingEncounter
      such that Comorbidities.prevalencePeriod starts 12 months or less on or before start of QualifyingEncounter.QEncounter.relevantPeriod

  ["Procedure, Performed": "General Surgery"] AdditionalProcedure
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that AdditionalProcedure.relevantPeriod starts 35 days or less on or after start of QP.QProcedure.relevantPeriod

  "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
    where Count(("Primary THA-TKA Procedures"
        union "Non-Primary THA_TKA Procedures")Procedures
        where Procedures.relevantPeriod starts during QE.QEncounter.relevantPeriod
    )> 2

  "Most Recent Documented BMI" BMIValue
    where BMIValue.result included in Interval[18.5 'kg/m2', 25 'kg/m2' )

  exists "Encounter Related To Elective Primary THA and TKA Procedures With Age"

  Last(["Physical Exam, Performed": "Body mass index (BMI) [Ratio]"] LastBMI
      with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QualifyingEncounter
        such that(LastBMI.relevantPeriod starts 12 months or less on or before start of QualifyingEncounter.QEncounter.relevantPeriod
            or LastBMI.relevantPeriod starts during QualifyingEncounter.QEncounter.relevantPeriod
        )
          and LastBMI.result is not null
      sort by authorDatetime
  )

  ["Procedure, Performed": "Nonprimary Total Hip, Total Knee Replacement"] NonPrimaryProcedures
    where NonPrimaryProcedures.relevantPeriod starts during "Measurement Period"

  ["Encounter, Performed": "Hospital-based outpatient emergency care center (environment)"] OutpatientVisit
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that OutpatientVisit.relevantPeriod starts 35 days or less after QP.QProcedure.relevantPeriod

  ( ["Encounter, Performed": "Encounter Inpatient"]
    union ["Encounter, Performed": "Outpatient surgery service (qualifier value)"] ) Encounter
    where Encounter.relevantPeriod starts during "Measurement Period"

  ["Procedure, Performed": "Total Hip, Total Knee Replacement"] PrimaryProcedure
    where PrimaryProcedure.relevantPeriod starts during "Measurement Period"

  from
    "Patient Encounters" Encounter,
    "Primary THA-TKA Procedures" Procedure
    where Procedure.relevantPeriod starts during Encounter.relevantPeriod
    return {
      QEncounter: Encounter,
      QProcedure: Procedure
    }

  {
    AbnormalBMI: "Has Normal BMI" is null,
    TobacoUser: "Screened and Identified as Tobacco User" is not null,
    HadExistingComorbidities: "Existing Comorbidities Prior To Surgery"
  }

  ( Last(["Assessment, Performed": "Tobacco Use Screening"] TobaccoUseScreening
      where TobaccoUseScreening.authorDatetime 24 months or less on or before 
      end of "Measurement Period"
      sort by authorDatetime
  )) MostRecentTobaccoUseScreening
    where MostRecentTobaccoUseScreening.result in "Current Smoking Tobacco User"

  "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QE
    where QE.QEncounter.admissionSource in "Transfer From Acute Care Hospital"
      or QE.QEncounter.dischargeDisposition in "Left Against Medical Advice"

  ( ["Diagnosis": "Venous Thromboembolism"]
    union ["Diagnosis": "Pulmonary Embolism or DVT"] ) VTEDiagnosis
    with "ED Visit Within 35 Days Of The Surgery" EDVisit
      such that VTEDiagnosis.prevalencePeriod starts during EDVisit.relevantPeriod

  exists "Diagnosed With VTE or DVT During The Index Admission"
    or exists "Diagnosed With VTE or DVT in the ED Within 35 Days Of The Surgery"
    or exists "Had 2 or More VTE Diagnosis Codes During Outpatient Visit Within 35 Days Of The Surgery"

  "Outpatient Care Visit Within 35 Days Of the Surgery" OV
    where Count((["Diagnosis": "Venous Thromboembolism"]
        union ["Diagnosis": "Pulmonary Embolism or DVT"])VTEDiagnosis
        where VTEDiagnosis.prevalencePeriod starts during OV.relevantPeriod
    )>= 2

  ["Medication, Order": "Anticoagulant Medications, Injection"] AntiCoagulantMed
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that AntiCoagulantMed.relevantPeriod starts during Interval[start of QP.QProcedure.relevantPeriod - 90 days, start of QP.QProcedure.relevantPeriod - 10 days]

  exists "Transferred From Another Acute Care Facility or Discharged Against Medical Advice During Index Admission"
    or exists "Had More Than 2 THA_TKA Procedures Codes During The Index Admission"
    or exists "Diagnosed With Renal Insufficiency 365 Days Prior To Procedure"
    or exists "Diagnosed With Atrial Fibrillation 365 Days Prior To Procedure"
    or exists "Diagnosed With Cancer 365 Days Prior To Procedure"
    or exists "Received Anticoagulant Medication Injection Between 10-90 Days Prior To Surgery Date"
    or exists "Received Oral Anticoagulant Medications Between 10-90 Days Prior To Procedure"
    or exists "Diagnosed With VTE or DVT 30 Days Prior To The Index Admission"
    or exists "Diagnosed With Coagulation Disorder 365 Days Prior To Procedure"
    or exists "Diagnosed With Excluded Conditions Within 90 Days Prior To The Index Admission"
    or exists "Had Additional Surgery Within 35 Days Post-Procedure"

  ["Medication, Order": "Anticoagulant Medications, Oral"] AntiCoagulantMed
    with "Qualifying Encounters Related To Elective Primary THA and TKA Procedures" QP
      such that AntiCoagulantMed.relevantPeriod starts during Interval[start of QP.QProcedure.relevantPeriod - 90 days, start of QP.QProcedure.relevantPeriod - 10 days]
        and AntiCoagulantMed.supply.value > 1

  ["Patient Characteristic Sex": "ONC Administrative Sex"]

  ["Patient Characteristic Ethnicity": "Ethnicity"]

  ["Patient Characteristic Payer": "Payer"]
