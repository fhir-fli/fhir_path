
/*
This example is taken from the following JIRA ticket:
https://oncprojectracking.healthit.gov/support/browse/CQLIT-128
*/

using QDM version '5.3'

parameter "Measurement Period" Interval<DateTime>


  "Encounter with Blood Transfusion" QualifyingEncounter
     return First("Blood Transfusion" FirstTransfusion
       where FirstTransfusion.relevantPeriod during QualifyingEncounter.relevantPeriod sort by start of relevantPeriod
     )
     
  ["Laboratory Test, Performed": "Hemoglobin Value Set"]
    
  from
    "Encounter with Selected Surgical Procedures" QualifyingEncounter,
    "Hemoglobin Drawn" HemoglobinDrawn,
    "Selected Surgical Procedure" SurgicalProcedure
  where HemoglobinDrawn.relevantPeriod starts 45 days or less before start of SurgicalProcedures.relevantPeriod
    and SurgicalProcedure.relevantPeriod starts during Interval[start of InpatientEncounter.relevantPeriod - 48 hours, end of InpatientEncounter.relevantPeriod]

  from
    "Encounter with Selected Surgical Procedures" QualifyingEncounter,
    "Blood Transfusion" BloodTransfusion,
    "Selected Surgical Procedure" SurgicalProcedures
  where SurgicalProcedures.relevantPeriod starts during Interval[start of InpatientEncounter.relevantPeriod - 48 hours, end of InpatientEncounter.relevantPeriod]
    and BloodTransfusion.relevantPeriod starts 5 days or less after end of SurgicalProcedures.relevantPeriod
		and BloodTransfusion.relevantPeriod ends on or before end of QualifyingEncounter.relevantPeriod
  return QualifyingEncounter

  ["Procedure, Performed": "Blood Transfusion Administration"] BloodTransfusion

  "Encounter with Age Range" InpatientEncounter
    with ["Procedure, Performed": "Selected Surgical Procedures"] SurgicalProcedures
      such that SurgicalProcedures.relevantPeriod starts during Interval[start of InpatientEncounter.relevantPeriod - 48 hours,
          end of InpatientEncounter.relevantPeriod]

  ["Procedure, Performed": "Selected Surgical Procedures"] SurgicalProcedures
    where SurgicalProcedures.relevantPeriod starts during Interval[start of SurgicalProcedures.relevantPeriod - 48 hours,
        end of SurgicalProcedures.relevantPeriod]

/*
The expression "Encounter with Blood Transfusion" is using a multi-source query,
which by default will return a tuple with an element for each input of the query:
*/

Tuple { 
  QualifyingEncounter "Encounter, Performed", 
  BloodTransfusion "Procedure, Performed", 
  SurgicalProcedures "Procedure, Performed" 
}

/*
But, based on the name of the expression, "Encounter with Blood Transfusion", it seems
like the result is intended to be just the Encounter. In that case, add a return clause
to indicate that only the Encounter should be returned:
*/
