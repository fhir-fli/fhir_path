import 'package:fhir_path/antlrish/quantity/ucum/ucum_pkg.dart';
import 'package:test/test.dart';

void main() {
  var pkgs = ['../source-cjs/ucumPkg.dart', '../browser-dist/ucum-lhc.dart'];
  UcumJsonDefs.instance.loadUcumDefs();
  for (var u = 0; u < pkgs.length; u++) {
    var ucum = pkgs[u]; // Assuming you can import the package this way in Dart
    var utils = UcumLhcUtils.instance; // Adjust as per actual implementation

    group('Tests using $ucum', () {
      group('Validate_m2/acr', () {
        group('Validation Return Object', () {
          var returnObj = utils.validateUnitString('m2/acr');
          test("should return status of valid", () {
            expect(returnObj['status'], equals('valid'));
          });
          test("should return a ucumCode = m2/acr", () {
            expect(returnObj['ucumCode'], equals("m2/acr"));
          });
          test("should return empty message array", () {
            expect(returnObj['msg'].length, equals(0));
          });
        });
      });

      group('Convert fathoms to inches', () {
        group('Conversion Return Object', () {
          var returnObj = utils.convertUnitTo(
              fromUnitCode: '[fth_us]', fromVal: 27, toUnitCode: '[in_us]');
          test("should return status = succeeded", () {
            expect(returnObj['status'], equals('succeeded'));
          });
          test("should return toVal = 1943.9999999999998", () {
            expect(returnObj['toVal'], equals(1943.9999999999998));
          });
          test("should return an empty msg array", () {
            expect(returnObj['msg'].length, 0);
          });
          test("should return a fromUnit object with name = fathom - US", () {
            expect(returnObj['fromUnit'].name_, 'fathom - US');
          });
          test("should return a toUnit object with name = inch - US", () {
            expect(returnObj['toUnit'].name_, 'inch - US');
          });
        });
      });

      group('Convert fathoms to bars', () {
        group('Conversion Return Object', () {
          final returnObj = utils.convertUnitTo(
              fromUnitCode: '[fth_us]', fromVal: 27, toUnitCode: 'bar');

          test("should return status = failed", () {
            expect(returnObj['status'], 'failed');
          });

          test("should return toVal = null", () {
            expect(returnObj['toVal'], null);
          });

          test(
              "should return msg = Sorry.  [fth_us] cannot be converted to bar.",
              () {
            expect(
              returnObj['msg'][0],
              "Sorry.  [fth_us] cannot be converted to bar.",
            );
          });

          test("should return a null fromUnit value", () {
            expect(returnObj['fromUnit'], null);
          });

          test("should return a null toUnit value", () {
            expect(returnObj['toUnit'], null);
          });
        });
      });

      group('Convert fathoms to acrs', () {
        group('Conversion Return Object', () {
          final returnObj = utils.convertUnitTo(
              fromUnitCode: '[fth_us]', fromVal: 27, toUnitCode: 'acr');

          test("should return status = failed", () {
            expect(
              returnObj['status'],
              'failed',
              reason: "status = ${returnObj['status'] ?? 'null'}",
            );
          });

          test("should return toVal = null", () {
            expect(
              returnObj['toVal'],
              null,
              reason: "toVal = ${returnObj['toVal'] ?? 'null'}",
            );
          });

          test("should return error message = acr is not a valid unit code.",
              () {
            expect(
              returnObj['msg'].length,
              2,
            );
            expect(
              returnObj['msg'][0],
              "acr is not a valid UCUM code.",
              reason: "msg = ${returnObj['msg'][0] ?? 'null'}",
            );
            expect(
              returnObj['msg'][1],
              "Unable to find a unit for acr, so no conversion could be performed.",
              reason: "msg = ${returnObj['msg'][1] ?? 'null'}",
            );
          });

          test("should return a null fromUnit value", () {
            expect(
              returnObj['fromUnit'],
              null,
              reason: "fromUnit = ${returnObj['fromUnit']}",
            );
          });

          test("should return a null toUnit value", () {
            expect(
              returnObj['toUnit'],
              null,
              reason: "toUnit = ${returnObj['toUnit']}",
            );
          });
        });
      });

      group('Test checkSynonyms', () {
        group('Get synonyms for month', () {
          var resp = utils.checkSynonyms('month');
          test("should return multiple synonyms and at least mo", () {
            expect(resp['status'], equals('succeeded'));
            expect(resp['units'].length, greaterThan(0));
            var foundMonth = resp['units'].any((unit) => unit.code == 'mo');
            expect(foundMonth, isTrue);
          });
        });

        group('Request synonyms for XmU72L', () {
          var resp = utils.checkSynonyms('XmU72L');
          test("should return no synonyms", () {
            expect(resp['status'], equals('failed'));
            expect(resp['units'], isNull);
          });
        });
      });
    });
  }
}
