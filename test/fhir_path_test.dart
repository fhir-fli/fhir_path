import 'test_arg_fxns.dart';
import 'test_basic_operators.dart';
import 'test_basic_types.dart';
import 'test_date_times.dart';
import 'test_fp_test_suite.dart';
import 'test_no_arg_fxns.dart';
import 'test_parser.dart';
import 'test_paths.dart';
import 'test_type_hierarchy_table.dart';
import 'test_type_operators.dart';

/// The engine's own semantics, tested where the engine lives.
///
/// These ran only inside the R4 binding until now, which meant a change to
/// this package could look green here while breaking everything that uses it
/// — the failure mode that already bit us once. They are unchanged from the
/// binding: still evaluated against the real R4 model through
/// `fhir_r4_path`'s WorkerContext and value factory, because the engine
/// builds every result through `IFhirValueFactory` and a stub model would
/// only be testing the stub.
Future<void> main() async {
  await testBasicTypes();
  await testParser();
  await testPaths();
  await testBasicOperators();
  await testDateTimes();
  await testNoArgFxns();
  await testArgFxns();
  await testFpTestSuite();
  await testTypeOperators();
  await testTypeHierarchyTable();
}
