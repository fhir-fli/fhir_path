// ignore_for_file: public_member_api_docs, avoid_positional_boolean_parameters

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';
import 'package:fhir_path/src/utils/path_string_extensions.dart';

class FHIRPathEngine {
  /// Constructor
  FHIRPathEngine._(IWorkerContext worker, [IEvaluationContext? hostServices])
      : fpContext = FhirPathContext(worker, hostServices);

  static Future<FHIRPathEngine> create(
    IWorkerContext worker, [
    IEvaluationContext? hostServices,
  ]) async {
    final engine = FHIRPathEngine._(worker, hostServices);
    await engine.fpContext.initialize();
    engine
      ..utilities = FhirPathUtilities(engine.fpContext)
      ..operations =
          FhirPathOperations(engine.fpContext, engine.utilities, engine)
      ..functions = FhirPathFunctions(
        engine.fpContext,
        engine.utilities,
        engine.operations,
        engine,
      );
    return engine;
  }

  /// Reads the canonical `url` of a StructureDefinition node exactly the way
  /// the model-bound code did (`sd.url!.toString()`: throws when the field is
  /// absent, `'null'` when its value is).
  static String _sdUrl(FhirNode sd) =>
      sd.getChildByName('url')!.primitiveValue ?? 'null';

  FhirPathContext fpContext;
  late final FhirPathUtilities utilities;
  late final FhirPathOperations operations;
  late final FhirPathFunctions functions;
  StringBuffer get fpLog => fpContext.fpLog;

