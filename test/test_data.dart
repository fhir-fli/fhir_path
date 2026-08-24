import 'dart:convert';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';

final worker = WorkerContext();
List<dynamic> toJsonList(List<FhirNode> list) => list
    .map((e) => e is PrimitiveType ? e.valueString : (e as FhirBase).toJson())
    .toList();

/// The parse-tree constant is a [FhirNode] after the engine's node swap;
/// tests asserting its R4 JSON narrow it here (the R4 binding surface).
extension FhirNodeR4JsonX on FhirNode {
  Map<String, dynamic> toR4Json() => (this as FhirBase).toJson();
}

final patient1 = Patient.fromJson(<String, dynamic>{
  'resourceType': 'Patient',
  'id': 'example',
  'text': {
    'status': 'generated',
    'div':
        '<div xmlns="http://www.w3.org/1999/xhtml">\n\t\t\t<table>\n\t\t\t\t<tbody>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Name</td>\n\t\t\t\t\t\t<td>Peter James \n              <b>Chalmers</b> (&quot;Jim&quot;)\n            </td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Address</td>\n\t\t\t\t\t\t<td>534 Erewhon, Pleasantville, Vic, 3999</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Contacts</td>\n\t\t\t\t\t\t<td>Home: unknown. Work: (03) 5555 6473</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>Id</td>\n\t\t\t\t\t\t<td>MRN: 12345 (Acme Healthcare)</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</tbody>\n\t\t\t</table>\n\t\t</div>',
  },
  'identifier': [
    {
      'use': 'usual',
      'type': {
        'coding': [
          {
            'system': 'http://terminology.hl7.org/CodeSystem/v2-0203',
            'code': 'MR',
          }
        ],
      },
      'system': 'urn:oid:1.2.36.146.595.217.0.1',
      'value': '12345',
      'period': {'start': '2001-05-06'},
      'assigner': {'display': 'Acme Healthcare'},
    }
  ],
  'active': true,
  'name': [
    {
      'use': 'official',
      'family': 'Chalmers',
      'given': ['Peter', 'James'],
    },
    {
      'use': 'usual',
      'given': ['Jim'],
    },
    {
      'use': 'maiden',
      'family': 'Windsor',
      'given': ['Peter', 'James'],
      'period': {'end': '2002'},
    }
  ],
  'telecom': [
    {'use': 'home'},
    {'system': 'phone', 'value': '(03) 5555 6473', 'use': 'work', 'rank': 1},
    {'system': 'phone', 'value': '(03) 3410 5613', 'use': 'mobile', 'rank': 2},
    {
      'system': 'phone',
      'value': '(03) 5555 8834',
      'use': 'old',
      'period': {'end': '2014'},
    }
  ],
  'gender': 'male',
  'birthDate': '1974-12-25',
  '_birthDate': {
    'extension': [
      {
        'url': 'http://hl7.org/fhir/StructureDefinition/patient-birthTime',
        'valueDateTime': '1974-12-25T14:35:45-05:00',
      }
    ],
  },
  'deceasedBoolean': false,
  'address': [
    {
      'use': 'home',
      'type': 'both',
      'text': '534 Erewhon St PeasantVille, Rainbow, Vic  3999',
      'line': ['534 Erewhon St'],
      'city': 'PleasantVille',
      'district': 'Rainbow',
      'state': 'Vic',
      'postalCode': '3999',
      'period': {'start': '1974-12-25'},
    }
  ],
  'contact': [
    {
      'relationship': [
        {
          'coding': [
            {
              'system': 'http://terminology.hl7.org/CodeSystem/v2-0131',
              'code': 'N',
            }
          ],
        }
      ],
      'name': {
        'family': 'du Marché',
        '_family': {
          'extension': [
            {
              'url':
                  'http://hl7.org/fhir/StructureDefinition/humanname-own-prefix',
              'valueString': 'VV',
            }
          ],
        },
        'given': ['Bénédicte'],
      },
      'telecom': [
        {'system': 'phone', 'value': '+33 (237) 998327'},
      ],
      'address': {
        'use': 'home',
        'type': 'both',
        'line': ['534 Erewhon St'],
        'city': 'PleasantVille',
        'district': 'Rainbow',
        'state': 'Vic',
        'postalCode': '3999',
        'period': {'start': '1974-12-25'},
      },
      'gender': 'female',
      'period': {'start': '2012'},
    }
  ],
  'managingOrganization': {'reference': 'Organization/1'},
});

