
/*
Percentage of final reports for all patients, regardless of age, undergoing non-CNS oncologic FDG PET studies that include at a minimum:
a.	Serum glucose (e.g., finger stick at time of injection)
b.	Uptake time (interval from injection to initiation of imaging)
c.	One reference background (e.g., volumetric normal liver or mediastinal blood pool) SUV measurement, along with description of the SUV measurement type (eg, SUVmax) and normalization method (e.g., BMI)
At least one lesional SUV measurement OR diagnosis of "no disease-specific abnormal uptake" 
*/

/*
Denominator
All final reports for all patients, regardless of age, undergoing  non-CNS oncologic FDG PET studies 
*/

  ["Diagnostic Study, Performed": "FDG PET Scan"]

  "FDG PET Scan Performed"

/*
Numerator
Final reports for FDG PET scans that include at a minimum:
a.	Serum glucose (eg, finger stick at time of injection)
b.	Uptake time (interval from injection to initiation of imaging)
c.	One reference background (eg, volumetric normal liver or mediastinal blood pool) SUV measurement, along with description of the SUV measurement type (eg, SUVmax) and normalization method (eg, BMI)
d.	At least one lesional SUV measurement OR diagnosis of "no disease-specific abnormal uptake"
*/

  "FDG PET Scan Performed" P
    with "Serum Glucose" S such that S.relevantPeriod starts within 1 hour of start of P.relevantPeriod
    //with "Uptake Time" T such that T.relevantPeriod starts within 1 hour of end of P.relevantPeriod
    with "Reference Background" R such that R.relevantPeriod starts within 1 hour of start of P.relevantPeriod
    where (exists ("Lesional SUV Measurement") or exists ("No Disease-specific Abnormal Uptake"))
      and exists (P.components C where C.code in "Uptake Time" and C.value is not null)
      
  ["Laboratory Test, Performed": "Serum Glucose Test"]
  
  // Assessment?
  
  // Study?
  // It seems that the type and description of the measurement would be terminology?
  // The normalization method would be the "method" in the study?

  // Study?
  