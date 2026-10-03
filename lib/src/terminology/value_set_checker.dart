import 'dart:collection';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// Checks codes against a ValueSet, and against the CodeSystems the worker
/// context can reach, reading every resource by element name.
class ValueSetChecker {
  /// A checker for [valueSet] (a ValueSet node, or null to check codes
  /// against their code systems only).
  ValueSetChecker({
    required this.context,
    required this.options,
    this.valueSet,
    this.localContext,
  }) {
    if (localContext != null) analyseValueSet();
  }

  /// The ValueSet node to check against.
  final FhirNode? valueSet;

  /// The worker context.
  final FhirWorkerContext context;

  /// The validation options.
  final ValidationOptions options;

  /// Resources the value set may refer to by contained reference.
  final ValidationContextCarrier? localContext;

  /// CodeSystems found contained in the local context.
  final List<FhirNode> localSystems = [];

  /// Checkers for value sets this one includes.
  final Map<String, ValueSetChecker> inner = HashMap();

  /// Finds the contained code systems the compose refers to.
  void analyseValueSet() {
    final compose = valueSet?.getChildByName('compose');
    if (compose == null) return;
    compose.getChildrenByName('include').forEach(analyseComponent);
    compose.getChildrenByName('exclude').forEach(analyseComponent);
  }

  /// Validates [code] (a CodeableConcept) against the code systems and,
  /// when there is one, the value set.
  Future<ValidationResult> validateCode(ConceptValue code) async {
    final errors = <String>[];
    final warnings = <String>[];

    // The display the code system gives this code, carried out with the
    // answer. The per-coding validation below already resolves it; dropping it
    // here is what made `Coding.memberOf` correct and left every other caller
    // of validateCodeWithCoding (the mapping engine among them) with codes
    // that had lost their display.
    String? display;

    if (!options.membershipOnly) {
      for (final coding in code.coding) {
        if (coding.system == null) {
          warnings.add('Coding has no system, cannot validate');
        }
        final cs = await resolveCodeSystem(coding.system);
        ValidationResult res;
        if (_content(cs) != 'complete') {
          res = await context.validateCodeWithCoding(
            options.withNoClient(),
            coding,
            null,
          );
        } else {
          if (cs == null) {
            return ValidationResult.error(message: 'Code system not found');
          }
          res = validateCodeAgainstCodeSystem(coding, cs);
        }
        if (!res.isOk) {
          errors.add(res.message ?? 'Unknown error');
        } else {
          display ??= res.display;
          if (res.message != null) warnings.add(res.message!);
        }
      }
    }

    if (valueSet != null) {
      final result = await _validateCodeInValueSet(code, warnings);
      if (result.errors.isNotEmpty) errors.insertAll(0, result.errors);
      if (result.warnings.isNotEmpty) warnings.insertAll(0, result.warnings);
    }

    if (errors.isNotEmpty) {
      return ValidationResult.error(message: errors.join(', '));
    } else if (warnings.isNotEmpty) {
      return ValidationResult(
        severity: ValidationSeverity.warning,
        message: warnings.join(', '),
      )..display = display;
    } else {
      return ValidationResult(severity: ValidationSeverity.information)
        ..display = display;
    }
  }

  static String? _content(FhirNode? cs) =>
      cs?.getChildByName('content')?.primitiveValue;

  /// The CodeSystem for [system]: a contained one first, then the context's.
  Future<FhirNode?> resolveCodeSystem(String? system) async {
    if (system == null) return null;
    for (final cs in localSystems) {
      if (cs.getChildByName('url')?.primitiveValue == system) return cs;
    }
    return context.fetchCodeSystem(system);
  }

  /// Notes a contained CodeSystem that an include's system extension names.
  void analyseComponent(FhirNode component) {
    final system = component.getChildByName('system');
    if (system == null) return;
    for (final ext in system.getChildrenByName('extension')) {
      if (ext.getChildByName('url')?.primitiveValue !=
          'http://hl7.org/fhir/StructureDefinition/valueSet-system') {
        continue;
      }
      final ref = ext.getChildByName('value')?.primitiveValue;
      if (ref == null) continue;
      if (!ref.startsWith('#')) {
        throw UnsupportedError(
          'External references are not supported yet: $ref',
        );
      }
      final id = ref.substring(1);
      for (final resource in localContext?.resources ?? const <FhirNode>[]) {
        for (final contained in resource.getChildrenByName('contained')) {
          if (contained.fhirType == 'CodeSystem' &&
              contained.getChildByName('id')?.primitiveValue == id) {
            localSystems.add(contained);
          }
        }
      }
    }
  }