final patient2 = Patient(
  address: [
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Mg'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'mL'.toFhirString),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Kg'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Km'.toFhirString),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Feet'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'inches'.toFhirString),
          ),
        ],
      ),
    ),
  ],
  deceasedX: FhirBoolean(false),
  name: [
    HumanName(
      family: 'Faulkenberry'.toFhirString,
      given: [
        'Jason'.toFhirString,
        'Grey'.toFhirString,
      ],
    ),
    HumanName(
      family: 'Niel'.toFhirString,
      given: [
        'Kristin'.toFhirString,
      ],
    ),
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

final patient3 = Patient(
  id: 'example'.toFhirString,
  active: true.toFhirBoolean,
  telecom: [
    ContactPoint(
      system: ContactPointSystem.email,
      use: ContactPointUse.mobile,
      rank: FhirPositiveInt(3),
    ),
  ],
  address: [
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Mg'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'mL'.toFhirString),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            extension_: [
              FhirExtension(
                url: 'www.mayjuun.com'.toFhirString,
                extension_: [
                  FhirExtension(
                    url: 'www.mayjuun.com'.toFhirString,
                    extension_: [
                      FhirExtension(
                        url: 'www.mayjuun.com'.toFhirString,
                        valueX: Count(unit: 'Kg'.toFhirString),
                      ),
                      FhirExtension(
                        url: 'www.mayjuun.com'.toFhirString,
                        valueX: Count(unit: 'Km'.toFhirString),
                      ),
                    ],
                    valueX: Count(unit: 'Kg'.toFhirString),
                  ),
                  FhirExtension(
                    url: 'www.mayjuun.com'.toFhirString,
                    valueX: Count(unit: 'Km'.toFhirString),
                  ),
                ],
                valueX: Count(unit: 'Kg'.toFhirString),
              ),
              FhirExtension(
                url: 'www.mayjuun.com'.toFhirString,
                valueX: Count(unit: 'Km'.toFhirString),
              ),
            ],
            valueX: Count(unit: 'Kg'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Km'.toFhirString),
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'Feet'.toFhirString),
          ),
          FhirExtension(
            url: 'www.mayjuun.com'.toFhirString,
            valueX: Count(unit: 'inches'.toFhirString),
          ),
        ],
      ),
    ),
  ],
  deceasedX: FhirBoolean(false),
  name: [
    HumanName(
      use: NameUse.official,
      family: 'Faulkenberry'.toFhirString,
      given: [
        'Jason'.toFhirString,
        'Grey'.toFhirString,
      ],
    ),
    HumanName(
      use: NameUse.official,
      family: 'Faulkenberry'.toFhirString,
      given: [
        'Jason'.toFhirString,
        'Grey'.toFhirString,
      ],
    ),
    HumanName(
      family: 'Niel'.toFhirString,
      given: [
        'Kristin'.toFhirString,
      ],
    ),
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

final patient5 = Resource.fromJson(
  jsonDecode(r'''
{
	"resourceType": "Patient",
	"id": "example",
	"text": {
		"status": "generated",
		"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><table><tbody><tr><td>Name</td><td>Peter James \r\n              <b>Chalmers</b> (\"Jim\")\r\n            </td></tr><tr><td>Address</td><td>534 Erewhon, Pleasantville, Vic, 3999</td></tr><tr><td>Contacts</td><td>Home: unknown. Work: (03) 5555 6473</td></tr><tr><td>Id</td><td>MRN: 12345 (Acme Healthcare)</td></tr></tbody></table></div>"
	},
	"identifier": [
		{
			"use": "usual",
			"type": {
				"coding": [
					{
						"system": "http://terminology.hl7.org/CodeSystem/v2-0203",
						"code": "MR"
					}
				]
			},
			"system": "urn:oid:1.2.36.146.595.217.0.1",
			"value": "12345",
			"period": {
				"start": "2001-05-06"
			},
			"assigner": {
				"display": "Acme Healthcare"
			}
		}
	],
	"active": true,
	"name": [
		{
			"use": "official",
			"family": "Chalmers",
			"given": [
				"Peter",
				"James"
			]
		},
		{
			"use": "usual",
			"given": [
				"Jim"
			]
		},
		{
			"use": "maiden",
			"family": "Windsor",
			"given": [
				"Peter",
				"James"
			],
			"period": {
				"end": "2002"
			}
		}
	],
	"telecom": [
		{
			"use": "home"
		},
		{
			"system": "phone",
			"value": "(03) 5555 6473",
			"use": "work",
			"rank": 1
		},
		{
			"system": "phone",
			"value": "(03) 3410 5613",
			"use": "mobile",
			"rank": 2
		},
		{
			"system": "phone",
			"value": "(03) 5555 8834",
			"use": "old",
			"period": {
				"end": "2014"
			}
		}
	],
	"gender": "male",
	"_birthDate": {
		"extension": [
			{
				"url": "http://hl7.org/fhir/StructureDefinition/patient-birthTime",
				"valueDateTime": "1974-12-25T14:35:45-05:00"
			}
		]
	},
	"birthDate": "1974-12-25",
	"deceasedBoolean": false,
	"address": [
		{
			"use": "home",
			"type": "both",
			"text": "534 Erewhon St PeasantVille, Rainbow, Vic  3999",
			"line": [
				"534 Erewhon St"
			],
			"city": "PleasantVille",
			"district": "Rainbow",
			"state": "Vic",
			"postalCode": "3999",
			"period": {
				"start": "1974-12-25"
			}
		}
	],
	"contact": [
		{
			"relationship": [
				{
					"coding": [
						{
							"system": "http://terminology.hl7.org/CodeSystem/v2-0131",
							"code": "N"
						}
					]
				}
			],
			"name": {
				"_family": {
					"extension": [
						{
							"url": "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix",
							"valueString": "VV"
						}
					]
				},
				"family": "du Marché",
				"given": [
					"Bénédicte"
				]
			},
			"telecom": [
				{
					"system": "phone",
					"value": "+33 (237) 998327"
				}
			],
			"address": {
				"use": "home",
				"type": "both",
				"line": [
					"534 Erewhon St"
				],
				"city": "PleasantVille",
				"district": "Rainbow",
				"state": "Vic",
				"postalCode": "3999",
				"period": {
					"start": "1974-12-25"
				}
			},
			"gender": "female",
			"period": {
				"start": "2012"
			}
		}
	],
	"managingOrganization": {
		"reference": "Organization/1"
	}
}''') as Map<String, dynamic>,
);

final questionnaireResponse1 = QuestionnaireResponse.fromJson({
  'resourceType': 'QuestionnaireResponse',
  'status': 'completed',
  'item': [
    {'linkId': '/psc/preschool'},
    {
      'linkId': '/psc/preschool/irritability/nervous',
      'answer': [
        {
          'valueCoding': {
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/ordinalValue',
                'valueDecimal': 1,
              }
            ],
            'code': 'Somewhat',
            'display': 'Somewhat',
          },
        }
      ],
    },
    {
      'linkId': '/psc/preschool/irritability/sad',
      'answer': [
        {
          'valueCoding': {
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/ordinalValue',
                'valueDecimal': 1,
              }
            ],
            'code': 'Somewhat',
            'display': 'Somewhat',
          },
        }
      ],
    },
    {'linkId': '/psc/preschool/irritability/upset'},
    {'linkId': '/psc/preschool/irritability/change'},
    {'linkId': '/psc/preschool/irritability/trouble_playing'},
    {'linkId': '/psc/preschool/irritability/break_things'},
    {'linkId': '/psc/preschool/inflexibility/irritability/fights'},
    {'linkId': '/psc/preschool/inflexibility/irritability/attention'},
    {'linkId': '/psc/preschool/inflexibility/irritability/calming_down'},
    {'linkId': '/psc/preschool/irritability/one_activity'},
    {'linkId': '/psc/preschool/subscore_irritability'},
    {'linkId': '/psc/preschool/inflexibility/aggressive'},
    {'linkId': '/psc/preschool/routines/inflexibility/fidgety'},
    {'linkId': '/psc/preschool/routines/inflexibility/angry'},
  ],
});

