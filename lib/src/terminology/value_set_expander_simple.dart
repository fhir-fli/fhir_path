// ignore_for_file: avoid_positional_boolean_parameters

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// Expands a ValueSet from its compose, using the CodeSystems the worker
/// context can reach. The expansion is built as JSON and handed back as a
/// node of the binding's model.
class ValueSetExpanderSimple implements ValueSetExpander {
  /// An expander.
  ValueSetExpanderSimple(this.context, [this.logger]);

  /// The worker context.
  final FhirWorkerContext context;

  /// Optional logger.
  final LoggingService? logger;

  final List<String> _allErrors = [];

  /// Every error the last expansion met.
  List<String> getAllErrors() => List.unmodifiable(_allErrors);

  @override
  Future<ValueSetExpansionOutcome> expand(
    FhirNode source,
    Map<String, dynamic>? parameters,
  ) async {
    _allErrors.clear();
    if (source.getChildByName('expansion') != null) {
      return ValueSetExpansionOutcome(source);
    }
    final compose = source.getChildByName('compose');
    if (compose == null ||
        (compose.getChildrenByName('include').isEmpty &&
            compose.getChildrenByName('exclude').isEmpty)) {
      const message = 'ValueSet has no compose element, or the compose element '
          'has no include or exclude element';
      _allErrors.add(message);
      return ValueSetExpansionOutcome.withError(
        null,
        message,
        TerminologyServiceErrorClass.valueSetUnsupported,
      );
    }
    try {
      final result = Map<String, dynamic>.from(context.binding.toJson(source));
      final excludeNested = getParameterBool(parameters, 'excludeNested', true);
      final includeDefinition =
          getParameterBool(parameters, 'includeDefinition', false);
      var expansion = <String, dynamic>{
        'identifier': DateTime.now().millisecondsSinceEpoch.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      for (final include in compose.getChildrenByName('include')) {
        expansion = await processIncludeExclude(
          include,
          expansion,
          true,
          excludeNested,
          includeDefinition,
        );
      }
      for (final exclude in compose.getChildrenByName('exclude')) {
        expansion = await processIncludeExclude(
          exclude,
          expansion,
          false,
          excludeNested,
          includeDefinition,
        );
      }
      result['expansion'] = expansion;
      return ValueSetExpansionOutcome(context.binding.fromJson(result));
    } on Exception catch (e) {
      _allErrors.add('Error expanding ValueSet: $e');
      return ValueSetExpansionOutcome.withError(
        null,
        'Error expanding ValueSet: $e',
        TerminologyServiceErrorClass.unknown,
      );
    }
  }

  /// Applies one include or exclude [component] to [expansion] (JSON).
  Future<Map<String, dynamic>> processIncludeExclude(
    FhirNode component,
    Map<String, dynamic> expansion,
    bool include,
    bool excludeNested,
    bool includeDefinition,
  ) async {
    final system = component.getChildByName('system')?.primitiveValue;
    if (system == null) {
      _allErrors.add(
        'ValueSet compose ${include ? 'include' : 'exclude'} has no system',
      );
      return expansion;
    }
    var newExpansion = expansion;
    for (final concept in component.getChildrenByName('concept')) {
      final code = concept.getChildByName('code')?.primitiveValue ?? '';
      newExpansion = include
          ? addCodeToExpansion(
              system,
              code,
              concept.getChildByName('display')?.primitiveValue,
              newExpansion,
              includeDefinition,
              designation: concept.getChildrenByName('designation'),
            )
          : removeCodeFromExpansion(system, code, newExpansion);
    }
    if (component.getChildrenByName('filter').isNotEmpty) {
      newExpansion = await processFilters(
        component,
        system,
        expansion,
        include,
        excludeNested,
        includeDefinition,
      );
    }
    for (final vsRef in component.getChildrenByName('valueSet')) {
      newExpansion = await processValueSetReference(
        vsRef.primitiveValue!,
        expansion,
        include,
        excludeNested,
        includeDefinition,
      );
    }
    return newExpansion;
  }

  /// Applies [component]'s filters against the CodeSystem for [system].
  Future<Map<String, dynamic>> processFilters(
    FhirNode component,
    String system,
    Map<String, dynamic> expansion,
    bool include,
    bool excludeNested,
    bool includeDefinition,
  ) async {
    final cs = await context.fetchCodeSystem(system);
    if (cs == null) {
      _allErrors.add('Code system $system not found');
      return expansion;
    }
    final content = cs.getChildByName('content')?.primitiveValue;
    if (content != 'complete') {
      _allErrors.add('Cannot process filters for code system '
          '$system with content mode $content');
      return expansion;
    }
    var newExpansion = expansion;
    for (final filter in component.getChildrenByName('filter')) {
      final property = filter.getChildByName('property')?.primitiveValue ?? '';
      final op = filter.getChildByName('op')?.primitiveValue ?? '';
      final value = filter.getChildByName('value')?.primitiveValue ?? '';
      final matching = findConceptsMatchingFilter(
        cs.getChildrenByName('concept'),
        property,
        op,
        value,
      );
      for (final concept in matching) {
        final code = concept.getChildByName('code')?.primitiveValue ?? '';
        if (include) {
          newExpansion = addCodeToExpansion(
            system,
            code,
            concept.getChildByName('display')?.primitiveValue,
            newExpansion,
            includeDefinition,
          );
          if (!excludeNested) {
            newExpansion = addChildConcepts(
              concept,
              system,
              newExpansion,
              includeDefinition,
            );
          }
        } else {
          newExpansion = removeCodeFromExpansion(system, code, newExpansion);
          if (!excludeNested) {
            newExpansion = removeChildConcepts(concept, system, newExpansion);
          }
        }
      }
    }
    return newExpansion;
  }

  /// The concepts in [concepts] (and nested) that match the filter.
  List<FhirNode> findConceptsMatchingFilter(
    List<FhirNode> concepts,
    String property,
    String op,
    String value,
  ) {
    final matches = <FhirNode>[];
    for (final concept in concepts) {
      if (matchesFilter(concept, property, op, value)) matches.add(concept);
      matches.addAll(
        findConceptsMatchingFilter(
          concept.getChildrenByName('concept'),
          property,
          op,
          value,
        ),
      );
    }
    return matches;
  }

  /// Whether [concept] matches the filter.
  bool matchesFilter(
    FhirNode concept,
    String property,
    String op,
    String value,
  ) {
    if (property == 'code') {
      final code = concept.getChildByName('code')?.primitiveValue ?? '';
      switch (op) {
        case '=':
          return code == value;
        case 'is-a':
          return code == value || isChildOf(concept, value);
        case 'descendent-of':
          return isChildOf(concept, value);
        case 'is-not-a':
          return code != value && !isChildOf(concept, value);
        case 'regex':
          return RegExp(value).hasMatch(code);
        case 'in':
          return value.split(',').contains(code);
        case 'not-in':
          return !value.split(',').contains(code);
        case 'generalizes':
          return false; // Not implemented for 'code'
        case 'exists':
          return true; // Code always exists
        default:
          return false;
      }
    }
    if (property == 'display') {
      final displayNode = concept.getChildByName('display');
      final display = displayNode?.primitiveValue ?? '';
      switch (op) {
        case '=':
          return display == value;
        case 'regex':
          return RegExp(value).hasMatch(display);
        case 'in':
          return value.split(',').contains(display);
        case 'not-in':
          return !value.split(',').contains(display);
        case 'exists':
          return displayNode != null;
        default:
          return false;
      }
    }
    for (final prop in concept.getChildrenByName('property')) {
      if (prop.getChildByName('code')?.primitiveValue == property) {
        return matchesPropertyValue(prop.getChildByName('value'), op, value);
      }
    }
    return op == 'exists' && value.toLowerCase() == 'false';
  }

  /// Whether a concept property's value matches the filter. A Coding is
  /// read by its code, a CodeableConcept by its first coding's code, any
  /// primitive by its value.
  bool matchesPropertyValue(FhirNode? propValue, String op, String value) {
    if (propValue == null) {
      return op == 'exists' && value.toLowerCase() == 'false';
    }
    final String strValue;
    if (propValue.isPrimitive) {
      strValue = propValue.primitiveValue ?? '';
    } else if (propValue.hasType(['Coding'])) {
      strValue = propValue.getChildByName('code')?.primitiveValue ?? '';
    } else if (propValue.hasType(['CodeableConcept'])) {
      final first = propValue.getChildrenByName('coding').firstOrNull;
      strValue = first?.getChildByName('code')?.primitiveValue ?? '';
    } else {
      strValue = context.binding.toJson(propValue).toString();
    }
    switch (op) {
      case '=':
        return strValue == value;
      case 'regex':
        return RegExp(value).hasMatch(strValue);
      case 'in':
        return value.split(',').contains(strValue);
      case 'not-in':
        return !value.split(',').contains(strValue);
      case 'exists':
        return value.toLowerCase() == 'true';
      default:
        return false;
    }
  }

  /// Whether [parentCode] is a nested concept of [concept].
  bool isChildOf(FhirNode concept, String parentCode) {
    for (final child in concept.getChildrenByName('concept')) {
      if (child.getChildByName('code')?.primitiveValue == parentCode) {
        return true;
      }
      if (isChildOf(child, parentCode)) return true;
    }
    return false;
  }

  /// Applies a referenced value set, by its expansion or its compose.
  Future<Map<String, dynamic>> processValueSetReference(
    String vsRef,
    Map<String, dynamic> expansion,
    bool include,
    bool excludeNested,
    bool includeDefinition,
  ) async {
    final vs = await context.fetchResource(uri: vsRef, type: 'ValueSet');
    if (vs == null) {
      _allErrors.add('Referenced ValueSet $vsRef not found');
      return expansion;
    }
    var newExpansion = expansion;
    final contains =
        vs.getChildByName('expansion')?.getChildrenByName('contains');
    if (contains != null && contains.isNotEmpty) {
      for (final item in contains) {
        if (include) {
          newExpansion = _withContains(newExpansion, [
            ..._containsOf(newExpansion),
            context.binding.toJson(item),
          ]);
        } else {
          newExpansion = removeCodeFromExpansion(
            item.getChildByName('system')?.primitiveValue ?? '',
            item.getChildByName('code')?.primitiveValue ?? '',
            newExpansion,
          );
        }
      }
      return newExpansion;
    }
    // Not expanded: apply its compose directly here rather than recursing
    // through expand(), to avoid circular references.
    final compose = vs.getChildByName('compose');
    if (compose != null) {
      for (final inc in compose.getChildrenByName('include')) {
        newExpansion = await processIncludeExclude(
          inc,
          newExpansion,
          include,
          excludeNested,
          includeDefinition,
        );
      }
      for (final exc in compose.getChildrenByName('exclude')) {
        newExpansion = await processIncludeExclude(
          exc,
          newExpansion,
          !include,
          excludeNested,
          includeDefinition,
        );
      }
    }
    return newExpansion;
  }

  static List<Map<String, dynamic>> _containsOf(
    Map<String, dynamic> expansion,
  ) =>
      [
        for (final c in (expansion['contains'] as List<dynamic>?) ?? const [])
          c as Map<String, dynamic>,
      ];

  static Map<String, dynamic> _withContains(
    Map<String, dynamic> expansion,
    List<Map<String, dynamic>> contains,
  ) =>
      {...expansion, 'contains': contains};

  /// Adds [system]#[code] to the expansion, once.
  Map<String, dynamic> addCodeToExpansion(
    String system,
    String code,
    String? display,
    Map<String, dynamic> expansion,
    bool includeDefinition, {
    List<FhirNode> designation = const [],
  }) {
    if (isCodeInExpansion(system, code, expansion)) return expansion;
    final item = <String, dynamic>{
      'system': system,
      'code': code,
      if (display != null) 'display': display,
      if (includeDefinition && designation.isNotEmpty)
        'designation': [for (final d in designation) context.binding.toJson(d)],
    };
    return _withContains(expansion, [..._containsOf(expansion), item]);
  }

  /// Whether [system]#[code] is already in the expansion.
  bool isCodeInExpansion(
    String system,
    String code,
    Map<String, dynamic> expansion,
  ) =>
      _findInContains(_containsOf(expansion), system, code) != null;

  Map<String, dynamic>? _findInContains(
    List<Map<String, dynamic>> items,
    String system,
    String code,
  ) {
    for (final item in items) {
      if (item['system'] == system && item['code'] == code) return item;
      final nested = item['contains'];
      if (nested is List) {
        final found = _findInContains(
          [for (final n in nested) n as Map<String, dynamic>],
          system,
          code,
        );
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Removes [system]#[code] from the expansion, at any depth.
  Map<String, dynamic> removeCodeFromExpansion(
    String system,
    String code,
    Map<String, dynamic> expansion,
  ) {
    if (expansion['contains'] == null) return expansion;
    return _withContains(
      expansion,
      _removeFromContains(_containsOf(expansion), system, code),
    );
  }

  List<Map<String, dynamic>> _removeFromContains(
    List<Map<String, dynamic>> items,
    String system,
    String code,
  ) =>
      [
        for (final item in items)
          if (!(item['system'] == system && item['code'] == code))
            if (item['contains'] is List)
              {
                ...item,
                'contains': _removeFromContains(
                  [
                    for (final n in item['contains'] as List)
                      n as Map<String, dynamic>,
                  ],
                  system,
                  code,
                ),
              }
            else
              item,
      ];

  /// Adds [parent]'s nested concepts, recursively.
  Map<String, dynamic> addChildConcepts(
    FhirNode parent,
    String system,
    Map<String, dynamic> expansion,
    bool includeDefinition,
  ) {
    var newExpansion = expansion;
    for (final child in parent.getChildrenByName('concept')) {
      newExpansion = addCodeToExpansion(
        system,
        child.getChildByName('code')?.primitiveValue ?? '',
        child.getChildByName('display')?.primitiveValue,
        newExpansion,
        includeDefinition,
      );
      newExpansion =
          addChildConcepts(child, system, newExpansion, includeDefinition);
    }
    return newExpansion;
  }

  /// Removes [parent]'s nested concepts, recursively.
  Map<String, dynamic> removeChildConcepts(
    FhirNode parent,
    String system,
    Map<String, dynamic> expansion,
  ) {
    var newExpansion = expansion;
    for (final child in parent.getChildrenByName('concept')) {
      newExpansion = removeCodeFromExpansion(
        system,
        child.getChildByName('code')?.primitiveValue ?? '',
        newExpansion,
      );
      newExpansion = removeChildConcepts(child, system, newExpansion);
    }
    return newExpansion;
  }

  /// Whether [system] needs a server: not held, or not complete.
  Future<bool> isServerSide(String? system) async {
    if (system == null) return false;
    final cs = await context.fetchCodeSystem(system);
    if (cs == null) return true;
    return cs.getChildByName('content')?.primitiveValue != 'complete';
  }

  /// The boolean parameter [name] of a Parameters resource (JSON).
  bool getParameterBool(
    Map<String, dynamic>? parameters,
    String name,
    bool defaultValue,
  ) {
    if (parameters == null) return defaultValue;
    for (final param
        in (parameters['parameter'] as List<dynamic>?) ?? const []) {
      final p = param as Map<String, dynamic>;
      if (p['name'] == name && p['valueBoolean'] is bool) {
        return p['valueBoolean'] as bool;
      }
    }
    return defaultValue;
  }
}
