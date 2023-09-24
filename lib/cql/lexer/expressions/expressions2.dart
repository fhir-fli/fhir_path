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
