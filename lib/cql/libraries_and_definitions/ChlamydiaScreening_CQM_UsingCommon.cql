library ChlamydiaScreening_CQM_UsingCommon version '2'

using QUICK

include ChlamydiaScreening_Common version '2' called Common

parameter MeasurementPeriod default Interval[DateTime(2013, 1, 1, 0, 0, 0, 0), DateTime(2014, 1, 1, 0, 0, 0, 0)]