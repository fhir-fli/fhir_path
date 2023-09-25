// Package imports:
import 'package:petitparser/petitparser.dart';

// Project imports:
import '../fhir_path.dart';

/******************************************************************************
 * All of the below are for functions that accept (but usually don't require)
 * arguments. The Lexers create the function parser, but the arguments are added
 * in the fhirpath_lexer.dart file
 *****************************************************************************/

/// identifies unionFunctions
final Parser<UnionFunctionParser> unionFunctionLexer =
    (string('union(') | string('.union('))
        .map((_) => UnionFunctionParser(ParserList([])));

/// identifies combines
final Parser<CombineParser> combineLexer =
    (string('combine(') | string('.combine('))
        .map((_) => CombineParser(ParserList([])));

/// identifies toQuantitys
final Parser<ToQuantityParser> toQuantityLexer =
    (string('toQuantity(') | string('.toQuantity('))
        .map((_) => ToQuantityParser());

/// identifies convertsToQuantitys
final Parser<ConvertsToQuantityParser> convertsToQuantityLexer =
    (string('convertsToQuantity(') | string('.convertsToQuantity('))
        .map((_) => ConvertsToQuantityParser());

/// identifies existss
final Parser<ExistsParser> existsLexer =
    (string('exists(') | string('.exists('))
        .map((_) => ExistsParser(ParserList([])));

/// identifies alls
final Parser<AllParser> allLexer =
    (string('all(') | string('.all(')).map((_) => AllParser(ParserList([])));

/// identifies subsetOfs
final Parser<SubsetOfParser> subsetOfLexer =
    (string('subsetOf(') | string('.subsetOf('))
        .map((_) => SubsetOfParser(ParserList([])));

/// identifies supersetOfs
final Parser<SupersetOfParser> supersetOfLexer =
    (string('supersetOf(') | string('.supersetOf('))
        .map((_) => SupersetOfParser());

/// identifies wheres
final Parser<FpWhereParser> whereLexer = (string('where(') | string('.where('))
    .map((_) => FpWhereParser(ParserList([])));

/// identifies selects
final Parser<SelectParser> selectLexer =
    (string('select(') | string('.select('))
        .map((_) => SelectParser(ParserList([])));

/// identifies repeats
final Parser<RepeatParser> repeatLexer =
    (string('repeat(') | string('.repeat('))
        .map((_) => RepeatParser(ParserList([])));

/// identifies ofTypes
final Parser<OfTypeParser> ofTypeLexer =
    (string('ofType(') | string('.ofType('))
        .map((_) => OfTypeParser(ParserList([])));

final Parser<ExtensionParser> extensionLexer =
    (string('extension(') | string('.extension('))
        .map((_) => ExtensionParser(ParserList([])));

/// identifies logs
final Parser<LogParser> logLexer =
    (string('log(') | string('.log(')).map((_) => LogParser(ParserList([])));

/// identifies powers
final Parser<PowerParser> powerLexer = (string('power(') | string('.power('))
    .map((_) => PowerParser(ParserList([])));

/// identifies rounds
final Parser<RoundParser> roundLexer = (string('round(') | string('.round('))
    .map((_) => RoundParser(ParserList([])));

/// identifies indexOfs
final Parser<IndexOfParser> indexOfLexer =
    (string('indexOf(') | string('.indexOf('))
        .map((_) => IndexOfParser(ParserList([])));

/// identifies substrings
final Parser<SubstringParser> substringLexer =
    (string('substring(') | string('.substring('))
        .map((_) => SubstringParser(ParserList([])));

/// identifies startsWiths
final Parser<StartsWithParser> startsWithLexer =
    (string('startsWith(') | string('.startsWith('))
        .map((_) => StartsWithParser(ParserList([])));

/// identifies endsWiths
final Parser<EndsWithParser> endsWithLexer =
    (string('endsWith(') | string('.endsWith('))
        .map((_) => EndsWithParser(ParserList([])));

/// identifies containsFunctions
final Parser<ContainsFunctionParser> containsFunctionLexer =
    (string('contains(') | string('.contains('))
        .map((_) => ContainsFunctionParser(ParserList([])));

/// identifies replaces
final Parser<ReplaceParser> replaceLexer =
    (string('replace(') | string('.replace('))
        .map((_) => ReplaceParser(ParserList([])));

/// identifies matchess
final Parser<FpMatchesParser> matchesLexer =
    (string('matches(') | string('.matches('))
        .map((_) => FpMatchesParser(ParserList([])));

/// identifies replaceMatchess
final Parser<ReplaceMatchesParser> replaceMatchesLexer =
    (string('replaceMatches(') | string('.replaceMatches('))
        .map((_) => ReplaceMatchesParser(ParserList([])));

/// identifies skips
final Parser<FpSkipParser> skipLexer = (string('skip(') | string('.skip('))
    .map((value) => FpSkipParser(ParserList([])));

/// identifies takes
final Parser<TakeParser> takeLexer =
    (string('take(') | string('.take(')).map((_) => TakeParser(ParserList([])));

/// identifies intersects
final Parser<IntersectParser> intersectLexer =
    (string('intersect(') | string('.intersect('))
        .map((_) => IntersectParser(ParserList([])));

/// identifies excludes
final Parser<ExcludeParser> excludeLexer =
    (string('exclude(') | string('.exclude('))
        .map((_) => ExcludeParser(ParserList([])));

/// identifies traces
final Parser<TraceParser> traceLexer = (string('trace(') | string('.trace('))
    .map((_) => TraceParser(ParserList([])));

/// identifies aggregates
final Parser<AggregateParser> aggregateLexer =
    (string('aggregate(') | string('.aggregate('))
        .map((_) => AggregateParser(ParserList([])));

/// identifies iifs
final Parser<IifParser> iifLexer =
    (string('iif(') | string('.iif(')).map((_) => IifParser(ParserList([])));
