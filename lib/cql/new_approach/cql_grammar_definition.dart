import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';

class CqlGrammarDefinition extends GrammarDefinition {
  Result<dynamic> parse(String input) =>
      CqlGrammarDefinition().build().parse(input);

  Parser token(Object input) {
    if (input is Parser) {
      return input.token();
    } else if (input is String) {
      return token(input.toParser());
    }
    throw ArgumentError.value(input, 'Invalid token parser');
  }

  Parser ignored() =>
      (whiteSpaceLexer | lineCommentLexer | multiLineCommentLexer).star();

  Parser whiteSpacePlus() => whiteSpaceLexer & ref0(ignored);

  Parser surroundingWhiteSpace(String inBetween) =>
      whiteSpaceLexer & ref1(token, inBetween) & whiteSpaceLexer;

  @override
  Parser start() => ref0(library).end();

  Parser library() =>
      ref0(ignored) &
      ref0(libraryDefinition).optional() &
      (ref0(ignored) & ref0(definition)).star() &
      (whiteSpaceLexer & ref0(ignored) & ref0(statement)).star() &
      ref0(ignored);

  Parser definition() =>
      ref0(usingDefinition) |
      ref0(includeDefinition) |
      ref0(codesystemDefinition) |
      ref0(valuesetDefinition) |
      ref0(codeDefinition) |
      ref0(conceptDefinition) |
      ref0(parameterDefinition);

  ///
  /// Definitions
  ///

  Parser libraryDefinition() =>
      ref1(token, 'library') &
      ref0(whiteSpacePlus) &
      ref0(qualifiedIdentifier) &
      (ref0(whiteSpacePlus) &
              ref1(token, 'version') &
              ref0(whiteSpacePlus) &
              ref0(versionSpecifier))
          .optional();

  Parser usingDefinition() =>
      ref1(token, 'using') &
      ref0(whiteSpacePlus) &
      ref0(modelIdentifier) &
      (ref0(whiteSpacePlus) &
              ref1(token, 'version') &
              ref0(whiteSpacePlus) &
              ref0(versionSpecifier))
          .optional();

  Parser includeDefinition() =>
      ref1(token, 'include') &
      ref0(whiteSpacePlus) &
      ref0(qualifiedIdentifier) &
      (ref0(whiteSpacePlus) &
              ref1(token, 'version') &
              ref0(whiteSpacePlus) &
              ref0(versionSpecifier))
          .optional() &
      (ref0(whiteSpacePlus) &
              ref1(token, 'called') &
              ref0(whiteSpacePlus) &
              ref0(localIdentifier))
          .optional();

  Parser localIdentifier() => ref0(identifier);

  Parser accessModifier() => ref1(token, 'public') | ref1(token, 'private');

  Parser parameterDefinition() =>
      (ref0(accessModifier) & ref0(whiteSpacePlus)).optional() &
      ref1(token, 'parameter') &
      ref0(whiteSpacePlus) &
      ref0(identifier) &
      (ref0(whiteSpacePlus) & ref1(typeSpecifier, ref1(token, 'default')))
          .optional() &
      (ref0(whiteSpacePlus) &
              ref1(token, 'default') &
              ref0(whiteSpacePlus) &
              ref0(expression))
          .optional();

  Parser codesystemDefinition() =>
      (ref0(accessModifier) & ref0(whiteSpacePlus)).optional() &
      ref1(token, 'codesystem') &
      ref0(whiteSpacePlus) &
      ref0(identifier) &
      ref0(whiteSpacePlus).optional() &
      ref1(token, ':') &
      ref0(whiteSpacePlus).optional() &
      ref0(codesystemId) &
      (ref0(whiteSpacePlus) &
              ref1(token, 'version') &
              ref0(whiteSpacePlus) &
              ref0(versionSpecifier))
          .optional();

