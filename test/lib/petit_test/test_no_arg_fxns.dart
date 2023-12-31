// ignore_for_file: depend_on_referenced_packages, prefer_single_quotes, always_specify_types

// Package imports:
import 'package:fhir/r4.dart';
import 'package:fhir_path/antlrish/antlrish.dart';
import 'package:fhir_path/petit/parser/parser.dart';
import 'package:test/test.dart';

// Project imports:

void testNoArgFxns() {
  group('Functions w/o Arguments: ', () {
    test('empty', () {
      expect(
          [false],
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'name.family.empty()'));
      expect(
          [false],
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'name.given.empty()'));
      expect(
          [true],
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.language.empty()'));
      expect(
          [true],
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.period.empty()'));
      expect(
          [true],
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: '{ }.empty()'));
    });
    test('allTrue', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.active.allTrue()'),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.deceasedBoolean.allTrue()'),
          [false]);
    });
    test('anyTrue', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.active.anyTrue()'),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.deceasedBoolean.anyTrue()'),
          [false]);
    });
    test('allFalse', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.active.allFalse()'),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.deceasedBoolean.allFalse()'),
          [true]);
    });
    test('anyFalse', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.active.anyFalse()'),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.deceasedBoolean.anyFalse()'),
          [true]);
    });
    test('count', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.count()'),
          [4]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.count()'),
          [8]);
    });
    test('distinct', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.distinct()'),
          [
            {
              'use': 'official',
              'family': 'Faulkenberry',
              'given': ['Jason', 'Grey']
            },
            {
              'family': 'Niel',
              'given': ['Kristin']
            },
            {
              'family': 'Smith',
              'given': ['John', 'Jacob', 'Jingleheimer']
            },
          ]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.distinct()'),
          ['Jason', 'Grey', 'Kristin', 'John', 'Jacob', 'Jingleheimer']);
    });
    test('isDistinct', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.distinct().isDistinct()'),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.distinct().isDistinct()'),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.address.period.isDistinct()'),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.isDistinct()'),
          [false]);
    });
    test('Single', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.telecom.single()'),
          [
            {
              'system': 'email',
              'use': 'mobile',
              'rank': 3,
            },
          ]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.id.single()'),
          []);
    });
    test('First', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.id.first()'),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.first()'),
          ['Jason']);
    });
    test('Last', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.id.last()'),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.last()'),
          ['Jingleheimer']);
    });
    test('Tail', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.id.tail()'),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: 'Patient.name.given.tail()'),
          [
            'Grey',
            'Jason',
            'Grey',
            'Kristin',
            'John',
            'Jacob',
            'Jingleheimer',
          ]);
    });
    test('toBoolean', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'1'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'true'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'t'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'yes'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'y'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'1.0'.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'0'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'false'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'f'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'no'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'n'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'0.0'.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "1.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "0.toBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "1.0.toBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "0.0.toBoolean()"),
          [false]);
    });
    test('convertsToBoolean', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'1'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'true'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'t'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'yes'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'y'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'1.0'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'0'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'false'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'f'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'no'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'n'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'0.0'.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "1.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "0.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "1.0.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "0.0.toBoolean().convertsToBoolean()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "name.first().convertsToBoolean()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "name.given.first().convertsToBoolean()"),
          [false]);
    });
    test('toInteger', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'1'.toInteger()"),
          [1]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'true'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'t'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'yes'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'y'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'1.0'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'0'.toInteger()"),
          [0]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'false'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'f'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'no'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'n'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "'0.0'.toInteger()"),
          []);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "1.toInteger()"),
          [1]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "0.toInteger()"),
          [0]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "1.0.toInteger()"),
          [1]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "0.0.toInteger()"),
          [0]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "true.toInteger()"),
          [1]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(), pathExpression: "false.toInteger()"),
          [0]);
    });
    test('convertsToInteger', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'1'.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'true'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'t'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'yes'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'y'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'1.0'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'0'.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'false'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'f'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'no'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'n'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'0.0'.convertsToInteger()"),
          [false]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "1.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "0.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "1.0.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "0.0.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "true.convertsToInteger()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "false.convertsToInteger()"),
          [true]);
    });
    test('toDate', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "@2021-01-01.toDate()"),
          [FhirDate('2021-01-01')]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'2021-01-01'.toDate()"),
          [FhirDate('2021-01-01')]);
    });
    test('convertsToDate', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "@2021-01-01.convertsToDate()"),
          [true]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'2021-01-01'.convertsToDate()"),
          [true]);
    });
    test('toDateTime', () {
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "@2021-01-01.toDateTime()"),
          [FhirDateTime('2021-01-01')]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'2021-01-01'.toDateTime()"),
          [FhirDateTime('2021-01-01')]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "@2021-01-01T12:12.toDateTime()"),
          [FhirDateTime('2021-01-01T12:12')]);
      expect(
          walkNewFhirPath(
              context: resource.toJson(),
              pathExpression: "'2021-01-01T12:12'.toDateTime()"),
          [FhirDateTime('2021-01-01T12:12')]);
    });
    // test('convertsToDateTime', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2021-01-01.convertsToDateTime()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'2021-01-01'.convertsToDateTime()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2021-01-01T12:12.convertsToDateTime()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'2021-01-01T12:12'.convertsToDateTime()"),
    //       [true]);
    // });
    // test('toDecimal', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'1'.toDecimal()"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'true'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'t'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'yes'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'y'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'1.0'.toDecimal()"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'0'.toDecimal()"),
    //       [0.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'false'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'f'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'no'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'n'.toDecimal()"),
    //       []);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'0.0'.toDecimal()"),
    //       [0.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.toDecimal()"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "0.toDecimal()"),
    //       [0.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.0.toDecimal()"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "0.0.toDecimal()"),
    //       [0.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "true.toDecimal()"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "false.toDecimal()"),
    //       [0.0]);
    // });
    // test('convertsToDecimal', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'1'.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'true'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'t'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'yes'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'y'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'1.0'.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'0'.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'false'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'f'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'no'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'n'.convertsToDecimal()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'0.0'.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "0.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.0.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "0.0.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "true.convertsToDecimal()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "false.convertsToDecimal()"),
    //       [true]);
    // });

    // test('toQuantity', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'4 days'.toQuantity()"),
    //       [FhirPathQuantity(4, 'days')]);

    //   // TODO(Dokotela):  toQuantity - more units
    //   // expect(
    //   //     walkNewFhirPath(
    //   //         context: resource.toJson(),
    //   //         pathExpression: ""10 \'mg[Hg]'".toQuantity()"),
    //   //     ['true']);
    // });

    // test('toQuantity', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'4 days'.convertsToQuantity()"),
    //       [true]);

    //   // TODO(Dokotela): still need to work on recognizing Quantity
    //   // expect(
    //   //     walkNewFhirPath(
    //   //         context: resource.toJson(),
    //   //         pathExpression: ""10 \'mg[Hg]'".convertsToQuantity()"),
    //   //     ['true']);
    // });

    // test('toString', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "true.toString()"),
    //       ['true']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "false.toString()"),
    //       ['false']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.toString()"),
    //       ['1']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "111.toString()"),
    //       ['111']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.1.toString()"),
    //       ['1.1']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "111.1.toString()"),
    //       ['111.1']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.1 'mg'.toString()"),
    //       ["1.1 'mg'"]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.1 'mL'.toString()"),
    //       ["111.1 'mL'"]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2019-08-01.toString()"),
    //       ['2019-08-01']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2021-01-01T12:12.toString()"),
    //       ['2021-01-01T12:12']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "@T12:12.toString()"),
    //       ['12:12']);
    // });
    // test('convertsToString', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "true.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "false.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.1.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.1.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.1 'mg'.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.1 'mL'.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2019-08-01.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2021-01-01T12:12.convertsToString()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@T12:12.convertsToString()"),
    //       [true]);
    // });
    // test('toTime', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "@T12:22.toTime()"),
    //       [FhirTime('12:22')]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@T12:22:33.toTime()"),
    //       [FhirTime('12:22:33')]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'12:22'.toTime()"),
    //       [FhirTime('12:22')]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'12:22:33.321'.toTime()"),
    //       [FhirTime('12:22:33.321')]);
    // });
    // test('convertsToTime', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@T12:22.convertsToTime()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@T12:22:33.convertsToTime()"),
    //       [true]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'T12:22'.convertsToTime()"),
    //       [false]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'12:22:33.321'.convertsToTime()"),
    //       [true]);
    // });
    // test('upper', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'abcdefg'.upper() // 'ABCDEFG'"),
    //       ['ABCDEFG']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'AbCdefg'.upper() // 'ABCDEFG'"),
    //       ['ABCDEFG']);
    // });
    // test('lower', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'ABCDEFG'.lower() // 'abcdefg'"),
    //       ['abcdefg']);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "'aBcDEFG'.lower() // 'abcdefg'"),
    //       ['abcdefg']);
    // });
    // test('Length', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "true.toString().length()"),
    //       [4]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "false.toString().length()"),
    //       [5]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.toString().length()"),
    //       [1]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.toString().length()"),
    //       [3]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.1.toString().length()"),
    //       [3]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.1.toString().length()"),
    //       [5]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.1 'mg'.toString().length()"),
    //       [8]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "111.1 'mL'.toString().length()"),
    //       [10]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2019-08-01.toString().length()"),
    //       [10]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@2021-01-01T12:12.toString().length()"),
    //       [16]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "@T12:12.toString().length()"),
    //       [5]);
    // });
    // test('toChars', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "'true'.toChars()"),
    //       ['t', 'r', 'u', 'e']);
    // });
    // test('abs', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "(-5) // -5"),
    //       [-5]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "(-5).abs() // 5"),
    //       [5]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-5.5).abs() // 5.5"),
    //       [5.5]);
    //   expect(
    //     () => walkNewFhirPath(
    //         context: resource.toJson(), pathExpression: "today() + 5.5 'mg'"),
    //     throwsA(const TypeMatcher<FhirPathEvaluationException>()),
    //   );

    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-5.5 'mg').abs() // 5.5 'mg'"),
    //       [FhirPathQuantity(5.5, "mg")]);
    // });
    // test('ceiling', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.ceiling() // 1"),
    //       [1]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.1.ceiling() // 2"),
    //       [2]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-1.1).ceiling() // -1"),
    //       [-1]);
    // });
    // test('exp', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "0.exp() // 1.0"),
    //       [1.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-0.0).exp() // 1.0"),
    //       [1.0]);
    // });
    // test('floor', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.floor() // 1"),
    //       [1]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "2.1.floor() // 2"),
    //       [2]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-2.1).floor() // -3"),
    //       [-3]);
    // });
    // test('ln', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.ln() // 0.0"),
    //       [0.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "1.0.ln() // 0.0"),
    //       [0.0]);
    // });
    // test('log', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "16.log(2) // 4.0"),
    //       [4.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "100.0.log(10.0) // 2.0"),
    //       [2.0]);
    // });
    // test('sqrt', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(), pathExpression: "81.sqrt() // 9.0"),
    //       [9.0]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-1).sqrt() // empty"),
    //       []);
    // });
    // test('truncate', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "101.truncate() // 101"),
    //       [101]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "1.00000001.truncate() // 1"),
    //       [1]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "(-1.56).truncate() // -1"),
    //       [-1]);
    // });
    // test('children', () {
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "Patient.name.children()"),
    //       [
    //         'official',
    //         'Faulkenberry',
    //         'Jason',
    //         'Grey',
    //         'official',
    //         'Faulkenberry',
    //         'Jason',
    //         'Grey',
    //         'Niel',
    //         'Kristin',
    //         'Smith',
    //         'John',
    //         'Jacob',
    //         'Jingleheimer'
    //       ]);
    //   expect(
    //       walkNewFhirPath(
    //           context: resource.toJson(),
    //           pathExpression: "Patient.address.children()"),
    //       [
    //         {
    //           "extension": [
    //             {
    //               "valueCount": {"unit": "Mg"}
    //             },
    //             {
    //               "valueCount": {"unit": "mL"}
    //             }
    //           ]
    //         },
    //         {
    //           "extension": [
    //             {
    //               "extension": [
    //                 {
    //                   "extension": [
    //                     {
    //                       "extension": [
    //                         {
    //                           "valueCount": {"unit": "Kg"}
    //                         },
    //                         {
    //                           "valueCount": {"unit": "Km"}
    //                         }
    //                       ],
    //                       "valueCount": {"unit": "Kg"}
    //                     },
    //                     {
    //                       "valueCount": {"unit": "Km"}
    //                     }
    //                   ],
    //                   "valueCount": {"unit": "Kg"}
    //                 },
    //                 {
    //                   "valueCount": {"unit": "Km"}
    //                 }
    //               ],
    //               "valueCount": {"unit": "Kg"}
    //             },
    //             {
    //               "valueCount": {"unit": "Km"}
    //             }
    //           ]
    //         },
    //         {
    //           "extension": [
    //             {
    //               "valueCount": {"unit": "Feet"}
    //             },
    //             {
    //               "valueCount": {"unit": "inches"}
    //             }
    //           ]
    //         }
    //       ]);
  });

  // TODO(Dokotela): descendants

  // test('DateTimeFunctions', () {
  //   final startNow = DateTime.now();
  //   final resultNow =
  //       walkNewFhirPath(context: resource.toJson(), pathExpression: "now()");
  //   final endNow = DateTime.now();
  //   expect(
  //       (toDateTime(startNow).isBefore(toDateTime(resultNow.first)) ||
  //               toDateTime(startNow)
  //                   .isAtSameMomentAs(toDateTime(resultNow.first))) &&
  //           (endNow.isAfter(toDateTime(resultNow.first)) ||
  //               toDateTime(endNow)
  //                   .isAtSameMomentAs(toDateTime(resultNow.first))),
  //       true);

  //   final startTimeOfDay = FhirTime(
  //       DateTime.now().toIso8601String().split('T').last.substring(0, 12));
  //   final resultTimeOfDay = walkNewFhirPath(
  //           context: resource.toJson(), pathExpression: "timeOfDay()")
  //       .first;
  //   final endTimeOfDay = FhirTime(
  //       DateTime.now().toIso8601String().split('T').last.substring(0, 12));
  //   expect(
  //       startTimeOfDay <= (resultTimeOfDay as FhirTime) &&
  //           endTimeOfDay >= resultTimeOfDay,
  //       true);
  //   expect(
  //       walkNewFhirPath(context: resource.toJson(), pathExpression: "today()")
  //           .first,
  //       FhirDate(DateTime.now().toIso8601String().split('T').first));
  // });
  // });
}

