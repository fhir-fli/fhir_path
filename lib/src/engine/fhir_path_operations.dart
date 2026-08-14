// ignore_for_file: public_member_api_docs

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';

/// Internal operations class for FHIRPath engine.
///
/// Handles all FHIRPath operations (+, -, *, /, ==, !=, <, >, etc.)
class FhirPathOperations {
  FhirPathOperations(this.fpContext, this.utilities, this.engine);

  final FhirPathContext fpContext;
  final FHIRPathEngine engine;
  final FhirPathUtilities utilities;

  /// OPERATIONS
  /// ***************************************
  ///
  List<FhirNode>? preOperate(
    List<FhirNode> left,
    FpOperation? operation,
    ExpressionNode expr,
  ) {
    if (left.isEmpty) return null;
    switch (operation) {
      case FpOperation.And:
        return utilities.isBoolean(left, false)
            ? utilities.makeBoolean(false)
            : null;
      case FpOperation.Or:
        return utilities.isBoolean(left, true)
            ? utilities.makeBoolean(true)
            : null;
      case FpOperation.Implies:
        final v = utilities.asBoolFromList(left, expr);
        return v == FpEquality.false_ ? utilities.makeBoolean(true) : null;
      // ignore: no_default_cases
      default:
        return null;
    }
  }

  Future<List<FhirNode>> operate(
    ExecutionContext execContext,
    List<FhirNode> left,
    FpOperation? operation,
    List<FhirNode> right,
    ExpressionNode holder,
  ) async {
    switch (operation) {
      case FpOperation.Equals:
        return opEquals(left, right, holder);
      case FpOperation.Equivalent:
        return opEquivalent(left, right, holder);
      case FpOperation.NotEquals:
        return opNotEquals(left, right, holder);
      case FpOperation.NotEquivalent:
        return opNotEquivalent(left, right, holder);
      case FpOperation.LessThan:
        return opLessThan(left, right, holder);
      case FpOperation.Greater:
        return opGreater(left, right, holder);
      case FpOperation.LessOrEqual:
        return opLessOrEqual(left, right, holder);
      case FpOperation.GreaterOrEqual:
        return opGreaterOrEqual(left, right, holder);
      case FpOperation.Union:
        return opUnion(left, right, holder);
      case FpOperation.In:
        return opIn(left, right, holder);
      case FpOperation.MemberOf:
        return opMemberOf(execContext, left, right, holder);
      case FpOperation.Contains:
        return opContains(left, right, holder);
      case FpOperation.Or:
        return opOr(left, right, holder);
      case FpOperation.And:
        return opAnd(left, right, holder);
      case FpOperation.Xor:
        return opXor(left, right, holder);
      case FpOperation.Implies:
        return opImplies(left, right, holder);
      case FpOperation.Plus:
        return opPlus(left, right, holder);
      case FpOperation.Times:
        return opTimes(left, right, holder);
      case FpOperation.Minus:
        return opMinus(left, right, holder);
      case FpOperation.Concatenate:
        return opConcatenate(left, right, holder);
      case FpOperation.DivideBy:
        return opDivideBy(left, right, holder);
      case FpOperation.Div:
        return opDiv(left, right, holder);
      case FpOperation.Mod:
        return opMod(left, right, holder);
      case FpOperation.Is:
        return opIs(left, right, holder);
      case FpOperation.As:
        return opAs(left, right, holder);
      case null:
        throw UnimplementedError();
    }
  }

  List<FhirNode> opEquals(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    if (left.length != right.length) {
      return utilities.makeBoolean(false);
    }

    var res = true;
    var nil = false;

    for (var i = 0; i < left.length; i++) {
      final eq = utilities.doEquals(left[i], right[i]);

      if (eq == null) {
        nil = true;
      } else if (!eq) {
        res = false;
        break;
      }
    }

    if (!res) {
      return utilities.makeBoolean(false);
    } else if (nil) {
      return [];
    } else {
      return utilities.makeBoolean(true);
    }
  }

  List<FhirNode> opEquivalent(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.length != right.length) {
      return utilities.makeBoolean(false);
    }

