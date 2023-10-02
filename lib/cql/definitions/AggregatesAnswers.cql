
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'


/*
1. How many observations does this patient have?
*/


/*
2. How many observations have an encounter?
*/

  [Observation] O
    where O.encounter is not null
  )

/*
3. How many different kinds of observations does this patient have?
*/

  [Observation] O
    return O.code
  )

/*
4. How many of each kind of observation does this patient have?
*/

  [Observation] O
    return {
      code: O.code,
      numberOfObservations: Count([Observation] InnerO where InnerO.code ~ O.code)
    }

/*
5. Which kinds of observations have more than one observation?
*/

  (
    [Observation] O
      return {
        code: O.code,
        numberOfObservations: Count([Observation] InnerO where InnerO.code ~ O.code)
      }
  ) ObservationsPerCode
    where ObservationsPerCode.numberOfObservations > 1

  NumberOfObservationsPerCode O
    where O.numberOfObservations > 1

/*
6. How many kinds of observations have more than one observation?
*/

    (
      [Observation] O
        return {
          code: O.code,
          numberOfObservations: Count([Observation] InnerO where InnerO.code ~ O.code)
        }
    ) NumberOfObservationsPerCode
      where NumberOfObservationsPerCode.numberOfObservations > 1
  )

  Count(ObservationCodesWithMultipleObservations)

/*
7. For each kind of observation with more than one observation, what is the date and result of the most recent observation?
*/
