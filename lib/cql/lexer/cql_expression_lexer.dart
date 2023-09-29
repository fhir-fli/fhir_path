import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

Parser cqlExpressionLexer() {
  print('CQLEXPRESSIONLEXER');

  final querySource = undefined();
  final aliasedQuerySource = undefined();
  final queryInclusionClause = undefined();
  final withClause = undefined();
  final withoutClause = undefined();
  final retrieve = undefined();
  final terminology = undefined();
  final query = undefined();
  final sourceClause = undefined();
  final letClause = undefined();
  final letClauseItem = undefined();
  final whereClause = undefined();
  final returnClause = undefined();
  final aggregateClause = undefined();
  final startingClause = undefined();
  final sortClause = undefined();
  final sortByItem = undefined();
  final cqlExpression = undefined();
  final expressionTerm = undefined();
  final caseExpressionItem = undefined();
  final term = undefined();
  final intervalSelector = undefined();
  final tupleSelector = undefined();
  final tupleElementSelector = undefined();
  final instanceSelector = undefined();
  final instanceElementSelector = undefined();
  final listSelector = undefined();

  final querySourcePart = retrieve |
      qualifiedIdentifierExpressionLexer |
      (char('(') &
          whiteSpaceLexer.optional() &
          cqlExpression &
          whiteSpaceLexer.optional() &
          char(')'));

  final aliasedQuerySourcePart = querySource & whiteSpaceLexer & aliasLexer;

  final queryInclusionClausePart = withClause | withoutClause;

  final withClausePart = string('with') &
      whiteSpaceLexer &
      aliasedQuerySource &
      whiteSpaceLexer &
      string('such that') &
      whiteSpaceLexer &
      cqlExpression;

  final withoutClausePart = string('without') &
      whiteSpaceLexer &
      aliasedQuerySource &
      whiteSpaceLexer &
      string('such that') &
      whiteSpaceLexer &
      cqlExpression;

  final retrievePart = char('[') &
      (whiteSpaceLexer &
              contextIdentifierLexer &
              whiteSpaceLexer.optional() &
              string('->'))
          .optional() &
      whiteSpaceLexer.optional() &
      namedTypeSpecifierLexer &
      whiteSpaceLexer.optional() &
      (char(':') &
              whiteSpaceLexer.optional() &
              (codePathLexer &
                      whiteSpaceLexer &
                      codeComparatorLexer &
                      whiteSpaceLexer)
                  .optional() &
              terminology)
          .optional() &
      whiteSpaceLexer.optional() &
      char(']');

  final terminologyPart = qualifiedIdentifierExpressionLexer | cqlExpression;

  final queryPart = sourceClause &
      whiteSpaceLexer &
      (letClause).optional() &
      (whiteSpaceLexer & queryInclusionClause).star() &
      (whiteSpaceLexer & whereClause).optional() &
      (whiteSpaceLexer & (aggregateClause | returnClause)).optional() &
      (whiteSpaceLexer & sortClause);

  final sourceClausePart = (string('from') & whiteSpaceLexer).optional() &
      aliasedQuerySource &
      (whiteSpaceLexer.optional() &
              char(',') &
              whiteSpaceLexer.optional() &
              aliasedQuerySource)
          .star();

  final letClausePart = string('let') &
      whiteSpaceLexer &
      letClauseItem &
      (whiteSpaceLexer.optional() &
              char(',') &
              whiteSpaceLexer.optional() &
              letClauseItem)
          .star();

  final letClauseItemPart = cqlIdentifierLexer &
      whiteSpaceLexer.optional() &
      char(':') &
      whiteSpaceLexer.optional() &
      cqlExpression;

  final whereClausePart = string('where') & whiteSpaceLexer & cqlExpression;

  final returnClausePart = string('return') &
      (whiteSpaceLexer & (string('all') | string('distinct'))).optional() &
      whiteSpaceLexer &
      cqlExpression;

  final aggregateClausePart = string('aggregate') &
      (whiteSpaceLexer & (string('all') | string('distinct'))).optional() &
      whiteSpaceLexer &
      cqlIdentifierLexer &
      (whiteSpaceLexer & startingClause).optional() &
      whiteSpaceLexer.optional() &
      char(':') &
      whiteSpaceLexer.optional() &
      cqlExpression;

  final startingClausePart = string('starting') &
      whiteSpaceLexer &
      (simpleLiteralLexer |
          quantityLexer |
          (char('(') &
              whiteSpaceLexer.optional() &
              cqlExpression &
              whiteSpaceLexer.optional() &
              char(')')));

  final sortClausePart = string('sort') &
      whiteSpaceLexer &
      (sortDirectionLexer |
          (string('by') &
              whiteSpaceLexer &
              sortByItem &
              (whiteSpaceLexer.optional() &
                      char(',') &
                      whiteSpaceLexer.optional() &
                      sortByItem)
                  .star()));

  final sortByItemPart =
      expressionTerm & (whiteSpaceLexer & sortDirectionLexer).optional();

  final cqlExpressionPart =

      ///  termExpression
      expressionTerm

          ///  retrieveExpression
          // |
          // retrieve

          // ///  queryExpression
          // |
          // query

          // ///  booleanExpression
          // |
          // (cqlExpression &
          //     whiteSpaceLexer &
          //     string('is') &
          //     (whiteSpaceLexer & string('not')).optional() &
          //     whiteSpaceLexer &
          //     (string('null') | string('true') | string('false')))

          // ///  typeExpression
          // |
          // (cqlExpression &
          //     whiteSpaceLexer &
          //     (string('is') | string('as')) &
          //     (whiteSpaceLexer & typeSpecifierLexer()).optional())

          // ///  castExpression
          // |
          // (string('cast') &
          //     whiteSpaceLexer &
          //     cqlExpression &
          //     whiteSpaceLexer &
          //     string('as') &
          //     whiteSpaceLexer &
          //     typeSpecifierLexer())

          // ///  notExpression
          // |
          // (string('not') & whiteSpaceLexer & cqlExpression)

          // ///  existenceExpression
          // |
          // (string('exists') & whiteSpaceLexer & cqlExpression)

          // ///  betweenExpression
          // |
          // (cqlExpression &
          //     (whiteSpaceLexer & string('properly')).optional() &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTerm &
          //     whiteSpaceLexer &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTerm)

          // /// durationBetweenExpression
          // |
          // (string('duration') &
          //     whiteSpaceLexer &
          //     string('in') &
          //     whiteSpaceLexer &
          //     pluralDateTimePrecisionLexer &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTerm &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTerm)

          // /// differenceBetweenExpression
          // |
          // (string('difference') &
          //     whiteSpaceLexer &
          //     string('in') &
          //     whiteSpaceLexer &
          //     pluralDateTimePrecisionLexer &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTerm &
          //     whiteSpaceLexer &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTerm)

          ///  inequalityExpression
          |
          (cqlExpression &
                  whiteSpaceLexer.optional() &
                  (string('<=') | char('<') | char('>') | string('>=')) &
                  whiteSpaceLexer.optional() &
                  cqlExpression)
              .flatten()
              .map((value) => print(value))

          // ///  timingExpression
          // |
          // (cqlExpression &
          //     whiteSpaceLexer &
          //     intervalOperatorPhraseLexer &
          //     whiteSpaceLexer &
          //     cqlExpression)

          // ///  equalityExpression
          // |
          // (cqlExpression &
          //     whiteSpaceLexer.optional() &
          //     (char('=') | string('!=') | char('~') | string('!~')) &
          //     whiteSpaceLexer &
          //     cqlExpression)

          // ///  membershipExpression
          // |
          // (cqlExpression &
          //     whiteSpaceLexer &
          //     (string('in') | string('contains')) &
          //     (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional() &
          //     whiteSpaceLexer &
          //     cqlExpression)

          ///  andExpression
          |
          (cqlExpression &
              whiteSpaceLexer &
              string('and') &
              whiteSpaceLexer &
              cqlExpression)

      // ///  orExpression
      // |
      // (cqlExpression &
      //     whiteSpaceLexer &
      //     (string('or') | string('xor')) &
      //     whiteSpaceLexer &
      //     cqlExpression)

      // ///  impliesExpression
      // |
      // (cqlExpression &
      //     whiteSpaceLexer &
      //     string('implies') &
      //     whiteSpaceLexer &
      //     cqlExpression)

      // ///  inFixSetExpression;
      // |
      // (cqlExpression &
      //     whiteSpaceLexer &
      //     (char('|') |
      //         string('union') |
      //         string('intersect') |
      //         string('except')) &
      //     whiteSpaceLexer &
      //     cqlExpression)
      ;

  final expressionTermPart =

      /// termExpressionTerm
      term
      // |

      /// invocationExpressionTerm
      // (expressionTerm & char('.') & qualifiedInvocationLexer)

      // /// indexedExpressionTerm
      // |
      // (
      //   expressionTerm,
      //   whiteSpaceLexer.optional(),
      //   char('['),
      //   whiteSpaceLexer.optional(),
      //   cqlExpression,
      //   whiteSpaceLexer.optional(),
      //   char(']')
      // ).toSequenceParser()

      // /// conversionExpressionTerm
      // |
      // (string('convert') &
      //     whiteSpaceLexer &
      //     cqlExpression &
      //     whiteSpaceLexer &
      //     string('to') &
      //     whiteSpaceLexer &
      //     (typeSpecifierLexer() | unitLexer))

      // /// polarityExpressionTerm
      // |
      // ((char('+') | char('-')) & expressionTerm)

      // /// timeBoundaryExpressionTerm
      // |
      // ((string('start') | string('end')) &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// timeUnitExpressionTerm
      // |
      // (dateTimeComponentLexer &
      //     whiteSpaceLexer &
      //     string('from') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// durationExpressionTerm
      // |
      // (string('duration') &
      //     whiteSpaceLexer &
      //     string('in') &
      //     whiteSpaceLexer &
      //     pluralDateTimePrecisionLexer &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// differenceExpressionTerm
      // |
      // (string('difference') &
      //     whiteSpaceLexer &
      //     string('in') &
      //     whiteSpaceLexer &
      //     pluralDateTimePrecisionLexer &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// widthExpressionTerm
      // |
      // (string('width') &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// successorExpressionTerm
      // |
      // (string('successor') &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// predecessorExpressionTerm
      // |
      // (string('predecessor') &
      //     whiteSpaceLexer &
      //     string('of') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// elementExtractorExpressionTerm
      // |
      // (string('singleton') &
      //     whiteSpaceLexer &
      //     string('from') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// pointExtractorExpressionTerm
      // |
      // (string('point') &
      //     whiteSpaceLexer &
      //     string('from') &
      //     whiteSpaceLexer &
      //     expressionTerm)

      // /// typeExtentExpressionTerm
      // |
      // ((string('minimum') | string('maximum')) &
      //     whiteSpaceLexer &
      //     namedTypeSpecifierLexer)

      // /// powerExpressionTerm
      // |
      // (expressionTerm & char('^') & expressionTerm)

      // /// multiplicationExpressionTerm
      // |
      // (expressionTerm &
      //     whiteSpaceLexer.optional() &
      //     (char('*') |
      //         char('/') |
      //         (string('div') & whiteSpaceLexer.optional()) |
      //         (string('mod') & whiteSpaceLexer.optional())) &
      //     expressionTerm)

      // /// additionExpressionTerm
      // |
      // (expressionTerm &
      //     whiteSpaceLexer.optional() &
      //     (char('+') | char('-') | char('&')) &
      //     whiteSpaceLexer.optional() &
      //     expressionTerm)

      // /// ifThenElseExpressionTerm
      // |
      // (string('if') &
      //     whiteSpaceLexer &
      //     cqlExpression &
      //     whiteSpaceLexer &
      //     string('then') &
      //     whiteSpaceLexer &
      //     cqlExpression &
      //     whiteSpaceLexer &
      //     string('else') &
      //     whiteSpaceLexer &
      //     cqlExpression)

      // /// caseExpressionTerm
      // |
      // (string('case') &
      //     (whiteSpaceLexer & cqlExpression).optional() &
      //     whiteSpaceLexer &
      //     caseExpressionItem.plus() &
      //     whiteSpaceLexer &
      //     string('else') &
      //     whiteSpaceLexer &
      //     cqlExpression &
      //     whiteSpaceLexer &
      //     string('end'))

      // /// aggregateExpressionTerm
      // |
      // ((string('distinct') | string('flatten')) &
      //     whiteSpaceLexer &
      //     cqlExpression)

      // /// setAggregateExpressionTerm
      // |
      // ((string('expand') | string('collapse')) &
      //     whiteSpaceLexer &
      //     cqlExpression &
      //     (whiteSpaceLexer &
      //             string('per') &
      //             whiteSpaceLexer &
      //             (dateTimePrecisionLexer | cqlExpression))
      //         .optional())
      ;

  final caseExpressionItemPart = string('when') &
      whiteSpaceLexer &
      cqlExpression &
      whiteSpaceLexer &
      string('then') &
      whiteSpaceLexer &
      cqlExpression;

  final termPart =

      /// invocationTerm
      invocationLexer |

          /// literalTerm
          literalLexer |

          /// externalConstantTerm
          externalConstantLexer
      // |

      /// intervalSelectorTerm
      // intervalSelector |

      // /// tupleSelectorTerm

      // tupleSelector |

      // /// instanceSelectorTerm

      // instanceSelector |

      // /// listSelectorTerm

      // listSelector |

      // /// codeSelectorTerm

      // codeSelectorLexer |

      // /// conceptSelectorTerm

      // conceptSelectorLexer |

      // /// parenthesizedTerm

      // (char('(') &
      //     whiteSpaceLexer.optional() &
      //     cqlExpression &
      //     whiteSpaceLexer.optional() &
      //     char(')'))
      ;

  final intervalSelectorPart =

      /// TODO: Consider this as an alternative syntax for intervals... (would need to be moved up to
      /// expression to make it work) expression ( '..' | '*.' | '.*' | '**' ) expression;
      string('Interval') &
          whiteSpaceLexer.optional() &
          (char('[') | char('(')) &
          whiteSpaceLexer.optional() &
          cqlExpression &
          whiteSpaceLexer.optional() &
          char(',') &
          whiteSpaceLexer.optional() &
          cqlExpression &
          whiteSpaceLexer.optional() &
          (char(']') | char(')'));

  final tupleSelectorPart =
      (string('Tuple') & whiteSpaceLexer.optional()).optional() &
          char('{') &
          whiteSpaceLexer.optional() &
          (char(':') |
              (tupleElementSelector &
                  (whiteSpaceLexer.optional() &
                          char(',') &
                          whiteSpaceLexer.optional() &
                          tupleElementSelector)
                      .star())) &
          whiteSpaceLexer.optional() &
          char('}');

  final tupleElementSelectorPart = referentialIdentifierLexer &
      whiteSpaceLexer.optional() &
      char(':') &
      whiteSpaceLexer.optional() &
      cqlExpression;

  final instanceSelectorPart = namedTypeSpecifierLexer &
      whiteSpaceLexer.optional() &
      char('{') &
      whiteSpaceLexer.optional() &
      (char(':') |
          (instanceElementSelector &
              (whiteSpaceLexer.optional() &
                      char(',') &
                      whiteSpaceLexer.optional() &
                      instanceElementSelector)
                  .star())) &
      whiteSpaceLexer.optional() &
      char('}');

  final instanceElementSelectorPart = referentialIdentifierLexer &
      whiteSpaceLexer.optional() &
      char(':') &
      whiteSpaceLexer.optional() &
      cqlExpression;

  final listSelectorPart = (string('List') &
              (char('<') & typeSpecifierLexer() & char('>')).optional())
          .optional() &
      char('{') &
      whiteSpaceLexer.optional() &
      (cqlExpression &
          (whiteSpaceLexer.optional() &
                  char(',') &
                  whiteSpaceLexer.optional() &
                  cqlExpression)
              .star()) &
      whiteSpaceLexer.optional() &
      char('}');

  querySource.set(querySourcePart);
  aliasedQuerySource.set(aliasedQuerySourcePart);
  queryInclusionClause.set(queryInclusionClausePart);
  withClause.set(withClausePart);
  withoutClause.set(withoutClausePart);
  retrieve.set(retrievePart);
  terminology.set(terminologyPart);
  query.set(queryPart);
  sourceClause.set(sourceClausePart);
  letClause.set(letClausePart);
  letClauseItem.set(letClauseItemPart);
  whereClause.set(whereClausePart);
  returnClause.set(returnClausePart);
  aggregateClause.set(aggregateClausePart);
  startingClause.set(startingClausePart);
  sortClause.set(sortClausePart);
  sortByItem.set(sortByItemPart);
  cqlExpression.set(cqlExpressionPart);
  expressionTerm.set(expressionTermPart);
  caseExpressionItem.set(caseExpressionItemPart);
  term.set(termPart);
  intervalSelector.set(intervalSelectorPart);
  tupleSelector.set(tupleSelectorPart);
  tupleElementSelector.set(tupleElementSelectorPart);
  instanceSelector.set(instanceSelectorPart);
  instanceElementSelector.set(instanceElementSelectorPart);
  listSelector.set(listSelectorPart);

  return cqlExpression;
}

final contextIdentifierLexer = qualifiedIdentifierExpressionLexer;

final qualifiedIdentifierExpressionLexer =
    (qualifierExpressionLexer & char('.')).star() & referentialIdentifierLexer;

final qualifierExpressionLexer = referentialIdentifierLexer;

final codePathLexer = simplePathLexer();

final codeComparatorLexer = string('in') | char('=') | char('~');

final invocationLexer =

    ///  memberInvocation
    referentialIdentifierLexer

        ///  functionInvocation
        |
        cqlFunctionLexer

        ///  thisInvocation
        |
        string(r'$this')

        ///  indexInvocation
        |
        string(r'$index')

        ///  totalInvocation;
        |
        string(r'$total');

final cqlFunctionLexer = (referentialIdentifierLexer &
        whiteSpaceLexer.optional() &
        char('(') &
        whiteSpaceLexer.optional() &
        paramListLexer.optional() &
        whiteSpaceLexer.optional() &
        char(')'))
    .map((value) => print(value));

Parser simplePathLexer() {
  final simplePath = undefined();
  final simplePathPart =

      /// simplePathReferentialIdentifier
      referentialIdentifierLexer

          /// simplePathQualifiedIdentifier
          |
          (simplePath & char('.') & referentialIdentifierLexer)

          /// simplePathIndexer
          |
          (simplePath & char('[') & simpleLiteralLexer & char(']'));
  simplePath.set(simplePathPart);
  return simplePath;
}

final simpleLiteralLexer =

    /// simpleStringLiteral
    stringLexer |

        /// simpleNumberLiteral
        numberLexer;

final aliasLexer = cqlIdentifierLexer;

final sortDirectionLexer =
    string('asc') | string('ascending') | string('desc') | string('descending');

final codeSelectorLexer = string('Code') &
    whiteSpaceLexer &
    stringLexer &
    whiteSpaceLexer &
    string('from') &
    whiteSpaceLexer &
    codesystemIdentifierLexer &
    (whiteSpaceLexer & displayClauseLexer).optional();

final conceptSelectorLexer = string('Concept') &
    whiteSpaceLexer.optional() &
    char('{') &
    whiteSpaceLexer.optional() &
    codeSelectorLexer &
    (whiteSpaceLexer.optional() &
            char(',') &
            whiteSpaceLexer.optional() &
            codeSelectorLexer)
        .star() &
    whiteSpaceLexer.optional() &
    char('}') &
    whiteSpaceLexer.optional() &
    displayClauseLexer.optional();

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

final dateTimePrecisionSpecifierLexer =
    dateTimePrecisionLexer & whiteSpaceLexer & string('of');

final qualifiedInvocationLexer =
    referentialIdentifierLexer | qualifiedFunctionLexer;

final qualifiedFunctionLexer = identifierOrFunctionIdentifierLexer &
    whiteSpaceLexer.optional() &
    char('(') &
    whiteSpaceLexer.optional() &
    paramListLexer.optional() &
    whiteSpaceLexer.optional() &
    char(')');

final paramListLexer =
    fhirPathLexer() & (char(',') & fhirPathLexer()).optional();

final intervalOperatorPhraseLexer =

    /// concurrentWithIntervalOperatorPhrase
    (((string('starts') | string('ends') | string('occurs')) & whiteSpaceLexer)
                .optional() &
            string('same') &
            whiteSpaceLexer &
            (dateTimePrecisionLexer & whiteSpaceLexer).optional() &
            (relativeQualifierLexer | string('as')) &
            (whiteSpaceLexer & (string('start') | string('end'))).optional())

        /// includesIntervalOperatorPhrase
        |
        ((string('properly') & whiteSpaceLexer).optional() &
            string('includes') &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional() &
            (whiteSpaceLexer & (string('start') | string('end'))).optional())

        /// includedInIntervalOperatorPhrase
        |
        (((string('starts') | string('ends') | string('occurs')) &
                    whiteSpaceLexer)
                .optional() &
            (string('properly') & whiteSpaceLexer).optional() &
            (string('during') | string('included in')) &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional())

        /// beforeOrAfterIntervalOperatorPhrase
        |
        (((string('starts') | string('ends') | string('occurs')) &
                    whiteSpaceLexer)
                .optional() &
            (quantityOffsetLexer & whiteSpaceLexer).optional() &
            temporalRelationshipLexer &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional() &
            (whiteSpaceLexer & (string('start') | string('end'))).optional())

        /// withinIntervalOperatorPhrase
        |
        (((string('starts') | string('ends') | string('occurs')) &
                    whiteSpaceLexer)
                .optional() &
            (string('properly') & whiteSpaceLexer).optional() &
            string('within') &
            whiteSpaceLexer &
            quantityLexer &
            whiteSpaceLexer &
            string('of') &
            (whiteSpaceLexer & (string('start') | string('end'))).optional())

        /// meetsIntervalOperatorPhrase
        |
        (string('meets') &
            (whiteSpaceLexer & (string('before') | string('after')))
                .optional() &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional())

        /// overlapsIntervalOperatorPhrase
        |
        (string('overlaps') &
            (whiteSpaceLexer & (string('before') | string('after')))
                .optional() &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional())

        /// startsIntervalOperatorPhrase
        |
        (string('starts') &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional())

        /// # endsIntervalOperatorPhrase
        |
        (string('ends') &
            (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional());

final relativeQualifierLexer = string('or before') | string('or after');

final quantityOffsetLexer = (quantityLexer &
        (whiteSpaceLexer & offsetRelativeQualifierLexer).optional()) |
    (exclusiveRelativeQualifierLexer & whiteSpaceLexer & quantityLexer);

final offsetRelativeQualifierLexer = string('or more') | string('or less');

final exclusiveRelativeQualifierLexer =
    string('less than') | string('more than');

final temporalRelationshipLexer =
    ((string('on or') & whiteSpaceLexer).optional() &
            (string('before') | string('after'))) |
        ((string('before') | string('after')) &
            (whiteSpaceLexer & string('or on')).optional());