  Parser valuesetDefinition() =>
      (ref0(accessModifier) & ref0(whiteSpacePlus)).optional() &
      ref1(token, 'valueset') &
      ref0(whiteSpacePlus) &
      ref0(identifier) &
      ref0(whiteSpacePlus).optional() &
      ref1(token, ':') &
      ref0(whiteSpacePlus).optional() &
      ref0(valuesetId) &
      (ref0(whiteSpacePlus) &
              ref1(token, 'version') &
              ref0(whiteSpacePlus) &
              ref0(versionSpecifier))
          .optional() &
      (ref0(whiteSpacePlus) & ref0(codesystems)).optional();

  Parser codesystems() =>
      ref1(token, 'codesystems') &
      ref0(whiteSpacePlus).optional() &
      ref1(token, '{') &
      ref0(whiteSpacePlus).optional() &
      ref0(codesystemIdentifier) &
      (ref0(whiteSpacePlus).optional() &
              ref1(token, ',') &
              ref0(whiteSpacePlus).optional() &
              ref0(codesystemIdentifier))
          .star() &
      ref0(whiteSpacePlus).optional() &
      ref1(token, '}');

  Parser codesystemIdentifier() =>
      (ref0(libraryIdentifier) & ref1(token, '.')).optional() &
      ref0(identifier);

  Parser libraryIdentifier() => ref0(identifier);

  Parser codeDefinition() =>
      (ref0(accessModifier) & ref0(whiteSpacePlus)).optional() &
      ref1(token, 'code') &
      ref0(whiteSpacePlus) &
      ref0(identifier) &
      ref0(whiteSpacePlus).optional() &
      ref1(token, ':') &
      ref0(whiteSpacePlus).optional() &
      ref0(codeId) &
      ref0(whiteSpacePlus) &
      ref1(token, 'from') &
      ref0(whiteSpacePlus) &
      ref0(codesystemIdentifier) &
      (ref0(whiteSpacePlus) & ref0(displayClause)).optional();

  Parser conceptDefinition() =>
      (ref0(accessModifier) & ref0(whiteSpacePlus)).optional() &
      ref1(token, 'concept') &
      ref0(whiteSpacePlus) &
      ref0(identifier) &
      ref0(whiteSpacePlus).optional() &
      ref1(token, ':') &
      ref0(whiteSpacePlus).optional() &
      ref1(token, '{') &
      ref0(whiteSpacePlus).optional() &
      ref0(codeIdentifier) &
      (ref0(whiteSpacePlus).optional() &
              ref1(token, ',') &
              ref0(whiteSpacePlus).optional() &
              ref0(codeIdentifier))
          .star() &
      ref0(whiteSpacePlus).optional() &
      ref1(token, '}') &
      (ref0(whiteSpacePlus).optional() & ref0(displayClause)).optional();

  Parser codeIdentifier() =>
      (ref0(libraryIdentifier) & ref1(token, '.')).optional() &
      ref0(identifier);

  Parser codesystemId() => stringLexer;

  Parser valuesetId() => stringLexer;

  Parser versionSpecifier() => stringLexer;

  Parser codeId() => stringLexer;

  ///
  /// Type Specifiers
  ///

  Parser typeSpecifier([Parser? notParser]) =>
      ref0(intervalTypeSpecifier) |
      (notParser == null
          ? ref0(namedTypeSpecifier)
          : notParser.not().seq(ref0(namedTypeSpecifier)))

      // ref0(listTypeSpecifier) |

      //  |
      // ref0(tupleTypeSpecifier) |
      // ref0(choiceTypeSpecifier)
      ;

  Parser namedTypeSpecifier() =>
      (ref0(qualifier) & ref1(token, '.')).star() &
      ref0(referentialOrTypeNameIdentifier);

  Parser modelIdentifier() => ref0(identifier);

// listTypeSpecifier: 'List' '<' typeSpecifier '>';

  Parser intervalTypeSpecifier() =>
      ref1(token, 'Interval') &
      ref1(token, '<') &
      ref0(typeSpecifier) &
      ref1(token, '>');

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

