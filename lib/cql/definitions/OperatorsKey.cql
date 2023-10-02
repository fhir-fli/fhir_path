
// # String Equality and Equivalence

  ('Abel' = 'abel') is false

  ('Abel' ~ 'abel') is true

  ('Abel' < 'abel') is true

  ('Abel' != 'abel') is true

  ('Abel' !~ 'abel') is false

  ('Abel' = null) is null

  ('Abel' ~ null) is false

// # Equality vs Equivalence


  (T1 = T2) is true

  (T2 = T3) is null

  (T2 ~ T3) is false

  Code {
    code: 'ABC',
    display: 'Code ABC',
    system: 'http://example.com',
    version: '2017-01'
  }

  Code {
    code: 'ABC',
    display: 'Variant Description',
    system: 'http://example.com',
    version: '2017-05'
  }

  (C1 = C2) is false

  (C1 ~ C2) is true

// # Arithmetic Operators

  (2 + 5 * 10 = 52) is true

  ((2 + 5) * 10 = 70) is true

  (10 / 2 = 5.0) is true

  (10 div 2 = 5) is true

  (10 mod 2 = 0) is true

  (-(10) = -10) is true

  (Abs(-10) = 10) is true

  (successor of 1 = 2) is true

  (predecessor of 1 = 0) is true

  (minimum Integer = -2147483647 - 1) is true

  (maximum Integer = 2147483647) is true

// # Rounding And Exponents

  (Round(5.5) = 6) is true

  (Round(5.55, 1) = 5.6) is true

  (Truncate(5.5) = 5) is true

  (Truncate(-5.5) = -5) is true

  (Floor(5.5) = 5) is true

  (Floor(-5.5) = -6) is true

  (Ceiling(5.5) = 6) is true

  (Ceiling(-5.5) = -5) is true

  (2 ^ 5 = 25) is true

  (25 ^ 0.5 = 5) is true

  (Log(25, 5) = 2) is true

  (Log(5, 25) = 0.5) is true

  (Ln(10) = 2.30258209288405) is true

  (Exp(2.30258509288405) = 10) is true

// # String Manipulation

   'AB' + 'CD' = 'ABCD'

  'AB' + null

  'AB' & null & 'CD'

  Length('ABCD')

  'ABCD'[0]

  PositionOf('C', 'ABCDCBA')

  LastPositionOf('C', 'ABCDCBA')

  StartsWith('AB', 'ABCDCBA')

  EndsWith('AB', 'ABCDCBA')

  Matches('ABCD', 'AB.*')

  ReplaceMatches('ABCD', 'C', 'X')

// # Date Comparisons

  @2014-01-15 = @2014-02-15

  @2014-01-15 < @2014-02-15

  @2014-01-15 <= @2014-02-15

  @2014-01-15 same year as @2014-02-15

  @2012-01-15 same year or before @2014-02-15

  @2012-01-15 before year of @2014-02-15

// # Date Arithmetic

  1 day

  2 years

  30 minutes

  1 'd'

  2 'a'

  30 'min'

  Today() - 1 year

  @2014-02-01T14:30 + 30 minutes

  @2014 + 24 months

  1 year ~ 1 'a'

  1 month ~ 1 'mo'

  1 week = 1 'wk'

  1 day = 1 'd'

  1 hour = 1 'h'

  1 minute = 1 'min'

  1 second = 1 's'

  1 millisecond = 1 'ms'

// # Duration And Difference

  duration in months between @2014-01-31 and @2014-02-01

  difference in months between @2014-01-31 and @2014-02-01

// # Conditionals

  10.0 'mg/mL'

  if strength.value < 0.1 then
    Quantity {
      value: strength.value * 1000,
      unit: 'mcg' + Substring(strength.unit, 2)
    }
  else
    strength

  'MG/ACTUAT'

  case unit
    when 'MG' then 'mg'
    when 'MG/ACTUAT' then 'mg/{actuat}'
    when 'MG/HR' then 'mg/h'
    when 'MG/ML' then 'mg/mL'
    else '{' + unit + '}'
  end

  316897
