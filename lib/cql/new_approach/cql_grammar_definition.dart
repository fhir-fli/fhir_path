import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';

Parser cqlLexer = (ignored &
        libraryDefinition.optional() &
        (whiteSpacePlus & definition).star() &
        (whiteSpacePlus & statement).star() &
        ignored)
    .end();

Parser ignored =
    (whiteSpaceLexer | lineCommentLexer | multiLineCommentLexer).star();

Parser whiteSpacePlus = whiteSpaceLexer & ignored;

Parser definition = usingDefinition |
    includeDefinition |
    codesystemDefinition |
    valuesetDefinition |
    codeDefinition |
    conceptDefinition |
    parameterDefinition;

///
/// Definitions
///

Parser libraryDefinition = string('library') &
    whiteSpacePlus &
    qualifiedIdentifier &
    (whiteSpacePlus & string('version') & whiteSpacePlus & versionSpecifier)
        .optional();

Parser usingDefinition = string('using') &
    whiteSpacePlus &
    modelIdentifier &
    (whiteSpacePlus & string('version') & whiteSpacePlus & versionSpecifier)
        .optional();

Parser includeDefinition = string('include') &
    whiteSpacePlus &
    qualifiedIdentifier &
    (whiteSpacePlus & string('version') & whiteSpacePlus & versionSpecifier)
        .optional() &
    (whiteSpacePlus & string('called') & whiteSpacePlus & localIdentifier)
        .optional();

Parser localIdentifier = identifier;

Parser accessModifier = string('public') | string('private');

Parser parameterDefinition = (accessModifier & whiteSpacePlus).optional() &
    string('parameter') &
    whiteSpacePlus &
    identifier &
    (whiteSpacePlus & typeSpecifier()).optional() &
    (whiteSpacePlus & string('default') & whiteSpacePlus
        //  &
        // expression()
        )
        .optional();

Parser codesystemDefinition = (accessModifier & whiteSpacePlus).optional() &
    string('codesystem') &
    whiteSpacePlus &
    identifier &
    whiteSpacePlus.optional() &
    char(':') &
    whiteSpacePlus.optional() &
    codesystemId &
    (whiteSpacePlus & string('version') & whiteSpacePlus & versionSpecifier)
        .optional();

Parser valuesetDefinition = (accessModifier & whiteSpacePlus).optional() &
    string('valueset') &
    whiteSpacePlus &
    identifier &
    whiteSpacePlus.optional() &
    char(':') &
    whiteSpacePlus.optional() &
    valuesetId &
    (whiteSpacePlus & string('version') & whiteSpacePlus & versionSpecifier)
        .optional() &
    (whiteSpacePlus & codesystems).optional();

Parser codesystems = string('codesystems') &
    whiteSpacePlus.optional() &
    char('{') &
    whiteSpacePlus.optional() &
    codesystemIdentifier &
    (ignored & char(',') & ignored & codesystemIdentifier).star() &
    ignored &
    char('}');

Parser codesystemIdentifier =
    (libraryIdentifier & char('.')).optional() & identifier;

Parser libraryIdentifier = identifier;

Parser codeDefinition = (accessModifier & whiteSpacePlus).optional() &
    string('code') &
    whiteSpacePlus &
    identifier &
    ignored &
    char(':') &
    ignored &
    codeId &
    whiteSpacePlus &
    string('from') &
    whiteSpacePlus &
    codesystemIdentifier &
    (whiteSpacePlus & displayClause).optional();

Parser conceptDefinition = (accessModifier & whiteSpacePlus).optional() &
    string('concept') &
    whiteSpacePlus &
    identifier &
    ignored &
    char(':') &
    ignored &
    char('{') &
    ignored &
    codeIdentifier &
    (ignored & char(',') & ignored & codeIdentifier).star() &
    whiteSpacePlus &
    char('}') &
    (ignored & displayClause).optional();

Parser codeIdentifier = (libraryIdentifier & char('.')).optional() & identifier;

Parser codesystemId = stringLexer;

Parser valuesetId = stringLexer;

Parser versionSpecifier = stringLexer;

Parser codeId = stringLexer;

///
/// Type Specifiers
///

