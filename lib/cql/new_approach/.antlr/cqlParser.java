// Generated from /home/grey/dev/fhir/fhir_path/lib/cql/new_approach/cql.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class cqlParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, 
		T__38=39, T__39=40, T__40=41, T__41=42, T__42=43, T__43=44, T__44=45, 
		T__45=46, T__46=47, T__47=48, T__48=49, T__49=50, T__50=51, T__51=52, 
		T__52=53, T__53=54, T__54=55, T__55=56, T__56=57, T__57=58, T__58=59, 
		T__59=60, T__60=61, T__61=62, T__62=63, T__63=64, T__64=65, T__65=66, 
		T__66=67, T__67=68, T__68=69, T__69=70, T__70=71, T__71=72, T__72=73, 
		T__73=74, T__74=75, T__75=76, T__76=77, T__77=78, T__78=79, T__79=80, 
		T__80=81, T__81=82, T__82=83, T__83=84, T__84=85, T__85=86, T__86=87, 
		T__87=88, T__88=89, T__89=90, T__90=91, T__91=92, T__92=93, T__93=94, 
		T__94=95, T__95=96, T__96=97, T__97=98, T__98=99, T__99=100, T__100=101, 
		T__101=102, T__102=103, T__103=104, T__104=105, T__105=106, T__106=107, 
		T__107=108, T__108=109, T__109=110, T__110=111, T__111=112, T__112=113, 
		T__113=114, T__114=115, T__115=116, T__116=117, T__117=118, T__118=119, 
		T__119=120, T__120=121, T__121=122, T__122=123, T__123=124, T__124=125, 
		T__125=126, T__126=127, T__127=128, T__128=129, T__129=130, T__130=131, 
		T__131=132, T__132=133, T__133=134, T__134=135, T__135=136, T__136=137, 
		T__137=138, T__138=139, T__139=140, T__140=141, T__141=142, T__142=143, 
		T__143=144, T__144=145, T__145=146, T__146=147, T__147=148, T__148=149, 
		T__149=150, T__150=151, T__151=152, T__152=153, T__153=154, T__154=155, 
		T__155=156, QUOTEDIDENTIFIER=157, DATETIME=158, LONGNUMBER=159, DATE=160, 
		TIME=161, IDENTIFIER=162, DELIMITEDIDENTIFIER=163, STRING=164, NUMBER=165, 
		WS=166, COMMENT=167, LINE_COMMENT=168;
	public static final int
		RULE_library = 0, RULE_definition = 1, RULE_libraryDefinition = 2, RULE_usingDefinition = 3, 
		RULE_includeDefinition = 4, RULE_localIdentifier = 5, RULE_accessModifier = 6, 
		RULE_parameterDefinition = 7, RULE_codesystemDefinition = 8, RULE_valuesetDefinition = 9, 
		RULE_codesystems = 10, RULE_codesystemIdentifier = 11, RULE_libraryIdentifier = 12, 
		RULE_codeDefinition = 13, RULE_conceptDefinition = 14, RULE_codeIdentifier = 15, 
		RULE_codesystemId = 16, RULE_valuesetId = 17, RULE_versionSpecifier = 18, 
		RULE_codeId = 19, RULE_typeSpecifier = 20, RULE_namedTypeSpecifier = 21, 
		RULE_modelIdentifier = 22, RULE_listTypeSpecifier = 23, RULE_intervalTypeSpecifier = 24, 
		RULE_tupleTypeSpecifier = 25, RULE_tupleElementDefinition = 26, RULE_choiceTypeSpecifier = 27, 
		RULE_statement = 28, RULE_expressionDefinition = 29, RULE_contextDefinition = 30, 
		RULE_functionDefinition = 31, RULE_operandDefinition = 32, RULE_functionBody = 33, 
		RULE_querySource = 34, RULE_aliasedQuerySource = 35, RULE_alias = 36, 
		RULE_queryInclusionClause = 37, RULE_withClause = 38, RULE_withoutClause = 39, 
		RULE_retrieve = 40, RULE_contextIdentifier = 41, RULE_codePath = 42, RULE_codeComparator = 43, 
		RULE_terminology = 44, RULE_qualifier = 45, RULE_query = 46, RULE_sourceClause = 47, 
		RULE_letClause = 48, RULE_letClauseItem = 49, RULE_whereClause = 50, RULE_returnClause = 51, 
		RULE_aggregateClause = 52, RULE_startingClause = 53, RULE_sortClause = 54, 
		RULE_sortDirection = 55, RULE_sortByItem = 56, RULE_qualifiedIdentifier = 57, 
		RULE_qualifiedIdentifierExpression = 58, RULE_qualifierExpression = 59, 
		RULE_simplePath = 60, RULE_simpleLiteral = 61, RULE_expression = 62, RULE_dateTimePrecision = 63, 
		RULE_dateTimeComponent = 64, RULE_pluralDateTimePrecision = 65, RULE_expressionTerm = 66, 
		RULE_caseExpressionItem = 67, RULE_dateTimePrecisionSpecifier = 68, RULE_relativeQualifier = 69, 
		RULE_offsetRelativeQualifier = 70, RULE_exclusiveRelativeQualifier = 71, 
		RULE_quantityOffset = 72, RULE_temporalRelationship = 73, RULE_intervalOperatorPhrase = 74, 
		RULE_term = 75, RULE_qualifiedInvocation = 76, RULE_qualifiedFunction = 77, 
		RULE_invocation = 78, RULE_function = 79, RULE_ratio = 80, RULE_literal = 81, 
		RULE_intervalSelector = 82, RULE_tupleSelector = 83, RULE_tupleElementSelector = 84, 
		RULE_instanceSelector = 85, RULE_instanceElementSelector = 86, RULE_listSelector = 87, 
		RULE_displayClause = 88, RULE_codeSelector = 89, RULE_conceptSelector = 90, 
		RULE_keyword = 91, RULE_reservedWord = 92, RULE_keywordIdentifier = 93, 
		RULE_obsoleteIdentifier = 94, RULE_functionIdentifier = 95, RULE_typeNameIdentifier = 96, 
		RULE_referentialIdentifier = 97, RULE_referentialOrTypeNameIdentifier = 98, 
		RULE_identifierOrFunctionIdentifier = 99, RULE_identifier = 100, RULE_externalConstant = 101, 
		RULE_paramList = 102, RULE_quantity = 103, RULE_unit = 104;
	private static String[] makeRuleNames() {
		return new String[] {
			"library", "definition", "libraryDefinition", "usingDefinition", "includeDefinition", 
			"localIdentifier", "accessModifier", "parameterDefinition", "codesystemDefinition", 
			"valuesetDefinition", "codesystems", "codesystemIdentifier", "libraryIdentifier", 
			"codeDefinition", "conceptDefinition", "codeIdentifier", "codesystemId", 
			"valuesetId", "versionSpecifier", "codeId", "typeSpecifier", "namedTypeSpecifier", 
			"modelIdentifier", "listTypeSpecifier", "intervalTypeSpecifier", "tupleTypeSpecifier", 
			"tupleElementDefinition", "choiceTypeSpecifier", "statement", "expressionDefinition", 
			"contextDefinition", "functionDefinition", "operandDefinition", "functionBody", 
			"querySource", "aliasedQuerySource", "alias", "queryInclusionClause", 
			"withClause", "withoutClause", "retrieve", "contextIdentifier", "codePath", 
			"codeComparator", "terminology", "qualifier", "query", "sourceClause", 
			"letClause", "letClauseItem", "whereClause", "returnClause", "aggregateClause", 
			"startingClause", "sortClause", "sortDirection", "sortByItem", "qualifiedIdentifier", 
			"qualifiedIdentifierExpression", "qualifierExpression", "simplePath", 
			"simpleLiteral", "expression", "dateTimePrecision", "dateTimeComponent", 
			"pluralDateTimePrecision", "expressionTerm", "caseExpressionItem", "dateTimePrecisionSpecifier", 
			"relativeQualifier", "offsetRelativeQualifier", "exclusiveRelativeQualifier", 
			"quantityOffset", "temporalRelationship", "intervalOperatorPhrase", "term", 
			"qualifiedInvocation", "qualifiedFunction", "invocation", "function", 
			"ratio", "literal", "intervalSelector", "tupleSelector", "tupleElementSelector", 
			"instanceSelector", "instanceElementSelector", "listSelector", "displayClause", 
			"codeSelector", "conceptSelector", "keyword", "reservedWord", "keywordIdentifier", 
			"obsoleteIdentifier", "functionIdentifier", "typeNameIdentifier", "referentialIdentifier", 
			"referentialOrTypeNameIdentifier", "identifierOrFunctionIdentifier", 
			"identifier", "externalConstant", "paramList", "quantity", "unit"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'library'", "'version'", "'using'", "'include'", "'called'", "'public'", 
			"'private'", "'parameter'", "'default'", "'codesystem'", "':'", "'valueset'", 
			"'codesystems'", "'{'", "','", "'}'", "'.'", "'code'", "'from'", "'concept'", 
			"'List'", "'<'", "'>'", "'Interval'", "'Tuple'", "'Choice'", "'define'", 
			"'context'", "'fluent'", "'function'", "'('", "')'", "'returns'", "'external'", 
			"'with'", "'such that'", "'without'", "'['", "'->'", "']'", "'in'", "'='", 
			"'~'", "'let'", "'where'", "'return'", "'all'", "'distinct'", "'aggregate'", 
			"'starting'", "'sort'", "'by'", "'asc'", "'ascending'", "'desc'", "'descending'", 
			"'is'", "'not'", "'null'", "'true'", "'false'", "'as'", "'cast'", "'exists'", 
			"'properly'", "'between'", "'and'", "'duration'", "'difference'", "'<='", 
			"'>='", "'!='", "'!~'", "'contains'", "'or'", "'xor'", "'implies'", "'|'", 
			"'union'", "'intersect'", "'except'", "'year'", "'month'", "'week'", 
			"'day'", "'hour'", "'minute'", "'second'", "'millisecond'", "'date'", 
			"'time'", "'timezoneoffset'", "'years'", "'months'", "'weeks'", "'days'", 
			"'hours'", "'minutes'", "'seconds'", "'milliseconds'", "'convert'", "'to'", 
			"'+'", "'-'", "'start'", "'end'", "'of'", "'width'", "'successor'", "'predecessor'", 
			"'singleton'", "'point'", "'minimum'", "'maximum'", "'^'", "'*'", "'/'", 
			"'div'", "'mod'", "'&'", "'if'", "'then'", "'else'", "'case'", "'flatten'", 
			"'expand'", "'collapse'", "'per'", "'when'", "'or before'", "'or after'", 
			"'or more'", "'or less'", "'less than'", "'more than'", "'on or'", "'before'", 
			"'after'", "'or on'", "'starts'", "'ends'", "'occurs'", "'same'", "'includes'", 
			"'during'", "'included in'", "'within'", "'meets'", "'overlaps'", "'$this'", 
			"'$index'", "'$total'", "'display'", "'Code'", "'Concept'", "'%'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, "QUOTEDIDENTIFIER", "DATETIME", "LONGNUMBER", "DATE", "TIME", "IDENTIFIER", 
			"DELIMITEDIDENTIFIER", "STRING", "NUMBER", "WS", "COMMENT", "LINE_COMMENT"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "cql.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public cqlParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class LibraryContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(cqlParser.EOF, 0); }
		public LibraryDefinitionContext libraryDefinition() {
			return getRuleContext(LibraryDefinitionContext.class,0);
		}
		public List<DefinitionContext> definition() {
			return getRuleContexts(DefinitionContext.class);
		}
		public DefinitionContext definition(int i) {
			return getRuleContext(DefinitionContext.class,i);
		}
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public LibraryContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_library; }
	}

	public final LibraryContext library() throws RecognitionException {
		LibraryContext _localctx = new LibraryContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_library);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(211);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__0) {
				{
				setState(210);
				libraryDefinition();
				}
			}

			setState(216);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__9) | (1L << T__11) | (1L << T__17) | (1L << T__19))) != 0)) {
				{
				{
				setState(213);
				definition();
				}
				}
				setState(218);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(222);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__26 || _la==T__27) {
				{
				{
				setState(219);
				statement();
				}
				}
				setState(224);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(225);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DefinitionContext extends ParserRuleContext {
		public UsingDefinitionContext usingDefinition() {
			return getRuleContext(UsingDefinitionContext.class,0);
		}
		public IncludeDefinitionContext includeDefinition() {
			return getRuleContext(IncludeDefinitionContext.class,0);
		}
		public CodesystemDefinitionContext codesystemDefinition() {
			return getRuleContext(CodesystemDefinitionContext.class,0);
		}
		public ValuesetDefinitionContext valuesetDefinition() {
			return getRuleContext(ValuesetDefinitionContext.class,0);
		}
		public CodeDefinitionContext codeDefinition() {
			return getRuleContext(CodeDefinitionContext.class,0);
		}
		public ConceptDefinitionContext conceptDefinition() {
			return getRuleContext(ConceptDefinitionContext.class,0);
		}
		public ParameterDefinitionContext parameterDefinition() {
			return getRuleContext(ParameterDefinitionContext.class,0);
		}
		public DefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_definition; }
	}

	public final DefinitionContext definition() throws RecognitionException {
		DefinitionContext _localctx = new DefinitionContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_definition);
		try {
			setState(234);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(227);
				usingDefinition();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(228);
				includeDefinition();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(229);
				codesystemDefinition();
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(230);
				valuesetDefinition();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(231);
				codeDefinition();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(232);
				conceptDefinition();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(233);
				parameterDefinition();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LibraryDefinitionContext extends ParserRuleContext {
		public QualifiedIdentifierContext qualifiedIdentifier() {
			return getRuleContext(QualifiedIdentifierContext.class,0);
		}
		public VersionSpecifierContext versionSpecifier() {
			return getRuleContext(VersionSpecifierContext.class,0);
		}
		public LibraryDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_libraryDefinition; }
	}

	public final LibraryDefinitionContext libraryDefinition() throws RecognitionException {
		LibraryDefinitionContext _localctx = new LibraryDefinitionContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_libraryDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(236);
			match(T__0);
			setState(237);
			qualifiedIdentifier();
			setState(240);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(238);
				match(T__1);
				setState(239);
				versionSpecifier();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class UsingDefinitionContext extends ParserRuleContext {
		public ModelIdentifierContext modelIdentifier() {
			return getRuleContext(ModelIdentifierContext.class,0);
		}
		public VersionSpecifierContext versionSpecifier() {
			return getRuleContext(VersionSpecifierContext.class,0);
		}
		public UsingDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_usingDefinition; }
	}

	public final UsingDefinitionContext usingDefinition() throws RecognitionException {
		UsingDefinitionContext _localctx = new UsingDefinitionContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_usingDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(242);
			match(T__2);
			setState(243);
			modelIdentifier();
			setState(246);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(244);
				match(T__1);
				setState(245);
				versionSpecifier();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IncludeDefinitionContext extends ParserRuleContext {
		public QualifiedIdentifierContext qualifiedIdentifier() {
			return getRuleContext(QualifiedIdentifierContext.class,0);
		}
		public VersionSpecifierContext versionSpecifier() {
			return getRuleContext(VersionSpecifierContext.class,0);
		}
		public LocalIdentifierContext localIdentifier() {
			return getRuleContext(LocalIdentifierContext.class,0);
		}
		public IncludeDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_includeDefinition; }
	}

	public final IncludeDefinitionContext includeDefinition() throws RecognitionException {
		IncludeDefinitionContext _localctx = new IncludeDefinitionContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_includeDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(248);
			match(T__3);
			setState(249);
			qualifiedIdentifier();
			setState(252);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(250);
				match(T__1);
				setState(251);
				versionSpecifier();
				}
			}

			setState(256);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__4) {
				{
				setState(254);
				match(T__4);
				setState(255);
				localIdentifier();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LocalIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public LocalIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_localIdentifier; }
	}

	public final LocalIdentifierContext localIdentifier() throws RecognitionException {
		LocalIdentifierContext _localctx = new LocalIdentifierContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_localIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(258);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AccessModifierContext extends ParserRuleContext {
		public AccessModifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_accessModifier; }
	}

	public final AccessModifierContext accessModifier() throws RecognitionException {
		AccessModifierContext _localctx = new AccessModifierContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_accessModifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(260);
			_la = _input.LA(1);
			if ( !(_la==T__5 || _la==T__6) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ParameterDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterDefinition; }
	}

	public final ParameterDefinitionContext parameterDefinition() throws RecognitionException {
		ParameterDefinitionContext _localctx = new ParameterDefinitionContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_parameterDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(263);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(262);
				accessModifier();
				}
			}

			setState(265);
			match(T__7);
			setState(266);
			identifier();
			setState(268);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
			case 1:
				{
				setState(267);
				typeSpecifier();
				}
				break;
			}
			setState(272);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__8) {
				{
				setState(270);
				match(T__8);
				setState(271);
				expression(0);
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodesystemDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public CodesystemIdContext codesystemId() {
			return getRuleContext(CodesystemIdContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public VersionSpecifierContext versionSpecifier() {
			return getRuleContext(VersionSpecifierContext.class,0);
		}
		public CodesystemDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codesystemDefinition; }
	}

	public final CodesystemDefinitionContext codesystemDefinition() throws RecognitionException {
		CodesystemDefinitionContext _localctx = new CodesystemDefinitionContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_codesystemDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(275);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(274);
				accessModifier();
				}
			}

			setState(277);
			match(T__9);
			setState(278);
			identifier();
			setState(279);
			match(T__10);
			setState(280);
			codesystemId();
			setState(283);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(281);
				match(T__1);
				setState(282);
				versionSpecifier();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ValuesetDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ValuesetIdContext valuesetId() {
			return getRuleContext(ValuesetIdContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public VersionSpecifierContext versionSpecifier() {
			return getRuleContext(VersionSpecifierContext.class,0);
		}
		public CodesystemsContext codesystems() {
			return getRuleContext(CodesystemsContext.class,0);
		}
		public ValuesetDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_valuesetDefinition; }
	}

	public final ValuesetDefinitionContext valuesetDefinition() throws RecognitionException {
		ValuesetDefinitionContext _localctx = new ValuesetDefinitionContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_valuesetDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(286);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(285);
				accessModifier();
				}
			}

			setState(288);
			match(T__11);
			setState(289);
			identifier();
			setState(290);
			match(T__10);
			setState(291);
			valuesetId();
			setState(294);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(292);
				match(T__1);
				setState(293);
				versionSpecifier();
				}
			}

			setState(297);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__12) {
				{
				setState(296);
				codesystems();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodesystemsContext extends ParserRuleContext {
		public List<CodesystemIdentifierContext> codesystemIdentifier() {
			return getRuleContexts(CodesystemIdentifierContext.class);
		}
		public CodesystemIdentifierContext codesystemIdentifier(int i) {
			return getRuleContext(CodesystemIdentifierContext.class,i);
		}
		public CodesystemsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codesystems; }
	}

	public final CodesystemsContext codesystems() throws RecognitionException {
		CodesystemsContext _localctx = new CodesystemsContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_codesystems);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(299);
			match(T__12);
			setState(300);
			match(T__13);
			setState(301);
			codesystemIdentifier();
			setState(306);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(302);
				match(T__14);
				setState(303);
				codesystemIdentifier();
				}
				}
				setState(308);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(309);
			match(T__15);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodesystemIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public LibraryIdentifierContext libraryIdentifier() {
			return getRuleContext(LibraryIdentifierContext.class,0);
		}
		public CodesystemIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codesystemIdentifier; }
	}

	public final CodesystemIdentifierContext codesystemIdentifier() throws RecognitionException {
		CodesystemIdentifierContext _localctx = new CodesystemIdentifierContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_codesystemIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(314);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
			case 1:
				{
				setState(311);
				libraryIdentifier();
				setState(312);
				match(T__16);
				}
				break;
			}
			setState(316);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LibraryIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public LibraryIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_libraryIdentifier; }
	}

	public final LibraryIdentifierContext libraryIdentifier() throws RecognitionException {
		LibraryIdentifierContext _localctx = new LibraryIdentifierContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_libraryIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(318);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodeDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public CodeIdContext codeId() {
			return getRuleContext(CodeIdContext.class,0);
		}
		public CodesystemIdentifierContext codesystemIdentifier() {
			return getRuleContext(CodesystemIdentifierContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public DisplayClauseContext displayClause() {
			return getRuleContext(DisplayClauseContext.class,0);
		}
		public CodeDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codeDefinition; }
	}

	public final CodeDefinitionContext codeDefinition() throws RecognitionException {
		CodeDefinitionContext _localctx = new CodeDefinitionContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_codeDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(321);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(320);
				accessModifier();
				}
			}

			setState(323);
			match(T__17);
			setState(324);
			identifier();
			setState(325);
			match(T__10);
			setState(326);
			codeId();
			setState(327);
			match(T__18);
			setState(328);
			codesystemIdentifier();
			setState(330);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__152) {
				{
				setState(329);
				displayClause();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ConceptDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public List<CodeIdentifierContext> codeIdentifier() {
			return getRuleContexts(CodeIdentifierContext.class);
		}
		public CodeIdentifierContext codeIdentifier(int i) {
			return getRuleContext(CodeIdentifierContext.class,i);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public DisplayClauseContext displayClause() {
			return getRuleContext(DisplayClauseContext.class,0);
		}
		public ConceptDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_conceptDefinition; }
	}

	public final ConceptDefinitionContext conceptDefinition() throws RecognitionException {
		ConceptDefinitionContext _localctx = new ConceptDefinitionContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_conceptDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(333);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(332);
				accessModifier();
				}
			}

			setState(335);
			match(T__19);
			setState(336);
			identifier();
			setState(337);
			match(T__10);
			setState(338);
			match(T__13);
			setState(339);
			codeIdentifier();
			setState(344);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(340);
				match(T__14);
				setState(341);
				codeIdentifier();
				}
				}
				setState(346);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(347);
			match(T__15);
			setState(349);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__152) {
				{
				setState(348);
				displayClause();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodeIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public LibraryIdentifierContext libraryIdentifier() {
			return getRuleContext(LibraryIdentifierContext.class,0);
		}
		public CodeIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codeIdentifier; }
	}

	public final CodeIdentifierContext codeIdentifier() throws RecognitionException {
		CodeIdentifierContext _localctx = new CodeIdentifierContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_codeIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(354);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
			case 1:
				{
				setState(351);
				libraryIdentifier();
				setState(352);
				match(T__16);
				}
				break;
			}
			setState(356);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodesystemIdContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public CodesystemIdContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codesystemId; }
	}

	public final CodesystemIdContext codesystemId() throws RecognitionException {
		CodesystemIdContext _localctx = new CodesystemIdContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_codesystemId);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(358);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ValuesetIdContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public ValuesetIdContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_valuesetId; }
	}

	public final ValuesetIdContext valuesetId() throws RecognitionException {
		ValuesetIdContext _localctx = new ValuesetIdContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_valuesetId);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(360);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class VersionSpecifierContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public VersionSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_versionSpecifier; }
	}

	public final VersionSpecifierContext versionSpecifier() throws RecognitionException {
		VersionSpecifierContext _localctx = new VersionSpecifierContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_versionSpecifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(362);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodeIdContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public CodeIdContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codeId; }
	}

	public final CodeIdContext codeId() throws RecognitionException {
		CodeIdContext _localctx = new CodeIdContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_codeId);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(364);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeSpecifierContext extends ParserRuleContext {
		public NamedTypeSpecifierContext namedTypeSpecifier() {
			return getRuleContext(NamedTypeSpecifierContext.class,0);
		}
		public ListTypeSpecifierContext listTypeSpecifier() {
			return getRuleContext(ListTypeSpecifierContext.class,0);
		}
		public IntervalTypeSpecifierContext intervalTypeSpecifier() {
			return getRuleContext(IntervalTypeSpecifierContext.class,0);
		}
		public TupleTypeSpecifierContext tupleTypeSpecifier() {
			return getRuleContext(TupleTypeSpecifierContext.class,0);
		}
		public ChoiceTypeSpecifierContext choiceTypeSpecifier() {
			return getRuleContext(ChoiceTypeSpecifierContext.class,0);
		}
		public TypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeSpecifier; }
	}

	public final TypeSpecifierContext typeSpecifier() throws RecognitionException {
		TypeSpecifierContext _localctx = new TypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_typeSpecifier);
		try {
			setState(371);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__19:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__44:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__89:
			case T__90:
			case T__91:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__117:
			case T__118:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__152:
			case T__153:
			case T__154:
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				enterOuterAlt(_localctx, 1);
				{
				setState(366);
				namedTypeSpecifier();
				}
				break;
			case T__20:
				enterOuterAlt(_localctx, 2);
				{
				setState(367);
				listTypeSpecifier();
				}
				break;
			case T__23:
				enterOuterAlt(_localctx, 3);
				{
				setState(368);
				intervalTypeSpecifier();
				}
				break;
			case T__24:
				enterOuterAlt(_localctx, 4);
				{
				setState(369);
				tupleTypeSpecifier();
				}
				break;
			case T__25:
				enterOuterAlt(_localctx, 5);
				{
				setState(370);
				choiceTypeSpecifier();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NamedTypeSpecifierContext extends ParserRuleContext {
		public ReferentialOrTypeNameIdentifierContext referentialOrTypeNameIdentifier() {
			return getRuleContext(ReferentialOrTypeNameIdentifierContext.class,0);
		}
		public List<QualifierContext> qualifier() {
			return getRuleContexts(QualifierContext.class);
		}
		public QualifierContext qualifier(int i) {
			return getRuleContext(QualifierContext.class,i);
		}
		public NamedTypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_namedTypeSpecifier; }
	}

	public final NamedTypeSpecifierContext namedTypeSpecifier() throws RecognitionException {
		NamedTypeSpecifierContext _localctx = new NamedTypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_namedTypeSpecifier);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(378);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(373);
					qualifier();
					setState(374);
					match(T__16);
					}
					} 
				}
				setState(380);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
			}
			setState(381);
			referentialOrTypeNameIdentifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ModelIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ModelIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_modelIdentifier; }
	}

	public final ModelIdentifierContext modelIdentifier() throws RecognitionException {
		ModelIdentifierContext _localctx = new ModelIdentifierContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_modelIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(383);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ListTypeSpecifierContext extends ParserRuleContext {
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public ListTypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_listTypeSpecifier; }
	}

	public final ListTypeSpecifierContext listTypeSpecifier() throws RecognitionException {
		ListTypeSpecifierContext _localctx = new ListTypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_listTypeSpecifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(385);
			match(T__20);
			setState(386);
			match(T__21);
			setState(387);
			typeSpecifier();
			setState(388);
			match(T__22);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IntervalTypeSpecifierContext extends ParserRuleContext {
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public IntervalTypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_intervalTypeSpecifier; }
	}

	public final IntervalTypeSpecifierContext intervalTypeSpecifier() throws RecognitionException {
		IntervalTypeSpecifierContext _localctx = new IntervalTypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_intervalTypeSpecifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(390);
			match(T__23);
			setState(391);
			match(T__21);
			setState(392);
			typeSpecifier();
			setState(393);
			match(T__22);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TupleTypeSpecifierContext extends ParserRuleContext {
		public List<TupleElementDefinitionContext> tupleElementDefinition() {
			return getRuleContexts(TupleElementDefinitionContext.class);
		}
		public TupleElementDefinitionContext tupleElementDefinition(int i) {
			return getRuleContext(TupleElementDefinitionContext.class,i);
		}
		public TupleTypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_tupleTypeSpecifier; }
	}

	public final TupleTypeSpecifierContext tupleTypeSpecifier() throws RecognitionException {
		TupleTypeSpecifierContext _localctx = new TupleTypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_tupleTypeSpecifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(395);
			match(T__24);
			setState(396);
			match(T__13);
			setState(397);
			tupleElementDefinition();
			setState(402);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(398);
				match(T__14);
				setState(399);
				tupleElementDefinition();
				}
				}
				setState(404);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(405);
			match(T__15);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TupleElementDefinitionContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public TupleElementDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_tupleElementDefinition; }
	}

	public final TupleElementDefinitionContext tupleElementDefinition() throws RecognitionException {
		TupleElementDefinitionContext _localctx = new TupleElementDefinitionContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_tupleElementDefinition);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(407);
			referentialIdentifier();
			setState(408);
			typeSpecifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ChoiceTypeSpecifierContext extends ParserRuleContext {
		public List<TypeSpecifierContext> typeSpecifier() {
			return getRuleContexts(TypeSpecifierContext.class);
		}
		public TypeSpecifierContext typeSpecifier(int i) {
			return getRuleContext(TypeSpecifierContext.class,i);
		}
		public ChoiceTypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_choiceTypeSpecifier; }
	}

	public final ChoiceTypeSpecifierContext choiceTypeSpecifier() throws RecognitionException {
		ChoiceTypeSpecifierContext _localctx = new ChoiceTypeSpecifierContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_choiceTypeSpecifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(410);
			match(T__25);
			setState(411);
			match(T__21);
			setState(412);
			typeSpecifier();
			setState(417);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(413);
				match(T__14);
				setState(414);
				typeSpecifier();
				}
				}
				setState(419);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(420);
			match(T__22);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StatementContext extends ParserRuleContext {
		public ExpressionDefinitionContext expressionDefinition() {
			return getRuleContext(ExpressionDefinitionContext.class,0);
		}
		public ContextDefinitionContext contextDefinition() {
			return getRuleContext(ContextDefinitionContext.class,0);
		}
		public FunctionDefinitionContext functionDefinition() {
			return getRuleContext(FunctionDefinitionContext.class,0);
		}
		public StatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_statement; }
	}

	public final StatementContext statement() throws RecognitionException {
		StatementContext _localctx = new StatementContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_statement);
		try {
			setState(425);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,28,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(422);
				expressionDefinition();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(423);
				contextDefinition();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(424);
				functionDefinition();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public ExpressionDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expressionDefinition; }
	}

	public final ExpressionDefinitionContext expressionDefinition() throws RecognitionException {
		ExpressionDefinitionContext _localctx = new ExpressionDefinitionContext(_ctx, getState());
		enterRule(_localctx, 58, RULE_expressionDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(427);
			match(T__26);
			setState(429);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(428);
				accessModifier();
				}
			}

			setState(431);
			identifier();
			setState(432);
			match(T__10);
			setState(433);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ContextDefinitionContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ModelIdentifierContext modelIdentifier() {
			return getRuleContext(ModelIdentifierContext.class,0);
		}
		public ContextDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_contextDefinition; }
	}

	public final ContextDefinitionContext contextDefinition() throws RecognitionException {
		ContextDefinitionContext _localctx = new ContextDefinitionContext(_ctx, getState());
		enterRule(_localctx, 60, RULE_contextDefinition);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(435);
			match(T__27);
			setState(439);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,30,_ctx) ) {
			case 1:
				{
				setState(436);
				modelIdentifier();
				setState(437);
				match(T__16);
				}
				break;
			}
			setState(441);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FunctionDefinitionContext extends ParserRuleContext {
		public IdentifierOrFunctionIdentifierContext identifierOrFunctionIdentifier() {
			return getRuleContext(IdentifierOrFunctionIdentifierContext.class,0);
		}
		public FunctionBodyContext functionBody() {
			return getRuleContext(FunctionBodyContext.class,0);
		}
		public AccessModifierContext accessModifier() {
			return getRuleContext(AccessModifierContext.class,0);
		}
		public List<OperandDefinitionContext> operandDefinition() {
			return getRuleContexts(OperandDefinitionContext.class);
		}
		public OperandDefinitionContext operandDefinition(int i) {
			return getRuleContext(OperandDefinitionContext.class,i);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public FunctionDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_functionDefinition; }
	}

	public final FunctionDefinitionContext functionDefinition() throws RecognitionException {
		FunctionDefinitionContext _localctx = new FunctionDefinitionContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_functionDefinition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(443);
			match(T__26);
			setState(445);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__5 || _la==T__6) {
				{
				setState(444);
				accessModifier();
				}
			}

			setState(448);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__28) {
				{
				setState(447);
				match(T__28);
				}
			}

			setState(450);
			match(T__29);
			setState(451);
			identifierOrFunctionIdentifier();
			setState(452);
			match(T__30);
			setState(461);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__17) | (1L << T__19) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__44) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (T__73 - 74)) | (1L << (T__75 - 74)) | (1L << (T__76 - 74)) | (1L << (T__78 - 74)) | (1L << (T__79 - 74)) | (1L << (T__80 - 74)) | (1L << (T__89 - 74)) | (1L << (T__90 - 74)) | (1L << (T__91 - 74)) | (1L << (T__104 - 74)) | (1L << (T__105 - 74)) | (1L << (T__107 - 74)) | (1L << (T__108 - 74)) | (1L << (T__109 - 74)) | (1L << (T__117 - 74)) | (1L << (T__118 - 74)) | (1L << (T__129 - 74)) | (1L << (T__130 - 74)) | (1L << (T__131 - 74)) | (1L << (T__132 - 74)))) != 0) || ((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__143 - 140)) | (1L << (T__147 - 140)) | (1L << (T__148 - 140)) | (1L << (T__152 - 140)) | (1L << (QUOTEDIDENTIFIER - 140)) | (1L << (IDENTIFIER - 140)) | (1L << (DELIMITEDIDENTIFIER - 140)))) != 0)) {
				{
				setState(453);
				operandDefinition();
				setState(458);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__14) {
					{
					{
					setState(454);
					match(T__14);
					setState(455);
					operandDefinition();
					}
					}
					setState(460);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(463);
			match(T__31);
			setState(466);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__32) {
				{
				setState(464);
				match(T__32);
				setState(465);
				typeSpecifier();
				}
			}

			setState(468);
			match(T__10);
			setState(471);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__13:
			case T__17:
			case T__18:
			case T__19:
			case T__20:
			case T__23:
			case T__24:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__30:
			case T__37:
			case T__44:
			case T__47:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__57:
			case T__58:
			case T__59:
			case T__60:
			case T__62:
			case T__63:
			case T__67:
			case T__68:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__81:
			case T__82:
			case T__83:
			case T__84:
			case T__85:
			case T__86:
			case T__87:
			case T__88:
			case T__89:
			case T__90:
			case T__91:
			case T__92:
			case T__93:
			case T__94:
			case T__95:
			case T__96:
			case T__97:
			case T__98:
			case T__99:
			case T__100:
			case T__102:
			case T__103:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__110:
			case T__111:
			case T__112:
			case T__113:
			case T__117:
			case T__118:
			case T__120:
			case T__123:
			case T__124:
			case T__125:
			case T__126:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__149:
			case T__150:
			case T__151:
			case T__152:
			case T__153:
			case T__154:
			case T__155:
			case QUOTEDIDENTIFIER:
			case DATETIME:
			case LONGNUMBER:
			case DATE:
			case TIME:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
			case STRING:
			case NUMBER:
				{
				setState(469);
				functionBody();
				}
				break;
			case T__33:
				{
				setState(470);
				match(T__33);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OperandDefinitionContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public OperandDefinitionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_operandDefinition; }
	}

	public final OperandDefinitionContext operandDefinition() throws RecognitionException {
		OperandDefinitionContext _localctx = new OperandDefinitionContext(_ctx, getState());
		enterRule(_localctx, 64, RULE_operandDefinition);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(473);
			referentialIdentifier();
			setState(474);
			typeSpecifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FunctionBodyContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public FunctionBodyContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_functionBody; }
	}

	public final FunctionBodyContext functionBody() throws RecognitionException {
		FunctionBodyContext _localctx = new FunctionBodyContext(_ctx, getState());
		enterRule(_localctx, 66, RULE_functionBody);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(476);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QuerySourceContext extends ParserRuleContext {
		public RetrieveContext retrieve() {
			return getRuleContext(RetrieveContext.class,0);
		}
		public QualifiedIdentifierExpressionContext qualifiedIdentifierExpression() {
			return getRuleContext(QualifiedIdentifierExpressionContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public QuerySourceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_querySource; }
	}

	public final QuerySourceContext querySource() throws RecognitionException {
		QuerySourceContext _localctx = new QuerySourceContext(_ctx, getState());
		enterRule(_localctx, 68, RULE_querySource);
		try {
			setState(484);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__37:
				enterOuterAlt(_localctx, 1);
				{
				setState(478);
				retrieve();
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__19:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__44:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__89:
			case T__90:
			case T__91:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__117:
			case T__118:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__152:
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				enterOuterAlt(_localctx, 2);
				{
				setState(479);
				qualifiedIdentifierExpression();
				}
				break;
			case T__30:
				enterOuterAlt(_localctx, 3);
				{
				setState(480);
				match(T__30);
				setState(481);
				expression(0);
				setState(482);
				match(T__31);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AliasedQuerySourceContext extends ParserRuleContext {
		public QuerySourceContext querySource() {
			return getRuleContext(QuerySourceContext.class,0);
		}
		public AliasContext alias() {
			return getRuleContext(AliasContext.class,0);
		}
		public AliasedQuerySourceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_aliasedQuerySource; }
	}

	public final AliasedQuerySourceContext aliasedQuerySource() throws RecognitionException {
		AliasedQuerySourceContext _localctx = new AliasedQuerySourceContext(_ctx, getState());
		enterRule(_localctx, 70, RULE_aliasedQuerySource);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(486);
			querySource();
			setState(487);
			alias();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AliasContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public AliasContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_alias; }
	}

	public final AliasContext alias() throws RecognitionException {
		AliasContext _localctx = new AliasContext(_ctx, getState());
		enterRule(_localctx, 72, RULE_alias);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(489);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QueryInclusionClauseContext extends ParserRuleContext {
		public WithClauseContext withClause() {
			return getRuleContext(WithClauseContext.class,0);
		}
		public WithoutClauseContext withoutClause() {
			return getRuleContext(WithoutClauseContext.class,0);
		}
		public QueryInclusionClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_queryInclusionClause; }
	}

	public final QueryInclusionClauseContext queryInclusionClause() throws RecognitionException {
		QueryInclusionClauseContext _localctx = new QueryInclusionClauseContext(_ctx, getState());
		enterRule(_localctx, 74, RULE_queryInclusionClause);
		try {
			setState(493);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__34:
				enterOuterAlt(_localctx, 1);
				{
				setState(491);
				withClause();
				}
				break;
			case T__36:
				enterOuterAlt(_localctx, 2);
				{
				setState(492);
				withoutClause();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class WithClauseContext extends ParserRuleContext {
		public AliasedQuerySourceContext aliasedQuerySource() {
			return getRuleContext(AliasedQuerySourceContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public WithClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_withClause; }
	}

	public final WithClauseContext withClause() throws RecognitionException {
		WithClauseContext _localctx = new WithClauseContext(_ctx, getState());
		enterRule(_localctx, 76, RULE_withClause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(495);
			match(T__34);
			setState(496);
			aliasedQuerySource();
			setState(497);
			match(T__35);
			setState(498);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class WithoutClauseContext extends ParserRuleContext {
		public AliasedQuerySourceContext aliasedQuerySource() {
			return getRuleContext(AliasedQuerySourceContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public WithoutClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_withoutClause; }
	}

	public final WithoutClauseContext withoutClause() throws RecognitionException {
		WithoutClauseContext _localctx = new WithoutClauseContext(_ctx, getState());
		enterRule(_localctx, 78, RULE_withoutClause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(500);
			match(T__36);
			setState(501);
			aliasedQuerySource();
			setState(502);
			match(T__35);
			setState(503);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RetrieveContext extends ParserRuleContext {
		public NamedTypeSpecifierContext namedTypeSpecifier() {
			return getRuleContext(NamedTypeSpecifierContext.class,0);
		}
		public ContextIdentifierContext contextIdentifier() {
			return getRuleContext(ContextIdentifierContext.class,0);
		}
		public TerminologyContext terminology() {
			return getRuleContext(TerminologyContext.class,0);
		}
		public CodePathContext codePath() {
			return getRuleContext(CodePathContext.class,0);
		}
		public CodeComparatorContext codeComparator() {
			return getRuleContext(CodeComparatorContext.class,0);
		}
		public RetrieveContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_retrieve; }
	}

	public final RetrieveContext retrieve() throws RecognitionException {
		RetrieveContext _localctx = new RetrieveContext(_ctx, getState());
		enterRule(_localctx, 80, RULE_retrieve);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(505);
			match(T__37);
			setState(509);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,39,_ctx) ) {
			case 1:
				{
				setState(506);
				contextIdentifier();
				setState(507);
				match(T__38);
				}
				break;
			}
			setState(511);
			namedTypeSpecifier();
			setState(519);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__10) {
				{
				setState(512);
				match(T__10);
				setState(516);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,40,_ctx) ) {
				case 1:
					{
					setState(513);
					codePath();
					setState(514);
					codeComparator();
					}
					break;
				}
				setState(518);
				terminology();
				}
			}

			setState(521);
			match(T__39);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ContextIdentifierContext extends ParserRuleContext {
		public QualifiedIdentifierExpressionContext qualifiedIdentifierExpression() {
			return getRuleContext(QualifiedIdentifierExpressionContext.class,0);
		}
		public ContextIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_contextIdentifier; }
	}

	public final ContextIdentifierContext contextIdentifier() throws RecognitionException {
		ContextIdentifierContext _localctx = new ContextIdentifierContext(_ctx, getState());
		enterRule(_localctx, 82, RULE_contextIdentifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(523);
			qualifiedIdentifierExpression();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodePathContext extends ParserRuleContext {
		public SimplePathContext simplePath() {
			return getRuleContext(SimplePathContext.class,0);
		}
		public CodePathContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codePath; }
	}

	public final CodePathContext codePath() throws RecognitionException {
		CodePathContext _localctx = new CodePathContext(_ctx, getState());
		enterRule(_localctx, 84, RULE_codePath);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(525);
			simplePath(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodeComparatorContext extends ParserRuleContext {
		public CodeComparatorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codeComparator; }
	}

	public final CodeComparatorContext codeComparator() throws RecognitionException {
		CodeComparatorContext _localctx = new CodeComparatorContext(_ctx, getState());
		enterRule(_localctx, 86, RULE_codeComparator);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(527);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__40) | (1L << T__41) | (1L << T__42))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TerminologyContext extends ParserRuleContext {
		public QualifiedIdentifierExpressionContext qualifiedIdentifierExpression() {
			return getRuleContext(QualifiedIdentifierExpressionContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminologyContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_terminology; }
	}

	public final TerminologyContext terminology() throws RecognitionException {
		TerminologyContext _localctx = new TerminologyContext(_ctx, getState());
		enterRule(_localctx, 88, RULE_terminology);
		try {
			setState(531);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,42,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(529);
				qualifiedIdentifierExpression();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(530);
				expression(0);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public QualifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifier; }
	}

	public final QualifierContext qualifier() throws RecognitionException {
		QualifierContext _localctx = new QualifierContext(_ctx, getState());
		enterRule(_localctx, 90, RULE_qualifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(533);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QueryContext extends ParserRuleContext {
		public SourceClauseContext sourceClause() {
			return getRuleContext(SourceClauseContext.class,0);
		}
		public LetClauseContext letClause() {
			return getRuleContext(LetClauseContext.class,0);
		}
		public List<QueryInclusionClauseContext> queryInclusionClause() {
			return getRuleContexts(QueryInclusionClauseContext.class);
		}
		public QueryInclusionClauseContext queryInclusionClause(int i) {
			return getRuleContext(QueryInclusionClauseContext.class,i);
		}
		public WhereClauseContext whereClause() {
			return getRuleContext(WhereClauseContext.class,0);
		}
		public AggregateClauseContext aggregateClause() {
			return getRuleContext(AggregateClauseContext.class,0);
		}
		public ReturnClauseContext returnClause() {
			return getRuleContext(ReturnClauseContext.class,0);
		}
		public SortClauseContext sortClause() {
			return getRuleContext(SortClauseContext.class,0);
		}
		public QueryContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_query; }
	}

	public final QueryContext query() throws RecognitionException {
		QueryContext _localctx = new QueryContext(_ctx, getState());
		enterRule(_localctx, 92, RULE_query);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(535);
			sourceClause();
			setState(537);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,43,_ctx) ) {
			case 1:
				{
				setState(536);
				letClause();
				}
				break;
			}
			setState(542);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,44,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(539);
					queryInclusionClause();
					}
					} 
				}
				setState(544);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,44,_ctx);
			}
			setState(546);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,45,_ctx) ) {
			case 1:
				{
				setState(545);
				whereClause();
				}
				break;
			}
			setState(550);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,46,_ctx) ) {
			case 1:
				{
				setState(548);
				aggregateClause();
				}
				break;
			case 2:
				{
				setState(549);
				returnClause();
				}
				break;
			}
			setState(553);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,47,_ctx) ) {
			case 1:
				{
				setState(552);
				sortClause();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SourceClauseContext extends ParserRuleContext {
		public List<AliasedQuerySourceContext> aliasedQuerySource() {
			return getRuleContexts(AliasedQuerySourceContext.class);
		}
		public AliasedQuerySourceContext aliasedQuerySource(int i) {
			return getRuleContext(AliasedQuerySourceContext.class,i);
		}
		public SourceClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sourceClause; }
	}

	public final SourceClauseContext sourceClause() throws RecognitionException {
		SourceClauseContext _localctx = new SourceClauseContext(_ctx, getState());
		enterRule(_localctx, 94, RULE_sourceClause);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(556);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__18) {
				{
				setState(555);
				match(T__18);
				}
			}

			setState(558);
			aliasedQuerySource();
			setState(563);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,49,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(559);
					match(T__14);
					setState(560);
					aliasedQuerySource();
					}
					} 
				}
				setState(565);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,49,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LetClauseContext extends ParserRuleContext {
		public List<LetClauseItemContext> letClauseItem() {
			return getRuleContexts(LetClauseItemContext.class);
		}
		public LetClauseItemContext letClauseItem(int i) {
			return getRuleContext(LetClauseItemContext.class,i);
		}
		public LetClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_letClause; }
	}

	public final LetClauseContext letClause() throws RecognitionException {
		LetClauseContext _localctx = new LetClauseContext(_ctx, getState());
		enterRule(_localctx, 96, RULE_letClause);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(566);
			match(T__43);
			setState(567);
			letClauseItem();
			setState(572);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,50,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(568);
					match(T__14);
					setState(569);
					letClauseItem();
					}
					} 
				}
				setState(574);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,50,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LetClauseItemContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public LetClauseItemContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_letClauseItem; }
	}

	public final LetClauseItemContext letClauseItem() throws RecognitionException {
		LetClauseItemContext _localctx = new LetClauseItemContext(_ctx, getState());
		enterRule(_localctx, 98, RULE_letClauseItem);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(575);
			identifier();
			setState(576);
			match(T__10);
			setState(577);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class WhereClauseContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public WhereClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_whereClause; }
	}

	public final WhereClauseContext whereClause() throws RecognitionException {
		WhereClauseContext _localctx = new WhereClauseContext(_ctx, getState());
		enterRule(_localctx, 100, RULE_whereClause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(579);
			match(T__44);
			setState(580);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReturnClauseContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ReturnClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_returnClause; }
	}

	public final ReturnClauseContext returnClause() throws RecognitionException {
		ReturnClauseContext _localctx = new ReturnClauseContext(_ctx, getState());
		enterRule(_localctx, 102, RULE_returnClause);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(582);
			match(T__45);
			setState(584);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,51,_ctx) ) {
			case 1:
				{
				setState(583);
				_la = _input.LA(1);
				if ( !(_la==T__46 || _la==T__47) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				break;
			}
			setState(586);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AggregateClauseContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public StartingClauseContext startingClause() {
			return getRuleContext(StartingClauseContext.class,0);
		}
		public AggregateClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_aggregateClause; }
	}

	public final AggregateClauseContext aggregateClause() throws RecognitionException {
		AggregateClauseContext _localctx = new AggregateClauseContext(_ctx, getState());
		enterRule(_localctx, 104, RULE_aggregateClause);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(588);
			match(T__48);
			setState(590);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__46 || _la==T__47) {
				{
				setState(589);
				_la = _input.LA(1);
				if ( !(_la==T__46 || _la==T__47) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
			}

			setState(592);
			identifier();
			setState(594);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__49) {
				{
				setState(593);
				startingClause();
				}
			}

			setState(596);
			match(T__10);
			setState(597);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StartingClauseContext extends ParserRuleContext {
		public SimpleLiteralContext simpleLiteral() {
			return getRuleContext(SimpleLiteralContext.class,0);
		}
		public QuantityContext quantity() {
			return getRuleContext(QuantityContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public StartingClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_startingClause; }
	}

	public final StartingClauseContext startingClause() throws RecognitionException {
		StartingClauseContext _localctx = new StartingClauseContext(_ctx, getState());
		enterRule(_localctx, 106, RULE_startingClause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(599);
			match(T__49);
			setState(606);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,54,_ctx) ) {
			case 1:
				{
				setState(600);
				simpleLiteral();
				}
				break;
			case 2:
				{
				setState(601);
				quantity();
				}
				break;
			case 3:
				{
				{
				setState(602);
				match(T__30);
				setState(603);
				expression(0);
				setState(604);
				match(T__31);
				}
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SortClauseContext extends ParserRuleContext {
		public SortDirectionContext sortDirection() {
			return getRuleContext(SortDirectionContext.class,0);
		}
		public List<SortByItemContext> sortByItem() {
			return getRuleContexts(SortByItemContext.class);
		}
		public SortByItemContext sortByItem(int i) {
			return getRuleContext(SortByItemContext.class,i);
		}
		public SortClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sortClause; }
	}

	public final SortClauseContext sortClause() throws RecognitionException {
		SortClauseContext _localctx = new SortClauseContext(_ctx, getState());
		enterRule(_localctx, 108, RULE_sortClause);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(608);
			match(T__50);
			setState(619);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__52:
			case T__53:
			case T__54:
			case T__55:
				{
				setState(609);
				sortDirection();
				}
				break;
			case T__51:
				{
				{
				setState(610);
				match(T__51);
				setState(611);
				sortByItem();
				setState(616);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(612);
						match(T__14);
						setState(613);
						sortByItem();
						}
						} 
					}
					setState(618);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
				}
				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SortDirectionContext extends ParserRuleContext {
		public SortDirectionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sortDirection; }
	}

	public final SortDirectionContext sortDirection() throws RecognitionException {
		SortDirectionContext _localctx = new SortDirectionContext(_ctx, getState());
		enterRule(_localctx, 110, RULE_sortDirection);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(621);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SortByItemContext extends ParserRuleContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public SortDirectionContext sortDirection() {
			return getRuleContext(SortDirectionContext.class,0);
		}
		public SortByItemContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sortByItem; }
	}

	public final SortByItemContext sortByItem() throws RecognitionException {
		SortByItemContext _localctx = new SortByItemContext(_ctx, getState());
		enterRule(_localctx, 112, RULE_sortByItem);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(623);
			expressionTerm(0);
			setState(625);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,57,_ctx) ) {
			case 1:
				{
				setState(624);
				sortDirection();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifiedIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public List<QualifierContext> qualifier() {
			return getRuleContexts(QualifierContext.class);
		}
		public QualifierContext qualifier(int i) {
			return getRuleContext(QualifierContext.class,i);
		}
		public QualifiedIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifiedIdentifier; }
	}

	public final QualifiedIdentifierContext qualifiedIdentifier() throws RecognitionException {
		QualifiedIdentifierContext _localctx = new QualifiedIdentifierContext(_ctx, getState());
		enterRule(_localctx, 114, RULE_qualifiedIdentifier);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(632);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,58,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(627);
					qualifier();
					setState(628);
					match(T__16);
					}
					} 
				}
				setState(634);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,58,_ctx);
			}
			setState(635);
			identifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifiedIdentifierExpressionContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public List<QualifierExpressionContext> qualifierExpression() {
			return getRuleContexts(QualifierExpressionContext.class);
		}
		public QualifierExpressionContext qualifierExpression(int i) {
			return getRuleContext(QualifierExpressionContext.class,i);
		}
		public QualifiedIdentifierExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifiedIdentifierExpression; }
	}

	public final QualifiedIdentifierExpressionContext qualifiedIdentifierExpression() throws RecognitionException {
		QualifiedIdentifierExpressionContext _localctx = new QualifiedIdentifierExpressionContext(_ctx, getState());
		enterRule(_localctx, 116, RULE_qualifiedIdentifierExpression);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(642);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,59,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(637);
					qualifierExpression();
					setState(638);
					match(T__16);
					}
					} 
				}
				setState(644);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,59,_ctx);
			}
			setState(645);
			referentialIdentifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifierExpressionContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public QualifierExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifierExpression; }
	}

	public final QualifierExpressionContext qualifierExpression() throws RecognitionException {
		QualifierExpressionContext _localctx = new QualifierExpressionContext(_ctx, getState());
		enterRule(_localctx, 118, RULE_qualifierExpression);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(647);
			referentialIdentifier();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SimplePathContext extends ParserRuleContext {
		public SimplePathContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_simplePath; }
	 
		public SimplePathContext() { }
		public void copyFrom(SimplePathContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class SimplePathIndexerContext extends SimplePathContext {
		public SimplePathContext simplePath() {
			return getRuleContext(SimplePathContext.class,0);
		}
		public SimpleLiteralContext simpleLiteral() {
			return getRuleContext(SimpleLiteralContext.class,0);
		}
		public SimplePathIndexerContext(SimplePathContext ctx) { copyFrom(ctx); }
	}
	public static class SimplePathQualifiedIdentifierContext extends SimplePathContext {
		public SimplePathContext simplePath() {
			return getRuleContext(SimplePathContext.class,0);
		}
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public SimplePathQualifiedIdentifierContext(SimplePathContext ctx) { copyFrom(ctx); }
	}
	public static class SimplePathReferentialIdentifierContext extends SimplePathContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public SimplePathReferentialIdentifierContext(SimplePathContext ctx) { copyFrom(ctx); }
	}

	public final SimplePathContext simplePath() throws RecognitionException {
		return simplePath(0);
	}

	private SimplePathContext simplePath(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		SimplePathContext _localctx = new SimplePathContext(_ctx, _parentState);
		SimplePathContext _prevctx = _localctx;
		int _startState = 120;
		enterRecursionRule(_localctx, 120, RULE_simplePath, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new SimplePathReferentialIdentifierContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(650);
			referentialIdentifier();
			}
			_ctx.stop = _input.LT(-1);
			setState(662);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,61,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(660);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,60,_ctx) ) {
					case 1:
						{
						_localctx = new SimplePathQualifiedIdentifierContext(new SimplePathContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_simplePath);
						setState(652);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(653);
						match(T__16);
						setState(654);
						referentialIdentifier();
						}
						break;
					case 2:
						{
						_localctx = new SimplePathIndexerContext(new SimplePathContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_simplePath);
						setState(655);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(656);
						match(T__37);
						setState(657);
						simpleLiteral();
						setState(658);
						match(T__39);
						}
						break;
					}
					} 
				}
				setState(664);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,61,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class SimpleLiteralContext extends ParserRuleContext {
		public SimpleLiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_simpleLiteral; }
	 
		public SimpleLiteralContext() { }
		public void copyFrom(SimpleLiteralContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class SimpleNumberLiteralContext extends SimpleLiteralContext {
		public TerminalNode NUMBER() { return getToken(cqlParser.NUMBER, 0); }
		public SimpleNumberLiteralContext(SimpleLiteralContext ctx) { copyFrom(ctx); }
	}
	public static class SimpleStringLiteralContext extends SimpleLiteralContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public SimpleStringLiteralContext(SimpleLiteralContext ctx) { copyFrom(ctx); }
	}

	public final SimpleLiteralContext simpleLiteral() throws RecognitionException {
		SimpleLiteralContext _localctx = new SimpleLiteralContext(_ctx, getState());
		enterRule(_localctx, 122, RULE_simpleLiteral);
		try {
			setState(667);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case STRING:
				_localctx = new SimpleStringLiteralContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(665);
				match(STRING);
				}
				break;
			case NUMBER:
				_localctx = new SimpleNumberLiteralContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(666);
				match(NUMBER);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionContext extends ParserRuleContext {
		public ExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expression; }
	 
		public ExpressionContext() { }
		public void copyFrom(ExpressionContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DurationBetweenExpressionContext extends ExpressionContext {
		public PluralDateTimePrecisionContext pluralDateTimePrecision() {
			return getRuleContext(PluralDateTimePrecisionContext.class,0);
		}
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public DurationBetweenExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class InFixSetExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public InFixSetExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class RetrieveExpressionContext extends ExpressionContext {
		public RetrieveContext retrieve() {
			return getRuleContext(RetrieveContext.class,0);
		}
		public RetrieveExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class TimingExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public IntervalOperatorPhraseContext intervalOperatorPhrase() {
			return getRuleContext(IntervalOperatorPhraseContext.class,0);
		}
		public TimingExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class QueryExpressionContext extends ExpressionContext {
		public QueryContext query() {
			return getRuleContext(QueryContext.class,0);
		}
		public QueryExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class NotExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public NotExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class BooleanExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public BooleanExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class OrExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public OrExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class CastExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public CastExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class AndExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public AndExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class BetweenExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public BetweenExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class MembershipExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public MembershipExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class DifferenceBetweenExpressionContext extends ExpressionContext {
		public PluralDateTimePrecisionContext pluralDateTimePrecision() {
			return getRuleContext(PluralDateTimePrecisionContext.class,0);
		}
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public DifferenceBetweenExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class InequalityExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public InequalityExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class EqualityExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public EqualityExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class ExistenceExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ExistenceExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class ImpliesExpressionContext extends ExpressionContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public ImpliesExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class TermExpressionContext extends ExpressionContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public TermExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}
	public static class TypeExpressionContext extends ExpressionContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public TypeExpressionContext(ExpressionContext ctx) { copyFrom(ctx); }
	}

	public final ExpressionContext expression() throws RecognitionException {
		return expression(0);
	}

	private ExpressionContext expression(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExpressionContext _localctx = new ExpressionContext(_ctx, _parentState);
		ExpressionContext _prevctx = _localctx;
		int _startState = 124;
		enterRecursionRule(_localctx, 124, RULE_expression, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(700);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,64,_ctx) ) {
			case 1:
				{
				_localctx = new TermExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(670);
				expressionTerm(0);
				}
				break;
			case 2:
				{
				_localctx = new RetrieveExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(671);
				retrieve();
				}
				break;
			case 3:
				{
				_localctx = new QueryExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(672);
				query();
				}
				break;
			case 4:
				{
				_localctx = new CastExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(673);
				match(T__62);
				setState(674);
				expression(0);
				setState(675);
				match(T__61);
				setState(676);
				typeSpecifier();
				}
				break;
			case 5:
				{
				_localctx = new NotExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(678);
				match(T__57);
				setState(679);
				expression(13);
				}
				break;
			case 6:
				{
				_localctx = new ExistenceExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(680);
				match(T__63);
				setState(681);
				expression(12);
				}
				break;
			case 7:
				{
				_localctx = new DurationBetweenExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(684);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__67) {
					{
					setState(682);
					match(T__67);
					setState(683);
					match(T__40);
					}
				}

				setState(686);
				pluralDateTimePrecision();
				setState(687);
				match(T__65);
				setState(688);
				expressionTerm(0);
				setState(689);
				match(T__66);
				setState(690);
				expressionTerm(0);
				}
				break;
			case 8:
				{
				_localctx = new DifferenceBetweenExpressionContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(692);
				match(T__68);
				setState(693);
				match(T__40);
				setState(694);
				pluralDateTimePrecision();
				setState(695);
				match(T__65);
				setState(696);
				expressionTerm(0);
				setState(697);
				match(T__66);
				setState(698);
				expressionTerm(0);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(750);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,69,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(748);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,68,_ctx) ) {
					case 1:
						{
						_localctx = new InequalityExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(702);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(703);
						_la = _input.LA(1);
						if ( !(((((_la - 22)) & ~0x3f) == 0 && ((1L << (_la - 22)) & ((1L << (T__21 - 22)) | (1L << (T__22 - 22)) | (1L << (T__69 - 22)) | (1L << (T__70 - 22)))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(704);
						expression(9);
						}
						break;
					case 2:
						{
						_localctx = new TimingExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(705);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(706);
						intervalOperatorPhrase();
						setState(707);
						expression(8);
						}
						break;
					case 3:
						{
						_localctx = new EqualityExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(709);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(710);
						_la = _input.LA(1);
						if ( !(((((_la - 42)) & ~0x3f) == 0 && ((1L << (_la - 42)) & ((1L << (T__41 - 42)) | (1L << (T__42 - 42)) | (1L << (T__71 - 42)) | (1L << (T__72 - 42)))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(711);
						expression(7);
						}
						break;
					case 4:
						{
						_localctx = new MembershipExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(712);
						if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
						setState(713);
						_la = _input.LA(1);
						if ( !(_la==T__40 || _la==T__73) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(715);
						_errHandler.sync(this);
						switch ( getInterpreter().adaptivePredict(_input,65,_ctx) ) {
						case 1:
							{
							setState(714);
							dateTimePrecisionSpecifier();
							}
							break;
						}
						setState(717);
						expression(6);
						}
						break;
					case 5:
						{
						_localctx = new AndExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(718);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(719);
						match(T__66);
						setState(720);
						expression(5);
						}
						break;
					case 6:
						{
						_localctx = new OrExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(721);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(722);
						_la = _input.LA(1);
						if ( !(_la==T__74 || _la==T__75) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(723);
						expression(4);
						}
						break;
					case 7:
						{
						_localctx = new ImpliesExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(724);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(725);
						match(T__76);
						setState(726);
						expression(3);
						}
						break;
					case 8:
						{
						_localctx = new InFixSetExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(727);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(728);
						_la = _input.LA(1);
						if ( !(((((_la - 78)) & ~0x3f) == 0 && ((1L << (_la - 78)) & ((1L << (T__77 - 78)) | (1L << (T__78 - 78)) | (1L << (T__79 - 78)) | (1L << (T__80 - 78)))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(729);
						expression(2);
						}
						break;
					case 9:
						{
						_localctx = new BooleanExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(730);
						if (!(precpred(_ctx, 16))) throw new FailedPredicateException(this, "precpred(_ctx, 16)");
						setState(731);
						match(T__56);
						setState(733);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if (_la==T__57) {
							{
							setState(732);
							match(T__57);
							}
						}

						setState(735);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__58) | (1L << T__59) | (1L << T__60))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						}
						break;
					case 10:
						{
						_localctx = new TypeExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(736);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(737);
						_la = _input.LA(1);
						if ( !(_la==T__56 || _la==T__61) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(738);
						typeSpecifier();
						}
						break;
					case 11:
						{
						_localctx = new BetweenExpressionContext(new ExpressionContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(739);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						setState(741);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if (_la==T__64) {
							{
							setState(740);
							match(T__64);
							}
						}

						setState(743);
						match(T__65);
						setState(744);
						expressionTerm(0);
						setState(745);
						match(T__66);
						setState(746);
						expressionTerm(0);
						}
						break;
					}
					} 
				}
				setState(752);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,69,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class DateTimePrecisionContext extends ParserRuleContext {
		public DateTimePrecisionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_dateTimePrecision; }
	}

	public final DateTimePrecisionContext dateTimePrecision() throws RecognitionException {
		DateTimePrecisionContext _localctx = new DateTimePrecisionContext(_ctx, getState());
		enterRule(_localctx, 126, RULE_dateTimePrecision);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(753);
			_la = _input.LA(1);
			if ( !(((((_la - 82)) & ~0x3f) == 0 && ((1L << (_la - 82)) & ((1L << (T__81 - 82)) | (1L << (T__82 - 82)) | (1L << (T__83 - 82)) | (1L << (T__84 - 82)) | (1L << (T__85 - 82)) | (1L << (T__86 - 82)) | (1L << (T__87 - 82)) | (1L << (T__88 - 82)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DateTimeComponentContext extends ParserRuleContext {
		public DateTimePrecisionContext dateTimePrecision() {
			return getRuleContext(DateTimePrecisionContext.class,0);
		}
		public DateTimeComponentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_dateTimeComponent; }
	}

	public final DateTimeComponentContext dateTimeComponent() throws RecognitionException {
		DateTimeComponentContext _localctx = new DateTimeComponentContext(_ctx, getState());
		enterRule(_localctx, 128, RULE_dateTimeComponent);
		try {
			setState(759);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__81:
			case T__82:
			case T__83:
			case T__84:
			case T__85:
			case T__86:
			case T__87:
			case T__88:
				enterOuterAlt(_localctx, 1);
				{
				setState(755);
				dateTimePrecision();
				}
				break;
			case T__89:
				enterOuterAlt(_localctx, 2);
				{
				setState(756);
				match(T__89);
				}
				break;
			case T__90:
				enterOuterAlt(_localctx, 3);
				{
				setState(757);
				match(T__90);
				}
				break;
			case T__91:
				enterOuterAlt(_localctx, 4);
				{
				setState(758);
				match(T__91);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PluralDateTimePrecisionContext extends ParserRuleContext {
		public PluralDateTimePrecisionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pluralDateTimePrecision; }
	}

	public final PluralDateTimePrecisionContext pluralDateTimePrecision() throws RecognitionException {
		PluralDateTimePrecisionContext _localctx = new PluralDateTimePrecisionContext(_ctx, getState());
		enterRule(_localctx, 130, RULE_pluralDateTimePrecision);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(761);
			_la = _input.LA(1);
			if ( !(((((_la - 93)) & ~0x3f) == 0 && ((1L << (_la - 93)) & ((1L << (T__92 - 93)) | (1L << (T__93 - 93)) | (1L << (T__94 - 93)) | (1L << (T__95 - 93)) | (1L << (T__96 - 93)) | (1L << (T__97 - 93)) | (1L << (T__98 - 93)) | (1L << (T__99 - 93)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionTermContext extends ParserRuleContext {
		public ExpressionTermContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expressionTerm; }
	 
		public ExpressionTermContext() { }
		public void copyFrom(ExpressionTermContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AdditionExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public AdditionExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class IndexedExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public IndexedExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class WidthExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public WidthExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class SetAggregateExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public DateTimePrecisionContext dateTimePrecision() {
			return getRuleContext(DateTimePrecisionContext.class,0);
		}
		public SetAggregateExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class TimeUnitExpressionTermContext extends ExpressionTermContext {
		public DateTimeComponentContext dateTimeComponent() {
			return getRuleContext(DateTimeComponentContext.class,0);
		}
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public TimeUnitExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class IfThenElseExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public IfThenElseExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class TimeBoundaryExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public TimeBoundaryExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class ElementExtractorExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public ElementExtractorExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class ConversionExpressionTermContext extends ExpressionTermContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public UnitContext unit() {
			return getRuleContext(UnitContext.class,0);
		}
		public ConversionExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class TypeExtentExpressionTermContext extends ExpressionTermContext {
		public NamedTypeSpecifierContext namedTypeSpecifier() {
			return getRuleContext(NamedTypeSpecifierContext.class,0);
		}
		public TypeExtentExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class PredecessorExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public PredecessorExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class PointExtractorExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public PointExtractorExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class MultiplicationExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public MultiplicationExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class AggregateExpressionTermContext extends ExpressionTermContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public AggregateExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class DurationExpressionTermContext extends ExpressionTermContext {
		public PluralDateTimePrecisionContext pluralDateTimePrecision() {
			return getRuleContext(PluralDateTimePrecisionContext.class,0);
		}
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public DurationExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class DifferenceExpressionTermContext extends ExpressionTermContext {
		public PluralDateTimePrecisionContext pluralDateTimePrecision() {
			return getRuleContext(PluralDateTimePrecisionContext.class,0);
		}
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public DifferenceExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class CaseExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<CaseExpressionItemContext> caseExpressionItem() {
			return getRuleContexts(CaseExpressionItemContext.class);
		}
		public CaseExpressionItemContext caseExpressionItem(int i) {
			return getRuleContext(CaseExpressionItemContext.class,i);
		}
		public CaseExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class PowerExpressionTermContext extends ExpressionTermContext {
		public List<ExpressionTermContext> expressionTerm() {
			return getRuleContexts(ExpressionTermContext.class);
		}
		public ExpressionTermContext expressionTerm(int i) {
			return getRuleContext(ExpressionTermContext.class,i);
		}
		public PowerExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class SuccessorExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public SuccessorExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class PolarityExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public PolarityExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class TermExpressionTermContext extends ExpressionTermContext {
		public TermContext term() {
			return getRuleContext(TermContext.class,0);
		}
		public TermExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}
	public static class InvocationExpressionTermContext extends ExpressionTermContext {
		public ExpressionTermContext expressionTerm() {
			return getRuleContext(ExpressionTermContext.class,0);
		}
		public QualifiedInvocationContext qualifiedInvocation() {
			return getRuleContext(QualifiedInvocationContext.class,0);
		}
		public InvocationExpressionTermContext(ExpressionTermContext ctx) { copyFrom(ctx); }
	}

	public final ExpressionTermContext expressionTerm() throws RecognitionException {
		return expressionTerm(0);
	}

	private ExpressionTermContext expressionTerm(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExpressionTermContext _localctx = new ExpressionTermContext(_ctx, _parentState);
		ExpressionTermContext _prevctx = _localctx;
		int _startState = 132;
		enterRecursionRule(_localctx, 132, RULE_expressionTerm, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(841);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,76,_ctx) ) {
			case 1:
				{
				_localctx = new TermExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(764);
				term();
				}
				break;
			case 2:
				{
				_localctx = new ConversionExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(765);
				match(T__100);
				setState(766);
				expression(0);
				setState(767);
				match(T__101);
				setState(770);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case T__0:
				case T__1:
				case T__2:
				case T__3:
				case T__4:
				case T__5:
				case T__6:
				case T__7:
				case T__8:
				case T__9:
				case T__11:
				case T__12:
				case T__17:
				case T__19:
				case T__20:
				case T__23:
				case T__24:
				case T__25:
				case T__26:
				case T__27:
				case T__28:
				case T__29:
				case T__44:
				case T__49:
				case T__51:
				case T__52:
				case T__53:
				case T__54:
				case T__55:
				case T__73:
				case T__75:
				case T__76:
				case T__78:
				case T__79:
				case T__80:
				case T__89:
				case T__90:
				case T__91:
				case T__104:
				case T__105:
				case T__107:
				case T__108:
				case T__109:
				case T__117:
				case T__118:
				case T__129:
				case T__130:
				case T__131:
				case T__132:
				case T__139:
				case T__140:
				case T__143:
				case T__147:
				case T__148:
				case T__152:
				case T__153:
				case T__154:
				case QUOTEDIDENTIFIER:
				case IDENTIFIER:
				case DELIMITEDIDENTIFIER:
					{
					setState(768);
					typeSpecifier();
					}
					break;
				case T__81:
				case T__82:
				case T__83:
				case T__84:
				case T__85:
				case T__86:
				case T__87:
				case T__88:
				case T__92:
				case T__93:
				case T__94:
				case T__95:
				case T__96:
				case T__97:
				case T__98:
				case T__99:
				case STRING:
					{
					setState(769);
					unit();
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				}
				break;
			case 3:
				{
				_localctx = new PolarityExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(772);
				_la = _input.LA(1);
				if ( !(_la==T__102 || _la==T__103) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(773);
				expressionTerm(18);
				}
				break;
			case 4:
				{
				_localctx = new TimeBoundaryExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(774);
				_la = _input.LA(1);
				if ( !(_la==T__104 || _la==T__105) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(775);
				match(T__106);
				setState(776);
				expressionTerm(17);
				}
				break;
			case 5:
				{
				_localctx = new TimeUnitExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(777);
				dateTimeComponent();
				setState(778);
				match(T__18);
				setState(779);
				expressionTerm(16);
				}
				break;
			case 6:
				{
				_localctx = new DurationExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(781);
				match(T__67);
				setState(782);
				match(T__40);
				setState(783);
				pluralDateTimePrecision();
				setState(784);
				match(T__106);
				setState(785);
				expressionTerm(15);
				}
				break;
			case 7:
				{
				_localctx = new DifferenceExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(787);
				match(T__68);
				setState(788);
				match(T__40);
				setState(789);
				pluralDateTimePrecision();
				setState(790);
				match(T__106);
				setState(791);
				expressionTerm(14);
				}
				break;
			case 8:
				{
				_localctx = new WidthExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(793);
				match(T__107);
				setState(794);
				match(T__106);
				setState(795);
				expressionTerm(13);
				}
				break;
			case 9:
				{
				_localctx = new SuccessorExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(796);
				match(T__108);
				setState(797);
				match(T__106);
				setState(798);
				expressionTerm(12);
				}
				break;
			case 10:
				{
				_localctx = new PredecessorExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(799);
				match(T__109);
				setState(800);
				match(T__106);
				setState(801);
				expressionTerm(11);
				}
				break;
			case 11:
				{
				_localctx = new ElementExtractorExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(802);
				match(T__110);
				setState(803);
				match(T__18);
				setState(804);
				expressionTerm(10);
				}
				break;
			case 12:
				{
				_localctx = new PointExtractorExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(805);
				match(T__111);
				setState(806);
				match(T__18);
				setState(807);
				expressionTerm(9);
				}
				break;
			case 13:
				{
				_localctx = new TypeExtentExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(808);
				_la = _input.LA(1);
				if ( !(_la==T__112 || _la==T__113) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(809);
				namedTypeSpecifier();
				}
				break;
			case 14:
				{
				_localctx = new IfThenElseExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(810);
				match(T__120);
				setState(811);
				expression(0);
				setState(812);
				match(T__121);
				setState(813);
				expression(0);
				setState(814);
				match(T__122);
				setState(815);
				expression(0);
				}
				break;
			case 15:
				{
				_localctx = new CaseExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(817);
				match(T__123);
				setState(819);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__37) | (1L << T__44) | (1L << T__47) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__102 - 64)) | (1L << (T__103 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 130)) & ~0x3f) == 0 && ((1L << (_la - 130)) & ((1L << (T__129 - 130)) | (1L << (T__130 - 130)) | (1L << (T__131 - 130)) | (1L << (T__132 - 130)) | (1L << (T__139 - 130)) | (1L << (T__140 - 130)) | (1L << (T__143 - 130)) | (1L << (T__147 - 130)) | (1L << (T__148 - 130)) | (1L << (T__149 - 130)) | (1L << (T__150 - 130)) | (1L << (T__151 - 130)) | (1L << (T__152 - 130)) | (1L << (T__153 - 130)) | (1L << (T__154 - 130)) | (1L << (T__155 - 130)) | (1L << (QUOTEDIDENTIFIER - 130)) | (1L << (DATETIME - 130)) | (1L << (LONGNUMBER - 130)) | (1L << (DATE - 130)) | (1L << (TIME - 130)) | (1L << (IDENTIFIER - 130)) | (1L << (DELIMITEDIDENTIFIER - 130)) | (1L << (STRING - 130)) | (1L << (NUMBER - 130)))) != 0)) {
					{
					setState(818);
					expression(0);
					}
				}

				setState(822); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(821);
					caseExpressionItem();
					}
					}
					setState(824); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==T__128 );
				setState(826);
				match(T__122);
				setState(827);
				expression(0);
				setState(828);
				match(T__105);
				}
				break;
			case 16:
				{
				_localctx = new AggregateExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(830);
				_la = _input.LA(1);
				if ( !(_la==T__47 || _la==T__124) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(831);
				expression(0);
				}
				break;
			case 17:
				{
				_localctx = new SetAggregateExpressionTermContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(832);
				_la = _input.LA(1);
				if ( !(_la==T__125 || _la==T__126) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(833);
				expression(0);
				setState(839);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,75,_ctx) ) {
				case 1:
					{
					setState(834);
					match(T__127);
					setState(837);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,74,_ctx) ) {
					case 1:
						{
						setState(835);
						dateTimePrecision();
						}
						break;
					case 2:
						{
						setState(836);
						expression(0);
						}
						break;
					}
					}
					break;
				}
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(862);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,78,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(860);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,77,_ctx) ) {
					case 1:
						{
						_localctx = new PowerExpressionTermContext(new ExpressionTermContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expressionTerm);
						setState(843);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(844);
						match(T__114);
						setState(845);
						expressionTerm(8);
						}
						break;
					case 2:
						{
						_localctx = new MultiplicationExpressionTermContext(new ExpressionTermContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expressionTerm);
						setState(846);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(847);
						_la = _input.LA(1);
						if ( !(((((_la - 116)) & ~0x3f) == 0 && ((1L << (_la - 116)) & ((1L << (T__115 - 116)) | (1L << (T__116 - 116)) | (1L << (T__117 - 116)) | (1L << (T__118 - 116)))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(848);
						expressionTerm(7);
						}
						break;
					case 3:
						{
						_localctx = new AdditionExpressionTermContext(new ExpressionTermContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expressionTerm);
						setState(849);
						if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
						setState(850);
						_la = _input.LA(1);
						if ( !(((((_la - 103)) & ~0x3f) == 0 && ((1L << (_la - 103)) & ((1L << (T__102 - 103)) | (1L << (T__103 - 103)) | (1L << (T__119 - 103)))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(851);
						expressionTerm(6);
						}
						break;
					case 4:
						{
						_localctx = new InvocationExpressionTermContext(new ExpressionTermContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expressionTerm);
						setState(852);
						if (!(precpred(_ctx, 21))) throw new FailedPredicateException(this, "precpred(_ctx, 21)");
						setState(853);
						match(T__16);
						setState(854);
						qualifiedInvocation();
						}
						break;
					case 5:
						{
						_localctx = new IndexedExpressionTermContext(new ExpressionTermContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expressionTerm);
						setState(855);
						if (!(precpred(_ctx, 20))) throw new FailedPredicateException(this, "precpred(_ctx, 20)");
						setState(856);
						match(T__37);
						setState(857);
						expression(0);
						setState(858);
						match(T__39);
						}
						break;
					}
					} 
				}
				setState(864);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,78,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class CaseExpressionItemContext extends ParserRuleContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public CaseExpressionItemContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_caseExpressionItem; }
	}

	public final CaseExpressionItemContext caseExpressionItem() throws RecognitionException {
		CaseExpressionItemContext _localctx = new CaseExpressionItemContext(_ctx, getState());
		enterRule(_localctx, 134, RULE_caseExpressionItem);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(865);
			match(T__128);
			setState(866);
			expression(0);
			setState(867);
			match(T__121);
			setState(868);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DateTimePrecisionSpecifierContext extends ParserRuleContext {
		public DateTimePrecisionContext dateTimePrecision() {
			return getRuleContext(DateTimePrecisionContext.class,0);
		}
		public DateTimePrecisionSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_dateTimePrecisionSpecifier; }
	}

	public final DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() throws RecognitionException {
		DateTimePrecisionSpecifierContext _localctx = new DateTimePrecisionSpecifierContext(_ctx, getState());
		enterRule(_localctx, 136, RULE_dateTimePrecisionSpecifier);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(870);
			dateTimePrecision();
			setState(871);
			match(T__106);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RelativeQualifierContext extends ParserRuleContext {
		public RelativeQualifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_relativeQualifier; }
	}

	public final RelativeQualifierContext relativeQualifier() throws RecognitionException {
		RelativeQualifierContext _localctx = new RelativeQualifierContext(_ctx, getState());
		enterRule(_localctx, 138, RULE_relativeQualifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(873);
			_la = _input.LA(1);
			if ( !(_la==T__129 || _la==T__130) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OffsetRelativeQualifierContext extends ParserRuleContext {
		public OffsetRelativeQualifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_offsetRelativeQualifier; }
	}

	public final OffsetRelativeQualifierContext offsetRelativeQualifier() throws RecognitionException {
		OffsetRelativeQualifierContext _localctx = new OffsetRelativeQualifierContext(_ctx, getState());
		enterRule(_localctx, 140, RULE_offsetRelativeQualifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(875);
			_la = _input.LA(1);
			if ( !(_la==T__131 || _la==T__132) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExclusiveRelativeQualifierContext extends ParserRuleContext {
		public ExclusiveRelativeQualifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_exclusiveRelativeQualifier; }
	}

	public final ExclusiveRelativeQualifierContext exclusiveRelativeQualifier() throws RecognitionException {
		ExclusiveRelativeQualifierContext _localctx = new ExclusiveRelativeQualifierContext(_ctx, getState());
		enterRule(_localctx, 142, RULE_exclusiveRelativeQualifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(877);
			_la = _input.LA(1);
			if ( !(_la==T__133 || _la==T__134) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QuantityOffsetContext extends ParserRuleContext {
		public QuantityContext quantity() {
			return getRuleContext(QuantityContext.class,0);
		}
		public OffsetRelativeQualifierContext offsetRelativeQualifier() {
			return getRuleContext(OffsetRelativeQualifierContext.class,0);
		}
		public ExclusiveRelativeQualifierContext exclusiveRelativeQualifier() {
			return getRuleContext(ExclusiveRelativeQualifierContext.class,0);
		}
		public QuantityOffsetContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_quantityOffset; }
	}

	public final QuantityOffsetContext quantityOffset() throws RecognitionException {
		QuantityOffsetContext _localctx = new QuantityOffsetContext(_ctx, getState());
		enterRule(_localctx, 144, RULE_quantityOffset);
		int _la;
		try {
			setState(886);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NUMBER:
				enterOuterAlt(_localctx, 1);
				{
				{
				setState(879);
				quantity();
				setState(881);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__131 || _la==T__132) {
					{
					setState(880);
					offsetRelativeQualifier();
					}
				}

				}
				}
				break;
			case T__133:
			case T__134:
				enterOuterAlt(_localctx, 2);
				{
				{
				setState(883);
				exclusiveRelativeQualifier();
				setState(884);
				quantity();
				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TemporalRelationshipContext extends ParserRuleContext {
		public TemporalRelationshipContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_temporalRelationship; }
	}

	public final TemporalRelationshipContext temporalRelationship() throws RecognitionException {
		TemporalRelationshipContext _localctx = new TemporalRelationshipContext(_ctx, getState());
		enterRule(_localctx, 146, RULE_temporalRelationship);
		int _la;
		try {
			setState(896);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,83,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				{
				setState(889);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__135) {
					{
					setState(888);
					match(T__135);
					}
				}

				setState(891);
				_la = _input.LA(1);
				if ( !(_la==T__136 || _la==T__137) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				{
				setState(892);
				_la = _input.LA(1);
				if ( !(_la==T__136 || _la==T__137) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(894);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__138) {
					{
					setState(893);
					match(T__138);
					}
				}

				}
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IntervalOperatorPhraseContext extends ParserRuleContext {
		public IntervalOperatorPhraseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_intervalOperatorPhrase; }
	 
		public IntervalOperatorPhraseContext() { }
		public void copyFrom(IntervalOperatorPhraseContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class WithinIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public QuantityContext quantity() {
			return getRuleContext(QuantityContext.class,0);
		}
		public WithinIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class IncludedInIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public IncludedInIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class EndsIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public EndsIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class ConcurrentWithIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public RelativeQualifierContext relativeQualifier() {
			return getRuleContext(RelativeQualifierContext.class,0);
		}
		public DateTimePrecisionContext dateTimePrecision() {
			return getRuleContext(DateTimePrecisionContext.class,0);
		}
		public ConcurrentWithIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class OverlapsIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public OverlapsIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class IncludesIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public IncludesIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class BeforeOrAfterIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public TemporalRelationshipContext temporalRelationship() {
			return getRuleContext(TemporalRelationshipContext.class,0);
		}
		public QuantityOffsetContext quantityOffset() {
			return getRuleContext(QuantityOffsetContext.class,0);
		}
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public BeforeOrAfterIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class MeetsIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public MeetsIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}
	public static class StartsIntervalOperatorPhraseContext extends IntervalOperatorPhraseContext {
		public DateTimePrecisionSpecifierContext dateTimePrecisionSpecifier() {
			return getRuleContext(DateTimePrecisionSpecifierContext.class,0);
		}
		public StartsIntervalOperatorPhraseContext(IntervalOperatorPhraseContext ctx) { copyFrom(ctx); }
	}

	public final IntervalOperatorPhraseContext intervalOperatorPhrase() throws RecognitionException {
		IntervalOperatorPhraseContext _localctx = new IntervalOperatorPhraseContext(_ctx, getState());
		enterRule(_localctx, 148, RULE_intervalOperatorPhrase);
		int _la;
		try {
			setState(979);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,107,_ctx) ) {
			case 1:
				_localctx = new ConcurrentWithIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(899);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) {
					{
					setState(898);
					_la = _input.LA(1);
					if ( !(((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(901);
				match(T__142);
				setState(903);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 82)) & ~0x3f) == 0 && ((1L << (_la - 82)) & ((1L << (T__81 - 82)) | (1L << (T__82 - 82)) | (1L << (T__83 - 82)) | (1L << (T__84 - 82)) | (1L << (T__85 - 82)) | (1L << (T__86 - 82)) | (1L << (T__87 - 82)) | (1L << (T__88 - 82)))) != 0)) {
					{
					setState(902);
					dateTimePrecision();
					}
				}

				setState(907);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case T__129:
				case T__130:
					{
					setState(905);
					relativeQualifier();
					}
					break;
				case T__61:
					{
					setState(906);
					match(T__61);
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(910);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,87,_ctx) ) {
				case 1:
					{
					setState(909);
					_la = _input.LA(1);
					if ( !(_la==T__104 || _la==T__105) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
					break;
				}
				}
				break;
			case 2:
				_localctx = new IncludesIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(913);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__64) {
					{
					setState(912);
					match(T__64);
					}
				}

				setState(915);
				match(T__143);
				setState(917);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,89,_ctx) ) {
				case 1:
					{
					setState(916);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				setState(920);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,90,_ctx) ) {
				case 1:
					{
					setState(919);
					_la = _input.LA(1);
					if ( !(_la==T__104 || _la==T__105) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
					break;
				}
				}
				break;
			case 3:
				_localctx = new IncludedInIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(923);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) {
					{
					setState(922);
					_la = _input.LA(1);
					if ( !(((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(926);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__64) {
					{
					setState(925);
					match(T__64);
					}
				}

				setState(928);
				_la = _input.LA(1);
				if ( !(_la==T__144 || _la==T__145) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(930);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,93,_ctx) ) {
				case 1:
					{
					setState(929);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				}
				break;
			case 4:
				_localctx = new BeforeOrAfterIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(933);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) {
					{
					setState(932);
					_la = _input.LA(1);
					if ( !(((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(936);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 134)) & ~0x3f) == 0 && ((1L << (_la - 134)) & ((1L << (T__133 - 134)) | (1L << (T__134 - 134)) | (1L << (NUMBER - 134)))) != 0)) {
					{
					setState(935);
					quantityOffset();
					}
				}

				setState(938);
				temporalRelationship();
				setState(940);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,96,_ctx) ) {
				case 1:
					{
					setState(939);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				setState(943);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,97,_ctx) ) {
				case 1:
					{
					setState(942);
					_la = _input.LA(1);
					if ( !(_la==T__104 || _la==T__105) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
					break;
				}
				}
				break;
			case 5:
				_localctx = new WithinIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(946);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) {
					{
					setState(945);
					_la = _input.LA(1);
					if ( !(((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__141 - 140)))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(949);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__64) {
					{
					setState(948);
					match(T__64);
					}
				}

				setState(951);
				match(T__146);
				setState(952);
				quantity();
				setState(953);
				match(T__106);
				setState(955);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,100,_ctx) ) {
				case 1:
					{
					setState(954);
					_la = _input.LA(1);
					if ( !(_la==T__104 || _la==T__105) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
					break;
				}
				}
				break;
			case 6:
				_localctx = new MeetsIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(957);
				match(T__147);
				setState(959);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__136 || _la==T__137) {
					{
					setState(958);
					_la = _input.LA(1);
					if ( !(_la==T__136 || _la==T__137) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(962);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,102,_ctx) ) {
				case 1:
					{
					setState(961);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				}
				break;
			case 7:
				_localctx = new OverlapsIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(964);
				match(T__148);
				setState(966);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__136 || _la==T__137) {
					{
					setState(965);
					_la = _input.LA(1);
					if ( !(_la==T__136 || _la==T__137) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
				}

				setState(969);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,104,_ctx) ) {
				case 1:
					{
					setState(968);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				}
				break;
			case 8:
				_localctx = new StartsIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(971);
				match(T__139);
				setState(973);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,105,_ctx) ) {
				case 1:
					{
					setState(972);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				}
				break;
			case 9:
				_localctx = new EndsIntervalOperatorPhraseContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(975);
				match(T__140);
				setState(977);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,106,_ctx) ) {
				case 1:
					{
					setState(976);
					dateTimePrecisionSpecifier();
					}
					break;
				}
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TermContext extends ParserRuleContext {
		public TermContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_term; }
	 
		public TermContext() { }
		public void copyFrom(TermContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ExternalConstantTermContext extends TermContext {
		public ExternalConstantContext externalConstant() {
			return getRuleContext(ExternalConstantContext.class,0);
		}
		public ExternalConstantTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class TupleSelectorTermContext extends TermContext {
		public TupleSelectorContext tupleSelector() {
			return getRuleContext(TupleSelectorContext.class,0);
		}
		public TupleSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class LiteralTermContext extends TermContext {
		public LiteralContext literal() {
			return getRuleContext(LiteralContext.class,0);
		}
		public LiteralTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class ConceptSelectorTermContext extends TermContext {
		public ConceptSelectorContext conceptSelector() {
			return getRuleContext(ConceptSelectorContext.class,0);
		}
		public ConceptSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class ParenthesizedTermContext extends TermContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ParenthesizedTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class CodeSelectorTermContext extends TermContext {
		public CodeSelectorContext codeSelector() {
			return getRuleContext(CodeSelectorContext.class,0);
		}
		public CodeSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class InvocationTermContext extends TermContext {
		public InvocationContext invocation() {
			return getRuleContext(InvocationContext.class,0);
		}
		public InvocationTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class InstanceSelectorTermContext extends TermContext {
		public InstanceSelectorContext instanceSelector() {
			return getRuleContext(InstanceSelectorContext.class,0);
		}
		public InstanceSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class IntervalSelectorTermContext extends TermContext {
		public IntervalSelectorContext intervalSelector() {
			return getRuleContext(IntervalSelectorContext.class,0);
		}
		public IntervalSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}
	public static class ListSelectorTermContext extends TermContext {
		public ListSelectorContext listSelector() {
			return getRuleContext(ListSelectorContext.class,0);
		}
		public ListSelectorTermContext(TermContext ctx) { copyFrom(ctx); }
	}

	public final TermContext term() throws RecognitionException {
		TermContext _localctx = new TermContext(_ctx, getState());
		enterRule(_localctx, 150, RULE_term);
		try {
			setState(994);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,108,_ctx) ) {
			case 1:
				_localctx = new InvocationTermContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(981);
				invocation();
				}
				break;
			case 2:
				_localctx = new LiteralTermContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(982);
				literal();
				}
				break;
			case 3:
				_localctx = new ExternalConstantTermContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(983);
				externalConstant();
				}
				break;
			case 4:
				_localctx = new IntervalSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(984);
				intervalSelector();
				}
				break;
			case 5:
				_localctx = new TupleSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(985);
				tupleSelector();
				}
				break;
			case 6:
				_localctx = new InstanceSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(986);
				instanceSelector();
				}
				break;
			case 7:
				_localctx = new ListSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(987);
				listSelector();
				}
				break;
			case 8:
				_localctx = new CodeSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(988);
				codeSelector();
				}
				break;
			case 9:
				_localctx = new ConceptSelectorTermContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(989);
				conceptSelector();
				}
				break;
			case 10:
				_localctx = new ParenthesizedTermContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(990);
				match(T__30);
				setState(991);
				expression(0);
				setState(992);
				match(T__31);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifiedInvocationContext extends ParserRuleContext {
		public QualifiedInvocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifiedInvocation; }
	 
		public QualifiedInvocationContext() { }
		public void copyFrom(QualifiedInvocationContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class QualifiedFunctionInvocationContext extends QualifiedInvocationContext {
		public QualifiedFunctionContext qualifiedFunction() {
			return getRuleContext(QualifiedFunctionContext.class,0);
		}
		public QualifiedFunctionInvocationContext(QualifiedInvocationContext ctx) { copyFrom(ctx); }
	}
	public static class QualifiedMemberInvocationContext extends QualifiedInvocationContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public QualifiedMemberInvocationContext(QualifiedInvocationContext ctx) { copyFrom(ctx); }
	}

	public final QualifiedInvocationContext qualifiedInvocation() throws RecognitionException {
		QualifiedInvocationContext _localctx = new QualifiedInvocationContext(_ctx, getState());
		enterRule(_localctx, 152, RULE_qualifiedInvocation);
		try {
			setState(998);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,109,_ctx) ) {
			case 1:
				_localctx = new QualifiedMemberInvocationContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(996);
				referentialIdentifier();
				}
				break;
			case 2:
				_localctx = new QualifiedFunctionInvocationContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(997);
				qualifiedFunction();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QualifiedFunctionContext extends ParserRuleContext {
		public IdentifierOrFunctionIdentifierContext identifierOrFunctionIdentifier() {
			return getRuleContext(IdentifierOrFunctionIdentifierContext.class,0);
		}
		public ParamListContext paramList() {
			return getRuleContext(ParamListContext.class,0);
		}
		public QualifiedFunctionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_qualifiedFunction; }
	}

	public final QualifiedFunctionContext qualifiedFunction() throws RecognitionException {
		QualifiedFunctionContext _localctx = new QualifiedFunctionContext(_ctx, getState());
		enterRule(_localctx, 154, RULE_qualifiedFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1000);
			identifierOrFunctionIdentifier();
			setState(1001);
			match(T__30);
			setState(1003);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__37) | (1L << T__44) | (1L << T__47) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__102 - 64)) | (1L << (T__103 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 130)) & ~0x3f) == 0 && ((1L << (_la - 130)) & ((1L << (T__129 - 130)) | (1L << (T__130 - 130)) | (1L << (T__131 - 130)) | (1L << (T__132 - 130)) | (1L << (T__139 - 130)) | (1L << (T__140 - 130)) | (1L << (T__143 - 130)) | (1L << (T__147 - 130)) | (1L << (T__148 - 130)) | (1L << (T__149 - 130)) | (1L << (T__150 - 130)) | (1L << (T__151 - 130)) | (1L << (T__152 - 130)) | (1L << (T__153 - 130)) | (1L << (T__154 - 130)) | (1L << (T__155 - 130)) | (1L << (QUOTEDIDENTIFIER - 130)) | (1L << (DATETIME - 130)) | (1L << (LONGNUMBER - 130)) | (1L << (DATE - 130)) | (1L << (TIME - 130)) | (1L << (IDENTIFIER - 130)) | (1L << (DELIMITEDIDENTIFIER - 130)) | (1L << (STRING - 130)) | (1L << (NUMBER - 130)))) != 0)) {
				{
				setState(1002);
				paramList();
				}
			}

			setState(1005);
			match(T__31);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InvocationContext extends ParserRuleContext {
		public InvocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_invocation; }
	 
		public InvocationContext() { }
		public void copyFrom(InvocationContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TotalInvocationContext extends InvocationContext {
		public TotalInvocationContext(InvocationContext ctx) { copyFrom(ctx); }
	}
	public static class ThisInvocationContext extends InvocationContext {
		public ThisInvocationContext(InvocationContext ctx) { copyFrom(ctx); }
	}
	public static class IndexInvocationContext extends InvocationContext {
		public IndexInvocationContext(InvocationContext ctx) { copyFrom(ctx); }
	}
	public static class FunctionInvocationContext extends InvocationContext {
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public FunctionInvocationContext(InvocationContext ctx) { copyFrom(ctx); }
	}
	public static class MemberInvocationContext extends InvocationContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public MemberInvocationContext(InvocationContext ctx) { copyFrom(ctx); }
	}

	public final InvocationContext invocation() throws RecognitionException {
		InvocationContext _localctx = new InvocationContext(_ctx, getState());
		enterRule(_localctx, 156, RULE_invocation);
		try {
			setState(1012);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,111,_ctx) ) {
			case 1:
				_localctx = new MemberInvocationContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(1007);
				referentialIdentifier();
				}
				break;
			case 2:
				_localctx = new FunctionInvocationContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(1008);
				function();
				}
				break;
			case 3:
				_localctx = new ThisInvocationContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(1009);
				match(T__149);
				}
				break;
			case 4:
				_localctx = new IndexInvocationContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(1010);
				match(T__150);
				}
				break;
			case 5:
				_localctx = new TotalInvocationContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(1011);
				match(T__151);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FunctionContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public ParamListContext paramList() {
			return getRuleContext(ParamListContext.class,0);
		}
		public FunctionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function() throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState());
		enterRule(_localctx, 158, RULE_function);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1014);
			referentialIdentifier();
			setState(1015);
			match(T__30);
			setState(1017);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__37) | (1L << T__44) | (1L << T__47) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__102 - 64)) | (1L << (T__103 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 130)) & ~0x3f) == 0 && ((1L << (_la - 130)) & ((1L << (T__129 - 130)) | (1L << (T__130 - 130)) | (1L << (T__131 - 130)) | (1L << (T__132 - 130)) | (1L << (T__139 - 130)) | (1L << (T__140 - 130)) | (1L << (T__143 - 130)) | (1L << (T__147 - 130)) | (1L << (T__148 - 130)) | (1L << (T__149 - 130)) | (1L << (T__150 - 130)) | (1L << (T__151 - 130)) | (1L << (T__152 - 130)) | (1L << (T__153 - 130)) | (1L << (T__154 - 130)) | (1L << (T__155 - 130)) | (1L << (QUOTEDIDENTIFIER - 130)) | (1L << (DATETIME - 130)) | (1L << (LONGNUMBER - 130)) | (1L << (DATE - 130)) | (1L << (TIME - 130)) | (1L << (IDENTIFIER - 130)) | (1L << (DELIMITEDIDENTIFIER - 130)) | (1L << (STRING - 130)) | (1L << (NUMBER - 130)))) != 0)) {
				{
				setState(1016);
				paramList();
				}
			}

			setState(1019);
			match(T__31);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RatioContext extends ParserRuleContext {
		public List<QuantityContext> quantity() {
			return getRuleContexts(QuantityContext.class);
		}
		public QuantityContext quantity(int i) {
			return getRuleContext(QuantityContext.class,i);
		}
		public RatioContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ratio; }
	}

	public final RatioContext ratio() throws RecognitionException {
		RatioContext _localctx = new RatioContext(_ctx, getState());
		enterRule(_localctx, 160, RULE_ratio);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1021);
			quantity();
			setState(1022);
			match(T__10);
			setState(1023);
			quantity();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LiteralContext extends ParserRuleContext {
		public LiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_literal; }
	 
		public LiteralContext() { }
		public void copyFrom(LiteralContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TimeLiteralContext extends LiteralContext {
		public TerminalNode TIME() { return getToken(cqlParser.TIME, 0); }
		public TimeLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class NullLiteralContext extends LiteralContext {
		public NullLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class RatioLiteralContext extends LiteralContext {
		public RatioContext ratio() {
			return getRuleContext(RatioContext.class,0);
		}
		public RatioLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class DateTimeLiteralContext extends LiteralContext {
		public TerminalNode DATETIME() { return getToken(cqlParser.DATETIME, 0); }
		public DateTimeLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class StringLiteralContext extends LiteralContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public StringLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class DateLiteralContext extends LiteralContext {
		public TerminalNode DATE() { return getToken(cqlParser.DATE, 0); }
		public DateLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class BooleanLiteralContext extends LiteralContext {
		public BooleanLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class NumberLiteralContext extends LiteralContext {
		public TerminalNode NUMBER() { return getToken(cqlParser.NUMBER, 0); }
		public NumberLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class LongNumberLiteralContext extends LiteralContext {
		public TerminalNode LONGNUMBER() { return getToken(cqlParser.LONGNUMBER, 0); }
		public LongNumberLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}
	public static class QuantityLiteralContext extends LiteralContext {
		public QuantityContext quantity() {
			return getRuleContext(QuantityContext.class,0);
		}
		public QuantityLiteralContext(LiteralContext ctx) { copyFrom(ctx); }
	}

	public final LiteralContext literal() throws RecognitionException {
		LiteralContext _localctx = new LiteralContext(_ctx, getState());
		enterRule(_localctx, 162, RULE_literal);
		int _la;
		try {
			setState(1035);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,113,_ctx) ) {
			case 1:
				_localctx = new BooleanLiteralContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(1025);
				_la = _input.LA(1);
				if ( !(_la==T__59 || _la==T__60) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				break;
			case 2:
				_localctx = new NullLiteralContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(1026);
				match(T__58);
				}
				break;
			case 3:
				_localctx = new StringLiteralContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(1027);
				match(STRING);
				}
				break;
			case 4:
				_localctx = new NumberLiteralContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(1028);
				match(NUMBER);
				}
				break;
			case 5:
				_localctx = new LongNumberLiteralContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(1029);
				match(LONGNUMBER);
				}
				break;
			case 6:
				_localctx = new DateTimeLiteralContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(1030);
				match(DATETIME);
				}
				break;
			case 7:
				_localctx = new DateLiteralContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(1031);
				match(DATE);
				}
				break;
			case 8:
				_localctx = new TimeLiteralContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(1032);
				match(TIME);
				}
				break;
			case 9:
				_localctx = new QuantityLiteralContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(1033);
				quantity();
				}
				break;
			case 10:
				_localctx = new RatioLiteralContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(1034);
				ratio();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IntervalSelectorContext extends ParserRuleContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public IntervalSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_intervalSelector; }
	}

	public final IntervalSelectorContext intervalSelector() throws RecognitionException {
		IntervalSelectorContext _localctx = new IntervalSelectorContext(_ctx, getState());
		enterRule(_localctx, 164, RULE_intervalSelector);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1037);
			match(T__23);
			setState(1038);
			_la = _input.LA(1);
			if ( !(_la==T__30 || _la==T__37) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(1039);
			expression(0);
			setState(1040);
			match(T__14);
			setState(1041);
			expression(0);
			setState(1042);
			_la = _input.LA(1);
			if ( !(_la==T__31 || _la==T__39) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TupleSelectorContext extends ParserRuleContext {
		public List<TupleElementSelectorContext> tupleElementSelector() {
			return getRuleContexts(TupleElementSelectorContext.class);
		}
		public TupleElementSelectorContext tupleElementSelector(int i) {
			return getRuleContext(TupleElementSelectorContext.class,i);
		}
		public TupleSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_tupleSelector; }
	}

	public final TupleSelectorContext tupleSelector() throws RecognitionException {
		TupleSelectorContext _localctx = new TupleSelectorContext(_ctx, getState());
		enterRule(_localctx, 166, RULE_tupleSelector);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1045);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__24) {
				{
				setState(1044);
				match(T__24);
				}
			}

			setState(1047);
			match(T__13);
			setState(1057);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__10:
				{
				setState(1048);
				match(T__10);
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__19:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__44:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__89:
			case T__90:
			case T__91:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__117:
			case T__118:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__152:
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				{
				{
				setState(1049);
				tupleElementSelector();
				setState(1054);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__14) {
					{
					{
					setState(1050);
					match(T__14);
					setState(1051);
					tupleElementSelector();
					}
					}
					setState(1056);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(1059);
			match(T__15);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TupleElementSelectorContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TupleElementSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_tupleElementSelector; }
	}

	public final TupleElementSelectorContext tupleElementSelector() throws RecognitionException {
		TupleElementSelectorContext _localctx = new TupleElementSelectorContext(_ctx, getState());
		enterRule(_localctx, 168, RULE_tupleElementSelector);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1061);
			referentialIdentifier();
			setState(1062);
			match(T__10);
			setState(1063);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstanceSelectorContext extends ParserRuleContext {
		public NamedTypeSpecifierContext namedTypeSpecifier() {
			return getRuleContext(NamedTypeSpecifierContext.class,0);
		}
		public List<InstanceElementSelectorContext> instanceElementSelector() {
			return getRuleContexts(InstanceElementSelectorContext.class);
		}
		public InstanceElementSelectorContext instanceElementSelector(int i) {
			return getRuleContext(InstanceElementSelectorContext.class,i);
		}
		public InstanceSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instanceSelector; }
	}

	public final InstanceSelectorContext instanceSelector() throws RecognitionException {
		InstanceSelectorContext _localctx = new InstanceSelectorContext(_ctx, getState());
		enterRule(_localctx, 170, RULE_instanceSelector);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1065);
			namedTypeSpecifier();
			setState(1066);
			match(T__13);
			setState(1076);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__10:
				{
				setState(1067);
				match(T__10);
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__19:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__44:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__89:
			case T__90:
			case T__91:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__117:
			case T__118:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__152:
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				{
				{
				setState(1068);
				instanceElementSelector();
				setState(1073);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__14) {
					{
					{
					setState(1069);
					match(T__14);
					setState(1070);
					instanceElementSelector();
					}
					}
					setState(1075);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(1078);
			match(T__15);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstanceElementSelectorContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public InstanceElementSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instanceElementSelector; }
	}

	public final InstanceElementSelectorContext instanceElementSelector() throws RecognitionException {
		InstanceElementSelectorContext _localctx = new InstanceElementSelectorContext(_ctx, getState());
		enterRule(_localctx, 172, RULE_instanceElementSelector);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1080);
			referentialIdentifier();
			setState(1081);
			match(T__10);
			setState(1082);
			expression(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ListSelectorContext extends ParserRuleContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public ListSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_listSelector; }
	}

	public final ListSelectorContext listSelector() throws RecognitionException {
		ListSelectorContext _localctx = new ListSelectorContext(_ctx, getState());
		enterRule(_localctx, 174, RULE_listSelector);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1091);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__20) {
				{
				setState(1084);
				match(T__20);
				setState(1089);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__21) {
					{
					setState(1085);
					match(T__21);
					setState(1086);
					typeSpecifier();
					setState(1087);
					match(T__22);
					}
				}

				}
			}

			setState(1093);
			match(T__13);
			setState(1102);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__37) | (1L << T__44) | (1L << T__47) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__102 - 64)) | (1L << (T__103 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 130)) & ~0x3f) == 0 && ((1L << (_la - 130)) & ((1L << (T__129 - 130)) | (1L << (T__130 - 130)) | (1L << (T__131 - 130)) | (1L << (T__132 - 130)) | (1L << (T__139 - 130)) | (1L << (T__140 - 130)) | (1L << (T__143 - 130)) | (1L << (T__147 - 130)) | (1L << (T__148 - 130)) | (1L << (T__149 - 130)) | (1L << (T__150 - 130)) | (1L << (T__151 - 130)) | (1L << (T__152 - 130)) | (1L << (T__153 - 130)) | (1L << (T__154 - 130)) | (1L << (T__155 - 130)) | (1L << (QUOTEDIDENTIFIER - 130)) | (1L << (DATETIME - 130)) | (1L << (LONGNUMBER - 130)) | (1L << (DATE - 130)) | (1L << (TIME - 130)) | (1L << (IDENTIFIER - 130)) | (1L << (DELIMITEDIDENTIFIER - 130)) | (1L << (STRING - 130)) | (1L << (NUMBER - 130)))) != 0)) {
				{
				setState(1094);
				expression(0);
				setState(1099);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__14) {
					{
					{
					setState(1095);
					match(T__14);
					setState(1096);
					expression(0);
					}
					}
					setState(1101);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(1104);
			match(T__15);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DisplayClauseContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public DisplayClauseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_displayClause; }
	}

	public final DisplayClauseContext displayClause() throws RecognitionException {
		DisplayClauseContext _localctx = new DisplayClauseContext(_ctx, getState());
		enterRule(_localctx, 176, RULE_displayClause);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1106);
			match(T__152);
			setState(1107);
			match(STRING);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CodeSelectorContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public CodesystemIdentifierContext codesystemIdentifier() {
			return getRuleContext(CodesystemIdentifierContext.class,0);
		}
		public DisplayClauseContext displayClause() {
			return getRuleContext(DisplayClauseContext.class,0);
		}
		public CodeSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_codeSelector; }
	}

	public final CodeSelectorContext codeSelector() throws RecognitionException {
		CodeSelectorContext _localctx = new CodeSelectorContext(_ctx, getState());
		enterRule(_localctx, 178, RULE_codeSelector);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1109);
			match(T__153);
			setState(1110);
			match(STRING);
			setState(1111);
			match(T__18);
			setState(1112);
			codesystemIdentifier();
			setState(1114);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,123,_ctx) ) {
			case 1:
				{
				setState(1113);
				displayClause();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ConceptSelectorContext extends ParserRuleContext {
		public List<CodeSelectorContext> codeSelector() {
			return getRuleContexts(CodeSelectorContext.class);
		}
		public CodeSelectorContext codeSelector(int i) {
			return getRuleContext(CodeSelectorContext.class,i);
		}
		public DisplayClauseContext displayClause() {
			return getRuleContext(DisplayClauseContext.class,0);
		}
		public ConceptSelectorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_conceptSelector; }
	}

	public final ConceptSelectorContext conceptSelector() throws RecognitionException {
		ConceptSelectorContext _localctx = new ConceptSelectorContext(_ctx, getState());
		enterRule(_localctx, 180, RULE_conceptSelector);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1116);
			match(T__154);
			setState(1117);
			match(T__13);
			setState(1118);
			codeSelector();
			setState(1123);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(1119);
				match(T__14);
				setState(1120);
				codeSelector();
				}
				}
				setState(1125);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(1126);
			match(T__15);
			setState(1128);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,125,_ctx) ) {
			case 1:
				{
				setState(1127);
				displayClause();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class KeywordContext extends ParserRuleContext {
		public KeywordContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_keyword; }
	}

	public final KeywordContext keyword() throws RecognitionException {
		KeywordContext _localctx = new KeywordContext(_ctx, getState());
		enterRule(_localctx, 182, RULE_keyword);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1130);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__40) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__61) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__64 - 64)) | (1L << (T__65 - 64)) | (1L << (T__66 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__74 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__101 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__106 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__121 - 64)) | (1L << (T__122 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 128)) & ~0x3f) == 0 && ((1L << (_la - 128)) & ((1L << (T__127 - 128)) | (1L << (T__128 - 128)) | (1L << (T__129 - 128)) | (1L << (T__130 - 128)) | (1L << (T__131 - 128)) | (1L << (T__132 - 128)) | (1L << (T__135 - 128)) | (1L << (T__136 - 128)) | (1L << (T__137 - 128)) | (1L << (T__138 - 128)) | (1L << (T__139 - 128)) | (1L << (T__140 - 128)) | (1L << (T__141 - 128)) | (1L << (T__142 - 128)) | (1L << (T__143 - 128)) | (1L << (T__144 - 128)) | (1L << (T__145 - 128)) | (1L << (T__146 - 128)) | (1L << (T__147 - 128)) | (1L << (T__148 - 128)) | (1L << (T__152 - 128)) | (1L << (T__153 - 128)) | (1L << (T__154 - 128)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReservedWordContext extends ParserRuleContext {
		public ReservedWordContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_reservedWord; }
	}

	public final ReservedWordContext reservedWord() throws RecognitionException {
		ReservedWordContext _localctx = new ReservedWordContext(_ctx, getState());
		enterRule(_localctx, 184, RULE_reservedWord);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1132);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__18) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__40) | (1L << T__43) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__50) | (1L << T__56) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__61) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__64 - 64)) | (1L << (T__65 - 64)) | (1L << (T__66 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__74 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__101 - 64)) | (1L << (T__106 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__120 - 64)) | (1L << (T__121 - 64)) | (1L << (T__122 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 128)) & ~0x3f) == 0 && ((1L << (_la - 128)) & ((1L << (T__127 - 128)) | (1L << (T__128 - 128)) | (1L << (T__135 - 128)) | (1L << (T__136 - 128)) | (1L << (T__137 - 128)) | (1L << (T__138 - 128)) | (1L << (T__141 - 128)) | (1L << (T__142 - 128)) | (1L << (T__144 - 128)) | (1L << (T__145 - 128)) | (1L << (T__146 - 128)) | (1L << (T__153 - 128)) | (1L << (T__154 - 128)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class KeywordIdentifierContext extends ParserRuleContext {
		public KeywordIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_keywordIdentifier; }
	}

	public final KeywordIdentifierContext keywordIdentifier() throws RecognitionException {
		KeywordIdentifierContext _localctx = new KeywordIdentifierContext(_ctx, getState());
		enterRule(_localctx, 186, RULE_keywordIdentifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1134);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__17) | (1L << T__19) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__44) | (1L << T__49) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (T__73 - 74)) | (1L << (T__75 - 74)) | (1L << (T__76 - 74)) | (1L << (T__78 - 74)) | (1L << (T__79 - 74)) | (1L << (T__80 - 74)) | (1L << (T__89 - 74)) | (1L << (T__90 - 74)) | (1L << (T__91 - 74)) | (1L << (T__104 - 74)) | (1L << (T__105 - 74)) | (1L << (T__107 - 74)) | (1L << (T__108 - 74)) | (1L << (T__109 - 74)) | (1L << (T__117 - 74)) | (1L << (T__118 - 74)) | (1L << (T__129 - 74)) | (1L << (T__130 - 74)) | (1L << (T__131 - 74)) | (1L << (T__132 - 74)))) != 0) || ((((_la - 140)) & ~0x3f) == 0 && ((1L << (_la - 140)) & ((1L << (T__139 - 140)) | (1L << (T__140 - 140)) | (1L << (T__143 - 140)) | (1L << (T__147 - 140)) | (1L << (T__148 - 140)) | (1L << (T__152 - 140)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ObsoleteIdentifierContext extends ParserRuleContext {
		public ObsoleteIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_obsoleteIdentifier; }
	}

	public final ObsoleteIdentifierContext obsoleteIdentifier() throws RecognitionException {
		ObsoleteIdentifierContext _localctx = new ObsoleteIdentifierContext(_ctx, getState());
		enterRule(_localctx, 188, RULE_obsoleteIdentifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1136);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__17) | (1L << T__19) | (1L << T__44) | (1L << T__46) | (1L << T__47) | (1L << T__57))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__73 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)))) != 0) || ((((_la - 153)) & ~0x3f) == 0 && ((1L << (_la - 153)) & ((1L << (T__152 - 153)) | (1L << (T__153 - 153)) | (1L << (T__154 - 153)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FunctionIdentifierContext extends ParserRuleContext {
		public FunctionIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_functionIdentifier; }
	}

	public final FunctionIdentifierContext functionIdentifier() throws RecognitionException {
		FunctionIdentifierContext _localctx = new FunctionIdentifierContext(_ctx, getState());
		enterRule(_localctx, 190, RULE_functionIdentifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1138);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__40) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60) | (1L << T__61) | (1L << T__62))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (T__63 - 64)) | (1L << (T__64 - 64)) | (1L << (T__65 - 64)) | (1L << (T__66 - 64)) | (1L << (T__67 - 64)) | (1L << (T__68 - 64)) | (1L << (T__73 - 64)) | (1L << (T__74 - 64)) | (1L << (T__75 - 64)) | (1L << (T__76 - 64)) | (1L << (T__78 - 64)) | (1L << (T__79 - 64)) | (1L << (T__80 - 64)) | (1L << (T__81 - 64)) | (1L << (T__82 - 64)) | (1L << (T__83 - 64)) | (1L << (T__84 - 64)) | (1L << (T__85 - 64)) | (1L << (T__86 - 64)) | (1L << (T__87 - 64)) | (1L << (T__88 - 64)) | (1L << (T__89 - 64)) | (1L << (T__90 - 64)) | (1L << (T__91 - 64)) | (1L << (T__92 - 64)) | (1L << (T__93 - 64)) | (1L << (T__94 - 64)) | (1L << (T__95 - 64)) | (1L << (T__96 - 64)) | (1L << (T__97 - 64)) | (1L << (T__98 - 64)) | (1L << (T__99 - 64)) | (1L << (T__100 - 64)) | (1L << (T__101 - 64)) | (1L << (T__104 - 64)) | (1L << (T__105 - 64)) | (1L << (T__106 - 64)) | (1L << (T__107 - 64)) | (1L << (T__108 - 64)) | (1L << (T__109 - 64)) | (1L << (T__110 - 64)) | (1L << (T__111 - 64)) | (1L << (T__112 - 64)) | (1L << (T__113 - 64)) | (1L << (T__117 - 64)) | (1L << (T__118 - 64)) | (1L << (T__120 - 64)) | (1L << (T__121 - 64)) | (1L << (T__122 - 64)) | (1L << (T__123 - 64)) | (1L << (T__124 - 64)) | (1L << (T__125 - 64)) | (1L << (T__126 - 64)))) != 0) || ((((_la - 128)) & ~0x3f) == 0 && ((1L << (_la - 128)) & ((1L << (T__127 - 128)) | (1L << (T__128 - 128)) | (1L << (T__129 - 128)) | (1L << (T__130 - 128)) | (1L << (T__131 - 128)) | (1L << (T__132 - 128)) | (1L << (T__136 - 128)) | (1L << (T__137 - 128)) | (1L << (T__139 - 128)) | (1L << (T__140 - 128)) | (1L << (T__141 - 128)) | (1L << (T__142 - 128)) | (1L << (T__143 - 128)) | (1L << (T__144 - 128)) | (1L << (T__145 - 128)) | (1L << (T__146 - 128)) | (1L << (T__147 - 128)) | (1L << (T__148 - 128)) | (1L << (T__152 - 128)) | (1L << (T__153 - 128)) | (1L << (T__154 - 128)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeNameIdentifierContext extends ParserRuleContext {
		public TypeNameIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeNameIdentifier; }
	}

	public final TypeNameIdentifierContext typeNameIdentifier() throws RecognitionException {
		TypeNameIdentifierContext _localctx = new TypeNameIdentifierContext(_ctx, getState());
		enterRule(_localctx, 192, RULE_typeNameIdentifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1140);
			_la = _input.LA(1);
			if ( !(_la==T__89 || _la==T__90 || _la==T__153 || _la==T__154) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReferentialIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public KeywordIdentifierContext keywordIdentifier() {
			return getRuleContext(KeywordIdentifierContext.class,0);
		}
		public ReferentialIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_referentialIdentifier; }
	}

	public final ReferentialIdentifierContext referentialIdentifier() throws RecognitionException {
		ReferentialIdentifierContext _localctx = new ReferentialIdentifierContext(_ctx, getState());
		enterRule(_localctx, 194, RULE_referentialIdentifier);
		try {
			setState(1144);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				enterOuterAlt(_localctx, 1);
				{
				setState(1142);
				identifier();
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__19:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__44:
			case T__49:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__73:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__89:
			case T__90:
			case T__91:
			case T__104:
			case T__105:
			case T__107:
			case T__108:
			case T__109:
			case T__117:
			case T__118:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__139:
			case T__140:
			case T__143:
			case T__147:
			case T__148:
			case T__152:
				enterOuterAlt(_localctx, 2);
				{
				setState(1143);
				keywordIdentifier();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReferentialOrTypeNameIdentifierContext extends ParserRuleContext {
		public ReferentialIdentifierContext referentialIdentifier() {
			return getRuleContext(ReferentialIdentifierContext.class,0);
		}
		public TypeNameIdentifierContext typeNameIdentifier() {
			return getRuleContext(TypeNameIdentifierContext.class,0);
		}
		public ReferentialOrTypeNameIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_referentialOrTypeNameIdentifier; }
	}

	public final ReferentialOrTypeNameIdentifierContext referentialOrTypeNameIdentifier() throws RecognitionException {
		ReferentialOrTypeNameIdentifierContext _localctx = new ReferentialOrTypeNameIdentifierContext(_ctx, getState());
		enterRule(_localctx, 196, RULE_referentialOrTypeNameIdentifier);
		try {
			setState(1148);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,127,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(1146);
				referentialIdentifier();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(1147);
				typeNameIdentifier();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IdentifierOrFunctionIdentifierContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public FunctionIdentifierContext functionIdentifier() {
			return getRuleContext(FunctionIdentifierContext.class,0);
		}
		public IdentifierOrFunctionIdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_identifierOrFunctionIdentifier; }
	}

	public final IdentifierOrFunctionIdentifierContext identifierOrFunctionIdentifier() throws RecognitionException {
		IdentifierOrFunctionIdentifierContext _localctx = new IdentifierOrFunctionIdentifierContext(_ctx, getState());
		enterRule(_localctx, 198, RULE_identifierOrFunctionIdentifier);
		try {
			setState(1152);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				enterOuterAlt(_localctx, 1);
				{
				setState(1150);
				identifier();
				}
				break;
			case T__0:
			case T__1:
			case T__2:
			case T__3:
			case T__4:
			case T__5:
			case T__6:
			case T__7:
			case T__8:
			case T__9:
			case T__11:
			case T__12:
			case T__17:
			case T__18:
			case T__19:
			case T__20:
			case T__23:
			case T__24:
			case T__26:
			case T__27:
			case T__28:
			case T__29:
			case T__34:
			case T__35:
			case T__36:
			case T__40:
			case T__43:
			case T__44:
			case T__45:
			case T__46:
			case T__47:
			case T__48:
			case T__49:
			case T__50:
			case T__51:
			case T__52:
			case T__53:
			case T__54:
			case T__55:
			case T__56:
			case T__57:
			case T__58:
			case T__59:
			case T__60:
			case T__61:
			case T__62:
			case T__63:
			case T__64:
			case T__65:
			case T__66:
			case T__67:
			case T__68:
			case T__73:
			case T__74:
			case T__75:
			case T__76:
			case T__78:
			case T__79:
			case T__80:
			case T__81:
			case T__82:
			case T__83:
			case T__84:
			case T__85:
			case T__86:
			case T__87:
			case T__88:
			case T__89:
			case T__90:
			case T__91:
			case T__92:
			case T__93:
			case T__94:
			case T__95:
			case T__96:
			case T__97:
			case T__98:
			case T__99:
			case T__100:
			case T__101:
			case T__104:
			case T__105:
			case T__106:
			case T__107:
			case T__108:
			case T__109:
			case T__110:
			case T__111:
			case T__112:
			case T__113:
			case T__117:
			case T__118:
			case T__120:
			case T__121:
			case T__122:
			case T__123:
			case T__124:
			case T__125:
			case T__126:
			case T__127:
			case T__128:
			case T__129:
			case T__130:
			case T__131:
			case T__132:
			case T__136:
			case T__137:
			case T__139:
			case T__140:
			case T__141:
			case T__142:
			case T__143:
			case T__144:
			case T__145:
			case T__146:
			case T__147:
			case T__148:
			case T__152:
			case T__153:
			case T__154:
				enterOuterAlt(_localctx, 2);
				{
				setState(1151);
				functionIdentifier();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IdentifierContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(cqlParser.IDENTIFIER, 0); }
		public TerminalNode DELIMITEDIDENTIFIER() { return getToken(cqlParser.DELIMITEDIDENTIFIER, 0); }
		public TerminalNode QUOTEDIDENTIFIER() { return getToken(cqlParser.QUOTEDIDENTIFIER, 0); }
		public IdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_identifier; }
	}

	public final IdentifierContext identifier() throws RecognitionException {
		IdentifierContext _localctx = new IdentifierContext(_ctx, getState());
		enterRule(_localctx, 200, RULE_identifier);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1154);
			_la = _input.LA(1);
			if ( !(((((_la - 157)) & ~0x3f) == 0 && ((1L << (_la - 157)) & ((1L << (QUOTEDIDENTIFIER - 157)) | (1L << (IDENTIFIER - 157)) | (1L << (DELIMITEDIDENTIFIER - 157)))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExternalConstantContext extends ParserRuleContext {
		public IdentifierContext identifier() {
			return getRuleContext(IdentifierContext.class,0);
		}
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public ExternalConstantContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_externalConstant; }
	}

	public final ExternalConstantContext externalConstant() throws RecognitionException {
		ExternalConstantContext _localctx = new ExternalConstantContext(_ctx, getState());
		enterRule(_localctx, 202, RULE_externalConstant);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1156);
			match(T__155);
			setState(1159);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case QUOTEDIDENTIFIER:
			case IDENTIFIER:
			case DELIMITEDIDENTIFIER:
				{
				setState(1157);
				identifier();
				}
				break;
			case STRING:
				{
				setState(1158);
				match(STRING);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParamListContext extends ParserRuleContext {
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public ParamListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_paramList; }
	}

	public final ParamListContext paramList() throws RecognitionException {
		ParamListContext _localctx = new ParamListContext(_ctx, getState());
		enterRule(_localctx, 204, RULE_paramList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1161);
			expression(0);
			setState(1166);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__14) {
				{
				{
				setState(1162);
				match(T__14);
				setState(1163);
				expression(0);
				}
				}
				setState(1168);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class QuantityContext extends ParserRuleContext {
		public TerminalNode NUMBER() { return getToken(cqlParser.NUMBER, 0); }
		public UnitContext unit() {
			return getRuleContext(UnitContext.class,0);
		}
		public QuantityContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_quantity; }
	}

	public final QuantityContext quantity() throws RecognitionException {
		QuantityContext _localctx = new QuantityContext(_ctx, getState());
		enterRule(_localctx, 206, RULE_quantity);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(1169);
			match(NUMBER);
			setState(1171);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,131,_ctx) ) {
			case 1:
				{
				setState(1170);
				unit();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class UnitContext extends ParserRuleContext {
		public DateTimePrecisionContext dateTimePrecision() {
			return getRuleContext(DateTimePrecisionContext.class,0);
		}
		public PluralDateTimePrecisionContext pluralDateTimePrecision() {
			return getRuleContext(PluralDateTimePrecisionContext.class,0);
		}
		public TerminalNode STRING() { return getToken(cqlParser.STRING, 0); }
		public UnitContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_unit; }
	}

	public final UnitContext unit() throws RecognitionException {
		UnitContext _localctx = new UnitContext(_ctx, getState());
		enterRule(_localctx, 208, RULE_unit);
		try {
			setState(1176);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__81:
			case T__82:
			case T__83:
			case T__84:
			case T__85:
			case T__86:
			case T__87:
			case T__88:
				enterOuterAlt(_localctx, 1);
				{
				setState(1173);
				dateTimePrecision();
				}
				break;
			case T__92:
			case T__93:
			case T__94:
			case T__95:
			case T__96:
			case T__97:
			case T__98:
			case T__99:
				enterOuterAlt(_localctx, 2);
				{
				setState(1174);
				pluralDateTimePrecision();
				}
				break;
			case STRING:
				enterOuterAlt(_localctx, 3);
				{
				setState(1175);
				match(STRING);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 60:
			return simplePath_sempred((SimplePathContext)_localctx, predIndex);
		case 62:
			return expression_sempred((ExpressionContext)_localctx, predIndex);
		case 66:
			return expressionTerm_sempred((ExpressionTermContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean simplePath_sempred(SimplePathContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 2);
		case 1:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean expression_sempred(ExpressionContext _localctx, int predIndex) {
		switch (predIndex) {
		case 2:
			return precpred(_ctx, 8);
		case 3:
			return precpred(_ctx, 7);
		case 4:
			return precpred(_ctx, 6);
		case 5:
			return precpred(_ctx, 5);
		case 6:
			return precpred(_ctx, 4);
		case 7:
			return precpred(_ctx, 3);
		case 8:
			return precpred(_ctx, 2);
		case 9:
			return precpred(_ctx, 1);
		case 10:
			return precpred(_ctx, 16);
		case 11:
			return precpred(_ctx, 15);
		case 12:
			return precpred(_ctx, 11);
		}
		return true;
	}
	private boolean expressionTerm_sempred(ExpressionTermContext _localctx, int predIndex) {
		switch (predIndex) {
		case 13:
			return precpred(_ctx, 7);
		case 14:
			return precpred(_ctx, 6);
		case 15:
			return precpred(_ctx, 5);
		case 16:
			return precpred(_ctx, 21);
		case 17:
			return precpred(_ctx, 20);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u00aa\u049d\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t<\4=\t="+
		"\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4H\tH\4I"+
		"\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR\4S\tS\4T\tT"+
		"\4U\tU\4V\tV\4W\tW\4X\tX\4Y\tY\4Z\tZ\4[\t[\4\\\t\\\4]\t]\4^\t^\4_\t_\4"+
		"`\t`\4a\ta\4b\tb\4c\tc\4d\td\4e\te\4f\tf\4g\tg\4h\th\4i\ti\4j\tj\3\2\5"+
		"\2\u00d6\n\2\3\2\7\2\u00d9\n\2\f\2\16\2\u00dc\13\2\3\2\7\2\u00df\n\2\f"+
		"\2\16\2\u00e2\13\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3\u00ed\n\3\3"+
		"\4\3\4\3\4\3\4\5\4\u00f3\n\4\3\5\3\5\3\5\3\5\5\5\u00f9\n\5\3\6\3\6\3\6"+
		"\3\6\5\6\u00ff\n\6\3\6\3\6\5\6\u0103\n\6\3\7\3\7\3\b\3\b\3\t\5\t\u010a"+
		"\n\t\3\t\3\t\3\t\5\t\u010f\n\t\3\t\3\t\5\t\u0113\n\t\3\n\5\n\u0116\n\n"+
		"\3\n\3\n\3\n\3\n\3\n\3\n\5\n\u011e\n\n\3\13\5\13\u0121\n\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\5\13\u0129\n\13\3\13\5\13\u012c\n\13\3\f\3\f\3\f"+
		"\3\f\3\f\7\f\u0133\n\f\f\f\16\f\u0136\13\f\3\f\3\f\3\r\3\r\3\r\5\r\u013d"+
		"\n\r\3\r\3\r\3\16\3\16\3\17\5\17\u0144\n\17\3\17\3\17\3\17\3\17\3\17\3"+
		"\17\3\17\5\17\u014d\n\17\3\20\5\20\u0150\n\20\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\7\20\u0159\n\20\f\20\16\20\u015c\13\20\3\20\3\20\5\20\u0160"+
		"\n\20\3\21\3\21\3\21\5\21\u0165\n\21\3\21\3\21\3\22\3\22\3\23\3\23\3\24"+
		"\3\24\3\25\3\25\3\26\3\26\3\26\3\26\3\26\5\26\u0176\n\26\3\27\3\27\3\27"+
		"\7\27\u017b\n\27\f\27\16\27\u017e\13\27\3\27\3\27\3\30\3\30\3\31\3\31"+
		"\3\31\3\31\3\31\3\32\3\32\3\32\3\32\3\32\3\33\3\33\3\33\3\33\3\33\7\33"+
		"\u0193\n\33\f\33\16\33\u0196\13\33\3\33\3\33\3\34\3\34\3\34\3\35\3\35"+
		"\3\35\3\35\3\35\7\35\u01a2\n\35\f\35\16\35\u01a5\13\35\3\35\3\35\3\36"+
		"\3\36\3\36\5\36\u01ac\n\36\3\37\3\37\5\37\u01b0\n\37\3\37\3\37\3\37\3"+
		"\37\3 \3 \3 \3 \5 \u01ba\n \3 \3 \3!\3!\5!\u01c0\n!\3!\5!\u01c3\n!\3!"+
		"\3!\3!\3!\3!\3!\7!\u01cb\n!\f!\16!\u01ce\13!\5!\u01d0\n!\3!\3!\3!\5!\u01d5"+
		"\n!\3!\3!\3!\5!\u01da\n!\3\"\3\"\3\"\3#\3#\3$\3$\3$\3$\3$\3$\5$\u01e7"+
		"\n$\3%\3%\3%\3&\3&\3\'\3\'\5\'\u01f0\n\'\3(\3(\3(\3(\3(\3)\3)\3)\3)\3"+
		")\3*\3*\3*\3*\5*\u0200\n*\3*\3*\3*\3*\3*\5*\u0207\n*\3*\5*\u020a\n*\3"+
		"*\3*\3+\3+\3,\3,\3-\3-\3.\3.\5.\u0216\n.\3/\3/\3\60\3\60\5\60\u021c\n"+
		"\60\3\60\7\60\u021f\n\60\f\60\16\60\u0222\13\60\3\60\5\60\u0225\n\60\3"+
		"\60\3\60\5\60\u0229\n\60\3\60\5\60\u022c\n\60\3\61\5\61\u022f\n\61\3\61"+
		"\3\61\3\61\7\61\u0234\n\61\f\61\16\61\u0237\13\61\3\62\3\62\3\62\3\62"+
		"\7\62\u023d\n\62\f\62\16\62\u0240\13\62\3\63\3\63\3\63\3\63\3\64\3\64"+
		"\3\64\3\65\3\65\5\65\u024b\n\65\3\65\3\65\3\66\3\66\5\66\u0251\n\66\3"+
		"\66\3\66\5\66\u0255\n\66\3\66\3\66\3\66\3\67\3\67\3\67\3\67\3\67\3\67"+
		"\3\67\5\67\u0261\n\67\38\38\38\38\38\38\78\u0269\n8\f8\168\u026c\138\5"+
		"8\u026e\n8\39\39\3:\3:\5:\u0274\n:\3;\3;\3;\7;\u0279\n;\f;\16;\u027c\13"+
		";\3;\3;\3<\3<\3<\7<\u0283\n<\f<\16<\u0286\13<\3<\3<\3=\3=\3>\3>\3>\3>"+
		"\3>\3>\3>\3>\3>\3>\3>\7>\u0297\n>\f>\16>\u029a\13>\3?\3?\5?\u029e\n?\3"+
		"@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\5@\u02af\n@\3@\3@\3@\3@\3"+
		"@\3@\3@\3@\3@\3@\3@\3@\3@\3@\5@\u02bf\n@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3"+
		"@\3@\3@\3@\5@\u02ce\n@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3"+
		"@\5@\u02e0\n@\3@\3@\3@\3@\3@\3@\5@\u02e8\n@\3@\3@\3@\3@\3@\7@\u02ef\n"+
		"@\f@\16@\u02f2\13@\3A\3A\3B\3B\3B\3B\5B\u02fa\nB\3C\3C\3D\3D\3D\3D\3D"+
		"\3D\3D\5D\u0305\nD\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D"+
		"\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D"+
		"\3D\3D\3D\3D\3D\3D\3D\5D\u0336\nD\3D\6D\u0339\nD\rD\16D\u033a\3D\3D\3"+
		"D\3D\3D\3D\3D\3D\3D\3D\3D\5D\u0348\nD\5D\u034a\nD\5D\u034c\nD\3D\3D\3"+
		"D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\7D\u035f\nD\fD\16D\u0362\13"+
		"D\3E\3E\3E\3E\3E\3F\3F\3F\3G\3G\3H\3H\3I\3I\3J\3J\5J\u0374\nJ\3J\3J\3"+
		"J\5J\u0379\nJ\3K\5K\u037c\nK\3K\3K\3K\5K\u0381\nK\5K\u0383\nK\3L\5L\u0386"+
		"\nL\3L\3L\5L\u038a\nL\3L\3L\5L\u038e\nL\3L\5L\u0391\nL\3L\5L\u0394\nL"+
		"\3L\3L\5L\u0398\nL\3L\5L\u039b\nL\3L\5L\u039e\nL\3L\5L\u03a1\nL\3L\3L"+
		"\5L\u03a5\nL\3L\5L\u03a8\nL\3L\5L\u03ab\nL\3L\3L\5L\u03af\nL\3L\5L\u03b2"+
		"\nL\3L\5L\u03b5\nL\3L\5L\u03b8\nL\3L\3L\3L\3L\5L\u03be\nL\3L\3L\5L\u03c2"+
		"\nL\3L\5L\u03c5\nL\3L\3L\5L\u03c9\nL\3L\5L\u03cc\nL\3L\3L\5L\u03d0\nL"+
		"\3L\3L\5L\u03d4\nL\5L\u03d6\nL\3M\3M\3M\3M\3M\3M\3M\3M\3M\3M\3M\3M\3M"+
		"\5M\u03e5\nM\3N\3N\5N\u03e9\nN\3O\3O\3O\5O\u03ee\nO\3O\3O\3P\3P\3P\3P"+
		"\3P\5P\u03f7\nP\3Q\3Q\3Q\5Q\u03fc\nQ\3Q\3Q\3R\3R\3R\3R\3S\3S\3S\3S\3S"+
		"\3S\3S\3S\3S\3S\5S\u040e\nS\3T\3T\3T\3T\3T\3T\3T\3U\5U\u0418\nU\3U\3U"+
		"\3U\3U\3U\7U\u041f\nU\fU\16U\u0422\13U\5U\u0424\nU\3U\3U\3V\3V\3V\3V\3"+
		"W\3W\3W\3W\3W\3W\7W\u0432\nW\fW\16W\u0435\13W\5W\u0437\nW\3W\3W\3X\3X"+
		"\3X\3X\3Y\3Y\3Y\3Y\3Y\5Y\u0444\nY\5Y\u0446\nY\3Y\3Y\3Y\3Y\7Y\u044c\nY"+
		"\fY\16Y\u044f\13Y\5Y\u0451\nY\3Y\3Y\3Z\3Z\3Z\3[\3[\3[\3[\3[\5[\u045d\n"+
		"[\3\\\3\\\3\\\3\\\3\\\7\\\u0464\n\\\f\\\16\\\u0467\13\\\3\\\3\\\5\\\u046b"+
		"\n\\\3]\3]\3^\3^\3_\3_\3`\3`\3a\3a\3b\3b\3c\3c\5c\u047b\nc\3d\3d\5d\u047f"+
		"\nd\3e\3e\5e\u0483\ne\3f\3f\3g\3g\3g\5g\u048a\ng\3h\3h\3h\7h\u048f\nh"+
		"\fh\16h\u0492\13h\3i\3i\5i\u0496\ni\3j\3j\3j\5j\u049b\nj\3j\2\5z~\u0086"+
		"k\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@BDF"+
		"HJLNPRTVXZ\\^`bdfhjlnprtvxz|~\u0080\u0082\u0084\u0086\u0088\u008a\u008c"+
		"\u008e\u0090\u0092\u0094\u0096\u0098\u009a\u009c\u009e\u00a0\u00a2\u00a4"+
		"\u00a6\u00a8\u00aa\u00ac\u00ae\u00b0\u00b2\u00b4\u00b6\u00b8\u00ba\u00bc"+
		"\u00be\u00c0\u00c2\u00c4\u00c6\u00c8\u00ca\u00cc\u00ce\u00d0\u00d2\2&"+
		"\3\2\b\t\3\2+-\3\2\61\62\3\2\67:\4\2\30\31HI\4\2,-JK\4\2++LL\3\2MN\3\2"+
		"PS\3\2=?\4\2;;@@\3\2T[\3\2_f\3\2ij\3\2kl\3\2st\4\2\62\62\177\177\3\2\u0080"+
		"\u0081\3\2vy\4\2ijzz\3\2\u0084\u0085\3\2\u0086\u0087\3\2\u0088\u0089\3"+
		"\2\u008b\u008c\3\2\u008e\u0090\3\2\u0093\u0094\3\2>?\4\2!!((\4\2\"\"*"+
		"*\21\2\3\f\16\17\24\27\32\33\35 %\'++.GLOQhktxy{\u0087\u008a\u0097\u009b"+
		"\u009d\25\2\25\25\27\27\32\33%\'++..\60\63\65\65;GMMT[_hmmqt{\u0083\u008a"+
		"\u008d\u0090\u0091\u0093\u0095\u009c\u009d\26\2\3\f\16\17\24\24\26\26"+
		"\35 //\64\64\66:LLNOQS\\^klnpxy\u0084\u0087\u008e\u008f\u0092\u0092\u0096"+
		"\u0097\u009b\u009b\r\2\4\4\24\24\26\26//\61\62<<BBLL\\^kl\u009b\u009d"+
		"\22\2\3\f\16\17\24\27\32\33\35 %\'++.GLOQhktxy{\u0087\u008b\u008c\u008e"+
		"\u0097\u009b\u009d\4\2\\]\u009c\u009d\4\2\u009f\u009f\u00a4\u00a5\2\u0502"+
		"\2\u00d5\3\2\2\2\4\u00ec\3\2\2\2\6\u00ee\3\2\2\2\b\u00f4\3\2\2\2\n\u00fa"+
		"\3\2\2\2\f\u0104\3\2\2\2\16\u0106\3\2\2\2\20\u0109\3\2\2\2\22\u0115\3"+
		"\2\2\2\24\u0120\3\2\2\2\26\u012d\3\2\2\2\30\u013c\3\2\2\2\32\u0140\3\2"+
		"\2\2\34\u0143\3\2\2\2\36\u014f\3\2\2\2 \u0164\3\2\2\2\"\u0168\3\2\2\2"+
		"$\u016a\3\2\2\2&\u016c\3\2\2\2(\u016e\3\2\2\2*\u0175\3\2\2\2,\u017c\3"+
		"\2\2\2.\u0181\3\2\2\2\60\u0183\3\2\2\2\62\u0188\3\2\2\2\64\u018d\3\2\2"+
		"\2\66\u0199\3\2\2\28\u019c\3\2\2\2:\u01ab\3\2\2\2<\u01ad\3\2\2\2>\u01b5"+
		"\3\2\2\2@\u01bd\3\2\2\2B\u01db\3\2\2\2D\u01de\3\2\2\2F\u01e6\3\2\2\2H"+
		"\u01e8\3\2\2\2J\u01eb\3\2\2\2L\u01ef\3\2\2\2N\u01f1\3\2\2\2P\u01f6\3\2"+
		"\2\2R\u01fb\3\2\2\2T\u020d\3\2\2\2V\u020f\3\2\2\2X\u0211\3\2\2\2Z\u0215"+
		"\3\2\2\2\\\u0217\3\2\2\2^\u0219\3\2\2\2`\u022e\3\2\2\2b\u0238\3\2\2\2"+
		"d\u0241\3\2\2\2f\u0245\3\2\2\2h\u0248\3\2\2\2j\u024e\3\2\2\2l\u0259\3"+
		"\2\2\2n\u0262\3\2\2\2p\u026f\3\2\2\2r\u0271\3\2\2\2t\u027a\3\2\2\2v\u0284"+
		"\3\2\2\2x\u0289\3\2\2\2z\u028b\3\2\2\2|\u029d\3\2\2\2~\u02be\3\2\2\2\u0080"+
		"\u02f3\3\2\2\2\u0082\u02f9\3\2\2\2\u0084\u02fb\3\2\2\2\u0086\u034b\3\2"+
		"\2\2\u0088\u0363\3\2\2\2\u008a\u0368\3\2\2\2\u008c\u036b\3\2\2\2\u008e"+
		"\u036d\3\2\2\2\u0090\u036f\3\2\2\2\u0092\u0378\3\2\2\2\u0094\u0382\3\2"+
		"\2\2\u0096\u03d5\3\2\2\2\u0098\u03e4\3\2\2\2\u009a\u03e8\3\2\2\2\u009c"+
		"\u03ea\3\2\2\2\u009e\u03f6\3\2\2\2\u00a0\u03f8\3\2\2\2\u00a2\u03ff\3\2"+
		"\2\2\u00a4\u040d\3\2\2\2\u00a6\u040f\3\2\2\2\u00a8\u0417\3\2\2\2\u00aa"+
		"\u0427\3\2\2\2\u00ac\u042b\3\2\2\2\u00ae\u043a\3\2\2\2\u00b0\u0445\3\2"+
		"\2\2\u00b2\u0454\3\2\2\2\u00b4\u0457\3\2\2\2\u00b6\u045e\3\2\2\2\u00b8"+
		"\u046c\3\2\2\2\u00ba\u046e\3\2\2\2\u00bc\u0470\3\2\2\2\u00be\u0472\3\2"+
		"\2\2\u00c0\u0474\3\2\2\2\u00c2\u0476\3\2\2\2\u00c4\u047a\3\2\2\2\u00c6"+
		"\u047e\3\2\2\2\u00c8\u0482\3\2\2\2\u00ca\u0484\3\2\2\2\u00cc\u0486\3\2"+
		"\2\2\u00ce\u048b\3\2\2\2\u00d0\u0493\3\2\2\2\u00d2\u049a\3\2\2\2\u00d4"+
		"\u00d6\5\6\4\2\u00d5\u00d4\3\2\2\2\u00d5\u00d6\3\2\2\2\u00d6\u00da\3\2"+
		"\2\2\u00d7\u00d9\5\4\3\2\u00d8\u00d7\3\2\2\2\u00d9\u00dc\3\2\2\2\u00da"+
		"\u00d8\3\2\2\2\u00da\u00db\3\2\2\2\u00db\u00e0\3\2\2\2\u00dc\u00da\3\2"+
		"\2\2\u00dd\u00df\5:\36\2\u00de\u00dd\3\2\2\2\u00df\u00e2\3\2\2\2\u00e0"+
		"\u00de\3\2\2\2\u00e0\u00e1\3\2\2\2\u00e1\u00e3\3\2\2\2\u00e2\u00e0\3\2"+
		"\2\2\u00e3\u00e4\7\2\2\3\u00e4\3\3\2\2\2\u00e5\u00ed\5\b\5\2\u00e6\u00ed"+
		"\5\n\6\2\u00e7\u00ed\5\22\n\2\u00e8\u00ed\5\24\13\2\u00e9\u00ed\5\34\17"+
		"\2\u00ea\u00ed\5\36\20\2\u00eb\u00ed\5\20\t\2\u00ec\u00e5\3\2\2\2\u00ec"+
		"\u00e6\3\2\2\2\u00ec\u00e7\3\2\2\2\u00ec\u00e8\3\2\2\2\u00ec\u00e9\3\2"+
		"\2\2\u00ec\u00ea\3\2\2\2\u00ec\u00eb\3\2\2\2\u00ed\5\3\2\2\2\u00ee\u00ef"+
		"\7\3\2\2\u00ef\u00f2\5t;\2\u00f0\u00f1\7\4\2\2\u00f1\u00f3\5&\24\2\u00f2"+
		"\u00f0\3\2\2\2\u00f2\u00f3\3\2\2\2\u00f3\7\3\2\2\2\u00f4\u00f5\7\5\2\2"+
		"\u00f5\u00f8\5.\30\2\u00f6\u00f7\7\4\2\2\u00f7\u00f9\5&\24\2\u00f8\u00f6"+
		"\3\2\2\2\u00f8\u00f9\3\2\2\2\u00f9\t\3\2\2\2\u00fa\u00fb\7\6\2\2\u00fb"+
		"\u00fe\5t;\2\u00fc\u00fd\7\4\2\2\u00fd\u00ff\5&\24\2\u00fe\u00fc\3\2\2"+
		"\2\u00fe\u00ff\3\2\2\2\u00ff\u0102\3\2\2\2\u0100\u0101\7\7\2\2\u0101\u0103"+
		"\5\f\7\2\u0102\u0100\3\2\2\2\u0102\u0103\3\2\2\2\u0103\13\3\2\2\2\u0104"+
		"\u0105\5\u00caf\2\u0105\r\3\2\2\2\u0106\u0107\t\2\2\2\u0107\17\3\2\2\2"+
		"\u0108\u010a\5\16\b\2\u0109\u0108\3\2\2\2\u0109\u010a\3\2\2\2\u010a\u010b"+
		"\3\2\2\2\u010b\u010c\7\n\2\2\u010c\u010e\5\u00caf\2\u010d\u010f\5*\26"+
		"\2\u010e\u010d\3\2\2\2\u010e\u010f\3\2\2\2\u010f\u0112\3\2\2\2\u0110\u0111"+
		"\7\13\2\2\u0111\u0113\5~@\2\u0112\u0110\3\2\2\2\u0112\u0113\3\2\2\2\u0113"+
		"\21\3\2\2\2\u0114\u0116\5\16\b\2\u0115\u0114\3\2\2\2\u0115\u0116\3\2\2"+
		"\2\u0116\u0117\3\2\2\2\u0117\u0118\7\f\2\2\u0118\u0119\5\u00caf\2\u0119"+
		"\u011a\7\r\2\2\u011a\u011d\5\"\22\2\u011b\u011c\7\4\2\2\u011c\u011e\5"+
		"&\24\2\u011d\u011b\3\2\2\2\u011d\u011e\3\2\2\2\u011e\23\3\2\2\2\u011f"+
		"\u0121\5\16\b\2\u0120\u011f\3\2\2\2\u0120\u0121\3\2\2\2\u0121\u0122\3"+
		"\2\2\2\u0122\u0123\7\16\2\2\u0123\u0124\5\u00caf\2\u0124\u0125\7\r\2\2"+
		"\u0125\u0128\5$\23\2\u0126\u0127\7\4\2\2\u0127\u0129\5&\24\2\u0128\u0126"+
		"\3\2\2\2\u0128\u0129\3\2\2\2\u0129\u012b\3\2\2\2\u012a\u012c\5\26\f\2"+
		"\u012b\u012a\3\2\2\2\u012b\u012c\3\2\2\2\u012c\25\3\2\2\2\u012d\u012e"+
		"\7\17\2\2\u012e\u012f\7\20\2\2\u012f\u0134\5\30\r\2\u0130\u0131\7\21\2"+
		"\2\u0131\u0133\5\30\r\2\u0132\u0130\3\2\2\2\u0133\u0136\3\2\2\2\u0134"+
		"\u0132\3\2\2\2\u0134\u0135\3\2\2\2\u0135\u0137\3\2\2\2\u0136\u0134\3\2"+
		"\2\2\u0137\u0138\7\22\2\2\u0138\27\3\2\2\2\u0139\u013a\5\32\16\2\u013a"+
		"\u013b\7\23\2\2\u013b\u013d\3\2\2\2\u013c\u0139\3\2\2\2\u013c\u013d\3"+
		"\2\2\2\u013d\u013e\3\2\2\2\u013e\u013f\5\u00caf\2\u013f\31\3\2\2\2\u0140"+
		"\u0141\5\u00caf\2\u0141\33\3\2\2\2\u0142\u0144\5\16\b\2\u0143\u0142\3"+
		"\2\2\2\u0143\u0144\3\2\2\2\u0144\u0145\3\2\2\2\u0145\u0146\7\24\2\2\u0146"+
		"\u0147\5\u00caf\2\u0147\u0148\7\r\2\2\u0148\u0149\5(\25\2\u0149\u014a"+
		"\7\25\2\2\u014a\u014c\5\30\r\2\u014b\u014d\5\u00b2Z\2\u014c\u014b\3\2"+
		"\2\2\u014c\u014d\3\2\2\2\u014d\35\3\2\2\2\u014e\u0150\5\16\b\2\u014f\u014e"+
		"\3\2\2\2\u014f\u0150\3\2\2\2\u0150\u0151\3\2\2\2\u0151\u0152\7\26\2\2"+
		"\u0152\u0153\5\u00caf\2\u0153\u0154\7\r\2\2\u0154\u0155\7\20\2\2\u0155"+
		"\u015a\5 \21\2\u0156\u0157\7\21\2\2\u0157\u0159\5 \21\2\u0158\u0156\3"+
		"\2\2\2\u0159\u015c\3\2\2\2\u015a\u0158\3\2\2\2\u015a\u015b\3\2\2\2\u015b"+
		"\u015d\3\2\2\2\u015c\u015a\3\2\2\2\u015d\u015f\7\22\2\2\u015e\u0160\5"+
		"\u00b2Z\2\u015f\u015e\3\2\2\2\u015f\u0160\3\2\2\2\u0160\37\3\2\2\2\u0161"+
		"\u0162\5\32\16\2\u0162\u0163\7\23\2\2\u0163\u0165\3\2\2\2\u0164\u0161"+
		"\3\2\2\2\u0164\u0165\3\2\2\2\u0165\u0166\3\2\2\2\u0166\u0167\5\u00caf"+
		"\2\u0167!\3\2\2\2\u0168\u0169\7\u00a6\2\2\u0169#\3\2\2\2\u016a\u016b\7"+
		"\u00a6\2\2\u016b%\3\2\2\2\u016c\u016d\7\u00a6\2\2\u016d\'\3\2\2\2\u016e"+
		"\u016f\7\u00a6\2\2\u016f)\3\2\2\2\u0170\u0176\5,\27\2\u0171\u0176\5\60"+
		"\31\2\u0172\u0176\5\62\32\2\u0173\u0176\5\64\33\2\u0174\u0176\58\35\2"+
		"\u0175\u0170\3\2\2\2\u0175\u0171\3\2\2\2\u0175\u0172\3\2\2\2\u0175\u0173"+
		"\3\2\2\2\u0175\u0174\3\2\2\2\u0176+\3\2\2\2\u0177\u0178\5\\/\2\u0178\u0179"+
		"\7\23\2\2\u0179\u017b\3\2\2\2\u017a\u0177\3\2\2\2\u017b\u017e\3\2\2\2"+
		"\u017c\u017a\3\2\2\2\u017c\u017d\3\2\2\2\u017d\u017f\3\2\2\2\u017e\u017c"+
		"\3\2\2\2\u017f\u0180\5\u00c6d\2\u0180-\3\2\2\2\u0181\u0182\5\u00caf\2"+
		"\u0182/\3\2\2\2\u0183\u0184\7\27\2\2\u0184\u0185\7\30\2\2\u0185\u0186"+
		"\5*\26\2\u0186\u0187\7\31\2\2\u0187\61\3\2\2\2\u0188\u0189\7\32\2\2\u0189"+
		"\u018a\7\30\2\2\u018a\u018b\5*\26\2\u018b\u018c\7\31\2\2\u018c\63\3\2"+
		"\2\2\u018d\u018e\7\33\2\2\u018e\u018f\7\20\2\2\u018f\u0194\5\66\34\2\u0190"+
		"\u0191\7\21\2\2\u0191\u0193\5\66\34\2\u0192\u0190\3\2\2\2\u0193\u0196"+
		"\3\2\2\2\u0194\u0192\3\2\2\2\u0194\u0195\3\2\2\2\u0195\u0197\3\2\2\2\u0196"+
		"\u0194\3\2\2\2\u0197\u0198\7\22\2\2\u0198\65\3\2\2\2\u0199\u019a\5\u00c4"+
		"c\2\u019a\u019b\5*\26\2\u019b\67\3\2\2\2\u019c\u019d\7\34\2\2\u019d\u019e"+
		"\7\30\2\2\u019e\u01a3\5*\26\2\u019f\u01a0\7\21\2\2\u01a0\u01a2\5*\26\2"+
		"\u01a1\u019f\3\2\2\2\u01a2\u01a5\3\2\2\2\u01a3\u01a1\3\2\2\2\u01a3\u01a4"+
		"\3\2\2\2\u01a4\u01a6\3\2\2\2\u01a5\u01a3\3\2\2\2\u01a6\u01a7\7\31\2\2"+
		"\u01a79\3\2\2\2\u01a8\u01ac\5<\37\2\u01a9\u01ac\5> \2\u01aa\u01ac\5@!"+
		"\2\u01ab\u01a8\3\2\2\2\u01ab\u01a9\3\2\2\2\u01ab\u01aa\3\2\2\2\u01ac;"+
		"\3\2\2\2\u01ad\u01af\7\35\2\2\u01ae\u01b0\5\16\b\2\u01af\u01ae\3\2\2\2"+
		"\u01af\u01b0\3\2\2\2\u01b0\u01b1\3\2\2\2\u01b1\u01b2\5\u00caf\2\u01b2"+
		"\u01b3\7\r\2\2\u01b3\u01b4\5~@\2\u01b4=\3\2\2\2\u01b5\u01b9\7\36\2\2\u01b6"+
		"\u01b7\5.\30\2\u01b7\u01b8\7\23\2\2\u01b8\u01ba\3\2\2\2\u01b9\u01b6\3"+
		"\2\2\2\u01b9\u01ba\3\2\2\2\u01ba\u01bb\3\2\2\2\u01bb\u01bc\5\u00caf\2"+
		"\u01bc?\3\2\2\2\u01bd\u01bf\7\35\2\2\u01be\u01c0\5\16\b\2\u01bf\u01be"+
		"\3\2\2\2\u01bf\u01c0\3\2\2\2\u01c0\u01c2\3\2\2\2\u01c1\u01c3\7\37\2\2"+
		"\u01c2\u01c1\3\2\2\2\u01c2\u01c3\3\2\2\2\u01c3\u01c4\3\2\2\2\u01c4\u01c5"+
		"\7 \2\2\u01c5\u01c6\5\u00c8e\2\u01c6\u01cf\7!\2\2\u01c7\u01cc\5B\"\2\u01c8"+
		"\u01c9\7\21\2\2\u01c9\u01cb\5B\"\2\u01ca\u01c8\3\2\2\2\u01cb\u01ce\3\2"+
		"\2\2\u01cc\u01ca\3\2\2\2\u01cc\u01cd\3\2\2\2\u01cd\u01d0\3\2\2\2\u01ce"+
		"\u01cc\3\2\2\2\u01cf\u01c7\3\2\2\2\u01cf\u01d0\3\2\2\2\u01d0\u01d1\3\2"+
		"\2\2\u01d1\u01d4\7\"\2\2\u01d2\u01d3\7#\2\2\u01d3\u01d5\5*\26\2\u01d4"+
		"\u01d2\3\2\2\2\u01d4\u01d5\3\2\2\2\u01d5\u01d6\3\2\2\2\u01d6\u01d9\7\r"+
		"\2\2\u01d7\u01da\5D#\2\u01d8\u01da\7$\2\2\u01d9\u01d7\3\2\2\2\u01d9\u01d8"+
		"\3\2\2\2\u01daA\3\2\2\2\u01db\u01dc\5\u00c4c\2\u01dc\u01dd\5*\26\2\u01dd"+
		"C\3\2\2\2\u01de\u01df\5~@\2\u01dfE\3\2\2\2\u01e0\u01e7\5R*\2\u01e1\u01e7"+
		"\5v<\2\u01e2\u01e3\7!\2\2\u01e3\u01e4\5~@\2\u01e4\u01e5\7\"\2\2\u01e5"+
		"\u01e7\3\2\2\2\u01e6\u01e0\3\2\2\2\u01e6\u01e1\3\2\2\2\u01e6\u01e2\3\2"+
		"\2\2\u01e7G\3\2\2\2\u01e8\u01e9\5F$\2\u01e9\u01ea\5J&\2\u01eaI\3\2\2\2"+
		"\u01eb\u01ec\5\u00caf\2\u01ecK\3\2\2\2\u01ed\u01f0\5N(\2\u01ee\u01f0\5"+
		"P)\2\u01ef\u01ed\3\2\2\2\u01ef\u01ee\3\2\2\2\u01f0M\3\2\2\2\u01f1\u01f2"+
		"\7%\2\2\u01f2\u01f3\5H%\2\u01f3\u01f4\7&\2\2\u01f4\u01f5\5~@\2\u01f5O"+
		"\3\2\2\2\u01f6\u01f7\7\'\2\2\u01f7\u01f8\5H%\2\u01f8\u01f9\7&\2\2\u01f9"+
		"\u01fa\5~@\2\u01faQ\3\2\2\2\u01fb\u01ff\7(\2\2\u01fc\u01fd\5T+\2\u01fd"+
		"\u01fe\7)\2\2\u01fe\u0200\3\2\2\2\u01ff\u01fc\3\2\2\2\u01ff\u0200\3\2"+
		"\2\2\u0200\u0201\3\2\2\2\u0201\u0209\5,\27\2\u0202\u0206\7\r\2\2\u0203"+
		"\u0204\5V,\2\u0204\u0205\5X-\2\u0205\u0207\3\2\2\2\u0206\u0203\3\2\2\2"+
		"\u0206\u0207\3\2\2\2\u0207\u0208\3\2\2\2\u0208\u020a\5Z.\2\u0209\u0202"+
		"\3\2\2\2\u0209\u020a\3\2\2\2\u020a\u020b\3\2\2\2\u020b\u020c\7*\2\2\u020c"+
		"S\3\2\2\2\u020d\u020e\5v<\2\u020eU\3\2\2\2\u020f\u0210\5z>\2\u0210W\3"+
		"\2\2\2\u0211\u0212\t\3\2\2\u0212Y\3\2\2\2\u0213\u0216\5v<\2\u0214\u0216"+
		"\5~@\2\u0215\u0213\3\2\2\2\u0215\u0214\3\2\2\2\u0216[\3\2\2\2\u0217\u0218"+
		"\5\u00caf\2\u0218]\3\2\2\2\u0219\u021b\5`\61\2\u021a\u021c\5b\62\2\u021b"+
		"\u021a\3\2\2\2\u021b\u021c\3\2\2\2\u021c\u0220\3\2\2\2\u021d\u021f\5L"+
		"\'\2\u021e\u021d\3\2\2\2\u021f\u0222\3\2\2\2\u0220\u021e\3\2\2\2\u0220"+
		"\u0221\3\2\2\2\u0221\u0224\3\2\2\2\u0222\u0220\3\2\2\2\u0223\u0225\5f"+
		"\64\2\u0224\u0223\3\2\2\2\u0224\u0225\3\2\2\2\u0225\u0228\3\2\2\2\u0226"+
		"\u0229\5j\66\2\u0227\u0229\5h\65\2\u0228\u0226\3\2\2\2\u0228\u0227\3\2"+
		"\2\2\u0228\u0229\3\2\2\2\u0229\u022b\3\2\2\2\u022a\u022c\5n8\2\u022b\u022a"+
		"\3\2\2\2\u022b\u022c\3\2\2\2\u022c_\3\2\2\2\u022d\u022f\7\25\2\2\u022e"+
		"\u022d\3\2\2\2\u022e\u022f\3\2\2\2\u022f\u0230\3\2\2\2\u0230\u0235\5H"+
		"%\2\u0231\u0232\7\21\2\2\u0232\u0234\5H%\2\u0233\u0231\3\2\2\2\u0234\u0237"+
		"\3\2\2\2\u0235\u0233\3\2\2\2\u0235\u0236\3\2\2\2\u0236a\3\2\2\2\u0237"+
		"\u0235\3\2\2\2\u0238\u0239\7.\2\2\u0239\u023e\5d\63\2\u023a\u023b\7\21"+
		"\2\2\u023b\u023d\5d\63\2\u023c\u023a\3\2\2\2\u023d\u0240\3\2\2\2\u023e"+
		"\u023c\3\2\2\2\u023e\u023f\3\2\2\2\u023fc\3\2\2\2\u0240\u023e\3\2\2\2"+
		"\u0241\u0242\5\u00caf\2\u0242\u0243\7\r\2\2\u0243\u0244\5~@\2\u0244e\3"+
		"\2\2\2\u0245\u0246\7/\2\2\u0246\u0247\5~@\2\u0247g\3\2\2\2\u0248\u024a"+
		"\7\60\2\2\u0249\u024b\t\4\2\2\u024a\u0249\3\2\2\2\u024a\u024b\3\2\2\2"+
		"\u024b\u024c\3\2\2\2\u024c\u024d\5~@\2\u024di\3\2\2\2\u024e\u0250\7\63"+
		"\2\2\u024f\u0251\t\4\2\2\u0250\u024f\3\2\2\2\u0250\u0251\3\2\2\2\u0251"+
		"\u0252\3\2\2\2\u0252\u0254\5\u00caf\2\u0253\u0255\5l\67\2\u0254\u0253"+
		"\3\2\2\2\u0254\u0255\3\2\2\2\u0255\u0256\3\2\2\2\u0256\u0257\7\r\2\2\u0257"+
		"\u0258\5~@\2\u0258k\3\2\2\2\u0259\u0260\7\64\2\2\u025a\u0261\5|?\2\u025b"+
		"\u0261\5\u00d0i\2\u025c\u025d\7!\2\2\u025d\u025e\5~@\2\u025e\u025f\7\""+
		"\2\2\u025f\u0261\3\2\2\2\u0260\u025a\3\2\2\2\u0260\u025b\3\2\2\2\u0260"+
		"\u025c\3\2\2\2\u0261m\3\2\2\2\u0262\u026d\7\65\2\2\u0263\u026e\5p9\2\u0264"+
		"\u0265\7\66\2\2\u0265\u026a\5r:\2\u0266\u0267\7\21\2\2\u0267\u0269\5r"+
		":\2\u0268\u0266\3\2\2\2\u0269\u026c\3\2\2\2\u026a\u0268\3\2\2\2\u026a"+
		"\u026b\3\2\2\2\u026b\u026e\3\2\2\2\u026c\u026a\3\2\2\2\u026d\u0263\3\2"+
		"\2\2\u026d\u0264\3\2\2\2\u026eo\3\2\2\2\u026f\u0270\t\5\2\2\u0270q\3\2"+
		"\2\2\u0271\u0273\5\u0086D\2\u0272\u0274\5p9\2\u0273\u0272\3\2\2\2\u0273"+
		"\u0274\3\2\2\2\u0274s\3\2\2\2\u0275\u0276\5\\/\2\u0276\u0277\7\23\2\2"+
		"\u0277\u0279\3\2\2\2\u0278\u0275\3\2\2\2\u0279\u027c\3\2\2\2\u027a\u0278"+
		"\3\2\2\2\u027a\u027b\3\2\2\2\u027b\u027d\3\2\2\2\u027c\u027a\3\2\2\2\u027d"+
		"\u027e\5\u00caf\2\u027eu\3\2\2\2\u027f\u0280\5x=\2\u0280\u0281\7\23\2"+
		"\2\u0281\u0283\3\2\2\2\u0282\u027f\3\2\2\2\u0283\u0286\3\2\2\2\u0284\u0282"+
		"\3\2\2\2\u0284\u0285\3\2\2\2\u0285\u0287\3\2\2\2\u0286\u0284\3\2\2\2\u0287"+
		"\u0288\5\u00c4c\2\u0288w\3\2\2\2\u0289\u028a\5\u00c4c\2\u028ay\3\2\2\2"+
		"\u028b\u028c\b>\1\2\u028c\u028d\5\u00c4c\2\u028d\u0298\3\2\2\2\u028e\u028f"+
		"\f\4\2\2\u028f\u0290\7\23\2\2\u0290\u0297\5\u00c4c\2\u0291\u0292\f\3\2"+
		"\2\u0292\u0293\7(\2\2\u0293\u0294\5|?\2\u0294\u0295\7*\2\2\u0295\u0297"+
		"\3\2\2\2\u0296\u028e\3\2\2\2\u0296\u0291\3\2\2\2\u0297\u029a\3\2\2\2\u0298"+
		"\u0296\3\2\2\2\u0298\u0299\3\2\2\2\u0299{\3\2\2\2\u029a\u0298\3\2\2\2"+
		"\u029b\u029e\7\u00a6\2\2\u029c\u029e\7\u00a7\2\2\u029d\u029b\3\2\2\2\u029d"+
		"\u029c\3\2\2\2\u029e}\3\2\2\2\u029f\u02a0\b@\1\2\u02a0\u02bf\5\u0086D"+
		"\2\u02a1\u02bf\5R*\2\u02a2\u02bf\5^\60\2\u02a3\u02a4\7A\2\2\u02a4\u02a5"+
		"\5~@\2\u02a5\u02a6\7@\2\2\u02a6\u02a7\5*\26\2\u02a7\u02bf\3\2\2\2\u02a8"+
		"\u02a9\7<\2\2\u02a9\u02bf\5~@\17\u02aa\u02ab\7B\2\2\u02ab\u02bf\5~@\16"+
		"\u02ac\u02ad\7F\2\2\u02ad\u02af\7+\2\2\u02ae\u02ac\3\2\2\2\u02ae\u02af"+
		"\3\2\2\2\u02af\u02b0\3\2\2\2\u02b0\u02b1\5\u0084C\2\u02b1\u02b2\7D\2\2"+
		"\u02b2\u02b3\5\u0086D\2\u02b3\u02b4\7E\2\2\u02b4\u02b5\5\u0086D\2\u02b5"+
		"\u02bf\3\2\2\2\u02b6\u02b7\7G\2\2\u02b7\u02b8\7+\2\2\u02b8\u02b9\5\u0084"+
		"C\2\u02b9\u02ba\7D\2\2\u02ba\u02bb\5\u0086D\2\u02bb\u02bc\7E\2\2\u02bc"+
		"\u02bd\5\u0086D\2\u02bd\u02bf\3\2\2\2\u02be\u029f\3\2\2\2\u02be\u02a1"+
		"\3\2\2\2\u02be\u02a2\3\2\2\2\u02be\u02a3\3\2\2\2\u02be\u02a8\3\2\2\2\u02be"+
		"\u02aa\3\2\2\2\u02be\u02ae\3\2\2\2\u02be\u02b6\3\2\2\2\u02bf\u02f0\3\2"+
		"\2\2\u02c0\u02c1\f\n\2\2\u02c1\u02c2\t\6\2\2\u02c2\u02ef\5~@\13\u02c3"+
		"\u02c4\f\t\2\2\u02c4\u02c5\5\u0096L\2\u02c5\u02c6\5~@\n\u02c6\u02ef\3"+
		"\2\2\2\u02c7\u02c8\f\b\2\2\u02c8\u02c9\t\7\2\2\u02c9\u02ef\5~@\t\u02ca"+
		"\u02cb\f\7\2\2\u02cb\u02cd\t\b\2\2\u02cc\u02ce\5\u008aF\2\u02cd\u02cc"+
		"\3\2\2\2\u02cd\u02ce\3\2\2\2\u02ce\u02cf\3\2\2\2\u02cf\u02ef\5~@\b\u02d0"+
		"\u02d1\f\6\2\2\u02d1\u02d2\7E\2\2\u02d2\u02ef\5~@\7\u02d3\u02d4\f\5\2"+
		"\2\u02d4\u02d5\t\t\2\2\u02d5\u02ef\5~@\6\u02d6\u02d7\f\4\2\2\u02d7\u02d8"+
		"\7O\2\2\u02d8\u02ef\5~@\5\u02d9\u02da\f\3\2\2\u02da\u02db\t\n\2\2\u02db"+
		"\u02ef\5~@\4\u02dc\u02dd\f\22\2\2\u02dd\u02df\7;\2\2\u02de\u02e0\7<\2"+
		"\2\u02df\u02de\3\2\2\2\u02df\u02e0\3\2\2\2\u02e0\u02e1\3\2\2\2\u02e1\u02ef"+
		"\t\13\2\2\u02e2\u02e3\f\21\2\2\u02e3\u02e4\t\f\2\2\u02e4\u02ef\5*\26\2"+
		"\u02e5\u02e7\f\r\2\2\u02e6\u02e8\7C\2\2\u02e7\u02e6\3\2\2\2\u02e7\u02e8"+
		"\3\2\2\2\u02e8\u02e9\3\2\2\2\u02e9\u02ea\7D\2\2\u02ea\u02eb\5\u0086D\2"+
		"\u02eb\u02ec\7E\2\2\u02ec\u02ed\5\u0086D\2\u02ed\u02ef\3\2\2\2\u02ee\u02c0"+
		"\3\2\2\2\u02ee\u02c3\3\2\2\2\u02ee\u02c7\3\2\2\2\u02ee\u02ca\3\2\2\2\u02ee"+
		"\u02d0\3\2\2\2\u02ee\u02d3\3\2\2\2\u02ee\u02d6\3\2\2\2\u02ee\u02d9\3\2"+
		"\2\2\u02ee\u02dc\3\2\2\2\u02ee\u02e2\3\2\2\2\u02ee\u02e5\3\2\2\2\u02ef"+
		"\u02f2\3\2\2\2\u02f0\u02ee\3\2\2\2\u02f0\u02f1\3\2\2\2\u02f1\177\3\2\2"+
		"\2\u02f2\u02f0\3\2\2\2\u02f3\u02f4\t\r\2\2\u02f4\u0081\3\2\2\2\u02f5\u02fa"+
		"\5\u0080A\2\u02f6\u02fa\7\\\2\2\u02f7\u02fa\7]\2\2\u02f8\u02fa\7^\2\2"+
		"\u02f9\u02f5\3\2\2\2\u02f9\u02f6\3\2\2\2\u02f9\u02f7\3\2\2\2\u02f9\u02f8"+
		"\3\2\2\2\u02fa\u0083\3\2\2\2\u02fb\u02fc\t\16\2\2\u02fc\u0085\3\2\2\2"+
		"\u02fd\u02fe\bD\1\2\u02fe\u034c\5\u0098M\2\u02ff\u0300\7g\2\2\u0300\u0301"+
		"\5~@\2\u0301\u0304\7h\2\2\u0302\u0305\5*\26\2\u0303\u0305\5\u00d2j\2\u0304"+
		"\u0302\3\2\2\2\u0304\u0303\3\2\2\2\u0305\u034c\3\2\2\2\u0306\u0307\t\17"+
		"\2\2\u0307\u034c\5\u0086D\24\u0308\u0309\t\20\2\2\u0309\u030a\7m\2\2\u030a"+
		"\u034c\5\u0086D\23\u030b\u030c\5\u0082B\2\u030c\u030d\7\25\2\2\u030d\u030e"+
		"\5\u0086D\22\u030e\u034c\3\2\2\2\u030f\u0310\7F\2\2\u0310\u0311\7+\2\2"+
		"\u0311\u0312\5\u0084C\2\u0312\u0313\7m\2\2\u0313\u0314\5\u0086D\21\u0314"+
		"\u034c\3\2\2\2\u0315\u0316\7G\2\2\u0316\u0317\7+\2\2\u0317\u0318\5\u0084"+
		"C\2\u0318\u0319\7m\2\2\u0319\u031a\5\u0086D\20\u031a\u034c\3\2\2\2\u031b"+
		"\u031c\7n\2\2\u031c\u031d\7m\2\2\u031d\u034c\5\u0086D\17\u031e\u031f\7"+
		"o\2\2\u031f\u0320\7m\2\2\u0320\u034c\5\u0086D\16\u0321\u0322\7p\2\2\u0322"+
		"\u0323\7m\2\2\u0323\u034c\5\u0086D\r\u0324\u0325\7q\2\2\u0325\u0326\7"+
		"\25\2\2\u0326\u034c\5\u0086D\f\u0327\u0328\7r\2\2\u0328\u0329\7\25\2\2"+
		"\u0329\u034c\5\u0086D\13\u032a\u032b\t\21\2\2\u032b\u034c\5,\27\2\u032c"+
		"\u032d\7{\2\2\u032d\u032e\5~@\2\u032e\u032f\7|\2\2\u032f\u0330\5~@\2\u0330"+
		"\u0331\7}\2\2\u0331\u0332\5~@\2\u0332\u034c\3\2\2\2\u0333\u0335\7~\2\2"+
		"\u0334\u0336\5~@\2\u0335\u0334\3\2\2\2\u0335\u0336\3\2\2\2\u0336\u0338"+
		"\3\2\2\2\u0337\u0339\5\u0088E\2\u0338\u0337\3\2\2\2\u0339\u033a\3\2\2"+
		"\2\u033a\u0338\3\2\2\2\u033a\u033b\3\2\2\2\u033b\u033c\3\2\2\2\u033c\u033d"+
		"\7}\2\2\u033d\u033e\5~@\2\u033e\u033f\7l\2\2\u033f\u034c\3\2\2\2\u0340"+
		"\u0341\t\22\2\2\u0341\u034c\5~@\2\u0342\u0343\t\23\2\2\u0343\u0349\5~"+
		"@\2\u0344\u0347\7\u0082\2\2\u0345\u0348\5\u0080A\2\u0346\u0348\5~@\2\u0347"+
		"\u0345\3\2\2\2\u0347\u0346\3\2\2\2\u0348\u034a\3\2\2\2\u0349\u0344\3\2"+
		"\2\2\u0349\u034a\3\2\2\2\u034a\u034c\3\2\2\2\u034b\u02fd\3\2\2\2\u034b"+
		"\u02ff\3\2\2\2\u034b\u0306\3\2\2\2\u034b\u0308\3\2\2\2\u034b\u030b\3\2"+
		"\2\2\u034b\u030f\3\2\2\2\u034b\u0315\3\2\2\2\u034b\u031b\3\2\2\2\u034b"+
		"\u031e\3\2\2\2\u034b\u0321\3\2\2\2\u034b\u0324\3\2\2\2\u034b\u0327\3\2"+
		"\2\2\u034b\u032a\3\2\2\2\u034b\u032c\3\2\2\2\u034b\u0333\3\2\2\2\u034b"+
		"\u0340\3\2\2\2\u034b\u0342\3\2\2\2\u034c\u0360\3\2\2\2\u034d\u034e\f\t"+
		"\2\2\u034e\u034f\7u\2\2\u034f\u035f\5\u0086D\n\u0350\u0351\f\b\2\2\u0351"+
		"\u0352\t\24\2\2\u0352\u035f\5\u0086D\t\u0353\u0354\f\7\2\2\u0354\u0355"+
		"\t\25\2\2\u0355\u035f\5\u0086D\b\u0356\u0357\f\27\2\2\u0357\u0358\7\23"+
		"\2\2\u0358\u035f\5\u009aN\2\u0359\u035a\f\26\2\2\u035a\u035b\7(\2\2\u035b"+
		"\u035c\5~@\2\u035c\u035d\7*\2\2\u035d\u035f\3\2\2\2\u035e\u034d\3\2\2"+
		"\2\u035e\u0350\3\2\2\2\u035e\u0353\3\2\2\2\u035e\u0356\3\2\2\2\u035e\u0359"+
		"\3\2\2\2\u035f\u0362\3\2\2\2\u0360\u035e\3\2\2\2\u0360\u0361\3\2\2\2\u0361"+
		"\u0087\3\2\2\2\u0362\u0360\3\2\2\2\u0363\u0364\7\u0083\2\2\u0364\u0365"+
		"\5~@\2\u0365\u0366\7|\2\2\u0366\u0367\5~@\2\u0367\u0089\3\2\2\2\u0368"+
		"\u0369\5\u0080A\2\u0369\u036a\7m\2\2\u036a\u008b\3\2\2\2\u036b\u036c\t"+
		"\26\2\2\u036c\u008d\3\2\2\2\u036d\u036e\t\27\2\2\u036e\u008f\3\2\2\2\u036f"+
		"\u0370\t\30\2\2\u0370\u0091\3\2\2\2\u0371\u0373\5\u00d0i\2\u0372\u0374"+
		"\5\u008eH\2\u0373\u0372\3\2\2\2\u0373\u0374\3\2\2\2\u0374\u0379\3\2\2"+
		"\2\u0375\u0376\5\u0090I\2\u0376\u0377\5\u00d0i\2\u0377\u0379\3\2\2\2\u0378"+
		"\u0371\3\2\2\2\u0378\u0375\3\2\2\2\u0379\u0093\3\2\2\2\u037a\u037c\7\u008a"+
		"\2\2\u037b\u037a\3\2\2\2\u037b\u037c\3\2\2\2\u037c\u037d\3\2\2\2\u037d"+
		"\u0383\t\31\2\2\u037e\u0380\t\31\2\2\u037f\u0381\7\u008d\2\2\u0380\u037f"+
		"\3\2\2\2\u0380\u0381\3\2\2\2\u0381\u0383\3\2\2\2\u0382\u037b\3\2\2\2\u0382"+
		"\u037e\3\2\2\2\u0383\u0095\3\2\2\2\u0384\u0386\t\32\2\2\u0385\u0384\3"+
		"\2\2\2\u0385\u0386\3\2\2\2\u0386\u0387\3\2\2\2\u0387\u0389\7\u0091\2\2"+
		"\u0388\u038a\5\u0080A\2\u0389\u0388\3\2\2\2\u0389\u038a\3\2\2\2\u038a"+
		"\u038d\3\2\2\2\u038b\u038e\5\u008cG\2\u038c\u038e\7@\2\2\u038d\u038b\3"+
		"\2\2\2\u038d\u038c\3\2\2\2\u038e\u0390\3\2\2\2\u038f\u0391\t\20\2\2\u0390"+
		"\u038f\3\2\2\2\u0390\u0391\3\2\2\2\u0391\u03d6\3\2\2\2\u0392\u0394\7C"+
		"\2\2\u0393\u0392\3\2\2\2\u0393\u0394\3\2\2\2\u0394\u0395\3\2\2\2\u0395"+
		"\u0397\7\u0092\2\2\u0396\u0398\5\u008aF\2\u0397\u0396\3\2\2\2\u0397\u0398"+
		"\3\2\2\2\u0398\u039a\3\2\2\2\u0399\u039b\t\20\2\2\u039a\u0399\3\2\2\2"+
		"\u039a\u039b\3\2\2\2\u039b\u03d6\3\2\2\2\u039c\u039e\t\32\2\2\u039d\u039c"+
		"\3\2\2\2\u039d\u039e\3\2\2\2\u039e\u03a0\3\2\2\2\u039f\u03a1\7C\2\2\u03a0"+
		"\u039f\3\2\2\2\u03a0\u03a1\3\2\2\2\u03a1\u03a2\3\2\2\2\u03a2\u03a4\t\33"+
		"\2\2\u03a3\u03a5\5\u008aF\2\u03a4\u03a3\3\2\2\2\u03a4\u03a5\3\2\2\2\u03a5"+
		"\u03d6\3\2\2\2\u03a6\u03a8\t\32\2\2\u03a7\u03a6\3\2\2\2\u03a7\u03a8\3"+
		"\2\2\2\u03a8\u03aa\3\2\2\2\u03a9\u03ab\5\u0092J\2\u03aa\u03a9\3\2\2\2"+
		"\u03aa\u03ab\3\2\2\2\u03ab\u03ac\3\2\2\2\u03ac\u03ae\5\u0094K\2\u03ad"+
		"\u03af\5\u008aF\2\u03ae\u03ad\3\2\2\2\u03ae\u03af\3\2\2\2\u03af\u03b1"+
		"\3\2\2\2\u03b0\u03b2\t\20\2\2\u03b1\u03b0\3\2\2\2\u03b1\u03b2\3\2\2\2"+
		"\u03b2\u03d6\3\2\2\2\u03b3\u03b5\t\32\2\2\u03b4\u03b3\3\2\2\2\u03b4\u03b5"+
		"\3\2\2\2\u03b5\u03b7\3\2\2\2\u03b6\u03b8\7C\2\2\u03b7\u03b6\3\2\2\2\u03b7"+
		"\u03b8\3\2\2\2\u03b8\u03b9\3\2\2\2\u03b9\u03ba\7\u0095\2\2\u03ba\u03bb"+
		"\5\u00d0i\2\u03bb\u03bd\7m\2\2\u03bc\u03be\t\20\2\2\u03bd\u03bc\3\2\2"+
		"\2\u03bd\u03be\3\2\2\2\u03be\u03d6\3\2\2\2\u03bf\u03c1\7\u0096\2\2\u03c0"+
		"\u03c2\t\31\2\2\u03c1\u03c0\3\2\2\2\u03c1\u03c2\3\2\2\2\u03c2\u03c4\3"+
		"\2\2\2\u03c3\u03c5\5\u008aF\2\u03c4\u03c3\3\2\2\2\u03c4\u03c5\3\2\2\2"+
		"\u03c5\u03d6\3\2\2\2\u03c6\u03c8\7\u0097\2\2\u03c7\u03c9\t\31\2\2\u03c8"+
		"\u03c7\3\2\2\2\u03c8\u03c9\3\2\2\2\u03c9\u03cb\3\2\2\2\u03ca\u03cc\5\u008a"+
		"F\2\u03cb\u03ca\3\2\2\2\u03cb\u03cc\3\2\2\2\u03cc\u03d6\3\2\2\2\u03cd"+
		"\u03cf\7\u008e\2\2\u03ce\u03d0\5\u008aF\2\u03cf\u03ce\3\2\2\2\u03cf\u03d0"+
		"\3\2\2\2\u03d0\u03d6\3\2\2\2\u03d1\u03d3\7\u008f\2\2\u03d2\u03d4\5\u008a"+
		"F\2\u03d3\u03d2\3\2\2\2\u03d3\u03d4\3\2\2\2\u03d4\u03d6\3\2\2\2\u03d5"+
		"\u0385\3\2\2\2\u03d5\u0393\3\2\2\2\u03d5\u039d\3\2\2\2\u03d5\u03a7\3\2"+
		"\2\2\u03d5\u03b4\3\2\2\2\u03d5\u03bf\3\2\2\2\u03d5\u03c6\3\2\2\2\u03d5"+
		"\u03cd\3\2\2\2\u03d5\u03d1\3\2\2\2\u03d6\u0097\3\2\2\2\u03d7\u03e5\5\u009e"+
		"P\2\u03d8\u03e5\5\u00a4S\2\u03d9\u03e5\5\u00ccg\2\u03da\u03e5\5\u00a6"+
		"T\2\u03db\u03e5\5\u00a8U\2\u03dc\u03e5\5\u00acW\2\u03dd\u03e5\5\u00b0"+
		"Y\2\u03de\u03e5\5\u00b4[\2\u03df\u03e5\5\u00b6\\\2\u03e0\u03e1\7!\2\2"+
		"\u03e1\u03e2\5~@\2\u03e2\u03e3\7\"\2\2\u03e3\u03e5\3\2\2\2\u03e4\u03d7"+
		"\3\2\2\2\u03e4\u03d8\3\2\2\2\u03e4\u03d9\3\2\2\2\u03e4\u03da\3\2\2\2\u03e4"+
		"\u03db\3\2\2\2\u03e4\u03dc\3\2\2\2\u03e4\u03dd\3\2\2\2\u03e4\u03de\3\2"+
		"\2\2\u03e4\u03df\3\2\2\2\u03e4\u03e0\3\2\2\2\u03e5\u0099\3\2\2\2\u03e6"+
		"\u03e9\5\u00c4c\2\u03e7\u03e9\5\u009cO\2\u03e8\u03e6\3\2\2\2\u03e8\u03e7"+
		"\3\2\2\2\u03e9\u009b\3\2\2\2\u03ea\u03eb\5\u00c8e\2\u03eb\u03ed\7!\2\2"+
		"\u03ec\u03ee\5\u00ceh\2\u03ed\u03ec\3\2\2\2\u03ed\u03ee\3\2\2\2\u03ee"+
		"\u03ef\3\2\2\2\u03ef\u03f0\7\"\2\2\u03f0\u009d\3\2\2\2\u03f1\u03f7\5\u00c4"+
		"c\2\u03f2\u03f7\5\u00a0Q\2\u03f3\u03f7\7\u0098\2\2\u03f4\u03f7\7\u0099"+
		"\2\2\u03f5\u03f7\7\u009a\2\2\u03f6\u03f1\3\2\2\2\u03f6\u03f2\3\2\2\2\u03f6"+
		"\u03f3\3\2\2\2\u03f6\u03f4\3\2\2\2\u03f6\u03f5\3\2\2\2\u03f7\u009f\3\2"+
		"\2\2\u03f8\u03f9\5\u00c4c\2\u03f9\u03fb\7!\2\2\u03fa\u03fc\5\u00ceh\2"+
		"\u03fb\u03fa\3\2\2\2\u03fb\u03fc\3\2\2\2\u03fc\u03fd\3\2\2\2\u03fd\u03fe"+
		"\7\"\2\2\u03fe\u00a1\3\2\2\2\u03ff\u0400\5\u00d0i\2\u0400\u0401\7\r\2"+
		"\2\u0401\u0402\5\u00d0i\2\u0402\u00a3\3\2\2\2\u0403\u040e\t\34\2\2\u0404"+
		"\u040e\7=\2\2\u0405\u040e\7\u00a6\2\2\u0406\u040e\7\u00a7\2\2\u0407\u040e"+
		"\7\u00a1\2\2\u0408\u040e\7\u00a0\2\2\u0409\u040e\7\u00a2\2\2\u040a\u040e"+
		"\7\u00a3\2\2\u040b\u040e\5\u00d0i\2\u040c\u040e\5\u00a2R\2\u040d\u0403"+
		"\3\2\2\2\u040d\u0404\3\2\2\2\u040d\u0405\3\2\2\2\u040d\u0406\3\2\2\2\u040d"+
		"\u0407\3\2\2\2\u040d\u0408\3\2\2\2\u040d\u0409\3\2\2\2\u040d\u040a\3\2"+
		"\2\2\u040d\u040b\3\2\2\2\u040d\u040c\3\2\2\2\u040e\u00a5\3\2\2\2\u040f"+
		"\u0410\7\32\2\2\u0410\u0411\t\35\2\2\u0411\u0412\5~@\2\u0412\u0413\7\21"+
		"\2\2\u0413\u0414\5~@\2\u0414\u0415\t\36\2\2\u0415\u00a7\3\2\2\2\u0416"+
		"\u0418\7\33\2\2\u0417\u0416\3\2\2\2\u0417\u0418\3\2\2\2\u0418\u0419\3"+
		"\2\2\2\u0419\u0423\7\20\2\2\u041a\u0424\7\r\2\2\u041b\u0420\5\u00aaV\2"+
		"\u041c\u041d\7\21\2\2\u041d\u041f\5\u00aaV\2\u041e\u041c\3\2\2\2\u041f"+
		"\u0422\3\2\2\2\u0420\u041e\3\2\2\2\u0420\u0421\3\2\2\2\u0421\u0424\3\2"+
		"\2\2\u0422\u0420\3\2\2\2\u0423\u041a\3\2\2\2\u0423\u041b\3\2\2\2\u0424"+
		"\u0425\3\2\2\2\u0425\u0426\7\22\2\2\u0426\u00a9\3\2\2\2\u0427\u0428\5"+
		"\u00c4c\2\u0428\u0429\7\r\2\2\u0429\u042a\5~@\2\u042a\u00ab\3\2\2\2\u042b"+
		"\u042c\5,\27\2\u042c\u0436\7\20\2\2\u042d\u0437\7\r\2\2\u042e\u0433\5"+
		"\u00aeX\2\u042f\u0430\7\21\2\2\u0430\u0432\5\u00aeX\2\u0431\u042f\3\2"+
		"\2\2\u0432\u0435\3\2\2\2\u0433\u0431\3\2\2\2\u0433\u0434\3\2\2\2\u0434"+
		"\u0437\3\2\2\2\u0435\u0433\3\2\2\2\u0436\u042d\3\2\2\2\u0436\u042e\3\2"+
		"\2\2\u0437\u0438\3\2\2\2\u0438\u0439\7\22\2\2\u0439\u00ad\3\2\2\2\u043a"+
		"\u043b\5\u00c4c\2\u043b\u043c\7\r\2\2\u043c\u043d\5~@\2\u043d\u00af\3"+
		"\2\2\2\u043e\u0443\7\27\2\2\u043f\u0440\7\30\2\2\u0440\u0441\5*\26\2\u0441"+
		"\u0442\7\31\2\2\u0442\u0444\3\2\2\2\u0443\u043f\3\2\2\2\u0443\u0444\3"+
		"\2\2\2\u0444\u0446\3\2\2\2\u0445\u043e\3\2\2\2\u0445\u0446\3\2\2\2\u0446"+
		"\u0447\3\2\2\2\u0447\u0450\7\20\2\2\u0448\u044d\5~@\2\u0449\u044a\7\21"+
		"\2\2\u044a\u044c\5~@\2\u044b\u0449\3\2\2\2\u044c\u044f\3\2\2\2\u044d\u044b"+
		"\3\2\2\2\u044d\u044e\3\2\2\2\u044e\u0451\3\2\2\2\u044f\u044d\3\2\2\2\u0450"+
		"\u0448\3\2\2\2\u0450\u0451\3\2\2\2\u0451\u0452\3\2\2\2\u0452\u0453\7\22"+
		"\2\2\u0453\u00b1\3\2\2\2\u0454\u0455\7\u009b\2\2\u0455\u0456\7\u00a6\2"+
		"\2\u0456\u00b3\3\2\2\2\u0457\u0458\7\u009c\2\2\u0458\u0459\7\u00a6\2\2"+
		"\u0459\u045a\7\25\2\2\u045a\u045c\5\30\r\2\u045b\u045d\5\u00b2Z\2\u045c"+
		"\u045b\3\2\2\2\u045c\u045d\3\2\2\2\u045d\u00b5\3\2\2\2\u045e\u045f\7\u009d"+
		"\2\2\u045f\u0460\7\20\2\2\u0460\u0465\5\u00b4[\2\u0461\u0462\7\21\2\2"+
		"\u0462\u0464\5\u00b4[\2\u0463\u0461\3\2\2\2\u0464\u0467\3\2\2\2\u0465"+
		"\u0463\3\2\2\2\u0465\u0466\3\2\2\2\u0466\u0468\3\2\2\2\u0467\u0465\3\2"+
		"\2\2\u0468\u046a\7\22\2\2\u0469\u046b\5\u00b2Z\2\u046a\u0469\3\2\2\2\u046a"+
		"\u046b\3\2\2\2\u046b\u00b7\3\2\2\2\u046c\u046d\t\37\2\2\u046d\u00b9\3"+
		"\2\2\2\u046e\u046f\t \2\2\u046f\u00bb\3\2\2\2\u0470\u0471\t!\2\2\u0471"+
		"\u00bd\3\2\2\2\u0472\u0473\t\"\2\2\u0473\u00bf\3\2\2\2\u0474\u0475\t#"+
		"\2\2\u0475\u00c1\3\2\2\2\u0476\u0477\t$\2\2\u0477\u00c3\3\2\2\2\u0478"+
		"\u047b\5\u00caf\2\u0479\u047b\5\u00bc_\2\u047a\u0478\3\2\2\2\u047a\u0479"+
		"\3\2\2\2\u047b\u00c5\3\2\2\2\u047c\u047f\5\u00c4c\2\u047d\u047f\5\u00c2"+
		"b\2\u047e\u047c\3\2\2\2\u047e\u047d\3\2\2\2\u047f\u00c7\3\2\2\2\u0480"+
		"\u0483\5\u00caf\2\u0481\u0483\5\u00c0a\2\u0482\u0480\3\2\2\2\u0482\u0481"+
		"\3\2\2\2\u0483\u00c9\3\2\2\2\u0484\u0485\t%\2\2\u0485\u00cb\3\2\2\2\u0486"+
		"\u0489\7\u009e\2\2\u0487\u048a\5\u00caf\2\u0488\u048a\7\u00a6\2\2\u0489"+
		"\u0487\3\2\2\2\u0489\u0488\3\2\2\2\u048a\u00cd\3\2\2\2\u048b\u0490\5~"+
		"@\2\u048c\u048d\7\21\2\2\u048d\u048f\5~@\2\u048e\u048c\3\2\2\2\u048f\u0492"+
		"\3\2\2\2\u0490\u048e\3\2\2\2\u0490\u0491\3\2\2\2\u0491\u00cf\3\2\2\2\u0492"+
		"\u0490\3\2\2\2\u0493\u0495\7\u00a7\2\2\u0494\u0496\5\u00d2j\2\u0495\u0494"+
		"\3\2\2\2\u0495\u0496\3\2\2\2\u0496\u00d1\3\2\2\2\u0497\u049b\5\u0080A"+
		"\2\u0498\u049b\5\u0084C\2\u0499\u049b\7\u00a6\2\2\u049a\u0497\3\2\2\2"+
		"\u049a\u0498\3\2\2\2\u049a\u0499\3\2\2\2\u049b\u00d3\3\2\2\2\u0087\u00d5"+
		"\u00da\u00e0\u00ec\u00f2\u00f8\u00fe\u0102\u0109\u010e\u0112\u0115\u011d"+
		"\u0120\u0128\u012b\u0134\u013c\u0143\u014c\u014f\u015a\u015f\u0164\u0175"+
		"\u017c\u0194\u01a3\u01ab\u01af\u01b9\u01bf\u01c2\u01cc\u01cf\u01d4\u01d9"+
		"\u01e6\u01ef\u01ff\u0206\u0209\u0215\u021b\u0220\u0224\u0228\u022b\u022e"+
		"\u0235\u023e\u024a\u0250\u0254\u0260\u026a\u026d\u0273\u027a\u0284\u0296"+
		"\u0298\u029d\u02ae\u02be\u02cd\u02df\u02e7\u02ee\u02f0\u02f9\u0304\u0335"+
		"\u033a\u0347\u0349\u034b\u035e\u0360\u0373\u0378\u037b\u0380\u0382\u0385"+
		"\u0389\u038d\u0390\u0393\u0397\u039a\u039d\u03a0\u03a4\u03a7\u03aa\u03ae"+
		"\u03b1\u03b4\u03b7\u03bd\u03c1\u03c4\u03c8\u03cb\u03cf\u03d3\u03d5\u03e4"+
		"\u03e8\u03ed\u03f6\u03fb\u040d\u0417\u0420\u0423\u0433\u0436\u0443\u0445"+
		"\u044d\u0450\u045c\u0465\u046a\u047a\u047e\u0482\u0489\u0490\u0495\u049a";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}