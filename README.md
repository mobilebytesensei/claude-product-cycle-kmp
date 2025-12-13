# Claude Product Cycle - KMP Template

A comprehensive development workflow template for Kotlin Multiplatform (KMP) projects using Claude Code. This template provides a structured approach to feature development with automated E2E pipelines.

## Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│  CLAUDE PRODUCT CYCLE WORKFLOW                                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  /design [Feature]     →  Create SPEC.md + API.md (Opus)                │
│         ↓                                                                │
│  /implement [Feature]  →  Full E2E implementation (Sonnet)              │
│         │                  Git → Validate → Server → Client → Feature   │
│         │                  Build → Test → Lint → PR                     │
│         ↓                                                                │
│  /verify [Feature]     →  Validate implementation vs spec               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Features

- **Structured Workflow**: Design → Implement → Verify phases
- **E2E Automation**: Git, Build, Test, Lint, PR preparation
- **Layer-based Architecture**: Server → Client → Feature
- **Smart Checkpoints**: Review after each layer with improve/continue options
- **Cross-Update Rules**: Automatic plan synchronization
- **Rollback Support**: Undo any layer or entire feature

## Quick Start

### 1. Initialize New Project

```bash
# Clone template
git clone https://github.com/mobilebytesensei/claude-product-cycle-kmp.git

# Run init script
./scripts/init-project.sh \
  --name "My App" \
  --package "com.example.myapp" \
  --output "../my-app"
```

### 2. Manual Setup (Alternative)

```bash
# Copy commands to your project
cp -r commands/ your-project/.claude/commands/

# Copy templates
cp -r templates/ your-project/claude-product-cycle/

# Create config
cp examples/claude-product-cycle.yaml your-project/.claude-product-cycle.yaml

# Edit config with your project details
```

### 3. Start Using

```bash
# In your project with Claude Code
/design MyFeature      # Design phase (use Opus)
/implement MyFeature   # Implementation (use Sonnet)
/verify MyFeature      # Verification
```

## Directory Structure

```
claude-product-cycle-kmp/
├── README.md                           # This file
├── CHANGELOG.md                        # Version history
├── VERSION                             # Current version (semver)
│
├── commands/                           # Slash commands
│   ├── implement.md                    # E2E implementation workflow
│   ├── design.md                       # Design phase workflow
│   ├── server.md                       # Server layer workflow
│   ├── client.md                       # Client layer workflow
│   ├── feature.md                      # Feature layer workflow
│   ├── verify.md                       # Verification workflow
│   └── projectstatus.md                # Project status overview
│
├── templates/                          # Project scaffolding
│   ├── CLAUDE.md.template              # Main CLAUDE.md template
│   ├── design-spec-layer/
│   │   ├── STATUS.md.template          # Feature status tracker
│   │   ├── _shared/
│   │   │   ├── PATTERNS.md             # Architecture patterns
│   │   │   └── CROSS_UPDATE_RULES.md   # Plan sync rules
│   │   └── features/
│   │       └── __FEATURE__/            # Feature scaffold
│   │           ├── SPEC.md.template
│   │           ├── API.md.template
│   │           └── STATUS.md.template
│   └── server-layer/
│       ├── supabase/
│       │   └── CLAUDE.md.template
│       └── data-pipeline/
│           └── CLAUDE.md.template
│
├── scripts/
│   ├── init-project.sh                 # Bootstrap new project
│   ├── sync-template.sh                # Pull template updates
│   ├── add-feature.sh                  # Scaffold new feature
│   └── validate-config.sh              # Validate project config
│
└── examples/
    ├── claude-product-cycle.yaml       # Example config
    └── mood-movies/                    # Reference implementation
```

## Configuration

Create `.claude-product-cycle.yaml` in your project root:

```yaml
template:
  version: "1.0.0"
  source: "github.com/mobilebytesensei/claude-product-cycle-kmp"

project:
  name: "My App"
  package: "com.example.myapp"
  type: "kmp"  # kmp | android | ios | web

architecture:
  pattern: "clean-mvi"
  layers:
    - network
    - data
    - domain
    - feature

backend:
  type: "supabase"  # supabase | firebase | custom (contribute more!)
  has_data_pipeline: false

features: []  # Will be populated as you add features
```

## Commands Reference

| Command | Model | Description |
|---------|-------|-------------|
| `/design [Feature]` | Opus | Create SPEC.md + API.md |
| `/implement [Feature]` | Sonnet | Full E2E implementation |
| `/implement [Feature] --quick` | Sonnet | Quick mode (skip validations) |
| `/implement improve [Feature]` | Sonnet | Improve existing feature |
| `/implement reverify [Feature]` | Sonnet | Verify only, no changes |
| `/implement rollback [Feature]` | Sonnet | Undo implementation |
| `/server [Feature]` | Sonnet | Server layer only |
| `/client [Feature]` | Sonnet | Client layer only |
| `/feature [Feature]` | Sonnet | Feature layer only |
| `/verify [Feature]` | Sonnet | Validate vs spec |
| `/projectstatus` | Any | Project overview |

## E2E Pipeline

```
┌───────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌─────────┐
│  GIT  │─▶│VALIDATE│─▶│ SERVER │─▶│ CLIENT │─▶│ FEATURE │
└───────┘  └────────┘  └───┬────┘  └───┬────┘  └────┬────┘
 branch     deps           │           │            │
                      [checkpoint] [checkpoint] [checkpoint]
                           │           │            │
                       ┌───▼───┐   ┌───▼───┐   ┌────▼────┐
                       │ BUILD │   │ BUILD │   │  BUILD  │
                       │ TEST  │   │ TEST  │   │  TEST   │
                       │ LINT  │   │ LINT  │   │  LINT   │
                       │COMMIT │   │COMMIT │   │ COMMIT  │
                       └───────┘   └───────┘   └────┬────┘
                                                    │
                                               ┌────▼────┐
                                               │   PR    │
                                               │  READY  │
                                               └─────────┘
```

## Architecture Patterns

This template supports Clean Architecture with MVI pattern:

```
┌─────────────────────────────────────────────────────────────┐
│  Feature Modules (UI + ViewModel)                            │
│  MVI: State, Event, Action                                   │
└─────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────┐
│  core/domain - Use Cases                                     │
│  Single responsibility, invoke() operator                    │
└─────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────┐
│  core/data - Repository Implementations                      │
│  DTO→Domain mapping, caching                                 │
└─────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────┐
│  core/network - Services + DTOs                              │
│  API calls, RPC functions                                    │
└─────────────────────────────────────────────────────────────┘
```

## Syncing Updates

When the template is updated:

```bash
# Check for updates
./scripts/sync-template.sh --check

# Pull updates (preserves project-specific files)
./scripts/sync-template.sh --sync
```

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/my-improvement`
3. Make changes
4. Test with a sample project
5. Submit PR

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.
