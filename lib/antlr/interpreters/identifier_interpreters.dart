// ignore_for_file: avoid_dynamic_calls

part of '../fhir_path_dart_visitor.dart';

List<dynamic>? _$visitIdentifier(
  IdentifierContext ctx,
  FhirPathDartVisitor visitor,
) {
  String identifierName;
  if (ctx.text.startsWith('`') && ctx.text.endsWith('`')) {
    identifierName = ctx.text.substring(1, ctx.text.length - 1);
  } else {
    identifierName = ctx.text;
  }

  if (visitor.identifierOnly) {
    visitor.context = <dynamic>[identifierName];
  } else {
    final List<dynamic> results = (ctx.childCount == 0 ||
            (ctx.childCount == 1 &&
                (ctx.getChild(0).runtimeType == TerminalNodeImpl ||
                    ctx.getChild(0).runtimeType == ErrorNodeImpl)))
        ? visitor.context
        : visitor.copyWith().visitChildren(ctx) ?? <dynamic>[];
    final List<dynamic> finalResults = <dynamic>[];
    final List<dynamic> finalPrimitiveExtensions =
        List<dynamic>.filled(results.length, null);

    final dynamic passedExtensions = visitor.environment['__extension'];
    visitor.environment['__extension'] = null;

    if (visitor.environment.isVersion(FhirVersion.r4)
        ? r4.resourceTypeFromStringMap.keys.contains(identifierName)
        : visitor.environment.isVersion(FhirVersion.r5)
            ? r5.resourceTypeFromStringMap.keys.contains(identifierName)
            : visitor.environment.isVersion(FhirVersion.dstu2)
                ? dstu2.resourceTypeFromStringMap.keys.contains(identifierName)
                : stu3.resourceTypeFromStringMap.keys
                    .contains(identifierName)) {
      if (visitor.environment.context?['resourceType'] == identifierName &&
          !visitor.environment.hasNoContext) {
        finalResults.add(visitor.environment.context);
      }
    } else if (results.isNotEmpty) {
      results.forEachIndexed((int i, dynamic r) {
        if (r is Map) {
          String jsonIdentifierName = identifierName;
          dynamic rValue = r[identifierName];
          if (rValue == null) {
            // Support for polymorphism:
            // If the key cannot be found in the r-map, then find
            // a key that starts with the same word, e.g. 'value' identifier will
            // match 'valueDateTime' key.
            r.forEach((dynamic k, dynamic v) {
              if (k.toString().startsWith(identifierName) &&
                  polymorphicPrefixes.contains(identifierName) &&
                  startsWithAPolymorphicPrefix(k.toString())) {
                rValue = v;
                jsonIdentifierName = k as String;
              }
            });
          }

          final Map<String, dynamic>? jsonPrimitiveExtension =
              r['_$jsonIdentifierName'] as Map<String, dynamic>?;
          if (jsonPrimitiveExtension != null) {
            finalPrimitiveExtensions[i] = jsonPrimitiveExtension['extension'];
          }

          if (rValue is List) {
            finalResults.addAll(rValue as List<dynamic>);
          } else if (rValue != null) {
            finalResults.add(rValue);
          } else if (r['resourceType'] == identifierName) {
            finalResults.add(r);
          }
        } else {
          if (identifierName == 'extension') {
            // Special processing for extensions on primitives
            if (passedExtensions != null) {
              final dynamic extensionOnPrimitive = passedExtensions[i];
              if (extensionOnPrimitive != null) {
                finalResults.addAll(extensionOnPrimitive as Iterable<dynamic>);
              }
            } else {
              // This primitive does not have an extension
              // Do nothing.
            }
          }
        }
      });
    }
    visitor.environment['__extension'] = finalPrimitiveExtensions;
    visitor.context = finalResults;
  }

  return visitor.context;
}
