import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';

FHIRPathEngine? _engine;

/// Parse and evaluate [pathExpression], the way these suites have always done
/// it — but through the engine API rather than the deprecated `walkFhirPath`
/// facade the tests used while they lived in the binding.
///
/// The error wrapping is reproduced deliberately: `walkFhirPath` turned a bare
/// `Error` into a [PathEngineError] and anything else into a
/// [PathEngineException], and a number of these tests assert on exactly that.
/// Dropping it would quietly change what they prove.
Future<List<FhirBase>> walkPath({
  required FhirBase? context,
  required String pathExpression,
  FhirBase? resource,
  FhirBase? rootResource,
  Map<String, dynamic>? environment,
}) async {
  final engine = _engine ??= await FHIRPathEngine.create(WorkerContext());
  final parsed = engine.parse(pathExpression);
  try {
    if (environment != null) {
      final passedEnvironment = <String, dynamic>{
        if (resource != null) 'focusResource': [resource],
        if (rootResource != null) 'rootResource': [rootResource],
        ...environment,
      };
      final result = await engine.evaluateWithContext(
        null,
        resource,
        rootResource,
        context,
        parsed,
        environment: passedEnvironment,
      );
      return result.cast<FhirBase>();
    }
    final result = await engine.evaluate(context, parsed);
    return result.cast<FhirBase>();
  } catch (error, st) {
    if (error is PathEngineException) {
      rethrow;
    } else if (error is Error) {
      throw PathEngineError(
        'Unable to execute FHIRPath expression',
        expression: pathExpression,
        cause: error,
        stackTrace: st,
      );
    } else {
      throw PathEngineException(
        'Unable to execute FHIRPath expression',
        expression: pathExpression,
        cause: error as Exception,
        stackTrace: st,
      );
    }
  }
}
