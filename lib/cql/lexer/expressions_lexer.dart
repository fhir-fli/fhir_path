import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

import '../../../fhir_path.dart';
import '../parser/parser.dart';

final querySourceLexer = retrieveLexer |
    qualifiedIdentifiercqlExpressionLexer |
    (char('(') & cqlExpressionLexer() & char(')'));

final aliasedQuerySourceLexer = querySourceLexer & aliasLexer;

final aliasLexer = cqlIdentifierLexer;

final queryInclusionClauseLexer = withClauseLexer | withoutClauseLexer;

final withClauseLexer = string('with') &
    aliasedQuerySourceLexer &
    string('such that') &
    cqlExpressionLexer();

final withoutClauseLexer = string('without') &
    aliasedQuerySourceLexer &
    string('such that') &
    cqlExpressionLexer();

final retrieveLexer = char('[') &
    (contextIdentifierLexer & string('->')).optional() &
    namedTypeSpecifierLexer &
    (char(':') &
            (codePathLexer & codeComparatorLexer).optional() &
            terminologyLexer)
        .optional() &
    char(']');

final contextIdentifierLexer = qualifiedIdentifiercqlExpressionLexer;

final codePathLexer = simplePathLexer();

final codeComparatorLexer = string('in') | char('=') | char('~');

final terminologyLexer =
    qualifiedIdentifiercqlExpressionLexer | cqlExpressionLexer();

final qualifierLexer = cqlIdentifierLexer;

final queryLexer = sourceClauseLexer &
    letClauseLexer.optional() &
    queryInclusionClauseLexer.optional() &
    whereClauseLexer.optional() &
    (aggregateClauseLexer | returnClauseLexer).optional() &
    sortClauseLexer.optional();

final sourceClauseLexer = string('from').optional() &
    aliasedQuerySourceLexer &
    (char(',') & aliasedQuerySourceLexer).star();

final letClauseLexer = string('let') &
    letClauseItemLexer &
    (char(',') & letClauseItemLexer).star();

final letClauseItemLexer =
    cqlIdentifierLexer & char(':') & cqlExpressionLexer();

final whereClauseLexer = string('where') & cqlExpressionLexer();

final returnClauseLexer = string('return') &
    (string('all') | string('distinct')).optional() &
    cqlExpressionLexer();

final aggregateClauseLexer = string('aggregate') &
    (string('all') | string('distinct')).optional() &
    cqlIdentifierLexer &
    startingClauseLexer.optional() &
    char(':') &
    cqlExpressionLexer();

final startingClauseLexer = string('starting') &
    (simpleLiteralLexer |
        quantityLexer |
        (char('(') & expressionDefinitionLexer & char(')')));

final sortClauseLexer = string('sort') &
    (sortDirectionLexer |
        (string('by') &
            sortByItemLexer &
            (char(',') & sortByItemLexer).star()));

final sortDirectionLexer =
    string('asc') | string('ascending') | string('desc') | string('descending');

final sortByItemLexer = cqlExpressionLexer() & sortDirectionLexer.optional();

final Parser<QualifiedIdentifierParser> qualifiedIdentifierLexer =
    ((qualifierLexer & char('.')).star() & cqlIdentifierLexer).map((value) =>
        QualifiedIdentifierParser(
            value.length == 1 ? null : value[0].toString(),
            value.last.toString()));

final qualifiedIdentifiercqlExpressionLexer =
    (qualifiercqlExpressionLexer & char('.')).star() &
        referentialIdentifierLexer;

final qualifiercqlExpressionLexer = referentialIdentifierLexer;

Parser simplePathLexer() {
  final simplePathLexer = undefined();
  final simplePathLexerPart = referentialIdentifierLexer |
      (simplePathLexer & char('.') & referentialIdentifierLexer) |
      (simplePathLexer & char('[') & simpleLiteralLexer & char(']'));
  simplePathLexer.set(simplePathLexerPart);
  return simplePathLexer;
}

final simpleLiteralLexer = stringLexer | numberLexer;

Parser cqlExpressionLexer() {
  final cqlExpressionLexer = undefined();
  final cqlExpressionLexerPart = expressionTermLexer() |
      retrieveLexer |
      queryLexer |
      (cqlExpressionLexer &
          string('is') &
          string('not').optional() &
          (string('null') | string('true') | string('false'))) |
      (cqlExpressionLexer &
          (string('is') | string('as')) &
          typeSpecifierLexer()) |
      (string('cast') &
          cqlExpressionLexer &
          string('as') &
          typeSpecifierLexer()) |
      (string('not') & cqlExpressionLexer) |
      (string('exists') & cqlExpressionLexer) |
      (cqlExpressionLexer &
          string('properly').optional() &
          string('between') &
          expressionTermLexer() &
          string('and') &
          expressionTermLexer()) |
      ((string('duration') & string('in')).optional() &
          pluralDateTimePrecisionLexer &
          string('between') &
          expressionTermLexer() &
          string('and') &
          expressionTermLexer()) |
      (string('difference') &
          string('in') &
          pluralDateTimePrecisionLexer &
          string('between') &
          expressionTermLexer() &
          string('and') &
          expressionTermLexer()) |
      (cqlExpressionLexer &
          (string('<=') | char('<') | char('>') | string('>=')) &
          cqlExpressionLexer) |
      (cqlExpressionLexer & intervalOperatorPhraseLexer & cqlExpressionLexer) |
      (cqlExpressionLexer &
          (char('=') | string('!=') | char('~') | string('!~')) &
          cqlExpressionLexer) |
      (cqlExpressionLexer &
          (string('in') | string('contains')) &
          dateTimePrecisionSpecifierLexer.optional() &
          cqlExpressionLexer) |
      (cqlExpressionLexer & string('and') & cqlExpressionLexer) |
      (cqlExpressionLexer &
          (string('or') | string('xor')) &
          cqlExpressionLexer) |
      (cqlExpressionLexer & string('implies') & cqlExpressionLexer) |
      (cqlExpressionLexer &
          (char('|') |
              string('union') |
              string('intersect') |
              string('except')) &
          cqlExpressionLexer);
  cqlExpressionLexer.set(cqlExpressionLexerPart);
  return cqlExpressionLexer;
}

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