final questionnaireResponse2 = QuestionnaireResponse.fromJson({
  'resourceType': 'QuestionnaireResponse',
  'meta': {
    'profile': [
      'http://hl7.org/fhir/4.0/StructureDefinition/QuestionnaireResponse',
      'http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse',
      'http://fhir.org/guides/argonaut/questionnaire/StructureDefinition/argo-questionnaireresponse',
    ],
  },
  'language': 'en',
  'text': {
    'status': 'generated',
    'div':
        '<div xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"><h3>Enter your birthdate (MM/DD/YYYY)</h3><p>8/22/2013</p><h3>Have you had mammogram before?(enableWhenExpression = only when gender is female and age > 40)</h3><p>- Don’t know</p><p>&nbsp;</p></div>',
  },
  'contained': [
    {
      'resourceType': 'Patient',
      'id': '14603',
      'name': [
        {
          'family': 'Lee',
          'given': ['Emma'],
        }
      ],
      'gender': 'female',
    }
  ],
  'questionnaire': 'http://build.fhir.org/ig/HL7/sdc/examples.html',
  '_questionnaire': {
    'extension': [
      {
        'url': 'http://hl7.org/fhir/StructureDefinition/display',
        'valueString': 'SDC Demo Survey',
      }
    ],
  },
  'status': 'in-progress',
  'subject': {'reference': '#14603', 'type': 'Patient'},
  'authored': '2021-08-28T23:57:20.643979+02:00',
  'item': [
    {
      'linkId': '4.2.b',
      'item': [
        {
          'linkId': '4.2.b.1',
          'text': 'What gender are you?',
          'answer': [
            {
              'valueCoding': {'code': 'female', 'display': 'Female'},
            }
          ],
        },
        {
          'linkId': '4.2.b.5',
          'text': 'Enter your birthdate (MM/DD/YYYY)',
          'answer': [
            {'valueDate': '2013-08-22'},
          ],
        },
        {
          'linkId': '4.2.b.6',
          'text': 'Have you had mammogram before?(enableWhenExpression = '
              'only when gender is female and age > 40)',
          'answer': [
            {
              'valueCoding': {
                'system':
                    'http://terminology.hl7.org/CodeSystem/data-absent-reason',
                'code': 'asked-unknown',
                'display': 'Don’t know',
                'userSelected': true,
              },
            }
          ],
        }
      ],
    }
  ],
});

