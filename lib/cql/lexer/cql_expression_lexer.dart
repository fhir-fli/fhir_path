import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

Parser cqlExpressionLexer() {
  final _cqlExpression = undefined();

  final cqlExpressionPart =

      ///  termExpression
      expressionTermLexer()

          ///  retrieveExpression
          // |
          // retrieve
          ///  queryExpression
          // | query
          ///  booleanExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              string('is') &
              (whiteSpaceLexer & string('not')).optional() &
              whiteSpaceLexer &
              (string('null') | string('true') | string('false')))

          ///  typeExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              (string('is') | string('as')) &
              (whiteSpaceLexer & typeSpecifierLexer()).optional())

          ///  castExpression
          |
          (string('cast') &
              whiteSpaceLexer &
              _cqlExpression &
              whiteSpaceLexer &
              string('as') &
              whiteSpaceLexer &
              typeSpecifierLexer())

          ///  notExpression
          |
          (string('not') & whiteSpaceLexer & _cqlExpression)

          ///  existenceExpression
          |
          (string('exists') & whiteSpaceLexer & _cqlExpression)

          ///  betweenExpression
          // |
          // (_cqlExpression &
          //     (whiteSpaceLexer & string('properly')).optional() &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTermLexer() &
          //     whiteSpaceLexer &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTermLexer())

          /// durationBetweenExpression
          // |
          // (string('duration') &
          //     whiteSpaceLexer &
          //     string('in') &
          //     whiteSpaceLexer &
          //     pluralDateTimePrecisionLexer &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTermLexer() &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTermLexer())

          /// differenceBetweenExpression
          // |
          // (string('difference') &
          //     whiteSpaceLexer &
          //     string('in') &
          //     whiteSpaceLexer &
          //     pluralDateTimePrecisionLexer &
          //     whiteSpaceLexer &
          //     string('between') &
          //     whiteSpaceLexer &
          //     expressionTermLexer() &
          //     whiteSpaceLexer &
          //     string('and') &
          //     whiteSpaceLexer &
          //     expressionTermLexer())

          ///  inequalityExpression
          |
          (_cqlExpression &
              whiteSpaceLexer.optional() &
              (string('<=') | char('<') | char('>') | string('>=')) &
              whiteSpaceLexer.optional() &
              _cqlExpression)

          ///  timingExpression
          // |
          // (_cqlExpression &
          //     whiteSpaceLexer &
          //     intervalOperatorPhraseLexer &
          //     whiteSpaceLexer &
          //     _cqlExpression)

          ///  equalityExpression
          |
          (_cqlExpression &
              whiteSpaceLexer.optional() &
              (char('=') | string('!=') | char('~') | string('!~')) &
              whiteSpaceLexer &
              _cqlExpression)

          ///  membershipExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              (string('in') | string('contains')) &
              (whiteSpaceLexer & dateTimePrecisionSpecifierLexer).optional() &
              whiteSpaceLexer &
              _cqlExpression)

          ///  andExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              string('and') &
              whiteSpaceLexer &
              _cqlExpression)

          ///  orExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              (string('or') | string('xor')) &
              whiteSpaceLexer &
              _cqlExpression)

          ///  impliesExpression
          |
          (_cqlExpression &
              whiteSpaceLexer &
              string('implies') &
              whiteSpaceLexer &
              _cqlExpression)

          ///  inFixSetExpression;
          |
          (_cqlExpression &
              whiteSpaceLexer &
              (char('|') |
                  string('union') |
                  string('intersect') |
                  string('except')) &
              whiteSpaceLexer &
              _cqlExpression);

  _cqlExpression.set(cqlExpressionPart);
  return _cqlExpression;
}

