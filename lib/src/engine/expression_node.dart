// ignore_for_file: public_member_api_docs,
// ignore_for_file: lines_longer_than_80_chars, avoid_print

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';
import 'package:fhir_path/src/utils/path_string_extensions.dart';
// Import extracted enums

enum ExpressionNodeKind { name, function, constant, group, unary }

// Converted from Java to Dart

class ExpressionNode {
  ExpressionNode(this.uniqueId);

  String uniqueId;
  ExpressionNodeKind? kind;
  String? name;
  FhirNode? constant;
  FpFunction? function;
  List<ExpressionNode> parameters = <ExpressionNode>[];
  ExpressionNode? inner;
  ExpressionNode? group;
  FpOperation? operation;
  bool proximal = false;
  ExpressionNode? opNext;
  SourceLocation? start;
  SourceLocation? end;
  SourceLocation? opStart;
  SourceLocation? opEnd;
  TypeDetails? types;
  TypeDetails? opTypes;

  void printExpressionTree([int depth = 0, Set<ExpressionNode>? visitedNodes]) {
    visitedNodes ??= <ExpressionNode>{};

    if (visitedNodes.contains(this)) {
      print('${'  ' * depth}Circular reference detected at node ID: $uniqueId');
      return;
    }

    visitedNodes.add(this);

    final indent = '  ' * depth;

    print('${indent}Node ID: $uniqueId (Kind: ${kind ?? 'null'})');
    if (name != null) print('$indent  Name: $name');
    if (constant != null) print('$indent  Constant: $constant');
    if (function != null) print('$indent  Function: ${function!.toCode()}');
    if (operation != null) print('$indent  Operation: ${operation!.toCode()}');
    if (start != null) {
      print('$indent  Start Location: ${start!.line}:${start!.column}');
    }
    if (end != null) {
      print('$indent  End Location: ${end!.line}:${end!.column}');
    }
    if (opStart != null) {
      print(
        '$indent  Operation Start Location: ${opStart!.line}:${opStart!.column}',
      );
    }
    if (opEnd != null) {
      print('$indent  Operation End Location: ${opEnd!.line}:${opEnd!.column}');
    }
    if (types != null) print('$indent  Types: $types');
    if (opTypes != null) print('$indent  Operation Types: $opTypes');
    print('$indent  Proximal: $proximal');

    if (group != null) {
      print('$indent  Group:');
      group!.printExpressionTree(depth + 1, visitedNodes);
    }

    if (parameters.isNotEmpty) {
      print('$indent  Parameters:');
      for (final param in parameters) {
        param.printExpressionTree(depth + 2, visitedNodes);
      }
    }

    if (inner != null) {
      print('$indent  Inner:');
      inner!.printExpressionTree(depth + 1, visitedNodes);
    }

    if (opNext != null) {
      print('$indent  Next:');
      opNext!.printExpressionTree(depth + 1, visitedNodes);
    }

    visitedNodes.remove(this);
  }

