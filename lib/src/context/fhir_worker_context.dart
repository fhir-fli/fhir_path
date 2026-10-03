// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:fhir_path/src/utils/path_string_extensions.dart';
import 'package:ucum/ucum.dart';

/// The engine's worker: type metadata (StructureDefinitions and the
/// binding's type table), canonical resources, and terminology, over any
/// model. A binding package subclasses it to supply its [FhirModelBinding]
/// and keep its `WorkerContext()` constructor.
class FhirWorkerContext implements IWorkerContext {
  FhirWorkerContext({
    required this.binding,
    this.txClient,
    ResourceCache? resourceCache,
  })  : resourceCache = resourceCache ?? CanonicalResourceCache(),
        txCache = TerminologyCache('lock', null, toJson: binding.toJson);

  /// What the model supplies.
  final FhirModelBinding binding;

  @override
  IFhirValueFactory get valueFactory => binding.valueFactory;

  final ResourceCache resourceCache;
  @override
  final UcumService ucumService = UcumService();
  final ValidatorFetcher locator = ValidatorFetcher();
  final TerminologyCache txCache;
  final Set<String> codeSystemsUsed = {};
  final ClientLogger txLog = ClientLogger();
  bool noTerminologyServer = true;
  bool tlogging = true;
  bool isTxCaching = false;
  String? cacheId;
  final Set<String> cached = {};
  final LoggingService? logger = LoggingService(debug: true);
  final FhirToolingClient? txClient;

  /// The expansion profile sent to a terminology server, as Parameters JSON.
  Map<String, dynamic>? expParameters;

  Map<String, TypeHierarchyEntry> get _table => binding.typeHierarchy;

  late final Map<String, TypeHierarchyEntry> _typeHierarchyByUrl = {
    for (final info in _table.values) info.url: info,
  };

  static String? _s(FhirNode? node, String name) =>
      node?.getChildByName(name)?.primitiveValue;

  Future<List<FhirNode>> getStructures() =>
      resourceCache.getStructureDefinitions();

  Future<List<FhirNode>> allStructures() => getStructures();

  Future<List<String>> getResourceNames() async {
    // Core resource type names come from the binding's hierarchy table
    // (kind `resource`, derivation `specialization`, the filter the Java
    // reference's TypeManager applies), so they are available with an
    // empty cache; loaded canonicals are unioned in on top.
    final names = <String>{
      for (final info in _table.values)
        if (info.kind == 'resource' && info.derivation == 'specialization')
          info.name,
      ...await resourceCache.getResourceNames(),
    };
    return names.toList();
  }

  @override
  String getVersion() => binding.fhirVersion;

  /// Whether [typeName] names a known FHIR type: the binding's own type
  /// lists and table first (so the check needs no definitions loaded), then
  /// a StructureDefinition in the cache.
  @override
  Future<bool> isKnownType(String typeName) async {
    if (binding.isModelType(typeName) || _table.containsKey(typeName)) {
      return true;
    }
    try {
      return (await fetchTypeDefinition(typeName)) != null;
    } on Exception catch (_) {
      return false;
    }
  }

  /// The canonical-URL ancestry chain of the type at [uri]: this type, then
  /// each successive `baseDefinition`, as `(url, typeName)` pairs. Mirrors
  /// the walk in the Java reference's `TypeDetails.hasType`, including its
  /// `uri` → `string` redirect.
  @override
  Future<List<(String, String)>> typeAncestry(String uri) async {
    final result = <(String, String)>[];
    var node = await _resolveTypeNodeByUrl(uri);
    while (node != null && node.url != null) {
      result.add((node.url!, node.type));
      if (node.baseUrl == null) break;
      node = node.type == 'uri'
          ? await _resolveTypeNodeByUrl(
              'http://hl7.org/fhir/StructureDefinition/string',
            )
          : await _resolveTypeNodeByUrl(node.baseUrl!);
    }
    return result;
  }

  @override
  Future<List<String>> specializedTypeNames() async {
    final names = <String>{
      for (final info in _table.values)
        if (info.derivation == 'specialization' && info.kind != 'logical')
          info.name,
    };
    for (final sd in await getStructures()) {
      if (_s(sd, 'derivation') == 'specialization' &&
          _s(sd, 'kind') != 'logical' &&
          _s(sd, 'name') != null) {
        names.add(_s(sd, 'name')!);
      }
    }
    return names.toList();
  }

  /// The FHIRPath type-membership test shared by the `is` operator and the
  /// `is()` function: does [node] belong to the type named [name] in
  /// namespace [ns] (`'System'` or `'FHIR'`)? A resource is never a System
  /// value; a System value is one the binding marks as outside the element
  /// tree or a bare primitive, matched by its capitalised type name (plus
  /// the Date→DateTime lattice rule); a FHIR test walks the subtype chain.
  /// Matches the Java reference `FHIRPathEngine.funcIs`.
  @override
  Future<bool> isValueOfType(FhirNode node, String ns, String name) async {
    if (ns == 'System') {
      if (node.isResource) return false;
      if (binding.isSystemValue(node)) {
        final t = node.fhirType.capitalize();
        if (name == t) return true;
        if (t == 'Date' && name == 'DateTime') return true;
        return false;
      }
      return false;
    } else if (ns == 'FHIR') {
      return isSubtypeOf(node.fhirType, name);
    }
    return false;
  }

