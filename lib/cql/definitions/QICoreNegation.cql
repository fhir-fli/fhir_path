
using QICore version '4.1.1'

include FHIRHelpers version '4.0.013'

codesystem "SNOMED-CT": 'http://snomed.info/sct'

valueset "Venous Foot Pumps (VFP)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.230'
valueset "Application of intermittent pneumatic compression devices (IPC)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.65'
valueset "NegationReasonCodes": 'http://hl7.org/fhir/us/qicore/ValueSet/qicore-negation-reason'

code "Venous foot pump, device (physical object)": '442023007' from "SNOMED-CT" display 'Venous foot pump, device (physical object)'

parameter "Measurement Period" Interval<DateTime> default Interval[@2022-01-01, @2022-12-31]


// NOTE: Specific negation (i.e. negation using a direct-reference code as the search terminology)
// is not currently supported due to the need for a terminology contains operator in CQL
// See: https://jira.hl7.org/browse/FHIR-31675
//define TestSpecificDeviceNotRequested:
//  ["DeviceNotRequested": "Venous foot pump, device (physical object)"]

  ["DeviceNotRequested": "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested": code in "Venous Foot Pumps (VFP)"]
      union ["DeviceNotRequested": code ~ "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested"] D
      where D.code in "Venous Foot Pumps (VFP)"
        or D.code ~ "Venous Foot Pumps (VFP)"

    ["DeviceNotRequested": code in "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested"] D
      where D.code in "Venous Foot Pumps (VFP)"

    ["DeviceNotRequested": code ~ "Venous Foot Pumps (VFP)"]

    ["DeviceNotRequested"] D
      where D.code ~ "Venous Foot Pumps (VFP)"

/*
Example use of DeviceNotRequested in a measure criteria:
*/
  ["DeviceNotRequested": "Venous Foot Pumps (VFP)"] D
    where D.doNotPerformReason in NegationReasonCodes
      and D.authoredOn during "Measurement Period"

/*
NOTE: The use of the profile "DeviceNotRequested" also implies any "fixed-value" constraints:
*/