  Parser statement() =>
      // ref0(expressionDefinition) |
      ref0(contextDefinition)
      // |
      // ref0(functionDefinition)
      ;

// expressionDefinition:
// 	'define' accessModifier? identifier ':' expression;

  Parser contextDefinition() =>
      ref1(token, 'context') &
      ref0(whiteSpacePlus) &
      (ref0(modelIdentifier) & ref1(token, '.')).optional() &
      ref0(identifier);

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

// querySource:
// 	retrieve
// 	| qualifiedIdentifierExpression
// 	| '(' expression ')';

// aliasedQuerySource: querySource alias;

// alias: identifier;

// queryInclusionClause: withClause | withoutClause;

// withClause: 'with' aliasedQuerySource 'such that' expression;

// withoutClause:
// 	'without' aliasedQuerySource 'such that' expression;

// retrieve:
// 	'[' (contextIdentifier '->')? namedTypeSpecifier (
// 		':' (codePath codeComparator)? terminology
// 	)? ']';

// contextIdentifier: qualifiedIdentifierExpression;

// codePath: simplePath;

// codeComparator: 'in' | '=' | '~';

// terminology: qualifiedIdentifierExpression | expression;

  Parser qualifier() => ref0(identifier);

// query:
// 	sourceClause letClause? queryInclusionClause* whereClause? (
// 		aggregateClause
// 		| returnClause
// 	)? sortClause?;

// sourceClause:
// 	'from'? aliasedQuerySource (',' aliasedQuerySource)*;

// letClause: 'let' letClauseItem (',' letClauseItem)*;

// letClauseItem: identifier ':' expression;

// whereClause: 'where' expression;

// returnClause: 'return' ('all' | 'distinct')? expression;

// aggregateClause:
// 	'aggregate' ('all' | 'distinct')? identifier startingClause? ':' expression;

// startingClause:
// 	'starting' (simpleLiteral | quantity | ('(' expression ')'));

// sortClause:
// 	'sort' (sortDirection | ('by' sortByItem (',' sortByItem)*));

// sortDirection: 'asc' | 'ascending' | 'desc' | 'descending';

// sortByItem: expressionTerm sortDirection?;

  Parser qualifiedIdentifier() =>
      (ref0(qualifier) & ref1(token, '.')).star() & ref0(identifier);

// qualifiedIdentifierExpression: (qualifierExpression '.')* referentialIdentifier;

// qualifierExpression: referentialIdentifier;

// simplePath:
// 	referentialIdentifier					# simplePathReferentialIdentifier
// 	| simplePath '.' referentialIdentifier	# simplePathQualifiedIdentifier
// 	| simplePath '[' simpleLiteral ']'		# simplePathIndexer;

// simpleLiteral:
// 	STRING		# simpleStringLiteral
// 	| NUMBER	# simpleNumberLiteral;

  Parser expression() =>

      /// termExpression
      ref0(expressionTerm)
// 	| retrieve																					# retrieveExpression
// 	| query																						# queryExpression
// 	| expression 'is' 'not'? ('null' | 'true' | 'false')										# booleanExpression
// 	| expression ('is' | 'as') typeSpecifier													# typeExpression
// 	| 'cast' expression 'as' typeSpecifier														# castExpression
// 	| 'not' expression																			# notExpression
// 	| 'exists' expression																		# existenceExpression
// 	| expression 'properly'? 'between' expressionTerm 'and' expressionTerm						# betweenExpression
// 	| ('duration' 'in')? pluralDateTimePrecision 'between' expressionTerm 'and' expressionTerm	#
// 		durationBetweenExpression
// 	| 'difference' 'in' pluralDateTimePrecision 'between' expressionTerm 'and' expressionTerm #
// 		differenceBetweenExpression
// 	| expression ('<=' | '<' | '>' | '>=') expression						# inequalityExpression
// 	| expression intervalOperatorPhrase expression							# timingExpression
// 	| expression ('=' | '!=' | '~' | '!~') expression						# equalityExpression
// 	| expression ('in' | 'contains') dateTimePrecisionSpecifier? expression	# membershipExpression
// 	| expression 'and' expression											# andExpression
// 	| expression ('or' | 'xor') expression									# orExpression
// 	| expression 'implies' expression										# impliesExpression
// 	| expression ('|' | 'union' | 'intersect' | 'except') expression		# inFixSetExpression
      ;

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