Parser typeSpecifier([Parser? notParser]) =>
    intervalTypeSpecifier |
    (notParser == null
        ? namedTypeSpecifier
        : notParser.not().seq(namedTypeSpecifier))

    // listTypeSpecifier |

    //  |
    // tupleTypeSpecifier |
    // choiceTypeSpecifier
    ;

Parser namedTypeSpecifier =
    (qualifier & char('.')).star() & referentialOrTypeNameIdentifier;

Parser modelIdentifier = identifier;

// listTypeSpecifier: 'List' '<' typeSpecifier '>';

Parser intervalTypeSpecifier =
    string('Interval') & char('<') & typeSpecifier() & char('>');

// tupleTypeSpecifier:
// 	'Tuple' '{' tupleElementDefinition (
// 		',' tupleElementDefinition
// 	)* '}';

// tupleElementDefinition: referentialIdentifier typeSpecifier;

// choiceTypeSpecifier:
// 	'Choice' '<' typeSpecifier (',' typeSpecifier)* '>';

///
/// Statements
///

Parser statement =
    // expressionDefinition |
    contextDefinition
    // |
    // functionDefinition
    ;

// expressionDefinition:
// 	'define' accessModifier? identifier ':' expression;

Parser contextDefinition = string('context') &
    whiteSpacePlus &
    (modelIdentifier & char('.')).optional() &
    identifier;

// functionDefinition:
// 	'define' accessModifier? 'fluent'? 'function' identifierOrFunctionIdentifier '(' (
// 		operandDefinition (',' operandDefinition)*
// 	)? ')' ('returns' typeSpecifier)? ':' (
// 		functionBody
// 		| 'external'
// 	);

// operandDefinition: referentialIdentifier typeSpecifier;

// functionBody: expression;

///
/// Expressions
///

Parser querySource = retrieve;
// querySource:
// 	retrieve
// 	| qualifiedIdentifierExpression
// 	| '(' expression ')';

Parser aliasedQuerySource = querySource & whiteSpacePlus & alias;

Parser alias = identifier;

Parser queryInclusionClause = withClause | withoutClause;

Parser withClause = string('with') &
        whiteSpacePlus &
        aliasedQuerySource &
        whiteSpacePlus &
        string('such that') &
        whiteSpacePlus
    // &
    // expression
    ;

Parser withoutClause = string('without') &
        whiteSpacePlus &
        aliasedQuerySource &
        whiteSpacePlus &
        string('such that') &
        whiteSpacePlus
    // &
    // expression
    ;

Parser retrieve = char('[') &
    ignored &
    (contextIdentifier) &
    whiteSpacePlus &
    string('->').optional() &
    namedTypeSpecifier &
    (ignored &
            char(':') &
            ignored &
            (codePath & whiteSpacePlus & codeComparator & whiteSpacePlus)
                .optional() &
            terminology)
        .optional() &
    ignored &
    char(']');

Parser contextIdentifier = qualifiedIdentifierExpression;

Parser codePath = simplePath;

Parser codeComparator = string('in') | char('=') | char('~');

Parser terminology = qualifiedIdentifierExpression
    // |
    // expression
    ;

Parser qualifier = identifier;

Parser sourceClause = (string('from') & whiteSpacePlus).optional() &
    aliasedQuerySource &
    (ignored & char(',') & ignored & aliasedQuerySource).star();

Parser letClause = string('let') &
    whiteSpacePlus &
    letClauseItem &
    (ignored & char(',') & ignored & letClauseItem).star();

Parser letClauseItem = identifier & ignored & char(':') & ignored
    // &
    // expression
    ;

Parser whereClause = string('where') & whiteSpacePlus
    // & expression
    ;

Parser returnClause = string('return') &
        whiteSpacePlus &
        ((string('all') | string('distinct')) & whiteSpacePlus).optional()

    // & expression
    ;

Parser aggregateClause = string('aggregate') &
        whiteSpacePlus &
        ((string('all') | string('distinct')) & whiteSpacePlus).optional() &
        identifier &
        (whiteSpacePlus & startingClause).optional() &
        ignored &
        char(':') &
        ignored
    // & expression
    ;

