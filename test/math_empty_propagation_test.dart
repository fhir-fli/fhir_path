import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'support/walk.dart';

/// Regression guard for FHIRPath Math empty-propagation conformance.
///
/// The FHIRPath spec states, per-function, that math functions return an
/// empty collection when the input collection is empty (and `power`/`log`
/// when the exponent/base argument is empty). A single item with >1 element
/// must still signal an error. This previously regressed: every math function
/// did `if (focus.length != 1) throw FHIRPATH_FOCUS`, which wrongly threw on
/// empty too. Keep this test so it cannot recur.
void main() {
  group('Math empty-input propagation -> empty (FHIRPath spec)', () {
    for (final expr in [
      '{}.abs()',
      '{}.ceiling()',
      '{}.exp()',
      '{}.floor()',
      '{}.ln()',
      '{}.log(10)',
      '{}.power(2)',
      '{}.round()',
      '{}.sqrt()',
      '{}.truncate()',
    ]) {
      test('$expr is empty', () async {
        expect(
          await walkPath(context: null, pathExpression: expr),
          isEmpty,
        );
      });
    }
  });

  group('Math empty-argument propagation -> empty', () {
    for (final expr in ['(1).power({})', '(1).log({})']) {
      test('$expr is empty', () async {
        expect(
          await walkPath(context: null, pathExpression: expr),
          isEmpty,
        );
      });
    }
  });

  group('Math >1 input/argument still signals an error', () {
    test('(1 | 2).sqrt() throws', () {
      expect(
        walkPath(context: null, pathExpression: '(1 | 2).sqrt()'),
        throwsA(isA<PathEngineException>()),
      );
    });
    test('(2).power(1 | 2) throws', () {
      expect(
        walkPath(context: null, pathExpression: '(2).power(1 | 2)'),
        throwsA(isA<PathEngineException>()),
      );
    });
  });
}