  @override
  String toString() {
    final b = StringBuffer();
    switch (kind) {
      case ExpressionNodeKind.name:
        b.write(name);
      case ExpressionNodeKind.function:
        if (function == FpFunction.Item) {
          b.write('[');
        } else {
          b
            ..write(name)
            ..write('(');
        }
        var first = true;
        for (final n in parameters) {
          if (first) {
            first = false;
          } else {
            b.write(', ');
          }
          b.write(n.toString());
        }
        if (function == FpFunction.Item) {
          b.write(']');
        } else {
          b.write(')');
        }
      case ExpressionNodeKind.constant:
        if (constant == null) {
          b.write('{}');
        } else if (constant?.fhirType == 'string') {
          b.write("'${constant!.primitiveValue?.escapeJson()}'");
        } else if (constant?.fhirType == 'Quantity') {
          final q = constant!;
          b
            ..write(
              (q.getChildByName('value')?.primitiveValue ?? 'null')
                  .escapeJson(),
            )
            ..write(" '")
            ..write(q.getChildByName('unit')?.primitiveValue?.escapeJson())
            ..write("'");
        } else if ((constant?.isPrimitive ?? false) &&
            constant?.primitiveValue != null) {
          b.write(constant?.primitiveValue?.escapeJson());
        } else {
          b.write(constant.toString().escapeJson());
        }
      case ExpressionNodeKind.group:
        b
          ..write('(')
          ..write(group.toString())
          ..write(')');
      case null:
      case ExpressionNodeKind.unary:
    }
    if (inner != null) {
      if (!(inner!.kind == ExpressionNodeKind.function &&
          inner!.function == FpFunction.Item)) {
        b.write('.');
      }
      b.write(inner!.toString());
    }

    if (operation != null) {
      b
        ..write(' ')
        ..write(operation?.toCode())
        ..write(' ')
        ..write(opNext.toString());
    }

    return b.toString();
  }

  String summary() {
    switch (kind) {
      case ExpressionNodeKind.name:
        return '$uniqueId: $name';
      case ExpressionNodeKind.function:
        return '$uniqueId: $function()';
      case ExpressionNodeKind.constant:
        return '$uniqueId: $constant';
      case ExpressionNodeKind.group:
        return '$uniqueId: (Group)';
      case ExpressionNodeKind.unary:
      case null:
        return '?exp-kind?';
    }
  }

  void write(StringBuffer b) {
    switch (kind) {
      case ExpressionNodeKind.name:
        b.write(name);
      case ExpressionNodeKind.constant:
        b.write(constant);
      case ExpressionNodeKind.function:
        b
          ..write(function?.toCode())
          ..write('(');
        var first = true;
        for (final n in parameters) {
          if (!first) {
            b.write(', ');
          }
          first = false;
          n.write(b);
        }
        b.write(')');
      case ExpressionNodeKind.group:
        b.write('(');
        group?.write(b);
        b.write(')');
      case null:
      case ExpressionNodeKind.unary:
    }
    if (inner != null) {
      b.write('.');
      inner!.write(b);
    }
    if (operation != null) {
      b.write(' ${operation!.toCode()} ');
      opNext?.write(b);
    }
  }

  String? check() {
    if (kind == null) {
      return 'Error in expression - node has no kind';
    }
    switch (kind) {
      case ExpressionNodeKind.name:
        if (name?.noString() ?? true) {
          return 'No Name provided @ ${location()}';
        }
      case ExpressionNodeKind.function:
        if (function == null) {
          return 'No Function id provided @ ${location()}';
        }
        for (final n in parameters) {
          final msg = n.check();
          if (msg != null) {
            return msg;
          }
        }
      case ExpressionNodeKind.constant:
        if (constant == null) {
          return 'No Constant provided @ ${location()}';
        }
      case ExpressionNodeKind.group:
        if (group == null) {
          return 'No Group provided @ ${location()}';
        } else {
          final msg = group?.check();
          if (msg != null) {
            return msg;
          }
        }
      case ExpressionNodeKind.unary:
      case null:
    }
    if (inner != null) {
      final msg = inner?.check();
      if (msg != null) {
        return msg;
      }
    }
    if (operation == null) {
      if (opNext != null) {
        return "Next provided when it shouldn't be @ ${location()}";
      }
    } else {
      if (opNext == null) {
        return 'No Next provided @ ${location()}';
      } else {
        opNext?.check();
      }
    }
    return null;
  }

  String location() {
    return '${start?.line ?? ''}, ${start?.column ?? ''}';
  }

  int get parameterCount => parameters.length;

  String canonical() {
    final b = StringBuffer();
    write(b);
    return b.toString();
  }

  bool checkName() {
    if (!(name?.startsWith(r'$') ?? true)) {
      return true;
    } else {
      return [r'$this', r'$total', r'$index'].contains(name);
    }
  }
}