final questionnaireResponse3 = QuestionnaireResponse.fromJson({
  'resourceType': 'QuestionnaireResponse',
  'id': 'gcs',
  'questionnaire': 'Questionnaire/gcs',
  'status': 'completed',
  'subject': {
    'reference': 'Patient/example',
    'display': 'Peter James Chalmers',
  },
  'authored': '2014-12-11T04:44:16Z',
  'source': {'reference': 'Practitioner/f007'},
  'item': [
    {
      'linkId': '1.1',
      'answer': [
        {
          'valueCoding': {
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/ordinalValue',
                'valueDecimal': 4,
              }
            ],
            'system': 'http://loinc.org',
            'code': 'LA6560-2',
            'display': 'Confused',
          },
        }
      ],
    },
    {
      'linkId': '1.2',
      'answer': [
        {
          'valueCoding': {
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/ordinalValue',
                'valueDecimal': 5,
              }
            ],
            'system': 'http://loinc.org',
            'code': 'LA6566-9',
            'display': 'Localizing pain',
          },
        }
      ],
    },
    {
      'linkId': '1.3',
      'answer': [
        {
          'valueCoding': {
            'extension': [
              {
                'url': 'http://hl7.org/fhir/StructureDefinition/ordinalValue',
                'valueDecimal': 4,
              }
            ],
            'system': 'http://loinc.org',
            'code': 'LA6556-0',
            'display': 'Eyes open spontaneously',
          },
        }
      ],
    }
  ],
});

