# Command Reference

> **Purpose**: Single source of truth for ALL slash commands
> **Version**: 1.4.0
> **Last Updated**: 2024-12-14

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        CLAUDE PRODUCT CYCLE COMMANDS                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  AUDIT PHASE                              Model: Any                        │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /audit                                   Full project audit                │
│  /audit [Feature]                         Single feature audit              │
│  /audit --quick                           Quick summary only                │
│  /audit --specs                           Spec quality only                 │
│  /audit --impl                            Implementation status only        │
│                                                                              │
│  DESIGN PHASE                             Model: Opus (recommended)         │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /design                                  Show feature list                 │
│  /design [Feature]                        Create/review SPEC.md + API.md    │
│  /design [Feature] --mockup [path]        Design from mockup image          │
│  /design [Feature] --figma [node]         Design from Figma node            │
│  /design [Feature] --research "[query]"   Research-based design             │
│  /design [Feature] --add "[section]"      Add specific section              │
│  /design [Feature] --quick                Quick spec (minimal)              │
│  /design update [Feature]                 Update existing spec              │
│  /design update [Feature] --enhance "[x]" Enhance with description          │
│  /design diff [Feature]                   Compare spec vs implementation    │
│                                                                              │
│  IMPLEMENT PHASE                          Model: Sonnet                     │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /implement [Feature]                     Full E2E implementation           │
│  /implement [Feature] --quick             Quick mode (skip validations)     │
│  /implement [Feature] --skip-server       Skip server layer                 │
│  /implement [Feature] --skip-client       Skip client layer                 │
│  /implement [Feature] --skip-feature      Skip feature layer                │
│  /implement [Feature] --only server       Server layer only                 │
│  /implement [Feature] --only client       Client layer only                 │
│  /implement [Feature] --only feature      Feature layer only                │
│  /implement improve [Feature]             Improve existing feature          │
│  /implement reverify [Feature]            Verify only, no changes           │
│  /implement reverify all                  Verify ALL features               │
│  /implement rollback [Feature]            Undo implementation               │
│                                                                              │
│  LAYER COMMANDS                           Model: Sonnet                     │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /server [Feature]                        Backend/Supabase layer only       │
│  /client [Feature]                        Network + Data + Domain layers    │
│  /feature [Feature]                       UI layer (ViewModel + Screen)     │
│                                                                              │
│  VERIFY PHASE                             Model: Any                        │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /verify [Feature]                        Validate implementation vs spec   │
│                                                                              │
│  UTILITIES                                Model: Any                        │
│  ─────────────────────────────────────────────────────────────────────────  │
│  /projectstatus                           Project overview dashboard        │
│  /opus                                    Switch to Opus model              │
│  /sonnet                                  Switch to Sonnet model            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Detailed Command Reference

### AUDIT COMMANDS

#### `/audit`
Full project audit - analyzes all features for gaps and quality issues.

```bash
# Full audit of entire project
/audit

# Output includes:
# - Feature status summary
# - Spec quality matrix (None/Basic/Good/Excellent)
# - Implementation gaps
# - Priority action plan
```

#### `/audit [Feature]`
Single feature deep audit.

```bash
# Audit specific feature
/audit Home
/audit ManageMoods
/audit Reviews

# Output includes:
# - 12-section spec completeness
# - Server/Client/Feature layer status
# - Missing components
# - Recommendations
```

#### `/audit --quick`
Quick summary without detailed report.

```bash
/audit --quick

# Output: Summary counts only
# Total: 11 | Done: 9 | In Progress: 1 | Planned: 1
```

#### `/audit --specs`
Spec quality analysis only.

```bash
/audit --specs

# Output: Spec quality matrix
# Excellent: 5 | Good: 4 | Basic: 1 | None: 1
```

#### `/audit --impl`
Implementation status only.

```bash
/audit --impl

# Output: Layer completion status
# Complete: 8 | Partial: 2 | Missing: 1
```

---

### DESIGN COMMANDS

#### `/design`
Show feature list with status.

```bash
/design

# Output: Feature list with current status
# ✅ Home (Done)
# ✅ ManageMoods (Done)
# 📋 Reviews (Spec Ready)
```

#### `/design [Feature]`
Create or review feature spec (12-section production template).

```bash
# Create new spec
/design Reviews

# Review existing spec
/design Home

# Output: Full SPEC.md + API.md in features/[feature]/
```

#### `/design [Feature] --mockup [path]`
Design from local mockup image.