  /// The `ofType()` filter for [node] against the type specifier [tn]
  /// (`System.X` or `FHIR.X`), matching the Java reference `funcOfType` /
  /// `funcAs`: System values match by exact type name; FHIR values match
  /// through the subtype hierarchy, but the `ofType` walk STOPS at
  /// primitive-type definitions (so `gender.ofType(string)` is false for a
  /// `code` even though `gender.is(string)` is true).
  @override
  Future<bool> matchesOfType(FhirNode node, String tn) async {
    if (tn.startsWith('System.')) {
      return binding.isSystemPrimitive(node) && node.hasType([tn.substring(7)]);
    } else if (tn.startsWith('FHIR.')) {
      final tnp = tn.substring(5);
      if (node.fhirType == tnp) return true;
      var step = await _resolveTypeNodeByName(node.fhirType);
      while (step != null) {
        if (step.type == tnp) return true;
        if (step.isPrimitiveKind) return false;
        if (step.baseUrl == null) return false;
        step = await _resolveTypeNodeByUrl(step.baseUrl!);
      }
      return false;
    }
    return false;
  }

  /// Whether [type] is [superType] or descends from it. The walk does NOT
  /// stop at primitive-type definitions (Java `funcIs` / `isAncestor`): this
  /// is what makes `Patient.gender.is(string)` true for a `code`.
  @override
  Future<bool> isSubtypeOf(String type, String superType) async {
    if (type == superType) return true;
    var node = await _resolveTypeNodeByName(type);
    while (node != null) {
      if (node.type == superType) return true;
      if (node.baseUrl == null) return false;
      node = await _resolveTypeNodeByUrl(node.baseUrl!);
    }
    return false;
  }

  /// One step of a type-hierarchy walk by type [name]: the binding's table
  /// for a core type (so the walks work with an empty cache), else a
  /// StructureDefinition in the cache (custom profiles, logical models).
  Future<_TypeHierarchyNode?> _resolveTypeNodeByName(String name) async {
    final info = _table[name];
    if (info != null) return _TypeHierarchyNode.fromEntry(info, _table);
    return _TypeHierarchyNode.fromSd(await fetchTypeDefinition(name));
  }

  Future<_TypeHierarchyNode?> _resolveTypeNodeByUrl(String url) async {
    final info = _typeHierarchyByUrl[url];
    if (info != null) return _TypeHierarchyNode.fromEntry(info, _table);
    return _TypeHierarchyNode.fromSd(
      await fetchResource(uri: url, type: 'StructureDefinition'),
    );
  }

  // ===========================================================================
  // STATIC TYPE ANALYSIS: every StructureDefinition / ElementDefinition walk
  // lives here; the engine drives it through neutral calls.
  // ===========================================================================

  Set<String>? _primitiveTypeCache;

  @override
  Future<Set<String>> primitiveTypeNames() async {
    if (_primitiveTypeCache != null) return _primitiveTypeCache!;
    final set = <String>{
      for (final info in _table.values)
        if (info.derivation == 'specialization' &&
            info.kind == 'primitive-type')
          info.name,
    };
    for (final sd in await getStructures()) {
      if (_s(sd, 'derivation') == 'specialization' &&
          _s(sd, 'kind') == 'primitive-type' &&
          _s(sd, 'name') != null) {
        set.add(_s(sd, 'name')!);
      }
    }
    return _primitiveTypeCache = set;
  }

  PathEngineException _makeException(
    ExpressionNode? holder,
    String constName,
    List<Object> args,
  ) {
    final fmt = formatMessage(constName, args);
    if (holder != null) {
      return PathEngineException(
        fmt,
        location: holder.start,
        expression: holder.toString(),
      );
    }
    return PathEngineException(fmt);
  }

  static List<FhirNode> _elements(FhirNode sd) =>
      sd.getChildByName('snapshot')?.getChildrenByName('element') ?? const [];

  static List<FhirNode> _types(FhirNode ed) => ed.getChildrenByName('type');

  static String _code(FhirNode type) => _s(type, 'code') ?? '';

  static bool _hasContentReference(FhirNode ed) =>
      _s(ed, 'contentReference')?.isNotEmpty ?? false;

  /// The typed port's `sdNs`: an absolute URL as it is, else [ns] and the
  /// type joined with '/'. Kept as it was (no `StructureDefinition` segment)
  /// so the move changes no answer; the official corpus decides whether the
  /// walks that reach it were ever right.
  static String _sdNs(String type, String ns) {
    final colon = type.indexOf(':');
    if (colon > 0) {
      final scheme = type.substring(0, colon);
      if (['http', 'https', 'urn', 'file'].contains(scheme)) return type;
    }
    return '$ns/$type';
  }

