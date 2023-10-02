
/*
This library reviews patterns included in the soon-to-be-published
QI Core version 4.0.0. The following link is to the continuous build:

http://build.fhir.org/ig/HL7/fhir-qi-core/index.html

Note that once published, this content will be available at the home link:

http://hl7.org/fhir/us/qicore
*/

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'
include MATGlobalCommonFunctions_FHIR4 version '4.0.000' called Global

valueset "Device Application": 'http://example.org/fhir/ValueSet/device-application'
valueset "Venous foot pumps (VFP)": 'http://example.org/fhir/ValueSet/venous-foot-pumps'
valueset "Statin Allergen": 'http://example.org/fhir/ValueSet/statin-allergen'
valueset "Congenital absence of cervix (disorder)": 'http://example.org/fhir/ValueSet/congenital-absence-of-cervix'
valueset "Frailty Device": 'http://example.org/fhir/ValueSet/frailty-device'
valueset "Encounter Inpatient": 'http://example.org/fhir/ValueSet/encounter-inpatient'
valueset "Inactivated Polio Vaccine (IPV)": 'http://example.org/fhir/ValueSet/inactivated-polio-vaccine'
valueset "Low Dose Unfractionated Heparin for VTE Prophylaxis": 'http://example.org/fhir/ValueSet/low-dose-unfractionated-heparin-for-vte-prophylaxis'
valueset "Dementia Medications": 'http://example.org/fhir/ValueSet/dementia-medications'
valueset "Antithrombotic Therapy": 'http://example.org/fhir/ValueSet/antithrombotic-therapy'
valueset "Pap Test": 'http://example.org/fhir/ValueSet/pap-test'
valueset "Flexible Sigmoidoscopy": 'http://example.org/fhir/ValueSet/flexible-sigmoidoscopy'
valueset "Intermittent pneumatic compression devices (IPC)": 'http://example.org/fhir/ValueSet/intermittent-pneumatic-compression-devices'
valueset "Graduated compression stockings (GCS)": 'http://example.org/fhir/ValueSet/graduated-compression-stockings'
valueset "Comfort Measures": 'http://example.org/fhir/ValueSet/comfort-measures'
valueset "Medical Reason": 'http://example.org/fhir/ValueSet/medical-reason'
valueset "Patient Refusal": 'http://example.org/fhir/ValueSet/patient-refusal'

parameter "Measurement Period" Interval<DateTime>
