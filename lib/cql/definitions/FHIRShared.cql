
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include FHIRCommon called FC

parameter AsOf DateTime default Now()


  First(
    observations O
      sort by issued
  )

  First(
    observations O
      sort by issued
  )

  Last(
    observations O
      sort by issued
  )

  Last(
    observations O
      sort by issued
  )

  Last(
    observations O
      where O.issued on or before AsOf
      sort by issued
  )

  Last(
    observations O
      where O.issued on or before AsOf
      sort by issued
  )

  First(
    observations O
      sort by (value as FHIR.Quantity)
  )

  First(
    observations O
      sort by (value as FHIR.Quantity)
  )

  Last(
    observations O
      sort by (value as FHIR.Quantity)
  )

  Last(
    observations O
      sort by (value as FHIR.Quantity)
  )

  case
    when value is true then 1
    when value is false then 0
    else null
  end

  case
    when value is true then 1
    when value is false then 0
    else null
  end

  if value is true then
    displayString
  else
    null