final questionnaireResponse4 = QuestionnaireResponse.fromJson({
  'resourceType': 'QuestionnaireResponse',
  'id': 'bb',
  'text': {
    'status': 'generated',
    'div':
        '<div xmlns="http://www.w3.org/1999/xhtml">\n      <pre>\n        Cathy Jones, female. Birth weight 3.25 kg at 44.3 cm. \n        Injection of Vitamin K given on 1972-11-30 (first dose) and 1972-12-11 (second dose)\n        Note: Was able to speak Chinese at birth.\n      </pre>\n    </div>',
  },
  'status': 'completed',
  'subject': {'reference': 'http://hl7.org/fhir/Patient/1', 'type': 'Patient'},
  'authored': '2013-02-19T14:15:00+10:00',
  'author': {
    'reference': 'http://hl7.org/fhir/Practitioner/example',
    'type': 'Practitioner',
  },
  'item': [
    {
      'linkId': 'birthDetails',
      'text': 'Birth details - To be completed by health professional',
      'item': [
        {
          'linkId': 'group',
          'item': [
            {
              'linkId': 'nameOfChild',
              'text': 'Name of child',
              'answer': [
                {'valueString': 'Cathy Jones'},
              ],
            },
            {
              'linkId': 'sex',
              'text': 'Sex',
              'answer': [
                {
                  'valueCoding': {'code': 'F'},
                }
              ],
            }
          ],
        },
        {
          'linkId': 'neonatalInformation',
          'text': 'Neonatal Information',
          'item': [
            {
              'linkId': 'birthWeight',
              'text': 'Birth weight (kg)',
              'answer': [
                {'valueDecimal': 3.25},
              ],
            },
            {
              'linkId': 'birthLength',
              'text': 'Birth length (cm)',
              'answer': [
                {'valueDecimal': 44.3},
              ],
            },
            {
              'linkId': 'vitaminKgiven',
              'text': 'Vitamin K given',
              'answer': [
                {
                  'valueCoding': {'code': 'INJECTION'},
                  'item': [
                    {
                      'linkId': 'vitaminKgivenDoses',
                      'item': [
                        {
                          'linkId': 'vitaminKDose1',
                          'text': '1st dose',
                          'answer': [
                            {'valueDate': '1972-11-30'},
                          ],
                        },
                        {
                          'linkId': 'vitaminKDose2',
                          'text': '2nd dose',
                          'answer': [
                            {'valueDate': '1972-12-11'},
                          ],
                        }
                      ],
                    }
                  ],
                }
              ],
            },
            {
              'linkId': 'hepBgiven',
              'text': 'Hep B given y / n',
              'answer': [
                {
                  'valueBoolean': true,
                  'item': [
                    {
                      'linkId': 'hepBgivenDate',
                      'text': 'Date given',
                      'answer': [
                        {'valueDate': '1972-12-04'},
                      ],
                    }
                  ],
                }
              ],
            },
            {
              'linkId': 'abnormalitiesAtBirth',
              'text': 'Abnormalities noted at birth',
              'answer': [
                {'valueString': 'Already able to speak Chinese'},
              ],
            }
          ],
        }
      ],
    }
  ],
});

final bundle = Bundle(
  type: BundleType.transaction,
  entry: [
    BundleEntry(resource: Patient(id: '1'.toFhirString)),
    BundleEntry(resource: Practitioner(id: '2'.toFhirString)),
    BundleEntry(resource: Patient(id: '3'.toFhirString)),
    BundleEntry(resource: Practitioner(id: '4'.toFhirString)),
    BundleEntry(resource: Practitioner(id: '5'.toFhirString)),
    BundleEntry(resource: Patient(id: '6'.toFhirString)),
    BundleEntry(resource: Patient(id: '7'.toFhirString)),
  ],
);

