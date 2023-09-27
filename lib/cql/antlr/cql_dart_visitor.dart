// Generated from cql.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'antlr4/antlr4.dart';

/// This class provides an empty implementation of [cqlVisitor],
/// which can be extended to create a visitor which only needs to handle
/// a subset of the available methods.
///
/// [T] is the return type of the visit operation. Use `void` for
/// operations with no return type.
class CqlDartVisitor<List> extends ParseTreeVisitor<List>
    implements cqlVisitor<List> {
  /// This is the beginning of how you evaluate an expression
  List? execute(LibraryContext ctx) => visit(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLibrary(LibraryContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDefinition(DefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLibraryDefinition(LibraryDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitUsingDefinition(UsingDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIncludeDefinition(IncludeDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLocalIdentifier(LocalIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAccessModifier(AccessModifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitParameterDefinition(ParameterDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodesystemDefinition(CodesystemDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitValuesetDefinition(ValuesetDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodesystems(CodesystemsContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodesystemIdentifier(CodesystemIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLibraryIdentifier(LibraryIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeDefinition(CodeDefinitionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitConceptDefinition(ConceptDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeIdentifier(CodeIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodesystemId(CodesystemIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitValuesetId(ValuesetIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitVersionSpecifier(VersionSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeId(CodeIdContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTypeSpecifier(TypeSpecifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitNamedTypeSpecifier(NamedTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitModelIdentifier(ModelIdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitListTypeSpecifier(ListTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIntervalTypeSpecifier(IntervalTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTupleTypeSpecifier(TupleTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTupleElementDefinition(TupleElementDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitChoiceTypeSpecifier(ChoiceTypeSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitStatement(StatementContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitExpressionDefinition(ExpressionDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitContextDefinition(ContextDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitFunctionDefinition(FunctionDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitOperandDefinition(OperandDefinitionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitFunctionBody(FunctionBodyContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQuerySource(QuerySourceContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAliasedQuerySource(AliasedQuerySourceContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAlias(AliasContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQueryInclusionClause(QueryInclusionClauseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitWithClause(WithClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitWithoutClause(WithoutClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitRetrieve(RetrieveContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitContextIdentifier(ContextIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodePath(CodePathContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeComparator(CodeComparatorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTerminology(TerminologyContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifier(QualifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQuery(QueryContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSourceClause(SourceClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLetClause(LetClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLetClauseItem(LetClauseItemContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitWhereClause(WhereClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitReturnClause(ReturnClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAggregateClause(AggregateClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitStartingClause(StartingClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSortClause(SortClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSortDirection(SortDirectionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSortByItem(SortByItemContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifiedIdentifier(QualifiedIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifiedIdentifierExpression(
          QualifiedIdentifierExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifierExpression(QualifierExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSimplePathIndexer(SimplePathIndexerContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSimplePathQualifiedIdentifier(
          SimplePathQualifiedIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSimplePathReferentialIdentifier(
          SimplePathReferentialIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSimpleStringLiteral(SimpleStringLiteralContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSimpleNumberLiteral(SimpleNumberLiteralContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDurationBetweenExpression(DurationBetweenExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInFixSetExpression(InFixSetExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitRetrieveExpression(RetrieveExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTimingExpression(TimingExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQueryExpression(QueryExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitNotExpression(NotExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitBooleanExpression(BooleanExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitOrExpression(OrExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCastExpression(CastExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAndExpression(AndExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitBetweenExpression(BetweenExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitMembershipExpression(MembershipExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDifferenceBetweenExpression(
          DifferenceBetweenExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInequalityExpression(InequalityExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitEqualityExpression(EqualityExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitExistenceExpression(ExistenceExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitImpliesExpression(ImpliesExpressionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTermExpression(TermExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTypeExpression(TypeExpressionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDateTimePrecision(DateTimePrecisionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDateTimeComponent(DateTimeComponentContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitPluralDateTimePrecision(PluralDateTimePrecisionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAdditionExpressionTerm(AdditionExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIndexedExpressionTerm(IndexedExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitWidthExpressionTerm(WidthExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSetAggregateExpressionTerm(
          SetAggregateExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTimeUnitExpressionTerm(TimeUnitExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIfThenElseExpressionTerm(IfThenElseExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTimeBoundaryExpressionTerm(
          TimeBoundaryExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitElementExtractorExpressionTerm(
          ElementExtractorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitConversionExpressionTerm(ConversionExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTypeExtentExpressionTerm(TypeExtentExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitPredecessorExpressionTerm(PredecessorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitPointExtractorExpressionTerm(
          PointExtractorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitMultiplicationExpressionTerm(
          MultiplicationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitAggregateExpressionTerm(AggregateExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDurationExpressionTerm(DurationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDifferenceExpressionTerm(DifferenceExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCaseExpressionTerm(CaseExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitPowerExpressionTerm(PowerExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitSuccessorExpressionTerm(SuccessorExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitPolarityExpressionTerm(PolarityExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTermExpressionTerm(TermExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInvocationExpressionTerm(InvocationExpressionTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCaseExpressionItem(CaseExpressionItemContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDateTimePrecisionSpecifier(
          DateTimePrecisionSpecifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitRelativeQualifier(RelativeQualifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitOffsetRelativeQualifier(OffsetRelativeQualifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitExclusiveRelativeQualifier(
          ExclusiveRelativeQualifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQuantityOffset(QuantityOffsetContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTemporalRelationship(TemporalRelationshipContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitConcurrentWithIntervalOperatorPhrase(
          ConcurrentWithIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIncludesIntervalOperatorPhrase(
          IncludesIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIncludedInIntervalOperatorPhrase(
          IncludedInIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitBeforeOrAfterIntervalOperatorPhrase(
          BeforeOrAfterIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitWithinIntervalOperatorPhrase(
          WithinIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitMeetsIntervalOperatorPhrase(
          MeetsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitOverlapsIntervalOperatorPhrase(
          OverlapsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitStartsIntervalOperatorPhrase(
          StartsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitEndsIntervalOperatorPhrase(
          EndsIntervalOperatorPhraseContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInvocationTerm(InvocationTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLiteralTerm(LiteralTermContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitExternalConstantTerm(ExternalConstantTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIntervalSelectorTerm(IntervalSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTupleSelectorTerm(TupleSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInstanceSelectorTerm(InstanceSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitListSelectorTerm(ListSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeSelectorTerm(CodeSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitConceptSelectorTerm(ConceptSelectorTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitParenthesizedTerm(ParenthesizedTermContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifiedMemberInvocation(QualifiedMemberInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifiedFunctionInvocation(
          QualifiedFunctionInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQualifiedFunction(QualifiedFunctionContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitMemberInvocation(MemberInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitFunctionInvocation(FunctionInvocationContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitThisInvocation(ThisInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIndexInvocation(IndexInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTotalInvocation(TotalInvocationContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitFunction(FunctionContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitRatio(RatioContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitBooleanLiteral(BooleanLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitNullLiteral(NullLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitStringLiteral(StringLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitNumberLiteral(NumberLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitLongNumberLiteral(LongNumberLiteralContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDateTimeLiteral(DateTimeLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDateLiteral(DateLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTimeLiteral(TimeLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQuantityLiteral(QuantityLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitRatioLiteral(RatioLiteralContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIntervalSelector(IntervalSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTupleSelector(TupleSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTupleElementSelector(TupleElementSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInstanceSelector(InstanceSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitInstanceElementSelector(InstanceElementSelectorContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitListSelector(ListSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitDisplayClause(DisplayClauseContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitCodeSelector(CodeSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitConceptSelector(ConceptSelectorContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitKeyword(KeywordContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitReservedWord(ReservedWordContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitKeywordIdentifier(KeywordIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitObsoleteIdentifier(ObsoleteIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitFunctionIdentifier(FunctionIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitTypeNameIdentifier(TypeNameIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitReferentialIdentifier(ReferentialIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitReferentialOrTypeNameIdentifier(
          ReferentialOrTypeNameIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIdentifierOrFunctionIdentifier(
          IdentifierOrFunctionIdentifierContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitIdentifier(IdentifierContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitExternalConstant(ExternalConstantContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitParamList(ParamListContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitQuantity(QuantityContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  List? visitUnit(UnitContext ctx) => visitChildren(ctx);
}