  Parser expressionTerm() =>

      /// termExpressionTerm
      ref0(term)
// 	| expressionTerm '.' qualifiedInvocation							# invocationExpressionTerm
// 	| expressionTerm '[' expression ']'									# indexedExpressionTerm
// 	| 'convert' expression 'to' (typeSpecifier | unit)					# conversionExpressionTerm
// 	| ('+' | '-') expressionTerm										# polarityExpressionTerm
// 	| ('start' | 'end') 'of' expressionTerm								# timeBoundaryExpressionTerm
// 	| dateTimeComponent 'from' expressionTerm							# timeUnitExpressionTerm
// 	| 'duration' 'in' pluralDateTimePrecision 'of' expressionTerm		# durationExpressionTerm
// 	| 'difference' 'in' pluralDateTimePrecision 'of' expressionTerm		# differenceExpressionTerm
// 	| 'width' 'of' expressionTerm										# widthExpressionTerm
// 	| 'successor' 'of' expressionTerm									# successorExpressionTerm
// 	| 'predecessor' 'of' expressionTerm									# predecessorExpressionTerm
// 	| 'singleton' 'from' expressionTerm									# elementExtractorExpressionTerm
// 	| 'point' 'from' expressionTerm										# pointExtractorExpressionTerm
// 	| ('minimum' | 'maximum') namedTypeSpecifier						# typeExtentExpressionTerm
// 	| expressionTerm '^' expressionTerm									# powerExpressionTerm
// 	| expressionTerm ('*' | '/' | 'div' | 'mod') expressionTerm			# multiplicationExpressionTerm
// 	| expressionTerm ('+' | '-' | '&') expressionTerm					# additionExpressionTerm
// 	| 'if' expression 'then' expression 'else' expression				# ifThenElseExpressionTerm
// 	| 'case' expression? caseExpressionItem+ 'else' expression 'end'	# caseExpressionTerm
// 	| ('distinct' | 'flatten') expression								# aggregateExpressionTerm
// 	| ('expand' | 'collapse') expression (
// 		'per' (dateTimePrecision | expression)
// 	)? # setAggregateExpressionTerm
      ;

// caseExpressionItem: 'when' expression 'then' expression;

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

  Parser term() =>
// 	invocation				# invocationTerm
// 	| literal				# literalTerm
// 	| externalConstant		# externalConstantTerm
      /// intervalSelectorTerm
      ref0(intervalSelector)
// 	| tupleSelector			# tupleSelectorTerm
// 	| instanceSelector		# instanceSelectorTerm
// 	| listSelector			# listSelectorTerm
// 	| codeSelector			# codeSelectorTerm
// 	| conceptSelector		# conceptSelectorTerm
// 	| '(' expression ')'	# parenthesizedTerm
      ;

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

  // TODO: Consider this as an alternative syntax for intervals... (would need to be moved up to
  // expression to make it work) expression ( '..' | '*.' | '.*' | '**' ) expression;

  Parser intervalSelector() =>
      ref1(token, 'Interval') &
      ref0(whiteSpacePlus).optional() &
      ((ref1(token, '[') & ref1(internalInterval, ']') & ref1(token, ']')) |
          (ref1(token, '(') & ref1(internalInterval, ')') & ref1(token, ')')));

  Parser internalInterval(String end) =>
      ref0(whiteSpacePlus).optional() &
      ref1(token, ',').neg().star() &
      // ref0(expression) &
      ref0(whiteSpacePlus).optional() &
      ref1(token, ',') &
      ref0(whiteSpacePlus).optional() &
      // ref0(expression) &
      (ref1(token, end)).neg().star() &
      ref0(whiteSpacePlus).optional();

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

