
using QICore version '4.1.1'

include FHIRHelpers version '4.2.000'
include QICoreCommon version '1.3.000'

// These code systems are not known to the MAT environment yet, request to have them added submitted
codesystem "V3TimingEvent": 'http://terminology.hl7.org/CodeSystem/v3-TimingEvent'
codesystem "EventTiming": 'http://hl7.org/fhir/event-timing'

code "HS": 'HS' from "V3TimingEvent" // event occurs [offset] before the hour of sleep (or trying to)
code "WAKE": 'WAKE' from "V3TimingEvent" // event occurs [offset] after waking
code "C": 'C' from "V3TimingEvent" //	event occurs at a meal (from the Latin cibus)
code "CM": 'CM' from "V3TimingEvent" //	event occurs at breakfast (from the Latin cibus matutinus)
code "CD": 'CD' from "V3TimingEvent" //	event occurs at lunch (from the Latin cibus diurnus)
code "CV": 'CV' from "V3TimingEvent" //	event occurs at dinner (from the Latin ante cibus vespertinus)
code "AC": 'AC' from "V3TimingEvent" //	event occurs [offset] before a meal (from the Latin ante cibus)
code "ACM": 'ACM' from "V3TimingEvent" //	event occurs [offset] before breakfast (from the Latin ante cibus matutinus)
code "ACD": 'ACD' from "V3TimingEvent" //	event occurs [offset] before lunch (from the Latin ante cibus diurnus)
code "ACV": 'ACV' from "V3TimingEvent" //	event occurs [offset] before dinner (from the Latin ante cibus vespertinus)
code "PC": 'PC' from "V3TimingEvent" //	event occurs [offset] after a meal (from the Latin post cibus)
code "PCM": 'PCM' from "V3TimingEvent" //	event occurs [offset] after breakfast (from the Latin post cibus matutinus)
code "PCD": 'PCD' from "V3TimingEvent" //	event occurs [offset] after lunch (from the Latin post cibus diurnus)
code "PCV": 'PCV' from "V3TimingEvent" //	event occurs [offset] after dinner (from the Latin post cibus vespertinus)

code "MORN": 'MORN' from EventTiming //	Event occurs during the morning. The exact time is unspecified and established by institution convention or patient interpretation.
code "MORN.early": 'MORN.early' from EventTiming //	Early Morning	Event occurs during the early morning. The exact time is unspecified and established by institution convention or patient interpretation.
code "MORN.late": 'MORN.late' from EventTiming // Late Morning	Event occurs during the late morning. The exact time is unspecified and established by institution convention or patient interpretation.
code "NOON": 'NOON' from EventTiming //	Noon	Event occurs around 12:00pm. The exact time is unspecified and established by institution convention or patient interpretation.
code "AFT": 'AFT' from EventTiming //	Afternoon	Event occurs during the afternoon. The exact time is unspecified and established by institution convention or patient interpretation.
code "AFT.early": 'AFT.early' from EventTiming //	Early Afternoon	Event occurs during the early afternoon. The exact time is unspecified and established by institution convention or patient interpretation.
code "AFT.late": 'AFT.late' from EventTiming //	Late Afternoon	Event occurs during the late afternoon. The exact time is unspecified and established by institution convention or patient interpretation.
code "EVE": 'EVE' from EventTiming //	Evening	Event occurs during the evening. The exact time is unspecified and established by institution convention or patient interpretation.
code "EVE.early": 'EVE.early' from EventTiming //	Early Evening	Event occurs during the early evening. The exact time is unspecified and established by institution convention or patient interpretation.
code "EVE.late": 'EVE.late' from EventTiming //	Late Evening	Event occurs during the late evening. The exact time is unspecified and established by institution convention or patient interpretation.
code "NIGHT": 'NIGHT' from EventTiming //	Night	Event occurs during the night. The exact time is unspecified and established by institution convention or patient interpretation.
code "PHS": 'PHS' from EventTiming //	After Sleep	Event occurs [offset] after subject goes to sleep. The exact time is unspecified and established by institution convention or patient interpretation.

code "Every eight hours (qualifier value)": '307469008' from QICoreCommon."SNOMEDCT" display 'Every eight hours (qualifier value)'
code "Every eight to twelve hours (qualifier value)": '396140003' from QICoreCommon."SNOMEDCT" display 'Every eight to twelve hours (qualifier value)'
code "Every forty eight hours (qualifier value)": '396131002' from QICoreCommon."SNOMEDCT" display 'Every forty eight hours (qualifier value)'
code "Every forty hours (qualifier value)": '396130001' from QICoreCommon."SNOMEDCT" display 'Every forty hours (qualifier value)'
code "Every four hours (qualifier value)": '225756002' from QICoreCommon."SNOMEDCT" display 'Every four hours (qualifier value)'
code "Every seventy two hours (qualifier value)": '396143001' from QICoreCommon."SNOMEDCT" display 'Every seventy two hours (qualifier value)'
code "Every six hours (qualifier value)": '307468000' from QICoreCommon."SNOMEDCT" display 'Every six hours (qualifier value)'
code "Every six to eight hours (qualifier value)": '396139000' from QICoreCommon."SNOMEDCT" display 'Every six to eight hours (qualifier value)'
code "Every thirty six hours (qualifier value)": '396126004' from QICoreCommon."SNOMEDCT" display 'Every thirty six hours (qualifier value)'
code "Every three to four hours (qualifier value)": '225754004' from QICoreCommon."SNOMEDCT" display 'Every three to four hours (qualifier value)'
code "Every three to six hours (qualifier value)": '396127008' from QICoreCommon."SNOMEDCT" display 'Every three to six hours (qualifier value)'
code "Every twelve hours (qualifier value)": '307470009' from QICoreCommon."SNOMEDCT" display 'Every twelve hours (qualifier value)'
code "Every twenty four hours (qualifier value)": '396125000' from QICoreCommon."SNOMEDCT" display 'Every twenty four hours (qualifier value)'
code "Every two to four hours (qualifier value)": '225752000' from QICoreCommon."SNOMEDCT" display 'Every two to four hours (qualifier value)'
code "Four times daily (qualifier value)": '307439001' from QICoreCommon."SNOMEDCT" display 'Four times daily (qualifier value)'
code "Once daily (qualifier value)": '229797004' from QICoreCommon."SNOMEDCT" display 'Once daily (qualifier value)'
code "One to four times a day (qualifier value)": '396109005' from QICoreCommon."SNOMEDCT" display 'One to four times a day (qualifier value)'
code "One to three times a day (qualifier value)": '396108002' from QICoreCommon."SNOMEDCT" display 'One to three times a day (qualifier value)'
code "One to two times a day (qualifier value)": '396107007' from QICoreCommon."SNOMEDCT" display 'One to two times a day (qualifier value)'
code "Three times daily (qualifier value)": '229798009' from QICoreCommon."SNOMEDCT" display 'Three times daily (qualifier value)'
code "Twice a day (qualifier value)": '229799001' from QICoreCommon."SNOMEDCT" display 'Twice a day (qualifier value)'
code "Two to four times a day (qualifier value)": '396111001' from QICoreCommon."SNOMEDCT" display 'Two to four times a day (qualifier value)'

parameter ErrorLevel String default 'Warning'
