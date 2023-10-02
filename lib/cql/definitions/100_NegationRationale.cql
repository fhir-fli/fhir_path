
/*
Two common patterns for negation used in quality measurement:

1. Absence of evidence for a particular event
2. Documentation of a reason for an event not occurring, together with a reason
*/

/*
Start with the basic pattern for "evidence for an event", specifically: 
Evidence that "Antithrombotic Therapy" (defined by a medication-specific value set) was administered:
*/

  ["Medication, Administered": "Antithrombotic Therapy"] 

/*
Then in CQL, for the "absence of evidence" pattern, specifically:
No evidence that "Antithrombotic Therapy"
*/

   not exists (
    ["Medication, Administered": "Antithrombotic Therapy"]
) 

/*
Note carefully this is _not_ using the "Not Administered" data type:
*/

/*
And finally, for a full negation rationale:
Evidence that "Antithrombotic Therapy" medication administration did not occur 
for an acceptable medical reason as defined by a value set referenced by the 
eCQM (i.e. negation rationale):
*/