  Parser displayClause() =>
      ref1(token, 'display') & ref0(whiteSpacePlus) & stringLexer;

// codeSelector:
// 	'Code' STRING 'from' codesystemIdentifier displayClause?;

// conceptSelector:
// 	'Concept' '{' codeSelector (',' codeSelector)* '}' displayClause?;

  Parser keyword() =>
      ref1(token, 'after') |
      ref1(token, 'aggregate') |
      ref1(token, 'all') |
      ref1(token, 'and') |
      ref1(token, 'as') |
      ref1(token, 'asc') |
      ref1(token, 'ascending') |
      ref1(token, 'before') |
      ref1(token, 'between') |
      ref1(token, 'by') |
      ref1(token, 'called') |
      ref1(token, 'case') |
      ref1(token, 'cast') |
      ref1(token, 'code') |
      ref1(token, 'Code') |
      ref1(token, 'codesystem') |
      ref1(token, 'codesystems') |
      ref1(token, 'collapse') |
      ref1(token, 'concept') |
      ref1(token, 'Concept') |
      ref1(token, 'contains') |
      ref1(token, 'context') |
      ref1(token, 'convert') |
      ref1(token, 'date') |
      ref1(token, 'day') |
      ref1(token, 'days') |
      ref1(token, 'default') |
      ref1(token, 'define') |
      ref1(token, 'desc') |
      ref1(token, 'descending') |
      ref1(token, 'difference') |
      ref1(token, 'display') |
      ref1(token, 'distinct') |
      ref1(token, 'div') |
      ref1(token, 'duration') |
      ref1(token, 'during') |
      ref1(token, 'else') |
      ref1(token, 'end') |
      ref1(token, 'ends') |
      ref1(token, 'except') |
      ref1(token, 'exists') |
      ref1(token, 'expand') |
      ref1(token, 'false') |
      ref1(token, 'flatten') |
      ref1(token, 'fluent') |
      ref1(token, 'from') |
      ref1(token, 'function') |
      ref1(token, 'hour') |
      ref1(token, 'hours') |
      ref1(token, 'if') |
      ref1(token, 'implies') |
      ref1(token, 'in') |
      ref1(token, 'include') |
      ref1(token, 'includes') |
      ref1(token, 'included in') |
      ref1(token, 'intersect') |
      ref1(token, 'Interval') |
      ref1(token, 'is') |
      ref1(token, 'let') |
      ref1(token, 'library') |
      ref1(token, 'List') |
      ref1(token, 'maximum') |
      ref1(token, 'meets') |
      ref1(token, 'millisecond') |
      ref1(token, 'milliseconds') |
      ref1(token, 'minimum') |
      ref1(token, 'minute') |
      ref1(token, 'minutes') |
      ref1(token, 'mod') |
      ref1(token, 'month') |
      ref1(token, 'months') |
      ref1(token, 'not') |
      ref1(token, 'null') |
      ref1(token, 'occurs') |
      ref1(token, 'of') |
      ref1(token, 'on or') |
      ref1(token, 'or') |
      ref1(token, 'or after') |
      ref1(token, 'or before') |
      ref1(token, 'or less') |
      ref1(token, 'or more') |
      ref1(token, 'or on') |
      ref1(token, 'overlaps') |
      ref1(token, 'parameter') |
      ref1(token, 'per') |
      ref1(token, 'point') |
      ref1(token, 'predecessor') |
      ref1(token, 'private') |
      ref1(token, 'properly') |
      ref1(token, 'public') |
      ref1(token, 'return') |
      ref1(token, 'same') |
      ref1(token, 'second') |
      ref1(token, 'seconds') |
      ref1(token, 'singleton') |
      ref1(token, 'start') |
      ref1(token, 'starting') |
      ref1(token, 'starts') |
      ref1(token, 'sort') |
      ref1(token, 'successor') |
      ref1(token, 'such that') |
      ref1(token, 'then') |
      ref1(token, 'time') |
      ref1(token, 'timezoneoffset') |
      ref1(token, 'to') |
      ref1(token, 'true') |
      ref1(token, 'Tuple') |
      ref1(token, 'union') |
      ref1(token, 'using') |
      ref1(token, 'valueset') |
      ref1(token, 'version') |
      ref1(token, 'week') |
      ref1(token, 'weeks') |
      ref1(token, 'where') |
      ref1(token, 'when') |
      ref1(token, 'width') |
      ref1(token, 'with') |
      ref1(token, 'within') |
      ref1(token, 'without') |
      ref1(token, 'xor') |
      ref1(token, 'year') |
      ref1(token, 'years');

// NOTE: Not used, this is the set of reserved words that may not appear as identifiers in ambiguous contexts
  Parser reservedWord() =>
      ref1(token, 'aggregate') |
      ref1(token, 'all') |
      ref1(token, 'and') |
      ref1(token, 'as') |
      ref1(token, 'after') |
      ref1(token, 'before') |
      ref1(token, 'between') |
      ref1(token, 'case') |
      ref1(token, 'cast') |
      ref1(token, 'Code') |
      ref1(token, 'collapse') |
      ref1(token, 'Concept') |
      ref1(token, 'convert') |
      ref1(token, 'day') |
      ref1(token, 'days') |
      ref1(token, 'difference') |
      ref1(token, 'distinct') |
      ref1(token, 'duration') |
      ref1(token, 'during') |
      ref1(token, 'else') |
      ref1(token, 'exists') |
      ref1(token, 'expand') |
      ref1(token, 'false') |
      ref1(token, 'flatten') |
      ref1(token, 'from') |
      ref1(token, 'if') |
      ref1(token, 'in') |
      ref1(token, 'included in') |
      ref1(token, 'is') |
      ref1(token, 'hour') |
      ref1(token, 'hours') |
      ref1(token, 'Interval') |
      ref1(token, 'let') |
      ref1(token, 'List') |
      ref1(token, 'maximum') |
      ref1(token, 'millisecond') |
      ref1(token, 'milliseconds') |
      ref1(token, 'minimum') |
      ref1(token, 'minute') |
      ref1(token, 'minutes') |
      ref1(token, 'month') |
      ref1(token, 'months') |
      ref1(token, 'not') |
      ref1(token, 'null') |
      ref1(token, 'occurs') |
      ref1(token, 'of') |
      ref1(token, 'on or') |
      ref1(token, 'or') |
      ref1(token, 'or on') |
      ref1(token, 'per') |
      ref1(token, 'point') |
      ref1(token, 'properly') |
      ref1(token, 'return') |
      ref1(token, 'same') |
      ref1(token, 'second') |
      ref1(token, 'seconds') |
      ref1(token, 'singleton') |
      ref1(token, 'sort') |
      ref1(token, 'such that') |
      ref1(token, 'then') |
      ref1(token, 'to') |
      ref1(token, 'true') |
      ref1(token, 'Tuple') |
      ref1(token, 'week') |
      ref1(token, 'weeks') |
      ref1(token, 'when') |
      ref1(token, 'with') |
      ref1(token, 'within') |
      ref1(token, 'without') |
      ref1(token, 'year') |
      ref1(token, 'years');

