
using QDM version '5.3'

include Test01_ScreeningForAlcoholMisuse version '1.1.000' called ScreeningForAlcoholMisuse
include Test02_HypertensionAssessment version '1.0.000' called HypertensionAssessment
include Test03_ScreeningForBreastCancer version '1.0.000' called ScreeningForBreastCancer
include Test04_ScreeningForColorectalCancer version '1.0.000' called ScreeningForColorectalCancer
include Test05_ScreeningForDepression version '1.0.000' called ScreeningForDepression


/*True if any initial population is true*/

	ScreeningForAlcoholMisuse."Initial Population"
		or HypertensionAssessment."Initial Population"
		or ScreeningForBreastCancer."Initial Population"
		or ScreeningForColorectalCancer."Initial Population"
		or ScreeningForDepression."Initial Population"

/*True if and only if all numerators are true*/

	ScreeningForAlcoholMisuse."Numerator"
		and HypertensionAssessment."Numerator"
		and ScreeningForBreastCancer."Numerator"
		and ScreeningForColorectalCancer."Numerator"
		and ScreeningForDepression."Numerator"

/*True if any denominator is true and any related denominator exclusions is false*/
