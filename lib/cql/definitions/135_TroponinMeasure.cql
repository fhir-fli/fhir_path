
/*
Measure Description: Measure in minutes of the time interval between the time the
results for troponin tests are determined and when the troponin levels are reported
by the laboratory to the responsible provider. This measure uses a continuous variable.

Only the first troponin test followed by a communication during the encounter is
counted as the measure observation. The communication should be completed after
the test and should be related to the test for which it is attributed.

The issue is in trying to create the logic to relate the Communication to a
specific test when there are multiple Troponin tests during an encounter.
Using the following as an example, during an encounter we have two Troponin tests
and one Communication:

    The first Troponin test result date time: 2/12/2019 1100
    The second Troponin test result date time: 2/12/2019 1205
    The first Communication sent date time: 2/12/2019 1305

We want to have the ability to relate the Communication to the second Troponin test,
if we so desired (so that the measure observation = 60 minutes), but the logic is such
that the Communication is always related to the first Troponin test
(with the measure observation = 125 minutes). Our thought was that we could use the
attributes .id and .relatedTo to make the association between Communication and test,
but Bonnie tests are showing the Communication always relates to the first test in this
example even when “Related To” the second test.
*/

using QDM version '5.5'

valueset "Cardiac Troponin": 'TBD'
valueset "Lab Communications": 'TBD'

parameter "Measurement Period" Interval<DateTime>
