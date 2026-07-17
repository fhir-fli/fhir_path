## 0.13.0

> **Complete rewrite.** Versions up to 0.12.0 were the original
> petitparser-based FHIRPath library (`walkFhirPath`). From 0.13.0 the
> package is the fhir-fli family's standalone, model-independent FHIRPath
> engine — a new codebase with a new API, developed at
> [fhir-fli/fhir_path](https://github.com/fhir-fli/fhir_path). Users of the
> legacy API should either stay on 0.12.0 or migrate to
> `FHIRPathEngine` via a version binding (`fhir_r4_path` / `fhir_r5_path`
> / `fhir_r6_path`), which is the recommended entry point.

First release of the standalone, model-independent FHIRPath engine,
extracted from `fhir_r4_path` (which is now a thin binding over this
package, alongside `fhir_r5_path` and `fhir_r6_path`).

- **Architecture**: no FHIR model dependency. Data is navigated through the
  `FhirNode` reflection contract (package `fhir_node`); FHIR-version
  knowledge (type metadata, terminology, value construction) enters through
  the `IWorkerContext` / `IFhirValueFactory` boundary interfaces that each
  binding implements. A port of the Java reference engine
  (org.hl7.fhir.core FHIRPathEngine); conformance is verified by the
  official FHIRPath test suite run in all three bindings (1070 tests each).
- **Curated public API**: the barrel exports the engine surface
  (`FHIRPathEngine`, `ExpressionNode`, the boundary interfaces, exceptions,
  type machinery, `FHIRLexer` — public because the FHIR Mapping Language
  parser lexes with it, as in Java). The implementation collaborators are
  `src`-internal and not exported.
- **Exceptions**: `PathEngineException` is the catchable root for all
  expression failures; `FHIRLexerException` extends it (Java parity via the
  shared FHIRException root). `PathEngineError` (an `Error`) is reserved
  for programming errors.
- **Java-parity fix**: `parse(String)` rejects trailing tokens ("Premature
  ExpressionNode termination"), while `parseLexer(FHIRLexer)` remains the
  lenient overload for embedded parsing.
- **Performance contract**: the engine is deliberately cache-free, like the
  Java reference — parse once, evaluate many; cache `ExpressionNode`s in
  the caller (bindings' WorkerContext layers are the right home for an
  expression cache). Parsed nodes are tied to the `IFhirValueFactory` that
  parsed them.
- Known pre-1.0 work: several engine methods that exist for the internal
  collaborator classes are still public on `FHIRPathEngine`; they will be
  narrowed before 1.0.
