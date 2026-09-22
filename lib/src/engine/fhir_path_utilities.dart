// ignore_for_file: public_member_api_docs, avoid_positional_boolean_parameters

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';
import 'package:fhir_path/src/utils/path_string_extensions.dart';
import 'package:ucum/ucum.dart';

/// Internal utilities class for FHIRPath engine.
///
/// This class contains helper methods used by operations, functions, and
/// execution. It is not part of the public API - users should use
/// [FHIRPathEngine] instead.
class FhirPathUtilities {
  FhirPathUtilities(this.fpContext);

  final FhirPathContext fpContext;

  // String conversion helpers
  String convertToString(FhirNode item) {
    if (item.isPrimitive) {
      return item.primitiveValue ?? '';
    } else if (isQuantityNode(item)) {
      final unit = qtyUnit(item);
      final system = qtySystem(item);
      final valueStr = _firstChildPrimitive(item, 'value');
      if (unit != null &&
          [
            'year',
            'years',
            'month',
            'months',
            'week',
            'weeks',
            'day',
            'days',
            'hour',
            'hours',
            'minute',
            'minutes',
            'second',
            'seconds',
            'millisecond',
            'milliseconds',
          ].contains(unit) &&
          (system == null || system == 'http://unitsofmeasure.org')) {
        return '$valueStr $unit';
      }
      if (system == 'http://unitsofmeasure.org') {
        final u = "'${qtyCode(item)}'";
        return '$valueStr $u';
      } else {
        return item.toString();
      }
    } else {
      return item.toString();
    }
  }

  String convertListToString(List<FhirNode> items) {
    final b = StringBuffer();
    var first = true;
    for (final item in items) {
      if (first) {
        first = false;
      } else {
        b.write(',');
      }

      b.write(convertToString(item));
    }
    return b.toString();
  }

  List<FhirNode> makeBoolean(bool value) {
    return <FhirNode>[fpContext.factory.boolean(value)];
  }

  /// The FHIR primitive type names FHIRPath treats as numbers. Mirrors the
  /// `FhirNumber` hierarchy (note: `integer64` is NOT a `FhirNumber`).
  static const Set<String> numericTypeNames = {
    'decimal',
    'integer',
    'positiveInt',
    'unsignedInt',
  };

  /// The integer-kind FHIR primitive type names (the `FhirNumber` hierarchy
  /// minus `decimal`).
  static const Set<String> integerTypeNames = {
    'integer',
    'positiveInt',
    'unsignedInt',
  };

  /// The FHIRPath System type names — a bare (unqualified) type specifier
  /// resolves to the `System` namespace iff it is one of these; every other
  /// bare name is a `FHIR` type. Mirrors the Java reference `funcIs` list
  /// (org.hl7.fhir.r4 FHIRPathEngine.funcIs; note `Quantity` is deliberately
  /// NOT in it — bare `Quantity` is the FHIR type, matched through the
  /// subtype hierarchy so Age/Duration/... qualify).
  static const Set<String> systemTypeNames = {
    'Boolean',
    'Integer',
    'Decimal',
    'String',
    'DateTime',
    'Date',
    'Time',
    'SimpleTypeInfo',
    'ClassInfo',
  };

  /// Splits a FHIRPath type-specifier string into its `(namespace, name)`:
  /// an explicit `System.`/`FHIR.` prefix wins; otherwise a bare name is
  /// `System` iff it is in [systemTypeNames], else `FHIR`. This is the same
  /// resolution the parse-tree function form (`is()`) applies, so the `is`
  /// OPERATOR shares the one type-membership predicate with it — the FHIRPath
  /// spec (§6.3 Types) defines `x is T` and `x.is(T)` as equivalent, and the
  /// official test suite asserts the same expectations through both forms.
  (String, String) resolveTypeSpecifier(String tn) {
    if (tn.startsWith('System.')) {
      return ('System', tn.substring(7));
    }
    if (tn.startsWith('FHIR.')) {
      return ('FHIR', tn.substring(5));
    }
    return systemTypeNames.contains(tn) ? ('System', tn) : ('FHIR', tn);
  }

  /// The FHIR primitive type names FHIRPath treats as `System.DateTime` /
  /// `System.Date`. Mirrors the `FhirDateTimeBase` hierarchy.
  static const Set<String> dateTimeTypeNames = {
    'date',
    'dateTime',
    'instant',
  };

