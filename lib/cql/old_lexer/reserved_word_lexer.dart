import 'package:petitparser/petitparser.dart';

final reservedWordLexer = string('aggregate') |
    string('all') |
    string('and') |
    string('as') |
    string('after') |
    string('before') |
    string('between') |
    string('case') |
    string('cast') |
    string('Code') |
    string('collapse') |
    string('Concept') |
    string('convert') |
    string('day') |
    string('days') |
    string('difference') |
    string('distinct') |
    string('duration') |
    string('during') |
    string('else') |
    string('exists') |
    string('expand') |
    string('false') |
    string('flatten') |
    string('from') |
    string('if') |
    string('in') |
    string('included in') |
    string('is') |
    string('hour') |
    string('hours') |
    string('Interval') |
    string('let') |
    string('List') |
    string('maximum') |
    string('millisecond') |
    string('milliseconds') |
    string('minimum') |
    string('minute') |
    string('minutes') |
    string('month') |
    string('months') |
    string('not') |
    string('null') |
    string('occurs') |
    string('of') |
    string('on or') |
    string('or') |
    string('or on') |
    string('per') |
    string('point') |
    string('properly') |
    string('return') |
    string('same') |
    string('second') |
    string('seconds') |
    string('singleton') |
    string('sort') |
    string('such that') |
    string('then') |
    string('to') |
    string('true') |
    string('Tuple') |
    string('week') |
    string('weeks') |
    string('when') |
    string('with') |
    string('within') |
    string('without') |
    string('year') |
    string('years').map((value) {
      print(value);
      return value;
    });