```bash
# From local screenshot
/design Reviews --mockup /path/to/reviews-mockup.png
/design Reviews --mockup ~/Desktop/screen.jpg

# From URL
/design Reviews --mockup https://example.com/mockup.png

# Process:
# 1. Read/fetch image
# 2. Analyze visual elements
# 3. Extract design tokens
# 4. Generate component hierarchy
# 5. Create SPEC.md with ASCII mockups
```

#### `/design [Feature] --figma [node]`
Design from Figma node (requires Figma MCP).

```bash
# Using FILE_KEY:NODE_ID format
/design Reviews --figma abc123:70410:8727

# Process:
# 1. Fetch design via mcp__figma__get_design_context
# 2. Get screenshot via mcp__figma__get_screenshot
# 3. Extract design tokens and components
# 4. Generate SPEC.md
```

#### `/design [Feature] --research "[query]"`
Research-based design using competitor analysis.

```bash
# Research competitor patterns
/design SurpriseMe --research "Netflix shuffle, Spotify discover weekly"
/design Reviews --research "Letterboxd reviews, IMDb ratings"

# Process:
# 1. Web search for patterns
# 2. Analyze competitor approaches
# 3. Extract best practices
# 4. Generate informed SPEC.md
```

#### `/design [Feature] --add "[section]"`
Add specific section to existing spec.

```bash
# Add new component section
/design Home --add "hero carousel"
/design Profile --add "mood analytics chart"

# Process:
# 1. Read existing SPEC.md
# 2. Add new section with full detail
# 3. Update component hierarchy
# 4. Update implementation checklist
```

#### `/design [Feature] --quick`
Quick spec for simple features.

```bash
# Minimal spec (fewer sections)
/design Settings --quick

# Generates: Overview, Visual Design, Components, Actions
# Skips: Animations, Performance, Testing details
```

#### `/design update [Feature]`
Update existing spec with enhancements.

```bash
# Interactive update
/design update ManageMoods

# With specific enhancement
/design update ManageMoods --enhance "Add quick mood selection via FAB"
/design update Home --enhance "Add trending movies section"

# Process:
# 1. Read existing SPEC.md
# 2. Analyze enhancement request
# 3. Update affected sections (2, 3, 4, 5, 7, 12)
# 4. Mark STATUS.md as "Needs Update"
# 5. Add changelog entry
```

#### `/design diff [Feature]`
Compare spec vs actual implementation.

```bash
/design diff ManageMoods
/design diff Home

# Output:
# ✅ IN SYNC: Items matching spec
# ⚠️ SPEC AHEAD: Spec features not implemented
# 🔴 CODE AHEAD: Code features not in spec
# 📊 Sync Score: X% (Y/Z items)
```

---

### IMPLEMENT COMMANDS

#### `/implement [Feature]`
Full E2E implementation from spec.

```bash
/implement Reviews
/implement Activity

# Process:
# 1. Git: Create feature branch
# 2. Validate: Check dependencies
# 3. Server: Deploy RPCs (if needed)
# 4. Client: Create Service → Repository → UseCase
# 5. Feature: Create ViewModel → Screen → Components
# 6. Build: Gradle build after each layer
# 7. Test: Generate unit tests
# 8. Lint: Run detekt/spotless
# 9. Commit: After each layer
# 10. PR: Prepare pull request
```

#### `/implement [Feature] --quick`
Quick mode - trust spec, skip validations.

```bash
/implement Reviews --quick

# Skips:
# - Deep spec verification
# - Extensive validation
# Faster but assumes spec is accurate
```

#### `/implement [Feature] --skip-server`
Skip server layer (backend already exists).

```bash
/implement Reviews --skip-server

# Use when:
# - RPCs already deployed
# - Using existing backend
# - Third-party API
```

#### `/implement [Feature] --skip-client`
Skip client layer (data layer exists).

```bash
/implement Reviews --skip-client

# Use when:
# - Service/Repository already exists
# - Only need UI changes
```

#### `/implement [Feature] --skip-feature`
Skip feature layer (no UI yet).

```bash
/implement Reviews --skip-feature

# Use when:
# - API-first development
# - Backend + data layer only
```

#### `/implement [Feature] --only [layer]`
Single layer implementation.

```bash
# Server layer only
/implement Reviews --only server

# Client layer only (Network + Data + Domain)
/implement Reviews --only client

# Feature layer only (ViewModel + Screen)
/implement Reviews --only feature

# Use for:
# - Focused layer work
# - Incremental implementation
# - Layer-specific fixes
```

