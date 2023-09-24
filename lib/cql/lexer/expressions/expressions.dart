import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

import '../../../fhir_path.dart';

part 'expressions1.dart';
part 'expressions2.dart';
part 'expressions3.dart';

final querySourceLexer = retrieveLexer |
    qualifiedIdentifierExpressionLexer |
    (char('(') & expressionLexer & char(')'));

final aliasedQuerySourceLexer = querySourceLexer & aliasLexer;

final aliasLexer = cqlIdentifierLexer;

final queryInclusionClauseLexer = withClauseLexer | withoutClauseLexer;

final withClauseLexer = string('with') &
    aliasedQuerySourceLexer &
    string('such that') &
    expressionLexer;

final withoutClauseLexer = string('without') &
    aliasedQuerySourceLexer &
    string('such that') &
    expressionLexer;

final retrieveLexer = char('[') &
    (contextIdentifierLexer & string('->')).optional() &
    namedTypeSpecifierLexer &
    (char(':') &
            (codePathLexer & codeComparatorLexer).optional() &
            terminologyLexer)
        .optional() &
    char(']');

final contextIdentifierLexer = qualifiedIdentifierExpressionLexer;

final codePathLexer = simplePathLexer;

final codeComparatorLexer = string('in') | char('=') | char('~');

final terminologyLexer = qualifiedIdentifierExpressionLexer | expressionLexer;

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

final letClauseItemLexer = cqlIdentifierLexer & char(':') & expressionLexer;

final whereClauseLexer = string('where') & expressionLexer;

final returnClauseLexer = string('return') &
    (string('all') | string('distinct')).optional() &
    expressionLexer;

final aggregateClauseLexer = string('aggregate') &
    (string('all') | string('distinct')).optional() &
    cqlIdentifierLexer &
    startingClauseLexer.optional() &
    char(':') &
    expressionLexer;

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

final sortByItemLexer = expressionLexer & sortDirectionLexer.optional();

final qualifiedIdentifierLexer =
    (cqlIdentifierLexer & char('.')).star() & cqlIdentifierLexer;

final qualifiedIdentifierExpressionLexer =
    (qualifierExpressionLexer & char('.')).star() & referentialIdentifierLexer;

final qualifierExpressionLexer = referentialIdentifierLexer;

final simplePathLexer = referentialIdentifierLexer |
    (simplePathLexer & char('.') & referentialIdentifierLexer) |
    (simplePathLexer & char('[') & simpleLiteralLexer & char(']'));

final simpleLiteralLexer = stringLexer | numberLexer;

part of 'expressions.dart';

final expressionLexer = expressionTermLexer |
    retrieveLexer |
    queryLexer |
    (expressionLexer &
        string('is') &
        string('not').optional() &
        (string('null') | string('true') | string('false'))) |
    (expressionLexer & (string('is') | string('as')) & typeSpecifierLexer) |
    (string('cast') & expressionLexer & string('as') & typeSpecifierLexer) |
    (string('not') & expressionLexer) |
    (string('exists') & expressionLexer) |
    (expressionLexer &
        string('properly').optional() &
        string('between') &
        expressionTermLexer &
        string('and') &
        expressionTermLexer) |
    ((string('duration') & string('in')).optional() &
        pluralDateTimePrecisionLexer &
        string('between') &
        expressionTermLexer &
        string('and') &
        expressionTermLexer &
        durationBetweenExpressionLexer) |
    (string('difference') &
        string('in') &
        pluralDateTimePrecisionLexer &
        string('between') &
        expressionTermLexer &
        string('and') &
        expressionTermLexer &
        durationBetweenExpressionLexer) |
    (expressionLexer &
        (string('<=') | char('<') | char('>') | string('>=')) &
        expressionLexer) |
    (expressionLexer & intervalOperatorPhrase & expressionLexer) |
    (expressionLexer &
        (char('=') | string('!=') | char('~') | string('!~')) &
        expressionLexer) |
    (expressionLexer &
        (string('in') | string('contains')) &
        dateTimePrecisionSpecifierLexer.optional() &
        expressionLexer) |
    (expressionLexer & string('and') & expressionLexer) |
    (expressionLexer & (string('or') | string('xor')) & expressionLexer) |
    (expressionLexer & string('implies') & expressionLexer) |
    (expressionLexer &
        (char('|') | string('union') | string('intersect') | string('except')) &
        expressionLexer);

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

part of 'expressions.dart';

final expressionTermLexer = termLexer |
    (expressionTermLexer & char('.') & qualifiedLexer) |
    (expressionTermLexer & char('[') & expressionLexer & char(']')) |
    (string('convert') &
        expressionLexer &
        string('to') &
        (typeSpecifierLexer | unitLexer)) |
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
        expressionLexer &
        string('then') &
        expressionLexer &
        string('else') &
        expressionLexer) |
    (string('case') &
        expressionLexer.optional() &
        caseExpressionItemLexer.plus() &
        string('else') &
        expressionLexer &
        string('end')) |
    ((string('distinct') | string('flatten')) & expressionLexer) |
    ((string('expand') | string('collapse')) &
        expressionLexer &
        (string('per') & (dateTimePrecisionLexer | expressionLexer))
            .optional());

final caseExpressionItemLexer =
    string('when') & expressionLexer & string('then') & expressionLexer;

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

part of 'expressions.dart';

final termLexer = invocationLexer |
    literalLexer |
    externalConstantLexer |
    intervalSelectorLexer |
    tupleSelectorLexer |
    instanceSelectorLexer |
    listSelectorLexer |
    codeSelectorLexer |
    conceptSelectorLexer |
    (char('(') & expressionLexer & char(')'));

final qualifiedInvocationLexer =
    referentialIdentifierLexer | qualitifedFunctionLexer;

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
    expressionLexer &
    char(',') &
    expressionLexer &
    (char(']') | char(')'));

final tupleSelectorLexer = string('Tuple').optional() &
    char('{') &
    (char(':') |
        (tupleElementSelectorLexer &
            (char(',') & tupleElementSelectorLexer).star())) &
    char('}');

final tupleElementSelectorLexer =
    referentialIdentifierLexer & char(':') & expressionLexer;

final instanceSelectorLexer = namedTypeSpecifierLexer &
    char('{') &
    (char(':') |
        (instanceElementSelectorLexer &
            (char(',') & instanceElementSelectorLexer).star())) &
    char('}');

final instanceElementSelectorLexer =
    referentialIdentifierLexer & char(':') & expressionLexer;

final listSelectorLexer =
    (string('List') & (char('<') & typeSpecifierLexer & char('>')).optional())
            .optional() &
        char('{') &
        (expressionLexer & (char(',') & expressionLexer).star()).optional() &
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