  /// Whether [node] is a date/dateTime/instant primitive — the
  /// model-independent equivalent of `node is FhirDateTimeBase`.
  bool isDateTimeNode(FhirNode node) =>
      node.isPrimitive && dateTimeTypeNames.contains(node.fhirType);

  /// Whether [node] is a `time` primitive — the model-independent equivalent
  /// of `node is FhirTime`.
  bool isTimeNode(FhirNode node) => node.isPrimitive && node.fhirType == 'time';

  /// Compares two date/dateTime/instant nodes under FHIRPath partial-precision
  /// semantics, reading each node's value string via the node contract.
  /// Returns null when the comparison is indeterminate (differing precision).
  bool? compareDateTimeNodes(
    FhirNode left,
    FhirNode right,
    TemporalComparator comparator,
  ) =>
      SystemDateTime.compareStrings(
        left.primitiveValue,
        right.primitiveValue,
        comparator,
      );

  /// Compares two `time` nodes component-wise, reading each value string via
  /// the node contract. Returns null when the operands differ in precision.
  bool? compareTimeNodes(
    FhirNode left,
    FhirNode right,
    TemporalComparator comparator,
  ) =>
      SystemTime.compareStrings(
        left.primitiveValue,
        right.primitiveValue,
        comparator,
      );

  /// Whether [node] is a numeric primitive — the model-independent equivalent
  /// of `node is FhirNumber`, decided from the node's [FhirNode.fhirType]
  /// rather than its Dart class so the engine needn't name FHIR value types.
  bool isNumericNode(FhirNode node) =>
      node.isPrimitive && numericTypeNames.contains(node.fhirType);

  /// Reads [node]'s numeric value as a Dart [num], mirroring
  /// `FhirNumber.valueNum` exactly (int for integer kinds, double for
  /// decimal). Returns null when the value is absent or unparseable.
  num? nodeNum(FhirNode node) {
    final s = node.primitiveValue;
    if (s == null) {
      return null;
    }
    return node.fhirType == 'decimal'
        ? double.tryParse(s)
        : int.tryParse(s) ?? double.tryParse(s);
  }

  /// Builds the FHIR-typed result of a binary numeric operation on operands
  /// [l] and [r] whose computed value is [value], mirroring
  /// `FhirNumber._operateOrNull`: a decimal when either operand is a decimal,
  /// otherwise an integer when [value] is a Dart `int` (`FhirNumber.fromNum`),
  /// else a decimal. Bare (extensions allowed), matching the arithmetic
  /// operators' direct construction.
  FhirNode numericResult(num value, FhirNode l, FhirNode r) {
    final eitherDecimal = l.fhirType == 'decimal' || r.fhirType == 'decimal';
    return eitherDecimal || value is! int
        ? fpContext.factory.decimal(value, disallowExtensions: false)
        : fpContext.factory.integer(value, disallowExtensions: false);
  }

  /// Whether [node] has any populated child — verbatim port of
  /// `FhirBase.hasValues`, expressed over the node contract.
  bool nodeHasValues(FhirNode node) {
    for (final child in node.listChildrenNames()) {
      if (node.getChildByName(child) != null) {
        return true;
      }
    }
    return false;
  }

  /// Whether [node] is a `Quantity` — the model-independent form of
  /// `node is Quantity`, decided from [FhirNode.fhirType].
  bool isQuantityNode(FhirNode node) => node.fhirType == 'Quantity';

  /// Negates a decimal STRING exactly — sign flip with the representation
  /// (scale, trailing zeros) preserved, and no negative zero. This is what
  /// the Java reference's BigDecimal arithmetic produces for unary minus
  /// (`BigDecimal.negate()` keeps the scale; a BigDecimal zero has no sign),
  /// where double arithmetic would render `-120.50` as `-120.5` and negate
  /// `0.0` to `-0.0`.
  String negateDecimalString(String s) {
    var v = s.startsWith('+') ? s.substring(1) : s;
    final negative = v.startsWith('-');
    if (negative) {
      v = v.substring(1);
    }
    // A zero has no sign.
    if (v.replaceAll('.', '').replaceAll('0', '').isEmpty) {
      return v;
    }
    return negative ? v : '-$v';
  }