Parser startingClause = string('starting') &
    whiteSpacePlus &
    (simpleLiteral |
        quantityLexer |
        (char('(') &
            ignored &
            // expression &
            ignored &
            char(')')));

Parser sortClause = string('sort') &
    whiteSpacePlus &
    (sortDirection |
        (string('by') &
            whiteSpacePlus &
            sortByItem &
            (ignored & char(',') & ignored & sortByItem).star()));

Parser sortDirection =
    string('ascending') | string('asc') | string('descending') | string('desc');

Parser sortByItem =
    // expressionTerm &
    (whiteSpacePlus & sortDirection).optional();

Parser qualifiedIdentifier = (qualifier & char('.')).star() & identifier;

Parser qualifiedIdentifierExpression =
    (qualifierExpression & char('.')).star() & referentialIdentifier;

Parser qualifierExpression = referentialIdentifier;

Parser simplePath =

    /// simplePathReferentialIdentifier
    referentialIdentifier |

        /// simplePathQualifiedIdentifier
        (simplePath & char('.') & referentialIdentifier) |

        /// simplePathIndexer
        (simplePath &
            ignored &
            char('[') &
            ignored &
            simpleLiteral &
            ignored &
            char(']'));

Parser simpleLiteral =

    /// simpleStringLiteral
    stringLexer |

        ///  simpleNumberLiteral
        numberLexer;

//   Parser expression() {
//     final SettableParser _expression = undefined();
//     final SettableParser _expressionTerm = undefined();
//     final SettableParser _query = undefined();
//     final SettableParser _caseExpressionItem = undefined();
//     final SettableParser _term = undefined();
//     final SettableParser _intervalSelector = undefined();

//     /// termExpression
//     final Parser _expressionPart = _expressionTerm |
// // 	| retrieve																					# retrieveExpression

//             /// queryExpression
//             _query

// // 	| expression 'is' 'not'? ('null' | 'true' | 'false')										# booleanExpression
// // 	| expression ('is' | 'as') typeSpecifier													# typeExpression
// // 	| 'cast' expression 'as' typeSpecifier														# castExpression
// // 	| 'not' expression																			# notExpression
// // 	| 'exists' expression																		# existenceExpression
// // 	| expression 'properly'? 'between' expressionTerm 'and' expressionTerm						# betweenExpression
// // 	| ('duration' 'in')? pluralDateTimePrecision 'between' expressionTerm 'and' expressionTerm	#
// // 		durationBetweenExpression
// // 	| 'difference' 'in' pluralDateTimePrecision 'between' expressionTerm 'and' expressionTerm #
// // 		differenceBetweenExpression
// // 	| expression ('<=' | '<' | '>' | '>=') expression						# inequalityExpression
// // 	| expression intervalOperatorPhrase expression							# timingExpression
// // 	| expression ('=' | '!=' | '~' | '!~') expression						# equalityExpression
// // 	| expression ('in' | 'contains') dateTimePrecisionSpecifier? expression	# membershipExpression
// // 	| expression 'and' expression											# andExpression
// // 	| expression ('or' | 'xor') expression									# orExpression
// // 	| expression 'implies' expression										# impliesExpression
// // 	| expression ('|' | 'union' | 'intersect' | 'except') expression		# inFixSetExpression
//         ;

//     _expression.set(_expressionPart);

//     final Parser _expressionTermPart =

//         /// caseExpressionTerm
//         string('case').flatten().map((value) => print('Case:$value')) &
//                 whiteSpacePlus &
//                 (_expression & whiteSpacePlus)
//                     .optional()
//                     .flatten()
//                     .map((value) => print('Exp:$value')) &
//                 _caseExpressionItem.plus() &
//                 whiteSpacePlus &
//                 string('else') &
//                 whiteSpacePlus &
//                 _expression &
//                 whiteSpacePlus &
//                 string('end') |

