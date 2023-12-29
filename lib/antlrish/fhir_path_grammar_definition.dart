import 'package:petitparser/petitparser.dart';

class FHIRPathGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() => expression().end();

  Parser expression() => (term() &
          char('.').seq(invocation()).optional() &
          char('[').seq(expression()).seq(char(']')).optional())
      .or(term());

  Parser term() => invocation().or(literal()).or(
        char('(').seq(expression()).seq(char(')')),
      );

  Parser literal() => (string('{}').map((_) => null) |
      (string('true') | string('false')).map((value) => value == 'true') |
      STRING() |
      NUMBER() |
      DATE() |
      DATETIME() |
      TIME() |
      quantity());

  Parser externalConstant() => char('%').seq(identifier().or(STRING()));

  Parser invocation() => identifier().or(function()).or(
        string('\$this') | string('\$index') | string('\$total'),
      );

  Parser function() => identifier().seq(
        char('(').seq(paramList().optional()).seq(char(')')),
      );

  Parser paramList() => expression().plusSeparated(char(','));

  Parser quantity() => (NUMBER().seq(unit().optional()) | unit());

  Parser unit() => (dateTimePrecision() | pluralDateTimePrecision() | STRING());

  Parser dateTimePrecision() => (string('year') |
      string('month') |
      string('week') |
      string('day') |
      string('hour') |
      string('minute') |
      string('second') |
      string('millisecond'));

  Parser pluralDateTimePrecision() => (string('years') |
      string('months') |
      string('weeks') |
      string('days') |
      string('hours') |
      string('minutes') |
      string('seconds') |
      string('milliseconds'));

  Parser typeSpecifier() => qualifiedIdentifier();

  Parser qualifiedIdentifier() =>
      (identifier() & char('.').seq(identifier()).star()).flatten();

  Parser identifier() => IDENTIFIER().or(DELIMITEDIDENTIFIER());

  Parser IDENTIFIER() =>
      pattern('A-Za-z_').seq(pattern('A-Za-z0-9_').star()).flatten();

  Parser DELIMITEDIDENTIFIER() =>
      char('`').seq(pattern('^`').star()).seq(char('`')).flatten();

  Parser STRING() =>
      char('\'').seq(pattern('^\'' ' \n').star()).seq(char('\'')).flatten();

  Parser NUMBER() =>
      digit().plus().seq(char('.').seq(digit().plus()).optional()).flatten();

  Parser DATE() => char('@').seq(DATEFORMAT()).flatten();

  Parser DATEFORMAT() => digit()
      .times(4)
      .seq(
        char('-')
            .seq(digit().times(2).seq(char('-').seq(digit().times(2))))
            .optional(),
      )
      .flatten();

  Parser DATETIME() => char('@')
      .seq(DATEFORMAT())
      .seq(char('T'))
      .seq(TIMEFORMAT())
      .seq(TIMEZONEOFFSETFORMAT().optional())
      .flatten();

  Parser TIME() => char('@').seq(char('T')).seq(TIMEFORMAT()).flatten();

  Parser TIMEFORMAT() => digit()
      .times(2)
      .seq(
        char(':').seq(digit()
            .times(2)
            .seq(
              char(':').seq(digit()
                  .times(2)
                  .seq(char('.').seq(digit().plus()).optional())
                  .optional()),
            )
            .optional()),
      )
      .flatten();

  Parser TIMEZONEOFFSETFORMAT() => string('Z').or(
        char('+')
            .or(char('-'))
            .seq(digit().times(2))
            .seq(char(':'))
            .seq(digit().times(2))
            .flatten(),
      );
}

void main() {
  final grammar = FHIRPathGrammarDefinition();
  final parser = grammar.build();
  final result = parser.parse('expression.to.parse');
  print(result);
}
