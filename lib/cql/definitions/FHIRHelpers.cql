
using FHIR version '4.0.1'

/*
@description: Converts the given [Period](https://hl7.org/fhir/datatypes.html#Period)
value to a CQL DateTime Interval
@comment: If the start value of the given period is unspecified, the starting
boundary of the resulting interval will be open (meaning the start of the interval
is unknown, as opposed to interpreted as the beginning of time).
*/
    if period is null then
        null
    else
        if period."start" is null then
            Interval(period."start".value, period."end".value]
        else
            Interval[period."start".value, period."end".value]

/*
@description: Converts a UCUM definite duration unit to a CQL calendar duration
unit using conversions specified in the [quantities](https://cql.hl7.org/02-authorsguide.html#quantities) 
topic of the CQL specification.
@comment: Note that for durations above days (or weeks), the conversion is understood to be approximate
*/
    case unit
        when 'ms' then 'millisecond'
        when 's' then 'second'
        when 'min' then 'minute'
        when 'h' then 'hour'
        when 'd' then 'day'
        when 'wk' then 'week'
        when 'mo' then 'month'
        when 'a' then 'year'
        else unit
    end

/*
@description: Converts the given FHIR [Quantity](https://hl7.org/fhir/datatypes.html#Quantity) 
value to a CQL Quantity
@comment: If the given quantity has a comparator specified, a runtime error is raised. If the given quantity
has a system other than UCUM (i.e. `http://unitsofmeasure.org`) or CQL calendar units (i.e. `http://hl7.org/fhirpath/CodeSystem/calendar-units`)
an error is raised. For UCUM to calendar units, the `ToCalendarUnit` function is used.
@seealso: ToCalendarUnit
*/
    case
        when quantity is null then null
        when quantity.value is null then null
        when quantity.comparator is not null then
            Message(null, true, 'FHIRHelpers.ToQuantity.ComparatorQuantityNotSupported', 'Error', 'FHIR Quantity value has a comparator and cannot be converted to a System.Quantity value.')
        when quantity.system is null or quantity.system.value = 'http://unitsofmeasure.org'
              or quantity.system.value = 'http://hl7.org/fhirpath/CodeSystem/calendar-units' then
            System.Quantity { value: quantity.value.value, unit: ToCalendarUnit(Coalesce(quantity.code.value, quantity.unit.value, '1')) }
        else
            Message(null, true, 'FHIRHelpers.ToQuantity.InvalidFHIRQuantity', 'Error', 'Invalid FHIR Quantity code: ' & quantity.unit.value & ' (' & quantity.system.value & '|' & quantity.code.value & ')')
    end

/*
@description: Converts the given FHIR [Quantity](https://hl7.org/fhir/datatypes.html#Quantity) value to a CQL Quantity, ignoring
the comparator element. This function should only be used when an application is justified in ignoring the comparator value (i.e. the
@comment: If the given quantity has a system other than UCUM (i.e. `http://unitsofmeasure.org`) or CQL calendar units 
(i.e. `http://hl7.org/fhirpath/CodeSystem/calendar-units`) an error is raised. For UCUM to calendar units, the `ToCalendarUnit` function 
is used.
@seealso: ToCalendarUnit
*/
    case
        when quantity is null then null
        when quantity.value is null then null
        when quantity.system is null or quantity.system.value = 'http://unitsofmeasure.org'
              or quantity.system.value = 'http://hl7.org/fhirpath/CodeSystem/calendar-units' then
            System.Quantity { value: quantity.value.value, unit: ToCalendarUnit(Coalesce(quantity.code.value, quantity.unit.value, '1')) }
        else
            Message(null, true, 'FHIRHelpers.ToQuantity.InvalidFHIRQuantity', 'Error', 'Invalid FHIR Quantity code: ' & quantity.unit.value & ' (' & quantity.system.value & '|' & quantity.code.value & ')')
    end

/*
@description: Converts the given FHIR [Quantity](https://hl7.org/fhir/datatypes.html#Quantity) value to a CQL Interval of Quantity.
@comment: If the given quantity has a comparator, it is used to construct an interval based on the value of the comparator. If the comparator
is less than, the resulting interval will start with a null closed boundary and end with an open boundary on the quantity. If the comparator
is less than or equal, the resulting interval will start with a null closed boundary and end with a closed boundary on the quantity. If the 
comparator is greater or equal, the resulting interval will start with a closed boundary on the quantity and end with a closed null boundary.
If the comparator is greatter than, the resulting interval will start with an open boundary on the quantity and end with a closed null boundary.
If no comparator is specified, the resulting interval will start and end with a closed boundary on the quantity.
*/
    if quantity is null then null else
        case quantity.comparator.value
            when '<' then
                Interval[
                    null,
                    ToQuantityIgnoringComparator(quantity)
                )
            when '<=' then
                Interval[
                    null,
                    ToQuantityIgnoringComparator(quantity)
                ]
            when '>=' then
                Interval[
                    ToQuantityIgnoringComparator(quantity),
                    null
                ]
            when '>' then
                Interval(
                    ToQuantityIgnoringComparator(quantity),
                    null
                ]
            else
                Interval[ToQuantity(quantity), ToQuantity(quantity)]
        end