#### `/implement improve [Feature]`
Improve existing feature (refactoring, animations, polish).

```bash
/implement improve Home
/implement improve ManageMoods

# Use for:
# - Adding animations
# - Refactoring code
# - Performance optimization
# - Polish and refinement
```

#### `/implement reverify [Feature]`
Verify implementation against spec (no changes).

```bash
# Single feature
/implement reverify ManageMoods

# All features
/implement reverify all

# Output:
# - Spec vs code comparison
# - Missing implementations
# - Gaps report
```

#### `/implement rollback [Feature]`
Undo feature implementation.

```bash
/implement rollback Reviews

# Options:
# - Rollback specific layer
# - Rollback entire feature
# - Git-based undo
```

---

### LAYER COMMANDS

#### `/server [Feature]`
Backend/Supabase layer only.

```bash
/server Reviews
/server Activity

# Creates:
# - RPC functions (SQL)
# - Database migrations
# - Edge functions (if needed)
# - Updates SCHEMA_REGISTRY.md
```

#### `/client [Feature]`
Network + Data + Domain layers.

```bash
/client Reviews

# Creates in order:
# 1. Network: DTOs + Service interface + ServiceImpl
# 2. Data: Mappers + Repository interface + RepositoryImpl
# 3. Domain: UseCases
# 4. DI: Module registrations
```

#### `/feature [Feature]`
UI layer (ViewModel + Screen).

```bash
/feature Reviews

# Creates:
# 1. ViewModel (State, Event, Action)
# 2. Screen (Composable)
# 3. Components (reusable UI)
# 4. Destination (navigation)
# 5. Module (DI)
# 6. String resources
```

---

### VERIFY COMMANDS

#### `/verify [Feature]`
Validate implementation against spec.

```bash
/verify Reviews
/verify ManageMoods

# Checks:
# - All spec sections implemented
# - API contracts match
# - Components exist
# - Navigation works
# - Tests pass
```

---

### UTILITY COMMANDS

#### `/projectstatus`
Project overview dashboard.

```bash
/projectstatus

# Output:
# - Feature status summary
# - Recent changes
# - Next priorities
# - Build status
```

#### `/opus`
Switch to Opus model.

```bash
/opus

# Use for:
# - /design commands
# - Architecture decisions
# - Complex debugging
```

#### `/sonnet`
Switch to Sonnet model.

```bash
/sonnet

# Use for:
# - /implement commands
# - Regular development
# - Quick fixes
```

---

## Command Cheat Sheet

### New Feature Flow
```bash
/opus                              # Switch to Opus
/design Reviews                    # Create spec
/sonnet                            # Switch to Sonnet
/implement Reviews                 # Full implementation
/verify Reviews                    # Validate
```

### Update Existing Feature
```bash
/opus
/design update ManageMoods --enhance "Add quick mood FAB"
/sonnet
/implement ManageMoods             # Implements new additions
```

### Check Project Health
```bash
/audit                             # Full audit
/audit --quick                     # Quick summary
/design diff [Feature]             # Spec vs code
```

### Layer-by-Layer Development
```bash
/server Reviews                    # Backend first
/client Reviews                    # Data layer
/feature Reviews                   # UI last
```

### Quick Fixes
```bash
/implement [Feature] --only feature    # UI fix only
/implement improve [Feature]           # Polish/refactor
```

---

## Cross-Reference: Related Files

| Command | Reads | Writes |
|---------|-------|--------|
| `/audit` | All SPEC.md, STATUS.md, code | FEATURE_AUDIT.md |
| `/design` | Mockups, Figma, existing spec | SPEC.md, API.md, STATUS.md |
| `/design update` | SPEC.md | SPEC.md, STATUS.md |
| `/design diff` | SPEC.md, code | (report only) |
| `/implement` | SPEC.md, API.md | Code, tests, commits |
| `/server` | API.md | SQL, migrations |
| `/client` | API.md | DTOs, Services, Repos, UseCases |
| `/feature` | SPEC.md | ViewModel, Screen, Components |
| `/verify` | SPEC.md, code | (report only) |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.4.0 | 2024-12-14 | Added `/design update`, `/design diff`, FEATURE_EVOLUTION.md |
| 1.3.0 | 2024-12-13 | Added `/audit` command |
| 1.2.0 | 2024-12-13 | Added mockup integration to `/design` |
| 1.1.0 | 2024-12-13 | Added layer selection to `/implement` |
| 1.0.0 | 2024-12-13 | Initial release |
