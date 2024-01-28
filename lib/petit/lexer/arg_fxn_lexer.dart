// Package imports:
import 'package:petitparser/petitparser.dart';

// Project imports:
import '../petit_fhir_path.dart';

/******************************************************************************
 * All of the below are for functions that accept (but usually don't require)
 * arguments. The Lexers create the function parser, but the arguments are added
 * in the fhirpath_lexer.dart file
 *****************************************************************************/

/// identifies unionFunctions
final Parser<UnionFunctionParser> unionFunctionLexer =
    (string('union(') | string('.union('))
        .map((_) => UnionFunctionParser.empty());

/// identifies combines
final Parser<CombineParser> combineLexer =
    (string('combine(') | string('.combine('))
        .map((_) => CombineParser.empty());

/// identifies toQuantitys
final Parser<ToQuantityParser> toQuantityLexer =
    (string('toQuantity(') | string('.toQuantity('))
        .map((_) => ToQuantityParser.empty());

/// identifies convertsToQuantitys
final Parser<ConvertsToQuantityParser> convertsToQuantityLexer =
    (string('convertsToQuantity(') | string('.convertsToQuantity('))
        .map((_) => ConvertsToQuantityParser.empty());

/// identifies existss
final Parser<ExistsParser> existsLexer =
    (string('exists(') | string('.exists(')).map((_) => ExistsParser.empty());

/// identifies alls
final Parser<AllParser> allLexer =
    (string('all(') | string('.all(')).map((_) => AllParser.empty());

/// identifies subsetOfs
final Parser<SubsetOfParser> subsetOfLexer =
    (string('subsetOf(') | string('.subsetOf('))
        .map((_) => SubsetOfParser.empty());

/// identifies supersetOfs
final Parser<SupersetOfParser> supersetOfLexer =
    (string('supersetOf(') | string('.supersetOf('))
        .map((_) => SupersetOfParser.empty());

/// identifies wheres
final Parser<FpWhereParser> whereLexer =
    (string('where(') | string('.where(')).map((_) => FpWhereParser.empty());

/// identifies selects
final Parser<SelectParser> selectLexer =
    (string('select(') | string('.select(')).map((_) => SelectParser.empty());

/// identifies repeats
final Parser<RepeatParser> repeatLexer =
    (string('repeat(') | string('.repeat(')).map((_) => RepeatParser.empty());

/// identifies ofTypes
final Parser<OfTypeParser> ofTypeLexer =
    (string('ofType(') | string('.ofType(')).map((_) => OfTypeParser.empty());

final Parser<ExtensionParser> extensionLexer =
    (string('extension(') | string('.extension('))
        .map((_) => ExtensionParser.empty());

/// identifies logs
final Parser<LogParser> logLexer =
    (string('log(') | string('.log(')).map((_) => LogParser.empty());

/// identifies powers
final Parser<PowerParser> powerLexer =
    (string('power(') | string('.power(')).map((_) => PowerParser.empty());

/// identifies rounds
final Parser<RoundParser> roundLexer =
    (string('round(') | string('.round(')).map((_) => RoundParser.empty());

/// identifies indexOfs
final Parser<IndexOfParser> indexOfLexer =
    (string('indexOf(') | string('.indexOf('))
        .map((_) => IndexOfParser.empty());

/// identifies substrings
final Parser<SubstringParser> substringLexer =
    (string('substring(') | string('.substring('))
        .map((_) => SubstringParser.empty());

/// identifies startsWiths
final Parser<StartsWithParser> startsWithLexer =
    (string('startsWith(') | string('.startsWith('))
        .map((_) => StartsWithParser.empty());

/// identifies endsWiths
final Parser<EndsWithParser> endsWithLexer =
    (string('endsWith(') | string('.endsWith('))
        .map((_) => EndsWithParser.empty());

/// identifies containsFunctions
final Parser<ContainsFunctionParser> containsFunctionLexer =
    (string('contains(') | string('.contains('))
        .map((_) => ContainsFunctionParser.empty());

/// identifies replaces
final Parser<ReplaceParser> replaceLexer =
    (string('replace(') | string('.replace('))
        .map((_) => ReplaceParser.empty());

/// identifies matchess
final Parser<FpMatchesParser> matchesLexer =
    (string('matches(') | string('.matches('))
        .map((_) => FpMatchesParser.empty());

/// identifies replaceMatchess
final Parser<ReplaceMatchesParser> replaceMatchesLexer =
    (string('replaceMatches(') | string('.replaceMatches('))
        .map((_) => ReplaceMatchesParser.empty());

/// identifies skips
final Parser<FpSkipParser> skipLexer =
    (string('skip(') | string('.skip(')).map((value) => FpSkipParser.empty());

/// identifies takes
final Parser<TakeParser> takeLexer =
    (string('take(') | string('.take(')).map((_) => TakeParser.empty());

/// identifies intersects
final Parser<IntersectParser> intersectLexer =
    (string('intersect(') | string('.intersect('))
        .map((_) => IntersectParser.empty());

/// identifies excludes
final Parser<ExcludeParser> excludeLexer =
    (string('exclude(') | string('.exclude('))
        .map((_) => ExcludeParser.empty());

/// identifies traces
final Parser<TraceParser> traceLexer =
    (string('trace(') | string('.trace(')).map((_) => TraceParser.empty());

/// identifies aggregates
final Parser<AggregateParser> aggregateLexer =
    (string('aggregate(') | string('.aggregate('))
        .map((_) => AggregateParser.empty());

/// identifies iifs
final Parser<IifParser> iifLexer =
    (string('iif(') | string('.iif(')).map((_) => IifParser.empty());
