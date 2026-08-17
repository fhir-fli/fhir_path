// ignore_for_file: public_member_api_docs

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/src/internal.dart';

class ExecutionContext {
  ExecutionContext({
    this.appInfo,
    this.focusResource,
    this.rootResource,
    this.context,
    this.thisItem,
  });

  ExecutionContext copyWith({
    Object? appInfo,
    FhirNode? focusResource,
    FhirNode? rootResource,
    FhirNode? context,
    FhirNode? thisItem,
    List<FhirNode>? total,
    int? index,
    Map<String, dynamic>? definedVariables,
  }) {
    return ExecutionContext(
      appInfo: appInfo ?? this.appInfo,
      focusResource: focusResource ?? this.focusResource,
      rootResource: rootResource ?? this.rootResource,
      context: context ?? this.context,
      thisItem: thisItem ?? this.thisItem,
    )
      ..total = total ?? this.total
      ..index = index ?? this.index
      ..definedVariables = definedVariables ?? this.definedVariables;
  }

  final Object? appInfo;
  final FhirNode? focusResource;
  final FhirNode? rootResource;
  final FhirNode? context;
  final FhirNode? thisItem;
  List<FhirNode>? total;
  int index = 0;
  Map<String, dynamic>? definedVariables;

  void next() {
    index++;
  }

  bool hasDefinedVariable(String name) {
    return definedVariables != null && definedVariables!.containsKey(name);
  }

  List<FhirNode> getDefinedVariable(String name) {
    if (definedVariables == null) {
      return <FhirNode>[];
    }
    final variable = definedVariables![name];
    // A Future here means someone bound the result of an un-awaited call.
    // Nothing legitimately binds one, and the fallback below would answer with
    // an empty collection — which is exactly what made the missing `await` in
    // funcDefineVariable invisible: every two-parameter defineVariable quietly
    // returned nothing. Say so instead of answering emptily.
    if (variable is Future) {
      throw PathEngineException(
        'Variable %$name was bound to a Future rather than a value. This is a '
        'missing await where the variable was defined.',
      );
    }
    if (variable is List<FhirNode>) {
      return variable;
    } else if (variable is Function) {
      // ignore: avoid_dynamic_calls
      final result = variable();
      if (result is List<FhirNode>) {
        return result;
      }
    }
    return <FhirNode>[];
  }

  void setDefinedVariable(
    String name,
    dynamic value,
    IWorkerContext worker,
  ) {
    if (isSystemVariable(name)) {
      throw PathEngineException(
        worker.formatMessage('FHIRPATH_REDEFINE_VARIABLE', [name]),
      );
    }

    definedVariables ??= {};
    if (definedVariables!.containsKey(name)) {
      throw PathEngineException(
        worker.formatMessage('FHIRPATH_REDEFINE_VARIABLE', [
          name,
        ]),
      );
    }

    definedVariables![name] = value;
  }

  ExecutionContext changeThis(FhirNode newThis, IWorkerContext worker) {
    final newContext = ExecutionContext(
      appInfo: appInfo,
      focusResource: focusResource,
      rootResource: rootResource,
      context: context,
      thisItem: newThis,
    );
    // append all of the defined variables from the context into the new context
    if (definedVariables != null) {
      for (final s in definedVariables?.keys ?? <String>[]) {
        newContext.setDefinedVariable(
          s,
          definedVariables![s] as List<FhirNode>? ?? <FhirNode>[],
          worker,
        );
      }
    }
    return newContext;
  }

  @override
  String toString() {
    return 'ExecutionContext{appInfo: $appInfo, focusResource: $focusResource, '
        'rootResource: $rootResource, context: $context, thisItem: $thisItem, '
        'total: $total, index: $index, definedVariables: $definedVariables}';
  }
}
