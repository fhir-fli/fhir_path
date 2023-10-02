
using QICore version '4.1.1'

include FHIRHelpers version '4.0.013'

codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "Venous Foot Pumps (VFP)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.230'
valueset "Application of intermittent pneumatic compression devices (IPC)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.65'
valueset "NegationReasonCodes": 'http://hl7.org/fhir/us/qicore/ValueSet/qicore-negation-reason'

code "Venous foot pump, device (physical object)": '442023007' from "SNOMED-CT" display 'Venous foot pump, device (physical object)'

parameter "Measurement Period" Interval<DateTime> default Interval[@2022-01-01, @2022-12-31]
