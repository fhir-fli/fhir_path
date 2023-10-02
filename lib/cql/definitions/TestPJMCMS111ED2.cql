
/*Testing only
null value issue CQLIT-207*/

using QDM version '5.5'

include MATGlobalCommonFunctions version '4.1.000' called Global

valueset "Admit Inpatient": 'urn:oid:2.16.840.1.113762.1.4.1111.164'
valueset "Decision to Admit to Hospital Inpatient": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.295'
valueset "ED Evaluation": 'urn:oid:2.16.840.1.113762.1.4.1111.163'
valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Hospital Settings": 'urn:oid:2.16.840.1.113762.1.4.1111.126'
valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'
valueset "Psychiatric/Mental Health Diagnosis": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.299'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'

parameter "Measurement Period" Interval<DateTime>


  ["Patient Characteristic Ethnicity": "Ethnicity"]

  ["Patient Characteristic Payer": "Payer"]

  ["Patient Characteristic Race": "Race"]

  ["Patient Characteristic Sex": "ONC Administrative Sex"]

  /*An ED visit with an order to admit inpatient that is prior to the patient departing the emergency department*/
  Global."ED Encounter" EDVisit
    with ["Encounter, Order": "Decision to Admit to Hospital Inpatient"] AdmitOrder
      such that AdmitOrder.authorDatetime during EDVisit.relevantPeriod
        and AdmitOrder.authorDatetime before "EDDepartureTime"(EDVisit)

  "Initial Population"

  /* Emergency department encounters with an admission source in "Hospital Setting" resulting in an inpatient stay*/
  Global."Inpatient Encounter" EncounterInpatient
    where RelatedEDVisit(EncounterInpatient).admissionSource in "Hospital Settings"

  /*Encounters of patients without a "Psychiatric/Mental Health Diagnosis" of rank 1*/
  Global."Inpatient Encounter" EncounterInpatient
    where not exists ( EncounterInpatient.diagnoses Diagnosis
        where Diagnosis.code in "Psychiatric/Mental Health Diagnosis"
          and Diagnosis.rank = 1
    )
      or not exists ( EncounterInpatient.diagnoses Diagnosis
          where Diagnosis.rank = 1
      )

  /*Encounters of patients with a "Psychiatric/Mental Health Diagnosis"  of rank 1*/
  Global."Inpatient Encounter" EncounterInpatient
    where exists ( EncounterInpatient.diagnoses Diagnosis
        where Diagnosis.code in "Psychiatric/Mental Health Diagnosis"
          and Diagnosis.rank = 1
    )

  /*An emergency department (ED) visit with an evaluation result that indicates the patient is being admitted to inpatient staus and is performed prior to the patient departing the ED Visit*/
  Global."ED Encounter" EDVisit
    with ( ["Assessment, Performed": "ED Evaluation"] EDEvaluation
      where EDEvaluation.result as Code in "Admit Inpatient" ) AdmitDecision
      such that AdmitDecision.relevantDatetime during EDVisit.relevantPeriod
        and AdmitDecision.relevantDatetime before "EDDepartureTime"(EDVisit)

  // original
  //define "Initial Population":
  //  /*An emergency department (ED) visit with an evaluation result or order that indicates the patient is being admitted to inpatient staus followed by an inpatient encounter admission that is within an hour of that ED Visit*/
  //  ( Global."Inpatient Encounter" EncounterInpatient
  //      with "Emergency Department Evaluation Admit Decision" EDEvaluation
  //        such that EDEvaluation.relevantPeriod ends 1 hour or less before or on start of EncounterInpatient.relevantPeriod
  //  )
  //    union ( Global."Inpatient Encounter" EncounterInpatient
  //        with "ED Visit with Admit Order" EDAdmitOrder
  //          such that EDAdmitOrder.relevantPeriod ends 1 hour or less before or on start of EncounterInpatient.relevantPeriod
  //    )
  //

  /*An emergency department (ED) visit with an evaluation result or order that indicates the patient is being admitted to inpatient staus followed by an inpatient encounter admission that is within an hour of that ED Visit*/
  ( ( Global."Inpatient Encounter" EncounterInpatient
        with "Emergency Department Evaluation Admit Decision" EDEvaluation
          such that EDEvaluation.relevantPeriod ends 1 hour or less before or on start of EncounterInpatient.relevantPeriod
    )
      union ( Global."Inpatient Encounter" EncounterInpatient
          with "ED Visit with Admit Order" EDAdmitOrder
            such that EDAdmitOrder.relevantPeriod ends 1 hour or less before or on start of EncounterInpatient.relevantPeriod
      )
  )

  /*ED visit with a decision to admit that preceded an inpatient encounter*/
  Last(Global."ED Encounter" EDVisit
      with(["Assessment, Performed": "ED Evaluation"]
        union ["Encounter, Order": "Decision to Admit to Hospital Inpatient"])AdmitDecision
        such that AdmitDecision.authorDatetime during EDVisit.relevantPeriod
      where EDVisit.relevantPeriod ends 1 hour or less on or before start of Encounter.relevantPeriod
      sort by
      end of relevantPeriod
  )

  /*An emergency department (ED) visit with an order that indicates the patient is being admitted to inpatient staus and is performed during the Related ED visit*/
  Last(["Encounter, Order": "Decision to Admit to Hospital Inpatient"] AdmitOrder
      where AdmitOrder.authorDatetime during "RelatedEDVisit"(Encounter).relevantPeriod
      sort by authorDatetime
  )

  /*An emergency department (ED) visit with an evaluation result that indicates the patient is being admitted to inpatient staus and is performed during the Related ED visit*/
  Last(["Assessment, Performed": "ED Evaluation"] EDEvaluation
      where EDEvaluation.relevantDatetime during "RelatedEDVisit"(Encounter).relevantPeriod
        and EDEvaluation.result in "Admit Inpatient"
      sort by relevantDatetime
  )

  /*The duration from the decision to admit inpatient to the departure from the Emergency Department*/
  duration in minutes of Interval[Coalesce("AdmitDecisionUsingAssessment"(Encounter).authorDatetime, "AdmitDecisionUsingEncounterOrder"(Encounter).authorDatetime), "EDDepartureTime"("RelatedEDVisit"(Encounter))]
