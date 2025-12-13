# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-13

### Added
- Initial template release
- **Commands Layer**
  - `/implement` - Full E2E implementation with automation
  - `/design` - Design phase workflow
  - `/server` - Server layer workflow
  - `/client` - Client layer workflow
  - `/feature` - Feature layer workflow
  - `/verify` - Verification workflow
  - `/projectstatus` - Project status overview

- **E2E Automation Features**
  - Git Integration (auto branch, commits)
  - Dependency Validation (pre-check tables, RPCs)
  - Auto-Build (Gradle build after each layer)
  - Auto-Test Generation (unit tests)
  - Lint & Format (detekt, spotless, ktlint)
  - Progress Dashboard (visual tracking)
  - Rollback Support (undo layers/features)
  - Hot Reload Integration (device refresh)
  - Parallel Execution (concurrent tasks)
  - PR Preparation (auto-generate PR)

- **Templates**
  - CLAUDE.md template with placeholders
  - STATUS.md template for feature tracking
  - Feature scaffold (SPEC.md, API.md, STATUS.md)
  - Server layer templates (Supabase)
  - Data pipeline templates

- **Scripts**
  - `init-project.sh` - Bootstrap new projects
  - `sync-template.sh` - Pull template updates
  - `add-feature.sh` - Scaffold new features
  - `validate-config.sh` - Validate config

- **Patterns**
  - Clean Architecture with MVI
  - Layer-based structure (network → data → domain → feature)
  - Cross-update rules for plan synchronization
  - Checkpoint system with improve/continue options

### Attribution
- Extracted from [Mood Movies](https://github.com/mobilebytesensei/mood-movies) project
- Developed with Claude Code (Anthropic)