  String? _firstChildPrimitive(FhirNode node, String name) {
    final children = node.getChildrenByName(name);
    return children.isEmpty ? null : children.first.primitiveValue;
  }

  /// The `Quantity.value` of [node] as a Dart [num], read via the node
  /// contract (Quantity fields are 0..1).
  num? qtyValue(FhirNode node) {
    final children = node.getChildrenByName('value');
    return children.isEmpty ? null : nodeNum(children.first);
  }

  /// The `Quantity.unit` of [node], read via the node contract.
  String? qtyUnit(FhirNode node) => _firstChildPrimitive(node, 'unit');

  /// The `Quantity.code` of [node], read via the node contract.
  String? qtyCode(FhirNode node) => _firstChildPrimitive(node, 'code');

  /// The `Quantity.system` of [node], read via the node contract.
  String? qtySystem(FhirNode node) => _firstChildPrimitive(node, 'system');

  bool isBoolean(List<FhirNode> list, bool value) {
    return list.length == 1 &&
        list.first.fhirType == 'boolean' &&
        list.first.primitiveValue == (value ? 'true' : 'false');
  }

  FpEquality asBool(FhirNode item, [bool narrow = false]) {
    if (item.fhirType == 'boolean' && item.primitiveValue != null) {
      return item.primitiveValue == 'true'
          ? FpEquality.true_
          : FpEquality.false_;
    }

    if (!narrow) {
      if (integerTypeNames.contains(item.fhirType) &&
          item.primitiveValue != null) {
        return asBoolFromInt(item.primitiveValue!);
      } else if (item.fhirType == 'decimal' && item.primitiveValue != null) {
        return asBoolFromDec(item.primitiveValue!);
      } else if (item.fhirType == 'string') {
        final lowerValue = (item.primitiveValue ?? '').toLowerCase();
        if (['true', 't', 'yes', 'y', '1', '1.0'].contains(lowerValue)) {
          return FpEquality.true_;
        } else if (['false', 'f', 'no', 'n', '0', '0.0'].contains(lowerValue)) {
          return FpEquality.false_;
        }
      }
    }
    return FpEquality.null_;
  }

  FpEquality asBoolFromList(List<FhirNode> items, ExpressionNode expr) {
    if (items.isEmpty) return FpEquality.null_;

    if (items.length == 1) {
      if (items.first.fhirType == 'boolean') {
        return asBool(items.first, true);
      }
      return FpEquality.true_;
    }

    throw fpContext.makeException(
      expr,
      'FHIRPATH_UNABLE_BOOLEAN',
      items.map((e) => e.toString()).toList(),
    );
  }

  FpEquality asBoolFromInt(String value) {
    final parsedValue = int.tryParse(value);

    if (parsedValue == null) return FpEquality.null_;
    if (parsedValue == 0) return FpEquality.false_;
    if (parsedValue == 1) return FpEquality.true_;
    return FpEquality.null_;
  }

  FpEquality asBoolFromDec(String value) {
    try {
      final parsedValue = BigInt.parse(value);
      if (parsedValue == BigInt.zero) return FpEquality.false_;
      if (parsedValue == BigInt.one) return FpEquality.true_;
      return FpEquality.null_;
    } on FormatException catch (_) {
      return FpEquality.null_;
    }
  }

  bool canConvertToBoolean(FhirNode item) {
    if (item.fhirType == 'boolean') return true;

    if (item.isPrimitive) {
      final value = item.toString().toLowerCase();
      return [
        'true',
        't',
        'yes',
        'y',
        '1',
        '1.0',
        'false',
        'f',
        'no',
        'n',
        '0',
        '0.0',
      ].contains(value);
    }

    return false;
  }

  bool convertToBoolean(List<FhirNode>? items) {
    if (items == null || items.isEmpty) return false;

    if (items.length == 1) {
      final first = items.first;
      if (first.fhirType == 'boolean') {
        return first.primitiveValue == 'true';
      }

      final lowerValue = first.toString().toLowerCase();
      if (['true', 't', 'yes', 'y', '1', '1.0'].contains(lowerValue)) {
        return true;
      } else if (['false', 'f', 'no', 'n', '0', '0.0'].contains(lowerValue)) {
        return false;
      }
    }

    return items.isNotEmpty;
  }

