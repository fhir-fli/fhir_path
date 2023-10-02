
using QDM version '5.5'

/*
Timing with choice elements in QDM
in QDM 5.5, many data types were extended with relevantDatetime attributes:

AssessmentPerformed
DeviceApplied
DiagnosticStudyPerformed
InterventionPerformed
LaboratoryTestPerformed
MedicationActive
MedicationAdministered
MedicationDispensed
PhysicalExamPerformed
ProcedurePerformed
SubstanceAdministered

Although they are declared as separate attributes, the guidance in QRDA indicates
instances must treat them as mutually exclusive, so they are effectively "choice"
types.

Is there a potential for defining a "Normalize Interval" function that would enable
more flexible CQL that could work however the data was communicated?
*/
