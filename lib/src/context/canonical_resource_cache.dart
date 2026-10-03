import 'dart:math';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// A cached canonical resource with the keys the cache files it under.
class CachedCanonicalResource {
  /// A cache entry.
  CachedCanonicalResource(this.resource, this.id, [this.packageInfo]);

  /// The resource node.
  final FhirNode resource;

  /// Its id: the resource's own, or one the cache gave it.
  final String id;

  /// Optional package/version metadata where this resource came from.
  final PackageVersion? packageInfo;

  /// Its canonical url (required of a canonical resource).
  String get url => resource.getChildByName('url')!.primitiveValue!;

  /// Its version, if present.
  String? get version => resource.getChildByName('version')?.primitiveValue;
}

/// A resource cache that holds what it is given, in memory.
class CanonicalResourceCache extends ResourceCache {
  /// A cache.
  CanonicalResourceCache({this.enforceUniqueId = false, super.client});

  /// If true, inserting a resource with the same ID replaces the old one.
  final bool enforceUniqueId;

  final Map<String, CachedCanonicalResource> _byId = {};

  /// By url, and by "url|version".
  final Map<String, CachedCanonicalResource> _byUrl = {};

  @override
  Future<void> saveCanonicalResource(FhirNode resource) async => see(resource);

  /// Keeps [resource]. A resource with no id is filed under a generated one.
  void see(FhirNode resource, [PackageVersion? pkg]) {
    final id = resource.getChildByName('id')?.primitiveValue ?? _newId();
    final cached = CachedCanonicalResource(resource, id, pkg);
    if (enforceUniqueId && _byId.containsKey(cached.id)) {
      _drop(cached.id);
    }
    _byId[cached.id] = cached;
    _byUrl[cached.url] = cached;
    final key = cached.version != null
        ? '${cached.url}|${cached.version}'
        : '${cached.url}|#0';
    _byUrl[key] = cached;
    _updateLatest(cached.url);
  }

  @override
  Future<FhirNode?> getCanonicalResource(String url, [String? version]) async {
    if (version != null) return _byUrl['$url|$version']?.resource;
    return _byUrl[url]?.resource;
  }

  @override
  Future<FhirNode?> getStructureDefinition(String url) async {
    final r = await getCanonicalResource(url);
    return r != null && r.fhirType == 'StructureDefinition' ? r : null;
  }

  @override
  Future<List<FhirNode>> getStructureDefinitions() async => [
        for (final c in _byId.values)
          if (c.resource.fhirType == 'StructureDefinition') c.resource,
      ];

  @override
  Future<FhirNode?> getCodeSystem(String url, [String? version]) async {
    final r = await getCanonicalResource(url, version);
    return r != null && r.fhirType == 'CodeSystem' ? r : null;
  }

  @override
  Future<List<String>> getResourceNames() async => {
        for (final c in _byId.values)
          if (c.resource.getChildByName('name')?.primitiveValue case final n?)
            n,
      }.toList();

  void _drop(String id) {
    final cached = _byId.remove(id);
    if (cached == null) return;
    _byUrl.remove(cached.url);
    if (cached.version != null) {
      _byUrl.remove('${cached.url}|${cached.version}');
    } else {
      _byUrl.remove('${cached.url}|#0');
    }
    _updateLatest(cached.url);
  }

  /// Recompute the unversioned "latest" pointer for [url].
  void _updateLatest(String url) {
    final versions = _byUrl.entries
        .where((e) => e.key.startsWith('$url|'))
        .map((e) => e.value)
        .toList();
    if (versions.isEmpty) return;
    versions.sort((a, b) => (a.version ?? '').compareTo(b.version ?? ''));
    _byUrl[url] = versions.last;
  }

  /// A random id for a resource that came without one (a v4-shaped UUID).
  static String _newId() {
    final r = Random.secure();
    String hex(int n) =>
        List.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-'
        '${(8 + r.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
  }
}