  FpEquality asBoolList(List<FhirNode> items, ExpressionNode expr) {
    if (items.isEmpty) {
      return FpEquality.null_;
    } else if (items.length == 1) {
      final eqBool = asBool(items.first);
      return eqBool == FpEquality.null_ ? FpEquality.true_ : eqBool;
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_UNABLE_BOOLEAN',
        [convertListToString(items)],
      );
    }
  }

  FpEquality boolToTriState(bool b) {
    return b ? FpEquality.true_ : FpEquality.false_;
  }

  /// Deep equality where either side may be null (Java reference
  /// `Base.equalsDeepWithNull`).
  bool deepEqualWithNull(FhirNode? a, FhirNode? b) {
    if (a == null && b == null) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    return a.equalsDeep(b);
  }

  /// Deep equality with optional empty-tolerance and the metadata-based side
  /// driving the comparison (Java reference `Base.compareDeep`).
  bool deepEqual(FhirNode? a, FhirNode? b, [bool allowNull = false]) {
    if (allowNull) {
      final noLeft = a == null || a.isEmpty();
      final noRight = b == null || b.isEmpty();
      if (noLeft && noRight) {
        return true;
      }
    }
    if (a == null || b == null) {
      return false;
    }
    if (b.isMetadataBased && !a.isMetadataBased) {
      return b.equalsDeep(a);
    }
    return a.equalsDeep(b);
  }

  /// Pairwise deep equality of two lists (Java reference
  /// `Base.compareDeepLists`).
  bool deepEqualLists(
    List<FhirNode>? e1,
    List<FhirNode>? e2, [
    bool allowNull = false,
  ]) {
    final noLeft = e1 == null || e1.isEmpty;
    final noRight = e2 == null || e2.isEmpty;
    if (noLeft && noRight && allowNull) {
      return true;
    }
    if (noLeft || noRight) {
      return false;
    }
    if (e1.length != e2.length) {
      return false;
    }
    for (var i = 0; i < e1.length; i++) {
      if (!deepEqual(e1[i], e2[i], allowNull)) {
        return false;
      }
    }
    return true;
  }

  bool? doEquals(FhirNode left, FhirNode right) {
    if (isQuantityNode(left) && isQuantityNode(right)) {
      return qtyEqual(left, right);
    } else if (isQuantityNode(left) &&
        isNumericNode(right) &&
        nodeNum(right) != null) {
      return qtyEqual(
        left,
        fpContext.factory.quantity(
          value: nodeNum(right),
          system: 'http://unitsofmeasure.org',
          code: '1',
        ),
      );
    } else if (isDateTimeNode(left) && isDateTimeNode(right)) {
      return compareDateTimeNodes(left, right, TemporalComparator.equal);
    } else if (left.fhirType == 'decimal' || right.fhirType == 'decimal') {
      return decEqual(left.toString(), right.toString());
    } else if (left.isPrimitive && right.isPrimitive) {
      return left.primitiveValue == right.primitiveValue;
    } else {
      return deepEqual(left, right);
    }
  }

  bool decEqual(String left, String right) {
    return removeTrailingZeros(left) == removeTrailingZeros(right);
  }

  /// Strips insignificant FRACTIONAL trailing zeros (and a then-bare dot) so
  /// [decEqual] ignores them per FHIRPath §6.1.1: `1.10 = 1.1` and
  /// `10.0 = 10` are both true; an integer's zeros (`10`) are significant
  /// and kept.
  ///
  /// Deliberate deviation from the Java reference's `removeTrailingZeros`,
  /// which strips zeros from dot-less strings too (`'10'` -> `'1'`, making
  /// `10.0 = 10` false); an earlier port of it bailed out early instead,
  /// keeping `1.10` intact (making official testEquality14 false). The spec
  /// rule needs both to hold.
  String removeTrailingZeros(String s) {
    if (s.noString()) {
      return '';
    }
    if (!s.contains('.')) {
      return s;
    }
    var end = s.length;
    while (end > 0 && s[end - 1] == '0') {
      end--;
    }
    if (end > 0 && s[end - 1] == '.') {
      end--;
    }
    return s.substring(0, end);
  }

  bool? qtyEqual(FhirNode left, FhirNode right) {
    final lValue = qtyValue(left);
    final rValue = qtyValue(right);
    if (lValue == null && rValue == null) {
      return true;
    }
    if (lValue == null || rValue == null) {
      return null;
    }
    final dl = qtyToCanonicalPair(left);
    final dr = qtyToCanonicalPair(right);

    if (dl != null && dr != null) {
      if (dl.unit == dr.unit) {
        return doEquals(
          fpContext.factory
              .decimal(dl.value.asDouble, disallowExtensions: false),
          fpContext.factory
              .decimal(dr.value.asDouble, disallowExtensions: false),
        );
      } else {
        return false;
      }
    }
    final lCode = qtyCode(left);
    final rCode = qtyCode(right);
    final lUnit = qtyUnit(left);
    final rUnit = qtyUnit(right);
    if (lCode != null || rCode != null) {
      if (!(lCode != null && rCode != null) || lCode != rCode) {
        return null;
      }
    } else if (lUnit == null || rUnit == null) {
      if (!(lUnit != null && rUnit != null) || lUnit != rUnit) {
        return null;
      }
    }
    return doEquals(left, right);
  }

  /// [qtyToCanonicalPair] with the FHIRPath §6.1.2 equivalence extension:
  /// a system-less calendar-duration quantity (`1 year`, `1 month`, ... —
  /// which the parser deliberately leaves without a UCUM code) is mapped to
  /// its definite-duration UCUM equivalent so that `1 year ~ 1 'a'` is true.
  /// Used by equivalence ONLY — equality keeps them un-comparable.
  Pair? qtyToEquivalenceCanonicalPair(FhirNode q) {
    if (qtySystem(q) == null && qtyCode(q) == null) {
      const calendarToUcum = {
        'year': 'a', 'years': 'a', //
        'month': 'mo', 'months': 'mo',
        'week': 'wk', 'weeks': 'wk',
        'day': 'd', 'days': 'd',
        'hour': 'h', 'hours': 'h',
        'minute': 'min', 'minutes': 'min',
        'second': 's', 'seconds': 's',
        'millisecond': 'ms', 'milliseconds': 'ms',
      };
      final ucum = calendarToUcum[qtyUnit(q)];
      if (ucum != null) {
        final value = qtyValue(q);
        if (value == null) return null;
        try {
          final p = Pair(value: UcumDecimal.fromNum(value), unit: ucum);
          return fpContext.worker.ucumService.getCanonicalForm(p);
        } on UcumException catch (_) {
          return null;
        }
      }
    }
    return qtyToCanonicalPair(q);
  }

  /// Canonicalises a UCUM quantity. A quantity whose system is not UCUM —
  /// notably the calendar-duration literals `1 year`/`1 month`, which the
  /// parser deliberately leaves without a system/code ("this is not the UCUM
  /// year", Java reference) — returns null, which is what makes
  /// `1 'mo' = 1 month` EMPTY (calendar and definite durations are not
  /// comparable) while `1 'wk' = 1 week` is true (week and below get UCUM
  /// codes at parse time). Verbatim Java `qtyToCanonicalPair`.
  Pair? qtyToCanonicalPair(FhirNode q) {
    if (qtySystem(q) != 'http://unitsofmeasure.org') {
      return null;
    }
    final value = qtyValue(q);
    if (value == null) return null;
    try {
      final p =
          Pair(value: UcumDecimal.fromNum(value), unit: qtyCode(q) ?? '1');
      return fpContext.worker.ucumService.getCanonicalForm(p);
    } on UcumException catch (_) {
      return null;
    }
  }

  Future<bool> isKnownType(String? tn) async {
    if (tn == null) {
      return false;
    } else if (!tn.contains('.')) {
      // SimpleTypeInfo/ClassInfo are FHIRPath reflection types (engine-side);
      // every model-type-name test is the worker's (which fast-paths on the
      // generated model's type-name classification).
      if (['SimpleTypeInfo', 'ClassInfo'].contains(tn)) {
        return true;
      }
      return fpContext.worker.isKnownType(tn);
    }
    final t = tn.split('.');
    if (t.length != 2) {
      return false;
    }
    if ('System' == t[0]) {
      return [
        'String',
        'Boolean',
        'Integer',
        'Decimal',
        'Quantity',
        'DateTime',
        'Time',
        'SimpleTypeInfo',
        'ClassInfo',
      ].contains(t[1]);
    } else if ('FHIR' == t[0]) {
      if (['SimpleTypeInfo', 'ClassInfo'].contains(t[1])) {
        return true;
      }
      return fpContext.worker.isKnownType(t[1]);
    } else {
      return false;
    }
  }

  bool compareTypeNames(String left, String right) {
    if (fpContext.doNotEnforceAsCaseSensitive) {
      return left.equalsIgnoreCase(right);
    } else {
      return left == right;
    }
  }

  bool? doEquivalent(FhirNode left, FhirNode right) {
    if (isQuantityNode(left) && isQuantityNode(right)) {
      return qtyEquivalent(left, right);
    }
    if (isQuantityNode(left) && isNumericNode(right)) {
      return qtyEquivalent(
        left,
        fpContext.factory.quantity(
          value: nodeNum(right),
          system: 'http://unitsofmeasure.org',
          code: '1',
        ),
      );
    }
    if (left.fhirType == 'boolean' && right.fhirType == 'boolean') {
      return doEquals(left, right);
    }
    if (isNumericNode(left) && isNumericNode(right)) {
      return equivalentNumber(nodeNum(left), nodeNum(right));
    }
    if (isDateTimeNode(left) && isDateTimeNode(right)) {
      // Equivalence is never empty: an indeterminate datetime comparison is
      // "not equivalent" (Java compareDateTimeElements equivalence path maps
      // equalsUsingFhirPathRules == TRUE ? 0 : 1).
      return compareDateTimeNodes(left, right, TemporalComparator.equivalent) ??
          false;
    }
    if (fpContext.FHIR_TYPES_STRING.contains(left.fhirType) &&
        fpContext.FHIR_TYPES_STRING.contains(right.fhirType)) {
      return equivalentString(
        convertToString(left),
        convertToString(right),
      );
    }
    if (left.isPrimitive && right.isPrimitive) {
      return equivalentString(
        left.toString(),
        right.toString(),
      );
    }
    if (!left.isPrimitive && !right.isPrimitive) {
      return deepEqualWithNull(left, right);
    } else {
      return false;
    }
  }

  bool equivalentString(String l, String r) {
    if (Utilities.noString(l) && Utilities.noString(r)) return true;
    if (Utilities.noString(l) || Utilities.noString(r)) return false;
    return l.toLowerCase() == r.toLowerCase();
  }

  bool equivalentNumber(num? lhsNum, num? rhsNum) {
    if (lhsNum == null && rhsNum == null) {
      return true;
    } else if (lhsNum == null || rhsNum == null) {
      return false;
    }
    final sigDigsLhs = lhsNum
        .toStringAsExponential()
        .split('e')
        .first
        .replaceAll('.', '')
        .length;
    final sigDigsRhs = rhsNum
        .toStringAsExponential()
        .split('e')
        .first
        .replaceAll('.', '')
        .length;
    if (sigDigsLhs < sigDigsRhs) {
      return lhsNum.toStringAsPrecision(sigDigsLhs) ==
          rhsNum.toStringAsPrecision(sigDigsLhs);
    } else {
      return lhsNum.toStringAsPrecision(sigDigsRhs) ==
          rhsNum.toStringAsPrecision(sigDigsRhs);
    }
  }

  bool? qtyEquivalent(FhirNode left, FhirNode right) {
    final lValue = qtyValue(left);
    final rValue = qtyValue(right);
    if (lValue == null && rValue == null) {
      return true;
    }
    if (lValue == null || rValue == null) {
      return null;
    }
    // Unlike equality (where FHIRPath §6.1.1 keeps calendar durations and
    // definite durations un-comparable, so `1 'mo' = 1 month` is empty),
    // equivalence treats them as the same: §6.1.2 "For time-valued
    // quantities, calendar durations and definite quantity durations are
    // considered equivalent" (spec example: 1 year ~ 1 'a' // true). The
    // Java reference omits this rule; the spec governs.
    final dl = qtyToEquivalenceCanonicalPair(left);
    final dr = qtyToEquivalenceCanonicalPair(right);

    if (dl != null && dr != null) {
      if (dl.unit == dr.unit) {
        return doEquivalent(
          fpContext.factory
              .decimal(dl.value.asDouble, disallowExtensions: false),
          fpContext.factory
              .decimal(dr.value.asDouble, disallowExtensions: false),
        );
      } else {
        return false;
      }
    }
    final lCode = qtyCode(left);
    final rCode = qtyCode(right);
    final lUnit = qtyUnit(left);
    final rUnit = qtyUnit(right);
    if (lCode != null || rCode != null) {
      if (!(lCode != null && rCode != null) || lCode != rCode) {
        return null;
      }
    } else if (lUnit == null || rUnit == null) {
      if (!(lUnit != null && rUnit != null) || lUnit != rUnit) {
        return null;
      }
    }
    return doEquivalent(
      left.getChildrenByName('value').first,
      right.getChildrenByName('value').first,
    );
  }

  bool doContains(List<FhirNode> list, FhirNode item) {
    for (final test in list) {
      final eq = doEquals(test, item);
      if (eq != null && eq) {
        return true;
      }
    }
    return false;
  }

  FhirNode? qtyToCanonicalDecimal(FhirNode q) {
    if (qtySystem(q) != 'http://unitsofmeasure.org') {
      return null;
    }
    final value = qtyValue(q);
    if (value == null) return null;
    try {
      final pair = Pair(
        value: UcumDecimal.fromNum(value),
        unit: qtyCode(q) ?? '1',
      );
      final canonicalPair = fpContext.worker.ucumService.getCanonicalForm(pair);
      final canonical = canonicalPair.value.asDouble;
      if (!canonical.isFinite) return null;
      return fpContext.factory.decimal(canonical, disallowExtensions: false);
    } on UcumException catch (_) {
      return null;
    }
  }

  List<FhirNode> makeNull() => <FhirNode>[];

  FhirNode dateAdd(
    FhirNode d,
    FhirNode q,
    bool negate,
    ExpressionNode holder,
  ) {
    final base = SystemDateTime.parse(d.primitiveValue);
    if (base == null) {
      throw PathEngineException(
        'Error in date arithmetic: invalid date/time value ${d.primitiveValue}',
      );
    }

    final rawValue = qtyValue(q)!.toInt();
    final value = negate ? -rawValue : rawValue;
    final unit = qtyCode(q) ?? qtyUnit(q);

    SystemDateTime result;
    switch (unit) {
      case 'years':
      case 'year':
        result = base.plus(TemporalDuration(years: value));
      case 'a':
        throw PathEngineException(
          'Error in date arithmetic: attempt to add a definite quantity '
          'duration time unit $unit',
        );
      case 'months':
      case 'month':
        result = base.plus(TemporalDuration(months: value));
      case 'mo':
        throw PathEngineException(
          'Error in date arithmetic: attempt to add a definite quantity '
          'duration time unit $unit',
          location: holder.opStart,
          expression: holder.toString(),
        );
      case 'weeks':
      case 'week':
      case 'wk':
        result = base.plus(TemporalDuration(weeks: value));
      case 'days':
      case 'day':
      case 'd':
        result = base.plus(TemporalDuration(days: value));
      case 'hours':
      case 'hour':
      case 'h':
        result = base.plus(TemporalDuration(hours: value));
      case 'minutes':
      case 'minute':
      case 'min':
        result = base.plus(TemporalDuration(minutes: value));
      case 'seconds':
      case 'second':
      case 's':
        result = base.plus(TemporalDuration(seconds: value));
      case 'milliseconds':
      case 'millisecond':
      case 'ms':
        result = base.plus(TemporalDuration(milliseconds: value));
      default:
        throw PathEngineException(
          'Error in date arithmetic: unrecognized time unit $unit',
        );
    }

    return fpContext.factory
        .dateTimeOfType(d.fhirType, result.toDateTimeString()!);
  }

  Pair? qtyToPair(FhirNode q) {
    if (qtySystem(q) != 'http://unitsofmeasure.org') {
      return null;
    }
    final value = qtyValue(q);
    if (value == null) return null;
    try {
      return Pair(value: UcumDecimal.fromNum(value), unit: qtyCode(q) ?? '1');
    } on UcumException catch (_) {
      return null;
    }
  }

  FhirNode pairToQty(Pair pair) {
    return fpContext.factory.quantity(
      value: pair.value.asDouble,
      system: 'http://unitsofmeasure.org',
      code: pair.unit.isEmpty ? null : pair.unit,
      disallowExtensions: true,
    );
  }
}
