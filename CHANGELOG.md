## 0.14.2

- `resolve()` on a literal reference now hands the reference string to the
  host's `resolveReference`, as the Java reference does (`FHIRPathEngine
  .funcResolve`: `url = convertToString(p.getValues().get(0))` on the
  `reference` property). The port looked for a primitive CHILD of the
  reference element and so never resolved a literal reference; with a host
  service wired, `subject.where(resolve() is Patient)` was always empty.
  Contained (`#id`) resolution is unchanged. `test/resolve_test.dart`.

## 0.14.1

- Fixed: `defineVariable(name, expression)` bound the Future returned by evaluating the expression rather than the value it resolved to, because `funcDefineVariable` did not await it. `setDefinedVariable` took `dynamic`, so nothing complained, and the variable compared unequal to everything — the expression simply returned an empty collection. Every use of the two-parameter form was affected; the one-parameter form, which binds the focus, was not
- A variable bound to a `Future` is now an error naming the missing await, instead of being answered as an empty collection. That silent fallback is why the bug above read as "this expression matched nothing" rather than as a defect, and why it survived a release

## 0.14.0

- BREAKING: `memberOf` now throws `PathEngineException` when the value set cannot be resolved, instead of returning an empty collection. The spec is explicit ("If the valueset cannot be resolved as a uri to a value set, an error is thrown"), and the old behavior made `where(code.memberOf(...)).count()` answer a confident `0` that a caller could not distinguish from a genuine none
- BREAKING: `memberOf` now asks only whether the code is in the value set, not whether it is also valid in its own code system. A value set enumerating SNOMED concepts is answerable from the enumeration alone, and SNOMED is licensed — the wider question returned `false` offline for a code the value set plainly lists. The operator form (`memberOf(...)` as an operation) had both defects and now matches the function form
- Divergence from the Java reference, taken on the spec's wording: Java's `funcMemberOf` passes plain validation options

## 0.13.1

- Example file renamed to `fhir_path_example.dart` so pub.dev's analyzer recognizes it; no code changes

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
