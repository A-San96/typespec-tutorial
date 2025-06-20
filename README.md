# TypeSpec Tutorial

This repository contains **my personal project** created by following the [TypeSpec 101 tutorial video series](https://aka.ms/typespec101/videos). I'm applying what I learn in each video step-by-step by building and modifying my own files.
Type

## What is TypeSpec?

[TypeSpec](https://aka.ms/typespec) is a language and toolchain created by Microsoft for designing APIs in a code-first, structured way. It allows you to define your API contract in `.tsp` files and then generate outputs like OpenAPI specs, client SDKs, and documentation automatically.

### Why Use TypeSpec?

TypeSpec is ideal for API-first development. Instead of starting with code, you define your API's structure, operations, data models, and behaviors up front — all in a consistent, strongly-typed format. This helps teams:

- Ensure consistency across services
- Catch design issues early before writing backend or frontend code
- Automatically generate documentation and SDKs from a single source of truth
- Align better between frontend, backend, and stakeholders around a shared contract

## Prerequisites

Before getting started, make sure the following tools are installed:

1. **Visual Studio Code**
   Download and install [VS Code](https://aka.ms/vscode).

2. **TypeSpec VS Code Extension**
   Install the TypeSpec extension from [aka.ms/typespec-vscode](https://aka.ms/typespec-vscode).

3. **Node.js**
   Download and install [Node.js](https://nodejs.org/) (minimum required: Node.js 20.0.0 and npm 7.0.0).

4. **TypeSpec CLI**
   Install the TypeSpec compiler globally:

   ```sh
   npm install -g @typespec/compiler
   ```

5. **Verify Installation**:

   ```sh
   tsp --version
   ```

## Project Setup
Clone the project and open it with VS Code.
Run the following command in your terminal
```sh
tsp install # Install the dependencies
tsp compile . # Compile the initial file to ensure everything is set up correctly
tsp compile . --watch  # To automatically compile changes on save
```

## Project Structure

* `main.tsp`: My primary working file that I update as I go through the tutorial.
* Additional files or folders may be added as I learn and experiment.

If you need reference files, you can check the original [official TypeSpec 101 repository](https://github.com/microsoft/typespec-101).