  static String _uncapitalize(String s) =>
      s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

  @override
  Future<void> getChildTypesByName(
    String? type,
    String name,
    TypeDetails result,
    ExpressionNode expr, {
    required bool allowPolymorphicNames,
  }) async {
    if (type == null || type.isEmpty) {
      throw _makeException(expr, 'FHIRPATH_NO_TYPE', ['getChildTypesByName']);
    }
    if (type == 'http://hl7.org/fhir/StructureDefinition/xhtml') return;
    if (type.startsWith(NS_SYSTEM_TYPE)) return;

    if (type == TypeDetails.FP_SimpleTypeInfo) {
      getSimpleTypeChildTypesByName(name, result);
    } else if (type == TypeDetails.FP_ClassInfo) {
      getClassInfoChildTypesByName(name, result);
    } else {
      final url =
          type.contains('#') ? type.substring(0, type.indexOf('#')) : type;
      var tail = '';
      final sd = await fetchResource(uri: url, type: 'StructureDefinition');
      if (sd == null) {
        throw _makeException(
          expr,
          'FHIRPATH_NO_TYPE',
          [url, 'getChildTypesByName'],
        );
      }
      final sdl = <FhirNode>[];
      ElementDefinitionMatch? m;
      if (type.contains('#')) {
        m = await getElementDefinition(
          sd,
          type.substring(type.indexOf('#') + 1),
          false,
          expr,
        );
      }
      if (m?.definition != null && hasDataType(m!.definition!)) {
        if (m.fixedType != null) {
          final dt = await fetchResource(
            uri: _sdNs(m.fixedType!, getOverrideVersionNs()),
            type: 'StructureDefinition',
          );
          if (dt == null) {
            throw _makeException(expr, 'FHIRPATH_NO_TYPE', [
              _sdNs(m.fixedType!, getOverrideVersionNs()),
              'getChildTypesByName',
            ]);
          }
          sdl.add(dt);
        } else {
          for (final t in _types(m.definition!)) {
            final dt = await fetchResource(
              uri: _sdNs(_code(t), getOverrideVersionNs()),
              type: 'StructureDefinition',
            );
            if (dt == null) {
              throw _makeException(expr, 'FHIRPATH_NO_TYPE', [
                _sdNs(_code(t), getOverrideVersionNs()),
                'getChildTypesByName',
              ]);
            }
            addTypeAndDescendents(sdl, dt, await allStructures());
          }
        }
      } else {
        addTypeAndDescendents(sdl, sd, await allStructures());
        if (type.contains('#')) {
          tail = type.substring(type.indexOf('#') + 1);
          tail = tail.substring(tail.indexOf('.'));
        }
      }

      for (final sdi in sdl) {
        final elements = _elements(sdi);
        final firstPath =
            elements.isEmpty ? '' : (_s(elements[0], 'path') ?? '');
        var path = '$firstPath$tail.';
        if (name == '**') {
          assert(
            result.collectionStatus == CollectionStatus.unordered,
            'CollectionStatus.unordered',
          );
          for (final ed in elements) {
            final edPath = _s(ed, 'path');
            if (edPath?.startsWith(path) ?? false) {
              for (final t in _types(ed)) {
                final code = _code(t);
                if (code.isEmpty) continue;
                final tn = code == 'Element' || code == 'BackboneElement'
                    ? '${_s(sdi, 'type')}#$edPath'
                    : code;
                if (code == 'Resource') {
                  for (final rn in await getResourceNames()) {
                    if (!(await result.hasTypeFromWorker(this, [rn]))) {
                      await getChildTypesByName(
                        result.addType(rn),
                        '**',
                        result,
                        expr,
                        allowPolymorphicNames: allowPolymorphicNames,
                      );
                    }
                  }
                } else if (!(await result.hasTypeFromWorker(this, [tn]))) {
                  await getChildTypesByName(
                    result.addType(tn),
                    '**',
                    result,
                    expr,
                    allowPolymorphicNames: allowPolymorphicNames,
                  );
                }
              }
            }
          }
        } else if (name == '*') {
          assert(
            result.collectionStatus == CollectionStatus.unordered,
            'CollectionStatus.unordered',
          );
          for (final ed in elements) {
            final edPath = _s(ed, 'path');
            if ((edPath?.startsWith(path) ?? false) &&
                !(edPath?.substring(path.length).contains('.') ?? false)) {
              for (final t in _types(ed)) {
                final code = _code(t);
                if (code.isEmpty) {
                  result.addType('System.string');
                } else if (code == 'Element' || code == 'BackboneElement') {
                  result.addType('${_s(sdi, 'type')}#$edPath');
                } else if (code == 'Resource') {
                  result.addTypes(await getResourceNames());
                } else {
                  result.addType(code);
                }
              }
            }
          }
        } else {
          path = '$firstPath$tail.$name';
          final ed = await getElementDefinition(
            sdi,
            path,
            allowPolymorphicNames,
            expr,
          );
          if (ed != null) {
            if (ed.fixedType?.isNotEmpty ?? false) {
              result.addType(ed.fixedType!);
            } else {
              final definition = ed.definition;
              for (final t in definition == null
                  ? const <FhirNode>[]
                  : _types(definition)) {
                final code = _code(t);
                if (code.isEmpty) {
                  final edId = _s(definition, 'id');
                  final basePath =
                      _s(definition?.getChildByName('base'), 'path');
                  if ((edId != null &&
                          ['Element.id', 'Extension.url'].contains(edId)) ||
                      (basePath != null &&
                          ['Resource.id', 'Element.id', 'Extension.url']
                              .contains(basePath))) {
                    result.addTypeWithProfile(TypeDetails.FP_NS, 'string');
                  }
                  break;
                }
                ProfiledType? pt;
                if (code == 'Element' || code == 'BackboneElement') {
                  pt = ProfiledType('${_s(sdi, 'url')}#$path');
                } else if (code == 'Resource') {
                  result.addTypes(await getResourceNames());
                } else {
                  pt = ProfiledType(code);
                }
                if (pt != null) {
                  final profiles = t.getChildrenByName('profile');
                  if (profiles.isNotEmpty) {
                    pt.addProfiles([
                      for (final u in profiles) u.primitiveValue ?? '',
                    ]);
                  }
                  final edBinding = definition?.getChildByName('binding');
                  if (edBinding != null) pt.addBinding(edBinding);
                  result.addProfiledType(pt);
                }
              }
            }
          }
        }
      }
    }
  }