/*
@description: Converts the given FHIR [Ratio](https://hl7.org/fhir/datatypes.html#Ratio) value to a CQL Ratio.
*/
    if ratio is null then
        null
    else
        System.Ratio { numerator: ToQuantity(ratio.numerator), denominator: ToQuantity(ratio.denominator) }

/*
@description: Converts the given FHIR [Range](https://hl7.org/fhir/datatypes.html#Range) value to a CQL Interval of Quantity
*/
    if range is null then
        null
    else
        Interval[ToQuantity(range.low), ToQuantity(range.high)]

/*
@description: Converts the given FHIR [Coding](https://hl7.org/fhir/datatypes.html#Coding) value to a CQL Code.
*/
    if coding is null then
        null
    else
        System.Code {
          code: coding.code.value,
          system: coding.system.value,
          version: coding.version.value,
          display: coding.display.value
        }

/*
@description: Converts the given FHIR [CodeableConcept](https://hl7.org/fhir/datatypes.html#CodeableConcept) value to a CQL Concept.
*/
    if concept is null then
        null
    else
        System.Concept {
            codes: concept.coding C return ToCode(C),
            display: concept.text.value
        }

/*
@description: Converts the given value (assumed to be a URI) to a CQL [ValueSet](https://cql.hl7.org/09-b-cqlreference.html#valueset)
*/
    if uri is null then
        null
    else
        System.ValueSet {
            id: uri
        }

/*
@description: Constructs a FHIR [Reference](https://hl7.org/fhir/datatypes.html#Reference) from the given reference (assumed to be a FHIR resource URL)
*/
    if reference is null then
        null
    else
        Reference { reference: string { value: reference } }

/*
@description: Converts the given value to a CQL value using the appropriate accessor or conversion function.
@comment: TODO: document conversion
*/
        boolean,
        canonical,
        code,
        date,
        dateTime,
        decimal,
        id,
        instant,
        integer,
        markdown,
        oid,
        positiveInt,
        string,
        time,
        unsignedInt,
        uri,
        url,
        uuid,
        Address,
        Age,
        Annotation,
        Attachment,
        CodeableConcept,
        Coding,
        ContactPoint,
        Count,
        Distance,
        Duration,
        HumanName,
        Identifier,
        Money,
        Period,
        Quantity,
        Range,
        Ratio,
        Reference,
        SampledData,
        Signature,
        Timing,
        ContactDetail,
        Contributor,
        DataRequirement,
        Expression,
        ParameterDefinition,
        RelatedArtifact,
        TriggerDefinition,
        UsageContext,
        Dosage,
        Meta>):
    case
      when value is base64Binary then (value as base64Binary).value
      when value is boolean then (value as boolean).value
      when value is canonical then (value as canonical).value
      when value is code then (value as code).value
      when value is date then (value as date).value
      when value is dateTime then (value as dateTime).value
      when value is decimal then (value as decimal).value
      when value is id then (value as id).value
      when value is instant then (value as instant).value
      when value is integer then (value as integer).value
      when value is markdown then (value as markdown).value
      when value is oid then (value as oid).value
      when value is positiveInt then (value as positiveInt).value
      when value is string then (value as string).value
      when value is time then (value as time).value
      when value is unsignedInt then (value as unsignedInt).value
      when value is uri then (value as uri).value
      when value is url then (value as url).value
      when value is uuid then (value as uuid).value
      when value is Age then ToQuantity(value as Age)
      when value is CodeableConcept then ToConcept(value as CodeableConcept)
      when value is Coding then ToCode(value as Coding)
      when value is Count then ToQuantity(value as Count)
      when value is Distance then ToQuantity(value as Distance)
      when value is Duration then ToQuantity(value as Duration)
      when value is Quantity then ToQuantity(value as Quantity)
      when value is Range then ToInterval(value as Range)
      when value is Period then ToInterval(value as Period)
      when value is Ratio then ToRatio(value as Ratio)
      else value as Choice<Address,
        Annotation,
        Attachment,
        ContactPoint,
        HumanName,
        Identifier,
        Money,
        Reference,
        SampledData,
        Signature,
        Timing,
        ContactDetail,
        Contributor,
        DataRequirement,
        Expression,
        ParameterDefinition,
        RelatedArtifact,
        TriggerDefinition,
        UsageContext,
        Dosage,
        Meta>
    end