//             /// termExpressionTerm
//             _term |
// // 	| expressionTerm '.' qualifiedInvocation							# invocationExpressionTerm
//             /// indexedExpressionTerm
//             (_expressionTerm &
//                 ignored &
//                 char('[') &
//                 ignored &
//                 _expression &
//                 ignored &
//                 char(']'))
// // 	| 'convert' expression 'to' (typeSpecifier | unit)					# conversionExpressionTerm
// // 	| ('+' | '-') expressionTerm										# polarityExpressionTerm
// // 	| ('start' | 'end') 'of' expressionTerm								# timeBoundaryExpressionTerm
// // 	| dateTimeComponent 'from' expressionTerm							# timeUnitExpressionTerm
// // 	| 'duration' 'in' pluralDateTimePrecision 'of' expressionTerm		# durationExpressionTerm
// // 	| 'difference' 'in' pluralDateTimePrecision 'of' expressionTerm		# differenceExpressionTerm
// // 	| 'width' 'of' expressionTerm										# widthExpressionTerm
// // 	| 'successor' 'of' expressionTerm									# successorExpressionTerm
// // 	| 'predecessor' 'of' expressionTerm									# predecessorExpressionTerm
// // 	| 'singleton' 'from' expressionTerm									# elementExtractorExpressionTerm
// // 	| 'point' 'from' expressionTerm										# pointExtractorExpressionTerm
// // 	| ('minimum' | 'maximum') namedTypeSpecifier						# typeExtentExpressionTerm
// // 	| expressionTerm '^' expressionTerm									# powerExpressionTerm
// // 	| expressionTerm ('*' | '/' | 'div' | 'mod') expressionTerm			# multiplicationExpressionTerm
// // 	| expressionTerm ('+' | '-' | '&') expressionTerm					# additionExpressionTerm
// // 	| 'if' expression 'then' expression 'else' expression				# ifThenElseExpressionTerm
// // 	| ('distinct' | 'flatten') expression								# aggregateExpressionTerm
// // 	| ('expand' | 'collapse') expression (
// // 		'per' (dateTimePrecision | expression)
// // 	)? # setAggregateExpressionTerm
//         ;
//     _expressionTerm.set(_expressionTermPart);

//     final Parser _queryPart = sourceClause &
//         whiteSpacePlus &
//         (letClause) & ref0(whiteSpacePlus)).optional() &
//         (queryInclusionClause) & ref0(whiteSpacePlus)).star( &
//         (whereClause) & ref0(whiteSpacePlus)).optional() &
//         ((aggregateClause) | ref0(returnClause)) & ref0(whiteSpacePlus)
//             .optional() &
//         sortClause).optional();

//     _query.set(_queryPart);

//     final Parser _caseExpressionItemPart = string('when') &
//         whiteSpacePlus &
//         _expression &
//         whiteSpacePlus &
//         string('then') &
//         whiteSpacePlus &
//         _expression;

//     _caseExpressionItem.set(_caseExpressionItemPart);

//     final Parser _termPart =
// // 	invocation				# invocationTerm
// // 	| literal				# literalTerm
// // 	| externalConstant		# externalConstantTerm
//         /// intervalSelectorTerm
//         _intervalSelector
// // 	| tupleSelector			# tupleSelectorTerm
// // 	| instanceSelector		# instanceSelectorTerm
// // 	| listSelector			# listSelectorTerm
// // 	| codeSelector			# codeSelectorTerm
// // 	| conceptSelector		# conceptSelectorTerm
// // 	| '(' expression ')'	# parenthesizedTerm
//         ;

//     _term.set(_termPart);

//     Parser internalInterval(String end) =>
//         whiteSpacePlus).optional() &
//         char(',').neg().star() &
//         // expression &
//         whiteSpacePlus).optional() &
//         char(',') &
//         whiteSpacePlus).optional() &
//         // expression &
//         (char(end)).neg().star() &
//         whiteSpacePlus).optional();

//     // TODO: Consider this as an alternative syntax for intervals... (would need to be moved up to
//     // expression to make it work) expression ( '..' | '*.' | '.*' | '**' ) expression;

//     Parser _intervalSelectorPart = string('Interval') &
//         whiteSpacePlus).optional() &
//         ((char('[') & ref1(internalInterval, ']') & char(']')) |
//             (char('(') &
//                 ref1(internalInterval, ')') &
//                 char(')')));

//     _intervalSelector.set(_intervalSelectorPart);

//     return _expression;

