
using QDM version '5.0'

valueset "Cup to Disc Ratio": 'Cup to Disc Ratio'
valueset "Optic Disc Exam for Structural Abnormalities": 'Optic Disc Exam for Structural Abnormalities'
valueset "Ophthalmological Services": 'Ophthalmological Services'
valueset "Care Services in Long-Term Residential Facility": 'Care Services in Long-Term Residential Facility'
valueset "Nursing Facility Visit": 'Nursing Facility Visit'
valueset "Office Visit": 'Office Visit'
valueset "Outpatient Consultation": 'Outpatient Consultation'
valueset "Face-to-Face Interaction": 'Face-to-Face Interaction'

parameter "Measurement Period" Interval<DateTime>

/*
Numerator =
  AND: "Diagnostic Study, Performed: Cup to Disc Ratio (result)"
    during Occurrence A of $EyeCareEncounters
  AND: "Diagnostic Study, Performed: Optic Disc Exam for Structural Abnormalities (result)"
    during Occurrence A of $EyeCareEncounters
*/