/*
@description: Resolve the given reference as a url to a resource. If the item resolves, the Resource is returned, otherwise the result is null.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Resolve the reference element of the given Reference. If the item resolves, the Resource is returned, otherwise the result is null.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Constructs a Reference to the given Resource. The resulting reference will typically be relative, but implementations may provide a base URL if one can be unambiguously determined.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns any extensions with the given url defined on the given element.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns any extensions with the given url defined on the given resource.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns any modifier extensions with the given url defined on the given element.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns any modifier extensions with the given url defined on the given resource.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the element is a FHIR primitive type with a value element (as opposed to having only extensions); false otherwise
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns the value of the FHIR primitive; null otherwise
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns a list containing only those elements in the input that are of the given type, specified as a string.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the input is of the given type; false otherwise
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: If the input is of the given type; returns the value as that type; null otherwise.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns the FHIR element definition for the given element
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns the given slice as defined in the given structure definition. The structure argument is a uri that resolves to the structure definition, and the name must be the name of a slice within that structure definition. If the structure cannot be resolved, or the name of the slice within the resolved structure is not present, an error is thrown.
@comment: For every element in the input collection, if the resolved slice is present on the element, it will be returned. If the slice does not match any element in the input collection, or if the input collection is empty, the result is an empty collection ({ }).
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: For each element in the input collection, verifies that there are no modifying extensions defined other than the ones given by the modifier argument. If the check passes, the input collection is returned. Otherwise, an error is thrown.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: For each element in the input collection, verifies that there are no modifying extensions defined other than the ones given by the modifier argument. If the check passes, the input collection is returned. Otherwise, an error is thrown.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: For each element in the input collection, verifies that there are no modifying extensions defined other than the ones given by the modifier argument. If the check passes, the input collection is returned. Otherwise, an error is thrown.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: For each element in the input collection, verifies that there are no modifying extensions defined other than the ones given by the modifier argument. If the check passes, the input collection is returned. Otherwise, an error is thrown.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the single input element conforms to the profile specified by the structure argument, and false otherwise. If the structure cannot be resolved to a valid profile, an error is thrown. If the input contains more than one element, an error is thrown. If the input is empty, the result is empty.
@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the given code is equal to a code in the valueset, so long as the valueset only contains one codesystem. If the valueset contains more than one codesystem, an error is thrown.
@comment: If the valueset cannot be resolved as a uri to a value set, an error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

For example:

```fhirpath
Observation.component.where(code.memberOf('http://hl7.org/fhir/ValueSet/observation-vitalsignresult'))
```

This expression returns components that have a code that is a member of the observation-vitalsignresult valueset.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the code is a member of the given valueset.
@comment: If the valueset cannot be resolved as a uri to a value set, an error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

For example:

```fhirpath
Observation.component.where(code.memberOf('http://hl7.org/fhir/ValueSet/observation-vitalsignresult'))
```

This expression returns components that have a code that is a member of the observation-vitalsignresult valueset.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if any code in the concept is a member of the given valueset.
@comment: If the valueset cannot be resolved as a uri to a value set, an error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

For example:

```fhirpath
Observation.component.where(code.memberOf('http://hl7.org/fhir/ValueSet/observation-vitalsignresult'))
```

This expression returns components that have a code that is a member of the observation-vitalsignresult valueset.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the source code is equivalent to the given code, or if the source code subsumes the given code (i.e. the source code is an ancestor of the given code in a subsumption hierarchy), and false otherwise.

@comment: If the Codings are from different code systems, the relationships between the code systems must be well-defined or a run-time error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if any Coding in the source or given elements is equivalent to or subsumes the given code.

@comment: If the Codings are from different code systems, the relationships between the code systems must be well-defined or a run-time error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if the source code is equivalent to the given code, or if the source code is subsumed by the given code (i.e. the source code is a descendant of the given code in a subsumption hierarchy), and false otherwise.

@comment: If the Codings are from different code systems, the relationships between the code systems must be well-defined or a run-time error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: Returns true if any Coding in the source or given elements is equivalent to or subsumed by the given code.

@comment: If the Codings are from different code systems, the relationships between the code systems must be well-defined or a run-time error is thrown.

Note that implementations are encouraged to make use of a terminology service to provide this functionality.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
/*
@description: When invoked on an xhtml element, returns true if the rules around HTML usage are met, and false if they are not. The return value is undefined (null) on any other kind of element.

@seealso: https://hl7.org/fhir/fhirpath.html#functions
*/
