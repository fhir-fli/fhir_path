/// Model-independent FHIRPath engine. No FHIR dependency — data is navigated
/// through the `FhirNode` contract (package fhir_node) and version knowledge
/// is supplied at the boundary via the [IWorkerContext] /
/// [IFhirValueFactory] interfaces (FHIR bindings live in the fhir_r*_path
/// packages).
///
/// Typical use goes through a binding, but the engine surface is:
/// [FHIRPathEngine.create] → [FHIRPathEngine.parse] (once per expression —
/// parsed [ExpressionNode]s should be cached by the caller and are tied to
/// the [IFhirValueFactory] that parsed them) → `evaluate*`. All expression
/// failures extend [PathEngineException]; programming errors surface as
/// [PathEngineError].
///
/// The implementation collaborators (FhirPathFunctions/Operations/Utilities,
/// the equality kernel, string/number helpers) are internal and deliberately
/// not exported.
library;
// The engine and its parse/evaluate surface.
// FHIRLexer is public API: the FHIR Mapping Language parser lexes with it,
// exactly as Java's StructureMapUtilities uses the reference FHIRLexer.
// The boundary interfaces a binding implements.
// Exceptions: PathEngineException is the catchable root for all expression
// failures (FHIRLexerException extends it); PathEngineError is for
// programming errors.
// Type machinery surfaced by check/evaluateFunctionType and the bindings.
// Small helpers the bindings and the FML engine consume.

export 'src/clients/fhir_tooling_client.dart';
export 'src/context/canonical_resource_cache.dart';
export 'src/context/element_definition_match.dart';
export 'src/context/fhir_worker_context.dart';
export 'src/context/online_resource_cache.dart';
export 'src/context/resource_cache.dart';
export 'src/engine/collection_status.dart';
export 'src/engine/execution_context.dart';
export 'src/engine/execution_type_context.dart';
export 'src/engine/expression_node.dart';
export 'src/engine/expression_node_with_offset.dart';
export 'src/engine/fhir_constants.dart';
export 'src/engine/fhir_lexer.dart';
export 'src/engine/fhir_path_context.dart';
export 'src/engine/fhir_path_engine.dart';
export 'src/engine/fp_function.dart';
export 'src/engine/fp_operation.dart';
export 'src/engine/function_details.dart';
export 'src/engine/i_evaluation_context.dart';
export 'src/engine/i_fhir_value_factory.dart';
export 'src/engine/i_worker_context.dart';
export 'src/engine/source_location.dart';
export 'src/exceptions/fhir_lexer_exception.dart';
export 'src/exceptions/no_terminology_service_exception.dart';
export 'src/exceptions/path_engine_error.dart';
export 'src/exceptions/path_engine_exception.dart';
export 'src/exceptions/value_set_expansion.dart';
export 'src/logging/client_logger.dart';
export 'src/logging/log_category.dart';
export 'src/logging/logging_service.dart';
export 'src/model/element_node.dart';
export 'src/model/model_binding.dart';
export 'src/terminology/code_in_value_set_result.dart';
export 'src/terminology/coding_value.dart';
export 'src/terminology/icoding.dart';
export 'src/terminology/terminology_cache.dart';
export 'src/terminology/value_set_cache_token.dart';
export 'src/terminology/value_set_checker.dart';
export 'src/terminology/value_set_expander.dart';
export 'src/terminology/value_set_expander_simple.dart';
export 'src/terminology/value_set_expansion_outcome.dart';
export 'src/types/fhir_publication.dart';
export 'src/types/profiled_type.dart';
export 'src/types/system_temporal.dart';
export 'src/types/type_details.dart';
export 'src/utils/utilities.dart';
export 'src/utils/version_utilities.dart';
export 'src/validation/terminology_service_error_class.dart';
export 'src/validation/validation_context_carrier.dart';
export 'src/validation/validation_options.dart';
export 'src/validation/validation_result.dart';
export 'src/validation/validator_fetcher.dart';
