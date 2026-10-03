// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:fhir_path/src/utils/io_support_stub.dart'
    if (dart.library.io) 'package:fhir_path/src/utils/io_support_io.dart';

/// A two-level cache of terminology answers: validations keyed by the
/// request they answered, and expansions keyed by value set.
class TerminologyCache {
  /// A cache. [toJson] is the model's serialiser, used to key a value set
  /// by its content; [folder] (optional) persists validations to disk.
  TerminologyCache(this.lock, this.folder, {required this.toJson}) {
    if (folder != null) _load();
  }

  final Map<ValueSetCacheToken, ValueSetExpansionOutcome> _expansionCache = {};

  /// Transient: not written to [folder].
  static const bool transient = false;

  /// Permanent: written to [folder].
  static const bool permanent = true;

  /// The cache name for a code with no system.
  static const String nameForNoSystem = 'all-systems';

  /// The entry marker in a cache file.
  static const String entryMarker =
      '----------------------------------------------------'
      '---------------------------------';

  /// The break marker in a cache file.
  static const String break_ = '####';

  /// The named caches, one per code system.
  final Map<String, NamedCache> caches = {};

  /// The lock for the cache.
  final Object lock;

  /// The folder for the cache.
  final String? folder;

  /// The model's node to JSON.
  final Map<String, dynamic> Function(FhirNode) toJson;

  /// Whether caching is disabled.
  static bool noCaching = false;

  /// Clears the cache.
  void clear() => caches.clear();

  /// A token for validating [code] against [vs].
  CacheToken generateValidationToken(
    ValidationOptions options,
    CodingValue code,
    FhirNode? vs,
  ) {
    final ct = CacheToken()..name = code.system ?? nameForNoSystem;
    final request = jsonEncode({
      'code': code.toJson(),
      'valueSet': _getVSEssence(vs),
      'options': options.toJson(),
    });
    ct
      ..request = request
      ..key = _hashNWS(request);
    return ct;
  }

  /// A token for validating [code] against [vs].
  CacheToken generateValidationTokenForCodeableConcept(
    ValidationOptions options,
    ConceptValue code,
    FhirNode? vs,
  ) {
    final ct = CacheToken();
    for (final coding in code.coding) {
      if (coding.system != null) ct.name = coding.system!;
    }
    final request = jsonEncode({
      'codeableConcept': code.toJson(),
      'valueSet': _getVSEssence(vs),
      'options': options.toJson(),
    });
    ct
      ..request = request
      ..key = _hashNWS(request);
    return ct;
  }

  /// The parts of a value set that decide a validation: status, compose and
  /// the expansion's parameters, contains and timestamp.
  Map<String, dynamic>? _getVSEssence(FhirNode? vs) {
    if (vs == null) return null;
    final json = toJson(vs);
    final expansion = json['expansion'] as Map<String, dynamic>?;
    return {
      if (json['status'] != null) 'status': json['status'],
      if (json['compose'] != null) 'compose': json['compose'],
      if (expansion != null)
        'expansion': {
          if (expansion['parameter'] != null)
            'parameter': expansion['parameter'],
          if (expansion['contains'] != null) 'contains': expansion['contains'],
          if (expansion['timestamp'] != null)
            'timestamp': expansion['timestamp'],
        },
    };
  }

  NamedCache _getNamedCache(CacheToken cacheToken) => caches.putIfAbsent(
        cacheToken.name,
        () => NamedCache(name: cacheToken.name),
      );

  /// The cached validation for [cacheToken], or null.
  ValidationResult? getValidation(CacheToken cacheToken) =>
      _getNamedCache(cacheToken).map[cacheToken.key]?.validationResult;

  /// Caches [result] for [cacheToken].
  void cacheValidation(
    CacheToken cacheToken,
    ValidationResult result,
    // ignore: avoid_positional_boolean_parameters
    bool persistent,
  ) {
    final nc = _getNamedCache(cacheToken);
    final entry = CacheEntry(
      request: cacheToken.request,
      persistent: persistent,
      validationResult: result,
    );
    _store(cacheToken, persistent, nc, entry);
  }