Parser expressionTermLexer() {
  final _expressionTerm = undefined();

  final expressionTermPart =
      // term																# termExpressionTerm
      // |
// invocationExpressionTerm
      (_expressionTerm & char('.') & qualifiedInvocationLexer)
// indexedExpressionTerm
          |
          (_expressionTerm &
              whiteSpaceLexer.optional() &
              char('[') &
              whiteSpaceLexer.optional() &
              cqlExpressionLexer() &
              whiteSpaceLexer.optional() &
              char(']'))
// // conversionExpressionTerm
//           |
//           (string('convert') &
//               whiteSpaceLexer &
//               cqlExpressionLexer() &
//               whiteSpaceLexer &
//               string('to') &
//               whiteSpaceLexer &
//               (typeSpecifierLexer() | unitLexer))
// // polarityExpressionTerm
//           |
//           ((char('+') | char('-')) & _expressionTerm)
// // timeBoundaryExpressionTerm
//           |
//           ((string('start') | string('end')) &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // timeUnitExpressionTerm
//           |
//           (dateTimeComponentLexer &
//               whiteSpaceLexer &
//               string('from') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // durationExpressionTerm
//           |
//           (string('duration') &
//               whiteSpaceLexer &
//               string('in') &
//               whiteSpaceLexer &
//               pluralDateTimePrecisionLexer &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // differenceExpressionTerm
//           |
//           (string('difference') &
//               whiteSpaceLexer &
//               string('in') &
//               whiteSpaceLexer &
//               pluralDateTimePrecisionLexer &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // widthExpressionTerm
//           |
//           (string('width') &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // successorExpressionTerm
//           |
//           (string('successor') &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // predecessorExpressionTerm
//           |
//           (string('predecessor') &
//               whiteSpaceLexer &
//               string('of') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // elementExtractorExpressionTerm
//           |
//           (string('singleton') &
//               whiteSpaceLexer &
//               string('from') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // pointExtractorExpressionTerm
//           |
//           (string('point') &
//               whiteSpaceLexer &
//               string('from') &
//               whiteSpaceLexer &
//               _expressionTerm)
// // typeExtentExpressionTerm
//           |
//           ((string('minimum') | string('maximum')) &
//               whiteSpaceLexer &
//               namedTypeSpecifierLexer)
// // powerExpressionTerm
//           |
//           (_expressionTerm & char('^') & _expressionTerm)
// // multiplicationExpressionTerm
//           |
//           (_expressionTerm &
//               whiteSpaceLexer.optional() &
//               (char('*') |
//                   char('/') |
//                   (string('div') & whiteSpaceLexer.optional()) |
//                   (string('mod') & whiteSpaceLexer.optional())) &
//               _expressionTerm)
// // additionExpressionTerm
//           |
//           (_expressionTerm &
//               whiteSpaceLexer.optional() &
//               (char('+') | char('-') | char('&')) &
//               whiteSpaceLexer.optional() &
//               _expressionTerm)
// // ifThenElseExpressionTerm
//           |
//           (string('if') &
//               whiteSpaceLexer &
//               cqlExpressionLexer() &
//               whiteSpaceLexer &
//               string('then') &
//               whiteSpaceLexer &
//               cqlExpressionLexer() &
//               whiteSpaceLexer &
//               string('else') &
//               whiteSpaceLexer &
//               cqlExpressionLexer())

// // caseExpressionTerm
//           |
//           (string('case') &
//               (whiteSpaceLexer & cqlExpressionLexer()).optional() &
//               whiteSpaceLexer &
//               caseExpressionItemLexer.plus() &
//               whiteSpaceLexer &
//               string('else') &
//               whiteSpaceLexer &
//               cqlExpressionLexer() &
//               whiteSpaceLexer &
//               string('end'))
// // aggregateExpressionTerm
//           |
//           ((string('distinct') | string('flatten')) &
//               whiteSpaceLexer &
//               cqlExpressionLexer())
//           // setAggregateExpressionTerm
//           |
//           ((string('expand') | string('collapse')) &
//               whiteSpaceLexer &
//               cqlExpressionLexer() &
//               (whiteSpaceLexer &
//                       string('per') &
//                       whiteSpaceLexer &
//                       (dateTimePrecisionLexer | cqlExpressionLexer()))
//                   .optional())
      ;

  _expressionTerm.set(expressionTermPart);
  return _expressionTerm;
}

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

final caseExpressionItemLexer = string('when') &
    whiteSpaceLexer &
    cqlExpressionLexer() &
    whiteSpaceLexer &
    string('then') &
    whiteSpaceLexer &
    cqlExpressionLexer();

final qualifiedInvocationLexer =
    referentialIdentifierLexer | qualifiedFunctionLexer;

final qualifiedFunctionLexer = identifierOrFunctionIdentifierLexer &
    whiteSpaceLexer.optional() &
    char('(') &
    whiteSpaceLexer.optional() &
    paramListLexer &
    whiteSpaceLexer.optional() &
    char(')');

final paramListLexer =
    fhirPathLexer() & (char(',') & fhirPathLexer()).optional();