  void getClassInfoChildTypesByName(String name, TypeDetails result) {
    if (name == 'namespace') result.addType(TypeDetails.FP_String);
    if (name == 'name') result.addType(TypeDetails.FP_String);
  }

  void getSimpleTypeChildTypesByName(String name, TypeDetails result) {
    if (name == 'namespace') result.addType(TypeDetails.FP_String);
    if (name == 'name') result.addType(TypeDetails.FP_String);
  }

  Future<ElementDefinitionMatch?> getElementDefinition(
    FhirNode sd,
    String path,
    bool allowTypedName,
    ExpressionNode expr,
  ) async {
    for (final ed in _elements(sd)) {
      final edPath = _s(ed, 'path');
      if (edPath == path) {
        if (_hasContentReference(ed)) {
          return getElementDefinitionById(sd, _s(ed, 'contentReference')!);
        }
        return ElementDefinitionMatch(ed, null);
      }
      if (edPath == null) continue;
      final choice = edPath.endsWith('[x]');
      final stem = choice ? edPath.substring(0, edPath.length - 3) : null;
      if (choice && path.startsWith(stem!) && path.length == stem.length) {
        return ElementDefinitionMatch(ed, null);
      }
      if (allowTypedName &&
          choice &&
          path.startsWith(stem!) &&
          path.length > stem.length) {
        final s = _uncapitalize(path.substring(stem.length));
        if ((await primitiveTypeNames()).contains(s)) {
          return ElementDefinitionMatch(ed, s);
        }
        return ElementDefinitionMatch(ed, path.substring(stem.length));
      }
      final types = _types(ed);
      if (edPath.contains('.') &&
          path.startsWith('$edPath.') &&
          types.isNotEmpty &&
          !isAbstractType(types)) {
        if (types.length > 1) throw StateError('Internal typing issue...');
        final nsd = await fetchResource(
          uri: _sdNs(_code(types[0]), getOverrideVersionNs()),
          type: 'StructureDefinition',
        );
        if (nsd == null) {
          throw _makeException(expr, 'FHIRPATH_NO_TYPE', [
            _code(types[0]),
            'getElementDefinition',
          ]);
        }
        return getElementDefinition(
          nsd,
          '${_s(nsd, 'id')}${path.substring(edPath.length)}',
          allowTypedName,
          expr,
        );
      }
      if (_hasContentReference(ed) && path.startsWith('$edPath.')) {
        final m = getElementDefinitionById(sd, _s(ed, 'contentReference')!);
        final mPath = _s(m?.definition, 'path');
        if (mPath != null) {
          return getElementDefinition(
            sd,
            '$mPath${path.substring(edPath.length)}',
            allowTypedName,
            expr,
          );
        }
      }
    }
    return null;
  }

  ElementDefinitionMatch? getElementDefinitionById(FhirNode sd, String ref) {
    for (final ed in _elements(sd)) {
      if (ref == '#${_s(ed, 'id')}') return ElementDefinitionMatch(ed, null);
    }
    return null;
  }

  void addTypeAndDescendents(
    List<FhirNode> sdl,
    FhirNode dt,
    List<FhirNode> types,
  ) {
    sdl.add(dt);
    for (final sd in types) {
      if (_s(sd, 'baseDefinition') != null &&
          _s(sd, 'baseDefinition') == _s(dt, 'url') &&
          _s(sd, 'derivation') == 'specialization') {
        addTypeAndDescendents(sdl, sd, types);
      }
    }
  }