  void _store(
    CacheToken cacheToken,
    bool persistent,
    NamedCache nc,
    CacheEntry entry,
  ) {
    if (noCaching) return;
    final isExisting = nc.map.containsKey(cacheToken.key);
    nc.map[cacheToken.key] = entry;
    if (persistent) {
      if (isExisting) nc.list.removeWhere((e) => e.request == entry.request);
      nc.list.add(entry);
      _save(nc);
    }
  }

  void _save(NamedCache nc) {
    if (folder == null) return;
    try {
      final sink = StringBuffer()..writeln(entryMarker);
      for (final entry in nc.list) {
        sink
          ..writeln(entry.request.trim())
          ..writeln(break_);
        if (entry.expansionOutcome != null) {
          sink.writeln('e: {');
          if (entry.expansionOutcome!.valueSet != null) {
            sink.writeln(
              '  "valueSet": '
              '${jsonEncode(toJson(entry.expansionOutcome!.valueSet!))},',
            );
          }
          sink
            ..writeln(
              '  "error": '
              '"${_escapeJson(entry.expansionOutcome!.error ?? "")}"',
            )
            ..writeln('}');
        } else {
          sink.writeln('v: {');
          final r = entry.validationResult;
          final fields = <String, String>{
            if (r?.getDisplay() != null)
              'display': _escapeJson(r!.getDisplay()!),
            if (r?.getCode() != null) 'code': _escapeJson(r!.getCode()!),
            if (r?.system != null) 'system': _escapeJson(r!.system!),
            if (r?.severity != null) 'severity': r!.severity!.name,
            if (r?.message != null) 'error': _escapeJson(r!.message!),
            if (r?.errorClass != null) 'class': r!.errorClass!.name,
            if (r?.getDefinition() != null)
              'definition': _escapeJson(r!.getDefinition()!),
          };
          sink
            ..writeln(
              fields.entries
                  .map((e) => '  "${e.key}": "${e.value}"')
                  .join(',\n'),
            )
            ..writeln('}');
        }
        sink.writeln(entryMarker);
      }
      writeFileAsString('$folder/${nc.name}.cache', sink.toString());
    } on Exception catch (e) {
      // writeFileAsString is platform-abstracted (io or stub), so this names
      // no io type; a cache that fails to save costs nothing but the cache.
      print('Error saving ${nc.name}: $e');
    }
  }

  /// A one-line account of [valueSet]'s compose.
  String summaryForValueSet(FhirNode? valueSet) {
    if (valueSet == null) return 'null';
    final compose = valueSet.getChildByName('compose');
    final buffer = StringBuffer();
    for (final cc
        in compose?.getChildrenByName('include') ?? const <FhirNode>[]) {
      buffer.write('Include ${_getIncSummary(cc)}\n');
    }
    for (final cc
        in compose?.getChildrenByName('exclude') ?? const <FhirNode>[]) {
      buffer.write('Exclude ${_getIncSummary(cc)}\n');
    }
    return buffer.toString();
  }

  String _getIncSummary(FhirNode cc) {
    final buffer = StringBuffer();
    for (final uri in cc.getChildrenByName('valueSet')) {
      buffer.write(uri.primitiveValue);
    }
    final valueSetsDescription = buffer.isNotEmpty
        ? ' where the codes are in the value sets ($buffer)'
        : '';
    final system = cc.getChildByName('system')?.primitiveValue;
    final concepts = cc.getChildrenByName('concept');
    if (concepts.isNotEmpty) {
      return '${concepts.length} codes from $system$valueSetsDescription';
    }
    final filters = cc.getChildrenByName('filter');
    if (filters.isNotEmpty) {
      final text = filters
          .map(
            (f) => '${f.getChildByName('property')?.primitiveValue} '
                '${f.getChildByName('op')?.primitiveValue} '
                '${f.getChildByName('value')?.primitiveValue}',
          )
          .join(' & ');
      return 'from $system where $text$valueSetsDescription';
    }
    return 'All codes from $system$valueSetsDescription';
  }

  /// A one-line account of [coding].
  String summaryForCoding(CodingValue coding) =>
      '${coding.system ?? 'unknown'}#${coding.code ?? 'unknown'}: '
      '"${coding.display ?? 'unknown'}"';

  /// A one-line account of [concept].
  String summaryForCodeableConcept(ConceptValue concept) {
    final buffer = StringBuffer('{');
    for (var i = 0; i < concept.coding.length; i++) {
      if (i > 0) buffer.write(',');
      buffer.write(summaryForCoding(concept.coding[i]));
    }
    buffer.write('}: "${concept.text ?? 'unknown'}"');
    return buffer.toString();
  }