    var res = true;

    for (var i = 0; i < left.length; i++) {
      var found = false;
      for (var j = 0; j < right.length; j++) {
        if (utilities.doEquivalent(left[i], right[j]) ?? false) {
          found = true;
          break;
        }
      }
      if (!found) {
        res = false;
        break;
      }
    }

    return utilities.makeBoolean(res);
  }

  List<FhirNode> opNotEquals(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (!fpContext.legacyMode && (left.isEmpty || right.isEmpty)) {
      return [];
    }

    if (left.length != right.length) {
      return utilities.makeBoolean(true);
    }

    var res = true;
    var nil = false;
    for (var i = 0; i < left.length; i++) {
      final eq = utilities.doEquals(left[i], right[i]);
      if (eq == null) {
        nil = true;
      } else if (eq) {
        res = false;
        break;
      }
    }

    if (!res) {
      return utilities.makeBoolean(res);
    } else if (nil) {
      return [];
    } else {
      return utilities.makeBoolean(res);
    }
  }

  List<FhirNode> opNotEquivalent(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.length != right.length) {
      return utilities.makeBoolean(true);
    }

    var res = true;

    for (var i = 0; i < left.length; i++) {
      var found = false;
      for (var j = 0; j < right.length; j++) {
        if (utilities.doEquivalent(left[i], right[j]) ?? false) {
          found = true;
          break;
        }
      }
      if (!found) {
        res = false;
        break;
      }
    }

    return utilities.makeBoolean(!res);
  }

  List<FhirNode> opLessThan(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    if (left.length == 1 && right.length == 1) {
      final l = left.first;
      final r = right.first;

      if (l.isPrimitive && r.isPrimitive) {
        if (fpContext.FHIR_TYPES_STRING.contains(l.fhirType) &&
            fpContext.FHIR_TYPES_STRING.contains(r.fhirType)) {
          return utilities
              .makeBoolean(l.toString().compareTo(r.toString()) < 0);
        } else if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
          final ln = utilities.nodeNum(l);
          final rn = utilities.nodeNum(r);
          return utilities.makeBoolean(ln != null && rn != null && ln < rn);
        } else if (utilities.isDateTimeNode(l) && utilities.isDateTimeNode(r)) {
          final comparison =
              utilities.compareDateTimeNodes(l, r, TemporalComparator.lessThan);
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else if (utilities.isTimeNode(l) && utilities.isTimeNode(r)) {
          final comparison =
              utilities.compareTimeNodes(l, r, TemporalComparator.lessThan);
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANT_COMPARE',
            [l.fhirType, r.fhirType],
          );
        }
      } else if (l.fhirType == 'Quantity' && r.fhirType == 'Quantity') {
        var lUnit = l.getChildrenByName('code');
        if (lUnit.isEmpty) {
          lUnit = l.getChildrenByName('unit');
        }
        var rUnit = r.getChildrenByName('code');
        if (rUnit.isEmpty) {
          rUnit = r.getChildrenByName('unit');
        }
        if (utilities.deepEqualLists(lUnit, rUnit, true)) {
          return opLessThan(
            l.getChildrenByName('value'),
            r.getChildrenByName('value'),
            expr,
          );
        } else {
          final lQuantity = utilities.qtyToCanonicalDecimal(l);
          final rQuantity = utilities.qtyToCanonicalDecimal(r);
          final dl = lQuantity == null ? <FhirNode>[] : [lQuantity];
          final dr = rQuantity == null ? <FhirNode>[] : [rQuantity];
          return opLessThan(dl, dr, expr);
        }
      }
    }
    return [];
  }

  List<FhirNode> opGreater(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    if (left.length == 1 && right.length == 1) {
      final l = left.first;
      final r = right.first;

      if (l.isPrimitive && r.isPrimitive) {
        if (fpContext.FHIR_TYPES_STRING.contains(l.fhirType) &&
            fpContext.FHIR_TYPES_STRING.contains(r.fhirType)) {
          return utilities
              .makeBoolean(l.toString().compareTo(r.toString()) > 0);
        } else if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
          final ln = utilities.nodeNum(l);
          final rn = utilities.nodeNum(r);
          return utilities.makeBoolean(ln != null && rn != null && ln > rn);
        } else if (utilities.isDateTimeNode(l) && utilities.isDateTimeNode(r)) {
          final comparison = utilities.compareDateTimeNodes(
            l,
            r,
            TemporalComparator.greaterThan,
          );
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else if (utilities.isTimeNode(l) && utilities.isTimeNode(r)) {
          final comparison =
              utilities.compareTimeNodes(l, r, TemporalComparator.greaterThan);

          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANT_COMPARE',
            [l.fhirType, r.fhirType],
          );
        }
      } else if (l.fhirType == 'Quantity' && r.fhirType == 'Quantity') {
        var lUnit = l.getChildrenByName('code');
        if (lUnit.isEmpty) {
          lUnit = l.getChildrenByName('unit');
        }
        var rUnit = r.getChildrenByName('code');
        if (rUnit.isEmpty) {
          rUnit = r.getChildrenByName('unit');
        }
        if (utilities.deepEqualLists(lUnit, rUnit, true)) {
          return opGreater(
            l.getChildrenByName('value'),
            r.getChildrenByName('value'),
            expr,
          );
        } else {
          final lQuantity = utilities.qtyToCanonicalDecimal(l);
          final rQuantity = utilities.qtyToCanonicalDecimal(r);
          final dl = lQuantity == null ? <FhirNode>[] : [lQuantity];
          final dr = rQuantity == null ? <FhirNode>[] : [rQuantity];
          return opGreater(dl, dr, expr);
        }
      }
    }
    return [];
  }

  List<FhirNode> opLessOrEqual(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    if (left.length == 1 && right.length == 1) {
      final l = left.first;
      final r = right.first;

      if (l.isPrimitive && r.isPrimitive) {
        if (fpContext.FHIR_TYPES_STRING.contains(l.fhirType) &&
            fpContext.FHIR_TYPES_STRING.contains(r.fhirType)) {
          return utilities
              .makeBoolean(l.toString().compareTo(r.toString()) <= 0);
        } else if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
          final ln = utilities.nodeNum(l);
          final rn = utilities.nodeNum(r);
          return utilities.makeBoolean(ln != null && rn != null && ln <= rn);
        } else if (utilities.isDateTimeNode(l) && utilities.isDateTimeNode(r)) {
          final comparison = utilities.compareDateTimeNodes(
            l,
            r,
            TemporalComparator.lessThanEqual,
          );
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else if (utilities.isTimeNode(l) && utilities.isTimeNode(r)) {
          final comparison = utilities.compareTimeNodes(
            l,
            r,
            TemporalComparator.lessThanEqual,
          );
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANT_COMPARE',
            [l.fhirType, r.fhirType],
          );
        }
      } else if (l.fhirType == 'Quantity' && r.fhirType == 'Quantity') {
        var lUnit = l.getChildrenByName('code');
        if (lUnit.isEmpty) {
          lUnit = l.getChildrenByName('unit');
        }
        var rUnit = r.getChildrenByName('code');
        if (rUnit.isEmpty) {
          rUnit = r.getChildrenByName('unit');
        }
        if (utilities.deepEqualLists(lUnit, rUnit, true)) {
          return opLessOrEqual(
            l.getChildrenByName('value'),
            r.getChildrenByName('value'),
            expr,
          );
        } else {
          final lQuantity = utilities.qtyToCanonicalDecimal(l);
          final rQuantity = utilities.qtyToCanonicalDecimal(r);
          final dl = lQuantity == null ? <FhirNode>[] : [lQuantity];
          final dr = rQuantity == null ? <FhirNode>[] : [rQuantity];
          return opLessOrEqual(dl, dr, expr);
        }
      }
    }
    return [];
  }

  List<FhirNode> opGreaterOrEqual(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    if (left.length == 1 && right.length == 1) {
      final l = left.first;
      final r = right.first;

      if (l.isPrimitive && r.isPrimitive) {
        if (fpContext.FHIR_TYPES_STRING.contains(l.fhirType) &&
            fpContext.FHIR_TYPES_STRING.contains(r.fhirType)) {
          return utilities
              .makeBoolean(l.toString().compareTo(r.toString()) >= 0);
        } else if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
          final ln = utilities.nodeNum(l);
          final rn = utilities.nodeNum(r);
          return utilities.makeBoolean(ln != null && rn != null && ln >= rn);
        } else if (utilities.isDateTimeNode(l) && utilities.isDateTimeNode(r)) {
          final comparison = utilities.compareDateTimeNodes(
            l,
            r,
            TemporalComparator.greaterThanEqual,
          );
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else if (utilities.isTimeNode(l) && utilities.isTimeNode(r)) {
          final comparison = utilities.compareTimeNodes(
            l,
            r,
            TemporalComparator.greaterThanEqual,
          );
          return comparison == null
              ? <FhirNode>[]
              : utilities.makeBoolean(comparison);
        } else {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANT_COMPARE',
            [l.fhirType, r.fhirType],
          );
        }
      } else if (l.fhirType == 'Quantity' && r.fhirType == 'Quantity') {
        var lUnit = l.getChildrenByName('code');
        if (lUnit.isEmpty) {
          lUnit = l.getChildrenByName('unit');
        }
        var rUnit = r.getChildrenByName('code');
        if (rUnit.isEmpty) {
          rUnit = r.getChildrenByName('unit');
        }
        if (utilities.deepEqualLists(lUnit, rUnit, true)) {
          return opGreaterOrEqual(
            l.getChildrenByName('value'),
            r.getChildrenByName('value'),
            expr,
          );
        } else {
          final lQuantity = utilities.qtyToCanonicalDecimal(l);
          final rQuantity = utilities.qtyToCanonicalDecimal(r);
          final dl = lQuantity == null ? <FhirNode>[] : [lQuantity];
          final dr = rQuantity == null ? <FhirNode>[] : [rQuantity];
          return opGreaterOrEqual(dl, dr, expr);
        }
      }
    }
    return [];
  }

  List<FhirNode> opUnion(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    final result = <FhirNode>[];
    for (final item in left) {
      if (!utilities.doContains(result, item)) {
        result.add(item);
      }
    }
    for (final item in right) {
      if (!utilities.doContains(result, item)) {
        result.add(item);
      }
    }
    return result;
  }

  List<FhirNode> opIn(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty) {
      return [];
    }
    if (right.isEmpty) {
      return utilities.makeBoolean(false);
    }

    var ans = true;
    for (final l in left) {
      var found = false;
      for (final r in right) {
        final eq = utilities.doEquals(l, r);
        if (eq ?? false) {
          found = true;
          break;
        }
      }
      if (!found) {
        ans = false;
        break;
      }
    }
    return utilities.makeBoolean(ans);
  }

  Future<List<FhirNode>> opMemberOf(
    ExecutionContext execContext,
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) async {
    var ans = false;
    final url = right.first.primitiveValue.toString();
    final vs = fpContext.hostServices != null
        ? fpContext.hostServices!
            .resolveValueSet(engine, execContext.appInfo, url)
        : await fpContext.worker.fetchValueSet(url);

    if (vs == null) {
      // Same rule as the function form: "If the valueset cannot be resolved as
      // a uri to a value set, an error is thrown." Answering `false` says the
      // code is not in the set, when what happened is that nobody could look.
      throw PathEngineException(
        'Unable to resolve value set $url',
        location: expr.start,
        expression: expr.toString(),
      );
    }

    // Membership in the value set is the whole question — see `funcMemberOf`
    // for why the wider "and valid in its code system" reading answers `false`
    // offline for a code the value set plainly lists.
    final options = fpContext.terminologyServiceOptions.withCheckValueSetOnly();

    for (final l in left) {
      if (['code', 'string', 'uri'].contains(l.fhirType)) {
        final result = await fpContext.worker.validateCodeForCodingValue(
          options.withGuessSystem(),
          l,
          vs,
        );
        if (result.isOk) {
          ans = true;
        }
      } else if (l.fhirType == 'Coding') {
        final result = await fpContext.worker.validateCodeForCodingValue(
          options,
          l,
          vs,
        );
        if (result.isOk) {
          ans = true;
        }
      } else if (l.fhirType == 'CodeableConcept') {
        final vr = await fpContext.worker.validateCodeForCodeableConceptValue(
          options,
          l,
          vs,
        );
        if (vr.isOk) {
          ans = true;
        }
      }
    }

    return utilities.makeBoolean(ans);
  }

  List<FhirNode> opContains(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }

    var ans = true;
    for (final r in right) {
      var found = false;
      for (final l in left) {
        final eq = utilities.doEquals(l, r);
        if (eq ?? false) {
          found = true;
          break;
        }
      }
      if (!found) {
        ans = false;
        break;
      }
    }
    return utilities.makeBoolean(ans);
  }

  List<FhirNode> opOr(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    final l = utilities.asBoolList(left, expr);
    final r = utilities.asBoolList(right, expr);
    switch (l) {
      case FpEquality.true_:
        return utilities.makeBoolean(true);
      case FpEquality.null_:
        return r == FpEquality.true_
            ? utilities.makeBoolean(true)
            : utilities.makeNull();
      case FpEquality.false_:
        switch (r) {
          case FpEquality.false_:
            return utilities.makeBoolean(false);
          case FpEquality.null_:
            return utilities.makeNull();
          case FpEquality.true_:
            return utilities.makeBoolean(true);
        }
    }
  }

  List<FhirNode> opAnd(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    final l = utilities.asBoolList(left, expr);
    final r = utilities.asBoolList(right, expr);
    switch (l) {
      case FpEquality.false_:
        return utilities.makeBoolean(false);
      case FpEquality.null_:
        return r == FpEquality.false_
            ? utilities.makeBoolean(false)
            : utilities.makeNull();
      case FpEquality.true_:
        switch (r) {
          case FpEquality.false_:
            return utilities.makeBoolean(false);
          case FpEquality.null_:
            return utilities.makeNull();
          case FpEquality.true_:
            return utilities.makeBoolean(true);
        }
    }
  }

  List<FhirNode> opXor(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    final l = utilities.asBoolList(left, expr);
    final r = utilities.asBoolList(right, expr);
    switch (l) {
      case FpEquality.true_:
        switch (r) {
          case FpEquality.false_:
            return utilities.makeBoolean(true);
          case FpEquality.true_:
            return utilities.makeBoolean(false);
          case FpEquality.null_:
            return utilities.makeNull();
        }
      case FpEquality.null_:
        return utilities.makeNull();
      case FpEquality.false_:
        switch (r) {
          case FpEquality.false_:
            return utilities.makeBoolean(false);
          case FpEquality.true_:
            return utilities.makeBoolean(true);
          case FpEquality.null_:
            return utilities.makeNull();
        }
    }
  }

  List<FhirNode> opImplies(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    final eq = utilities.asBoolList(left, expr);
    if (eq == FpEquality.false_) {
      return utilities.makeBoolean(true);
    } else if (right.isEmpty) {
      return utilities.makeNull();
    } else {
      switch (utilities.asBoolList(right, expr)) {
        case FpEquality.false_:
          return eq == FpEquality.null_
              ? utilities.makeNull()
              : utilities.makeBoolean(false);
        case FpEquality.null_:
          return utilities.makeNull();
        case FpEquality.true_:
          return utilities.makeBoolean(true);
      }
    }
  }

  List<FhirNode> opPlus(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext.makeExceptionPlural(
        left.length,
        expr,
        'FHIRPATH_LEFT_VALUE',
        ['+'],
      );
    }
    if (!left.first.isPrimitive) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_LEFT_VALUE_WRONG_TYPE',
        ['+', left.first.fhirType],
      );
    }
    if (right.length > 1) {
      throw fpContext.makeExceptionPlural(
        right.length,
        expr,
        'FHIRPATH_RIGHT_VALUE',
        ['+'],
      );
    }
    if (!right.first.isPrimitive &&
        !((utilities.isQuantityNode(left.first) &&
                utilities.isQuantityNode(right.first)) ||
            (utilities.isDateTimeNode(left.first) &&
                utilities.isQuantityNode(right.first)))) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_RIGHT_VALUE_WRONG_TYPE',
        ['+', right.first.fhirType],
      );
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;

    if (fpContext.FHIR_TYPES_STRING.contains(l.fhirType) &&
        fpContext.FHIR_TYPES_STRING.contains(r.fhirType)) {
      result.add(
        fpContext.factory.string(
          '${l.primitiveValue}${r.primitiveValue}',
          disallowExtensions: false,
        ),
      );
    } else if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      result.add(
        utilities.numericResult(
          utilities.nodeNum(l)! + utilities.nodeNum(r)!,
          l,
          r,
        ),
      );
    } else if (utilities.isDateTimeNode(l) && utilities.isQuantityNode(r)) {
      result.add(utilities.dateAdd(l, r, false, expr));
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_OP_INCOMPATIBLE',
        ['+', l.fhirType, r.fhirType],
      );
    }

    return result;
  }

  List<FhirNode> opTimes(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext.makeExceptionPlural(
        left.length,
        expr,
        'FHIRPATH_LEFT_VALUE',
        ['*'],
      );
    }
    if (!left.first.isPrimitive && left.first.fhirType != 'Quantity') {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_LEFT_VALUE_WRONG_TYPE',
        ['*', left.first.fhirType],
      );
    }
    if (right.length > 1) {
      throw fpContext.makeExceptionPlural(
        right.length,
        expr,
        'FHIRPATH_RIGHT_VALUE',
        ['*'],
      );
    }
    if (!right.first.isPrimitive && right.first.fhirType != 'Quantity') {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_RIGHT_VALUE_WRONG_TYPE',
        ['*', right.first.fhirType],
      );
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;

    if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      result.add(
        utilities.numericResult(
          utilities.nodeNum(l)! * utilities.nodeNum(r)!,
          l,
          r,
        ),
      );
    } else if (utilities.isQuantityNode(l) && utilities.isQuantityNode(r)) {
      final pl = utilities.qtyToPair(l);
      final pr = utilities.qtyToPair(r);
      if (pl != null && pr != null) {
        try {
          final p = fpContext.worker.ucumService.multiply(pl, pr);
          result.add(utilities.pairToQty(p));
        } catch (e) {
          throw PathEngineException(
            e.toString(),
            location: expr.opStart,
            expression: expr.toString(),
          );
        }
      }
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_OP_INCOMPATIBLE',
        ['*', l.fhirType, r.fhirType],
      );
    }

    return result;
  }

  Future<List<FhirNode>> opMinus(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) async {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext.makeExceptionPlural(
        left.length,
        expr,
        'FHIRPATH_LEFT_VALUE',
        ['-'],
      );
    }
    // Subtype-aware, like the Java reference's `instanceof Quantity`
    // (Age/Duration/... derive from Quantity).
    if (!left.first.isPrimitive &&
        !(await fpContext.worker
            .isSubtypeOf(left.first.fhirType, 'Quantity'))) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_LEFT_VALUE_WRONG_TYPE',
        ['-', left.first.fhirType],
      );
    }
    if (right.length > 1) {
      throw fpContext.makeExceptionPlural(
        right.length,
        expr,
        'FHIRPATH_RIGHT_VALUE',
        ['-'],
      );
    }
    if (!right.first.isPrimitive &&
        !((utilities.isDateTimeNode(left.first) ||
                left.first.toString() == '0' ||
                utilities.isQuantityNode(left.first)) &&
            utilities.isQuantityNode(right.first))) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_RIGHT_VALUE_WRONG_TYPE',
        ['-', right.first.fhirType],
      );
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;

    if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      result.add(
        utilities.numericResult(
          utilities.nodeNum(l)! - utilities.nodeNum(r)!,
          l,
          r,
        ),
      );
    } else if ((utilities.isNumericNode(l) || utilities.isQuantityNode(l)) &&
        utilities.isQuantityNode(r)) {
      if (l.toString() == '0') {
        result.add(
          fpContext.factory.quantityWithValue(r, utilities.qtyValue(r)?.abs()),
        );
      }
    } else if (utilities.isDateTimeNode(l) && utilities.isQuantityNode(r)) {
      result.add(utilities.dateAdd(l, r, true, expr));
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_OP_INCOMPATIBLE',
        ['-', l.fhirType, r.fhirType],
      );
    }

    return result;
  }

  List<FhirNode> opConcatenate(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.length > 1) {
      throw fpContext.makeExceptionPlural(
        left.length,
        expr,
        'FHIRPATH_LEFT_VALUE',
        ['&'],
      );
    }
    if (left.isNotEmpty &&
        !fpContext.FHIR_TYPES_STRING.contains(left.first.fhirType)) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_LEFT_VALUE_WRONG_TYPE',
        ['&', left.first.fhirType],
      );
    }
    if (right.length > 1) {
      throw fpContext.makeExceptionPlural(
        right.length,
        expr,
        'FHIRPATH_RIGHT_VALUE',
        ['&'],
      );
    }
    if (right.isNotEmpty &&
        !fpContext.FHIR_TYPES_STRING.contains(right.first.fhirType)) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_RIGHT_VALUE_WRONG_TYPE',
        ['&', right.first.fhirType],
      );
    }

    final result = <FhirNode>[];
    final l = left.isEmpty ? '' : left.first.primitiveValue.toString();
    final r = right.isEmpty ? '' : right.first.primitiveValue.toString();
    result.add(fpContext.factory.string('$l$r', disallowExtensions: false));

    return result;
  }

  List<FhirNode> opDivideBy(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext.makeExceptionPlural(
        left.length,
        expr,
        'FHIRPATH_LEFT_VALUE',
        ['/'],
      );
    }
    if (!left.first.isPrimitive && left.first.fhirType != 'Quantity') {
      throw fpContext.makeException(expr, 'FHIRPATH_LEFT_VALUE_WRONG_TYPE', [
        '/',
        left.first.fhirType,
      ]);
    }
    if (right.length > 1) {
      throw fpContext
          .makeExceptionPlural(right.length, expr, 'FHIRPATH_RIGHT_VALUE', [
        '/',
      ]);
    }
    if (!right.first.isPrimitive && right.first.fhirType != 'Quantity') {
      throw fpContext.makeException(expr, 'FHIRPATH_RIGHT_VALUE_WRONG_TYPE', [
        '/',
        right.first.fhirType,
      ]);
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;

    if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      try {
        final ln = utilities.nodeNum(l);
        final rn = utilities.nodeNum(r);
        if (ln == null || rn == null || rn == 0) {
          return <FhirNode>[];
        }
        // FHIRPath division always yields a decimal.
        result
            .add(fpContext.factory.decimal(ln / rn, disallowExtensions: false));
      } catch (e) {
        return <FhirNode>[];
      }
    } else if (utilities.isQuantityNode(l) && utilities.isQuantityNode(r)) {
      final pl = utilities.qtyToPair(l);
      final pr = utilities.qtyToPair(r);
      if (pl != null && pr != null) {
        final p = fpContext.worker.ucumService.divideBy(pl, pr);

        result.add(utilities.pairToQty(p));
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_OP_INCOMPATIBLE', [
        '/',
        l.fhirType,
        r.fhirType,
      ]);
    }

    return result;
  }

  List<FhirNode> opDiv(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext
          .makeExceptionPlural(left.length, expr, 'FHIRPATH_LEFT_VALUE', [
        'div',
      ]);
    }
    if (!left.first.isPrimitive && left.first.fhirType != 'Quantity') {
      throw fpContext.makeException(expr, 'FHIRPATH_LEFT_VALUE_WRONG_TYPE', [
        'div',
        left.first.fhirType,
      ]);
    }
    if (right.length > 1) {
      throw fpContext
          .makeExceptionPlural(right.length, expr, 'FHIRPATH_RIGHT_VALUE', [
        'div',
      ]);
    }
    if (!right.first.isPrimitive && right.first.fhirType != 'Quantity') {
      throw fpContext.makeException(expr, 'FHIRPATH_RIGHT_VALUE_WRONG_TYPE', [
        'div',
        right.first.fhirType,
      ]);
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;

    if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      final ln = utilities.nodeNum(l);
      final rn = utilities.nodeNum(r);
      // Integer (truncating) division; empty when the divisor is zero.
      if (ln != null && rn != null && rn != 0) {
        result.add(utilities.numericResult(ln ~/ rn, l, r));
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_OP_INCOMPATIBLE', [
        'div',
        l.fhirType,
        r.fhirType,
      ]);
    }

    return result;
  }

  List<FhirNode> opMod(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) {
    if (left.isEmpty || right.isEmpty) {
      return [];
    }
    if (left.length > 1) {
      throw fpContext
          .makeExceptionPlural(left.length, expr, 'FHIRPATH_LEFT_VALUE', [
        'mod',
      ]);
    }
    if (!left.first.isPrimitive) {
      throw fpContext.makeException(expr, 'FHIRPATH_LEFT_VALUE_WRONG_TYPE', [
        'mod',
        left.first.fhirType,
      ]);
    }
    if (right.length > 1) {
      throw fpContext
          .makeExceptionPlural(right.length, expr, 'FHIRPATH_RIGHT_VALUE', [
        'mod',
      ]);
    }
    if (!right.first.isPrimitive) {
      throw fpContext.makeException(expr, 'FHIRPATH_RIGHT_VALUE_WRONG_TYPE', [
        'mod',
        right.first.fhirType,
      ]);
    }

    final result = <FhirNode>[];
    final l = left.first;
    final r = right.first;
    if (utilities.isNumericNode(l) && utilities.isNumericNode(r)) {
      final ln = utilities.nodeNum(l);
      final rn = utilities.nodeNum(r);
      // Empty when the divisor is zero (avoids a division-by-zero throw).
      if (ln != null && rn != null && rn != 0) {
        result.add(utilities.numericResult(ln % rn, l, r));
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_OP_INCOMPATIBLE', [
        'mod',
        l.fhirType,
        r.fhirType,
      ]);
    }

    return result;
  }

  Future<List<FhirNode>> opIs(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) async {
    final result = <FhirNode>[];
    if (left.isEmpty || right.isEmpty) {
      // No operation needed for empty lists
    } else if (left.length != 1 || right.length != 1) {
      result.add(fpContext.factory.boolean(false));
    } else {
      var tn = utilities.convertListToString(right);
      // Handle .not() syntax: System.Quantity.not() means "not System.Quantity"
      var negate = false;
      if (tn.endsWith('.not()')) {
        tn = tn.substring(0, tn.length - 6); // Remove '.not()'
        negate = true;
      }
      // `x is T` is equivalent to `x.is(T)` (FHIRPath spec §6.3), so the
      // operator resolves the specifier's namespace the same way and shares
      // the one type-membership predicate with the function form.
      final (ns, name) = utilities.resolveTypeSpecifier(tn);
      final matches =
          await fpContext.worker.isValueOfType(left.first, ns, name);
      result.add(fpContext.factory.boolean(negate ? !matches : matches));
    }

    return result;
  }

  Future<List<FhirNode>> opAs(
    List<FhirNode> left,
    List<FhirNode> right,
    ExpressionNode expr,
  ) async {
    final result = <FhirNode>[];
    if (right.length != 1) {
      return result;
    }

    final tn = utilities.convertListToString(right);

    if (!(await utilities.isKnownType(tn))) {
      throw PathEngineException('The type $tn is not valid');
    }
    if (!fpContext.doNotEnforceAsSingletonRule && left.length > 1) {
      throw PathEngineException(
        'Attempt to use "as" on more than one item (${left.length}, "$expr")',
      );
    }

    for (final nextLeft in left) {
      if (utilities.compareTypeNames(tn, nextLeft.fhirType)) {
        result.add(nextLeft);
      }
    }
    return result;
  }
}
