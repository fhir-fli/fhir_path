
using QDM version '5.3'

valueset "Inpatient Encounter": '1.2.3'
valueset "ED": '4.5.6'
valueset "ICU": '7.8.9'

//define "Measure Observation":
//  duration in minutes of "Related ED Visit"(Encounter). locationPeriod

// Arrival time: earliest start of a location period for any facility location
// Departure time: latest end of a location period for any facility location
  Interval
  [
    First(Encounter.facilityLocations Location 
      return start of Location.locationPeriod sort ascending),
    Last(Encounter.facilityLocations Location 
      return end of Location.locationPeriod sort ascending)
  ]
  
//define "Measure Observation":
//    duration in minutes of "Arrival And Departure Time"("Related ED Visit"(Encounter))
    
// Location-specific period