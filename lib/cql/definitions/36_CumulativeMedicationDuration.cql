
/*
This library provides guidance for calculating Cumulative Medication Duration
using QDM 5.5 and above.
*/

using QDM version '5.5'

codesystem "EventTiming": 'urn:oid:2.16.840.1.113883.4.642.1.69' // http://hl7.org/fhir/event-timing

code "HS": 'HS' from "EventTiming" // event occurs [offset] before the hour of sleep (or trying to)
code "WAKE": 'WAKE' from "EventTiming" // event occurs [offset] after waking
code "C": 'C' from "EventTiming" //	event occurs at a meal (from the Latin cibus)
code "CM": 'CM' from "EventTiming" //	event occurs at breakfast (from the Latin cibus matutinus)
code "CD": 'CD' from "EventTiming" //	event occurs at lunch (from the Latin cibus diurnus)
code "CV": 'CV' from "EventTiming" //	event occurs at dinner (from the Latin ante cibus vespertinus)
code "AC": 'AC' from "EventTiming" //	event occurs [offset] before a meal (from the Latin ante cibus)
code "ACM": 'ACM' from "EventTiming" //	event occurs [offset] before breakfast (from the Latin ante cibus matutinus)
code "ACD": 'ACD' from "EventTiming" //	event occurs [offset] before lunch (from the Latin ante cibus diurnus)
code "ACV": 'ACV' from "EventTiming" //	event occurs [offset] before dinner (from the Latin ante cibus vespertinus)
code "PC": 'PC' from "EventTiming" //	event occurs [offset] after a meal (from the Latin post cibus)
code "PCM": 'PCM' from "EventTiming" //	event occurs [offset] after breakfast (from the Latin post cibus matutinus)
code "PCD": 'PCD' from "EventTiming" //	event occurs [offset] after lunch (from the Latin post cibus diurnus)
code "PCV": 'PCV' from "EventTiming" //	event occurs [offset] after dinner (from the Latin post cibus vespertinus)
