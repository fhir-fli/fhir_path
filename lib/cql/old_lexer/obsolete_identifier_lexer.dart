import 'package:petitparser/petitparser.dart';

final obsoleteIdentifierLexer = string('all') |
    string('Code') |
    string('code') |
    string('Concept') |
    string('concept') |
    string('contains') |
    string('date') |
    string('display') |
    string('distinct') |
    string('end') |
    string('exists') |
    string('not') |
    string('start') |
    string('time') |
    string('timezoneoffset') |
    string('version') |
    string('where').map((value) {
      print(value);
      return value;
    });