  ///
  /// ***************************************
  /// PARSING AND PRECEDENCE MANAGEMENT
  /// ***************************************
  ///
  /// Check if an Expression is valid FHIRPath
  bool isValid(String path) {
    try {
      parse(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Parse a FHIRPath expression
  ExpressionNode parse(String path, [String? name]) {
    final lexer = FHIRLexer(
      source: path,
      name: name,
      allowDoubleQuotes: fpContext.allowDoubleQuotes,
    );

    if (lexer.done()) {
      throw FHIRLexerException(
        message: 'Path cannot be empty',
        location: lexer.currentLocation,
      );
    }
    final result = _parseExpression(lexer, true)..check();
    // Java parity: parse(String) rejects trailing input — without this,
    // parse('name.given garbage') silently drops the garbage and isValid()
    // reports such expressions valid. parseLexer stays lenient for embedded
    // parsing (Java's parse(FHIRLexer) overload), as parsePartial does.
    if (!lexer.done()) {
      throw lexer
          .error('Premature ExpressionNode termination at unexpected token '
              '"${lexer.current}"');
    }
    return result;
  }

  ExpressionNodeWithOffset parsePartial(String path, int i) {
    final lexer = FHIRLexer(
      source: path,
      cursor: i,
      allowDoubleQuotes: fpContext.allowDoubleQuotes,
    );
    if (lexer.done()) {
      throw lexer.error('Path cannot be empty');
    }
    final result = _parseExpression(lexer, true)..check();
    return ExpressionNodeWithOffset(lexer.currentStart, result);
  }

  /// Parses from an existing lexer WITHOUT requiring end-of-input — the
  /// lenient overload for embedded/partial parsing (Java's
  /// parse(FHIRLexer)). Whole-expression parsing goes through [parse],
  /// which rejects trailing tokens.
  ExpressionNode parseLexer(FHIRLexer lexer) {
    return _parseExpression(lexer, true)..check();
  }

  ExpressionNode _parseExpression(FHIRLexer lexer, bool proximal) {
    // 1) Create our main 'result' node
    var result = ExpressionNode(lexer.nextId().toString());
    ExpressionNode? wrapper;
    final c = lexer.currentStartLocation;
    result.start = lexer.currentLocation;

    // 2) Check if the current token is a standalone unary ('-' or '+') at this
    // point
    if (['-', '+'].contains(lexer.current)) {
      // This parallels the Java snippet where it does:
      //   if (Utilities.existsInList(lexer.getCurrent(), "-", "+")) { ... }
      wrapper = ExpressionNode(lexer.nextId().toString())
        ..kind = ExpressionNodeKind.unary
        ..operation = FpOperation.fromCode(lexer.take())
        ..start = lexer.currentLocation
        ..proximal = proximal;
    }

    // 3) Now parse out the actual expression content
    if (lexer.current == null) {
      throw lexer.error('Expression terminated unexpectedly');
    } else if (lexer.isConstant()) {
      final isString = lexer.isStringConstant();

      // Check if it's a unary sign embedded with the constant, e.g. '-123'
      FhirNode? constantValue;
      if (!isString &&
          (lexer.current!.startsWith('-') || lexer.current!.startsWith('+'))) {
        wrapper = ExpressionNode(lexer.nextId().toString())
          ..kind = ExpressionNodeKind.unary
          ..operation = FpOperation.fromCode(lexer.current!.substring(0, 1))
          ..proximal = proximal
          ..start = lexer.currentLocation;
        // Take the token and strip the sign before parsing
        // This preserves lexer state (cursor position) correctly
        final token = lexer.take();
        final numStr = token.substring(1);
        if (numStr.isInteger) {
          constantValue = fpContext.factory.integer(int.parse(numStr));
        } else if (numStr.isDecimal()) {
          // Preserve the literal's exact string form — 12.500 keeps its
          // trailing zeros (significant for lowBoundary/highBoundary), as the
          // Java reference's BigDecimal-backed DecimalType does.
          constantValue = fpContext.factory.decimalFromString(numStr);
        } else {
          throw lexer
              .error('Invalid numeric constant after unary sign: $token');
        }
      } else {
        // Actually parse the constant normally
        constantValue = _processConstant(lexer);
      }

      result
        ..constant = constantValue
        ..kind = ExpressionNodeKind.constant;

      // Possibly parse a quantity (e.g., "5 years")
      if (!isString &&
          !lexer.done() &&
          const {'integer', 'decimal'}.contains(result.constant?.fhirType) &&
          (lexer.isStringConstant() ||
              lexer.hasTokenList([
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
              ]))) {
        String? ucum;
        String? unit;

        if (lexer.hasTokenList([
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
        ])) {
          final s = lexer.take();
          unit = s;
          switch (s) {
            case 'week':
            case 'weeks':
              ucum = 'wk';
            case 'day':
            case 'days':
              ucum = 'd';
            case 'hour':
            case 'hours':
              ucum = 'h';
            case 'minute':
            case 'minutes':
              ucum = 'min';
            case 'second':
            case 'seconds':
              ucum = 's';
            case 'millisecond':
            case 'milliseconds':
              ucum = 'ms';
            // If 'year' or 'month', the Java code just doesn't set a UCUM,
            // but you can adapt as needed.
          }
        } else {
          ucum = lexer.readConstant('units');
        }

        result.constant = fpContext.factory.quantityLiteral(
          value: result.constant?.primitiveValue,
          unit: unit,
          ucumCode: ucum,
        );
      }
      result.end = lexer.currentLocation;
    } else if (lexer.current == '(') {
      // If the token is '(' => parse a group
      lexer.next();
      final newExpression = _parseExpression(lexer, true);
      result
        ..kind = ExpressionNodeKind.group
        ..group = newExpression;
      if (lexer.current != ')') {
        throw lexer.error('Found ${lexer.current} expecting a ")"');
      }
      result.end = lexer.currentLocation;
      lexer.next(); // consume ')'
    } else {
      // Parse a named token or function
      if (!lexer.isToken() && !lexer.current!.startsWith('')) {
        throw lexer.error('Found ${lexer.current} expecting a token name');
      }
      if (lexer.isFixedName()) {
        result.name = lexer.readFixedName('Path Name');
      } else {
        result.name = lexer.take();
      }
      result.end = lexer.currentLocation;
      if (!result.checkName()) {
        throw lexer.error('Found ${result.name} expecting a valid token name');
      }
      // If it looks like a function call => parse parameters
      if (lexer.current == '(') {
        var f = FpFunction.fromCode(result.name!);
        FunctionDetails? details;
        if (f == null) {
          if (fpContext.hostServices != null) {
            details =
                fpContext.hostServices!.resolveFunction(this, result.name!);
          }
          if (details == null) {
            throw lexer
                .error('The name ${result.name} is not a valid function name');
          }
          f = FpFunction.Custom;
        }
        result
          ..kind = ExpressionNodeKind.function
          ..function = f;

        lexer.next(); // consume '('
        while (lexer.current != ')') {
          result.parameters.add(_parseExpression(lexer, true));
          if (lexer.current == ',') {
            lexer.next();
          } else if (lexer.current != ')') {
            throw lexer.error(
              'The token ${lexer.current} is not expected here - '
              'either a "," or a ")" expected',
            );
          }
        }
        result.end = lexer.currentLocation;
        lexer.next(); // consume ')'
        _checkParameters(lexer, c, result, details);
      } else {
        result.kind = ExpressionNodeKind.name;
      }
    }

    // 4) Possibly parse array indexing [x]
    var focus = result;
    if (lexer.current == '[') {
      lexer.next();
      final item = ExpressionNode(lexer.nextId().toString())
        ..kind = ExpressionNodeKind.function
        ..function = FpFunction.Item
        ..parameters.add(_parseExpression(lexer, true));
      if (lexer.current != ']') {
        throw lexer.error(
          'The token ${lexer.current} is not expected here - a "]" expected',
        );
      }
      lexer.next();
      result.inner = item;
      focus = item;
    }

    // Possibly parse .inner expressions
    if (lexer.current == '.') {
      lexer.next();
      focus.inner = _parseExpression(lexer, false);
    }

    // 5) Mark result as proximal or not
    result.proximal = proximal;

    // 6) If it's the proximal expression, parse any operators
    if (proximal) {
      // The Java code:  while (lexer.isOp()) { focus.setOperation(...); ... }
      while (lexer.isOp()) {
        focus
          ..operation = FpOperation.fromCode(lexer.current)
          ..opStart = lexer.currentStartLocation
          ..opEnd = lexer.currentLocation;

        lexer.next(); // Consume the operator

        // Parse the right-hand side of the operation
        focus.opNext = _parseExpression(lexer, false);

        // Move focus forward carefully
        if (focus.opNext != null) {
          focus = focus.opNext!;

          // Ensure we do not skip unary nodes
          while (
              focus.kind == ExpressionNodeKind.unary && focus.opNext != null) {
            focus = focus.opNext!;
          }
        }
      }

      // 7) Then do the precedence reorganization
      result = _organisePrecedence(lexer, result);
    }

    // 8) If we built a unary wrapper for this expression, link it up
    if (wrapper != null) {
      wrapper.opNext = result;
      // Only set result.proximal = false if there are no operators attached
      // If there are operators, we need to keep proximal = true so they get
      // evaluated
      if (result.operation == null) {
        result.proximal = false;
      }
      result = wrapper;
    }

    return result;
  }

  // Mirror the Java organisePrecedence
  ExpressionNode _organisePrecedence(FHIRLexer lexer, ExpressionNode oldNode) {
    var node = oldNode;

    // Times/DivideBy/Div/Mod
    node = _gatherPrecedence(
      lexer,
      node,
      {
        FpOperation.Times,
        FpOperation.DivideBy,
        FpOperation.Div,
        FpOperation.Mod,
      },
    );

    // Plus/Minus/Concatenate
    node = _gatherPrecedence(
      lexer,
      node,
      {FpOperation.Plus, FpOperation.Minus, FpOperation.Concatenate},
    );

    node = _gatherPrecedence(
      lexer,
      node,
      {
        FpOperation.Is,
        FpOperation.As,
      },
    );

    // Union
    node = _gatherPrecedence(lexer, node, {FpOperation.Union});
    // <, >, <=, >=
    node = _gatherPrecedence(
      lexer,
      node,
      {
        FpOperation.LessThan,
        FpOperation.Greater,
        FpOperation.LessOrEqual,
        FpOperation.GreaterOrEqual,
      },
    );
    // =, ~, !=, !~
    node = _gatherPrecedence(
      lexer,
      node,
      {
        FpOperation.Equals,
        FpOperation.Equivalent,
        FpOperation.NotEquals,
        FpOperation.NotEquivalent,
      },
    );
    // in, contains, memberOf — bind tighter than the logical operators
    // (Java reference organisePrecedence; official testPrecedence5/6:
    // `true and X in Y` is `true and (X in Y)`).
    node = _gatherPrecedence(
      lexer,
      node,
      {FpOperation.In, FpOperation.Contains, FpOperation.MemberOf},
    );
    // and
    node = _gatherPrecedence(lexer, node, {FpOperation.And});
    // xor, or
    node = _gatherPrecedence(lexer, node, {FpOperation.Xor, FpOperation.Or});
    // implies
    node = _gatherPrecedence(lexer, node, {FpOperation.Implies});

    return node;
  }

// Mirror the Java gatherPrecedence
  ExpressionNode _gatherPrecedence(
    FHIRLexer lexer,
    ExpressionNode oldStart,
    Set<FpOperation> ops,
  ) {
    // Must be proximal in the chain
    assert(oldStart.proximal, 'Start must be proximal');
    var start = oldStart;

    // 1) Determine if we need to group anything
    var focus = start.opNext;
    var work = false;
    if (ops.contains(start.operation) &&
        start.kind != ExpressionNodeKind.unary) {
      // If the start node's operator is in 'ops', grouping might be needed
      while (focus != null && focus.operation != null) {
        work = work || !ops.contains(focus.operation);
        focus = focus.opNext;
      }
    } else {
      // Otherwise grouping is needed if we see an operator in 'ops'
      while (focus != null && focus.operation != null) {
        work = work ||
            (ops.contains(focus.operation) &&
                focus.kind != ExpressionNodeKind.unary);
        focus = focus.opNext;
      }
    }
    if (!work) {
      // no changes
      return start;
    }

    // 2) Possibly create a new group at the start
    ExpressionNode group;
    if (ops.contains(start.operation) &&
        start.kind != ExpressionNodeKind.unary) {
      group = _newGroup(lexer, start)..proximal = true;
      focus = start;
      start = group;
    } else {
      var node = start;
      focus = node.opNext;
      // skip over unary or irrelevant operators
      while (focus != null) {
        if (focus.kind == ExpressionNodeKind.unary) {
          node = focus;
          focus = focus.opNext;
          continue;
        }
        if (focus.operation == null || !ops.contains(focus.operation)) {
          node = focus;
          focus = focus.opNext;
        } else {
          // found a matching operator
          break;
        }
      }
      if (focus == null) {
        return start; // no grouping needed
      }
      group = _newGroup(lexer, focus);
      node.opNext = group;
    }

    // 3) Grouping loop
    do {
      // (A) skip unary nodes
      while (focus != null && focus.kind == ExpressionNodeKind.unary) {
        focus = focus.opNext;
      }
      // (B) skip consecutive ops in 'ops'
      while (focus != null &&
          focus.operation != null &&
          ops.contains(focus.operation) &&
          focus.kind != ExpressionNodeKind.unary) {
        focus = focus.opNext;
      }
      // (C) if there's still an operator, attach it
      if (focus != null &&
          focus.operation != null &&
          focus.kind != ExpressionNodeKind.unary) {
        group
          ..operation = focus.operation
          ..opNext = focus.opNext;
        focus
          ..operation = null
          ..opNext = null;

        var node = group;
        focus = group.opNext;

        // (D) possibly chain more groups
        if (focus != null) {
          while (focus != null &&
              (focus.kind == ExpressionNodeKind.unary ||
                  !ops.contains(focus.operation))) {
            node = focus;
            focus = focus.opNext;
          }
          if (focus != null) {
            group = _newGroup(lexer, focus);
            node.opNext = group;
          }
        }
      }
    } while (focus != null && focus.operation != null);

    return start;
  }

  // Mirror the Java newGroup
  ExpressionNode _newGroup(FHIRLexer lexer, ExpressionNode? next) {
    final result = ExpressionNode(lexer.nextId().toString())
      ..kind = ExpressionNodeKind.group
      ..group = next;
    if (next != null) {
      next.proximal = true;
    }
    return result;
  }

  ///
  /// ***************************************
  /// CORE EVALUATION METHODS
  /// ***************************************
  ///
  /// Evaluation with base and ExpressionNode
  Future<List<FhirNode>> evaluate(FhirNode? base, ExpressionNode node) async {
    final list = <FhirNode>[];
    if (base != null) {
      list.add(base);
    }
    fpLog.clear();
    final context = ExecutionContext(
      // FhirNode.isResource — the contract's equivalent of the Java
      // reference's Base.isResource().
      focusResource: base != null && base.isResource ? base : null,
      rootResource: base != null && base.isResource ? base : null,
      context: base,
      thisItem: base,
    );
    return execute(context, list, node, true);
  }

  // Evaluation with base and FHIRPath expression (String)
  Future<List<FhirNode>> evaluateFromPath(FhirNode? base, String path) async {
    final node = parse(path); // Assume `parse` is implemented
    return evaluate(base, node);
  }

  Future<String> evaluateToString(
    Object appInfo,
    FhirNode? focusResource,
    FhirNode? rootResource,
    FhirNode base,
    ExpressionNode node,
  ) async {
    return utilities.convertListToString(
      await evaluateWithContext(
        appInfo,
        focusResource,
        rootResource,
        base,
        node,
      ),
    );
  }

  Future<bool> evaluateToBoolean(
    Object appInfo,
    FhirNode? focusResource,
    FhirNode? rootResource,
    FhirNode base,
    ExpressionNode node,
  ) async {
    return utilities.convertToBoolean(
      await evaluateWithContext(
        appInfo,
        focusResource,
        rootResource,
        base,
        node,
      ),
    );
  }

  // Evaluation with appContext and additional parameters
  Future<List<FhirNode>> evaluateWithContext(
    Object? appContext,
    FhirNode? focusResource,
    FhirNode? rootResource,
    FhirNode? base,
    ExpressionNode node, {
    Map<String, dynamic>? environment,
  }) async {
    final list = <FhirNode>[];
    if (base != null) {
      list.add(base);
    }
    fpLog.clear();
    final context = ExecutionContext(
      appInfo: appContext,
      focusResource: focusResource,
      rootResource: rootResource,
      context: base,
      thisItem: base,
    )..definedVariables = environment;

    return execute(context, list, node, true);
  }

  // Evaluation with appContext and path (String)
  Future<List<FhirNode>> evaluateWithPath(
    Object? appContext,
    FhirNode? focusResource,
    FhirNode? rootResource,
    FhirNode? base,
    String path,
  ) async {
    final node = parse(path); // Assume `parse` is implemented
    return evaluateWithContext(
      appContext,
      focusResource,
      rootResource,
      base,
      node,
    );
  }

  Future<TypeDetails> evaluateFunctionType(
    ExecutionTypeContext context,
    TypeDetails focus,
    ExpressionNode exp,
  ) async {
    final paramTypes = <TypeDetails>[];
    if (exp.function == FpFunction.Is ||
        exp.function == FpFunction.As ||
        exp.function == FpFunction.OfType) {
      paramTypes.add(
        TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
      );
    } else {
      var i = 0;
      for (final expr in exp.parameters) {
        if (isExpressionParameter(exp, i)) {
          paramTypes.add(
            await executeType(
              changeThisTypeContext(context, focus),
              focus,
              expr,
              true,
            ),
          );
        } else {
          paramTypes
              .add(await executeType(context, context.thisItem, expr, true));
        }
        i++;
      }
    }

    switch (exp.function) {
      case FpFunction.Empty:
      case FpFunction.Not:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Exists:
      case FpFunction.SubsetOf:
      case FpFunction.SupersetOf:
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [focus],
        );
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.IsDistinct:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Distinct:
        return focus;
      case FpFunction.Count:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Integer],
        );
      case FpFunction.Where:
      case FpFunction.Select:
      case FpFunction.Repeat:
      case FpFunction.Aggregate:
        return anything(focus.collectionStatus);
      case FpFunction.Sort:
        return TypeDetails(CollectionStatus.ordered, focus.getTypes().toList());
      case FpFunction.All:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Item:
        checkOrdered(focus, 'item', exp);
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Integer]),
          ],
        );
        return focus;
      case FpFunction.As:
      case FpFunction.OfType:
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
          ],
        );
        return TypeDetails(
          CollectionStatus.singleton,
          exp.parameters.isEmpty || exp.parameters.first.name == null
              ? []
              : [exp.parameters.first.name!],
        );
      case FpFunction.Type:
        var hasSystemType = false;
        var hasCustomType = false;
        for (final pt in focus.types) {
          hasSystemType = hasSystemType || pt.isSystemType();
          hasCustomType = hasCustomType || !pt.isSystemType();
        }
        if (hasSystemType && hasCustomType) {
          return TypeDetails(
            CollectionStatus.singleton,
            [TypeDetails.FP_SimpleTypeInfo, TypeDetails.FP_ClassInfo],
          );
        } else if (hasSystemType) {
          return TypeDetails(
            CollectionStatus.singleton,
            [TypeDetails.FP_SimpleTypeInfo],
          );
        } else {
          return TypeDetails(
            CollectionStatus.singleton,
            [TypeDetails.FP_ClassInfo],
          );
        }
      case FpFunction.Is:
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
          ],
        );
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Single:
        return focus.toSingleton();
      case FpFunction.First:
      case FpFunction.Last:
        checkOrdered(focus, exp.function.toString(), exp);
        return focus.toSingleton();
      case FpFunction.Tail:
      case FpFunction.Skip:
      case FpFunction.Take:
        checkOrdered(focus, exp.function.toString(), exp);
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Integer]),
          ],
        );
        return focus;
      case FpFunction.Union:
      case FpFunction.Combine:
        return focus.union(paramTypes.first);
      case FpFunction.Intersect:
        return focus.intersect(paramTypes.first);
      case FpFunction.Exclude:
        return focus;
      case FpFunction.Iif:
        final types = TypeDetails(null);
        checkSingleton(focus, 'iif', exp);
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Boolean]),
          ],
        );
        types.update(paramTypes[1]);
        if (paramTypes.length > 2) {
          types.update(paramTypes[2]);
        }
        return types;
      case FpFunction.Lower:
      case FpFunction.Upper:
      case FpFunction.ToChars:
        await checkContextString(focus, exp.function.toString(), exp, true);
        return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]);
      case FpFunction.IndexOf:
      case FpFunction.Substring:
      case FpFunction.StartsWith:
      case FpFunction.EndsWith:
      case FpFunction.Matches:
      case FpFunction.MatchesFull:
      case FpFunction.ReplaceMatches:
      case FpFunction.Contains:
      case FpFunction.Replace:
        await checkContextString(focus, exp.function.toString(), exp, true);
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
          ],
        );
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Length:
        checkContextPrimitive(focus, 'length', false, exp);
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Integer],
        );
      case FpFunction.Children:
      case FpFunction.Descendants:
        return childTypes(focus, exp.function.toString(), exp);
      case FpFunction.MemberOf:
        await checkContextCoded(focus, 'memberOf', exp);
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
          ],
        );
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpFunction.Trace:
      case FpFunction.DefineVariable:
      case FpFunction.Check:
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.unordered, [TypeDetails.FP_String]),
          ],
        );
        return focus;
      case FpFunction.Today:
      case FpFunction.Now:
      case FpFunction.TimeOfDay:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_DateTime],
        );
      case FpFunction.Resolve:
        await checkContextReference(focus, 'resolve', exp);
        return TypeDetails(CollectionStatus.singleton, ['DomainResource']);
      case FpFunction.Extension:
        await checkParamTypes(
          exp,
          exp.function.toString(),
          paramTypes,
          [
            TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]),
          ],
        );
        return TypeDetails(CollectionStatus.singleton, ['Extension']);
      case FpFunction.ToInteger:
      case FpFunction.ToDecimal:
      case FpFunction.ToString:
      case FpFunction.ToQuantity:
      case FpFunction.ToBoolean:
        checkContextPrimitive(focus, exp.function.toString(), true, exp);
        return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]);
      case FpFunction.ToDateTime:
      case FpFunction.ToDate:
      case FpFunction.ToTime:
        checkContextPrimitive(focus, exp.function.toString(), false, exp);
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_DateTime],
        );
      case FpFunction.Custom:
        if (fpContext.hostServices == null) {
          throw fpContext.makeException(
            exp,
            'FHIRPATH_NO_HOST_SERVICES',
            ['Custom Function'],
          );
        }
        return fpContext.hostServices!.checkFunction(
          this,
          context.appInfo,
          exp.name ?? 'custom',
          focus,
          paramTypes,
        );
      case null:
      case FpFunction.AllFalse:
      case FpFunction.AnyFalse:
      case FpFunction.AllTrue:
      case FpFunction.AnyTrue:
      case FpFunction.HasValue:
      case FpFunction.IsBoolean:
      case FpFunction.ConvertsToBoolean:
      case FpFunction.IsInteger:
      case FpFunction.ConvertsToInteger:
      case FpFunction.IsString:
      case FpFunction.ConvertsToString:
      case FpFunction.IsDecimal:
      case FpFunction.ConvertsToDecimal:
      case FpFunction.IsQuantity:
      case FpFunction.ConvertsToQuantity:
      case FpFunction.IsDateTime:
      case FpFunction.ConvertsToDateTime:
      case FpFunction.IsDate:
      case FpFunction.ConvertsToDate:
      case FpFunction.IsTime:
      case FpFunction.ConvertsToTime:
      case FpFunction.ConformsTo:
      case FpFunction.Round:
      case FpFunction.Sqrt:
      case FpFunction.Abs:
      case FpFunction.Ceiling:
      case FpFunction.Exp:
      case FpFunction.Floor:
      case FpFunction.Ln:
      case FpFunction.Log:
      case FpFunction.Power:
      case FpFunction.Sum:
      case FpFunction.Truncate:
      case FpFunction.Encode:
      case FpFunction.Decode:
      case FpFunction.Escape:
      case FpFunction.Unescape:
      case FpFunction.Trim:
      case FpFunction.Split:
      case FpFunction.Join:
      case FpFunction.LowBoundary:
      case FpFunction.HighBoundary:
      case FpFunction.Precision:
      case FpFunction.HtmlChecks1:
      case FpFunction.HtmlChecks2:
      case FpFunction.Comparable:
      case FpFunction.HasTemplateIdOf:
        throw UnimplementedError();
    }
  }

  ///
  /// ***************************************
  /// CORE EXECUTION FUNCTIONS
  /// ***************************************
  ///
  /// Core method to execute evaluation logic
  Future<List<FhirNode>> execute(
    ExecutionContext inContext,
    List<FhirNode> focus,
    ExpressionNode exp,
    bool atEntry,
  ) async {
    // Acquire context for special variables ($this, $total, $index, etc.)
    var context = contextForParameter(inContext);

    // This will hold the evaluated results for the current node
    var work = <FhirNode>[];

    // Main switch to evaluate this node based on its kind
    switch (exp.kind) {
      case ExpressionNodeKind.unary:
        // Evaluate the operand first
        if (exp.opNext != null) {
          // Evaluate operand in non-proximal mode (the unary node is the
          // 'proximal' context)
          // If the operand has operators, we need to evaluate just the base
          //expression first,
          // then apply unary, then evaluate operators on the result
          final operand = exp.opNext!;
          final hadOperators = operand.proximal && operand.operation != null;

          List<FhirNode> operandResult;
          if (hadOperators) {
            // Create a temporary node without operators to evaluate just the
            //base expression
            final baseNode = ExpressionNode('${operand.uniqueId}_base')
              ..kind = operand.kind
              ..name = operand.name
              ..constant = operand.constant
              ..function = operand.function
              ..parameters = operand.parameters
              ..inner = operand.inner
              ..group = operand.group
              ..proximal = false;
            operandResult = await execute(context, focus, baseNode, false);
          } else {
            operandResult = await execute(context, focus, operand, false);
          }

          // Now apply the unary operation. Negation is exact on the decimal
          // STRING (sign flip; scale preserved; no negative zero), matching
          // the Java reference's BigDecimal arithmetic — see
          // utilities.negateDecimalString. Integer kinds negate as Dart ints
          // (exact), yielding an `integer` result like the reference's
          // 0 - x numeric path.
          if (exp.operation == FpOperation.Minus) {
            final negValues = <FhirNode>[];
            for (final val in operandResult) {
              if (val.fhirType == 'decimal') {
                negValues.add(
                  fpContext.factory.decimalFromString(
                    utilities.negateDecimalString(val.primitiveValue ?? '0'),
                    disallowExtensions: false,
                  ),
                );
              } else if (utilities.isNumericNode(val)) {
                negValues.add(
                  fpContext.factory.integer(
                    -(utilities.nodeNum(val) ?? 0).toInt(),
                    disallowExtensions: false,
                  ),
                );
              } else if (utilities.isQuantityNode(val)) {
                final v = val.getChildByName('value')?.primitiveValue;
                negValues.add(
                  fpContext.factory.quantityWithValueString(
                    val,
                    v == null ? null : utilities.negateDecimalString(v),
                  ),
                );
              } else {
                throw PathEngineException('Unary minus not supported on $val');
              }
            }
            work.addAll(negValues);
          } else if (exp.operation == FpOperation.Plus) {
            // Unary plus: no-op
            work.addAll(operandResult);
          } else {
            throw PathEngineException(
              'Unsupported unary operator: ${exp.operation}',
            );
          }

          // If the operand had operators, we need to evaluate them on the
          // result
          if (hadOperators) {
            // Evaluate the operators on the result of the unary operation
            // The operators are on the operand, so we need to evaluate them
            // with work as focus
            var opNode = operand;
            while (opNode.operation != null && opNode.opNext != null) {
              // Get the right-hand side
              final rhs = await execute(context, focus, opNode.opNext!, false);
              // Apply the operation
              work = await operations.operate(
                context,
                work,
                opNode.operation,
                rhs,
                opNode,
              );
              // Move to next operation
              opNode = opNode.opNext!;
              // Skip unary nodes
              while (opNode.kind == ExpressionNodeKind.unary &&
                  opNode.opNext != null) {
                opNode = opNode.opNext!;
              }
            }
          }
        } else {
          // If no operand, decide how to handle (e.g. 0, or throw an error)
          // Java reference: a Unary node evaluates to IntegerType(0); the
          // operator chain then applies 0 - x / 0 + x.
          work.add(fpContext.factory.integer(0, disallowExtensions: false));
        }
        // Nullify the unary operation so it's not re-applied in the proximal
        // loop
        exp.operation = null;

      case ExpressionNodeKind.name:
        // Handle a named reference
        if (atEntry && exp.name == r'$this') {
          work.add(context.thisItem!);
        } else if (atEntry && exp.name == r'$total') {
          work.addAll(context.total ?? []);
        } else if (atEntry && exp.name == r'$index') {
          work.add(
            fpContext.factory.integer(context.index, disallowExtensions: false),
          );
        } else {
          for (final item in focus) {
            final outcome =
                await executeForItem(context, item, exp, atEntry: true);

            work.addAll(outcome);
          }
        }

      case ExpressionNodeKind.function:
        // Evaluate a function call
        work.addAll(await functions.evaluateFunction(context, focus, exp));

      case ExpressionNodeKind.constant:
        // Evaluate a literal constant
        final constants = functions.resolveConstantWithBase(
          context,
          exp.constant,
          false,
          exp,
          true,
        );

        work.addAll(constants);

      case ExpressionNodeKind.group:
        // Evaluate the sub-expression inside the group
        work.addAll(await execute(context, focus, exp.group!, atEntry));

      case null:
        // No node kind: do nothing or throw
        break;
    }

    // If there's an inner expression (dot or bracket indexing), evaluate that
    // next
    if (exp.inner != null) {
      work = await execute(context, work, exp.inner!, false);
    }

    // If the node is proximal and has an operation, evaluate the chain of
    // operations
    if (exp.proximal && exp.operation != null) {
      var next = exp.opNext;
      var last = exp;

      while (next != null) {
        // If the last node was a unary node, we skip its operand, which is next
        // because unary already consumed 'next' as its single operand
        if (last.kind == ExpressionNodeKind.unary) {
          next = next.opNext; // skip the operand
          if (next == null) {
            break;
          }
        }

        // If there's no operation on 'last', we've exhausted the chain
        if (last.operation == null) {
          break;
        }

        // Re-fetch context for each operation
        context = contextForParameter(inContext);

        // Optional pre-operation logic
        var work2 = operations.preOperate(work, last.operation, exp);

        if (work2 != null) {
          // If preOperate returns a value, use it
          work = work2;
        } else if (last.operation == FpOperation.Is ||
            last.operation == FpOperation.As) {
          // Evaluate a type check or cast
          work2 = await executeContextTypeName(context, focus, next, false);
          work = await operations.operate(
            context,
            work,
            last.operation,
            work2,
            last,
          );
        } else {
          // Evaluate the 'next' node, then apply the operation

          work2 = await execute(context, focus, next, true);
          work = await operations.operate(
            context,
            work,
            last.operation,
            work2,
            last,
          );
        }

        // Move on to the next operation
        last = next;
        next = next.opNext;
      }
    }

    return work;
  }

  Future<List<FhirNode>> executeForItem(
    ExecutionContext context,
    FhirNode item,
    ExpressionNode exp, {
    required bool atEntry,
  }) async {
    final result = <FhirNode>[];
    // Step 1: Resolve constants if at entry
    if (atEntry && context.appInfo != null && fpContext.hostServices != null) {
      final temp = fpContext.hostServices!
          .resolveConstant(this, context.appInfo, exp.name, true, false);

      if (temp.isNotEmpty) {
        result.addAll(temp);
        return result;
      }
    }

    // Step 2: Special case for type checks
    if (atEntry &&
        exp.name != null &&
        exp.name!.isNotEmpty &&
        exp.name![0].toUpperCase() == exp.name![0]) {
      // Handle constant items
      if (item.isPrimitive) {
        final itemType = item.fhirType;

        if (itemType == exp.name) {
          result.add(item);
          return result;
        }
      }

      // Handle resources: match when the item's type is, or descends from,
      // the named type (the logical-model case falls out of the identity check
      // inside isSubtypeOf).
      if (await fpContext.worker.isSubtypeOf(item.fhirType, exp.name!)) {
        result.add(item);
      }
    } else {
      // Step 3: Default case - Get children by name
      getChildrenByName(item, exp.name!, result);
    }

    // Step 4: Fallback to resolve constants if result is empty
    if (atEntry &&
        context.appInfo != null &&
        fpContext.hostServices != null &&
        result.isEmpty) {
      result.addAll(
        fpContext.hostServices!
            .resolveConstant(this, context.appInfo, exp.name, false, false),
      );
    }
    return result;
  }

  Future<TypeDetails> executeType(
    dynamic contextOrType, // Can be String or ExecutionTypeContext
    dynamic focusOrExp, // Can be TypeDetails or ExpressionNode
    ExpressionNode exp,
    bool atEntry,
  ) async {
    // Determine whether the first parameter is a String or ExecutionTypeContext
    if (contextOrType is String && focusOrExp is ExpressionNode) {
      // Handle the first function's logic
      final type = contextOrType;
      final expression = focusOrExp;

      if (atEntry &&
          expression.name != null &&
          expression.name!.isNotEmpty &&
          expression.name![0].isUpperCase() &&
          type.hashTail() == expression.name) {
        // Special case for start up
        return TypeDetails(CollectionStatus.singleton, [type]);
      }

      final result = TypeDetails(null);
      await fpContext.worker.getChildTypesByName(
        type,
        expression.name!,
        result,
        expression,
        allowPolymorphicNames: fpContext.allowPolymorphicNames,
      );
      return result;
    } else if (contextOrType is ExecutionTypeContext &&
        focusOrExp is TypeDetails?) {
      // Handle the second function's logic
      var context = typeContextForParameter(contextOrType);
      final focus = focusOrExp;
      TypeDetails? result = TypeDetails(null);

      switch (exp.kind) {
        case ExpressionNodeKind.name:
          if (atEntry && exp.name == r'$this') {
            if (context.thisItem == null) {
              throw fpContext.makeException(exp, 'FHIRPATH_NO_THIS', ['']);
            }
            result.update(context.thisItem!);
          } else if (atEntry && exp.name == r'$total') {
            result.update(anything(CollectionStatus.unordered));
          } else if (atEntry && exp.name == r'$index') {
            result.addType(TypeDetails.FP_Integer);
          } else if (atEntry && focus == null) {
            result.update(executeContextType(context, exp.name!, exp, false));
          } else {
            for (final s in focus?.types ?? <String>[]) {
              result.update(await executeType(s, null, exp, atEntry));
            }
            if (result.hasNoTypes()) {
              throw fpContext.makeException(exp, 'FHIRPATH_UNKNOWN_NAME', [
                exp.name ?? '',
                focus?.describe() ?? '',
              ]);
            }
          }

        case ExpressionNodeKind.function:
          if (focus == null) {
            throw fpContext.makeException(exp, 'FHIRPATH_NO_FOCUS', ['']);
          }
          result.update(await evaluateFunctionType(context, focus, exp));

        case ExpressionNodeKind.unary:
          result
            ..addType(TypeDetails.FP_Integer)
            ..addType(TypeDetails.FP_Decimal)
            ..addType(TypeDetails.FP_Quantity);

        case ExpressionNodeKind.constant:
          result.update(resolveConstantType(context, exp.constant, exp, true));

        case ExpressionNodeKind.group:
          result.update(await executeType(context, focus, exp.group!, atEntry));
        case null:
          throw ArgumentError('Invalid arguments passed to executeType');
      }

      exp.types = result;

      if (exp.inner != null) {
        result = await executeType(context, result, exp.inner!, false);
      }

      if (exp.proximal && exp.operation != null) {
        var next = exp.opNext;
        var last = exp;
        while (next != null) {
          context = typeContextForParameter(contextOrType);
          TypeDetails work;

          if (last.operation == FpOperation.Is ||
              last.operation == FpOperation.As) {
            if (focus == null) {
              throw fpContext.makeException(exp, 'FHIRPATH_NO_FOCUS', ['']);
            }
            work = executeTypeContextTypeName(context, focus, next, atEntry);
          } else {
            work = await executeType(context, focus, next, atEntry);
          }
          if (result == null) {
            throw ArgumentError('result is null');
          }
          result = await operateTypes(result, last.operation!, work, last);
          last = next;
          next = next.opNext;
        }
        exp.opTypes = result;
      }
      if (result == null) {
        throw ArgumentError('result is null');
      }
      return result;
    } else {
      throw ArgumentError('Invalid arguments passed to executeType');
    }
  }

  TypeDetails executeContextType(
    ExecutionTypeContext context,
    String name,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    if (fpContext.hostServices == null) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_NO_HOST_SERVICES',
        ['Context Reference'],
      );
    }
    return fpContext.hostServices!
        .resolveConstantType(this, context.appInfo, name, explicitConstant);
  }

  Future<List<FhirNode>> executeContextTypeName(
    ExecutionContext context,
    List<FhirNode> focus,
    ExpressionNode next,
    bool atEntry,
  ) async {
    final result = <FhirNode>[];

    if (next.inner != null) {
      // Handle inner nodes by constructing the fully qualified name
      result.add(
        fpContext.factory.string(
          '${next.name}.${next.inner!.name}',
          disallowExtensions: false,
        ),
      );
    } else if (next.name != null) {
      // Handle nodes with a name
      result
          .add(fpContext.factory.string(next.name, disallowExtensions: false));
    } else if (next.kind == ExpressionNodeKind.group) {
      // Process group nodes recursively

      result.addAll(await execute(context, focus, next.group!, atEntry));
    }

    return result;
  }

  TypeDetails executeTypeContextTypeName(
    ExecutionTypeContext context,
    TypeDetails focus,
    ExpressionNode exp,
    bool atEntry,
  ) {
    return TypeDetails(
      CollectionStatus.singleton,
      exp.name == null ? <String>[] : [exp.name!],
    );
  }

  /// Static type-analysis entry point. [structureDefinition], when supplied,
  /// must be a `StructureDefinition` resource node of the bound FHIR model;
  /// the engine reads only its canonical `url` and passes it opaquely to the
  /// worker's type queries.
  Future<TypeDetails> check(
    Object appContext, {
    String? resourceType,
    FhirNode? structureDefinition,
    String? context,
    ExpressionNode? expressionNode,
    String? expressionString,
  }) async {
    if (expressionString != null && resourceType != null && context != null) {
      // Case 4: resourceType, context, and expressionString provided
      return check(
        appContext,
        resourceType: resourceType,
        context: context,
        expressionNode: parse(expressionString),
      );
    } else if (structureDefinition != null && expressionNode != null) {
      if (context != null) {
        // Case 2: structureDefinition, context, and expressionNode provided
        TypeDetails types;
        if (!context.contains('.')) {
          types = TypeDetails(
            CollectionStatus.singleton,
            [_sdUrl(structureDefinition)],
          );
        } else {
          final resolved = await fpContext.worker.resolveContextTypeDetails(
            structureDefinition,
            context,
            _sdUrl(structureDefinition),
            expressionNode,
          );
          if (resolved == null) {
            throw fpContext.makeException(
              expressionNode,
              'FHIRPATH_UNKNOWN_CONTEXT_ELEMENT',
              [context],
            );
          }
          types = resolved;
        }
        return executeType(
          ExecutionTypeContext(
            appContext,
            _sdUrl(structureDefinition),
            types,
            types,
          ),
          types,
          expressionNode,
          true,
        );
      } else {
        // Case 3: structureDefinition and expressionNode provided
        return executeType(
          ExecutionTypeContext(
            appContext,
            _sdUrl(structureDefinition),
            null,
            null,
          ),
          null,
          expressionNode,
          true,
        );
      }
    } else if (resourceType != null &&
        context != null &&
        expressionNode != null) {
      // Case 1: resourceType, context, and expressionNode provided
      TypeDetails? types;
      if (!context.contains('.')) {
        final url = await fpContext.worker.typeCanonicalUrl(context);
        if (url == null) {
          throw PathEngineException('Unknown type definition: $context');
        }
        types = TypeDetails(CollectionStatus.singleton, [url]);
      } else {
        var ctxt = context.substring(0, context.indexOf('.'));
        if (resourceType.isAbsoluteUrl()) {
          ctxt =
              '${resourceType.substring(0, resourceType.lastIndexOf('/') + 1)}'
              '$ctxt';
        }
        final sd = await fpContext.worker.fetchTypeDefinitionByUrl(ctxt);
        if (sd == null) {
          throw fpContext
              .makeException(expressionNode, 'Unknown context: $context', []);
        }
        final resolved = await fpContext.worker.resolveContextTypeDetails(
          sd,
          context,
          ctxt,
          expressionNode,
        );
        if (resolved == null) {
          throw fpContext.makeException(
            expressionNode,
            'Unknown context element: ',
            [context],
          );
        }
        types = resolved;
      }
      return executeType(
        ExecutionTypeContext(appContext, resourceType, types, types),
        types,
        expressionNode,
        true,
      );
    } else {
      throw ArgumentError(
        'Insufficient or incorrect arguments provided to the check method.',
      );
    }
  }

  TypeDetails resolveConstantType(
    ExecutionTypeContext context,
    dynamic constant,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    if (constant is FhirNode && constant.fhirType == 'boolean') {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Boolean]);
    } else if (constant is FhirNode && constant.fhirType == 'integer') {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Integer]);
    } else if (constant is FhirNode && constant.fhirType == 'decimal') {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Decimal]);
    } else if (constant is FhirNode && constant.fhirType == 'Quantity') {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Quantity]);
    } else if (constant is FHIRConstant) {
      return resolveConstantType(
        context,
        constant.value,
        expr,
        explicitConstant,
      );
    } else if (constant == null) {
      return TypeDetails(CollectionStatus.singleton);
    } else if (constant is String) {
      return resolveStringConstantType(
        context,
        constant,
        expr,
        explicitConstant,
      );
    } else {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]);
    }
  }

  TypeDetails resolveStringConstantType(
    ExecutionTypeContext context,
    String s,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    if (s.startsWith('@')) {
      if (s.startsWith('@T')) {
        return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_Time]);
      } else {
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_DateTime],
        );
      }
    } else if (s == '%sct' ||
        s == '%loinc' ||
        s == '%ucum' ||
        s == '%map-codes' ||
        s == '%us-zip' ||
        s.startsWith('%`vs-') ||
        s.startsWith('%`cs-') ||
        s.startsWith('%`ext-')) {
      return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]);
    } else if (s == '%resource') {
      if (context.resource == null) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_CANNOT_USE',
          ['%resource', 'no focus resource'],
        );
      }
      return TypeDetails(
        CollectionStatus.singleton,
        context.resource == null ? <String>[] : [context.resource!],
      );
    } else if (s == '%rootResource') {
      if (context.resource == null) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_CANNOT_USE',
          [
            '%rootResource',
            'no focus resource',
          ],
        );
      }
      return TypeDetails(
        CollectionStatus.singleton,
        context.resource == null ? <String>[] : [context.resource!],
      );
    } else if (s == '%context') {
      return context.context!;
    } else {
      return resolveVariableOrHostService(context, s, expr, explicitConstant);
    }
  }

  TypeDetails resolveVariableOrHostService(
    ExecutionTypeContext context,
    String s,
    ExpressionNode expr,
    bool explicitConstant,
  ) {
    final varName = s.substring(1);
    if (context.hasDefinedVariable(varName)) {
      return context.getDefinedVariable(varName)!;
    } else if (fpContext.hostServices != null) {
      return fpContext.hostServices!
          .resolveConstantType(this, context.appInfo, s, explicitConstant);
    } else {
      throw fpContext.makeException(expr, 'FHIRPATH_UNKNOWN_CONSTANT', [s]);
    }
  }

  Future<TypeDetails> childTypes(
    TypeDetails focus,
    String mask,
    ExpressionNode expr,
  ) async {
    final result = TypeDetails(CollectionStatus.unordered);
    for (final f in focus.getTypes()) {
      await fpContext.worker.getChildTypesByName(
        f,
        mask,
        result,
        expr,
        allowPolymorphicNames: fpContext.allowPolymorphicNames,
      );
    }
    return result;
  }

  TypeDetails anything(CollectionStatus? status) {
    return TypeDetails(status, fpContext.allTypeNames.toList());
  }

  ///
  /// ***************************************
  /// CHILD AND CONTEXT HANDLING
  /// ***************************************
  ///
  void getChildrenByName(FhirNode item, String oldName, List<FhirNode> result) {
    if (oldName == '*') {
      for (final child in item.listChildrenNames()) {
        result.addAll(item.getChildrenByName(child));
      }
    } else {
      String? tn;
      var name = oldName;

      if (fpContext.allowPolymorphicNames) {
        // we'll look to see whether we have a polymorphic name
        for (final p in item.listChildrenNames()) {
          if (p.endsWith('X')) {
            final n = p.substring(0, p.length - 1);
            if (name.startsWith(n)) {
              tn = name.substring(n.length);
              name = n;
              break;
            }
          }
        }
      }

      final list = item.getChildrenByName(name);
      if (list.isNotEmpty) {
        for (final v in list) {
          if (tn == null || tn.isEmpty || v.fhirType.equalsIgnoreCase(tn)) {
            result.add(v);
          }
        }
      }
    }
  }

  ExecutionContext contextForParameter(ExecutionContext context) {
    final newContext = ExecutionContext(
      appInfo: context.appInfo,
      focusResource: context.focusResource,
      rootResource: context.rootResource,
      context: context.context,
      thisItem: context.thisItem,
    )
      ..total = context.total
      ..index = context.index;

    // append all of the defined variables from the context into the new context
    if (context.definedVariables != null) {
      for (final s in context.definedVariables!.keys) {
        newContext.setDefinedVariable(
          s,
          context.definedVariables![s],
          fpContext.worker,
        );
      }
    }
    return newContext;
  }

  ExecutionTypeContext typeContextForParameter(ExecutionTypeContext context) {
    final newContext = ExecutionTypeContext(
      context.appInfo,
      context.resource,
      context.context,
      context.thisItem,
    );
    // append all of the defined variables from the context into the new context
    if (context.definedVariables != null) {
      for (final s in context.definedVariables!.keys) {
        newContext.setDefinedVariable(s, context.definedVariables![s]);
      }
    }
    return newContext;
  }

  ExecutionContext changeThisContext(
    ExecutionContext context,
    FhirNode newThis,
  ) {
    final newContext = context.copyWith(thisItem: newThis);
    // append all of the defined variables from the context into the new context
    if (context.definedVariables != null) {
      for (final s in context.definedVariables!.keys) {
        newContext.setDefinedVariable(
          s,
          context.definedVariables![s],
          fpContext.worker,
        );
      }
    }
    return newContext;
  }

  ExecutionTypeContext changeThisTypeContext(
    ExecutionTypeContext context,
    TypeDetails newThis,
  ) {
    final newContext = ExecutionTypeContext(
      context.appInfo,
      context.resource,
      context.context,
      newThis,
    );
    // append all of the defined variables from the context into the new context
    if (context.definedVariables != null) {
      for (final s in context.definedVariables!.keys) {
        newContext.setDefinedVariable(s, context.definedVariables![s]);
      }
    }
    return newContext;
  }

  ///
  /// ***************************************
  /// PROCESSING CONSTANTS
  /// ***************************************
  ///
  FhirNode? _processConstant(FHIRLexer lexer) {
    if (lexer.isStringConstant()) {
      return fpContext.factory
          .string(processConstantString(lexer.take(), lexer));
    } else if (lexer.current?.isInteger ?? false) {
      return fpContext.factory.integer(int.parse(lexer.take()));
    } else if (lexer.current?.isDecimal() ?? false) {
      // Preserve the literal's exact string form (see the unary path above).
      return fpContext.factory.decimalFromString(lexer.take());
    } else if (lexer.current?.existsInList({'true', 'false'}) ?? false) {
      return fpContext.factory.boolean(lexer.take() == 'true');
    } else if (lexer.current == '{}') {
      lexer.take();
      return null;
    } else if ((lexer.current?.startsWith('%') ?? false) ||
        (lexer.current?.startsWith('@') ?? false)) {
      return FHIRConstant(lexer.take());
    } else {
      throw lexer.error('Invalid Constant ${lexer.current}');
    }
  }

  String processConstantString(String s, FHIRLexer lexer) {
    final buffer = StringBuffer();
    var i = 1; // Start after the opening quote

    while (i < s.length - 1) {
      // Stop before the closing quote
      final ch = s[i];
      if (ch == r'\') {
        i++;
        if (i >= s.length - 1) {
          // Treat incomplete escape sequence as literal backslash
          buffer.write(r'\');
          break;
        }
        switch (s[i]) {
          case 't':
            buffer.write('\t');
          case 'r':
            buffer.write('\r');
          case 'n':
            buffer.write('\n');
          case 'f':
            buffer.write('\f');
          case "'":
            buffer.write("'");
          case '"':
            buffer.write('"');
          case '`':
            buffer.write('`');
          case r'\':
            buffer.write(r'\');
          case '/':
            buffer.write('/');
          case 'u':
            // Check for a complete Unicode sequence (\uXXXX)
            if (i + 4 < s.length - 1) {
              final unicodeValue =
                  int.tryParse(s.substring(i + 1, i + 5), radix: 16);
              if (unicodeValue != null) {
                buffer.write(String.fromCharCode(unicodeValue));
                i += 4; // Skip the Unicode sequence
              } else {
                // Ignore the backslash and the 'u' for invalid sequences
                buffer.write('u');
              }
            } else {
              // Ignore the backslash for incomplete sequences
              buffer.write('u');
            }
          default:
            // Ignore the backslash for unrecognized escape sequences
            buffer.write(s[i]);
        }
      } else {
        buffer.write(ch);
      }
      i++;
    }

    return buffer.toString();
  }

  ///
  /// ***************************************
  /// uTILITY AND HELPER METHODS
  /// ***************************************
  ///
  bool _checkParameters(
    FHIRLexer lexer,
    SourceLocation location,
    ExpressionNode exp,
    FunctionDetails? details,
  ) {
    switch (exp.function) {
      case FpFunction.Empty:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Not:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Exists:
        return checkParamCountBoundary(lexer, location, exp, 0, 1);
      case FpFunction.SubsetOf:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.SupersetOf:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.IsDistinct:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Distinct:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Count:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Where:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Select:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.All:
        return checkParamCountBoundary(lexer, location, exp, 0, 1);
      case FpFunction.Repeat:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Aggregate:
        return checkParamCountBoundary(lexer, location, exp, 1, 2);
      case FpFunction.Sort:
        return checkParamCountBoundary(lexer, location, exp, 0, 10);
      case FpFunction.Item:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.As:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.OfType:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Type:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Is:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Single:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.First:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Last:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Tail:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Skip:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Take:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Union:
        return checkParamCount(lexer, location, exp, 0, 1);
      case FpFunction.Combine:
        return checkParamCount(lexer, location, exp, 0, 1);
      case FpFunction.Intersect:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Exclude:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Iif:
        return checkParamCountBoundary(lexer, location, exp, 2, 3);
      case FpFunction.Lower:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Upper:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToChars:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IndexOf:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Substring:
        return checkParamCountBoundary(lexer, location, exp, 1, 2);
      case FpFunction.StartsWith:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.EndsWith:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Matches:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.MatchesFull:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.ReplaceMatches:
        return checkParamCount(lexer, location, exp, 2);
      case FpFunction.Contains:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Replace:
        return checkParamCount(lexer, location, exp, 2);
      case FpFunction.Length:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Children:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Descendants:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.MemberOf:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Trace:
        return checkParamCountBoundary(lexer, location, exp, 1, 2);
      case FpFunction.DefineVariable:
        return checkParamCountBoundary(lexer, location, exp, 1, 2);
      case FpFunction.Check:
        return checkParamCount(lexer, location, exp, 2);
      case FpFunction.Today:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.TimeOfDay:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Now:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Resolve:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Extension:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.AllFalse:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.AnyFalse:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.AllTrue:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.AnyTrue:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.HasValue:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Encode:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Decode:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Escape:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Unescape:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Trim:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Split:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Join:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.HtmlChecks1:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.HtmlChecks2:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Comparable:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.ToInteger:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToDecimal:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToString:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToQuantity:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToBoolean:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToDateTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToDate:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ToTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsInteger:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToInteger:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsDecimal:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToDecimal:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsString:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToString:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsQuantity:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToQuantity:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsBoolean:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToBoolean:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsDateTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToDateTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsDate:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToDate:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.IsTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConvertsToTime:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.ConformsTo:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Round:
        return checkParamCountBoundary(lexer, location, exp, 0, 1);
      case FpFunction.Sqrt:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Abs:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Ceiling:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Exp:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Floor:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Ln:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Log:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Power:
        return checkParamCount(lexer, location, exp, 1);
      case FpFunction.Sum:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Truncate:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.LowBoundary:
        return checkParamCountBoundary(lexer, location, exp, 0, 1);
      case FpFunction.HighBoundary:
        return checkParamCountBoundary(lexer, location, exp, 0, 1);
      case FpFunction.Precision:
        return checkParamCount(lexer, location, exp, 0);
      case FpFunction.Custom:
        return checkParamCountBoundary(
          lexer,
          location,
          exp,
          details?.getMinParameters(),
          details?.maxParameters,
        );
      case null:
      case FpFunction.HasTemplateIdOf:
        throw UnimplementedError();
    }
  }

  bool checkParamCount(
    FHIRLexer lexer,
    SourceLocation location,
    ExpressionNode exp,
    int count, [
    int? count2,
  ]) {
    if (exp.parameters.length == count ||
        (count2 != null && exp.parameters.length == count2)) {
      return true;
    } else {
      throw lexer
          .error('The function "${exp.name}" requires $count parameters');
    }
  }

  bool checkParamCountBoundary(
    FHIRLexer lexer,
    SourceLocation location,
    ExpressionNode exp,
    int? countMin,
    int? countMax,
  ) {
    if (countMin == null || countMax == null) {
      throw ArgumentError('countMin and countMax cannot be null');
    }
    if (exp.parameters.length < countMin || exp.parameters.length > countMax) {
      throw lexer
          .error('The function "${exp.name}" requires between $countMin and'
              ' $countMax parameters');
    }
    return true;
  }

  Future<void> checkParamTypes(
    ExpressionNode expr,
    String funcName,
    List<TypeDetails> paramTypes,
    List<TypeDetails> typeSet,
  ) async {
    var i = 0;
    for (final pt in typeSet) {
      if (i == paramTypes.length) {
        return;
      }
      final actual = paramTypes[i];
      i++;
      for (final a in actual.getTypes()) {
        if (!(await pt.hasTypeFromWorker(fpContext.worker, [a]))) {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_WRONG_PARAM_TYPE',
            [funcName, i, a, pt.toString()],
          );
        }
      }
    }
  }

  void checkOrdered(TypeDetails focus, String name, ExpressionNode expr) {
    if (focus.collectionStatus == CollectionStatus.unordered) {
      throw fpContext.makeException(expr, 'FHIRPATH_ORDERED_ONLY', [name]);
    }
  }

  void checkSingleton(TypeDetails focus, String name, ExpressionNode expr) {
    if (focus.collectionStatus != CollectionStatus.singleton) {
// ignore: lines_longer_than_80_chars
// typeWarnings.add(new IssueMessage(fpContext.worker.formatMessage(I18nConstants.FHIRPATH_COLLECTION_STATUS_CONTEXT, name, expr.toString()), I18nConstants.FHIRPATH_COLLECTION_STATUS_CONTEXT));
    }
  }

  bool isExpressionParameter(ExpressionNode exp, int i) {
    // Every sort() parameter is a per-item sort-key expression
    // (Java reference isExpressionParameter).
    if (exp.function == FpFunction.Sort) {
      return true;
    }
    switch (i) {
      case 0:
        return exp.function == FpFunction.Where ||
            exp.function == FpFunction.Exists ||
            exp.function == FpFunction.All ||
            exp.function == FpFunction.Select ||
            exp.function == FpFunction.Repeat ||
            exp.function == FpFunction.Aggregate;
      case 1:
        return exp.function == FpFunction.Trace ||
            exp.function == FpFunction.DefineVariable;
      default:
        return false;
    }
  }

  Future<TypeDetails?> operateTypes(
    TypeDetails left,
    FpOperation operation,
    TypeDetails right,
    ExpressionNode expr,
  ) async {
    switch (operation) {
      case FpOperation.Equals:
      case FpOperation.Equivalent:
      case FpOperation.NotEquals:
      case FpOperation.NotEquivalent:
      case FpOperation.LessThan:
      case FpOperation.Greater:
      case FpOperation.LessOrEqual:
      case FpOperation.GreaterOrEqual:
      case FpOperation.Is:
      case FpOperation.Or:
      case FpOperation.And:
      case FpOperation.Xor:
      case FpOperation.Implies:
      case FpOperation.In:
      case FpOperation.MemberOf:
      case FpOperation.Contains:
        return TypeDetails(
          CollectionStatus.singleton,
          [TypeDetails.FP_Boolean],
        );
      case FpOperation.As:
        return TypeDetails.profiledTypes(
          CollectionStatus.singleton,
          right.types,
        );
      case FpOperation.Union:
        return left.union(right);
      case FpOperation.Times:
        final result = TypeDetails(CollectionStatus.singleton);
        if ((await left.hasTypeFromWorker(fpContext.worker, ['integer'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['integer']))) {
          result.addType(TypeDetails.FP_Integer);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal'])) &&
            (await right
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal']))) {
          result.addType(TypeDetails.FP_Decimal);
        }
        return result;
      case FpOperation.DivideBy:
        final result = TypeDetails(CollectionStatus.singleton);
        if ((await left.hasTypeFromWorker(fpContext.worker, ['integer'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['integer']))) {
          result.addType(TypeDetails.FP_Decimal);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal'])) &&
            (await right
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal']))) {
          result.addType(TypeDetails.FP_Decimal);
        }
        return result;
      case FpOperation.Concatenate:
        return TypeDetails(CollectionStatus.singleton, [TypeDetails.FP_String]);
      case FpOperation.Plus:
        final result = TypeDetails(CollectionStatus.singleton);
        if ((await left.hasTypeFromWorker(fpContext.worker, ['integer'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['integer']))) {
          result.addType(TypeDetails.FP_Integer);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal'])) &&
            (await right
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal']))) {
          result.addType(TypeDetails.FP_Decimal);
        } else if ((await left.hasTypeFromWorker(
              fpContext.worker,
              ['string', 'id', 'code', 'uri'],
            )) &&
            (await right.hasTypeFromWorker(
              fpContext.worker,
              ['string', 'id', 'code', 'uri'],
            ))) {
          result.addType(TypeDetails.FP_String);
        } else if (await left.hasTypeFromWorker(
          fpContext.worker,
          ['date', 'dateTime', 'instant'],
        )) {
          if (await right.hasTypeFromWorker(fpContext.worker, ['Quantity'])) {
            result.addType(left.getType());
          } else {
            throw PathEngineException(
              'Error in date arithmetic: Unable to add type '
              '${right.getType()} to ${left.getType()}',
            );
          }
        }
        return result;
      case FpOperation.Minus:
        final result = TypeDetails(CollectionStatus.singleton);
        if ((await left.hasTypeFromWorker(fpContext.worker, ['integer'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['integer']))) {
          result.addType(TypeDetails.FP_Integer);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal'])) &&
            (await right
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal']))) {
          result.addType(TypeDetails.FP_Decimal);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['Quantity'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['Quantity']))) {
          result.addType(TypeDetails.FP_Quantity);
        } else if (await left.hasTypeFromWorker(
          fpContext.worker,
          ['date', 'dateTime', 'instant'],
        )) {
          if (await right.hasTypeFromWorker(fpContext.worker, ['Quantity'])) {
            result.addType(left.getType());
          } else {
            throw PathEngineException(
              'Error in date arithmetic: Unable to subtract type '
              '${right.getType()} from ${left.getType()}',
            );
          }
        }
        return result;
      case FpOperation.Div:
      case FpOperation.Mod:
        final result = TypeDetails(CollectionStatus.singleton);
        if ((await left.hasTypeFromWorker(fpContext.worker, ['integer'])) &&
            (await right.hasTypeFromWorker(fpContext.worker, ['integer']))) {
          result.addType(TypeDetails.FP_Integer);
        } else if ((await left
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal'])) &&
            (await right
                .hasTypeFromWorker(fpContext.worker, ['integer', 'decimal']))) {
          result.addType(TypeDetails.FP_Decimal);
        }
        return result;
    }
  }

  Future<void> checkContextString(
    TypeDetails focus,
    String name,
    ExpressionNode expr,
    bool sing,
  ) async {
    if (!focus.hasNoTypes() &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['string'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['code'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['uri'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['canonical'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['id']))) {
      throw fpContext.makeException(
        expr,
        sing ? 'FHIRPATH_STRING_SING_ONLY' : 'FHIRPATH_STRING_ORD_ONLY',
        [name, focus.describe()],
      );
    }
  }

  void checkContextPrimitive(
    TypeDetails focus,
    String name,
    bool canQty,
    ExpressionNode expr,
  ) {
    if (!focus.hasNoTypes()) {
      if (canQty) {
        if (!focus.hasTypes(fpContext.primitiveTypes.toList()) &&
            !focus.hasType('Quantity')) {
          throw fpContext.makeException(
            expr,
            'FHIRPATH_PRIMITIVE_ONLY',
            [
              name,
              focus.describe(),
              'Quantity, ${fpContext.primitiveTypes}',
            ],
          );
        }
      } else if (!focus.hasTypes(fpContext.primitiveTypes.toList())) {
        throw fpContext.makeException(
          expr,
          'FHIRPATH_PRIMITIVE_ONLY',
          [name, focus.describe(), fpContext.primitiveTypes.toString()],
        );
      }
    }
  }

  Future<void> checkContextCoded(
    TypeDetails focus,
    String name,
    ExpressionNode expr,
  ) async {
    if (!(await focus.hasTypeFromWorker(fpContext.worker, ['string'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['code'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['uri'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['Coding'])) &&
        !(await focus
            .hasTypeFromWorker(fpContext.worker, ['CodeableConcept']))) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_CODED_ONLY',
        [name, focus.describe()],
      );
    }
  }

  Future<void> checkContextReference(
    TypeDetails focus,
    String name,
    ExpressionNode expr,
  ) async {
    if (!(await focus.hasTypeFromWorker(fpContext.worker, ['string'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['uri'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['Reference'])) &&
        !(await focus.hasTypeFromWorker(fpContext.worker, ['canonical']))) {
      throw fpContext.makeException(
        expr,
        'FHIRPATH_REFERENCE_ONLY',
        [name, focus.describe()],
      );
    }
  }
}