  bool isAbstractType(List<FhirNode> list) =>
      list.length != 1 ||
      _code(list.first).existsInList(
        {'Element', 'BackboneElement', 'Resource', 'DomainResource'},
      );

  /// Whether [ed] declares a concrete data type (not Element or
  /// BackboneElement). Java `ed.hasType()` is "has a type"; the earlier
  /// port asked the element whether its own type name was in an empty list,
  /// which was always false, so this branch had never run.
  bool hasDataType(FhirNode ed) {
    final types = _types(ed);
    if (types.isEmpty) return false;
    final first = _code(types.first);
    return first != 'Element' && first != 'BackboneElement';
  }

  @override
  Future<String?> typeCanonicalUrl(String type) async =>
      _s(await fetchTypeDefinition(type), 'url');

  @override
  Future<FhirNode?> fetchTypeDefinitionByUrl(String url) =>
      fetchResource(uri: url, type: 'StructureDefinition');

  @override
  Future<TypeDetails?> resolveContextTypeDetails(
    FhirNode structureDefinition,
    String context,
    String abstractTypePrefix,
    ExpressionNode expr,
  ) async {
    final ed =
        await getElementDefinition(structureDefinition, context, true, expr);
    if (ed == null) return null;
    if (ed.fixedType != null) {
      return TypeDetails(CollectionStatus.singleton, [ed.fixedType!]);
    }
    final types =
        ed.definition == null ? const <FhirNode>[] : _types(ed.definition!);
    if (types.isEmpty || isAbstractType(types)) {
      return TypeDetails(
        CollectionStatus.singleton,
        ['$abstractTypePrefix#$context'],
      );
    }
    final details = TypeDetails(CollectionStatus.singleton);
    for (final t in types) {
      details.addType(_code(t));
    }
    return details;
  }

  Future<FhirNode?> fetchTypeDefinition(String typeName) async {
    return await resourceCache.getStructureDefinition(typeName) ??
        await resourceCache.getStructureDefinition(
          'http://hl7.org/fhir/StructureDefinition/$typeName',
        ) ??
        await resourceCache.getStructureDefinition(
          'http://terminology.hl7.org/StructureDefinition/$typeName',
        );
  }

  /// The canonical resource at [uri] (and [version]), of [type] when given.
  Future<FhirNode?> fetchResource({
    String? uri,
    String? version,
    String? type,
  }) async {
    if (uri == null) return null;
    final resource = await resourceCache.getCanonicalResource(uri, version);
    if (resource == null) return null;
    if (type != null && resource.fhirType != type) return null;
    return resource;
  }

  Future<FhirNode?> fetchCodeSystem(String? system) async {
    if (system == null) return null;
    if (system.contains('|')) {
      final s = system.substring(0, system.indexOf('|'));
      final v = system.substring(system.indexOf('|') + 1);
      return fetchCodeSystemWithVersion(s, v);
    }
    final codeSystem = await resourceCache.getCodeSystem(system);
    if (codeSystem != null) return codeSystem;
    locator.findResource(this, system);
    return resourceCache.getCodeSystem(system);
  }

  Future<FhirNode?> fetchCodeSystemWithVersion(
    String system,
    String version,
  ) async {
    var codeSystem = await resourceCache.getCodeSystem(system, version);
    if (codeSystem == null) {
      locator.findResource(this, system);
      codeSystem = await resourceCache.getCodeSystem(system, version);
    }
    return codeSystem;
  }

  @override
  String formatMessage(String theMessage, List<dynamic> theMessageArguments) {
    final argumentsInfo = theMessageArguments
        .asMap()
        .entries
        .map(
          (entry) =>
              '[${entry.key}]: (${entry.value.runtimeType}) ${entry.value}',
        )
        .join(', ');
    final formattedMessage = theMessageArguments.asMap().entries.fold(
          theMessage,
          (msg, entry) =>
              msg.replaceAll('{$entry.key}', entry.value.toString()),
        );
    return '$formattedMessage\nArguments: $argumentsInfo';
  }

  @override
  String formatMessagePlural(
    int pl,
    String theMessage,
    List<dynamic> theMessageArguments,
  ) {
    final message = formatMessage(theMessage, theMessageArguments);
    return '$message (plural count: $pl)';
  }

  String getOverrideVersionNs() => 'http://hl7.org/fhir';

  /// Keeps [sd], a StructureDefinition node with a name and a url.
  Future<void> loadStructureDefinition(FhirNode sd) async {
    if (_s(sd, 'name') != null && _s(sd, 'url') != null) {
      await resourceCache.saveCanonicalResource(sd);
    }
  }

  Future<void> loadStructureDefinitions(List<FhirNode> sds) async {
    for (final sd in sds) {
      await loadStructureDefinition(sd);
    }
  }

  /// Keeps [resource], a canonical resource node with an id or a version id.
  Future<void> loadResource(FhirNode resource) async {
    final uri =
        _s(resource, 'id') ?? _s(resource.getChildByName('meta'), 'versionId');
    if (uri != null) await resourceCache.saveCanonicalResource(resource);
  }

