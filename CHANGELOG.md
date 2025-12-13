# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-13

### Added
- **CONTRIBUTING.md** - Complete evolution strategy guide
  - Change classification (syncable vs non-syncable files)
  - Semantic versioning guidelines
  - File change checklists
  - Testing checklist before PRs
  - **NEW: Adding New Backend Types** section for community contributions
- **SYNC_STRATEGY.md** - Quick reference for project maintainers
  - What gets synced vs preserved
  - When and how to sync
  - Handling version differences
  - Troubleshooting guide
- **bump-version.sh** - Automated version bumping
  - Semantic version calculation (major/minor/patch)
  - Auto-generates CHANGELOG entries
  - Dry-run mode for preview
  - Git workflow guidance
- **Firebase Backend Template** (`templates/server-layer/firebase/`)
  - CLAUDE.md.template with Firebase-specific patterns
  - Firestore security rules template
  - Cloud Functions patterns
  - Firebase Auth integration
- **Custom Backend Template** (`templates/server-layer/custom/`)
  - CLAUDE.md.template for REST/GraphQL APIs
  - OpenAPI and GraphQL schema patterns
  - Ktor client integration examples
  - JWT and API key authentication patterns
- **Layer Selection in /implement** - Choose which layers to include
  - `--layers server,client,feature` - Explicit layer selection
  - `--skip-server`, `--skip-client`, `--skip-feature` - Skip specific layers
  - `--only server|client|feature` - Run single layer
  - All selected layers go into a single PR
  - Auto-dependency checking when skipping layers
  - Mock data generation when skipping client layer
- **Layer Configuration in Setup** - Configure during project init
  - Interactive mode (`-i`) with layer configuration prompts
  - CLI flags: `--no-server`, `--no-client`, `--no-feature`
  - Default layers: `--default-layers "server,client"`
  - Presets: `--preset api-first|backend-data|frontend-only|ui-prototype`
  - Config stored in `.claude-product-cycle.yaml` under `implementation:` section
  - Automation options: `--no-mocks`, `--no-tests`, `--no-build`, `--no-lint`

### Changed
- **sync-template.sh** - Enhanced with new features
  - `--diff` flag to preview changes before sync
  - `--changelog` flag to view template changelog
  - `--list` flag to show all syncable files
  - `-v/--verbose` flag for detailed output
  - Smart version comparison (detects major/minor/patch)
  - Colored output with change summaries

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
