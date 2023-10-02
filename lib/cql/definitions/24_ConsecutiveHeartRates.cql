
using QDM version '5.0.2'

/*
Coronary Artery Disease (CAD): Beta Blocker Therapy Prior Myocardial Infarction (MI) 
or Left Ventricular Systolic Dysfunction (LVEF < 40%)

Patient-based Proportion Measure
*/

valueset "Heart Rate": 'X.Y.Z'

/*
Specifically:

AND: Most Recent: "Occurrence B of Physical Exam, Performed: Heart Rate" 
  starts before start of "Occurrence A of Physical Exam, Performed: Heart Rate" 
AND: "Occurrence A of Physical Exam, Performed: Heart Rate (result < 50 bpm)" 
  during Occurrence A of $CADEncounters145 
AND: "Occurrence B of Physical Exam, Performed: Heart Rate (result < 50 bpm)" 
  during Occurrence A of $CADEncounters145  
*/
