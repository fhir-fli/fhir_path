import 'package:meta/meta.dart';

/// ValueSetCacheToken
@immutable
class ValueSetCacheToken {
  /// Create a new cache token
  const ValueSetCacheToken(
    this.valueSetUrl,
    this.valueSetVersion,
    this.hierarchical,
  );

  /// The value set URL
  final String? valueSetUrl;

  /// The value set version
  final String? valueSetVersion;

  /// Whether the expansion is hierarchical
  final bool hierarchical;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueSetCacheToken &&
          runtimeType == other.runtimeType &&
          valueSetUrl == other.valueSetUrl &&
          valueSetVersion == other.valueSetVersion &&
          hierarchical == other.hierarchical;

  @override
  int get hashCode => Object.hash(valueSetUrl, valueSetVersion, hierarchical);
}
