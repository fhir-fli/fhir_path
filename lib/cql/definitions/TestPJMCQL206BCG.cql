
/*Testing only
based on:
IntravesicalBacillusCalmetteGuerinfornonmuscleinvasivebladdercancer version '0.1.008'
Recommend caution re length of library name since can afffect zip files.
Comments added within test script near associated definition.*/

using QDM version '5.5'

codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "ICD10CM": 'urn:oid:2.16.840.1.113883.6.90'

valueset "Active Tuberculosis for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.56'
valueset "BCG Bacillus Calmette Guerin for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.52'
valueset "Bladder Cancer for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.45'
valueset "Bladder Cancer Staging Tis for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.58'
valueset "Cystectomy for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.55'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "HIV": 'urn:oid:2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Immunocompromised Conditions": 'urn:oid:2.16.840.1.113883.3.666.5.1940'
valueset "Immunosuppressive Drugs for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.32'
valueset "Mixed histology urothelial cell carcinoma for Urology Care": 'urn:oid:2.16.840.1.113762.1.4.1151.39'
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Unavailability of Bacillus Calmette Guerin for urology care": 'urn:oid:2.16.840.1.113762.1.4.1151.44'

code "Birth date": '21112-8' from "LOINC" display 'Birth date'
code "Cancer staging (tumor staging)": '258232002' from "SNOMEDCT" display 'Cancer staging (tumor staging)'
code "Carcinoma in situ of bladder": 'D09.0' from "ICD10CM" display 'Carcinoma in situ of bladder'
code "Chemotherapy care (regime/therapy)": '385786002' from "SNOMEDCT" display 'Chemotherapy care (regime/therapy)'
code "Combined radiotherapy (procedure)": '169331000' from "SNOMEDCT" display 'Combined radiotherapy (procedure)'
code "Dead (finding)": '419099009' from "SNOMEDCT" display 'Dead (finding)'
code "High grade histologic differentiation (finding)": '399611001' from "SNOMEDCT" display 'High grade histologic differentiation (finding)'
code "T1: Tumor invades lamina propria or submucosa (finding)": '369909002' from "SNOMEDCT" display 'T1: Tumor invades lamina propria or submucosa (finding)'
code "Ta: Noninvasive papillary carcinoma (urinary tract) (finding)": '369949005' from "SNOMEDCT" display 'Ta: Noninvasive papillary carcinoma (urinary tract) (finding)'

parameter "Measurement Period" Interval<DateTime>
