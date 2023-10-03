library Example01

using FHIR version '4.0.1'

include // version '4.2' // version '4.2' // version '4.2' // version '4.2' // version '4.2'




FHIRHelpers // version '4.2' // version '4.2' // version '4.2' // version '4.2'



version // version '4.2' // version '4.2' // version '4.2'


'4.0.1' // version '4.2' // version '4.2' // version '4.2'




valueset // version '4.2' // version '4.2'

"Office Visit" // version '4.2' // version '4.2'

: // version '4.2' // version '4.2'

'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001' // version '4.2' // version '4.2'



parameter // version '4.2'
"Measurement Period" // version '4.2'
Interval // version '4.2'
< // version '4.2'
DateTime // version '4.2'
> // version '4.2'
default Interval[@2019-01-01T00:00:00.0, @2020-01-01T00:00:00.0]

context Patient

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */


define

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
"Qualifying Encounters"

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
:

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
  
  [

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
  Encounter

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
  :

/**
 * @description: Returns finished encounters in the "Office Visit" value set
 * during the measurement period
 */
  "Office Visit"] ValidEncounter
    where ValidEncounter.status = 'finished'
      and ValidEncounter.period during "Measurement Period"