
// Warfarin time in therapeutic range

using QDM version '5.0.2'

valueset "Atrial Fibrillation/Flutter": '2.16.840.1.113883.3.117.1.7.1.202'
valueset "Warfarin": '2.16.840.1.113883.3.117.1.7.1.232'
valueset "Face-to-Face Interaction": '2.16.840.1.113883.3.464.1003.101.12.1048'
valueset "Office Visit": '2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Valvular Heart Disease": '2.16.840.1.113883.3.464.1003.104.12.1017'
valueset "INR": '2.16.840.1.113883.3.117.1.7.1.213'
valueset "birth date": '2.16.840.1.113883.3.560.100.4'
valueset "Computed Value INR percent TTR": '2.16.840.1.113883.3.464.1003.104.12.1018'

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0)]

context Patient