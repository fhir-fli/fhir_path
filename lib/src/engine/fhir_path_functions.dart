// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:math';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';
import 'package:fhir_path/src/utils/path_string_extensions.dart';

/// Internal functions class for FHIRPath engine.
///
/// Handles all FHIRPath functions (empty(), not(), exists(), where(),
/// select(), etc.)
class FhirPathFunctions {
  FhirPathFunctions(
    this.fpContext,
    this.utilities,
    this.operations,
    this.engine,
  );

  final FhirPathContext fpContext;
  final FhirPathUtilities utilities;
  final FhirPathOperations operations;
  final FHIRPathEngine engine;

  /// FUNCTIONS
  /// ***************************************
  ///
  Future<List<FhirNode>> evaluateFunction(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    switch (exp.function) {
      case FpFunction.Empty:
        return funcEmpty(execContext, focus, exp);
      case FpFunction.Not:
        return funcNot(execContext, focus, exp);
      case FpFunction.Exists:
        return funcExists(execContext, focus, exp);
      case FpFunction.SubsetOf:
        return funcSubsetOf(execContext, focus, exp);
      case FpFunction.SupersetOf:
        return funcSupersetOf(execContext, focus, exp);
      case FpFunction.IsDistinct:
        return funcIsDistinct(execContext, focus, exp);
      case FpFunction.Distinct:
        return funcDistinct(execContext, focus, exp);
      case FpFunction.Count:
        return funcCount(execContext, focus, exp);
      case FpFunction.Where:
        return funcWhere(execContext, focus, exp);
      case FpFunction.Select:
        return funcSelect(execContext, focus, exp);
      case FpFunction.All:
        return funcAll(execContext, focus, exp);
      case FpFunction.Repeat:
        return funcRepeat(execContext, focus, exp);
      case FpFunction.Aggregate:
        return funcAggregate(execContext, focus, exp);
      case FpFunction.Sort:
        return funcSort(execContext, focus, exp);
      case FpFunction.Item:
        return funcItem(execContext, focus, exp);
      case FpFunction.As:
        return funcAs(execContext, focus, exp);
      case FpFunction.OfType:
        return funcOfType(execContext, focus, exp);
      case FpFunction.Type:
        return funcType(execContext, focus, exp);
      case FpFunction.Is:
        return funcIs(execContext, focus, exp);
      case FpFunction.Single:
        return funcSingle(execContext, focus, exp);
      case FpFunction.First:
        return funcFirst(execContext, focus, exp);
      case FpFunction.Last:
        return funcLast(execContext, focus, exp);
      case FpFunction.Tail:
        return funcTail(execContext, focus, exp);
      case FpFunction.Skip:
        return funcSkip(execContext, focus, exp);
      case FpFunction.Take:
        return funcTake(execContext, focus, exp);
      case FpFunction.Union:
        return funcUnion(execContext, focus, exp);
      case FpFunction.Combine:
        return funcCombine(execContext, focus, exp);
      case FpFunction.Intersect:
        return funcIntersect(execContext, focus, exp);
      case FpFunction.Exclude:
        return funcExclude(execContext, focus, exp);
      case FpFunction.Iif:
        return funcIif(execContext, focus, exp);
      case FpFunction.Lower:
        return funcLower(execContext, focus, exp);
      case FpFunction.Upper:
        return funcUpper(execContext, focus, exp);
      case FpFunction.ToChars:
        return funcToChars(execContext, focus, exp);
      case FpFunction.IndexOf:
        return funcIndexOf(execContext, focus, exp);
      case FpFunction.Substring:
        return funcSubstring(execContext, focus, exp);
      case FpFunction.StartsWith:
        return funcStartsWith(execContext, focus, exp);
      case FpFunction.EndsWith:
        return funcEndsWith(execContext, focus, exp);
      case FpFunction.Matches:
        return funcMatches(execContext, focus, exp);
      case FpFunction.MatchesFull:
        return funcMatchesFull(execContext, focus, exp);
      case FpFunction.ReplaceMatches:
        return funcReplaceMatches(execContext, focus, exp);
      case FpFunction.Contains:
        return funcContains(execContext, focus, exp);
      case FpFunction.Replace:
        return funcReplace(execContext, focus, exp);
      case FpFunction.Length:
        return funcLength(execContext, focus, exp);
      case FpFunction.Children:
        return funcChildren(execContext, focus, exp);
      case FpFunction.Descendants:
        return funcDescendants(execContext, focus, exp);
      case FpFunction.MemberOf:
        return funcMemberOf(execContext, focus, exp);
      case FpFunction.Trace:
        return funcTrace(execContext, focus, exp);
      case FpFunction.DefineVariable:
        return funcDefineVariable(execContext, focus, exp);
      case FpFunction.Check:
        return funcCheck(execContext, focus, exp);
      case FpFunction.Today:
        return funcToday(execContext, focus, exp);
      case FpFunction.Now:
        return funcNow(execContext, focus, exp);
      case FpFunction.TimeOfDay:
        return funcTimeOfDay(execContext, focus, exp);
      case FpFunction.Resolve:
        return funcResolve(execContext, focus, exp);
      case FpFunction.Extension:
        return funcExtension(execContext, focus, exp);
      case FpFunction.AnyFalse:
        return funcAnyFalse(execContext, focus, exp);
      case FpFunction.AllFalse:
        return funcAllFalse(execContext, focus, exp);
      case FpFunction.AnyTrue:
        return funcAnyTrue(execContext, focus, exp);
      case FpFunction.AllTrue:
        return funcAllTrue(execContext, focus, exp);
      case FpFunction.HasValue:
        return funcHasValue(execContext, focus, exp);
      case FpFunction.Encode:
        return funcEncode(execContext, focus, exp);
      case FpFunction.Decode:
        return funcDecode(execContext, focus, exp);
      case FpFunction.Escape:
        return funcEscape(execContext, focus, exp);
      case FpFunction.Unescape:
        return funcUnescape(execContext, focus, exp);
      case FpFunction.Trim:
        return funcTrim(execContext, focus, exp);
      case FpFunction.Split:
        return funcSplit(execContext, focus, exp);
      case FpFunction.Join:
        return funcJoin(execContext, focus, exp);
      case FpFunction.HtmlChecks1:
        return funcHtmlChecks1(execContext, focus, exp);
      case FpFunction.HtmlChecks2:
        return funcHtmlChecks2(execContext, focus, exp);
      case FpFunction.Comparable:
        return funcComparable(execContext, focus, exp);
      case FpFunction.ToInteger:
        return funcToInteger(execContext, focus, exp);
      case FpFunction.ToDecimal:
        return funcToDecimal(execContext, focus, exp);
      case FpFunction.ToString:
        return funcToString(execContext, focus, exp);
      case FpFunction.ToBoolean:
        return funcToBoolean(execContext, focus, exp);
      case FpFunction.ToQuantity:
        return funcToQuantity(execContext, focus, exp);
      case FpFunction.ToDateTime:
        return funcToDateTime(execContext, focus, exp);
      case FpFunction.ToDate:
        return funcToDate(execContext, focus, exp);
      case FpFunction.ToTime:
        return funcToTime(execContext, focus, exp);
      case FpFunction.IsInteger:
        return operations.opIs(
          focus,
          [fpContext.factory.string('integer', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToInteger:
        return funcIsInteger(focus);
      case FpFunction.IsDecimal:
        return operations.opIs(
          focus,
          [fpContext.factory.string('decimal', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToDecimal:
        return funcIsDecimal(execContext, focus, exp);
      case FpFunction.IsString:
        return operations.opIs(
          focus,
          [fpContext.factory.string('string', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToString:
        return funcIsString(focus);
      case FpFunction.IsBoolean:
        return operations.opIs(
          focus,
          [fpContext.factory.string('boolean', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToBoolean:
        return funcIsBoolean(focus);
      case FpFunction.IsQuantity:
        return operations.opIs(
          focus,
          [fpContext.factory.string('Quantity', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToQuantity:
        return funcIsQuantity(focus);
      case FpFunction.IsDateTime:
        return operations.opIs(
          focus,
          [fpContext.factory.string('dateTime', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToDateTime:
        return funcIsDateTime(focus);
      case FpFunction.IsDate:
        return operations.opIs(
          focus,
          [fpContext.factory.string('date', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToDate:
        return funcIsDate(focus);
      case FpFunction.IsTime:
        return operations.opIs(
          focus,
          [fpContext.factory.string('time', disallowExtensions: false)],
          exp,
        );
      case FpFunction.ConvertsToTime:
        return funcIsTime(focus);
      case FpFunction.ConformsTo:
        return funcConformsTo(execContext, focus, exp);
      case FpFunction.Round:
        return funcRound(execContext, focus, exp);
      case FpFunction.Sqrt:
        return funcSqrt(execContext, focus, exp);
      case FpFunction.Abs:
        return funcAbs(execContext, focus, exp);
      case FpFunction.Ceiling:
        return funcCeiling(execContext, focus, exp);
      case FpFunction.Exp:
        return funcExp(execContext, focus, exp);
      case FpFunction.Floor:
        return funcFloor(execContext, focus, exp);
      case FpFunction.Ln:
        return funcLn(execContext, focus, exp);
      case FpFunction.Log:
        return funcLog(execContext, focus, exp);
      case FpFunction.Power:
        return funcPower(execContext, focus, exp);
      case FpFunction.Sum:
        return funcSum(execContext, focus, exp);
      case FpFunction.Truncate:
        return funcTruncate(execContext, focus, exp);
      case FpFunction.LowBoundary:
        return funcLowBoundary(execContext, focus, exp);
      case FpFunction.HighBoundary:
        return funcHighBoundary(execContext, focus, exp);
      case FpFunction.Precision:
        return funcPrecision(execContext, focus, exp);
      case FpFunction.Custom:
        {
          final params = <List<FhirNode>>[];
          for (final p in exp.parameters) {
            params.add(await engine.execute(execContext, focus, p, true));
          }
          return fpContext.hostServices?.executeFunction(
                engine,
                execContext.appInfo,
                focus,
                exp.name,
                params,
              ) ??
              <FhirNode>[];
        }
      case null:
      case FpFunction.HasTemplateIdOf:
        throw UnimplementedError();
    }
  }

  List<FhirNode> funcEmpty(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return [fpContext.factory.boolean(focus.isEmpty)];
  }

  List<FhirNode> funcNot(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    final v = utilities.asBoolList(focus, exp);

    if (v != FpEquality.null_) {
      result.add(
        fpContext.factory
            .boolean(v != FpEquality.true_, disallowExtensions: false),
      );
    }

    return result;
  }

  Future<List<FhirNode>> funcExists(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    var empty = true;
    final pc = <FhirNode>[];

    for (final f in focus) {
      if (exp.parameters.length == 1) {
        pc
          ..clear()
          ..add(f);
        final v = utilities.asBoolList(
          await engine.execute(
            execContext.changeThis(f, fpContext.worker),
            pc,
            exp.parameters[0],
            true,
          ),
          exp,
        );
        if (v == FpEquality.true_) {
          empty = false;
        }
      } else if (!f.isEmpty()) {
        empty = false;
      }
    }

    return [fpContext.factory.boolean(!empty)];
  }

  Future<List<FhirNode>> funcSubsetOf(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final target = await engine.execute(
      execContext,
      execContext.focusResource == null ? focus : [execContext.focusResource!],
      exp.parameters[0],
      true,
    );
    var valid = true;
    for (final item in focus) {
      var found = false;
      for (final t in target) {
        if (utilities.deepEqual(item, t)) {
          found = true;
          break;
        }
      }
      if (!found) {
        valid = false;
        break;
      }
    }

    return [fpContext.factory.boolean(valid)];
  }

  List<FhirNode> funcIsDistinct(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.isEmpty) {
      return utilities.makeBoolean(true);
    }
    if (focus.length == 1) {
      return utilities.makeBoolean(true);
    }

    var distinct = true;
    for (var i = 0; i < focus.length; i++) {
      for (var j = i + 1; j < focus.length; j++) {
        final eq = utilities.doEquals(focus[j], focus[i]);
        if (eq == null) {
          return [];
        } else if (eq) {
          distinct = false;
          break;
        }
      }
    }
    return utilities.makeBoolean(distinct);
  }

  List<FhirNode> funcDistinct(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.length <= 1) {
      return focus;
    }

    final result = <FhirNode>[];

    for (var i = 0; i < focus.length; i++) {
      var found = false;

      for (var j = i + 1; j < focus.length; j++) {
        final eq = utilities.doEquals(focus[j], focus[i]);
        if (eq == null) return <FhirNode>[];
        if (eq) {
          found = true;
          break;
        }
      }

      if (!found) {
        result.add(focus[i]);
      }
    }
    return result;
  }

  List<FhirNode> funcCount(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return [fpContext.factory.integer(focus.length)];
  }

  Future<List<FhirNode>> funcWhere(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final pc = <FhirNode>[];
    for (final item in focus) {
      pc
        ..clear()
        ..add(item);
      if (exp.parameters.isEmpty) {
        throw PathEngineException(
          'Where function must have at least one parameter',
        );
      }
      final v = utilities.asBoolList(
        await engine.execute(
          changeThisExecutionContext(execContext, item),
          pc,
          exp.parameters.first,
          true,
        ),
        exp,
      );
      if (v == FpEquality.true_) {
        result.add(item);
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcSelect(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final pc = <FhirNode>[];

    for (var i = 0; i < focus.length; i++) {
      final item = focus[i];
      pc
        ..clear()
        ..add(item);
      result.addAll(
        await engine.execute(
          execContext.changeThis(item, fpContext.worker)..index = i,
          pc,
          exp.parameters[0],
          true,
        ),
      );
    }
    return result;
  }

  Future<List<FhirNode>> funcAll(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    if (exp.parameters.length == 1) {
      final pc = <FhirNode>[];
      var all = true;
      for (final item in focus) {
        pc
          ..clear()
          ..add(item);
        final eq = utilities.asBoolList(
          await engine.execute(
            execContext.changeThis(item, fpContext.worker),
            pc,
            exp.parameters[0],
            true,
          ),
          exp,
        );
        if (eq != FpEquality.true_) {
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    } else {
      var all = true;
      for (final item in focus) {
        final eq = utilities.asBool(item, true);
        if (eq != FpEquality.true_) {
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    }
    return result;
  }

  Future<List<FhirNode>> funcRepeat(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final current = <FhirNode>[...focus];
    final added = <FhirNode>[];
    var more = true;

    while (more) {
      added.clear();
      final pc = <FhirNode>[];

      for (final item in current) {
        pc
          ..clear()
          ..add(item);

        try {
          final ex = await engine.execute(
            execContext.changeThis(item, fpContext.worker),
            pc,
            exp.parameters.first,
            false,
          );

          added.addAll(ex);
        } catch (e) {
          if (e is PathEngineException) {
            rethrow;
          } else {
            throw PathEngineException(
              e.toString(),
              location: exp.opStart,
              expression: exp.toString(),
            );
          }
        }
      }

      more = false;
      current.clear();

      for (final b in added) {
        var isNew = true;

        for (final t in result) {
          if (b.equalsDeep(t)) {
            isNew = false;
            break;
          }
        }

        if (isNew) {
          result.add(b);
          current.add(b);
          more = true;
        }
      }
    }

    return result;
  }

  Future<List<FhirNode>> funcAggregate(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    var total = <FhirNode>[];
    if (exp.parameterCount > 1) {
      total =
          await engine.execute(execContext, focus, exp.parameters[1], false);
    }

    final pc = <FhirNode>[];
    for (final item in focus) {
      final c = execContext.changeThis(item, fpContext.worker)
        ..total = total
        ..next();
      total = await engine.execute(c, pc, exp.parameters[0], true);
    }
    return total;
  }

  Future<List<FhirNode>> funcItem(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final s = utilities.convertListToString(
      await engine.execute(execContext, focus, exp.parameters[0], true),
    );
    if (Utilities.isInteger(s) && int.parse(s) < focus.length) {
      result.add(focus[int.parse(s)]);
    }
    return result;
  }

  /// The `as()` FUNCTION form — retained by the FHIRPath spec for backwards
  /// compatibility and implemented by the Java reference (`funcAs`, identical
  /// filter logic to `ofType()`).
  Future<List<FhirNode>> funcAs(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    final result = <FhirNode>[];
    final parameter = expr.parameters[0];
    final tn = parameter.inner != null
        ? '${parameter.name}.${parameter.inner!.name}'
        : 'FHIR.${parameter.name}';

    if (!(await utilities.isKnownType(tn))) {
      throw PathEngineException('The type $tn is not valid');
    }

    if (!fpContext.doNotEnforceAsSingletonRule && focus.length > 1) {
      throw PathEngineException(
        'Attempt to use as() on more than one item (${focus.length})',
      );
    }

    for (final b in focus) {
      if (await fpContext.worker.matchesOfType(b, tn)) {
        result.add(b);
      }
    }
    return result;
  }

  /// `sort()` / `sort(key...)` — port of the Java reference
  /// `FHIRPathBaseSorter`. Each parameter is a per-item sort-key expression,
  /// optionally prefixed with unary `-` for descending. The keys are computed
  /// up front (expression evaluation is async and a Dart comparator cannot
  /// await), then compared with the reference's natural ordering.
  Future<List<FhirNode>> funcSort(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    if (focus.length <= 1) {
      return [...focus];
    }

    // Which parameters are descending (unary minus), and their key
    // expressions.
    final reversed = <bool>[];
    final keyExprs = <ExpressionNode>[];
    for (final p in exp.parameters) {
      if (p.kind == ExpressionNodeKind.unary) {
        reversed.add(true);
        keyExprs.add(p.opNext!);
      } else {
        reversed.add(false);
        keyExprs.add(p);
      }
    }

    // Precompute each item's sort keys (the item itself for a natural sort).
    final keyed = <(FhirNode, List<FhirNode?>)>[];
    for (final item in focus) {
      if (keyExprs.isEmpty) {
        keyed.add((item, [item]));
        continue;
      }
      final keys = <FhirNode?>[];
      for (final keyExpr in keyExprs) {
        final r = await engine.execute(
          changeThisExecutionContext(execContext, item),
          [item],
          keyExpr,
          true,
        );
        if (r.length > 1) {
          throw PathEngineException(
            'Multiple values while evaluating sort criterion '
            '"$keyExpr"',
          );
        }
        keys.add(r.isEmpty ? null : r.first);
      }
      keyed.add((item, keys));
    }

    keyed.sort((a, b) {
      if (keyExprs.isEmpty) {
        return _compareNatural(a.$2[0], b.$2[0], null);
      }
      for (var i = 0; i < keyExprs.length; i++) {
        final res = _compareNatural(a.$2[i], b.$2[i], keyExprs[i].toString());
        if (res != 0) {
          return reversed[i] ? -res : res;
        }
      }
      return 0;
    });
    return keyed.map((e) => e.$1).toList();
  }

  static const Set<String> _sortableTypeNames = {
    'integer', 'unsignedInt', 'positiveInt', 'decimal', 'boolean', //
    'date', 'dateTime', 'time', 'instant', //
    'string', 'code', 'url', 'uri', 'uuid', 'oid', 'canonical', 'integer64',
  };

  static const Set<String> _sortIntegerNames = {
    'integer',
    'unsignedInt',
    'positiveInt',
    'integer64',
  };

  static const Set<String> _sortDateNames = {'date', 'dateTime', 'instant'};

  static const Set<String> _sortStringNames = {
    'string',
    'code',
    'url',
    'uri',
    'uuid',
    'oid',
    'canonical',
  };

  /// Natural ordering for sort keys — verbatim port of the Java reference
  /// `FHIRPathBaseSorter.compareNatural` (including its deliberate reversed
  /// boolean comparison; a missing key sorts last).
  int _compareNatural(FhirNode? o1, FhirNode? o2, String? sorter) {
    if (o1 == null && o2 == null) {
      return 0;
    }
    if (o1 == null) {
      return 1;
    }
    if (o2 == null) {
      return -1;
    }
    if (!_sortComparableTypes(o1.fhirType, o2.fhirType)) {
      throw PathEngineException(
        sorter == null
            ? 'The types ${o1.fhirType} and ${o2.fhirType} cannot be sorted '
                'in a natural sort'
            : 'The types ${o1.fhirType} and ${o2.fhirType} cannot be sorted '
                'for the sort criterion "$sorter"',
      );
    }
    final s1 = o1.primitiveValue!;
    final s2 = o2.primitiveValue!;
    if (_sortIntegerNames.contains(o1.fhirType)) {
      return int.parse(s1).compareTo(int.parse(s2));
    } else if (o1.fhirType == 'decimal') {
      return double.parse(s1).compareTo(double.parse(s2));
    } else if (o1.fhirType == 'boolean') {
      return s2.compareTo(s1); // order is deliberately reverse
    } else {
      return s1.compareTo(s2);
    }
  }

  /// Whether two key types belong to the same sortable family — verbatim
  /// port of the Java reference `FHIRPathBaseSorter.isComparableTypes`.
  bool _sortComparableTypes(String t1, String t2) {
    if (!_sortableTypeNames.contains(t1) || !_sortableTypeNames.contains(t2)) {
      return false;
    }
    if (_sortIntegerNames.contains(t1) && _sortIntegerNames.contains(t2)) {
      return true;
    }
    if (t1 == 'boolean' && t2 == 'boolean') {
      return true;
    }
    if (t1 == 'decimal' && t2 == 'decimal') {
      return true;
    }
    if (t1 == 'time' && t2 == 'time') {
      return true;
    }
    if (_sortDateNames.contains(t1) && _sortDateNames.contains(t2)) {
      return true;
    }
    if (_sortStringNames.contains(t1) && _sortStringNames.contains(t2)) {
      return true;
    }
    return false;
  }

  Future<List<FhirNode>> funcOfType(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    final result = <FhirNode>[];
    String? tn;
    if (expr.parameters.isNotEmpty && expr.parameters.first.inner != null) {
      tn = '${expr.parameters.first.name}.${expr.parameters.first.inner!.name}';
    } else if (expr.parameters.isNotEmpty) {
      tn = 'FHIR.${expr.parameters.first.name}';
    }

    if (!(await utilities.isKnownType(tn))) {
      throw PathEngineException('The type $tn is not valid');
    }

    for (final b in focus) {
      if (await fpContext.worker.matchesOfType(b, tn!)) {
        result.add(b);
      }
    }

    return result;
  }

  Future<List<FhirNode>> funcIs(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty || focus.length > 1) {
      return utilities.makeNull();
    }

    String? ns;
    String? n;

    final texp = expr.parameters[0];
    if (texp.kind != ExpressionNodeKind.name) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_PARAM_WRONG',
        [
          texp.kind!,
          '0',
          'is',
        ],
      );
    }

    if (texp.inner != null) {
      if (texp.inner!.kind != ExpressionNodeKind.name) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_PARAM_WRONG',
          [
            texp.kind!,
            '1',
            'is',
          ],
        );
      }
      ns = texp.name;
      n = texp.inner!.name;
    } else if ([
      'Boolean',
      'Integer',
      'Decimal',
      'String',
      'DateTime',
      'Date',
      'Time',
      'SimpleTypeInfo',
      'ClassInfo',
    ].contains(texp.name)) {
      ns = 'System';
      n = texp.name;
    } else {
      ns = 'FHIR';
      n = texp.name;
    }

    // The one type-membership predicate (System-vs-FHIR namespace, System-value
    // distinction, FHIR subtype hierarchy) lives binding-side on the worker.
    return utilities.makeBoolean(
      await fpContext.worker.isValueOfType(focus.first, ns!, n!),
    );
  }

  List<FhirNode> funcSingle(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.length == 1) {
      return focus;
    } else if (focus.isEmpty) {
      return [];
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_NO_COLLECTION', [
        'single',
        focus.length,
      ]);
    }
  }

  List<FhirNode> funcFirst(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return focus.isNotEmpty ? [focus.first] : [];
  }

  List<FhirNode> funcLast(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return focus.isNotEmpty ? [focus.last] : [];
  }

  List<FhirNode> funcTail(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return focus.length > 1 ? focus.sublist(1) : [];
  }

  Future<List<FhirNode>> funcSkip(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final n1 =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final i1 = int.parse(n1.first.primitiveValue.toString());

    if (focus.length <= i1) {
      return [];
    }

    return focus.sublist(i1);
  }

  Future<List<FhirNode>> funcTake(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final n1 =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final i1 = int.parse(n1.first.primitiveValue ?? '0');

    final result = <FhirNode>[];
    for (var i = 0; i < focus.length && i < i1; i++) {
      result.add(focus[i]);
    }
    return result;
  }

  Future<List<FhirNode>> funcUnion(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    for (final item in focus) {
      if (!utilities.doContains(result, item)) {
        result.add(item);
      }
    }

    if (execContext.thisItem == null) {
      throw PathEngineException('The fpContext does not have a thisItem');
    }

    final other = exp.parameters.isEmpty
        ? <FhirNode>[]
        : await engine.execute(
            execContext,
            baseToList(execContext.thisItem!),
            exp.parameters[0],
            true,
          );

    for (final item in other) {
      if (!utilities.doContains(result, item)) {
        result.add(item);
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcCombine(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = List<FhirNode>.from(focus);
    if (execContext.thisItem == null) {
      throw PathEngineException('The fpContext does not have a thisItem');
    }

    final other = exp.parameters.isEmpty
        ? <FhirNode>[]
        : await engine.execute(
            execContext,
            baseToList(execContext.thisItem!),
            exp.parameters[0],
            true,
          );

    result.addAll(other);
    return result;
  }

  Future<List<FhirNode>> funcIntersect(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final other =
        await engine.execute(execContext, focus, exp.parameters[0], true);

    for (final item in focus) {
      if (!utilities.doContains(result, item) &&
          utilities.doContains(other, item)) {
        result.add(item);
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcExclude(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final other = await engine.execute(
      execContext,
      execContext.focusResource == null ? focus : [execContext.focusResource!],
      exp.parameters[0],
      true,
    );

    for (final item in focus) {
      if (!utilities.doContains(other, item)) {
        result.add(item);
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcIif(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    if (focus.length > 1) {
      throw fpContext.makeException(
        exp,
        'FHIRPATH_NO_COLLECTION',
        ['iif', focus.length],
      );
    }

    final n1 = await engine.execute(
      focus.isEmpty
          ? execContext
          : execContext.changeThis(focus.first, fpContext.worker),
      focus,
      exp.parameters[0],
      true,
    );

    final v = utilities.asBoolList(n1, exp);
    if (v == FpEquality.true_) {
      return engine.execute(execContext, focus, exp.parameters[1], true);
    } else if (exp.parameters.length < 3) {
      return [];
    } else {
      return engine.execute(execContext, focus, exp.parameters[2], true);
    }
  }

  List<FhirNode> funcLower(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final s = utilities.convertToString(focus.first);
      if (s.isNotEmpty) {
        result.add(fpContext.factory.string(s.toLowerCase()));
      }
    }
    return result;
  }

  List<FhirNode> funcUpper(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final s = utilities.convertToString(focus.first);
      if (s.isNotEmpty) {
        result.add(fpContext.factory.string(s.toUpperCase()));
      }
    }
    return result;
  }

  List<FhirNode> funcToChars(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final s = utilities.convertToString(focus.first);
      for (final c in s.split('')) {
        result.add(fpContext.factory.string(c));
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcIndexOf(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final swb =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final sw = utilities.convertListToString(swb);

    if (focus.isEmpty || swb.isEmpty) {
      // Empty focus or empty parameter propagates to an empty result
      // (Java reference funcIndexOf; official testIndexOf4-6).
    } else if (sw.isEmpty) {
      result.add(fpContext.factory.integer(0));
    } else if (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
        fpContext.doImplicitStringConversion) {
      final s = utilities.convertToString(focus.first);
      result.add(fpContext.factory.integer(s.indexOf(sw)));
    }
    return result;
  }

  Future<List<FhirNode>> funcSubstring(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final n1 =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final i1 = int.parse(n1.first.primitiveValue ?? '0');
    var i2 = -1;

    if (exp.parameterCount == 2) {
      final n2 =
          await engine.execute(execContext, focus, exp.parameters[1], true);
      if (n2.isEmpty ||
          !n2.first.isPrimitive ||
          !n2.first.primitiveValue!.isInteger) {
        return [];
      }
      i2 = int.parse(n2.first.primitiveValue ?? '-1');
    }

    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final sw = utilities.convertToString(focus.first);
      if (i1 < 0 || i1 >= sw.length) {
        return [];
      }

      final s = (exp.parameterCount == 2)
          ? sw.substring(i1, (i1 + i2).clamp(0, sw.length))
          : sw.substring(i1);

      if (s.isNotEmpty) {
        result.add(fpContext.factory.string(s));
      }
    }
    return result;
  }

  Future<List<FhirNode>> funcStartsWith(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final swb =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final sw = utilities.convertListToString(swb);

    if (focus.isEmpty || swb.isEmpty) {
      return result;
    }

    if (sw.isEmpty) {
      result.add(fpContext.factory.boolean(true));
    } else if (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
        fpContext.doImplicitStringConversion) {
      final s = utilities.convertToString(focus.first);
      result.add(fpContext.factory.boolean(s.startsWith(sw)));
    }
    return result;
  }

  Future<List<FhirNode>> funcEndsWith(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final swb =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final sw = utilities.convertListToString(swb);

    if (focus.isEmpty || swb.isEmpty) {
      return result;
    }

    if (sw.isEmpty) {
      result.add(fpContext.factory.boolean(true));
    } else if (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
        fpContext.doImplicitStringConversion) {
      final s = utilities.convertToString(focus.first);
      result.add(fpContext.factory.boolean(s.endsWith(sw)));
    }
    return result;
  }

  Future<List<FhirNode>> funcMatches(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final swb =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final sw = utilities.convertListToString(swb);

    if (focus.isEmpty || swb.isEmpty) {
      return result;
    } else if (focus.length == 1 && sw.isNotEmpty) {
      final st = utilities.convertToString(focus.first);
      if (st.isEmpty) {
        result.add(fpContext.factory.boolean(false));
      } else {
        final regExp = RegExp(sw, dotAll: true);
        final match = regExp.hasMatch(st);
        result.add(fpContext.factory.boolean(match));
      }
    } else {
      result.add(fpContext.factory.boolean(false));
    }
    return result;
  }

  Future<List<FhirNode>> funcMatchesFull(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final sw = utilities.convertListToString(
      await engine.execute(execContext, focus, exp.parameters[0], true),
    );

    if (focus.length == 1 && sw.isNotEmpty) {
      final st = utilities.convertToString(focus.first);
      if (st.isEmpty) {
        result.add(fpContext.factory.boolean(false));
      } else {
        final regExp = RegExp(sw, dotAll: true);
        final fullMatch = regExp.matchAsPrefix(st) != null;
        result.add(fpContext.factory.boolean(fullMatch));
      }
    } else {
      result.add(fpContext.factory.boolean(false));
    }
    return result;
  }

  Future<List<FhirNode>> funcReplaceMatches(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final regexB =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final regex = utilities.convertListToString(regexB);
    final replB =
        await engine.execute(execContext, focus, exp.parameters[1], true);
    final repl = utilities.convertListToString(replB);

    if (focus.isEmpty || regexB.isEmpty || replB.isEmpty) {
      return result;
    }

    if (focus.length == 1 && !Utilities.noString(regex)) {
      if (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
          fpContext.doImplicitStringConversion) {
        final s = utilities.convertToString(focus.first);
        result.add(
          fpContext.factory.string(s.replaceAll(RegExp(regex), repl)),
        );
      }
    } else {
      // A blank pattern (or non-singleton focus) returns the input unchanged
      // (Java reference funcReplaceMatches; official testReplaceMatches2).
      result.add(
        fpContext.factory.string(utilities.convertToString(focus.first)),
      );
    }
    return result;
  }

  Future<List<FhirNode>> funcContains(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    if (execContext.thisItem == null) {
      throw PathEngineException('The fpContext does not have a thisItem');
    }
    final swb = await engine.execute(
      execContext,
      baseToList(execContext.thisItem!),
      exp.parameters[0],
      true,
    );
    final sw = utilities.convertListToString(swb);

    if (focus.length != 1 || swb.length != 1) {
      return result;
    } else if (sw.isEmpty) {
      result.add(fpContext.factory.boolean(true));
    } else if (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
        fpContext.doImplicitStringConversion) {
      final st = utilities.convertToString(focus.first);
      result.add(fpContext.factory.boolean(st.contains(sw)));
    }
    return result;
  }

  Future<List<FhirNode>> funcReplace(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final tB =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final t = utilities.convertListToString(tB);
    final rB =
        await engine.execute(execContext, focus, exp.parameters[1], true);
    final r = utilities.convertListToString(rB);

    if (focus.isEmpty || tB.isEmpty || rB.isEmpty) {
      return result;
    }

    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final f = utilities.convertToString(focus.first);
      if (f.isEmpty) {
        result.add(fpContext.factory.string(''));
      } else {
        result.add(fpContext.factory.string(f.replaceAll(t, r)));
      }
    } else {
      throw fpContext.makeException(
        exp,
        'FHIRPATH_NO_COLLECTION',
        ['replace', focus.length],
      );
    }
    return result;
  }

  List<FhirNode> funcLength(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1 &&
        (focus.first.hasType(fpContext.FHIR_TYPES_STRING) ||
            fpContext.doImplicitStringConversion)) {
      final s = utilities.convertToString(focus.first);
      result.add(fpContext.factory.integer(s.length));
    }
    return result;
  }

  List<FhirNode> funcChildren(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    for (final b in focus) {
      engine.getChildrenByName(b, '*', result);
    }
    return result;
  }

  List<FhirNode> funcDescendants(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    final current = <FhirNode>[...focus];
    final added = <FhirNode>[];
    var more = true;
    while (more) {
      added.clear();
      for (final item in current) {
        engine.getChildrenByName(item, '*', added);
      }
      more = added.isNotEmpty;
      result.addAll(added);
      current
        ..clear()
        ..addAll(added);
    }
    return result;
  }

  Future<List<FhirNode>> funcMemberOf(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters[0], true);

    if (nl.length != 1 || focus.length != 1) {
      return [];
    }

    final url = nl.first.primitiveValue;
    if (url == null) {
      return [];
    }
    final vs = fpContext.hostServices != null
        ? fpContext.hostServices!
            .resolveValueSet(engine, execContext.appInfo, url)
        : await fpContext.worker.fetchValueSet(url);

    if (vs == null) {
      // The spec is explicit: "If the valueset cannot be resolved as a uri to
      // a value set, an error is thrown." Returning empty instead makes
      // `where(code.memberOf(...)).count()` answer 0, which is
      // indistinguishable from a genuine none — a caller cannot tell "nothing
      // matched" from "nobody could look".
      throw PathEngineException(
        'Unable to resolve value set $url',
        location: exp.start,
        expression: exp.toString(),
      );
    }

    // `memberOf` asks one question: is this code IN this value set. The spec
    // is worded as membership throughout — "returns true if the code is a
    // member of the given valueset", "returns true if any code in the concept
    // is a member of the given valueset" — and says nothing about the code
    // also being valid in its own code system.
    //
    // That difference decides real answers. A value set enumerating SNOMED
    // concepts is answerable from the enumeration alone, and SNOMED is
    // licensed, so no offline deployment has the code system to hand. Asking
    // the wider question there produces `false` for a code that is plainly
    // listed in the value set — a confident wrong answer, and silent.
    final options = fpContext.terminologyServiceOptions.withCheckValueSetOnly();

    final l = focus.first;
    if (['code', 'string', 'uri'].contains(l.fhirType)) {
      final result = await fpContext.worker.validateCodeForCodingValue(
        // A bare code carries no system, so the system is taken from the value
        // set — which is why the spec qualifies this case with "so long as the
        // valueset only contains one codesystem".
        options.withGuessSystem(),
        l,
        vs,
      );
      return utilities.makeBoolean(
        result.isOk,
      );
    } else if (l.fhirType == 'Coding') {
      final result = await fpContext.worker.validateCodeForCodingValue(
        options,
        l,
        vs,
      );
      return utilities.makeBoolean(
        result.isOk,
      );
    } else if (l.fhirType == 'CodeableConcept') {
      final result = await fpContext.worker.validateCodeForCodeableConceptValue(
        options,
        l,
        vs,
      );
      return utilities.makeBoolean(result.isOk);
    }
    return [];
  }

  Future<List<FhirNode>> funcTrace(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final name = nl.first.primitiveValue.toString();

    if (exp.parameters.length == 2) {
      final n2 =
          await engine.execute(execContext, focus, exp.parameters[1], true);
      writeToLog(name, n2);
    } else {
      writeToLog(name, focus);
    }
    return focus;
  }

  Future<List<FhirNode>> funcDefineVariable(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    final name = nl.first.primitiveValue.toString();
    // AWAITED. This was `engine.execute(...)` with no await, so the
    // two-parameter form stored a Future rather than the value it resolves
    // to. setDefinedVariable takes `dynamic`, so nothing complained and every
    // use of defineVariable(name, expression) was quietly wrong: the variable
    // was never equal to anything and the expression returned nothing.
    final value = exp.parameters.length == 2
        ? await engine.execute(execContext, focus, exp.parameters[1], true)
        : focus;

    execContext.setDefinedVariable(name, value, fpContext.worker);
    return focus;
  }

  Future<List<FhirNode>> funcCheck(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    final n1 =
        await engine.execute(execContext, focus, expr.parameters[0], true);

    if (!utilities.convertToBoolean(n1)) {
      final n2 =
          await engine.execute(execContext, focus, expr.parameters[1], true);
      final name = n2.first.primitiveValue.toString();
      throw FhirPathException('Check failed for $name');
    }
    return focus;
  }

  List<FhirNode> funcToday(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return <FhirNode>[fpContext.factory.todayFrom(DateTime.now())];
  }

  List<FhirNode> funcNow(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return <FhirNode>[fpContext.factory.nowFrom(DateTime.now())];
  }

  List<FhirNode> funcTimeOfDay(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return <FhirNode>[fpContext.factory.timeOfDayFrom(DateTime.now())];
  }

  Future<List<FhirNode>> funcAllFalse(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    if (exp.parameters.length == 1) {
      var all = true;
      final pc = <FhirNode>[];
      for (final item in focus) {
        pc
          ..clear()
          ..add(item);
        final res =
            await engine.execute(execContext, pc, exp.parameters.first, true);
        final v = utilities.asBoolList(res, exp);
        if (v != FpEquality.false_) {
          // Assuming FpEquality.falseValue corresponds to `FpEquality.False`
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    } else {
      var all = true;
      for (final item in focus) {
        if (!utilities.canConvertToBoolean(item)) {
          throw PathEngineException(
            "Unable to convert '${utilities.convertToString(item)}' "
            'to a boolean',
          );
        }

        final v = utilities.asBool(item, true);
        if (v != FpEquality.false_) {
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    }
    return result;
  }

  Future<List<FhirNode>> funcAnyFalse(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    if (exp.parameters.length == 1) {
      var any = false;
      final pc = <FhirNode>[];
      for (final item in focus) {
        pc
          ..clear()
          ..add(item);
        final res =
            await engine.execute(execContext, pc, exp.parameters.first, true);
        final v = utilities.asBoolList(res, exp);
        if (v == FpEquality.false_) {
          any = true;
          break;
        }
      }
      result.add(fpContext.factory.boolean(any));
    } else {
      var any = false;
      for (final item in focus) {
        if (!utilities.canConvertToBoolean(item)) {
          throw PathEngineException(
            "Unable to convert '${utilities.convertToString(item)}' "
            'to a boolean',
          );
        }

        final v = utilities.asBool(item, true);
        if (v == FpEquality.false_) {
          any = true;
          break;
        }
      }
      result.add(fpContext.factory.boolean(any));
    }
    return result;
  }

  Future<List<FhirNode>> funcAnyTrue(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];

    if (exp.parameters.length == 1) {
      var any = false;
      final pc = <FhirNode>[];

      for (final item in focus) {
        pc
          ..clear()
          ..add(item);
        final res =
            await engine.execute(execContext, pc, exp.parameters[0], true);
        final v = utilities.asBoolList(res, exp);
        if (v == FpEquality.true_) {
          any = true;
          break;
        }
      }
      result.add(fpContext.factory.boolean(any));
    } else {
      var any = false;
      for (final item in focus) {
        if (!utilities.canConvertToBoolean(item)) {
          throw PathEngineException(
            "Unable to convert '${utilities.convertToString(item)}' "
            'to a boolean',
          );
        }
        final v = utilities.asBool(item, true);
        if (v == FpEquality.true_) {
          any = true;
          break;
        }
      }
      result.add(fpContext.factory.boolean(any));
    }
    return result;
  }

  Future<List<FhirNode>> funcAllTrue(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];

    if (exp.parameters.length == 1) {
      var all = true;
      final pc = <FhirNode>[];

      for (final item in focus) {
        pc
          ..clear()
          ..add(item);
        final res =
            await engine.execute(execContext, pc, exp.parameters[0], true);
        final v = utilities.asBoolList(res, exp);
        if (v != FpEquality.true_) {
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    } else {
      var all = true;
      for (final item in focus) {
        if (!utilities.canConvertToBoolean(item)) {
          throw PathEngineException(
            "Unable to convert '${utilities.convertToString(item)}' "
            'to a boolean',
          );
        }
        final v = utilities.asBool(item, true);
        if (v != FpEquality.true_) {
          all = false;
          break;
        }
      }
      result.add(fpContext.factory.boolean(all));
    }
    return result;
  }

  List<FhirNode> funcResolve(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    FhirNode? refContext;

    for (final item in focus) {
      String? s = utilities.convertToString(item);
      if (item.fhirType == 'Reference') {
        refContext = item;
        // Java (org.hl7.fhir.r4.fhirpath FHIRPathEngine.funcResolve, read
        // 2026-09-14): `Property p = item.getChildByName("reference"); if (p
        // != null && p.hasValues()) { url = convertToString(p.getValues()
        // .get(0)); }`. The reference element is a primitive; its string IS
        // the value. This used to look for a primitive CHILD of it and so
        // never resolved a literal reference: `subject.where(resolve() is
        // Patient)` was empty for every stored reference.
        final property = item.getChildByName('reference');
        if (property == null) {
          s = null;
        } else if (property.isPrimitive) {
          s = property.primitiveValue;
        } else if (utilities.nodeHasValues(property)) {
          s = null;
          for (final child in property.listChildrenNames()) {
            final prop = property.getChildByName(child);
            if (prop != null && prop.isPrimitive) {
              s = prop.primitiveValue;
              break;
            }
          }
        } else {
          s = null;
        }
      }

      if (item.fhirType == 'canonical') {
        s = item.primitiveValue;
        refContext = item;
      }

      if (s != null) {
        FhirNode? res;
        if (s.startsWith('#')) {
          final property =
              execContext.rootResource?.getChildByName('contained');
          if (property != null) {
            for (final c in property.listChildrenNames()) {
              final val = property.getChildByName(c);
              // Both Element.id and Resource.id are the 'id' child, read via
              // the node contract rather than casting to a FHIR base type.
              final id = val?.getChildByName('id')?.primitiveValue;
              if (id != null && chompHash(s) == chompHash(id)) {
                res = fpContext.factory.string(c, disallowExtensions: false);
                break;
              }
            }
          }
        } else if (fpContext.hostServices != null && refContext != null) {
          try {
            res = fpContext.hostServices?.resolveReference(
              engine,
              execContext.appInfo ?? '',
              s,
              refContext,
            );
          } catch (e) {
            res = null;
          }
        }

        if (res != null) {
          result.add(res);
        }
      }
    }

    return result;
  }

  String? chompHash(String? theId) {
    var retVal = theId;
    while (retVal?.startsWith('#') ?? false) {
      retVal = retVal!.substring(1);
    }
    return retVal;
  }

  Future<List<FhirNode>> funcExtension(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final result = <FhirNode>[];
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final url = nl.first.primitiveValue;

    for (final item in focus) {
      final ext = <FhirNode>[];
      engine
        ..getChildrenByName(item, 'extension', ext)
        ..getChildrenByName(item, 'modifierExtension', ext);
      for (final ex in ext) {
        final vl = <FhirNode>[];
        engine.getChildrenByName(ex, 'url', vl);
        if (utilities.convertListToString(vl) == url) {
          result.add(ex);
        }
      }
    }

    return result;
  }

  List<FhirNode> funcHasValue(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.length == 1) {
      final s = utilities.convertToString(focus.first);
      return [
        fpContext.factory
            .boolean(!Utilities.noString(s), disallowExtensions: false),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  Future<List<FhirNode>> funcEncode(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final param = nl.first.primitiveValue;

    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null) {
        if (param == 'hex') {
          return [
            fpContext.factory
                .string(bytesToHex(cnt.codeUnits), disallowExtensions: false),
          ];
        } else if (param == 'base64') {
          return [
            fpContext.factory
                .string(base64Encode(cnt.codeUnits), disallowExtensions: false),
          ];
        } else if (param == 'urlbase64') {
          return [
            fpContext.factory.string(
              base64UrlEncode(cnt.codeUnits),
              disallowExtensions: false,
            ),
          ];
        }
      }
    }
    return [];
  }

  String bytesToHex(List<int> bytes) {
    const hexArray = '0123456789ABCDEF';
    final hexChars = List<String>.filled(bytes.length * 2, '');

    for (var j = 0; j < bytes.length; j++) {
      final v = bytes[j] & 0xFF;
      hexChars[j * 2] = hexArray[v >> 4];
      hexChars[j * 2 + 1] = hexArray[v & 0x0F];
    }

    return hexChars.join();
  }

  Future<List<FhirNode>> funcDecode(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final param = nl.first.primitiveValue;

    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null) {
        if (param == 'hex') {
          return [
            fpContext.factory.string(
              String.fromCharCodes(hexStringToByteArray(cnt)),
              disallowExtensions: false,
            ),
          ];
        } else if (param == 'base64') {
          return [
            fpContext.factory.string(
              utf8.decode(base64Decode(cnt)),
              disallowExtensions: false,
            ),
          ];
        } else if (param == 'urlbase64') {
          return [
            fpContext.factory.string(
              utf8.decode(base64Url.decode(cnt)),
              disallowExtensions: false,
            ),
          ];
        }
      }
    }
    return [];
  }

  List<int> hexStringToByteArray(String s) {
    final len = s.length;
    if (len % 2 != 0) {
      throw ArgumentError('Hex string must have an even number of characters');
    }

    final data = List<int>.filled(len ~/ 2, 0);
    for (var i = 0; i < len; i += 2) {
      final high = int.parse(s[i], radix: 16);
      final low = int.parse(s[i + 1], radix: 16);
      data[i ~/ 2] = (high << 4) + low;
    }
    return data;
  }

  Future<List<FhirNode>> funcEscape(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final param = nl.first.primitiveValue;

    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null) {
        if (param == 'html') {
          return [
            fpContext.factory
                .string(cnt.escapeXml(), disallowExtensions: false),
          ];
        } else if (param == 'json') {
          return [
            fpContext.factory
                .string(cnt.escapeJson(), disallowExtensions: false),
          ];
        }
      }
    }
    return [];
  }

  Future<List<FhirNode>> funcUnescape(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final param = nl.first.primitiveValue;

    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null) {
        if (param == 'html') {
          return [
            fpContext.factory
                .string(cnt.unescapeXml(), disallowExtensions: false),
          ];
        } else if (param == 'json') {
          return [
            fpContext.factory
                .string(cnt.unescapeJson(), disallowExtensions: false),
          ];
        }
      }
    }
    return [];
  }

  List<FhirNode> funcTrim(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null) {
        return [
          fpContext.factory.string(cnt.trim(), disallowExtensions: false),
        ];
      }
    }
    return [];
  }

  Future<List<FhirNode>> funcSplit(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final param = nl.first.primitiveValue;

    if (focus.length == 1) {
      final cnt = focus.first.primitiveValue;
      if (cnt != null && param != null) {
        final parts = cnt.split(param);
        // Java reference funcToChars: new StringType(...).
        return parts
            .map((c) => fpContext.factory.string(c, disallowExtensions: false))
            .toList();
      }
    }
    return [];
  }

  Future<List<FhirNode>> funcJoin(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final nl =
        await engine.execute(execContext, focus, exp.parameters.first, true);
    final delimiter = nl.first.primitiveValue;

    final joined =
        focus.map((item) => item.primitiveValue).join(delimiter ?? '');
    return [fpContext.factory.string(joined, disallowExtensions: false)];
  }

  List<FhirNode> funcHtmlChecks1(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
    return [fpContext.factory.boolean(false, disallowExtensions: false)];
    // final xhtml = focus.first.getXhtml();
    // if (xhtml == null) {
    //   return [FhirBoolean(false)];
    // }
    // return [FhirBoolean(checkHtmlNames(xhtml))];
  }

  List<FhirNode> funcHtmlChecks2(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
    return [fpContext.factory.boolean(false, disallowExtensions: false)];
    // final xhtml = focus.first.getXhtml();
    // if (xhtml == null) {
    //   return [FhirBoolean(false)];
    // }
    // return [FhirBoolean(checkForContent(xhtml))];
  }

  Future<List<FhirNode>> funcComparable(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    if (focus.length != 1 || focus.first.fhirType != 'Quantity') {
      return utilities.makeBoolean(false);
    }

    final nl =
        await engine.execute(execContext, focus, exp.parameters[0], true);
    if (nl.length != 1 || nl.first.fhirType != 'Quantity') {
      return utilities.makeBoolean(false);
    }

    final s1 = getNamedValue(focus.first, 'system');
    final u1 = getNamedValue(focus.first, 'code');
    final s2 = getNamedValue(nl.first, 'system');
    final u2 = getNamedValue(nl.first, 'code');

    if (s1 == null || s2 == null || s1 != s2) {
      return utilities.makeBoolean(false);
    }
    if (u1 == null || u2 == null) {
      return utilities.makeBoolean(false);
    }
    if (u1 == u2) {
      return utilities.makeBoolean(true);
    }
    if (s1 == 'http://unitsofmeasure.org') {
      try {
        return utilities
            .makeBoolean(fpContext.worker.ucumService.isComparable(u1, u2));
      } catch (e) {
        return utilities.makeBoolean(false);
      }
    } else {
      return utilities.makeBoolean(false);
    }
  }

  List<FhirNode> funcToInteger(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final s = utilities.convertListToString(focus);
    final result = <FhirNode>[];
    if (Utilities.isInteger(s)) {
      result.add(fpContext.factory.integer(int.parse(s)));
    } else if (s == 'true') {
      result.add(fpContext.factory.integer(1));
    } else if (s == 'false') {
      result.add(fpContext.factory.integer(0));
    }
    return result;
  }

  List<FhirNode> funcToString(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    for (final item in focus) {
      final value = utilities.convertToString(item);
      result.add(fpContext.factory.string(value));
    }

    if (result.length > 1) {
      throw fpContext.makeException(
        exp,
        'FHIRPATH_NO_COLLECTION',
        ['toString', result.length],
      );
    }
    return result;
  }

  List<FhirNode> funcToBoolean(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1) {
      final item = focus.first;
      if (item.fhirType == 'boolean') {
        result.add(item);
      } else if (item.fhirType == 'integer') {
        final i = utilities.nodeNum(item);
        if (i == 0) {
          result.add(fpContext.factory.boolean(false));
        } else if (i == 1) {
          result.add(fpContext.factory.boolean(true));
        }
      } else if (item.fhirType == 'decimal') {
        final value = utilities.nodeNum(item);
        if (value == 0) {
          result.add(fpContext.factory.boolean(false));
        } else if (value == 1) {
          result.add(fpContext.factory.boolean(true));
        }
      } else if (item.fhirType == 'string') {
        final primitiveValue = item.primitiveValue?.toLowerCase();
        if (<String>['true', 't', 'yes', 'y', '1', '1.0']
            .contains(primitiveValue)) {
          result.add(fpContext.factory.boolean(true));
        } else if (<String>[
          'false',
          'f',
          'no',
          'n',
          '0',
          '0.0',
        ].contains(primitiveValue)) {
          result.add(fpContext.factory.boolean(false));
        }
      }
    }
    return result;
  }

  List<FhirNode> funcToQuantity(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length == 1) {
      final item = focus.first;
      if (utilities.isQuantityNode(item)) {
        result.add(item);
      } else if (item.fhirType == 'string') {
        final q = parseQuantityString(item.primitiveValue);
        if (q != null) {
          result.add(q);
        }
      } else if (utilities.isNumericNode(item)) {
        result.add(
          fpContext.factory.quantity(
            value: utilities.nodeNum(item),
            system: 'http://unitsofmeasure.org',
            code: '1',
          ),
        );
      }
    }
    return result;
  }

  FhirNode? parseQuantityString(String? str) {
    if (str == null) {
      return null;
    }
    var s = str.trim();
    if (s.contains(' ')) {
      final v = s.substring(0, s.indexOf(' ')).trim();

      s = s.substring(s.indexOf(' ')).trim();

      if (!Utilities.isDecimal(v)) {
        return null;
      }

      if (s.startsWith("'") && s.endsWith("'")) {
        return quantityFromUcum(v, s.substring(1, s.length - 1));
      }

      // Only the calendar keywords may appear unquoted (FHIRPath quantity
      // grammar; Java reference parseQuantityString). A bare UCUM code like
      // `1 wk` does NOT convert — UCUM codes must be quoted (`1 'wk'`,
      // handled above). Official testStringQuantityWeekConvertsToQuantityFalse.
      switch (s) {
        case 'year':
        case 'years':
          return quantityFromUcum(v, 'a');
        case 'month':
        case 'months':
          return quantityFromUcum(v, 'mo_s');
        case 'week':
        case 'weeks':
          return quantityFromUcum(v, 'wk');
        case 'day':
        case 'days':
          return quantityFromUcum(v, 'd');
        case 'hour':
        case 'hours':
          return quantityFromUcum(v, 'h');
        case 'minute':
        case 'minutes':
          return quantityFromUcum(v, 'min');
        case 'second':
        case 'seconds':
          return quantityFromUcum(v, 's');
        case 'millisecond':
        case 'milliseconds':
          return quantityFromUcum(v, 'ms');
        default:
          return null;
      }
    } else {
      if (Utilities.isDecimal(s)) {
        return fpContext.factory.quantity(
          value: int.tryParse(s) ?? double.parse(s),
          system: 'http://unitsofmeasure.org',
          code: '1',
        );
      } else {
        return null;
      }
    }
  }

  List<FhirNode> funcToDateTime(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    } else if (focus.length == 1) {
      if (utilities.isDateTimeNode(focus.first) &&
          focus.first.primitiveValue != null) {
        return [
          fpContext.factory
              .dateTimeOfType('dateTime', focus.first.primitiveValue!),
        ];
      } else if (focus.first.fhirType == 'string') {
        final dateTime = focus.first.primitiveValue == null
            ? null
            : fpContext.factory.tryDateTime(focus.first.primitiveValue);
        if (dateTime != null) {
          return [dateTime];
        }
        return [];
      }
    }

    throw fpContext.makeException(
      expr,
      'FHIRPATH_NO_COLLECTION',
      ['toString'],
    );
  }

  List<FhirNode> funcToDate(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    } else if (focus.length == 1) {
      if (utilities.isDateTimeNode(focus.first)) {
        final date = fpContext.factory.tryDate(focus.first.primitiveValue);
        if (date != null) {
          return [date];
        }
        return [];
      } else if (focus.first.fhirType == 'string') {
        final date = focus.first.primitiveValue == null
            ? null
            : fpContext.factory.tryDateTime(focus.first.primitiveValue);
        if (date != null) {
          return [date];
        }
        return [];
      }
    }

    throw fpContext.makeException(
      expr,
      'FHIRPATH_NO_COLLECTION',
      ['toString'],
    );
  }

  List<FhirNode> funcToTime(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    } else if (focus.length == 1) {
      if (utilities.isTimeNode(focus.first)) {
        return [focus.first];
      } else if (focus.first.fhirType == 'string') {
        final time = fpContext.factory.tryTime(focus.first.toString());
        if (time != null) {
          return [time];
        }
        return [];
      }
    }

    throw fpContext.makeException(
      expr,
      'FHIRPATH_NO_COLLECTION',
      ['toString'],
    );
  }

  List<FhirNode> funcToDecimal(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    final s = utilities.convertListToString(focus);
    final result = <FhirNode>[];
    if (Utilities.isDecimal(s)) {
      // Preserve the source string form (Java: new DecimalType(s)).
      result.add(fpContext.factory.decimalFromString(s));
    } else if (s == 'true') {
      result.add(fpContext.factory.decimal(1));
    } else if (s == 'false') {
      result.add(fpContext.factory.decimal(0));
    }
    return result;
  }

  List<FhirNode> funcIsDecimal(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    final result = <FhirNode>[];
    if (focus.length != 1) {
      result.add(fpContext.factory.boolean(false));
    } else if (const {'integer', 'boolean', 'decimal'}
        .contains(focus.first.fhirType)) {
      result.add(fpContext.factory.boolean(true));
    } else if (focus.first.fhirType == 'string') {
      result.add(
        fpContext.factory.boolean(Utilities.isDecimal(focus.first.toString())),
      );
    } else {
      result.add(fpContext.factory.boolean(false));
    }
    return result;
  }

  List<FhirNode> funcIsInteger(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'integer' ||
        focus.first.fhirType == 'boolean') {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'string') {
      return [
        fpContext.factory.boolean(
          Utilities.isInteger(focus.first.toString()),
          disallowExtensions: false,
        ),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  List<FhirNode> funcIsBoolean(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'integer') {
      final value = utilities.nodeNum(focus.first);
      return [
        fpContext.factory.boolean(
          value != null && value >= 0 && value <= 1,
          disallowExtensions: false,
        ),
      ];
    } else if (focus.first.fhirType == 'decimal') {
      final value = utilities.nodeNum(focus.first);
      return [
        fpContext.factory.boolean(
          value != null && (value == 0 || value == 1),
          disallowExtensions: false,
        ),
      ];
    } else if (focus.first.fhirType == 'boolean') {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'string') {
      final value = focus.first.toString().toLowerCase();
      return [
        fpContext.factory.boolean(
          value == 'true' || value == 'false',
          disallowExtensions: false,
        ),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  List<FhirNode> funcIsDateTime(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'dateTime' ||
        focus.first.fhirType == 'date') {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (stringClassTypeNames.contains(focus.first.fhirType)) {
      final regex = RegExp(
        r'(\d{4}(-\d{2}(-\d{2}(T\d{2}:\d{2}(:\d{2}(\.\d+)?)?(Z|([-+]\d{2}:\d{2})))?)?)?)',
      );
      return [
        fpContext.factory.boolean(
          regex.hasMatch(focus.first.toString()),
          disallowExtensions: false,
        ),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  List<FhirNode> funcIsDate(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'dateTime' ||
        focus.first.fhirType == 'date') {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (stringClassTypeNames.contains(focus.first.fhirType)) {
      final regex = RegExp(
        r'\d{4}(-\d{2}(-\d{2})?)?',
      );
      return [
        fpContext.factory.boolean(
          regex.hasMatch(focus.first.toString()),
          disallowExtensions: false,
        ),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  Future<List<FhirNode>> funcConformsTo(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (fpContext.hostServices == null) {
      throw fpContext.makeException(expr, 'FHIRPATH_HO_HOST_SERVICES', [
        'conformsTo',
      ]);
    }
    final result = <FhirNode>[];
    if (focus.length != 1) {
      result.add(fpContext.factory.boolean(false));
    } else {
      final url = utilities.convertListToString(
        await engine.execute(execContext, focus, expr.parameters.first, true),
      );
      result.add(
        fpContext.factory.boolean(
          fpContext.hostServices!.conformsToProfile(
            engine,
            execContext.appInfo ?? '',
            focus.first,
            url,
          ),
        ),
      );
    }
    return result;
  }

  List<FhirNode> funcIsTime(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'time') {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (stringClassTypeNames.contains(focus.first.fhirType)) {
      final regex = RegExp(
        r'(T)?([01]\d|2[0-3])(:[0-5]\d(:[0-5]\d(\.\d+)?)?)?(Z|([-+](0[0-9]|1[0-3]):[0-5]\d|14:00))?',
      );

      return [
        fpContext.factory.boolean(
          regex.hasMatch(focus.first.toString()),
          disallowExtensions: false,
        ),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  List<FhirNode> funcIsString(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (const {
      'string',
      'integer',
      'decimal',
      'date',
      'dateTime',
      'time',
      'boolean',
      'Quantity',
    }.contains(focus.first.fhirType)) {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  /// The FHIR type names whose classes derive from string in the reference
  /// model — the model-independent equivalent of the Java reference's
  /// `instanceof StringType` (CodeType and MarkdownType extend StringType;
  /// id/uri kinds do not).
  static const Set<String> stringClassTypeNames = {
    'string',
    'code',
    'markdown',
  };

  List<FhirNode> funcIsQuantity(List<FhirNode> focus) {
    if (focus.length != 1) {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    } else if (const {'integer', 'decimal', 'Quantity', 'boolean'}
        .contains(focus.first.fhirType)) {
      return [fpContext.factory.boolean(true, disallowExtensions: false)];
    } else if (focus.first.fhirType == 'string') {
      final quantity = parseQuantityString(focus.first.toString());
      return [
        fpContext.factory.boolean(quantity != null, disallowExtensions: false),
      ];
    } else {
      return [fpContext.factory.boolean(false, disallowExtensions: false)];
    }
  }

  Future<List<FhirNode>> funcRound(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext
          .makeExceptionPlural(focus.length, expr, 'FHIRPATH_FOCUS', [
        'round',
        focus.length,
      ]);
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (base.hasType(['integer', 'decimal', 'unsignedInt', 'positiveInt'])) {
      int? precision = 0;

      if (expr.parameters.isNotEmpty) {
        final n1 =
            await engine.execute(execContext, focus, expr.parameters[0], true);
        if (n1.length != 1) {
          throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
            'round',
            '0',
            'Multiple Values',
            'integer',
          ]);
        }
        precision = int.tryParse(n1[0].toString());
      }

      final value =
          int.tryParse(base.toString()) ?? double.tryParse(base.toString());
      if (value == null) {
        throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
          'round',
          '(focus)',
          base.fhirType,
          'integer or decimal',
        ]);
      }
      if (precision == null) {
        throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
          'round',
          '(focus)',
          base.fhirType,
          'integer',
        ]);
      }
      final valueString = value.toStringAsFixed(precision);
      result.add(
        fpContext.factory
            .decimalFromString(valueString, disallowExtensions: false),
      );
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'round',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcSqrt(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['sqrt', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (utilities.isNumericNode(base)) {
      final value = int.tryParse(base.primitiveValue ?? '') ??
          double.tryParse(base.primitiveValue ?? '');
      if (value != null) {
        try {
          final val = sqrt(value);
          if (!val.isNaN) {
            result.add(fpContext.factory.decimal(val));
          }
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'sqrt',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcAbs(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['abs', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (utilities.isNumericNode(base) && utilities.nodeNum(base) != null) {
      result.add(fpContext.factory.numericAbs(base));
    } else if (base.fhirType == 'Quantity') {
      final n = utilities.qtyValue(base)?.abs();
      if (n != null) {
        result.add(fpContext.factory.quantityWithValue(base, n));
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'abs',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcCeiling(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['ceiling', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (utilities.isNumericNode(base)) {
      final value = utilities.nodeNum(base);
      if (value != null) {
        try {
          result.add(fpContext.factory.integer(value.ceil()));
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'ceiling',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcFloor(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['floor', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (utilities.isNumericNode(base)) {
      final value = utilities.nodeNum(base);
      if (value != null) {
        try {
          result.add(fpContext.factory.integer(value.floor()));
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'floor',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcLn(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['ln', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (utilities.isNumericNode(base)) {
      final value = int.tryParse(base.primitiveValue ?? '') ??
          double.tryParse(base.primitiveValue ?? '');
      if (value != null) {
        try {
          result.add(fpContext.factory.decimal(log(value)));
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'ln',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  Future<List<FhirNode>> funcPower(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['power', focus.length],
      );
    }

    final base = focus[0];
    final result = <FhirNode>[];

    if (base.hasType(['integer', 'decimal', 'unsignedInt', 'positiveInt'])) {
      final n1 =
          await engine.execute(execContext, focus, expr.parameters.first, true);
      if (n1.isEmpty) {
        return [];
      }
      if (n1.length > 1) {
        throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
          'power',
          '0',
          'Multiple Values',
          'integer or decimal',
        ]);
      }

      final exponent = int.tryParse(n1[0].primitiveValue ?? '') ??
          double.tryParse(n1[0].primitiveValue ?? '');
      final value = int.tryParse(base.primitiveValue ?? '') ??
          double.tryParse(base.primitiveValue ?? '');
      if (exponent != null && value != null) {
        try {
          final res = pow(value, exponent);
          if (!res.isNaN) {
            result.add(fpContext.factory.decimal(res));
          }
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'power',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcSum(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    FhirNode? sum;

    for (final item in focus) {
      if (utilities.isNumericNode(item)) {
        if (sum == null) {
          sum = item;
        } else {
          sum = utilities.numericResult(
            utilities.nodeNum(sum)! + utilities.nodeNum(item)!,
            sum,
            item,
          );
        }
      } else {
        throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
          'sum',
          '(focus)',
          item.fhirType,
          'integer or decimal',
        ]);
      }
    }

    return sum == null ? [] : [sum];
  }

  List<FhirNode> funcExp(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['exp', focus.length],
      );
    }

    final base = focus.first;
    final result = <FhirNode>[];
    if (utilities.isNumericNode(base)) {
      final d = int.tryParse(base.primitiveValue ?? '') ??
          double.tryParse(base.primitiveValue ?? '');
      if (d != null) {
        try {
          result.add(fpContext.factory.decimal(exp(d)));
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'exp',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  Future<List<FhirNode>> funcLog(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['log', focus.length],
      );
    }

    final base = focus.first;
    final result = <FhirNode>[];
    if (base.hasType(['integer', 'decimal', 'unsignedInt', 'positiveInt'])) {
      final n1 =
          await engine.execute(execContext, focus, expr.parameters[0], true);
      if (n1.isEmpty) {
        return [];
      }
      if (n1.length > 1) {
        throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
          'log',
          '0',
          'Multiple Values',
          'integer or decimal',
        ]);
      }
      final e = int.tryParse(n1.first.primitiveValue ?? '') ??
          double.tryParse(n1.first.primitiveValue ?? '');
      final d = int.tryParse(base.primitiveValue ?? '') ??
          double.tryParse(base.primitiveValue ?? '');
      if (e != null && d != null) {
        try {
          result.add(fpContext.factory.decimal(log(d) / log(e)));
        } catch (e) {
          // Do nothing on error
        }
      }
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'log',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  List<FhirNode> funcTruncate(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.isEmpty) {
      return [];
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['truncate', focus.length],
      );
    }

    final base = focus.first;
    final result = <FhirNode>[];
    if (base.hasType(['integer', 'decimal', 'unsignedInt', 'positiveInt'])) {
      var s = base.primitiveValue ?? '';
      if (s.contains('.')) {
        s = s.split('.').first;
      }
      result.add(fpContext.factory.integer(int.parse(s)));
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_WRONG_PARAM_TYPE', [
        'truncate',
        '(focus)',
        base.fhirType,
        'integer or decimal',
      ]);
    }

    return result;
  }

  Future<List<FhirNode>> funcLowBoundary(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty) {
      return utilities.makeNull();
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['lowBoundary', focus.length],
      );
    }

    int? precision;
    if (expr.parameters.isNotEmpty) {
      final n1 =
          await engine.execute(execContext, focus, expr.parameters[0], true);
      if (n1.length != 1) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_WRONG_PARAM_TYPE',
          ['lowBoundary', '0', 'Multiple Values', 'integer'],
        );
      }
      precision = int.tryParse(n1.first.primitiveValue ?? '');
    }

    final base = focus.first;
    final result = <FhirNode>[];

    if (base.hasType(['decimal', 'integer'])) {
      if (precision == null || (precision >= 0 && precision < 17)) {
        // The boundary is an exact decimal STRING (trailing zeros are
        // significant); construct from the string to preserve it (Java
        // reference: new DecimalType(Utilities.lowBoundaryForDecimal(...))).
        result.add(
          fpContext.factory.decimalFromString(
            (base.primitiveValue ?? '').lowBoundaryForDecimal(precision ?? 8),
          ),
        );
      }
    } else if (base.hasType(['date'])) {
      result.add(
        fpContext.factory.dateTimeOfType(
          'dateTime',
          (base.primitiveValue ?? '').lowBoundaryForDate(precision ?? 10),
          disallowExtensions: true,
        ),
      );
    } else if (base.hasType(['dateTime'])) {
      result.add(
        fpContext.factory.dateTimeOfType(
          'dateTime',
          (base.primitiveValue ?? '').lowBoundaryForDate(precision ?? 17),
          disallowExtensions: true,
        ),
      );
    } else if (base.hasType(['time'])) {
      result.add(
        fpContext.factory.time(
          (base.primitiveValue ?? '').lowBoundaryForTime(precision ?? 9),
        ),
      );
    } else if (base.hasType(['Quantity'])) {
      // Quantity.value is a direct decimal child (Java reference reads
      // getValue().toPlainString()); getNamedValue is for polymorphic
      // wrappers and returned null here. The boundary string is preserved.
      final value = base.getChildByName('value')?.primitiveValue;
      result.add(
        fpContext.factory.quantityWithValueString(
          base,
          (value ?? '').lowBoundaryForDecimal(precision ?? 8),
        ),
      );
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_WRONG_PARAM_TYPE',
        ['lowBoundary', '(focus)', base.fhirType, 'decimal or date'],
      );
    }

    return result;
  }

  Future<List<FhirNode>> funcHighBoundary(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) async {
    if (focus.isEmpty) {
      return utilities.makeNull();
    }
    if (focus.length > 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['highBoundary', focus.length],
      );
    }

    int? precision;
    if (expr.parameters.isNotEmpty) {
      final n1 =
          await engine.execute(execContext, focus, expr.parameters[0], true);
      if (n1.length != 1) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_WRONG_PARAM_TYPE',
          ['highBoundary', '0', 'Multiple Values', 'integer'],
        );
      }
      precision = int.tryParse(n1.first.primitiveValue ?? '');
    }

    final base = focus.first;
    final result = <FhirNode>[];

    if (base.hasType(['decimal', 'integer'])) {
      if (precision == null || (precision >= 0 && precision < 17)) {
        // See funcLowBoundary — the exact string form is preserved.
        result.add(
          fpContext.factory.decimalFromString(
            (base.primitiveValue ?? '').highBoundaryForDecimal(precision ?? 8),
          ),
        );
      }
    } else if (base.hasType(['date'])) {
      result.add(
        fpContext.factory.dateTimeOfType(
          'dateTime',
          (base.primitiveValue ?? '').highBoundaryForDate(precision ?? 10),
          disallowExtensions: true,
        ),
      );
    } else if (base.hasType(['dateTime'])) {
      result.add(
        fpContext.factory.dateTimeOfType(
          'dateTime',
          (base.primitiveValue ?? '').highBoundaryForDate(precision ?? 17),
          disallowExtensions: true,
        ),
      );
    } else if (base.hasType(['time'])) {
      result.add(
        fpContext.factory.time(
          (base.primitiveValue ?? '').highBoundaryForTime(precision ?? 9),
        ),
      );
    } else if (base.hasType(['Quantity'])) {
      // See the lowBoundary Quantity branch.
      final value = base.getChildByName('value')?.primitiveValue;
      result.add(
        fpContext.factory.quantityWithValueString(
          base,
          (value ?? '').highBoundaryForDecimal(precision ?? 8),
        ),
      );
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_WRONG_PARAM_TYPE',
        ['highBoundary', '(focus)', base.fhirType, 'decimal or date'],
      );
    }

    return result;
  }

  List<FhirNode> funcPrecision(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode expr,
  ) {
    if (focus.length != 1) {
      throw fpContext.makeExceptionPlural(
        focus.length,
        expr,
        'FHIRPATH_FOCUS',
        ['highBoundary', focus.length],
      );
    }

    final base = focus.first;
    final result = <FhirNode>[];

    if (base.hasType(['decimal'])) {
      result.add(
        fpContext.factory.integer(
          (base.primitiveValue ?? '').getDecimalPrecision(),
          disallowExtensions: false,
        ),
      );
    } else if (base.hasType(['date', 'dateTime'])) {
      result.add(
        fpContext.factory.integer(
          (base.primitiveValue ?? '').getDatePrecision(),
          disallowExtensions: false,
        ),
      );
    } else if (base.hasType(['time'])) {
      result.add(
        fpContext.factory.integer(
          (base.primitiveValue ?? '').getTimePrecision(),
          disallowExtensions: false,
        ),
      );
    } else {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_WRONG_PARAM_TYPE',
        ['highBoundary', '(focus)', base.fhirType, 'decimal or date'],
      );
    }

    return result;
  }

  String? getNamedValue(FhirNode base, String name) {
    final property = base.getChildByName(name);
    final propertyChildren = property?.listChildrenNames();
    if (property != null && propertyChildren!.length == 1) {
      return property.getChildByName(propertyChildren.first)?.primitiveValue;
    }
    return null;
  }

  Future<List<FhirNode>> funcSupersetOf(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) async {
    final target = await engine.execute(
      execContext,
      execContext.focusResource == null ? focus : [execContext.focusResource!],
      exp.parameters[0],
      true,
    );

    var valid = true;
    for (final item in target) {
      var found = false;
      for (final t in focus) {
        if (utilities.deepEqual(item, t)) {
          found = true;
          break;
        }
      }
      if (!found) {
        valid = false;
        break;
      }
    }

    return [fpContext.factory.boolean(valid)];
  }

  List<FhirNode> funcType(
    ExecutionContext execContext,
    List<FhirNode> focus,
    ExpressionNode exp,
  ) {
    return focus.map(fpContext.factory.classTypeInfo).toList();
  }

  ///
  /// ***************************************
  /// UTILITIES
  /// ***************************************
  ///

  List<FhirNode> resolveConstantWithBase(
    ExecutionContext execContext,
    FhirNode? constant,
    bool beforeContext,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    if (constant == null) {
      return [];
    }

    if (constant is! FHIRConstant) {
      return [constant];
    }

    final c = constant;
    if (c.value.startsWith('%')) {
      final varName = c.value.substring(1);
      if (execContext.hasDefinedVariable(varName)) {
        return execContext.getDefinedVariable(varName);
      }
      final resolved = resolveConstantWithString(
        execContext,
        c.value,
        beforeContext,
        expr,
        explicitConstant,
      );
      return resolved;
    } else if (c.value.startsWith('@')) {
      return [
        processDateConstant(execContext.appInfo, c.value.substring(1), expr),
      ];
    } else {
      throw fpContext
          .makeException(expr, 'FHIRPATH_UNKNOWN_CONSTANT', [c.value]);
    }
  }

  List<FhirNode> resolveConstantWithString(
    ExecutionContext execContext,
    String s,
    bool beforeContext,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    switch (s) {
      case '%sct':
        return [fpContext.factory.string('http://snomed.info/sct')];
      case '%loinc':
        return [fpContext.factory.string('http://loinc.org')];
      case '%ucum':
        return [fpContext.factory.string('http://unitsofmeasure.org')];
      case '%resource':
        if (execContext.focusResource == null) {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANNOT_USE',
            ['%resource', 'no focus resource'],
          );
        }
        return [execContext.focusResource!];
      case '%rootResource':
        if (execContext.rootResource == null) {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_CANNOT_USE',
            ['%rootResource', 'no focus resource'],
          );
        }
        return [execContext.rootResource!];
      case '%context':
        return execContext.context == null ? [] : [execContext.context!];
      case '%us-zip':
        return [fpContext.factory.string('[0-9]{5}(-[0-9]{4}){0,1}')];
      default:
        if (s.startsWith('%`vs-')) {
          return [
            fpContext.factory.string(
              'http://hl7.org/fhir/ValueSet/${s.substring(5, s.length - 1)}',
            ),
          ];
        } else if (s.startsWith('%`cs-')) {
          return [
            fpContext.factory
                .string('http://hl7.org/fhir/${s.substring(5, s.length - 1)}'),
          ];
        } else if (s.startsWith('%`ext-')) {
          return [
            fpContext.factory.string(
              'http://hl7.org/fhir/StructureDefinition/${s.substring(6, s.length - 1)}',
            ),
          ];
        } else if (fpContext.hostServices == null) {
          throw fpContext.makeException(expr, 'FHIRPATH_UNKNOWN_CONSTANT', [s]);
        } else {
          return fpContext.hostServices!.resolveConstant(
            engine,
            execContext.appInfo,
            s.substring(1),
            beforeContext,
            explicitConstant,
          );
        }
    }
  }

  FhirNode processDateConstant(
    Object? appInfo,
    String value,
    ExpressionNode expr,
  ) {
    FhirNode? result;

    if (value.startsWith('T')) {
      result = fpContext.factory.tryTime(value.replaceFirst('T', ''));
    } else if (value.contains('T')) {
      result = fpContext.factory.tryDateTime(value) ??
          fpContext.factory.tryTime(value);
    } else {
      result = fpContext.factory.tryDate(value) ??
          fpContext.factory.tryDateTime(value) ??
          fpContext.factory.tryTime(value);
    }
    if (result != null) return result;
    throw fpContext.makeException(
      expr,
      'FHIRPATH_INVALID_DATE',
      [value],
    );
  }

  bool equivalentNumberAsString(String? l, String? r) {
    if ((l == null || l.isEmpty) && (r == null || r.isEmpty)) {
      return true;
    }
    if ((l == null || l.isEmpty) || (r == null || r.isEmpty)) {
      return false;
    }
    if (!l.isDecimal() || !r.isDecimal()) {
      return false;
    }

    final dl = int.tryParse(l) ?? double.parse(l);
    final dr = int.tryParse(r) ?? double.parse(r);

    return dl == dr;
  }

  ExecutionContext changeThisExecutionContext(
    ExecutionContext execContext,
    FhirNode newThis,
  ) {
    final newContext = ExecutionContext(
      appInfo: execContext.appInfo,
      focusResource: execContext.focusResource,
      rootResource: execContext.rootResource,
      context: execContext.context,
      thisItem: newThis,
    );
    // append all of the defined variables from the context into the new context
    if (execContext.definedVariables != null) {
      for (final s in execContext.definedVariables?.keys ?? <String>[]) {
        newContext.setDefinedVariable(
          s,
          execContext.definedVariables![s],
          fpContext.worker,
        );
      }
    }
    return newContext;
  }

  ExecutionTypeContext changeThisExecutionTypeContext(
    ExecutionTypeContext execContext,
    TypeDetails newThis,
  ) {
    final newContext = ExecutionTypeContext(
      execContext.appInfo,
      execContext.resource,
      execContext.context,
      newThis,
    );
    // append all of the defined variables from the context into the new context
    if (execContext.definedVariables != null) {
      for (final s in execContext.definedVariables?.keys ?? <String>[]) {
        newContext.setDefinedVariable(s, execContext.definedVariables![s]);
      }
    }
    return newContext;
  }

  List<FhirNode> baseToList(FhirNode b) {
    return [b];
  }

  void writeToLog(String name, List<FhirNode> contents) {
    if (fpContext.hostServices == null ||
        !fpContext.hostServices!.fpLog(name, contents)) {
      if (fpContext.fpLog.length > 0) {
        fpContext.fpLog.write('; ');
      }
      fpContext.fpLog
        ..write(name)
        ..write(': ');
      var first = true;
      for (final b in contents) {
        if (first) {
          first = false;
        } else {
          fpContext.fpLog.write(',');
        }
        fpContext.fpLog.write(utilities.convertToString(b));
      }
    }
  }

  String forLog() {
    if (fpContext.fpLog.length > 0) {
      return ' (${fpContext.fpLog})';
    } else {
      return '';
    }
  }

  bool hasType(FhirNode b, List<String> names) {
    final t = b.fhirType;
    for (final n in names) {
      if (n.equalsIgnoreCase(t)) return true;
    }
    return false;
  }

  FhirNode quantityFromUcum(String v, String code) {
    return fpContext.factory.quantity(
      value: int.tryParse(v) ?? double.parse(v),
      system: 'http://unitsofmeasure.org',
      code: code,
    );
  }
}