  String _escapeJson(String value) => value
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');

  void _load() {
    if (folder == null) return;
    final files = listFilesWithContents(folder!);
    for (final fileEntry in files.entries) {
      if (!fileEntry.key.endsWith('.cache') ||
          fileEntry.key.endsWith('validation.cache')) {
        continue;
      }
      var entryCount = 0;
      try {
        final title = fileEntry.key.replaceFirst('.cache', '');
        final nc = NamedCache(name: title);
        caches[title] = nc;
        var content = fileEntry.value;
        if (content.startsWith('?')) content = content.substring(1);
        var markerIndex = content.indexOf(entryMarker);
        while (markerIndex != -1) {
          entryCount++;
          final entry = content.substring(0, markerIndex);
          content = content.substring(markerIndex + entryMarker.length + 1);
          markerIndex = content.indexOf(entryMarker);
          if (entry.trim().isEmpty) continue;
          final breakIndex = entry.indexOf(break_);
          final request = entry.substring(0, breakIndex);
          final payload = entry.substring(breakIndex + break_.length).trim();
          final ce = CacheEntry(request: request, persistent: true);
          final json = jsonDecode(payload.substring(3)) as Map<String, dynamic>;
          if (payload.startsWith('e')) {
            // A persisted expansion needs the model to rebuild its node;
            // the cache has no model, so only the error form is restored.
            ce.expansionOutcome = ValueSetExpansionOutcome.withError(
              null,
              json['error'] as String?,
              TerminologyServiceErrorClass.unknown,
            );
          } else {
            ce.validationResult = ValidationResult(
              severity: json['severity'] == null
                  ? null
                  : ValidationSeverity.values
                      .byName(json['severity'] as String),
              message: json['error'] as String?,
              system: json['system'] as String?,
              definition: json['code'] == null
                  ? null
                  : ConceptDefinition(
                      code: json['code'] as String,
                      display: json['display'] as String?,
                      definition: json['definition'] as String?,
                    ),
              errorClass: json['class'] == null
                  ? null
                  : TerminologyServiceErrorClass.values
                      .byName(json['class'] as String),
            );
          }
          nc.map[_hashNWS(request)] = ce;
          nc.list.add(ce);
        }
      } on FormatException catch (e) {
        throw FormatException(
          'Error loading $folder/${fileEntry.key}: $e entry $entryCount',
        );
      }
    }
  }

  String _hashNWS(String input) =>
      base64Encode(utf8.encode(input.replaceAll(RegExp(r'\s'), '')));

  /// Caches an expansion.
  void cacheExpansion(
    ValueSetCacheToken token,
    ValueSetExpansionOutcome outcome,
    int mode,
  ) {
    _expansionCache[token] = outcome;
  }

  /// A token for expanding [vs].
  ValueSetCacheToken generateExpandToken(FhirNode vs, bool hierarchical) =>
      ValueSetCacheToken(
        vs.getChildByName('url')?.primitiveValue,
        vs.getChildByName('version')?.primitiveValue,
        hierarchical,
      );

  /// The cached expansion for [token], or null.
  ValueSetExpansionOutcome? getExpansion(ValueSetCacheToken token) =>
      _expansionCache[token];
}

/// A validation request's key in the cache.
class CacheToken {
  /// The named cache (the code system).
  String name = '';

  /// The hashed request.
  String key = '';

  /// The request.
  String request = '';
}

/// A cached answer.
class CacheEntry {
  /// An entry.
  CacheEntry({
    required this.request,
    this.persistent = false,
    this.validationResult,
    this.expansionOutcome,
  });

  /// The request.
  final String request;

  /// Whether the entry is written to disk.
  final bool persistent;

  /// The validation, when the entry is one.
  ValidationResult? validationResult;

  /// The expansion, when the entry is one.
  ValueSetExpansionOutcome? expansionOutcome;
}

/// One code system's cache.
class NamedCache {
  /// A named cache.
  NamedCache({required this.name});

  /// The code system.
  final String name;

  /// The entries, in order.
  final List<CacheEntry> list = [];

  /// The entries by key.
  final Map<String, CacheEntry> map = {};
}
