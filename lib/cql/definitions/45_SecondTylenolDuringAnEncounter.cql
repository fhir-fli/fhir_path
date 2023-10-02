
using QDM version '5.3'

valueset "Tylenol": 'urn:oid:1.2.3.4.5'
valueset "Inpatient": 'urn:oid:1.2.3.4.5'

parameter "Measurement Period" Interval<DateTime>


  ["Encounter, Performed": "Inpatient"] Encounter
    where Encounter.relevantPeriod during "Measurement Period"
    
  ["Medication, Administered": "Tylenol"] Medication
    where Medication.relevantPeriod during "Measurement Period"

// This returns a list of Tylenol Administrations that are the second Tylenol Administration
// During the Encounter  
  "Inpatient Encounter" Encounter
    return ("Tylenol Administration" Administration
        where Administration.relevantPeriod during Encounter.relevantPeriod)[1]

// To return Encounters together with the second Tylenol Administration during that encounter