# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bootstrapp is a macOS SwiftUI app that generates boilerplate code from templates. It supports three template types: General, Swift Package, and Xcode Project. Templates are defined by a `Bootstrapp.json` spec file and processed through a custom substitution engine with conditionals and loops.

## Build

Open `Bootstrapp.xcodeproj` in Xcode and build/run. No Makefile or build scripts exist — Xcode is the sole build system. There are no test targets.

## Dependencies (SPM, managed via Xcode)

- **BootstrappKit** (1.3.6) — Core template engine (`Bootstrapp.instantiateTemplate()`)
- **Splash** (0.16.0) — Swift syntax highlighting
- **SwiftUIToolbox** (1.4.0) — SwiftUI utilities
- **SystemKit** (1.6.0) — System-level operations (e.g. `FileEventStream`)
- **AttributionsUI** (1.1.0) — Open-source attribution display

All from `github.com/apparata/` except Splash (`github.com/JohnSundell/Splash`).

## Architecture

MVVM pattern with clear Model / View Model / View separation:

- **Model layer**: `Templates` loads templates by finding `Bootstrapp.json` files recursively and monitors the folder via `FileEventStream`. `Bootstrapper` orchestrates template instantiation by calling into BootstrappKit.
- **View Model layer**: `TemplatesModel` manages the collection and persists the template root folder as a sandboxed bookmark. `TemplateModel` wraps a single template with its `ParameterStore` and `PackageStore`.
- **View layer**: `MainView` → `MainSplitView` with sidebar (template list) and content (`TemplateView` showing parameters form, package form, preview images, and Markin documentation).

## Key Conventions

- The app is sandboxed — file access uses URL bookmarks (`URL+Bookmark.swift`).
- Templates are dragged onto the main window to set the root folder.
- `SettingPresets/` contains XcodeGen build setting YAML files bundled with the app for Xcode Project template generation.
- Swift 5.0 target.
