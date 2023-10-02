
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using QDM

valueset "Acute Respiratory Failure": '2.16.840.1.113883.3.464.1003.102.12.1018'
valueset "Chronic Obstructive Pulmonary Disease": '2.16.840.1.113883.3.464.1003.102.12.1007'
valueset "Cystic Fibrosis": '2.16.840.1.113883.3.464.1003.102.12.1002'
valueset "Emphysema": '2.16.840.1.113883.3.464.1003.102.12.1004'
valueset "Persistent Asthma": '2.16.840.1.113883.3.464.1003.102.12.1023'
valueset "Face-to-Face Interaction": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Home Healthcare Services": '2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Preventive Care - Established Office Visit, 0 to 17": '2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Preventive Care Services - Established Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": '2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care- Initial Office Visit, 0 to 17": '2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preferred Asthma Therapy": '2.16.840.1.113883.3.464.1003.196.12.1212'

parameter MeasurementPeriod Interval<DateTime>



	AgeInYearsAt(start of MeasurementPeriod) >= 5
    and AgeInYearsAt(start of MeasurementPeriod) < 64

  PersistentAsthmaDiagnoses A where Interval[A."start datetime", A."stop datetime"] overlaps MeasurementPeriod

  OfficeVisitEncounter
		union HomeHealthcareEncounter
		union FaceToFaceEncounter
		union EstablishedPreventiveCareForMinorEncounter
		union EstablishedPreventiveCareForAdultEncounter
		union InitialPreventiveCareForAdultEncounter
    union InitialPreventiveCareForMinorEncounter

	ValidEncounters E where Interval[E."start datetime", E."stop datetime"] during MeasurementPeriod

  InDemographic
    and exists (ActivePersistentAsthmaDiagnosis)
    and exists (EncountersDuringMeasurementPeriod)

  InitialPopulation

  ChronicObstructivePulmonaryDiseaseDiagnoses
    union EmphysemaDiagnoses
    union CysticFibrosisDiagnoses
    union AcuteRespiratoryFailureDiagnoses

  ActiveDiagnoses D where Interval[D."start datetime", D."stop datetime"] overlaps MeasurementPeriod

  exists (ActiveDiagnosesDuringMeasurementPeriod)

  PreferredAsthmaTherapy P where Interval[P."start datetime", P."stop datetime"] during MeasurementPeriod

  AgeInYearsAt(start of MeasurementPeriod) >= 5
    and AgeInYearsAt(start of MeasurementPeriod) < 11

  AgeInYearsAt(start of MeasurementPeriod) >= 11
    and AgeInYearsAt(start of MeasurementPeriod) < 18

  AgeInYearsAt(start of MeasurementPeriod) >= 18
    and AgeInYearsAt(start of MeasurementPeriod) < 50