// dateTimePrecision:
// 	'year'
// 	| 'month'
// 	| 'week'
// 	| 'day'
// 	| 'hour'
// 	| 'minute'
// 	| 'second'
// 	| 'millisecond';

// dateTimeComponent:
// 	dateTimePrecision
// 	| 'date'
// 	| 'time'
// 	| 'timezoneoffset';

// pluralDateTimePrecision:
// 	'years'
// 	| 'months'
// 	| 'weeks'
// 	| 'days'
// 	| 'hours'
// 	| 'minutes'
// 	| 'seconds'
// 	| 'milliseconds';

// dateTimePrecisionSpecifier: dateTimePrecision 'of';

// relativeQualifier: 'or before' | 'or after';

// offsetRelativeQualifier: 'or more' | 'or less';

// exclusiveRelativeQualifier: 'less than' | 'more than';

// quantityOffset: (quantity offsetRelativeQualifier?)
// 	| (exclusiveRelativeQualifier quantity);

// temporalRelationship: ('on or'? ('before' | 'after'))
// 	| (('before' | 'after') 'or on'?);

// intervalOperatorPhrase: ('starts' | 'ends' | 'occurs')? 'same' dateTimePrecision? (
// 		relativeQualifier
// 		| 'as'
// 	) ('start' | 'end')? # concurrentWithIntervalOperatorPhrase
// 	| 'properly'? 'includes' dateTimePrecisionSpecifier? (
// 		'start'
// 		| 'end'
// 	)? # includesIntervalOperatorPhrase
// 	| ('starts' | 'ends' | 'occurs')? 'properly'? (
// 		'during'
// 		| 'included in'
// 	) dateTimePrecisionSpecifier? # includedInIntervalOperatorPhrase
// 	| ('starts' | 'ends' | 'occurs')? quantityOffset? temporalRelationship
// 		dateTimePrecisionSpecifier? ('start' | 'end')? # beforeOrAfterIntervalOperatorPhrase
// 	| ('starts' | 'ends' | 'occurs')? 'properly'? 'within' quantity 'of' (
// 		'start'
// 		| 'end'
// 	)?																# withinIntervalOperatorPhrase
// 	| 'meets' ('before' | 'after')? dateTimePrecisionSpecifier?		# meetsIntervalOperatorPhrase
// 	| 'overlaps' ('before' | 'after')? dateTimePrecisionSpecifier?	# overlapsIntervalOperatorPhrase
// 	| 'starts' dateTimePrecisionSpecifier?							# startsIntervalOperatorPhrase
// 	| 'ends' dateTimePrecisionSpecifier?							# endsIntervalOperatorPhrase;

// qualifiedInvocation: // Terms that can be used after the function/member invocation '.'
// 	referentialIdentifier	# qualifiedMemberInvocation
// 	| qualifiedFunction		# qualifiedFunctionInvocation;

// qualifiedFunction:
// 	identifierOrFunctionIdentifier '(' paramList? ')';

// invocation:
// 	referentialIdentifier	# memberInvocation
// 	| function				# functionInvocation
// 	| '$this'				# thisInvocation
// 	| '$index'				# indexInvocation
// 	| '$total'				# totalInvocation;

// function: referentialIdentifier '(' paramList? ')';

// ratio: quantity ':' quantity;

// literal: ('true' | 'false')	# booleanLiteral
// 	| 'null'				# nullLiteral
// 	| STRING				# stringLiteral
// 	| NUMBER				# numberLiteral
// 	| LONGNUMBER			# longNumberLiteral
// 	| DATETIME				# dateTimeLiteral
// 	| DATE					# dateLiteral
// 	| TIME					# timeLiteral
// 	| quantity				# quantityLiteral
// 	| ratio					# ratioLiteral;

// tupleSelector:
// 	'Tuple'? '{' (
// 		':'
// 		| (tupleElementSelector (',' tupleElementSelector)*)
// 	) '}';

// tupleElementSelector: referentialIdentifier ':' expression;

// instanceSelector:
// 	namedTypeSpecifier '{' (
// 		':'
// 		| (
// 			instanceElementSelector (',' instanceElementSelector)*
// 		)
// 	) '}';

