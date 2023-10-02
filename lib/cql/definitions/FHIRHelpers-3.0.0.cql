
using FHIR version '3.0.0'

    if period is null then
        null
    else
        Interval[period."start".value, period."end".value]

    if quantity is null then
        null
    else
        System.Quantity { value: quantity.value.value, unit: quantity.unit.value }

    if range is null then
        null
    else
        Interval[ToQuantity(range.low), ToQuantity(range.high)]

    if coding is null then
        null
    else
        System.Code {
          code: coding.code.value,
          system: coding.system.value,
          version: coding.version.value,
          display: coding.display.value
        }

    if concept is null then
         null
    else
        System.Concept {
            codes: concept.coding C return ToCode(C),
            display: concept.text.value
        }
