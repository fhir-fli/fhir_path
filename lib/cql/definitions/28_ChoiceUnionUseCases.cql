
using QDM version '5.0.2'

// "Choice" Union Use Cases

codesystem "SNOMED-CT": 'X.Y.Z'

valueset "Comfort Measures": 'TBD'
valueset "Inpatient": 'TBD'
valueset "Emergency Department Visit": 'TBD'

valueset "Antithrombotic Therapy": 'X.Y.Z'
valueset "Medical Reason": 'X.Y.Z'
valueset "Patient Refusal": 'X.Y.Z'

valueset "Unfractionated Heparin": 'X.Y.Z'
valueset "Intravenous route": 'X.Y.Z'
valueset "Direct Thrombin Inhibitor": 'X.Y.Z'
valueset "Glycoprotein IIb/IIIa Inhibitors": 'X.Y.Z'
valueset "VTE Risk Assessment": 'X.Y.Z'
valueset "INR": 'X.Y.Z'

code "Low Risk": 'XYZ' from "SNOMED-CT"

// Use Case 1: Union 2 different datatypes:

/*
QDM version:
  $InterventionComfortMeasures = 
    Union of: 
      "Intervention, Order: Comfort Measures" 
      "Intervention, Performed: Comfort Measures" 

  OR: $InterventionComfortMeasures starts during ("Encounter, Performed: Emergency Department Visit" <= 1 hour(s) ends before or concurrent with start of Occurrence A of $EncounterInpatientNonElective ) 
  OR: $InterventionComfortMeasures starts during Occurrence A of $EncounterInpatientNonElective 
*/  

/*
Current CQL Version:
