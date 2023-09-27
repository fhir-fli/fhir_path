// Generated from cql.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'cql_parser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [cqlParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class cqlVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [cqlParser.library].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLibrary(LibraryContext ctx);

  /// Visit a parse tree produced by [cqlParser.definition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDefinition(DefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.libraryDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLibraryDefinition(LibraryDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.usingDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUsingDefinition(UsingDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.includeDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIncludeDefinition(IncludeDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.localIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLocalIdentifier(LocalIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.accessModifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAccessModifier(AccessModifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.parameterDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParameterDefinition(ParameterDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.codesystemDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodesystemDefinition(CodesystemDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.valuesetDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitValuesetDefinition(ValuesetDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.codesystems].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodesystems(CodesystemsContext ctx);

  /// Visit a parse tree produced by [cqlParser.codesystemIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodesystemIdentifier(CodesystemIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.libraryIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLibraryIdentifier(LibraryIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.codeDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeDefinition(CodeDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.conceptDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConceptDefinition(ConceptDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.codeIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeIdentifier(CodeIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.codesystemId].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodesystemId(CodesystemIdContext ctx);

  /// Visit a parse tree produced by [cqlParser.valuesetId].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitValuesetId(ValuesetIdContext ctx);

  /// Visit a parse tree produced by [cqlParser.versionSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitVersionSpecifier(VersionSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.codeId].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeId(CodeIdContext ctx);

  /// Visit a parse tree produced by [cqlParser.typeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTypeSpecifier(TypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.namedTypeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNamedTypeSpecifier(NamedTypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.modelIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitModelIdentifier(ModelIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.listTypeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitListTypeSpecifier(ListTypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.intervalTypeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIntervalTypeSpecifier(IntervalTypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.tupleTypeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTupleTypeSpecifier(TupleTypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.tupleElementDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTupleElementDefinition(TupleElementDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.choiceTypeSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitChoiceTypeSpecifier(ChoiceTypeSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.statement].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStatement(StatementContext ctx);

  /// Visit a parse tree produced by [cqlParser.expressionDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExpressionDefinition(ExpressionDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.contextDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitContextDefinition(ContextDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.functionDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFunctionDefinition(FunctionDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.operandDefinition].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOperandDefinition(OperandDefinitionContext ctx);

  /// Visit a parse tree produced by [cqlParser.functionBody].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFunctionBody(FunctionBodyContext ctx);

  /// Visit a parse tree produced by [cqlParser.querySource].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQuerySource(QuerySourceContext ctx);

  /// Visit a parse tree produced by [cqlParser.aliasedQuerySource].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAliasedQuerySource(AliasedQuerySourceContext ctx);

  /// Visit a parse tree produced by [cqlParser.alias].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAlias(AliasContext ctx);

  /// Visit a parse tree produced by [cqlParser.queryInclusionClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQueryInclusionClause(QueryInclusionClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.withClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWithClause(WithClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.withoutClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWithoutClause(WithoutClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.retrieve].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRetrieve(RetrieveContext ctx);

  /// Visit a parse tree produced by [cqlParser.contextIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitContextIdentifier(ContextIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.codePath].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodePath(CodePathContext ctx);

  /// Visit a parse tree produced by [cqlParser.codeComparator].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeComparator(CodeComparatorContext ctx);

  /// Visit a parse tree produced by [cqlParser.terminology].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTerminology(TerminologyContext ctx);

  /// Visit a parse tree produced by [cqlParser.qualifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifier(QualifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.query].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQuery(QueryContext ctx);

  /// Visit a parse tree produced by [cqlParser.sourceClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSourceClause(SourceClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.letClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLetClause(LetClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.letClauseItem].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLetClauseItem(LetClauseItemContext ctx);

  /// Visit a parse tree produced by [cqlParser.whereClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWhereClause(WhereClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.returnClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitReturnClause(ReturnClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.aggregateClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAggregateClause(AggregateClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.startingClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStartingClause(StartingClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.sortClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSortClause(SortClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.sortDirection].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSortDirection(SortDirectionContext ctx);

  /// Visit a parse tree produced by [cqlParser.sortByItem].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSortByItem(SortByItemContext ctx);

  /// Visit a parse tree produced by [cqlParser.qualifiedIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifiedIdentifier(QualifiedIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.qualifiedIdentifierExpression].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifiedIdentifierExpression(
      QualifiedIdentifierExpressionContext ctx);

  /// Visit a parse tree produced by [cqlParser.qualifierExpression].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifierExpression(QualifierExpressionContext ctx);

  /// Visit a parse tree produced by the {@code simplePathIndexer}
  /// labeled alternative in {@link cqlParser#simplePath}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSimplePathIndexer(SimplePathIndexerContext ctx);

  /// Visit a parse tree produced by the {@code simplePathQualifiedIdentifier}
  /// labeled alternative in {@link cqlParser#simplePath}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSimplePathQualifiedIdentifier(
      SimplePathQualifiedIdentifierContext ctx);

  /// Visit a parse tree produced by the {@code simplePathReferentialIdentifier}
  /// labeled alternative in {@link cqlParser#simplePath}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSimplePathReferentialIdentifier(
      SimplePathReferentialIdentifierContext ctx);

  /// Visit a parse tree produced by the {@code simpleStringLiteral}
  /// labeled alternative in {@link cqlParser#simpleLiteral}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSimpleStringLiteral(SimpleStringLiteralContext ctx);

  /// Visit a parse tree produced by the {@code simpleNumberLiteral}
  /// labeled alternative in {@link cqlParser#simpleLiteral}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSimpleNumberLiteral(SimpleNumberLiteralContext ctx);

  /// Visit a parse tree produced by the {@code durationBetweenExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDurationBetweenExpression(DurationBetweenExpressionContext ctx);

  /// Visit a parse tree produced by the {@code inFixSetExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInFixSetExpression(InFixSetExpressionContext ctx);

  /// Visit a parse tree produced by the {@code retrieveExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRetrieveExpression(RetrieveExpressionContext ctx);

  /// Visit a parse tree produced by the {@code timingExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTimingExpression(TimingExpressionContext ctx);

  /// Visit a parse tree produced by the {@code queryExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQueryExpression(QueryExpressionContext ctx);

  /// Visit a parse tree produced by the {@code notExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNotExpression(NotExpressionContext ctx);

  /// Visit a parse tree produced by the {@code booleanExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanExpression(BooleanExpressionContext ctx);

  /// Visit a parse tree produced by the {@code orExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOrExpression(OrExpressionContext ctx);

  /// Visit a parse tree produced by the {@code castExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCastExpression(CastExpressionContext ctx);

  /// Visit a parse tree produced by the {@code andExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAndExpression(AndExpressionContext ctx);

  /// Visit a parse tree produced by the {@code betweenExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBetweenExpression(BetweenExpressionContext ctx);

  /// Visit a parse tree produced by the {@code membershipExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMembershipExpression(MembershipExpressionContext ctx);

  /// Visit a parse tree produced by the {@code differenceBetweenExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDifferenceBetweenExpression(DifferenceBetweenExpressionContext ctx);

  /// Visit a parse tree produced by the {@code inequalityExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInequalityExpression(InequalityExpressionContext ctx);

  /// Visit a parse tree produced by the {@code equalityExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitEqualityExpression(EqualityExpressionContext ctx);

  /// Visit a parse tree produced by the {@code existenceExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExistenceExpression(ExistenceExpressionContext ctx);

  /// Visit a parse tree produced by the {@code impliesExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitImpliesExpression(ImpliesExpressionContext ctx);

  /// Visit a parse tree produced by the {@code termExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTermExpression(TermExpressionContext ctx);

  /// Visit a parse tree produced by the {@code typeExpression}
  /// labeled alternative in {@link cqlParser#expression}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTypeExpression(TypeExpressionContext ctx);

  /// Visit a parse tree produced by [cqlParser.dateTimePrecision].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDateTimePrecision(DateTimePrecisionContext ctx);

  /// Visit a parse tree produced by [cqlParser.dateTimeComponent].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDateTimeComponent(DateTimeComponentContext ctx);

  /// Visit a parse tree produced by [cqlParser.pluralDateTimePrecision].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPluralDateTimePrecision(PluralDateTimePrecisionContext ctx);

  /// Visit a parse tree produced by the {@code additionExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAdditionExpressionTerm(AdditionExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code indexedExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIndexedExpressionTerm(IndexedExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code widthExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWidthExpressionTerm(WidthExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code setAggregateExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSetAggregateExpressionTerm(SetAggregateExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code timeUnitExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTimeUnitExpressionTerm(TimeUnitExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code ifThenElseExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIfThenElseExpressionTerm(IfThenElseExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code timeBoundaryExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTimeBoundaryExpressionTerm(TimeBoundaryExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code elementExtractorExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitElementExtractorExpressionTerm(
      ElementExtractorExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code conversionExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConversionExpressionTerm(ConversionExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code typeExtentExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTypeExtentExpressionTerm(TypeExtentExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code predecessorExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPredecessorExpressionTerm(PredecessorExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code pointExtractorExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPointExtractorExpressionTerm(PointExtractorExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code multiplicationExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMultiplicationExpressionTerm(MultiplicationExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code aggregateExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAggregateExpressionTerm(AggregateExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code durationExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDurationExpressionTerm(DurationExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code differenceExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDifferenceExpressionTerm(DifferenceExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code caseExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCaseExpressionTerm(CaseExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code powerExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPowerExpressionTerm(PowerExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code successorExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSuccessorExpressionTerm(SuccessorExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code polarityExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPolarityExpressionTerm(PolarityExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code termExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTermExpressionTerm(TermExpressionTermContext ctx);

  /// Visit a parse tree produced by the {@code invocationExpressionTerm}
  /// labeled alternative in {@link cqlParser#expressionTerm}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInvocationExpressionTerm(InvocationExpressionTermContext ctx);

  /// Visit a parse tree produced by [cqlParser.caseExpressionItem].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCaseExpressionItem(CaseExpressionItemContext ctx);

  /// Visit a parse tree produced by [cqlParser.dateTimePrecisionSpecifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDateTimePrecisionSpecifier(DateTimePrecisionSpecifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.relativeQualifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRelativeQualifier(RelativeQualifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.offsetRelativeQualifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOffsetRelativeQualifier(OffsetRelativeQualifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.exclusiveRelativeQualifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExclusiveRelativeQualifier(ExclusiveRelativeQualifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.quantityOffset].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQuantityOffset(QuantityOffsetContext ctx);

  /// Visit a parse tree produced by [cqlParser.temporalRelationship].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTemporalRelationship(TemporalRelationshipContext ctx);

  /// Visit a parse tree produced by the {@code concurrentWithIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConcurrentWithIntervalOperatorPhrase(
      ConcurrentWithIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code includesIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIncludesIntervalOperatorPhrase(
      IncludesIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code includedInIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIncludedInIntervalOperatorPhrase(
      IncludedInIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code beforeOrAfterIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBeforeOrAfterIntervalOperatorPhrase(
      BeforeOrAfterIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code withinIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWithinIntervalOperatorPhrase(WithinIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code meetsIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMeetsIntervalOperatorPhrase(MeetsIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code overlapsIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOverlapsIntervalOperatorPhrase(
      OverlapsIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code startsIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStartsIntervalOperatorPhrase(StartsIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code endsIntervalOperatorPhrase}
  /// labeled alternative in {@link cqlParser#intervalOperatorPhrase}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitEndsIntervalOperatorPhrase(EndsIntervalOperatorPhraseContext ctx);

  /// Visit a parse tree produced by the {@code invocationTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInvocationTerm(InvocationTermContext ctx);

  /// Visit a parse tree produced by the {@code literalTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLiteralTerm(LiteralTermContext ctx);

  /// Visit a parse tree produced by the {@code externalConstantTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExternalConstantTerm(ExternalConstantTermContext ctx);

  /// Visit a parse tree produced by the {@code intervalSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIntervalSelectorTerm(IntervalSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code tupleSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTupleSelectorTerm(TupleSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code instanceSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInstanceSelectorTerm(InstanceSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code listSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitListSelectorTerm(ListSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code codeSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeSelectorTerm(CodeSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code conceptSelectorTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConceptSelectorTerm(ConceptSelectorTermContext ctx);

  /// Visit a parse tree produced by the {@code parenthesizedTerm}
  /// labeled alternative in {@link cqlParser#term}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParenthesizedTerm(ParenthesizedTermContext ctx);

  /// Visit a parse tree produced by the {@code qualifiedMemberInvocation}
  /// labeled alternative in {@link cqlParser#qualifiedInvocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifiedMemberInvocation(QualifiedMemberInvocationContext ctx);

  /// Visit a parse tree produced by the {@code qualifiedFunctionInvocation}
  /// labeled alternative in {@link cqlParser#qualifiedInvocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifiedFunctionInvocation(QualifiedFunctionInvocationContext ctx);

  /// Visit a parse tree produced by [cqlParser.qualifiedFunction].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQualifiedFunction(QualifiedFunctionContext ctx);

  /// Visit a parse tree produced by the {@code memberInvocation}
  /// labeled alternative in {@link cqlParser#invocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMemberInvocation(MemberInvocationContext ctx);

  /// Visit a parse tree produced by the {@code functionInvocation}
  /// labeled alternative in {@link cqlParser#invocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFunctionInvocation(FunctionInvocationContext ctx);

  /// Visit a parse tree produced by the {@code thisInvocation}
  /// labeled alternative in {@link cqlParser#invocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitThisInvocation(ThisInvocationContext ctx);

  /// Visit a parse tree produced by the {@code indexInvocation}
  /// labeled alternative in {@link cqlParser#invocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIndexInvocation(IndexInvocationContext ctx);

  /// Visit a parse tree produced by the {@code totalInvocation}
  /// labeled alternative in {@link cqlParser#invocation}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTotalInvocation(TotalInvocationContext ctx);

  /// Visit a parse tree produced by [cqlParser.function].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFunction(FunctionContext ctx);

  /// Visit a parse tree produced by [cqlParser.ratio].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRatio(RatioContext ctx);

  /// Visit a parse tree produced by the {@code booleanLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanLiteral(BooleanLiteralContext ctx);

  /// Visit a parse tree produced by the {@code nullLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNullLiteral(NullLiteralContext ctx);

  /// Visit a parse tree produced by the {@code stringLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStringLiteral(StringLiteralContext ctx);

  /// Visit a parse tree produced by the {@code numberLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumberLiteral(NumberLiteralContext ctx);

  /// Visit a parse tree produced by the {@code longNumberLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLongNumberLiteral(LongNumberLiteralContext ctx);

  /// Visit a parse tree produced by the {@code dateTimeLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDateTimeLiteral(DateTimeLiteralContext ctx);

  /// Visit a parse tree produced by the {@code dateLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDateLiteral(DateLiteralContext ctx);

  /// Visit a parse tree produced by the {@code timeLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTimeLiteral(TimeLiteralContext ctx);

  /// Visit a parse tree produced by the {@code quantityLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQuantityLiteral(QuantityLiteralContext ctx);

  /// Visit a parse tree produced by the {@code ratioLiteral}
  /// labeled alternative in {@link cqlParser#literal}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRatioLiteral(RatioLiteralContext ctx);

  /// Visit a parse tree produced by [cqlParser.intervalSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIntervalSelector(IntervalSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.tupleSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTupleSelector(TupleSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.tupleElementSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTupleElementSelector(TupleElementSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.instanceSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInstanceSelector(InstanceSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.instanceElementSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInstanceElementSelector(InstanceElementSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.listSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitListSelector(ListSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.displayClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDisplayClause(DisplayClauseContext ctx);

  /// Visit a parse tree produced by [cqlParser.codeSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCodeSelector(CodeSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.conceptSelector].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConceptSelector(ConceptSelectorContext ctx);

  /// Visit a parse tree produced by [cqlParser.keyword].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitKeyword(KeywordContext ctx);

  /// Visit a parse tree produced by [cqlParser.reservedWord].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitReservedWord(ReservedWordContext ctx);

  /// Visit a parse tree produced by [cqlParser.keywordIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitKeywordIdentifier(KeywordIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.obsoleteIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitObsoleteIdentifier(ObsoleteIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.functionIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFunctionIdentifier(FunctionIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.typeNameIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTypeNameIdentifier(TypeNameIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.referentialIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitReferentialIdentifier(ReferentialIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.referentialOrTypeNameIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitReferentialOrTypeNameIdentifier(
      ReferentialOrTypeNameIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.identifierOrFunctionIdentifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIdentifierOrFunctionIdentifier(
      IdentifierOrFunctionIdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.identifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIdentifier(IdentifierContext ctx);

  /// Visit a parse tree produced by [cqlParser.externalConstant].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExternalConstant(ExternalConstantContext ctx);

  /// Visit a parse tree produced by [cqlParser.paramList].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParamList(ParamListContext ctx);

  /// Visit a parse tree produced by [cqlParser.quantity].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitQuantity(QuantityContext ctx);

  /// Visit a parse tree produced by [cqlParser.unit].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUnit(UnitContext ctx);
}
