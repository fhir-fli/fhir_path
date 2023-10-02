
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon version '4.0.1' called FC

include ColorectalCancerConcepts called Cs

// QUESTION: Should this be a single timepoint, or is a period required?
//parameter AsOf DateTime default Now()

/*
NOTE: Introduced Measurement Period as the parameter here for demonstration purposes
so it will run on the current implementations.
*/
parameter "Measurement Period" Interval<DateTime>
  default Interval[Now() - 1 year, Now()]


  end of "Measurement Period"

  [Procedure: Cs."Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
		where FlexibleSigmoidoscopy.status = 'completed'

// NOTE: HEDIS version allows for a "history of" SNOMED code as FHIR.Condition. Code is present in eCQM valueset.
  [Condition: Cs."Flexible Sigmoidoscopy"] FlexibleSigmoidoscopyCondition
    where FlexibleSigmoidoscopyCondition.clinicalStatus in FC."Active Condition"
      and FlexibleSigmoidoscopyCondition.verificationStatus ~ FC."confirmed"

  [Procedure: Cs."CT Colonography"] Colonography
    where Colonography.status = 'completed'

  [Procedure: Cs."Total Colectomy"] Colectomy
    where Colectomy.status = 'completed'

// NOTE: HEDIS version allows for a "history of" SNOMED code as FHIR.Condition. Code is present in eCQM valueset.
  [Condition: Cs."Total Colectomy"] ColectomyCondition
    where ColectomyCondition.clinicalStatus in FC."Active Condition"
      and ColectomyCondition.verificationStatus ~ FC."confirmed"

  [Observation: Cs."Fecal Occult Blood Test (FOBT)"] FecalOccultResult
		where FecalOccultResult.status in {'final', 'amended', 'corrected', 'preliminary'}
			and FecalOccultResult.value is not null

  [Observation: Cs."FIT DNA"] FitDNA
		where FitDNA.status in {'final', 'amended', 'corrected', 'preliminary'}
			and FitDNA.value is not null

  [Procedure: Cs."Colonoscopy"] Colonoscopy
		where Colonoscopy.status = 'completed'

// NOTE: HEDIS version allows for a "history of" SNOMED code as FHIR.Condition. Code is present in eCQM valueset.
  [Condition: Cs."Colonoscopy"] C
    where C.clinicalStatus in FC."Active Condition"
    and C.verificationStatus ~ FC."confirmed"

  [Condition: Cs."Malignant Neoplasm of Colon"] ColorectalCancer
    where ColorectalCancer.clinicalStatus in FC."Active Condition"
      and ColorectalCancer.verificationStatus ~ FC."confirmed"

  "Fecal Occult Blood Test Result" R
    where R.issued 1 year or less on or before AsOf

  MostRecent("Fecal Occult Blood Test Result", AsOf)

  "Fecal Immunochemical Test DNA Result" R
    where R.issued 3 years or less on or before AsOf

  MostRecent("Fecal Immunochemical Test DNA Result", AsOf)

  "Flexible Sigmoidoscopy Performed" P
    where FC.ToInterval(P.performed) ends 5 years or less on or before AsOf

  MostRecent("Flexible Sigmoidoscopy Performed", AsOf)

  "CT Colonography Performed" P
    where FC.ToInterval(P.performed) ends 5 years or less on or before AsOf

  MostRecent("CT Colonography Performed", AsOf)

  "Colonoscopy Performed" P
    where FC.ToInterval(P.performed) ends 10 years or less on or before AsOf

  MostRecent("Colonoscopy Performed", AsOf)

  exists (
    "Active Malignant Neoplasm" M
      where FC.ToPrevalenceInterval(M) starts on or before AsOf
  )

// NOTE: Added these two for HEDIS version.
  exists (
    PerformedWithin("Total Colectomy Performed", 1 year)
  )

 exists (
    "Total Colectomy from Patient History" ColectomyHistory
      where FC.ToPrevalenceInterval(ColectomyHistory) starts on or before AsOf
  )

/*
  FOBT within 1 year
    or FIT DNA within 3 years
    or CT Colonography within 5 years
    or Flexible Sigmoidoscopy within 5 years
    or Colonoscopy within 10 years
*/
  exists "Fecal Occult Blood Test Result Within 1 Year"
    or exists "Fecal Immunochemical Test DNA Result Within 3 Years"
    or exists "CT Colonography Performed Within 5 Years"
    or exists "Flexible Sigmoidoscopy Performed Within 5 Years"
    or exists "Colonoscopy Performed Within 10 Years"

// NOTE: For Condition options
  exists (
    "Flexible Sigmoidoscopy from Patient History" FlexSigCondition
      where FC.ToPrevalenceInterval(FlexSigCondition) starts on or after day of AsOf - 5 years)
  or exists (
    "Colonoscopy from Patient History" ColonscopyCondition
      where FC.ToPrevalenceInterval(ColonscopyCondition) starts on or after day of AsOf - 10 years)

  First(
    procedures P
      sort by start of FC.ToInterval(performed)
  )

  First(
    observations O
      sort by issued
  )

  observations O
    where O.issued on or after day of AsOf - lookback