Parser expressionTermLexer() {
  final expressionTermLexer = undefined();
  final expressionTermLexerPart = termLexer |
      (expressionTermLexer & char('.') & qualifiedInvocationLexer) |
      (expressionTermLexer & char('[') & cqlExpressionLexer() & char(']')) |
      (string('convert') &
          cqlExpressionLexer() &
          string('to') &
          (typeSpecifierLexer() | unitLexer)) |
      ((char('+') | char('-')) & expressionTermLexer) |
      ((string('start') | string('end')) & string('of') & expressionTermLexer) |
      (dateTimeComponentLexer & string('from') & expressionTermLexer) |
      (string('duration') &
          string('in') &
          pluralDateTimePrecisionLexer &
          string('of') &
          expressionTermLexer) |
      (string('difference') &
          string('in') &
          pluralDateTimePrecisionLexer &
          string('of') &
          expressionTermLexer) |
      (string('width') & string('of') & expressionTermLexer) |
      (string('successor') & string('of') & expressionTermLexer) |
      (string('predecessor') & string('of') & expressionTermLexer) |
      (string('singleton') & string('from') & expressionTermLexer) |
      (string('point') & string('from') & expressionTermLexer) |
      ((string('minimum') | string('maximum')) & namedTypeSpecifierLexer) |
      (expressionTermLexer & char('^') & expressionTermLexer) |
      (expressionTermLexer &
          (char('*') | char('/') | char('div') | char('mod')) &
          expressionTermLexer) |
      (expressionTermLexer &
          (char('+') | char('-') | char('&')) &
          expressionTermLexer) |
      (string('if') &
          cqlExpressionLexer() &
          string('then') &
          cqlExpressionLexer() &
          string('else') &
          cqlExpressionLexer()) |
      (string('case') &
          cqlExpressionLexer().optional() &
          caseExpressionItemLexer.plus() &
          string('else') &
          cqlExpressionLexer() &
          string('end')) |
      ((string('distinct') | string('flatten')) & cqlExpressionLexer()) |
      ((string('expand') | string('collapse')) &
          cqlExpressionLexer() &
          (string('per') & (dateTimePrecisionLexer | cqlExpressionLexer()))
              .optional());
  expressionTermLexer.set(expressionTermLexerPart);
  return expressionTermLexer;
}

final caseExpressionItemLexer = string('when') &
    cqlExpressionLexer() &
    string('then') &
    cqlExpressionLexer();

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

final termLexer = invocationLexer |
    literalLexer |
    externalConstantLexer |
    intervalSelectorLexer |
    tupleSelectorLexer |
    instanceSelectorLexer |
    listSelectorLexer |
    codeSelectorLexer |
    conceptSelectorLexer |
    (char('(') & cqlExpressionLexer() & char(')'));

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

final literalLexer = (string('true') | string('false')) |
    string('null') |
    stringLexer |
    numberLexer |
    longNumberLexer |
    dateTimeLexer |
    dateLexer |
    timeLexer |
    quantityLexer |
    ratioLexer;

final intervalSelectorLexer = string('Interval') &
    (char('[') | char('(')) &
    cqlExpressionLexer() &
    char(',') &
    cqlExpressionLexer() &
    (char(']') | char(')'));

final tupleSelectorLexer = string('Tuple').optional() &
    char('{') &
    (char(':') |
        (tupleElementSelectorLexer &
            (char(',') & tupleElementSelectorLexer).star())) &
    char('}');

final tupleElementSelectorLexer =
    referentialIdentifierLexer & char(':') & cqlExpressionLexer();

final instanceSelectorLexer = namedTypeSpecifierLexer &
    char('{') &
    (char(':') |
        (instanceElementSelectorLexer &
            (char(',') & instanceElementSelectorLexer).star())) &
    char('}');

final instanceElementSelectorLexer =
    referentialIdentifierLexer & char(':') & cqlExpressionLexer();

final listSelectorLexer =
    (string('List') & (char('<') & typeSpecifierLexer() & char('>')).optional())
            .optional() &
        char('{') &
        (cqlExpressionLexer() & (char(',') & cqlExpressionLexer()).star())
            .optional() &
        char('}');

final displayClauseLexer = string('display') & stringLexer;

final codeSelectorLexer = string('Code') &
    stringLexer &
    string('from') &
    codesystemIdentifierLexer &
    displayClauseLexer.optional();

final conceptSelectorLexer = string('Concept') &
    char('{') &
    codeSelectorLexer &
    (char(',') & codeSelectorLexer).star() &
    char('}') &
    displayClauseLexer.optional();

final paramListLexer =
    fhirPathLexer() & (char(',') & fhirPathLexer()).optional();
