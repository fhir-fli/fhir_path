// Package imports:
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;
import 'package:petitparser/core.dart';

import '../petit/parser/parser.dart';
import 'fhirpath_lexer.dart';
import 'utils/utils.dart';

// Project imports:

/// Start here! This is where the fun begins. This is a bit confusing, so we'll
/// explain the arguments that can be passed.
///
/// The FHIRPath specification defines the following inputs:
///
/// **context**
///
/// [context](https://hl7.org/fhirpath/#environment-variables)
/// Is the original node that was passed to the evaluation engine before
/// starting evaluation.
///
/// Should always be passed in through the [context] parameter.
///
///
/// **resource**
///
/// [resource](https://www.hl7.org/fhir/fhirpath.html#variables)
/// the resource that contains the original node that is in %context
///
/// May be passed in either through an entry in the [environment] map,
/// named "%resource", or through the dedicated parameter.
/// A non-null dedicated parameter takes precedence.
///
///
/// **rootResource**
///
/// [rootResource](https://www.hl7.org/fhir/fhirpath.html#variables)
/// the container resource for the resource identified by %resource
///
/// May be passed in either through an entry in the [environment] map,
/// named "%rootResource", or through the dedicated parameter.
/// A non-null dedicated parameter takes precedence.
///
/// **environment variables / resources**
///
/// [environment] - arbitrary named environment variables.
/// These should be passed in as a map, where each key has the format
/// "%variable-name".
///
/// ```json
/// {
///   "%pi": 3.1415927,
///   "%myname": "Grey"
/// }
/// ```
///
/// *** Lazy-loading ***
/// Instead of a static value, the [environment] may map keys to functions
/// which return the actual value. These functions will only be evaluated when
/// the variable is accessed. This lazy evaluation may boost performance, for
/// instance when iif is used to determine which of two expensive objects is to
/// be used.
///
/// The lazy-loading mechanism is currently only supported through the
/// [environment] map, not for explicitly passed-in parameters.
List<dynamic> walkNewFhirPath({
  required Map<String, dynamic>? context,
  required String pathExpression,
  Map<String, dynamic>? resource,
  Map<String, dynamic>? rootResource,
  Map<String, dynamic>? environment,
  FhirVersionNew version = FhirVersionNew.r4,
}) {
  final ast = parseFhirPathNew(pathExpression);
  return executeFhirPathNew(
    context: context,
    parsedFhirPath: ast,
    pathExpression: pathExpression,
    resource: resource,
    rootResource: rootResource,
    environment: environment,
    version: version,
  );
}

/// Parse a FHIRPath for repeated use with different inputs later.
FhirPathParser parseFhirPathNew(String pathExpression) {
  try {
    final ast = fhirPathLexer().parse(pathExpression).value;
    // print(ast);
    // if (ast is ParserList) {
    //   if (ast.isEmpty) {
    //     return ast;
    //   } else {
    //     // Check for combination of IdentifierParser followed by ParenthesisParser
    //     // This indicates invalid function name
    //     if (ast.value.length > 1) {
    //       for (int i = 0; i < ast.value.length - 1; i++) {
    //         if ((ast.value[i] is IdentifierParser) &&
    //             (ast.value[i + 1] is ParenthesesParser)) {
    //           final String functionName =
    //               (ast.value[i] as IdentifierParser).value;
    //           throw FhirPathInvalidExpressionExceptionNew(
    //               'Unknown function: $functionName',
    //               pathExpression: pathExpression);
    //         }
    //       }
    //     }

    return ast;
    // }
    // } else {
    //   throw FhirPathInvalidExpressionExceptionNew(
    //       'Parsing did not result in ParserList',
    // pathExpression: pathExpression);
    // }
  } catch (error) {
    if (error is ParserException) {
      throw FhirPathInvalidExpressionExceptionNew(
        'Expression could not be parsed: ${error.message}',
        pathExpression: pathExpression,
        offset: error.offset,
        cause: error,
      );
    } else {
      rethrow;
    }
  }
}

