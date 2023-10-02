
/*
This library provides guidance for calculating Cumulative Medication Duration
using FHIR R4.
*/

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

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

parameter ErrorLevel String default 'Warning'
