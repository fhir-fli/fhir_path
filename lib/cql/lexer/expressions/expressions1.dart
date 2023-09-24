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
