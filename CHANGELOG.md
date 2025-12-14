# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2024-12-13

### Added
- **Feature Audit Command** (`/audit`) - Comprehensive project health check
  - `/audit` - Full audit of all features
  - `/audit [Feature]` - Audit single feature
  - `/audit --quick` - Quick summary only
  - `/audit --specs` - Spec quality only
  - `/audit --impl` - Implementation status only

- **Feature Audit Report Template** (`FEATURE_AUDIT.md.template`)
  - Executive summary with counts
  - Feature-by-feature audit tables
  - 12-section spec quality matrix
  - Implementation gap analysis (Server/Client/Feature layers)
  - Priority action plan (P1-P4)
  - Cross-feature dependency mapping
  - Technical debt tracking
  - Recommendations (short/medium/long term)

- **Spec Quality Assessment** - Automated quality scoring
  - None: No spec exists
  - Basic: 1-4 sections
  - Good: 5-8 sections
  - Excellent: 9-12 sections

- **Implementation Verification** - Layer-by-layer code checking
  - Server layer: RPC existence verification
  - Client layer: Service, Repository, UseCase checks
  - Feature layer: ViewModel, Screen, Components, DI Module checks

---

## [1.2.0] - 2024-12-13

### Added
- **Enhanced /design Command** - Intelligent mockup integration and production-quality specs
  - `--mockup [path]` - Analyze local screenshot for design extraction
  - `--figma [FILE_KEY:NODE_ID]` - Fetch Figma designs via MCP integration
  - `--research [competitor]` - Competitor analysis for inspiration
  - `--quick` - Fast mode for simple features

- **Mockup Analysis Process** - AI-powered visual extraction
  - Visual element identification (headers, sections, components)
  - Design token extraction (colors, typography, spacing, corner radius)
  - Component hierarchy mapping to design system
  - Interaction inference (tap targets, scroll behavior, gestures)

- **Production-Quality SPEC Template** - 12 comprehensive sections
  1. Overview (User Stories, Success Metrics)
  2. Visual Design (ASCII from Mockup, Design Tokens)
  3. Component Hierarchy (Tree + Specifications)
  4. User Interactions (Actions Matrix, Navigation Flows)
  5. State Management (Screen State, State Transitions)
  6. Animations & Micro-interactions
  7. API Requirements (RPC signatures, DTOs)
  8. Accessibility (A11y requirements)
  9. Performance Requirements
  10. Testing Requirements
  11. Mockup References
  12. Implementation Checklist

- **Spec Quality Scoring** - 100-point quality system
  - Completeness (40 points): All sections filled
  - Clarity (30 points): Unambiguous specifications
  - Implementation Ready (30 points): Actionable for developers

- **Implementation Brief** - Output for /implement command
  - Priority layers identification
  - Effort estimates
  - Critical design decisions
  - Suggested starting points

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
