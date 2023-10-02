
using QDM version '5.0.2'

valueset "ONC Administrative Sex (1)": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "ONC Administrative Sex (2)": 'urn:oid:2.16.840.1.113762.1.4.2'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Medications Encounter Code Set": 'urn:oid:2.16.840.1.113883.3.600.1.1834'
valueset "Current Medications Documented SNMD": 'urn:oid:2.16.840.1.113883.3.600.1.462'
valueset "Medical or Other reason not done": 'urn:oid:2.16.840.1.113883.3.600.1.1502'

parameter "Measurement Period" Interval<DateTime>


  ["Encounter, Performed": "Medications Encounter Code Set"]

  "Encounter" Encounter
    where Encounter.relevantPeriod during "Measurement Period"

  "Encounters during Measurement Period" Encounter
    where AgeInYearsAt(start of "Measurement Period") >= 18

  "Initial Population"

  "Encounters during Measurement Period" Encounter
    with ["Procedure, Performed": "Current Medications Documented SNMD"] Procedure
      such that Procedure.relevantPeriod during Encounter.relevantPeriod

  "Medications Documented"

  ["Procedure, Not Performed": "Current Medications Documented SNMD"] Performed
    where Performed.negationRationale in "Medical or Other reason not done"

  "Encounters during Measurement Period" Enc
    with "Medications Not Documented for Medical Reason" Meds
      such that Meds.authorDatetime during Enc.relevantPeriod

  ["Patient Characteristic Ethnicity": "Ethnicity"]

  ["Patient Characteristic Payer": "Payer"]

  ["Patient Characteristic Race": "Race"]
