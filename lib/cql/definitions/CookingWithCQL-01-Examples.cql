
using QDM // version '4.2'

/*
 * Utilization of the PHQ-9 to Monitor Depression Symptoms for Adolescents and Adults
 */

parameter "Measurement Period" Interval<DateTime>


/*
Initial Population:
  •	AND: Age >=12 years at “Measurement Period”
  •	AND: “Depression Encounter” during “Measurement Period”
  •	AND: Union of:
    o	Diagnosis: “Major Depression”
    o	Diagnosis: “Dysthymia”
    o	Overlaps “Measurement Period
*/

  AgeInYearsAt(start of "Measurement Period") >= 12
    and exists "Depression Encounter"
    and exists "Depression Diagnosis"

  ["Encounter, Performed": "Outpatient"] Encounter
    where Interval[Encounter.admissionDateTime, Encounter.dischargeDateTime]
      during "Measurement Period"
      and Encounter.negationRationale is null

  (["Diagnosis": "Major Depression"]
    union ["Diagnosis": "Dysthymia"]
  ) Diagnosis
    where Interval[Diagnosis.onsetDateTime, Diagnosis.abatementDateTime]
      overlaps "Measurement Period"

  Interval[start of "Measurement Period", start of "Measurement Period" + 4 months)

  Interval[start of "Measurement Period" + 4 months, start of "Measurement Period" + 8 months)

  Interval[start of "Measurement Period" + 8 months, end of "Measurement Period"]

/*
· Numerator 1
	o AND: Union Of:
		§ "Risk Category Assessment: PHQ-9 Tool (result)"
		§ “Risk Category Assessment: PHQ-9 Modified Score (result)”
		§  < 4 month(s) starts after start of "Measurement Period"
*/

  (["Risk Category Assessment": "PHQ-9 Tool"]
    union ["Risk Category Assessment": "PHQ-9 Modified Score"]
  ) RiskAssessment
    where RiskAssessment.negationRationale is null
      and RiskAssessment.result is not null
      and Interval[RiskAssessment.startDateTime, RiskAssessment.stopDateTime]
        during "Assessment Period 1"

/*
· Numerator 2
	o AND: Union Of:
		§ "Risk Category Assessment: PHQ-9 Tool" satisfies all:
			§ (result)
			§ >= 4 month(s) starts after start of "Measurement Period"
			§ < 8 month(s) ends after start of "Measurement Period"
		§ Risk Category Assessment: PHQ-9 Modified Score" satisfies all:
			§ (result)
			§ >= 4 month(s) starts after start of "Measurement Period"
			§ < 8 month(s) ends after start of "Measurement Period"
*/

  (["Risk Category Assessment": "PHQ-9 Tool"]
    union ["Risk Category Assessment": "PHQ-9 Modified Score"]
  ) RiskAssessment
    where RiskAssessment.negationRationale is null
      and RiskAssessment.result is not null
      and Interval[RiskAssessment.startDateTime, RiskAssesssment.stopDateTime]
        during "Assessment Period 2"

/*
· Numerator 3
	o AND: Union Of:
					§ "Risk Category Assessment: PHQ-9 Tool (result)"
					§ “Risk Category Assessment: PHQ- Modified Score (result)”
					§  < 4 month(s) ends before end of "Measurement Period"
*/

  (["Risk Category Assessment": "PHQ-9 Tool"]
    union ["Risk Category Assessment": "PHQ-9 Modified Score"]
  ) RiskAssessment
    where RiskAssessment.negationRationale is null
      and RiskAssessment.result is not null
      and Interval[RiskAssessment.startDateTime, RiskAssesssment.stopDateTime]
        during "Assessment Period 3"

/*
· Stratification=
		o Stratification 1 =
				§ AND: Age>= 12 year(s) at: "Measurement Period"
				§ AND: Age< 18 year(s) at: "Measurement Period"
		o Stratification 2 =
				§ AND: Age>= 18 year(s) at: "Measurement Period"
				§ AND: Age< 45 year(s) at: "Measurement Period"
		o Stratification 3 =
				§ AND: Age>= 45 year(s) at: "Measurement Period"
				§ AND: Age< 65 year(s) at: "Measurement Period"
		o Stratification 4 =
				§ Age>= 65 year(s) at: "Measurement Period"
*/

  AgeInYearsAt(start of "Measurement Period") in [12, 18)

  AgeInYearsAt(start of "Measurement Period") in [18, 45)

  AgeInYearsAt(start of "Measurement Period") in [45, 65)