  /// Keyword identifiers are keywords that may be used as identifiers in a referential context
  /// Effectively, keyword except reservedWord
  Parser keywordIdentifier() =>
      ref1(token, 'asc') |
      ref1(token, 'ascending') |
      ref1(token, 'by') |
      ref1(token, 'called') |
      ref1(token, 'code') |
      ref1(token, 'codesystem') |
      ref1(token, 'codesystems') |
      ref1(token, 'concept') |
      ref1(token, 'contains') |
      ref1(token, 'context') |
      ref1(token, 'date') |
      ref1(token, 'default') |
      ref1(token, 'define') |
      ref1(token, 'desc') |
      ref1(token, 'descending') |
      ref1(token, 'display') |
      ref1(token, 'div') |
      ref1(token, 'end') |
      ref1(token, 'ends') |
      ref1(token, 'except') |
      ref1(token, 'fluent') |
      ref1(token, 'function') |
      ref1(token, 'implies') |
      ref1(token, 'include') |
      ref1(token, 'includes') |
      ref1(token, 'intersect') |
      ref1(token, 'library') |
      ref1(token, 'meets') |
      ref1(token, 'mod') |
      ref1(token, 'or after') |
      ref1(token, 'or before') |
      ref1(token, 'or less') |
      ref1(token, 'or more') |
      ref1(token, 'overlaps') |
      ref1(token, 'parameter') |
      ref1(token, 'predecessor') |
      ref1(token, 'private') |
      ref1(token, 'public') |
      ref1(token, 'start') |
      ref1(token, 'starting') |
      ref1(token, 'starts') |
      ref1(token, 'successor') |
      ref1(token, 'time') |
      ref1(token, 'timezoneoffset') |
      ref1(token, 'union') |
      ref1(token, 'using') |
      ref1(token, 'valueset') |
      ref1(token, 'version') |
      ref1(token, 'where') |
      ref1(token, 'width') |
      ref1(token, 'xor');

