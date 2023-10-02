
/*This is an interim version for use prior to AU 2020 release.  We anticipate another release for inclusion with the program measures in Spring 2020*/

/*
Update to 5.6 to get "class" as an attribute of an encounter, performed
*/
using QDM version '5.6'

valueset "Emergency Department Visit": 'urn:oid:2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'urn:oid:2.16.840.1.113883.3.666.5.307'
valueset "Intensive Care Unit": 'urn:oid:2.16.840.1.113762.1.4.1029.206'
valueset "Observation Services": 'urn:oid:2.16.840.1.113762.1.4.1111.143'
valueset "Outpatient Surgery Service": 'urn:oid:2.16.840.1.113762.1.4.1110.38'

/*
Encounter Class Discussion:
http://hl7.org/fhir/R4/v3/ActEncounterCode/vs.html

Code	Display	Definition
AMB	ambulatory	A comprehensive term for health care provided in a healthcare facility (e.g. a practitioneraTMs office, clinic setting, or hospital) on a nonresident basis. The term ambulatory usually implies that the patient has come to the location and is not assigned to a bed. Sometimes referred to as an outpatient encounter.
EMER	emergency	A patient encounter that takes place at a dedicated healthcare service delivery location where the patient receives immediate evaluation and treatment, provided until the patient can be discharged or responsibility for the patient's care is transferred elsewhere (for example, the patient could be admitted as an inpatient or transferred to another facility.)
FLD	field	A patient encounter that takes place both outside a dedicated service delivery location and outside a patient's residence. Example locations might include an accident site and at a supermarket.
HH	home health	Healthcare encounter that takes place in the residence of the patient or a designee
IMP	inpatient encounter	A patient encounter where a patient is admitted by a hospital or equivalent facility, assigned to a location where patients generally stay at least overnight and provided with room, board, and continuous nursing service.
ACUTE	inpatient acute	An acute inpatient encounter.
NONAC	inpatient non-acute	Any category of inpatient encounter except 'acute'
OBSENC	observation encounter	An encounter where the patient usually will start in different encounter, such as one in the emergency department (EMER) but then transition to this type of encounter because they require a significant period of treatment and monitoring to determine whether or not their condition warrants an inpatient admission or discharge. In the majority of cases the decision about admission or discharge will occur within a time period determined by local, regional or national regulation, often between 24 and 48 hours.
PRENC	pre-admission	A patient encounter where patient is scheduled or planned to receive service delivery in the future, and the patient is given a pre-admission account number. When the patient comes back for subsequent service, the pre-admission encounter is selected and is encapsulated into the service registration, and a new account number is generated. Usage Note: This is intended to be used in advance of encounter types such as ambulatory, inpatient encounter, virtual, etc.
SS	short stay	An encounter where the patient is admitted to a health care facility for a predetermined length of time, usually less than 24 hours.
VR	virtual	A patient encounter where the patient and the practitioner(s) are not in the same physical location. Examples include telephone conference, email exchange, robotic surgery, and televideo conference.
*/

/*
Propose the definition of value sets to support these "class" concepts:
*/
valueset "Ambulatory Encounter Class": 'http://example.org/fhir/ValueSet/ambulatory-encounter-class'
valueset "Emergency Encounter Class": 'http://example.org/fhir/ValueSet/emergency-encounter-class'
valueset "Field Encounter Class": 'http://example.org/fhir/ValueSet/field-encounter-class'
valueset "Home Health Encounter Class": 'http://example.org/fhir/ValueSet/home-health-encounter-class'
valueset "Inpatient Encounter Class": 'http://example.org/fhir/ValueSet/inpatient-encounter-class'
valueset "Acute Encounter Class": 'http://example.org/fhir/ValueSet/acute-encounter-class'
valueset "Nonacute Encounter Class": 'http://example.org/fhir/ValueSet/nonacute-encounter-class'
valueset "Observation Encounter Class": 'http://example.org/fhir/ValueSet/observation-encounter-class'
valueset "Preadmission Encounter Class": 'http://example.org/fhir/ValueSet/preadmission-encounter-class'
valueset "Short Stay Encounter Class": 'http://example.org/fhir/ValueSet/short-stay-encounter-class'
valueset "Virtual Encounter Class": 'http://example.org/fhir/ValueSet/virtual-encounter-class'
// DISCUSSION: Use ambulatory
//valueset "Outpatient Encounter Class": 'http://example.org/fhir/ValueSet/outpatient-encounter-class'

parameter "Measurement Period" Interval<DateTime>