final questionnaire1 = Questionnaire.fromJsonString(r'''
{
	"resourceType": "Questionnaire",
	"id": "3141",
	"text": {
		"status": "generated",
		"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><pre>\r\n            1.Comorbidity?\r\n              1.1 Cardial Comorbidity\r\n                1.1.1 Angina?\r\n                1.1.2 MI?\r\n              1.2 Vascular Comorbidity?\r\n              ...\r\n            Histopathology\r\n              Abdominal\r\n                pT category?\r\n              ...\r\n          </pre></div>"
	},
	"url": "http://hl7.org/fhir/Questionnaire/3141",
	"title": "Cancer Quality Forum Questionnaire 2012",
	"status": "draft",
	"subjectType": [
		"Patient"
	],
	"date": "2012-01",
	"item": [
		{
			"linkId": "1",
			"code": [
				{
					"system": "http://example.org/system/code/sections",
					"code": "COMORBIDITY"
				}
			],
			"type": "group",
			"item": [
				{
					"linkId": "1.1",
					"code": [
						{
							"system": "http://example.org/system/code/questions",
							"code": "COMORB"
						}
					],
					"prefix": "1",
					"type": "choice",
					"answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow",
					"item": [
						{
							"linkId": "1.1.1",
							"code": [
								{
									"system": "http://example.org/system/code/sections",
									"code": "CARDIAL"
								}
							],
							"type": "group",
							"enableWhen": [
								{
									"question": "1.1",
									"operator": "=",
									"answerCoding": {
										"system": "http://terminology.hl7.org/CodeSystem/v2-0136",
										"code": "Y"
									}
								}
							],
							"item": [
								{
									"linkId": "1.1.1.1",
									"code": [
										{
											"system": "http://example.org/system/code/questions",
											"code": "COMORBCAR"
										}
									],
									"prefix": "1.1",
									"type": "choice",
									"answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow",
									"item": [
										{
											"linkId": "1.1.1.1.1",
											"code": [
												{
													"system": "http://example.org/system/code/questions",
													"code": "COMCAR00",
													"display": "Angina Pectoris"
												},
												{
													"system": "http://snomed.info/sct",
													"code": "194828000",
													"display": "Angina (disorder)"
												}
											],
											"prefix": "1.1.1",
											"type": "choice",
											"answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
										},
										{
											"linkId": "1.1.1.1.2",
											"code": [
												{
													"system": "http://snomed.info/sct",
													"code": "22298006",
													"display": "Myocardial infarction (disorder)"
												}
											],
											"prefix": "1.1.2",
											"type": "choice",
											"answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
										}
									]
								},
								{
									"linkId": "1.1.1.2",
									"code": [
										{
											"system": "http://example.org/system/code/questions",
											"code": "COMORBVAS"
										}
									],
									"prefix": "1.2",
									"type": "choice",
									"answerValueSet": "http://hl7.org/fhir/ValueSet/yesnodontknow"
								}
							]
						}
					]
				}
			]
		},
		{
			"linkId": "2",
			"code": [
				{
					"system": "http://example.org/system/code/sections",
					"code": "HISTOPATHOLOGY"
				}
			],
			"type": "group",
			"item": [
				{
					"linkId": "2.1",
					"code": [
						{
							"system": "http://example.org/system/code/sections",
							"code": "ABDOMINAL"
						}
					],
					"type": "group",
					"item": [
						{
							"linkId": "2.1.2",
							"code": [
								{
									"system": "http://example.org/system/code/questions",
									"code": "STADPT",
									"display": "pT category"
								}
							],
							"type": "choice"
						}
					]
				}
			]
		}
	]
}''');

final observation1 = Observation.fromJsonString(r'''
{
	"resourceType": "Observation",
	"id": "example",
	"text": {
		"status": "generated",
		"div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative with Details</b></p><p><b>id</b>: example</p><p><b>status</b>: final</p><p><b>category</b>: Vital Signs <span>(Details : {http://terminology.hl7.org/CodeSystem/observation-category code 'vital-signs' = 'Vital Signs', given as 'Vital Signs'})</span></p><p><b>code</b>: Body Weight <span>(Details : {LOINC code '29463-7' = 'Body weight', given as 'Body Weight'}; {LOINC code '3141-9' = 'Body weight Measured', given as 'Body weight Measured'}; {SNOMED CT code '27113001' = 'Body weight', given as 'Body weight'}; {http://acme.org/devices/clinical-codes code 'body-weight' = 'body-weight', given as 'Body Weight'})</span></p><p><b>subject</b>: <a>Patient/example</a></p><p><b>encounter</b>: <a>Encounter/example</a></p><p><b>effective</b>: 28/03/2016</p><p><b>value</b>: 185 lbs<span> (Details: UCUM code [lb_av] = 'lb_av')</span></p></div>"
	},
	"status": "final",
	"category": [
		{
			"coding": [
				{
					"system": "http://terminology.hl7.org/CodeSystem/observation-category",
					"code": "vital-signs",
					"display": "Vital Signs"
				}
			]
		}
	],
	"code": {
		"coding": [
			{
				"system": "http://loinc.org",
				"code": "29463-7",
				"display": "Body Weight"
			},
			{
				"system": "http://loinc.org",
				"code": "3141-9",
				"display": "Body weight Measured"
			},
			{
				"system": "http://snomed.info/sct",
				"code": "27113001",
				"display": "Body weight"
			},
			{
				"system": "http://acme.org/devices/clinical-codes",
				"code": "body-weight",
				"display": "Body Weight"
			}
		]
	},
	"subject": {
		"reference": "Patient/example"
	},
	"encounter": {
		"reference": "Encounter/example"
	},
	"effectiveDateTime": "2016-03-28",
	"valueQuantity": {
		"value": 185,
		"unit": "lbs",
		"system": "http://unitsofmeasure.org",
		"code": "[lb_av]"
	}
}''');
