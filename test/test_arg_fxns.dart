import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'support/walk.dart';

import 'test_data.dart';

Future<void> testArgFxns() async {
  final fhirPathEngine = await FHIRPathEngine.create(WorkerContext());
  group('Functions with Arguments: ', () {
    test('%variables', () async {
      var node = fhirPathEngine.parse('%var');
      await expectLater(
        fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'var': [5.toFhirInteger],
          },
        ),
        completion(equals([5.toFhirInteger])),
      );

      node = fhirPathEngine.parse('%var');

      // Valid variable
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'var': [5.toFhirInteger],
          },
        ),
        [5.toFhirInteger],
      );

      // Invalid variable
      await expectLater(
        fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'dummy': [5.toFhirInteger],
          },
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );

      // test('Lazy %variables', () async {
      node = fhirPathEngine.parse('%var');

      // Lazy variable with a list
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'var': [5.toFhirInteger],
          },
        ),
        [5.toFhirInteger],
      );

      // Lazy variable with a single value
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'var': () => [5.toFhirInteger],
          },
        ),
        [5.toFhirInteger],
      );

      // Invalid lazy variable
      expect(
        () => fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'dummy': () => [6.toFhirInteger],
          },
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );

      // Mixed variables
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'var': () => [5.toFhirInteger],
            'da_bomb': () => [throw Exception('BOOM!')],
          },
        ),
        [5.toFhirInteger],
      );

      final bombNode = fhirPathEngine.parse('%da_bomb');
      await expectLater(
        fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          bombNode,
          environment: {
            'var': () => 5.toFhirInteger,
            'da_bomb': () => throw Exception('BOOM!'),
          },
        ),
        throwsA(const TypeMatcher<Exception>()),
      );
    });

    test('%variables and math', () async {
      final node = fhirPathEngine.parse('%a + %b + %c > 5');

      // All variables as empty lists
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'a': <FhirBase>[],
            'b': <FhirBase>[],
            'c': [2.toFhirInteger],
          },
        ),
        <FhirBase>[],
      );

      // Lazy variables as empty lists
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'a': () => <FhirBase>[],
            'b': () => <FhirBase>[],
            'c': () => [2.toFhirInteger],
          },
        ),
        <FhirBase>[],
      );

      // Variables with valid values
      expect(
        await fhirPathEngine.evaluateWithContext(
          null,
          null,
          null,
          null,
          node,
          environment: {
            'a': () => [1.toFhirInteger],
            'b': () => [2.toFhirInteger],
            'c': () => [3.toFhirInteger],
          },
        ),
        [true.toFhirBoolean],
      );
    });
  });

  test(r'$this', () async {
    final resource = Patient(
      name: [
        HumanName(
          use: NameUse.official,
          family: 'Faulkenberry'.toFhirString,
          given: ['Jason'.toFhirString, 'Grey'.toFhirString],
        ),
        HumanName(family: 'Niel'.toFhirString, given: ['Kristin'.toFhirString]),
        HumanName(
          family: 'Smith'.toFhirString,
          given: [
            'John'.toFhirString,
            'Jacob'.toFhirString,
            'Jingleheimer'.toFhirString,
          ],
        ),
      ],
    );

    var node = fhirPathEngine.parse(r'Patient.name.exists($this)');
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [true.toFhirBoolean],
    );

    node = fhirPathEngine.parse(r'Patient.name.where($this)');
    expect(
      (await fhirPathEngine.evaluate(resource, node))
          .map((e) => (e as FhirBase).toJson()),
      [
        {
          'use': 'official',
          'family': 'Faulkenberry',
          'given': ['Jason', 'Grey'],
        },
        {
          'family': 'Niel',
          'given': ['Kristin'],
        },
        {
          'family': 'Smith',
          'given': ['John', 'Jacob', 'Jingleheimer'],
        },
      ],
    );

    node = fhirPathEngine.parse(r'Patient.name.given.where($this)');
    expect(
      (await fhirPathEngine.evaluate(resource, node))
          .map((e) => e.primitiveValue),
      ['Jason', 'Grey', 'Kristin', 'John', 'Jacob', 'Jingleheimer'],
    );
  });

  test('exists', () async {
    final resource = Patient(
      name: [
        HumanName(given: ['Jason'.toFhirString, 'Grey'.toFhirString]),
      ],
      telecom: [
        ContactPoint(
          system: ContactPointSystem.email,
          use: ContactPointUse.mobile,
          rank: 3.toFhirPositiveInt,
        ),
      ],
    );

    var node = fhirPathEngine.parse('name.given.exists()');
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [true.toFhirBoolean],
    );

    node = fhirPathEngine.parse('Patient.language.exists()');
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [false.toFhirBoolean],
    );

    node = fhirPathEngine.parse("telecom.exists(system = 'email')");
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [true.toFhirBoolean],
    );

    node = fhirPathEngine
        .parse("telecom.exists(system = 'email' and use = 'mobile')");
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [true.toFhirBoolean],
    );

    node = fhirPathEngine.parse('{}.exists()');
    expect(
      await fhirPathEngine.evaluate(resource, node),
      [false.toFhirBoolean],
    );
  });

  group('Functions with Arguments: ', () {
    test('%variables', () async {
      expect(
        await walkPath(
          context: null,
          pathExpression: '%var',
          environment: {
            'var': [5.toFhirInteger],
          },
        ),
        [5.toFhirInteger],
      );
      await expectLater(
        walkPath(
          context: null,
          pathExpression: '%var',
          environment: {'dummy': 5},
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });
  });
  test('Lazy %variables', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: '%var',
        environment: {
          'var': () => [5.toFhirInteger],
        },
      ),
      [5.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: '%var',
        environment: {
          'var': () => [5.toFhirInteger],
        },
      ),
      [5.toFhirInteger],
    );
    await expectLater(
      walkPath(
        context: null,
        pathExpression: '%var',
        environment: {
          'dummy': () => [6.toFhirInteger],
        },
      ),
      throwsA(const TypeMatcher<PathEngineException>()),
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: '%var',
        environment: {
          'var': () => [5.toFhirInteger],
          'da_bomb': () => [throw Exception('BOOM!')],
        },
      ),
      [5.toFhirInteger],
    );
    await expectLater(
      walkPath(
        context: null,
        pathExpression: '%da_bomb',
        environment: {
          'var': () => [5.toFhirInteger],
          'da_bomb': () => [throw Exception('BOOM!')],
        },
      ),
      throwsA(const TypeMatcher<Exception>()),
    );
  });

  test('%variables and math', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: '%a + %b + %c > 5',
        environment: {
          'a': <FhirBase>[],
          'b': <FhirBase>[],
          'c': [2.toFhirInteger],
        },
      ),
      <FhirBase>[],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: '%a + %b + %c > 5',
        environment: {
          'a': () => <FhirBase>[],
          'b': () => <FhirBase>[],
          'c': () => [2.toFhirInteger],
        },
      ),
      <FhirBase>[],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: '%a + %b + %c > 5',
        environment: {
          'a': () => [1.toFhirInteger],
          'b': () => [2.toFhirInteger],
          'c': () => [3.toFhirInteger],
        },
      ),
      [true.toFhirBoolean],
    );
  });

  test(r'$this', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: r'Patient.name.exists($this)',
      ),
      [true.toFhirBoolean],
    );
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: r'Patient.name.where($this)',
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {
            'use': 'official',
            'family': 'Faulkenberry',
            'given': ['Jason', 'Grey'],
          },
          {
            'use': 'official',
            'family': 'Faulkenberry',
            'given': ['Jason', 'Grey'],
          },
          {
            'family': 'Niel',
            'given': ['Kristin'],
          },
          {
            'family': 'Smith',
            'given': ['John', 'Jacob', 'Jingleheimer'],
          }
        ]);
    expect(
        await walkPath(
          context: patient3,
          pathExpression: r'Patient.name.given.where($this)',
        ),
        [
          'Jason'.toFhirString,
          'Grey'.toFhirString,
          'Jason'.toFhirString,
          'Grey'.toFhirString,
          'Kristin'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);
  });

  test('exists', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'name.given.exists()',
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.language.exists()',
      ),
      [false.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.exists(system = 'email')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.exists(system = 'email' and use = 'mobile')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.exists(system = 'sms' and use = 'mobile')",
      ),
      [false.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.exists(system = 'email' and use = 'any')",
      ),
      [false.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '{}.exists()',
      ),
      [false.toFhirBoolean],
    );
  });

  test('all', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.language.all()',
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "name.all(use = 'official')",
      ),
      [false.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "name.all(use = 'usual')",
      ),
      [false.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.all(system = 'email')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.all(use = 'mobile')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "telecom.all(system = 'email' and use = 'mobile')",
      ),
      [true.toFhirBoolean],
    );
  });

  test('subsetOf', () async {
    final node = fhirPathEngine
        .parse('Patient.name.given[2].subsetOf(Patient.name.given)');
    expect(
      await fhirPathEngine.evaluate(patient3, node),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given[2].subsetOf(Patient.name.given)',
      ),
      [true.toFhirBoolean],
    );

    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.subsetOf(Patient.name.given)',
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.subsetOf(Patient.name.given)',
      ),
      [false.toFhirBoolean],
    );
  });

  test('supersetOf', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.supersetOf(Patient.name.given[2])',
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.supersetOf(Patient.name.given)',
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.supersetOf(Patient.name)',
      ),
      [false.toFhirBoolean],
    );
  });

  test('where', () async {
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: "Patient.telecom.where(use = 'mobile')",
        ))
            .map((e) => e.toJson()),
        [
          {
            'system': 'email',
            'use': 'mobile',
            'rank': 3,
          }
        ]);

    expect(
        (await walkPath(
          context: patient3,
          pathExpression: "Patient.telecom.where(use = 'mobile' and rank = 3)",
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {
            'system': 'email',
            'use': 'mobile',
            'rank': 3,
          }
        ]);
    expect(
        (await walkPath(
          context: patient3,
          pathExpression:
              "Patient.telecom.where(use = 'mobile' and system = 'email')",
        ))
            .map((e) => e.toJson()),
        [
          {
            'system': 'email',
            'use': 'mobile',
            'rank': 3,
          }
        ]);
    expect(
        (await walkPath(
          context: patient3,
          pathExpression:
              "Patient.telecom.where(use = 'mobile' and system = 'email' and "
              'rank = 3)',
        ))
            .map((e) => e.toJson()),
        [
          {
            'system': 'email',
            'use': 'mobile',
            'rank': 3,
          }
        ]);
    expect(
      (await walkPath(
        context: patient3,
        pathExpression: "Patient.telecom.where(use = 'mobile' and rank = 2)",
      ))
          .map((e) => e.toJson()),
      <FhirBase>[],
    );
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: "Patient.name.where(use = 'official')",
        ))
            .map((e) => e.toJson()),
        [
          {
            'use': 'official',
            'family': 'Faulkenberry',
            'given': [
              'Jason',
              'Grey',
            ],
          },
          {
            'use': 'official',
            'family': 'Faulkenberry',
            'given': [
              'Jason',
              'Grey',
            ],
          }
        ]);
  });

  test('select', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.telecom.select(rank as positiveInt)',
      ),
      [3.toFhirPositiveInt],
    );
    expect(
        (await walkPath(
          context: bundle,
          pathExpression: 'Bundle.entry.select(resource as Patient)',
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {'resourceType': 'Patient', 'id': '1'},
          {'resourceType': 'Patient', 'id': '3'},
          {'resourceType': 'Patient', 'id': '6'},
          {'resourceType': 'Patient', 'id': '7'},
        ]);
    expect(
        (await walkPath(
          context: bundle,
          pathExpression: 'Bundle.entry.select(resource as Practitioner)',
        ))
            .map((e) => e.toJson()),
        [
          {'resourceType': 'Practitioner', 'id': '2'},
          {'resourceType': 'Practitioner', 'id': '4'},
          {'resourceType': 'Practitioner', 'id': '5'},
        ]);
  });

  test('repeat', () async {
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: 'Patient.address.period.extension.extension.extension'
              '.repeat(extension)',
        ))
            .map((e) => e.toJson()),
        [
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          },
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Km'},
          }
        ]);
    expect(
        (await walkPath(
          context: patient3,
          pathExpression:
              'Patient.address.period.extension.extension.repeat(extension)',
        ))
            .map((e) => e.toJson()),
        [
          {
            'extension': [
              {
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Kg'},
              },
              {
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Km'},
              }
            ],
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          },
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Km'},
          },
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          }
        ]);
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: 'Patient.address.period.extension.repeat(extension)',
        ))
            .map((e) => e.toJson()),
        [
          {
            'extension': [
              {
                'extension': [
                  {
                    'url': 'www.mayjuun.com',
                    'valueCount': {'unit': 'Kg'},
                  },
                  {
                    'url': 'www.mayjuun.com',
                    'valueCount': {'unit': 'Km'},
                  }
                ],
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Kg'},
              },
              {
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Km'},
              }
            ],
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          },
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Km'},
          },
          {
            'extension': [
              {
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Kg'},
              },
              {
                'url': 'www.mayjuun.com',
                'valueCount': {'unit': 'Km'},
              }
            ],
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          },
          {
            'url': 'www.mayjuun.com',
            'valueCount': {'unit': 'Kg'},
          }
        ]);
  });

  test('ofType', () async {
    expect(
        (await walkPath(
          context: bundle,
          pathExpression: 'Bundle.entry.resource.ofType(Patient)',
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {'resourceType': 'Patient', 'id': '1'},
          {'resourceType': 'Patient', 'id': '3'},
          {'resourceType': 'Patient', 'id': '6'},
          {'resourceType': 'Patient', 'id': '7'},
        ]);
    expect(
        (await walkPath(
          context: bundle,
          pathExpression: 'Bundle.entry.resource.ofType(Practitioner)',
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {'resourceType': 'Practitioner', 'id': '2'},
          {'resourceType': 'Practitioner', 'id': '4'},
          {'resourceType': 'Practitioner', 'id': '5'},
        ]);
  });

  test('index', () async {
    expect(
        (await walkPath(
          context: patient3,
          pathExpression: 'Patient.name[3]',
        ))
            .map((e) => e.toJson())
            .toList(),
        [
          {
            'family': 'Smith',
            'given': [
              'John',
              'Jacob',
              'Jingleheimer',
            ],
          }
        ]);
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name[12]',
      ),
      <FhirBase>[],
    );
  });

  test('skip', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.id.skip(1)',
      ),
      <FhirBase>[],
    );
    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.skip(3)',
        ),
        [
          'Grey'.toFhirString,
          'Kristin'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);
  });

  test('take', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.id.take(1)',
      ),
      <FhirBase>[],
    );
    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.take(3)',
        ),
        [
          'Jason'.toFhirString,
          'Grey'.toFhirString,
          'Jason'.toFhirString,
        ]);
    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.take(13)',
        ),
        [
          'Jason'.toFhirString,
          'Grey'.toFhirString,
          'Jason'.toFhirString,
          'Grey'.toFhirString,
          'Kristin'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);
  });

  test('intersect', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.intersect(%nameList)',
        environment: {
          'nameList': ['Jason'.toFhirString],
        },
      ),
      ['Jason'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.intersect(%nameList)',
        environment: {
          'nameList': ['Jason'.toFhirString, 'Kristin'.toFhirString],
        },
      ),
      ['Jason'.toFhirString, 'Kristin'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'Patient.name.given.intersect(%nameList)',
        environment: {
          'nameList': ['Jason'.toFhirString, 'Fnuts'.toFhirString],
        },
      ),
      ['Jason'.toFhirString],
    );
  });

  test('exclude', () async {
    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.exclude(%nameList)',
          environment: {
            'nameList': ['Jason'.toFhirString],
          },
        ),
        [
          'Grey'.toFhirString,
          'Grey'.toFhirString,
          'Kristin'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);

    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.exclude(%nameList)',
          environment: {
            'nameList': ['Jason'.toFhirString, 'Kristin'.toFhirString],
          },
        ),
        [
          'Grey'.toFhirString,
          'Grey'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);
    expect(
        await walkPath(
          context: patient3,
          pathExpression: 'Patient.name.given.exclude(%nameList)',
          environment: {
            'nameList': ['Jason'.toFhirString, 'Fnuts'.toFhirString],
          },
        ),
        [
          'Grey'.toFhirString,
          'Grey'.toFhirString,
          'Kristin'.toFhirString,
          'John'.toFhirString,
          'Jacob'.toFhirString,
          'Jingleheimer'.toFhirString,
        ]);
  });

  test('union', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '%a.union(%b)',
        environment: {
          'a': [
            1.toFhirInteger,
            1.toFhirInteger,
            2.toFhirInteger,
            3.toFhirInteger,
          ],
          'b': [2.toFhirInteger, 3.toFhirInteger],
        },
      ),
      [1.toFhirInteger, 2.toFhirInteger, 3.toFhirInteger],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '%a.union()',
        environment: {
          'a': [
            1.toFhirInteger,
            1.toFhirInteger,
            2.toFhirInteger,
            3.toFhirInteger,
          ],
        },
      ),
      [1.toFhirInteger, 2.toFhirInteger, 3.toFhirInteger],
    );
  });

  test('combine', () async {
    expect(
      FhirBase.listEquals(
        await walkPath(
          context: patient3,
          pathExpression: '%a.combine(%b)',
          environment: {
            'a': [
              1.toFhirInteger,
              1.toFhirInteger,
              2.toFhirInteger,
              3.toFhirInteger,
            ],
            'b': [2.toFhirInteger, 3.toFhirInteger],
          },
        ),
        [
          1.toFhirInteger,
          1.toFhirInteger,
          2.toFhirInteger,
          3.toFhirInteger,
          2.toFhirInteger,
          3.toFhirInteger,
        ],
      ),
      true,
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '%a.combine()',
        environment: {
          'a': [
            1.toFhirInteger,
            1.toFhirInteger,
            2.toFhirInteger,
            3.toFhirInteger,
          ],
        },
      ),
      [1.toFhirInteger, 1.toFhirInteger, 2.toFhirInteger, 3.toFhirInteger],
    );
  });

  test('indexOf', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.indexOf('bc') // 1",
      ),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.indexOf('x') // -1",
      ),
      [-1.toFhirInteger],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.indexOf('abcdefg') // 0",
      ),
      [0.toFhirInteger],
    );
  });

  test('Substring Function', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.substring(3) // 'defg'",
      ),
      ['defg'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.substring(1, 2) // 'bc'",
      ),
      ['bc'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.substring(6, 2) // 'g'",
      ),
      ['g'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.substring(7, 1) // { }",
      ),
      <FhirBase>[],
    );
  });

  test('startsWith', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.startsWith('abc') // true",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.startsWith('xyz') // false",
      ),
      [false.toFhirBoolean],
    );
  });

  test('endsWith', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.endsWith('efg') // true",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.endsWith('abc') // false",
      ),
      [false.toFhirBoolean],
    );
  });

  test('contains', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abc'.contains('b') // true",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abc'.contains('bc') // true",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abc'.contains('d') // false",
      ),
      [false.toFhirBoolean],
    );
  });

  test('replace', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.replace('cde', '123') // 'ab123fg'",
      ),
      ['ab123fg'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abcdefg'.replace('cde', '') // 'abfg'",
      ),
      ['abfg'.toFhirString],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'abc'.replace('', 'x') // 'xaxbxcx'",
      ),
      ['xaxbxcx'.toFhirString],
    );
  });

  test('matches', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'hello'.matches('hello')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "35.matches('[2-9]|[12]d|3[0-6]')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "38.matches('[2-9]|[12]d|3[0-6]')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'35'.matches('[2-9]|[12]d|3[0-6]')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'38'.matches('[2-9]|[12]d|3[0-6]')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'google'.matches('g(oog)+le')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'googoogoogoogle'.matches('g(oog)+le')",
      ),
      [true.toFhirBoolean],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: "'goooooogle'.matches('g(oog)+le')",
      ),
      [false.toFhirBoolean],
    );
  });

  test('replacesMatches', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression:
            r"'11/30/1972'.replace('\\b(?<month>\\d{1,2})/(?<day>\\d{1,2})/(?<year>\\d{2,4})\\b','${day}-${month}-${year}')",
      ),
      ['11/30/1972'.toFhirString],
    );
  });

  test('log', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '16.log(2) // 4.0',
      ),
      [4.0.toFhirDecimal],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '100.0.log(10.0) // 2.0',
      ),
      [2.0.toFhirDecimal],
    );
  });

  test('power', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '2.power(3) // 8',
      ),
      [8.0.toFhirDecimal],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '2.5.power(2) // 6.25',
      ),
      [6.25.toFhirDecimal],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '(-1).power(0.5) // empty ({ })',
      ),
      <FhirBase>[],
    );
  });

  test('round', () async {
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '1.round() // 1',
      ),
      [1.0.toFhirDecimal],
    );
    expect(
      await walkPath(
        context: patient3,
        pathExpression: '3.14159.round(3) // 3.142',
      ),
      [3.142.toFhirDecimal],
    );
  });

  test('complex-extension', () async {
    expect(
      await walkPath(
        context: questionnaireResponse3,
        pathExpression:
            '%context.repeat(item).answer.value.extension(%`ext-ordinalValue`)'
            '.value.sum()',
      ),
      [13.toFhirDecimal],
    );
  });

  test('iif-basic', () async {
    expect(
      await walkPath(context: null, pathExpression: 'iif(true, 1, 0)'),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(context: null, pathExpression: 'iif(false, 1, 0)'),
      [0.toFhirInteger],
    );
    expect(
      await walkPath(context: null, pathExpression: 'iif({}, 1, 0)'),
      [0.toFhirInteger],
    );
    expect(
      await walkPath(context: null, pathExpression: 'iif(5, 1, 0)'),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(context: null, pathExpression: 'iif(true, 1)'),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(context: null, pathExpression: 'iif(false, 1)'),
      <FhirBase>[],
    );
    await expectLater(
      walkPath(context: null, pathExpression: 'iif(false)'),
      throwsA(const TypeMatcher<FHIRLexerException>()),
    );
  });

  test('iif-short-circuit', () async {
    // non-existent identifier should never be evaluated
    expect(
      await walkPath(
        context: patient3,
        pathExpression: 'iif(true, 1, %patient3.blurb)',
      ),
      [1.toFhirInteger],
    );
    // non-existent identifier should throw
    await expectLater(
      walkPath(
        context: patient3,
        pathExpression: 'iif(false, 1, %patient3.blurb)',
      ),
      throwsA(const TypeMatcher<PathEngineException>()),
    );
  });

  test('iif-with-variables', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: 'iif(%smokesCode.exists(), 1, 0)',
        environment: {'smokesCode': <FhirBase>[]},
      ),
      [0.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: "iif(%smokesCode = 'Y', 1, 0)",
        environment: {
          'smokesCode': ['Y'.toFhirString],
        },
      ),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: "iif(%smokesCode = 'Y', 1, 0)",
        environment: {
          'smokesCode': ['N'],
        },
      ),
      [0.toFhirInteger],
    );
  });

  test('iif-nested-fxns', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: 'iif(%smokesCode.exists(), {}.empty(), {}.exists())',
        environment: {'smokesCode': <FhirBase>[]},
      ),
      [false.toFhirBoolean],
    );
  });

  test('iif-nested-iif-empty-variable', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression:
            "iif(%smokesCode.exists(), iif(%smokesCode = 'Y', 1, 0), {})",
        environment: {'smokesCode': <FhirBase>[]},
      ),
      <FhirBase>[],
    );
  });

  test('iif-nested-iif-empty-set', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: "iif({}.exists(), iif({} = 'Y', 1, 0), {})",
      ),
      <FhirBase>[],
    );
  });

  test('iif-nested-iif-filled-variable', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression:
            "iif(%smokesCode.exists(), iif(%smokesCode = 'Y', 1, 0), {})",
        environment: {
          'smokesCode': ['Y'.toFhirString],
        },
      ),
      [1.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression:
            "iif(%smokesCode.exists(), iif(%smokesCode = 'Y', 1, 0), {})",
        environment: {
          'smokesCode': ['N'.toFhirString],
        },
      ),
      [0.toFhirInteger],
    );
  });

  test('iif-act-on-score', () async {
    expect(
      await walkPath(
        context: null,
        pathExpression: r"(2 + 2).select(iif($this > 2, $this, '<= 2'))",
      ),
      [4.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: r"(1 + 1).select(iif($this > 2, $this, '<= 2'))",
      ),
      ['<= 2'.toFhirString],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: r'(1 + 1).select(iif($this > 2, $this, iif($this < 2, '
            r"$this.toString() + ' is below 2', $this.toString() + ' is above "
            "2')))",
      ),
      ['2 is above 2'.toFhirString],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: r'(2 + 2).select(iif($this > 2, $this, iif($this < 2, '
            r"$this.toString() + ' is below 2', $this.toString() + ' is above "
            "2')))",
      ),
      [4.toFhirInteger],
    );
    expect(
      await walkPath(
        context: null,
        pathExpression: r'(1 + 0).select(iif($this > 2, $this, iif($this < 2, '
            r"$this.toString() + ' is below 2', $this.toString() + ' is above "
            "2')))",
      ),
      ['1 is below 2'.toFhirString],
    );
  });

  group('extensions', () {
    test('extensionOnPolymorphic', () async {
      expect(
        await walkPath(
          context: questionnaireResponse3,
          pathExpression: '%context.repeat(item).answer.value.extension.'
              'where(url=%`ext-ordinalValue`).value',
        ),
        [4.toFhirDecimal, 5.toFhirDecimal, 4.toFhirDecimal],
      );
    });
    test('extensionOnPrimitive', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.contact.name.family.extension'
              '(%`ext-humanname-own-prefix`).value',
        ),
        ['VV'.toFhirString],
      );
    });
  });

  test('trace', () async {
    // Test trace with one parameter (logs name and focus)
    final engine = await FHIRPathEngine.create(WorkerContext());
    final result = await engine.evaluateFromPath(
      patient1,
      "Patient.name.family.trace('familyName')",
    );
    expect(result, isNotEmpty);
    expect(engine.fpContext.fpLog.toString(), contains('familyName'));

    // Test trace with two parameters (logs name and value)
    engine.fpContext.fpLog.clear();
    final result2 = await engine.evaluateFromPath(
      patient1,
      "Patient.name.family.trace('familyName', 'Doe')",
    );
    expect(result2, isNotEmpty);
    expect(engine.fpContext.fpLog.toString(), contains('familyName'));
    expect(engine.fpContext.fpLog.toString(), contains('Doe'));
  });
}