  bool laterVersion(String newVersion, String oldVersion) {
    final n = newVersion.trim();
    final o = oldVersion.trim();
    if (_isNumeric(n) && _isNumeric(o)) {
      return double.parse(n) > double.parse(o);
    }
    for (final (delim, pattern) in [
      ('.', r'\.'),
      ('-', r'\-'),
      ('_', r'\_'),
      (':', r'\:'),
      (' ', r'\s'),
    ]) {
      if (hasDelimiter(n, o, delim)) {
        return laterDelimitedVersion(n, o, pattern);
      }
    }
    return n.compareTo(o) > 0;
  }

  bool hasDelimiter(String s1, String s2, String delimiter) =>
      s1.contains(delimiter) &&
      s2.contains(delimiter) &&
      s1.split(delimiter).length == s2.split(delimiter).length;

  bool laterDelimitedVersion(
    String newVersion,
    String oldVersion,
    String delimiter,
  ) {
    final newParts = newVersion.split(RegExp(delimiter));
    final oldParts = oldVersion.split(RegExp(delimiter));
    for (var i = 0; i < newParts.length; i++) {
      if (newParts[i] != oldParts[i]) {
        return laterVersion(newParts[i], oldParts[i]);
      }
    }
    throw StateError('Delimited versions have an exact match for delimiter.');
  }

  bool _isNumeric(String s) => double.tryParse(s) != null;

  Future<ValidationResult> validateCode(
    ValidationOptions options,
    String? system,
    String? version,
    String code,
    String? display,
  ) =>
      validateCodeWithCoding(
        options,
        CodingValue(
          system: system,
          version: version,
          code: code,
          display: display,
        ),
        null,
      );

  /// Validates [coding] against [valueSet] (a ValueSet node, or null for the
  /// code system alone), on the client when the options allow it.
  Future<ValidationResult> validateCodeWithCoding(
    ValidationOptions options,
    CodingValue coding,
    FhirNode? valueSet,
  ) async {
    try {
      // Through the checker, so that the value set is actually consulted:
      // `Coding.memberOf(vs)` once answered a question about the code system
      // and never about `vs`.
      if (options.useClient) {
        final checker = ValueSetChecker(
          options: options,
          valueSet: valueSet,
          context: this,
        );
        return await checker.validateCode(ConceptValue(coding: [coding]));
      }
      if (options.useServer) {
        return validateCodeOnServer(options, coding, valueSet);
      }
      return ValidationResult.error(
        message: 'No validation methods (client/server) enabled.',
      );
    } on Exception catch (e) {
      return ValidationResult.error(message: 'Validation failed: $e');
    }
  }

  @override
  Future<FhirNode?> fetchValueSet(String? url) =>
      fetchResource(uri: url, type: 'ValueSet');

  /// Validates a code-carrying value (what the binding reads as a Coding)
  /// against [valueSet].
  @override
  Future<ValidationResult> validateCodeForCodingValue(
    ValidationOptions options,
    FhirNode node,
    FhirNode? valueSet,
  ) async {
    final coding = binding.asCoding(node);
    if (coding == null) {
      return ValidationResult.error(
        message: 'Unable to interpret a ${node.fhirType} as a Coding',
      );
    }
    return validateCodeWithCoding(options, coding, valueSet);
  }

  @override
  Future<ValidationResult> validateCodeForCodeableConceptValue(
    ValidationOptions options,
    FhirNode node,
    FhirNode valueSet,
  ) async {
    final concept = binding.asCodeableConcept(node);
    if (concept == null) {
      return ValidationResult.error(
        message: 'Unable to interpret a ${node.fhirType} as a CodeableConcept',
      );
    }
    return validateCodeWithCodeableConcept(options, concept, valueSet);
  }

  Future<ValidationResult> validateCodeWithCodeableConcept(
    ValidationOptions options,
    ConceptValue code,
    FhirNode vs,
  ) async {
    final cacheToken =
        txCache.generateValidationTokenForCodeableConcept(options, code, vs);
    final cachedResult = txCache.getValidation(cacheToken);
    if (cachedResult != null) return cachedResult;

    for (final coding in code.coding) {
      if (coding.system != null) codeSystemsUsed.add(coding.system!);
    }

    if (options.useClient) {
      try {
        final checker =
            ValueSetChecker(options: options, valueSet: vs, context: this);
        final result = await checker.validateCode(code);
        txCache.cacheValidation(cacheToken, result, TerminologyCache.transient);
        return result;
      } on NoTerminologyServiceException catch (_) {
        return ValidationResult.error(
          message: 'No Terminology Service available',
          errorClass: TerminologyServiceErrorClass.noservice,
        );
      } on Exception catch (_) {
        // Any other client-side failure falls through to the server path.
      }
    }

    if (!options.useServer) {
      return ValidationResult(
        severity: ValidationSeverity.warning,
        message: 'Unable to validate code without using server',
        errorClass: TerminologyServiceErrorClass.blockedByOptions,
      );
    }
    if (noTerminologyServer) {
      return ValidationResult.error(
        message: 'Error validating code: running without terminology services',
        errorClass: TerminologyServiceErrorClass.noservice,
      );
    }

    tlog(
      'Validating ${txCache.summaryForCodeableConcept(code)} for '
      '${txCache.summaryForValueSet(vs)}',
    );

    try {
      var params = <String, dynamic>{
        'resourceType': 'Parameters',
        'parameter': [
          {'name': 'codeableConcept', 'valueCodeableConcept': code.toJson()},
        ],
      };
      params = setTerminologyOptions(options, params);
      final result = validateOnServer(vs, params, options);
      txCache.cacheValidation(cacheToken, result, TerminologyCache.permanent);
      return result;
    } on Exception catch (e) {
      return ValidationResult.error(message: e.toString())
        ..txLink = txLog.getLastId();
    }
  }

