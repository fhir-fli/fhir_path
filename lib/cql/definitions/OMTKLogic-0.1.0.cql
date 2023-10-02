
using OMTK version '0.1.0'

codesystem RxNorm: 'http://www.nlm.nih.gov/research/umls/rxnorm'

//define MED_DOSE_FORMS: [MED_DOSE_FORM]

// Given an RxNorm Code:
// NON_SURGICAL_OPIOID_TO_INCLUDE.DRUG_RXCUI
// MED_DRUG.DRUG_RXCUI
// MED_SCDC_FOR_DRUG.DRUG_RXCUI -> SCDC_RXCUI
// MED_SCDC.SCDC_RXCUI (STRENGTH, STRENGTH_VALUE, STRENGTH_UNIT)
// MED_INGREDIENT_FOR_SCDC.SCDC_RXCUI -> INGREDIENT_RXCUI
// MED_INGREDIENT.INGREDIENT_RXCUI
// MED_INGREDIENT_TYPE.INGREDIENT_RXCUI (INGREDIENT_TYPE = 'NonSurgicalOpioid')

/*
 SQL ->
select D.DRUG_RXCUI, D.DRUG_NAME, DF.DOSE_FORM_NAME, SCDCD.SCDC_RXCUI, SCDC.SCDC_NAME, SCDC.STRENGTH, SCDC.STRENGTH_VALUE, SCDC.STRENGTH_UNIT, I.INGREDIENT_RXCUI, I.INGREDIENT_NAME
  from MED_DRUG D
    join NON_SURGICAL_OPIOID_TO_INCLUDE NSO on D.DRUG_RXCUI = NSO.DRUG_RXCUI
    join MED_SCDC_FOR_DRUG SCDCD on D.DRUG_RXCUI = SCDCD.DRUG_RXCUI
    join MED_SCDC SCDC on SCDCD.SCDC_RXCUI = SCDC.SCDC_RXCUI
    join MED_INGREDIENT_FOR_SCDC SCDCI on SCDC.SCDC_RXCUI = SCDCI.SCDC_RXCUI
    join MED_INGREDIENT I on SCDCI.INGREDIENT_RXCUI = I.INGREDIENT_RXCUI
    join MED_INGREDIENT_TYPE IT on I.INGREDIENT_RXCUI = IT.INGREDIENT_RXCUI
	left join MED_DRUG_DOSE_FORM DDF on D.DRUG_RXCUI = DDF.DRUG_RXCUI
	left join MED_DOSE_FORM DF on DDF.DOSE_FORM_RXCUI = DF.DOSE_FORM_RXCUI
	--Most of the drugs have multiple dose form groups...
	--left join MED_DRUG_DOSE_FORM_GROUP DDFG on D.DRUG_RXCUI = DDFG.DRUG_RXCUI
	--left join MED_DOSE_FORM_GROUP DFG on DDFG.DOSE_FORM_GROUP_RXCUI = DFG.DOSE_FORM_GROUP_RXCUI
  where D.DRUG_RXCUI = @RxNormCode // 197696
    and IT.INGREDIENT_TYPE = 'NonSurgicalOpioid'
*/

/*
  CQL, assuming translation to SQL:

  from
    [MED_DRUG: rxNormCode] D,
    [NON_SURGICAL_OPIOID_TO_INCLUDE] NSO,
    [MED_SCDC_FOR_DRUG] SCDCD,
    [MED_SCDC] SCDC,
    [MED_INGREDIENT_FOR_SCDC] SCDCI,
    [MED_INGREDIENT] I,
    [MED_INGREDIENT_TYPE] IT,
    [MED_DRUG_DOSE_FORM] DDF,
    [MED_DOSE_FORM] DF
  where D.DRUG_RXCUI = NSO.DRUG_RXCUI
    and D.DRUG_RXCUI = SCDCD.DRUG_RXCUI
    and SCDCD.SCDC_RXCUI = SCDC.SCDC_RXCUI
    and SCDC.SCDC_RXCUI = SCDCI.SCDC_RXCUI
    and SDCDI.INGREDIENT_RXCUI = I.INGREDIENT_RXCUI
    and I.INGREDIENT_RXCUI = IT.INGREDIENT_RXCUI
    and D.DRUG_RXCUI = DDF.DRUG_RXCUI
    and DDF.DOSE_FORM_RXCUI = DF.DOSE_FORM_RXCUI
    and IT.INGREDIENT_TYPE = 'NonSurgicalOpioid'
*/

/*
An engine with a naive implementation for multi-source queries would perform
pretty horribly here, so rewrite it using "syntactic optimization" :)
*/

/*
  Normalizes the input units to UCUM units
  
  Note guidance for UCUM presentation of medication units from SNOMED here:
  https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjU3vLpicPTAhWFMGMKHRpOBUAQFggiMAA&url=https%3A%2F%2Fconfluence.ihtsdotools.org%2Fdownload%2Fattachments%2F17859188%2FExpressing%2520Units%2520of%2520Measure%2520for%2520Medicinal%2520Products.doc%3Fapi%3Dv2&usg=AFQjCNE5sboicqvJDUyXJ2im8VzBpgHE8A
  
  The values listed here are the only ones currently present in the OMTK data
  
  Based on the HL7 UCUM subset here:
  http://download.hl7.de/documents/ucum/ucumdata.html
*/