// instanceElementSelector: referentialIdentifier ':' expression;

// listSelector: ('List' ('<' typeSpecifier '>')?)? '{' (
// 		expression (',' expression)*
// 	)? '}';

Parser displayClause = string('display') & whiteSpacePlus & stringLexer;

// codeSelector:
// 	'Code' STRING 'from' codesystemIdentifier displayClause?;

// conceptSelector:
// 	'Concept' '{' codeSelector (',' codeSelector)* '}' displayClause?;

Parser keyword = string('after') |
    string('aggregate') |
    string('all') |
    string('and') |
    string('as') |
    string('asc') |
    string('ascending') |
    string('before') |
    string('between') |
    string('by') |
    string('called') |
    string('case') |
    string('cast') |
    string('code') |
    string('Code') |
    string('codesystem') |
    string('codesystems') |
    string('collapse') |
    string('concept') |
    string('Concept') |
    string('contains') |
    string('context') |
    string('convert') |
    string('date') |
    string('day') |
    string('days') |
    string('default') |
    string('define') |
    string('desc') |
    string('descending') |
    string('difference') |
    string('display') |
    string('distinct') |
    string('div') |
    string('duration') |
    string('during') |
    string('else') |
    string('end') |
    string('ends') |
    string('except') |
    string('exists') |
    string('expand') |
    string('false') |
    string('flatten') |
    string('fluent') |
    string('from') |
    string('function') |
    string('hour') |
    string('hours') |
    string('if') |
    string('implies') |
    string('in') |
    string('include') |
    string('includes') |
    string('included in') |
    string('intersect') |
    string('Interval') |
    string('is') |
    string('let') |
    string('library') |
    string('List') |
    string('maximum') |
    string('meets') |
    string('millisecond') |
    string('milliseconds') |
    string('minimum') |
    string('minute') |
    string('minutes') |
    string('mod') |
    string('month') |
    string('months') |
    string('not') |
    string('null') |
    string('occurs') |
    string('of') |
    string('on or') |
    string('or') |
    string('or after') |
    string('or before') |
    string('or less') |
    string('or more') |
    string('or on') |
    string('overlaps') |
    string('parameter') |
    string('per') |
    string('point') |
    string('predecessor') |
    string('private') |
    string('properly') |
    string('public') |
    string('return') |
    string('same') |
    string('second') |
    string('seconds') |
    string('singleton') |
    string('start') |
    string('starting') |
    string('starts') |
    string('sort') |
    string('successor') |
    string('such that') |
    string('then') |
    string('time') |
    string('timezoneoffset') |
    string('to') |
    string('true') |
    string('Tuple') |
    string('union') |
    string('using') |
    string('valueset') |
    string('version') |
    string('week') |
    string('weeks') |
    string('where') |
    string('when') |
    string('width') |
    string('with') |
    string('within') |
    string('without') |
    string('xor') |
    string('year') |
    string('years');

// NOTE: Not used, this is the set of reserved words that may not appear as identifiers in ambiguous contexts
Parser reservedWord = string('aggregate') |
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
    string('years');

/// Keyword identifiers are keywords that may be used as identifiers in a referential context
/// Effectively, keyword except reservedWord
Parser keywordIdentifier = string('asc') |
    string('ascending') |
    string('by') |
    string('called') |
    string('code') |
    string('codesystem') |
    string('codesystems') |
    string('concept') |
    string('contains') |
    string('context') |
    string('date') |
    string('default') |
    string('define') |
    string('desc') |
    string('descending') |
    string('display') |
    string('div') |
    string('end') |
    string('ends') |
    string('except') |
    string('fluent') |
    string('function') |
    string('implies') |
    string('include') |
    string('includes') |
    string('intersect') |
    string('library') |
    string('meets') |
    string('mod') |
    string('or after') |
    string('or before') |
    string('or less') |
    string('or more') |
    string('overlaps') |
    string('parameter') |
    string('predecessor') |
    string('private') |
    string('public') |
    string('start') |
    string('starting') |
    string('starts') |
    string('successor') |
    string('time') |
    string('timezoneoffset') |
    string('union') |
    string('using') |
    string('valueset') |
    string('version') |
    string('where') |
    string('width') |
    string('xor');

