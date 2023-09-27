import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

import '../../../fhir_path.dart';

final simpleLiteralLexer = stringLexer | numberLexer;

final dateTimePrecisionLexer = string('year') |
    string('month') |
    string('week') |
    string('day') |
    string('hour') |
    string('minute') |
    string('second') |
    string('millisecond');

final dateTimeComponentLexer = dateTimePrecisionLexer |
    string('date') |
    string('time') |
    string('timezoneoffset');

final pluralDateTimePrecisionLexer = string('years') |
    string('months') |
    string('weeks') |
    string('days') |
    string('hours') |
    string('minutes') |
    string('seconds') |
    string('milliseconds');

final dateTimePrecisionSpecifierLexer = dateTimePrecisionLexer & string('of');

final relativeQualifierLexer = string('or before') | string('or after');

final offsetRelativeQualifierLexer = string('or more') | string('or less');

final exclusiveRelativeQualifierLexer =
    string('less than') | string('more than');

final quantityOffsetLexer =
    (quantityLexer & offsetRelativeQualifierLexer.optional()) |
        (exclusiveRelativeQualifierLexer & quantityLexer);

final temporalRelationshipLexer =
    ((string('on or').optional() & (string('before') | string('after'))) |
        ((string('before') | string('after')) & string('or on').optional()));

final intervalOperatorPhraseLexer =
    ((string('starts') | string('ends') | string('occurs')).optional() &
            string('same') &
            dateTimePrecisionLexer.optional() &
            (relativeQualifierLexer | string('as')) &
            (string('start') | string('end')).optional()) |
        (string('properly').optional() &
            string('includes') &
            dateTimePrecisionSpecifierLexer.optional() &
            (string('start') | string('end')).optional()) |
        ((string('starts') | string('ends') | string('occurs')).optional() &
            string('properly').optional() &
            (string('during') | string('included in')) &
            dateTimePrecisionSpecifierLexer.optional()) |
        ((string('starts') | string('ends') | string('occurs')).optional() &
            quantityOffsetLexer.optional() &
            temporalRelationshipLexer &
            dateTimePrecisionSpecifierLexer.optional() &
            (string('start') | string('end')).optional()) |
        ((string('starts') | string('ends') | string('occurs')).optional() &
            string('properly').optional() &
            string('within') &
            quantityLexer &
            string('of') &
            (string('start') | string('end')).optional()) |
        (string('meets') &
            (string('before') | string('after')).optional() &
            dateTimePrecisionSpecifierLexer.optional()) |
        (string('overlaps') &
            (string('before') | string('after')).optional() &
            dateTimePrecisionSpecifierLexer.optional()) |
        (string('starts') & dateTimePrecisionSpecifierLexer.optional()) |
        (string('ends') & dateTimePrecisionSpecifierLexer.optional());

final qualifiedInvocationLexer =
    referentialIdentifierLexer | qualifiedFunctionLexer;

final qualifiedFunctionLexer = identifierOrFunctionIdentifierLexer &
    char('(') &
    paramListLexer.optional() &
    char(')');

final invocationLexer = referentialIdentifierLexer |
    functionLexer |
    string(r'$this') |
    string(r'$index') |
    string(r'$total');

final functionLexer = referentialIdentifierLexer &
    char('(') &
    paramListLexer.optional() &
    char(')');

final ratioLexer = quantityLexer & char(':') & quantityLexer;

final cqlLiteralLexer = (string('true') | string('false')) |
    string('null') |
    stringLexer |
    numberLexer |
    longNumberLexer |
    dateTimeLexer |
    dateLexer |
    timeLexer |
    quantityLexer |
    ratioLexer;

final displayClauseLexer = string('display') & stringLexer;

final codeSelectorLexer = string('Code') &
    stringLexer &
    string('from') &
    codesystemIdentifierLexer &
    displayClauseLexer;

final conceptSelectorLexer = string('Concept') &
    char('{') &
    codeSelectorLexer &
    (char(',') & codeSelectorLexer).star() &
    char('}') &
    displayClauseLexer.optional();

final paramListLexer =
    fhirPathLexer() & (char(',') & fhirPathLexer()).optional();