/// Execute the FHIRPath as pre-parsed by [parseFhirPathNew].
///
/// May be invoked repeatedly on the same parsed FHIRPath,
/// resulting in a performance gain over [walkFhirPath].
///
/// All parameters have the same meaning as for [walkFhirPath].
List<dynamic> executeFhirPathNew({
  ///
  required Map<String, dynamic>? context,
  required FhirPathParser parsedFhirPath,
  required String pathExpression,
  Map<String, dynamic>? resource,
  Map<String, dynamic>? rootResource,
  Map<String, dynamic>? environment,
  FhirVersionNew version = FhirVersionNew.r4,
}) {
  // Use passed-in environment as the starting point.
  // It will later be amended/overridden by explicitly passed resources.
  final passedEnvironment = Map<String, dynamic>.from(environment ?? {});

  // Explicitly passed context overrides context that might have been passed
  // through environment.
  passedEnvironment.context = context;

  // Explicitly passed resource overrides resource that might have been passed
  // through environment.
  if (resource != null) {
    passedEnvironment.resource = resource;
  }

  // Explicitly passed rootResource overrides rootResource that might have been passed
  // through environment.
  if (rootResource != null) {
    passedEnvironment.rootResource = rootResource;
  }

  passedEnvironment.version = version;

  try {
    return parsedFhirPath.execute([context], passedEnvironment);
  } catch (error) {
    if (error is FhirPathExceptionNew) {
      rethrow;
    } else {
      throw FhirPathExceptionNew(
        'Unable to execute FHIRPath expression',
        pathExpression: pathExpression,
        cause: error,
        context: context,
        environment: passedEnvironment,
      );
    }
  }
}

List<dynamic> r4WalkFhirPathNew(
  r4.Resource? resource,
  String pathExpression, [
  Map<String, dynamic>? environment,
]) {
  final resourceJson = resource?.toJson();
  return walkNewFhirPath(
    context: resourceJson,
    pathExpression: pathExpression,
    environment: environment,
    version: FhirVersionNew.r4,
  );
}

List<dynamic> r5WalkFhirPathNew(
  r5.Resource? resource,
  String pathExpression, [
  Map<String, dynamic>? environment,
]) {
  final resourceJson = resource?.toJson();
  return walkNewFhirPath(
    context: resourceJson,
    pathExpression: pathExpression,
    environment: environment,
    version: FhirVersionNew.r5,
  );
}

List<dynamic> dstu2WalkFhirPathNew(
  dstu2.Resource? resource,
  String pathExpression, [
  Map<String, dynamic>? environment,
]) {
  final resourceJson = resource?.toJson();
  return walkNewFhirPath(
    context: resourceJson,
    pathExpression: pathExpression,
    environment: environment,
    version: FhirVersionNew.dstu2,
  );
}

List<dynamic> stu3WalkFhirPathNew(
  stu3.Resource? resource,
  String pathExpression, [
  Map<String, dynamic>? environment,
]) {
  final resourceJson = resource?.toJson();
  return walkNewFhirPath(
    context: resourceJson,
    pathExpression: pathExpression,
    environment: environment,
    version: FhirVersionNew.stu3,
  );
}

extension FhirPathResourceExtensionNew on Map<String, dynamic> {
  static const contextKey = '%context';
  static const resourceKey = '%resource';
  static const rootResourceKey = '%rootResource';

  Map<String, dynamic>? get context =>
      this[contextKey] as Map<String, dynamic>?;
  set context(Map<String, dynamic>? context) => this[contextKey] = context;
  bool get hasNoContext => context == null;

  set resource(Map<String, dynamic>? resource) {
    if (resource != null) {
      this[resourceKey] = resource;
    }
  }

  set rootResource(Map<String, dynamic>? rootResource) {
    if (rootResource != null) {
      this[resourceKey] = rootResource;
    }
  }
}