  void tlog(String msg) {
    if (tlogging) logger?.logDebugMessage(LogCategory.tx, msg);
  }

  static List<dynamic> _params(Map<String, dynamic> pin) =>
      pin['parameter'] as List<dynamic>? ?? (pin['parameter'] = <dynamic>[]);

  /// Prepares [pin] (Parameters JSON) for a server validation of [vs]. The
  /// server call itself is not yet implemented.
  ValidationResult validateOnServer(
    FhirNode? vs,
    Map<String, dynamic> pin,
    ValidationOptions options,
  ) {
    var cache = false;
    if (vs != null) {
      final compose = vs.getChildByName('compose');
      for (final part in ['include', 'exclude']) {
        for (final inc
            in compose?.getChildrenByName(part) ?? const <FhirNode>[]) {
          final system = _s(inc, 'system');
          if (system != null) codeSystemsUsed.add(system);
        }
      }
      final url = _s(vs, 'url');
      final version = _s(vs, 'version');
      if (isTxCaching &&
          cacheId != null &&
          url != null &&
          cached.contains('$url|$version')) {
        _params(pin).add({
          'name': 'url',
          'valueUri': '$url${version != null ? '|$version' : ''}',
        });
      } else if (options.vsAsUrl) {
        _params(pin).add({'name': 'url', if (url != null) 'valueString': url});
      } else {
        _params(pin).add({'name': 'valueSet', 'resource': binding.toJson(vs)});
        if (url != null) cached.add('$url|$version');
      }
      cache = true;
      unawaited(addDependentResources(pin, vs));
    }
    if (cache) {
      _params(pin).add({'name': 'cache-id', 'valueString': cacheId});
    }
    for (final pp in _params(pin)) {
      if ((pp as Map<String, dynamic>)['name'] == 'profile') {
        throw ArgumentError(
          formatMessage('CAN_ONLY_SPECIFY_PROFILE_IN_THE_CONTEXT', []),
        );
      }
    }
    if (expParameters == null) {
      throw ArgumentError(formatMessage('NO_EXPANSIONPROFILE_PROVIDED', []));
    }
    _params(pin).add({'name': 'profile', 'resource': expParameters});
    txLog.clearLastId();
    if (txClient == null) {
      throw ArgumentError(
        formatMessage(
          // ignore: lines_longer_than_80_chars
          'ATTEMPT_TO_USE_TERMINOLOGY_SERVER_WHEN_NO_TERMINOLOGY_SERVER_IS_AVAILABLE',
          [],
        ),
      );
    }
    return ValidationResult.error(message: 'Not yet Implemented');
    // TODO(Dokotela): Implement actual server validation:
    // final pOut = vs == null
    //     ? await txClient!.validateCS(pin)
    //     : await txClient!.validateVS(pin);
    // return processValidationResult(pOut);
  }

  Future<(bool, Map<String, dynamic>)> addDependentResources(
    Map<String, dynamic> oldPin,
    FhirNode vs,
  ) async {
    var cache = false;
    var pin = oldPin;
    final compose = vs.getChildByName('compose');
    for (final part in ['include', 'exclude']) {
      for (final inc
          in compose?.getChildrenByName(part) ?? const <FhirNode>[]) {
        final r = await addDependentResourcesForComponent(pin, inc);
        cache = r.$1 || cache;
        pin = r.$2;
      }
    }
    return (cache, pin);
  }

