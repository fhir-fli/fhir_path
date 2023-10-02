
using QDM version '5.5'

include MATGlobalCommonFunctions version '5.0.000' called Global

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'

valueset "Active Bleeding": 'urn:oid:2.16.840.1.113762.1.4.1029.211'
valueset "Anticoagulant Medications, Injection": 'urn:oid:2.16.840.1.113762.1.4.1206.21'
valueset "Anticoagulant Medications, Oral": 'urn:oid:2.16.840.1.113762.1.4.1206.20'
valueset "Atrial Fibrillation": 'urn:oid:2.16.840.1.113883.17.4077.3.1001'
valueset "Blood Transfusion Administration": 'urn:oid:2.16.840.1.113762.1.4.1029.209'
valueset "Cancer": 'urn:oid:2.16.840.1.113883.3.526.3.1010'
valueset "Coagulation Disorder Conditions": 'urn:oid:2.16.840.1.113762.1.4.1206.17'
valueset "Comorbidity Risk Factors": 'urn:oid:2.16.840.1.113762.1.4.1206.13'
valueset "Current Smoking Tobacco User": 'urn:oid:2.16.840.1.113762.1.4.1111.99'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Fracture Exclusions For Hip And Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.2'
valueset "General Major Bleeding Events": 'urn:oid:2.16.840.1.113762.1.4.1179.5'
valueset "General Surgery": 'urn:oid:2.16.840.1.113762.1.4.1206.15'
valueset "Left Against Medical Advice": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.308'
valueset "Malignant Neoplasm Complications Related To Hip and Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.7'
valueset "Mechanical Complications Related To Hip and Knee Procedures": 'urn:oid:2.16.840.1.113762.1.4.1206.1'
valueset "Nonprimary Total Hip, Total Knee Replacement": 'urn:oid:2.16.840.1.113762.1.4.1206.5'
valueset "Postoperative Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1070'
valueset "Pulmonary Embolism or DVT": 'urn:oid:2.16.840.1.113883.17.4077.3.1036'
valueset "Renal insufficiency": 'urn:oid:2.16.840.1.113883.3.3157.1330'
valueset "Tobacco Use Screening": 'urn:oid:2.16.840.1.113883.3.526.3.1278'
valueset "Total Hip, Total Knee Replacement": 'urn:oid:2.16.840.1.113762.1.4.1029.96'
valueset "Transfer From Acute Care Hospital": 'urn:oid:2.16.840.1.113883.13.190.5.43'
valueset "Treatment of Hemorrhage or Hematoma": 'urn:oid:2.16.840.1.113762.1.4.1206.14'
valueset "Venous Thromboembolism": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.279'

code "Body mass index (BMI) [Ratio]": '39156-5' from "LOINC" display 'Body mass index (BMI) [Ratio]'
code "Hospital-based outpatient emergency care center (environment)": '73770003' from "SNOMEDCT" display 'Hospital-based outpatient emergency care center (environment)'
code "Outpatient surgery service (qualifier value)": '2621000175106' from "SNOMEDCT" display 'Outpatient surgery service (qualifier value)'

parameter "Measurement Period" Interval<DateTime>