  /// Obsolete identifiers are keywords that could be used as identifiers in CQL 1.3 NOTE: Not
  /// currently used, this is the set of keywords that were defined as allowed identifiers as part of
  /// 1.3 NOTE: Several keywords were commented out in this list (notably exists) because of an issue
  /// with the ANTLR tooling. In 4.5, having these keywords as identifiers results in unacceptable
  /// parsing performance. In 4.6+, having them as identifiers resulted in incorrect parsing. See
  /// Github issue [#343](https://github.com/cqframework/clinical_quality_language/issues/343) for more
  /// detail This should no longer be an issue with 1.4 due to the introduction of reserved words
  Parser obsoleteIdentifier() =>
      ref1(token, 'all') |
      ref1(token, 'Code') |
      ref1(token, 'code') |
      ref1(token, 'Concept') |
      ref1(token, 'concept') |
      ref1(token, 'contains') |
      ref1(token, 'date') |
      ref1(token, 'display') |
      ref1(token, 'distinct') |
      ref1(token, 'end') |
      ref1(token, 'exists') |
      ref1(token, 'not') |
      ref1(token, 'start') |
      ref1(token, 'time') |
      ref1(token, 'timezoneoffset') |
      ref1(token, 'version') |
      ref1(token, 'where');

// Function identifiers are keywords that may be used as identifiers for functions
  Parser functionIdentifier() =>
      ref1(token, 'after') |
      ref1(token, 'aggregate') |
      ref1(token, 'all') |
      ref1(token, 'and') |
      ref1(token, 'as') |
      ref1(token, 'asc') |
      ref1(token, 'ascending') |
      ref1(token, 'before') |
      ref1(token, 'between') |
      ref1(token, 'by') |
      ref1(token, 'called') |
      ref1(token, 'case') |
      ref1(token, 'cast') |
      ref1(token, 'code') |
      ref1(token, 'Code') |
      ref1(token, 'codesystem') |
      ref1(token, 'codesystems') |
      ref1(token, 'collapse') |
      ref1(token, 'concept') |
      ref1(token, 'Concept') |
      ref1(token, 'contains') |
      ref1(token, 'context') |
      ref1(token, 'convert') |
      ref1(token, 'date') |
      ref1(token, 'day') |
      ref1(token, 'days') |
      ref1(token, 'default') |
      ref1(token, 'define') |
      ref1(token, 'desc') |
      ref1(token, 'descending') |
      ref1(token, 'difference') |
      ref1(token, 'display') |
      ref1(token, 'distinct') |
      ref1(token, 'div') |
      ref1(token, 'duration') |
      ref1(token, 'during') |
      ref1(token, 'else') |
      ref1(token, 'end') |
      ref1(token, 'ends') |
      ref1(token, 'except') |
      ref1(token, 'exists') |
      ref1(token, 'expand') |
      ref1(token, 'false') |
      ref1(token, 'flatten') |
      ref1(token, 'fluent') |
      ref1(token, 'from') |
      ref1(token, 'function') |
      ref1(token, 'hour') |
      ref1(token, 'hours') |
      ref1(token, 'if') |
      ref1(token, 'implies') |
      ref1(token, 'in') |
      ref1(token, 'include') |
      ref1(token, 'includes') |
      ref1(token, 'included in') |
      ref1(token, 'intersect') |
      ref1(token, 'Interval') |
      ref1(token, 'is') |
      ref1(token, 'let') |
      ref1(token, 'library') |
      ref1(token, 'List') |
      ref1(token, 'maximum') |
      ref1(token, 'meets') |
      ref1(token, 'millisecond') |
      ref1(token, 'milliseconds') |
      ref1(token, 'minimum') |
      ref1(token, 'minute') |
      ref1(token, 'minutes') |
      ref1(token, 'mod') |
      ref1(token, 'month') |
      ref1(token, 'months') |
      ref1(token, 'not') |
      ref1(token, 'null') |
      ref1(token, 'occurs') |
      ref1(token, 'of') |
      ref1(token, 'or') |
      ref1(token, 'or after') |
      ref1(token, 'or before') |
      ref1(token, 'or less') |
      ref1(token, 'or more') |
      ref1(token, 'overlaps') |
      ref1(token, 'parameter') |
      ref1(token, 'per') |
      ref1(token, 'point') |
      ref1(token, 'predecessor') |
      ref1(token, 'private') |
      ref1(token, 'properly') |
      ref1(token, 'public') |
      ref1(token, 'return') |
      ref1(token, 'same') |
      ref1(token, 'singleton') |
      ref1(token, 'second') |
      ref1(token, 'seconds') |
      ref1(token, 'start') |
      ref1(token, 'starting') |
      ref1(token, 'starts') |
      ref1(token, 'sort') |
      ref1(token, 'successor') |
      ref1(token, 'such that') |
      ref1(token, 'then') |
      ref1(token, 'time') |
      ref1(token, 'timezoneoffset') |
      ref1(token, 'to') |
      ref1(token, 'true') |
      ref1(token, 'Tuple') |
      ref1(token, 'union') |
      ref1(token, 'using') |
      ref1(token, 'valueset') |
      ref1(token, 'version') |
      ref1(token, 'week') |
      ref1(token, 'weeks') |
      ref1(token, 'where') |
      ref1(token, 'when') |
      ref1(token, 'width') |
      ref1(token, 'with') |
      ref1(token, 'within') |
      ref1(token, 'without') |
      ref1(token, 'xor') |
      ref1(token, 'year') |
      ref1(token, 'years');

  /// Reserved words that are also type names
  Parser typeNameIdentifier() =>
      ref1(token, 'Code') |
      ref1(token, 'Concept') |
      ref1(token, 'date') |
      ref1(token, 'time');

  Parser referentialIdentifier() => ref0(identifier) | ref0(keywordIdentifier);

// referentialIdentifier: identifier | keywordIdentifier;

  Parser referentialOrTypeNameIdentifier() =>
      ref0(referentialIdentifier) | ref0(typeNameIdentifier);

// identifierOrFunctionIdentifier: identifier | functionIdentifier;

  Parser identifier() =>
      identifierLexer | delimitedIdentifierLexer | ref0(quotedIdentifier);

  Parser quotedIdentifier() =>
      ref1(token, '"') &
      (escLexer | ref1(token, '"').neg()).star() &
      ref1(token, '"');

// DATETIME: '@' DATEFORMAT 'T' TIMEFORMAT? TIMEZONEOFFSETFORMAT?;

// LONGNUMBER: [0-9]+ 'L';

// fragment ESC:
// 	'\\' ([`'"\\/fnrt] | UNICODE); // allow \`, \', \", \\, \/, \f, etc. and \uXXX
}