  /// Validates [coding] against the complete CodeSystem [cs].
  ValidationResult validateCodeAgainstCodeSystem(
    CodingValue coding,
    FhirNode cs,
  ) {
    if (_content(cs) != 'complete') {
      return ValidationResult(
        severity: ValidationSeverity.warning,
        message: 'Code system is incomplete: '
            '${cs.getChildByName('url')?.primitiveValue}',
      );
    }
    final concept = findCodeInConceptList(
      cs.getChildrenByName('concept'),
      coding.code ?? '',
    );
    if (concept == null) {
      return ValidationResult.error(
        message: 'Code not found in code system: ${coding.code}',
      );
    }
    final definition = ConceptDefinition.fromNode(concept);
    return ValidationResult.success(
      system: coding.system,
      definition: definition,
    )..display = coding.display ?? definition.display;
  }

  /// The concept with [code] in [concepts] or any nested concept, or null.
  FhirNode? findCodeInConceptList(List<FhirNode> concepts, String code) {
    for (final concept in concepts) {
      if (concept.getChildByName('code')?.primitiveValue == code) {
        return concept;
      }
      final sub =
          findCodeInConceptList(concept.getChildrenByName('concept'), code);
      if (sub != null) return sub;
    }
    return null;
  }

  Future<CodeInValueSetResult> _validateCodeInValueSet(
    ConceptValue code,
    List<String> warnings,
  ) async {
    final errors = <String>[];
    for (final coding in code.coding) {
      final matched =
          await codeInValueSet(coding.system, coding.code, warnings);
      if (matched == null) {
        errors.add('Unable to validate ${coding.code} in value set');
      } else if (!matched) {
        errors.add('Code ${coding.code} not in value set');
      }
    }
    return CodeInValueSetResult(errors: errors, warnings: warnings);
  }

  /// Whether [system]#[code] is in the value set: true, false, or null when
  /// the value set cannot say (a code system it needs is not available).
  Future<bool?> codeInValueSet(
    String? system,
    String? code,
    List<String>? warnings,
  ) async {
    final vs = valueSet;
    if (vs == null) return false;
    final expansion = vs.getChildByName('expansion');
    if (expansion != null) {
      return _inContains(expansion.getChildrenByName('contains'), system, code);
    }
    final compose = vs.getChildByName('compose');
    if (compose != null) {
      // An exclude removes a code the includes brought in: ValueSet.compose
      // .exclude, "Exclude one or more codes from the value set based on
      // code system filters and/or other value sets" (quoted from
      // hl7.org/fhir/R4B/valueset-definitions.html, fetched 2026-10-03). The
      // typed port returned true on the first include match before reading
      // any exclude, so an excluded code was a member.
      bool? included = false;
      for (final include in compose.getChildrenByName('include')) {
        final match = await _inComponent(include, system, code);
        if (match ?? false) {
          included = true;
          break;
        }
        if (match == null) included = null;
      }
      if (included == false) return false;
      for (final exclude in compose.getChildrenByName('exclude')) {
        final match = await _inComponent(exclude, system, code);
        if (match ?? false) return false;
      }
      return included;
    }
    return false;
  }

  Future<bool?> _inComponent(
    FhirNode component,
    String? system,
    String? code,
  ) async {
    if (system == null) return false;
    if (code == null) return null;
    final componentSystem = component.getChildByName('system')?.primitiveValue;
    if (componentSystem != system) return false;
    final concepts = component.getChildrenByName('concept');
    if (concepts.isEmpty && componentSystem != null) {
      final codeSystem = await resolveCodeSystem(componentSystem);
      return findCodeInConceptList(
            codeSystem?.getChildrenByName('concept') ?? const [],
            code,
          ) !=
          null;
    }
    for (final concept in concepts) {
      if (concept.getChildByName('code')?.primitiveValue == code) return true;
    }
    return null;
  }

  bool _inContains(List<FhirNode> items, String? system, String? code) {
    for (final item in items) {
      if (item.getChildByName('system')?.primitiveValue == system &&
          item.getChildByName('code')?.primitiveValue == code) {
        return true;
      }
      if (_inContains(item.getChildrenByName('contains'), system, code)) {
        return true;
      }
    }
    return false;
  }
}