/// Obsolete identifiers are keywords that could be used as identifiers in CQL 1.3 NOTE: Not
/// currently used, this is the set of keywords that were defined as allowed identifiers as part of
/// 1.3 NOTE: Several keywords were commented out in this list (notably exists) because of an issue
/// with the ANTLR tooling. In 4.5, having these keywords as identifiers results in unacceptable
/// parsing performance. In 4.6+, having them as identifiers resulted in incorrect parsing. See
/// Github issue [#343](https://github.com/cqframework/clinical_quality_language/issues/343) for more
/// detail This should no longer be an issue with 1.4 due to the introduction of reserved words
Parser obsoleteIdentifier = string('all') |
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
    string('where');

// Function identifiers are keywords that may be used as identifiers for functions
Parser functionIdentifier = string('after') |
    string('aggregate') |
    string('all') |
    string('and') |
    string('as') |
    string('asc') |
    string('ascending') |
    string('before') |
    string('between') |
    string('by') |
    string('called') |
    string('case') |
    string('cast') |
    string('code') |
    string('Code') |
    string('codesystem') |
    string('codesystems') |
    string('collapse') |
    string('concept') |
    string('Concept') |
    string('contains') |
    string('context') |
    string('convert') |
    string('date') |
    string('day') |
    string('days') |
    string('default') |
    string('define') |
    string('desc') |
    string('descending') |
    string('difference') |
    string('display') |
    string('distinct') |
    string('div') |
    string('duration') |
    string('during') |
    string('else') |
    string('end') |
    string('ends') |
    string('except') |
    string('exists') |
    string('expand') |
    string('false') |
    string('flatten') |
    string('fluent') |
    string('from') |
    string('function') |
    string('hour') |
    string('hours') |
    string('if') |
    string('implies') |
    string('in') |
    string('include') |
    string('includes') |
    string('included in') |
    string('intersect') |
    string('Interval') |
    string('is') |
    string('let') |
    string('library') |
    string('List') |
    string('maximum') |
    string('meets') |
    string('millisecond') |
    string('milliseconds') |
    string('minimum') |
    string('minute') |
    string('minutes') |
    string('mod') |
    string('month') |
    string('months') |
    string('not') |
    string('null') |
    string('occurs') |
    string('of') |
    string('or') |
    string('or after') |
    string('or before') |
    string('or less') |
    string('or more') |
    string('overlaps') |
    string('parameter') |
    string('per') |
    string('point') |
    string('predecessor') |
    string('private') |
    string('properly') |
    string('public') |
    string('return') |
    string('same') |
    string('singleton') |
    string('second') |
    string('seconds') |
    string('start') |
    string('starting') |
    string('starts') |
    string('sort') |
    string('successor') |
    string('such that') |
    string('then') |
    string('time') |
    string('timezoneoffset') |
    string('to') |
    string('true') |
    string('Tuple') |
    string('union') |
    string('using') |
    string('valueset') |
    string('version') |
    string('week') |
    string('weeks') |
    string('where') |
    string('when') |
    string('width') |
    string('with') |
    string('within') |
    string('without') |
    string('xor') |
    string('year') |
    string('years');

/// Reserved words that are also type names
Parser typeNameIdentifier =
    string('Code') | string('Concept') | string('date') | string('time');

Parser referentialIdentifier = identifier | keywordIdentifier;

// referentialIdentifier: identifier | keywordIdentifier;

Parser referentialOrTypeNameIdentifier =
    referentialIdentifier | typeNameIdentifier;

// identifierOrFunctionIdentifier: identifier | functionIdentifier;

Parser identifier =
    identifierLexer | delimitedIdentifierLexer | quotedIdentifier;

Parser quotedIdentifier =
    char('"') & (escLexer | char('"').neg()).star() & char('"');

// DATETIME: '@' DATEFORMAT 'T' TIMEFORMAT? TIMEZONEOFFSETFORMAT?;

// LONGNUMBER: [0-9]+ 'L';

// fragment ESC:
// 	'\\' ([`'"\\/fnrt] | UNICODE); // allow \`, \', \", \\, \/, \f, etc. and \uXXX

