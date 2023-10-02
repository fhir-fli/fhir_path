
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'


  collapse(
    {
      Interval[@2021-01-06, @2021-01-08],
      Interval[@2021-01-08, null]
    }
  )
