// Generated from cql.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'cql_parser.dart';
import 'cql_visitor.dart';

/// This class provides an empty implementation of [cqlVisitor],
/// which can be extended to create a visitor which only needs to handle
/// a subset of the available methods.
///
/// [T] is the return type of the visit operation. Use `void` for
/// operations with no return type.
class cqlBaseVisitor<T> extends ParseTreeVisitor<T> implements cqlVisitor<T> {
  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLibrary(LibraryContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDefinition(DefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLibraryDefinition(LibraryDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitUsingDefinition(UsingDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIncludeDefinition(IncludeDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLocalIdentifier(LocalIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAccessModifier(AccessModifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParameterDefinition(ParameterDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodesystemDefinition(CodesystemDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitValuesetDefinition(ValuesetDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodesystems(CodesystemsContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodesystemIdentifier(CodesystemIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLibraryIdentifier(LibraryIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeDefinition(CodeDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConceptDefinition(ConceptDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeIdentifier(CodeIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodesystemId(CodesystemIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitValuesetId(ValuesetIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitVersionSpecifier(VersionSpecifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeId(CodeIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTypeSpecifier(TypeSpecifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNamedTypeSpecifier(NamedTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitModelIdentifier(ModelIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitListTypeSpecifier(ListTypeSpecifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIntervalTypeSpecifier(IntervalTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTupleTypeSpecifier(TupleTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTupleElementDefinition(TupleElementDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitChoiceTypeSpecifier(ChoiceTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStatement(StatementContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExpressionDefinition(ExpressionDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitContextDefinition(ContextDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFunctionDefinition(FunctionDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitOperandDefinition(OperandDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFunctionBody(FunctionBodyContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQuerySource(QuerySourceContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAliasedQuerySource(AliasedQuerySourceContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAlias(AliasContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQueryInclusionClause(QueryInclusionClauseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWithClause(WithClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWithoutClause(WithoutClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRetrieve(RetrieveContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitContextIdentifier(ContextIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodePath(CodePathContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeComparator(CodeComparatorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTerminology(TerminologyContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifier(QualifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQuery(QueryContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSourceClause(SourceClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLetClause(LetClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLetClauseItem(LetClauseItemContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWhereClause(WhereClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitReturnClause(ReturnClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAggregateClause(AggregateClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStartingClause(StartingClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSortClause(SortClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSortDirection(SortDirectionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSortByItem(SortByItemContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifiedIdentifier(QualifiedIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifiedIdentifierExpression(
          QualifiedIdentifierExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifierExpression(QualifierExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSimplePathIndexer(SimplePathIndexerContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSimplePathQualifiedIdentifier(
          SimplePathQualifiedIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSimplePathReferentialIdentifier(
          SimplePathReferentialIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSimpleStringLiteral(SimpleStringLiteralContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSimpleNumberLiteral(SimpleNumberLiteralContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDurationBetweenExpression(DurationBetweenExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInFixSetExpression(InFixSetExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRetrieveExpression(RetrieveExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTimingExpression(TimingExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQueryExpression(QueryExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNotExpression(NotExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBooleanExpression(BooleanExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitOrExpression(OrExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCastExpression(CastExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAndExpression(AndExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBetweenExpression(BetweenExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMembershipExpression(MembershipExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDifferenceBetweenExpression(DifferenceBetweenExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInequalityExpression(InequalityExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitEqualityExpression(EqualityExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExistenceExpression(ExistenceExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitImpliesExpression(ImpliesExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTermExpression(TermExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTypeExpression(TypeExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDateTimePrecision(DateTimePrecisionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDateTimeComponent(DateTimeComponentContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPluralDateTimePrecision(PluralDateTimePrecisionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAdditionExpressionTerm(AdditionExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIndexedExpressionTerm(IndexedExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWidthExpressionTerm(WidthExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSetAggregateExpressionTerm(SetAggregateExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTimeUnitExpressionTerm(TimeUnitExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIfThenElseExpressionTerm(IfThenElseExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTimeBoundaryExpressionTerm(TimeBoundaryExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitElementExtractorExpressionTerm(
          ElementExtractorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConversionExpressionTerm(ConversionExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTypeExtentExpressionTerm(TypeExtentExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPredecessorExpressionTerm(PredecessorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPointExtractorExpressionTerm(
          PointExtractorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMultiplicationExpressionTerm(
          MultiplicationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAggregateExpressionTerm(AggregateExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDurationExpressionTerm(DurationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDifferenceExpressionTerm(DifferenceExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCaseExpressionTerm(CaseExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPowerExpressionTerm(PowerExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSuccessorExpressionTerm(SuccessorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPolarityExpressionTerm(PolarityExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTermExpressionTerm(TermExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInvocationExpressionTerm(InvocationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCaseExpressionItem(CaseExpressionItemContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDateTimePrecisionSpecifier(DateTimePrecisionSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRelativeQualifier(RelativeQualifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitOffsetRelativeQualifier(OffsetRelativeQualifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExclusiveRelativeQualifier(ExclusiveRelativeQualifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQuantityOffset(QuantityOffsetContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTemporalRelationship(TemporalRelationshipContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConcurrentWithIntervalOperatorPhrase(
          ConcurrentWithIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIncludesIntervalOperatorPhrase(
          IncludesIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIncludedInIntervalOperatorPhrase(
          IncludedInIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBeforeOrAfterIntervalOperatorPhrase(
          BeforeOrAfterIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWithinIntervalOperatorPhrase(
          WithinIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMeetsIntervalOperatorPhrase(MeetsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitOverlapsIntervalOperatorPhrase(
          OverlapsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStartsIntervalOperatorPhrase(
          StartsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitEndsIntervalOperatorPhrase(EndsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInvocationTerm(InvocationTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLiteralTerm(LiteralTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExternalConstantTerm(ExternalConstantTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIntervalSelectorTerm(IntervalSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTupleSelectorTerm(TupleSelectorTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInstanceSelectorTerm(InstanceSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitListSelectorTerm(ListSelectorTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeSelectorTerm(CodeSelectorTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConceptSelectorTerm(ConceptSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParenthesizedTerm(ParenthesizedTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifiedMemberInvocation(QualifiedMemberInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifiedFunctionInvocation(QualifiedFunctionInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQualifiedFunction(QualifiedFunctionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMemberInvocation(MemberInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFunctionInvocation(FunctionInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitThisInvocation(ThisInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIndexInvocation(IndexInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTotalInvocation(TotalInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFunction(FunctionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRatio(RatioContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBooleanLiteral(BooleanLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNullLiteral(NullLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStringLiteral(StringLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNumberLiteral(NumberLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLongNumberLiteral(LongNumberLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDateTimeLiteral(DateTimeLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDateLiteral(DateLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTimeLiteral(TimeLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQuantityLiteral(QuantityLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRatioLiteral(RatioLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIntervalSelector(IntervalSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTupleSelector(TupleSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTupleElementSelector(TupleElementSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInstanceSelector(InstanceSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInstanceElementSelector(InstanceElementSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitListSelector(ListSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDisplayClause(DisplayClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCodeSelector(CodeSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConceptSelector(ConceptSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitKeyword(KeywordContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitReservedWord(ReservedWordContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitKeywordIdentifier(KeywordIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitObsoleteIdentifier(ObsoleteIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFunctionIdentifier(FunctionIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTypeNameIdentifier(TypeNameIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitReferentialIdentifier(ReferentialIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitReferentialOrTypeNameIdentifier(
          ReferentialOrTypeNameIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIdentifierOrFunctionIdentifier(
          IdentifierOrFunctionIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIdentifier(IdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExternalConstant(ExternalConstantContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParamList(ParamListContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitQuantity(QuantityContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitUnit(UnitContext ctx) => visitChildren(ctx);
}
