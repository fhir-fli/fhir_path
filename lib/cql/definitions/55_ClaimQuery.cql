
using FHIR version '3.0.0'

include FHIRHelpers version '3.0.0'

valueset "Dx Cholesterol Embolism": 'urn:oid:1.2.3.4.5'

parameter "Measurement Period" Interval<DateTime>
