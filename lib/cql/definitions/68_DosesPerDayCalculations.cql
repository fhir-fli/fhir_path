
/*
Issue: Different systems will provide different data for medications, we will
review alternative approaches to calculating doses per day with QDM medication statements.
*/

/*
Source data from Medications in QDM:

*/

/*
Medication, Active
  dosage - quantity to be taken at a single administration
  supply - number of doses supplied
  frequency - how frequently the medication is administered
  relevantPeriod - covers when the medication is first known to be used to when the medication is discontinued

Medication, Administered
  dosage - quantity to be taken at a single administration
  supply - number of doses supplied
  frequency - how frequently the medication was administered
  relevantPeriod - when a single medication administration event starts to the end of the administration

Medication, Discharge
  dosage - quantity to be taken at a single administration
  frequency - how frequently the medication should be administered
  supply - number of doses supplied per refill
  refills - number of refills allowed by the prescription
  authorDatetime - when the discharge medication list was authored

Medication, Dispensed
  dosage - quantity to be taken at a single administration
  supply - number of doses supplied per refill
  frequency - how frequently the medication is administered
  refills - number of refills allowed by the prescription
  relevantPeriod - covers when the administration of the medication is expected to start and end

Medication, Order
  dosage - quantity to be taken at a single administration
  supply - number of doses supplied per refill
  frequency - how frequently the medication should be administered
  refills - number of refills allowed by the prescription
  relevantPeriod - covers when the administration of the medication is expected to start and end

*/

/*
For reference, the dosesPerDay calculation used with "QDM Medication, Order":
*/
