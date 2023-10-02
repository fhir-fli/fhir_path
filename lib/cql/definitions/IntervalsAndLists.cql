
// # Intervals And Lists

  Interval[3, 5)

  Interval[3.0, 5.0)

  Interval[@2014-01-01T00:00:00.0, @2015-01-01T00:00:00.0]

  Interval[3, 5) contains 4

  4 in Interval[3, 5)

  start of Interval[3, 5)

  end of Interval[3, 5)

  width of Interval[3, 5)

  Size(Interval[3, 5))

  Interval[3, 5) = Interval[3, 4]

  Interval[1, 2] before Interval[3, 4]

  Interval[3, 4] after Interval[1, 2]

  Interval[1, 2] meets Interval[3, 4]

  Interval[1, 5] overlaps Interval[3, 6]

  Interval[1, 2] starts Interval[1, 5]

  Interval[2, 4] included in Interval[1, 5]

  Interval[1, 5] includes Interval[2, 4]

  Interval[4, 5] ends Interval[1, 5]

// # Timing Phrases

  Interval[@2021-03-01, @2021-03-10]

  Interval[@2021-03-04, @2021-03-30]

  IntervalX starts before start IntervalY

  IntervalX starts 3 days before start IntervalY

  IntervalX starts 3 days or more before start IntervalY

  IntervalX starts within 3 days of start IntervalY

// # List Values

  { 1, 2, 3, 4, 5 }

  { 1, 'abc', null }

  { { X: 1, Y: 1 }, { X: 2, Y: 2 } }

  { 'a', 'b', 'c'}[1]

  IndexOf({ 1, 2, 3 }, 2)

  { 1, 'abc', null } contains null

  Length({ 1, 'abc', null })

  First({ 1, 2, 3 })

  Last({ 1, 2, 3 })

  singleton from { 1 }

// This will throw a run-time error, stopping evaluation of the library
//define "Singleton From (Error)":
//  singleton from { 1, 2, 3 }

  Take({ 1, 2, 3, 4 }, 2)

  Skip({ 1, 2, 3, 4 }, 2)

  Tail({ 1, 2, 3, 4 })

  { 1, 2, 3, 4, 5 }

  { 2, 3, 4 }

  ListX contains 3

  3 in ListX

  ListX includes ListY

  ListY included in ListX

// # List Union



  ListA union ListB

  { 1, 2, 3 } union { 'a', 'b', 'c' }

  ListA intersect ListB

  ListA except ListB

// # Aggregates

  Count({ 1, 2, 3, null})

  Sum({ 1, 2, 3, null })

  Min({ 1, 2, 3, null })

  Max({ 1, 2, 3, null })

  Avg({ 1, 2, 3, null })

  Median({ 1, 2, 3, null })

  Mode({ 1, 2, 3, null })

  Variance({ 1, 2, 3, null })

  StdDev({ 1, 2, 3, null })

  PopulationVariance({ 1, 2, 3, null })

  PopulationStdDev({ 1, 2, 3, null })

  AllTrue({ true, false, true })

  AnyTrue({ true, false, true })

// # Lists of Strings

  Combine({ 'ab', 'cd', 'ef' })

  Combine({ 'completed', 'refused', 'pending' }, ';')

  Split('completed;refused;pending', ';')

// # Lists of Lists

  flatten { { 1, 2, 3 }, { 2, 3, 4 }, { 3, 4, 5 } }

  distinct { 1, 2, 3, 2, 3, 4, 3, 4, 5 }

  { { 1, 2, 3 }, { { 'a', 'b' }, { 'x', 'y' } } }

  { { 1, 2, 3 }, 2, 3, 4 }

// # Lists of Intervals

  collapse { Interval[1, 6], Interval[3, 7], Interval[9, 12] }
