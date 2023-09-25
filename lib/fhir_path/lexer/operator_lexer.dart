// Package imports:
import 'package:petitparser/petitparser.dart';

// Project imports:
import '../fhir_path.dart';

/******************************************************************************
 * All of the below are for operators that require two arguments. The Lexers 
 * create the operator parser, but the arguments are added in the 
 * fhirpath_lexer.dart file
 * ***************************************************************************/

/// identifies commas
final Parser<CommaParser> commaLexer =
    char(',').map((_) => CommaParser(ParserList([]), ParserList([])));

/// identifies stars
final Parser<StarParser> starLexer =
    char('*').map((_) => StarParser(ParserList([]), ParserList([])));

/// identifies divSigns
final Parser<DivSignParser> divSignLexer =
    char('/').map((_) => DivSignParser(ParserList([]), ParserList([])));

/// identifies divStrings
final Parser<DivStringParser> divStringLexer =
    string(' div ').map((_) => DivStringParser(ParserList([]), ParserList([])));

/// identifies divMods
final Parser<ModParser> modLexer =
    string(' mod ').map((_) => ModParser(ParserList([]), ParserList([])));

final Parser<PlusParser> plusLexer =
    char('+').map((_) => PlusParser(ParserList([]), ParserList([])));

final Parser<MinusParser> minusLexer =
    char('-').map((_) => MinusParser(ParserList([]), ParserList([])));

/// identifies string concatenation ampersand (&)
final Parser<StringConcatenationParser> stringConcatenationLexer = char('&')
    .map((_) => StringConcatenationParser(ParserList([]), ParserList([])));

/// identifies is
final Parser<IsParser> isLexer =
    string(' is ').map((_) => IsParser(ParserList([]), ParserList([])));

/// identifies as
final Parser<AsParser> asLexer =
    string(' as ').map((_) => AsParser(ParserList([]), ParserList([])));

/// identifies unionOperators
final Parser<UnionOperatorParser> unionOperatorLexer =
    char('|').map((_) => UnionOperatorParser(ParserList([]), ParserList([])));

/// identifies greaters
final Parser<GreaterParser> greaterLexer =
    char('>').map((_) => GreaterParser(ParserList([]), ParserList([])));

/// identifies lesss
final Parser<LessParser> lessLexer =
    char('<').map((_) => LessParser(ParserList([]), ParserList([])));

/// identifies greaterEquals
final Parser<GreaterEqualParser> greaterEqualLexer =
    string('>=').map((_) => GreaterEqualParser(ParserList([]), ParserList([])));

/// identifies lessEquals
final Parser<LessEqualParser> lessEqualLexer =
    string('<=').map((_) => LessEqualParser(ParserList([]), ParserList([])));

/// identifies equalss
final Parser<EqualsParser> equalsLexer = (char('=').trim() | char('='))
    .map((_) => EqualsParser(ParserList([]), ParserList([])));

/// identifies equivalents
final Parser<EquivalentParser> equivalentLexer =
    string('~').map((_) => EquivalentParser(ParserList([]), ParserList([])));

/// identifies notEqualss
final Parser<NotEqualsParser> notEqualsLexer =
    string('!=').map((_) => NotEqualsParser(ParserList([]), ParserList([])));

/// identifies notEquivalents
final Parser<NotEquivalentParser> notEquivalentLexer = string('!~')
    .map((_) => NotEquivalentParser(ParserList([]), ParserList([])));

/// identifies ins
final Parser<InParser> inLexer =
    string(' in ').map((_) => InParser(ParserList([]), ParserList([])));

/// identifies contains operators
final Parser<ContainsOperatorParser> containsOperatorLexer =
    string(' contains ')
        .map((_) => ContainsOperatorParser(ParserList([]), ParserList([])));

/// identifies andStrings
final Parser<AndStringParser> andStringLexer =
    string(' and ').map((_) => AndStringParser(ParserList([]), ParserList([])));

/// identifies xors
final Parser<XorParser> xorLexer =
    string(' xor ').map((_) => XorParser(ParserList([]), ParserList([])));

/// identifies orStrings
final Parser<OrStringParser> orStringLexer =
    string(' or ').map((_) => OrStringParser(ParserList([]), ParserList([])));

/// identifies implies
final Parser<ImpliesParser> impliesLexer = string(' implies ')
    .map((_) => ImpliesParser(ParserList([]), ParserList([])));