final resource = Patient(
  active: FhirBoolean(true),
  telecom: [
    ContactPoint(
        system: ContactPointSystem.email,
        use: ContactPointUse.mobile,
        rank: FhirPositiveInt(3)),
  ],
  address: const [
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            valueCount: Count(unit: 'Mg'),
          ),
          FhirExtension(
            valueCount: Count(unit: 'mL'),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            extension_: [
              FhirExtension(
                extension_: [
                  FhirExtension(
                    extension_: [
                      FhirExtension(
                        valueCount: Count(unit: 'Kg'),
                      ),
                      FhirExtension(
                        valueCount: Count(unit: 'Km'),
                      ),
                    ],
                    valueCount: Count(unit: 'Kg'),
                  ),
                  FhirExtension(
                    valueCount: Count(unit: 'Km'),
                  ),
                ],
                valueCount: Count(unit: 'Kg'),
              ),
              FhirExtension(
                valueCount: Count(unit: 'Km'),
              ),
            ],
            valueCount: Count(unit: 'Kg'),
          ),
          FhirExtension(
            valueCount: Count(unit: 'Km'),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            valueCount: Count(unit: 'Feet'),
          ),
          FhirExtension(
            valueCount: Count(unit: 'inches'),
          ),
        ],
      ),
    ),
  ],
  deceasedBoolean: FhirBoolean(false),
  name: const [
    HumanName(
      use: HumanNameUse.official,
      family: 'Faulkenberry',
      given: [
        'Jason',
        'Grey',
      ],
    ),
    HumanName(
      use: HumanNameUse.official,
      family: 'Faulkenberry',
      given: [
        'Jason',
        'Grey',
      ],
    ),
    HumanName(
      family: 'Niel',
      given: [
        'Kristin',
      ],
    ),
    HumanName(
      family: 'Smith',
      given: [
        'John',
        'Jacob',
        'Jingleheimer',
      ],
    ),
  ],
);

DateTime toDateTime(dynamic dateTime) => dateTime is DateTime
    ? dateTime
    : dateTime is FhirDateTime && dateTime.isValid
        ? dateTime.value!
        : DateTime.now();
