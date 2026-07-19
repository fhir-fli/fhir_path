# fhir_path

Model-independent [FHIRPath](https://hl7.org/fhirpath/) engine in Dart — a
port of the Java reference implementation (`org.hl7.fhir.core`
FHIRPathEngine). Part of the [fhir-fli](https://github.com/fhir-fli)
ecosystem.

## Model independence

The engine has **zero coupling to any FHIR version**. It never imports a
`fhir_r4` / `fhir_r5` / `fhir_r6` model. Instead:

- Runtime data is navigated through the `FhirNode` reflection contract
  (package [`fhir_node`](https://github.com/fhir-fli/fhir_node)) — children
  by name, type name, primitive value.
- All version-specific knowledge — type metadata, terminology, and value
  construction — is supplied at the boundary through the `IWorkerContext`
  and `IFhirValueFactory` interfaces, which this package only *defines*.

```
fhir_node ──▶ FhirNode        (how the engine reads data)
fhir_path ──▶ FHIRPathEngine  (the version-agnostic evaluator)
              IWorkerContext  (boundary interface — implemented downstream)
                    ▲
fhir_r4_path / fhir_r5_path / fhir_r6_path  (concrete WorkerContext + factory)
```

## Which package do I depend on?

Most applications depend on a **binding**, not this package directly:

- `fhir_r4_path`, `fhir_r5_path`, `fhir_r6_path` bundle `fhir_path` together
  with a concrete `WorkerContext` (an `IWorkerContext`) and value factory
  for that FHIR version. They are what evaluates `Patient.name.given` over
  real `fhir_r*` resources.

Depend on **`fhir_path` directly** only when you are writing your own binding
over a non-`fhir_r*` data model, or embedding the parser/lexer (e.g. the
FHIR Mapping Language engine uses the exported `FHIRLexer`).

## Install

```yaml
dependencies:
  # Usually a binding, which pulls in fhir_path transitively:
  fhir_r4_path: any
  # …or the engine directly, to build your own binding:
  fhir_path: ^0.13.0
```

## Usage (through a binding)

```dart
import 'package:fhir_r4_path/fhir_r4_path.dart';

// The binding supplies the concrete WorkerContext (an IWorkerContext).
final engine = await FHIRPathEngine.create(WorkerContext());

// Parse once, evaluate many — the engine is deliberately cache-free (like
// the Java reference), so hold onto the ExpressionNode yourself. Parsed
// nodes are tied to the value factory (binding) that produced them.
final expr = engine.parse('Patient.name.given');
final List<FhirNode> result = await engine.evaluate(patient, expr);

// One-shot parse+evaluate when you don't need to cache the expression:
final List<FhirNode> active = await engine.evaluateFromPath(patient, 'active');

// Validate an expression without evaluating it:
engine.isValid('name.given'); // true
```

The core surface is `FHIRPathEngine.create` → `parse` → `evaluate`;
everything else (functions, operations, the equality kernel) is internal.

## Error handling

Every expression failure — lexing, parsing, evaluation — extends
`PathEngineException`, so one catch clause covers them all
(`FHIRLexerException` is a subtype, mirroring Java's shared `FHIRException`
root). `PathEngineError` (an `Error`) is reserved for programming mistakes
and should not be caught.

## Implementing your own binding

Implement `FhirNode` (package `fhir_node`) for your data model and the
`IWorkerContext` / `IFhirValueFactory` interfaces for type metadata and
value construction. `example/stub_model.dart` is a complete minimal
implementation exercised by `example/fhir_path_example.dart`; the
`fhir_r*_path` packages are the production ones.

## Conformance

The official FHIRPath test suite runs against all three bindings. The engine
repo itself carries its own parser/lexer/evaluation tests over the stub
model in `example/`.

## Credits

A port of the FHIRPathEngine from
[org.hl7.fhir.core](https://github.com/hapifhir/org.hl7.fhir.core)
(BSD-3-Clause, © HL7 / Health Intersections). MIT licensed, © FHIR-FLI.
