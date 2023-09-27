// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import '../parser/parser.dart';
import 'lexer.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> cqlLexer() {
  ///
  /// Setup all of the lexers that will be used in this function and may be
  /// recursive and so will throw a Stack Overflow exception if we don't manage
  /// them properly
  ///
  final definitionLexer = undefined();
  final parameterDefinitionLexer = undefined();
  final statementLexer = undefined();
  final expressionDefinitionLexer = undefined();
  final contextDefinitionLexer = undefined();
  final functionDefinitionLexer = undefined();
  final operandDefinitionLexer = undefined();
  final functionBodyLexer = undefined();
  final querySourceLexer = undefined();
  final aliasedQuerySourceLexer = undefined();
  final queryInclusionClauseLexer = undefined();
  final withClauseLexer = undefined();
  final withoutClauseLexer = undefined();
  final retrieveLexer = undefined();
  final contextIdentifierLexer = undefined();
  final codePathLexer = undefined();
  final codeComparatorLexer = undefined();
  final terminologyLexer = undefined();
  final queryLexer = undefined();
  final sourceClauseLexer = undefined();
  final letClauseLexer = undefined();
  final letClauseItemLexer = undefined();
  final whereClauseLexer = undefined();
  final returnClauseLexer = undefined();
  final aggregateClauseLexer = undefined();
  final startingClauseLexer = undefined();
  final sortClauseLexer = undefined();
  final sortDirectionLexer = undefined();
  final sortByItemLexer = undefined();
  final qualifiedIdentifierExpressionLexer = undefined();
  final qualifierExpressionLexer = undefined();
  final simplePathLexer = undefined();
  final cqlExpressionLexer = undefined();
  final expressionTermLexer = undefined();
  final termLexer = undefined();
  final intervalSelectorLexer = undefined();
  final tupleSelectorLexer = undefined();
  final tupleElementSelectorLexer = undefined();
  final instanceSelectorLexer = undefined();
  final instanceElementSelectorLexer = undefined();
  final listSelectorLexer = undefined();
  final caseExpressionItemLexer = undefined();

  ///
  /// Setup all the "Part" lexers - that is, the actual definition of the Lexer
  /// that we're going to eventually set at the bottom of this function
  ///
  final definitionLexerPart = usingDefinitionLexer |
      includeDefinitionLexer |
      codesystemDefinitionLexer |
      valuesetDefinitionLexer |
      codeDefinitionLexer |
      conceptDefinitionLexer |
      parameterDefinitionLexer;

  final Parser<ParameterDefinitionParser> parameterDefinitionLexerPart =
      (accessModifierLexer.optional() &
              string('parameter') &
              cqlIdentifierLexer &
              typeSpecifierLexer().optional() &
              (string('default') & cqlExpressionLexer).optional())
          .map((value) => ParameterDefinitionParser(
                value[0].toString(),
                value[2].toString(),
                value[3].toString(),
                value[4].toString(),
              ));

  //print('statementLexerPart');
  final statementLexerPart = expressionDefinitionLexer |
      contextDefinitionLexer |
      functionDefinitionLexer;

  //print('expressionDefinitionLexerPart');
  final expressionDefinitionLexerPart = string('define') &
      accessModifierLexer.optional() &
      cqlIdentifierLexer &
      char(':') &
      cqlExpressionLexer;

  //print('contextDefinitionLexerPart');
  final contextDefinitionLexerPart = string('context') &
      (typeSpecifierLexer() & char('.')).optional() &
      cqlIdentifierLexer;

  //print('functionDefinitionLexerPart');
  final functionDefinitionLexerPart = string('define') &
      accessModifierLexer.optional() &
      string('fluent').optional() &
      string('function') &
      identifierOrFunctionIdentifierLexer &
      char('(') &
      (operandDefinitionLexer & (char(',') & operandDefinitionLexer).star())
          .optional() &
      char(')') &
      (string('returns') & typeSpecifierLexer()).optional() &
      char(':') &
      (functionBodyLexer | string('external'));

  //print('operandDefinitionLexerPart');
  final operandDefinitionLexerPart = referentialIdentifierLexer &
      typeSpecifierLexer().map((value) {
        //print(value);
        return value;
      });

  //print('functionBodyLexerPart');
  final functionBodyLexerPart = cqlExpressionLexer;

  //print('querySourceLexerPart');
  final querySourceLexerPart = retrieveLexer |
      qualifiedIdentifierExpressionLexer |
      (char('(') & cqlExpressionLexer & char(')'));

  //print('aliasLexer');
  final aliasLexer = cqlIdentifierLexer;

  //print('aliasedQuerySourceLexerPart');
  final aliasedQuerySourceLexerPart = querySourceLexer & aliasLexer;

  //print('queryInclusionClauseLexerPart');
  final queryInclusionClauseLexerPart = withClauseLexer | withoutClauseLexer;

  //print('withClauseLexerPart');
  final withClauseLexerPart = string('with') &
      aliasedQuerySourceLexer &
      string('such that') &
      cqlExpressionLexer;

  //print('withoutClauseLexerPart');
  final withoutClauseLexerPart = string('without') &
      aliasedQuerySourceLexer &
      string('such that') &
      cqlExpressionLexer;

  //print('retrieveLexerPart');
  final retrieveLexerPart = char('[') &
      (contextIdentifierLexer & string('->')).optional() &
      namedTypeSpecifierLexer &
      (char(':') &
              (codePathLexer & codeComparatorLexer).optional() &
              terminologyLexer)
          .optional() &
      char(']');

  //print('contextIdentifierLexerPart');
  final contextIdentifierLexerPart = qualifiedIdentifierExpressionLexer;

  //print('codePathLexerPart');
  final codePathLexerPart = simplePathLexer;

  //print('codeComparatorLexerPart');
  final codeComparatorLexerPart = string('in') | char('=') | char('~');

  //print('terminologyLexerPart');
  final terminologyLexerPart =
      qualifiedIdentifierExpressionLexer | cqlExpressionLexer;

  //print('queryLexerPart');
  final queryLexerPart = sourceClauseLexer &
      letClauseLexer.optional() &
      queryInclusionClauseLexer.optional() &
      whereClauseLexer.optional() &
      (aggregateClauseLexer | returnClauseLexer).optional() &
      sortClauseLexer.optional();

  //print('sourceClauseLexerPart');
  final sourceClauseLexerPart = string('from').optional() &
      aliasedQuerySourceLexer &
      (char(',') & aliasedQuerySourceLexer).star();

  //print('letClauseLexerPart');
  final letClauseLexerPart = string('let') &
      letClauseItemLexer &
      (char(',') & letClauseItemLexer).star();

  //print('letClauseItemLexerPart');
  final letClauseItemLexerPart =
      cqlIdentifierLexer & char(':') & cqlExpressionLexer;

  //print('whereClauseLexerPart');
  final whereClauseLexerPart = string('where') & cqlExpressionLexer;

  //print('returnClauseLexerPart');
  final returnClauseLexerPart = string('return') &
      (string('all') | string('distinct')).optional() &
      cqlExpressionLexer;

  //print('aggregateClauseLexerPart');
  final aggregateClauseLexerPart = string('aggregate') &
      (string('all') | string('distinct')).optional() &
      cqlIdentifierLexer &
      startingClauseLexer.optional() &
      char(':') &
      cqlExpressionLexer;

  //print('startingClauseLexerPart');
  final startingClauseLexerPart = string('starting') &
      (simpleLiteralLexer |
          quantityLexer |
          (char('(') & expressionDefinitionLexer & char(')')));

  //print('sortClauseLexerPart');
  final sortClauseLexerPart = string('sort') &
      (sortDirectionLexer |
          (string('by') &
              sortByItemLexer &
              (char(',') & sortByItemLexer).star()));

  //print('sortDirectionLexerPart');
  final sortDirectionLexerPart = string('asc') |
      string('ascending') |
      string('desc') |
      string('descending');

  //print('sortByItemLexerPart');
  final sortByItemLexerPart =
      cqlExpressionLexer & sortDirectionLexer.optional();

  //print('qualifiedIdentifierExpressionLexerPart');
  final qualifiedIdentifierExpressionLexerPart =
      (qualifierExpressionLexer & char('.')).star() &
          referentialIdentifierLexer;

  //print('qualifierExpressionLexerPart');
  final qualifierExpressionLexerPart = referentialIdentifierLexer;

  //print('simplePathLexerPart');
  final simplePathLexerPart = referentialIdentifierLexer |
      (simplePathLexer & char('.') & referentialIdentifierLexer) |
      (simplePathLexer & char('[') & simpleLiteralLexer & char(']'));

  //print('termLexerPart');
  final termLexerPart = invocationLexer |
      cqlLiteralLexer |
      externalConstantLexer |
      intervalSelectorLexer |
      tupleSelectorLexer |
      instanceSelectorLexer |
      listSelectorLexer |
      codeSelectorLexer |
      conceptSelectorLexer |
      (char('(') & cqlExpressionLexer & char(')'));

  //print('intervalSelectorLexerPart');
  final intervalSelectorLexerPart = string('Interval') &
      (char('[') | char('(')) &
      cqlExpressionLexer &
      char(',') &
      cqlExpressionLexer &
      (char(']') | char(')'));

  //print('tupleElementSelectorLexerPart');
  final tupleElementSelectorLexerPart =
      referentialIdentifierLexer & char(':') & cqlExpressionLexer;

  //print('tupleSelectorLexerPart');
  final tupleSelectorLexerPart = string('Tuple').optional() &
      char('{') &
      (char(':') |
          (tupleElementSelectorLexer &
              (char(',') & tupleElementSelectorLexer).star())) &
      char('}');

  //print('instanceElementSelectorLexerPart');
  final instanceElementSelectorLexerPart =
      referentialIdentifierLexer & char(':') & cqlExpressionLexer;

  //print('instanceSelectorLexerPart');
  final instanceSelectorLexerPart = namedTypeSpecifierLexer &
      char('{') &
      (char(':') |
          (instanceElementSelectorLexer &
              (char(',') & instanceElementSelectorLexer).star())) &
      char('}');

  //print('listSelectorLexerPart');
  final listSelectorLexerPart = (string('List') &
              (char('<') & typeSpecifierLexer() & char('>')).optional())
          .optional() &
      char('{') &
      (cqlExpressionLexer & (char(',') & cqlExpressionLexer).star())
          .optional() &
      char('}');

  //print('caseExpressionItemLexerPart');
  final caseExpressionItemLexerPart =
      string('when') & cqlExpressionLexer & string('then') & cqlExpressionLexer;

  //print('expressionTermLexerPart');
  final expressionTermLexerPart = termLexer |
      (expressionTermLexer & char('.') & qualifiedInvocationLexer) |
      (expressionTermLexer & char('[') & cqlExpressionLexer & char(']')) |
      (string('convert') &
          cqlExpressionLexer &
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
          cqlExpressionLexer &
          string('then') &
          cqlExpressionLexer &
          string('else') &
          cqlExpressionLexer) |
      (string('case') &
          cqlExpressionLexer.optional() &
          caseExpressionItemLexer.plus() &
          string('else') &
          cqlExpressionLexer &
          string('end')) |
      ((string('distinct') | string('flatten')) & cqlExpressionLexer) |
      ((string('expand') | string('collapse')) &
          cqlExpressionLexer &
          (string('per') & (dateTimePrecisionLexer | cqlExpressionLexer))
              .optional());

  //print('cqlExpressionLexerPart');
  final cqlExpressionLexerPart = expressionTermLexer |
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
          expressionTermLexer &
          string('and') &
          expressionTermLexer) |
      ((string('duration') & string('in')).optional() &
          pluralDateTimePrecisionLexer &
          string('between') &
          expressionTermLexer &
          string('and') &
          expressionTermLexer) |
      (string('difference') &
          string('in') &
          pluralDateTimePrecisionLexer &
          string('between') &
          expressionTermLexer &
          string('and') &
          expressionTermLexer) |
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

  ///
  /// Set all of the lexers above that we defined
  ///
  functionBodyLexer.set(functionBodyLexerPart);
  operandDefinitionLexer.set(operandDefinitionLexerPart);
  functionDefinitionLexer.set(functionDefinitionLexerPart);
  contextDefinitionLexer.set(contextDefinitionLexerPart);
  expressionDefinitionLexer.set(expressionDefinitionLexerPart);
  statementLexer.set(statementLexerPart);
  cqlExpressionLexer.set(cqlExpressionLexerPart);
  expressionTermLexer.set(expressionTermLexerPart);
  caseExpressionItemLexer.set(caseExpressionItemLexerPart);
  listSelectorLexer.set(listSelectorLexerPart);
  instanceElementSelectorLexer.set(instanceElementSelectorLexerPart);
  instanceSelectorLexer.set(instanceSelectorLexerPart);
  tupleElementSelectorLexer.set(tupleElementSelectorLexerPart);
  tupleSelectorLexer.set(tupleSelectorLexerPart);
  intervalSelectorLexer.set(intervalSelectorLexerPart);
  termLexer.set(termLexerPart);
  simplePathLexer.set(simplePathLexerPart);
  qualifierExpressionLexer.set(qualifierExpressionLexerPart);
  qualifiedIdentifierExpressionLexer
      .set(qualifiedIdentifierExpressionLexerPart);
  sortByItemLexer.set(sortByItemLexerPart);
  sortDirectionLexer.set(sortDirectionLexerPart);
  sortClauseLexer.set(sortClauseLexerPart);
  startingClauseLexer.set(startingClauseLexerPart);
  aggregateClauseLexer.set(aggregateClauseLexerPart);
  returnClauseLexer.set(returnClauseLexerPart);
  whereClauseLexer.set(whereClauseLexerPart);
  letClauseItemLexer.set(letClauseItemLexerPart);
  letClauseLexer.set(letClauseLexerPart);
  sourceClauseLexer.set(sourceClauseLexerPart);
  queryLexer.set(queryLexerPart);
  terminologyLexer.set(terminologyLexerPart);
  codeComparatorLexer.set(codeComparatorLexerPart);
  codePathLexer.set(codePathLexerPart);
  contextIdentifierLexer.set(contextIdentifierLexerPart);
  retrieveLexer.set(retrieveLexerPart);
  withoutClauseLexer.set(withoutClauseLexerPart);
  withClauseLexer.set(withClauseLexerPart);
  queryInclusionClauseLexer.set(queryInclusionClauseLexerPart);
  aliasedQuerySourceLexer.set(aliasedQuerySourceLexerPart);
  querySourceLexer.set(querySourceLexerPart);
  parameterDefinitionLexer.set(parameterDefinitionLexerPart);
  definitionLexer.set(definitionLexerPart);

  /// Complete the lexing and again, passes to operatorValues
  return (libraryDefinitionLexer.optional() &
          definitionLexer.star() &
          statementLexer.star())
      .plus()
      .end()
      .map((value) => ParserList([]));
}
