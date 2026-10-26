# Small Type Analysis

This repository is the starting point for the INFOM227 static program analysis project. The selected extension adds optional type annotations to the Small language and infers types where annotations are absent. The analyser will use those types to report invalid operations, such as adding an integer to a boolean.

The project brief is available in [`docs/project.pdf`](docs/project.pdf). This codebase is a fork of the course's [ExampleAnalyser](https://github.com/UNamurCSFaculty/INFOM227_ExampleAnalyser), written in Scala.

## Project focus

The goal is to extend Small so that a program can be checked even when some or all type annotations are omitted. The completed analyser should:

- accept the chosen type annotation syntax and define its semantics;
- infer types for unannotated variables, function parameters, and return values, according to the design adopted for the project;
- detect incompatible operations and function calls before execution;
- explain diagnostics and document the analysis' capabilities and limits.

The handout leaves design choices open. Specify the annotation syntax, inference rules, treatment of conflicting information, and the errors the analyser reports in the project report.

## Current status

This fork provides the language and static-analysis infrastructure; it does **not** yet implement type annotations or type inference. The current grammar and AST have no annotation nodes. The interpreter handles integer and boolean values, and the starter project includes a control-flow graph, a worklist analysis framework, and example analyses for zeroes, signs, intervals, and constants (including an interprocedural constant analysis).

## Build and run

### Requirements

- JDK 21 or later

### Build

From this directory, run:

```bash
./gradlew build
```

On Windows, use `gradlew.bat build`.

### Run the starter analyser

Pass an action and a Small source file to the application:

```bash
./gradlew run --args="run data/test.small"
./gradlew run --args="zero-analysis data/test.small -v"
```

`run` executes the program's `main` function. The existing analysis actions are:

| Action | What it does |
| --- | --- |
| `zero-analysis` | Reports possible division by zero. |
| `sign-analysis` | Computes sign information for variables. |
| `interval-analysis` | Computes interval information for variables. |
| `constant-analysis` | Computes constant values within each function. |
| `interprocedural-constant-analysis` | Computes constant information across function calls. |

Add `-v` after the source file to display detailed analysis tables where supported. The type-inference analysis will be added as part of this project; it is not an available command yet.

### Tests

Run the existing test suite with:

```bash
./gradlew test
```

## Where to work

The main implementation path is:

1. **Grammar:** extend [`SmallGrammar.g4`](src/main/antlr/be/unamur/info/infom227/small/cst/SmallGrammar.g4) with the selected annotation syntax.
2. **AST:** represent annotations in [`Nodes.scala`](src/main/scala/be/unamur/info/infom227/small/ast/Nodes.scala) and build them in [`Builder.scala`](src/main/scala/be/unamur/info/infom227/small/ast/Builder.scala).
3. **Analysis:** define the type domain and transfer rules alongside the framework in [`analysis`](src/main/scala/be/unamur/info/infom227/small/analysis/).
4. **Diagnostics and CLI:** report type errors and expose the new analysis from [`Main.scala`](src/main/scala/be/unamur/info/infom227/small/Main.scala).

The existing forward worklist algorithm is implemented in [`Analysis.scala`](src/main/scala/be/unamur/info/infom227/small/analysis/Analysis.scala). The grammar currently supports functions, assignments, conditionals, loops, returns, calls, integer expressions, and boolean expressions.

## Report and deliverables

The assignment requires both the analyser source and a PDF report. The report should describe the analysis informally and formally, including:

- the language changes and their semantics;
- the abstract domain, lattice, abstraction and concretisation functions;
- a transfer function and an argument that it is sound;
- how the analysis processes programs and when it emits diagnostics;
- a worked example, installation and execution instructions, limitations, and references.

Consult [`docs/project.pdf`](docs/project.pdf) for the full requirements and submission instructions.
