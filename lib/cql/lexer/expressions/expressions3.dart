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
