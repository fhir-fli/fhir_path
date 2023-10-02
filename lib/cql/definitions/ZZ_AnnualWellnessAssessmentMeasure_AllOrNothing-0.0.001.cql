
using QDM version '5.3'

include Test01_ScreeningForAlcoholMisuse version '1.1.000' called ScreeningForAlcoholMisuse
include Test02_HypertensionAssessment version '1.0.000' called HypertensionAssessment
include Test03_ScreeningForBreastCancer version '1.0.000' called ScreeningForBreastCancer
include Test04_ScreeningForColorectalCancer version '1.0.000' called ScreeningForColorectalCancer
include Test05_ScreeningForDepression version '1.0.000' called ScreeningForDepression

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1'
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836'
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837'
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591'


	["Patient Characteristic Ethnicity": "Ethnicity"]

	["Patient Characteristic Payer": "Payer"]

	["Patient Characteristic Race": "Race"]

	["Patient Characteristic Sex": "ONC Administrative Sex"]
	
  ScreeningForAlcoholMisuse."Initial Population"
	  or HypertensionAssessment."Initial Population"
		or ScreeningForBreastCancer."Initial Population"
		or ScreeningForColorectalCancer."Initial Population"
		or ScreeningForDepression."Initial Population"
		
  ScreeningForAlcoholMisuse."Denominator"
	  or HypertensionAssessment."Denominator"
		or ScreeningForBreastCancer."Denominator"
		or ScreeningForColorectalCancer."Denominator"
		or ScreeningForDepression."Denominator"
		
  ScreeningForAlcoholMisuse."Denominator Exclusions"
	  //or HypertensionAssessment."Denominator" NOTE: This measure does not have denominator exclusions
		or ScreeningForBreastCancer."Denominator Exclusions"
		or ScreeningForColorectalCancer."Denominator Exclusions"
		or ScreeningForDepression."Denominator Exclusions"
		