
using QDM version '5.3'

parameter "Measurement Period" Interval<DateTime>


/*
  There are two approaches to identifying a diagnosis:
    1) With a Diagnosis data element
    2) With a Diagnosis attribute on an encounter
*/

/*
  The first approach: with a Diagnosis element that overlaps the encounter in some way:
*/
  "Delivery Encounters Ages 8 Years to less than 65" DeliveryEncounters
    with ["Diagnosis": "Multiple Gestation"] MultGest
      such that MultGest.prevalencePeriod starts 42 weeks or less before or on end DeliveryEncounters.relevantPeriod

/*
  The second approach: With a diagnosis attribute on the encounter itself
*/
  "Delivery Encounters Ages 8 Years to less than 65" DeliveryEncounters
    where exists ( DeliveryEncounters.diagnoses MultGest where MultGest in "Multiple Gestation" )

/*
  To look for either, we can "union" the above expressions, or we can combine
  them into a single definition. To combine them, we have to use a filter
  because using a "with" would require the relationship to always exist
*/