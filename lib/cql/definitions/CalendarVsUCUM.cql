
/*
  "Single Live Birth Encounter" SingleLiveBirthEncounter
    with ["Assessment, Performed": "Gestational age--at birth"] GestationalAge
      such that GestationalAge.result >= 37 weeks
        and Global."EarliestOf" ( GestationalAge.relevantDatetime, GestationalAge.relevantPeriod ) during SingleLiveBirthEncounter.relevantPeriod
*/



// CQL Translator: Propose that the quantity unit be normalized (up to weeks)
//year != 'a'
//year ~ 'a' 365.26
//month != 'mo' (365.26 / 12)
//month ~ 'mo'

/*
CQL Specification Author's Guide Topic on UCUM Quantities:
https://build.fhir.org/ig/HL7/cql/02-authorsguide.html#quantities

CQL Specification Author's Guide Topic on Date/Time Arithmetic:
https://build.fhir.org/ig/HL7/cql/02-authorsguide.html#datetime-arithmetic

In particular, this aspect of the use of time-valued quantities in FHIR:
Although the CQL specification does not support arithmetic with definite quantity
durations above days (and weeks), data models that use UCUM for all quantities
may support implicit conversion from UCUM definite durations to calendar durations.
See [Use of FHIR Quantity](http://hl7.org/fhir/fhirpath.html#quantity) for an example.

This means that when a FHIR Quantity is converted to a CQL Quantity, the UCUM
definite-duration units are treated as equal to the calendar duration units.

Unless quality improvement logic specifically needs definite-duration time-valued
quantities, calendar duration units (and keywords in CQL) should be used.

An example of logic that requires definite-duration time-valued quantities:
