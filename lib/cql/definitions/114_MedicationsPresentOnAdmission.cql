
/*
What is the best way to specify in CQL that a medication was present on admission
for an inpatient encounter. There have been conversations recently about a
"presentOnAdmissionIndicator" for diagnoses in QDM 5.5, but not something equivalent
for medications.

There are some examples of possible workarounds (e.g. medication active before the start of
an encounter), but it's not clear whether this approach will work.

We understand, of course, that having a way to specify this in CQL is not the same as 
assuring that the medication list is up to date, or that it would clearly delineate 
between medications that were truly "present on admission" and those initiated in 
the hospital, but we are looking for the clearest way to use logic to express our intent.  
*/

using QDM version '5.4'