  Future<(bool, Map<String, dynamic>)> addDependentResourcesForComponent(
    Map<String, dynamic> oldPin,
    FhirNode inc,
  ) async {
    var cache = false;
    final pin = oldPin;
    for (final canonical in inc.getChildrenByName('valueSet')) {
      final vs =
          await fetchResource(uri: canonical.primitiveValue, type: 'ValueSet');
      if (vs != null) {
        _params(pin)
            .add({'name': 'tx-resource', 'resource': binding.toJson(vs)});
        final url = _s(vs, 'url');
        if (isTxCaching && cacheId == null || !cached.contains(url)) {
          if (url != null) cached.add(url);
          cache = true;
        }
        await addDependentResources(pin, vs);
      }
    }
    final cs = await fetchResource(uri: _s(inc, 'system'), type: 'CodeSystem');
    if (cs != null) {
      _params(pin).add({'name': 'tx-resource', 'resource': binding.toJson(cs)});
      final url = _s(cs, 'url');
      if (isTxCaching && cacheId == null || !cached.contains(url)) {
        if (url != null) cached.add(url);
        cache = true;
      }
      // TODO(Dokotela): handle supplements
    }
    return (cache, pin);
  }

  /// The ValidationResult a server's \$validate-code Parameters answer means.
  ValidationResult processValidationResult(Map<String, dynamic> pOut) {
    var ok = false;
    var message = 'No Message returned';
    String? display;
    String? system;
    String? code;
    var errorClass = TerminologyServiceErrorClass.unknown;
    for (final p in (pOut['parameter'] as List<dynamic>?) ?? const []) {
      final parameter = p as Map<String, dynamic>;
      switch (parameter['name']) {
        case 'result':
          ok = parameter['valueBoolean'] == true;
        case 'message':
          message = parameter['valueString'] as String? ?? message;
        case 'display':
          display = parameter['valueString'] as String?;
        case 'system':
          system = parameter['valueString'] as String?;
        case 'code':
          code = parameter['valueString'] as String?;
        case 'cause':
          errorClass = switch (parameter['valueString']) {
            'not_found' => TerminologyServiceErrorClass.codeSystemUnsupported,
            'code_invalid' => TerminologyServiceErrorClass.valueSetUnsupported,
            _ => TerminologyServiceErrorClass.unknown,
          };
      }
    }
    if (!ok) {
      return ValidationResult(
        severity: ValidationSeverity.error,
        message: '$message (from ${txClient?.getAddress()})',
        errorClass: errorClass,
        txLink: txLog.getLastId(),
      );
    }
    if (code == null) {
      throw ArgumentError('Code is required when the server answers ok');
    }
    final definition = ConceptDefinition(code: code, display: display);
    if (message != 'No Message returned') {
      return ValidationResult(
        severity: ValidationSeverity.warning,
        message: '$message (from ${txClient?.getAddress()})',
        system: system,
        definition: definition,
        txLink: txLog.getLastId(),
      );
    }
    return ValidationResult(
      system: system,
      definition: definition,
      txLink: txLog.getLastId(),
    );
  }

  /// [pIn] with the parameters the validation options add.
  Map<String, dynamic> setTerminologyOptions(
    ValidationOptions options,
    Map<String, dynamic> pIn,
  ) =>
      {
        ...pIn,
        'parameter': [
          ...(pIn['parameter'] as List<dynamic>?) ?? const [],
          if (options.hasLanguages())
            {
              'name': 'displayLanguage',
              'valueString': options.getLanguages().toString(),
            },
          if (options.membershipOnly)
            {'name': 'valueset-membership-only', 'valueBoolean': true},
          if (options.displayWarningMode)
            {'name': 'lenient-display-validation', 'valueBoolean': true},
          if (options.versionFlexible)
            {'name': 'default-to-latest-version', 'valueBoolean': true},
        ],
      };

  ValidationResult validateCodeOnServer(
    ValidationOptions options,
    CodingValue coding,
    FhirNode? valueSet,
  ) =>
      // TODO(Dokotela): Implement actual server validation
      ValidationResult.error(
        message: 'Server validation failed: not yet implemented',
      );

  ValidationResult processValidationResponse(Map<String, dynamic> response) {
    if (response['result'] == true) {
      return ValidationResult.success(message: response['message'] as String?);
    }
    return ValidationResult.error(
      message: response['message'] as String? ??
          'Unknown error during server validation.',
    );
  }
}

/// One resolved step of a type-hierarchy walk, from the binding's table (a
/// core type, cache-independent) or from a StructureDefinition node in the
/// cache (custom profiles, logical models).
class _TypeHierarchyNode {
  _TypeHierarchyNode.fromEntry(
    TypeHierarchyEntry info,
    Map<String, TypeHierarchyEntry> table,
  )   : url = info.url,
        type = info.type,
        isPrimitiveKind = info.kind == 'primitive-type',
        baseUrl = info.base == null ? null : table[info.base]!.url;

  _TypeHierarchyNode._fromSd(FhirNode sd)
      : url = sd.getChildByName('url')?.primitiveValue,
        type = sd.getChildByName('type')?.primitiveValue ?? '',
        isPrimitiveKind =
            sd.getChildByName('kind')?.primitiveValue == 'primitive-type',
        baseUrl = sd.getChildByName('baseDefinition')?.primitiveValue;

  static _TypeHierarchyNode? fromSd(FhirNode? sd) =>
      sd == null ? null : _TypeHierarchyNode._fromSd(sd);

  final String? url;
  final String type;
  final bool isPrimitiveKind;
  final String? baseUrl;
}
