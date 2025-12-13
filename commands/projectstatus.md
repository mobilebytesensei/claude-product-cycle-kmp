# Project Status - Session Start Command

**RUN THIS AT SESSION START** - Shows project overview, all commands, and current status.

---

## ALL COMMANDS (Quick Reference)

```
┌─────────────────────────────────────────────────────────────────────┐
│  SETUP                                                               │
├─────────────────────────────────────────────────────────────────────┤
│  /projectstatus           → PROJECT OVERVIEW (run at session start) │
├─────────────────────────────────────────────────────────────────────┤
│  DESIGN PHASE (Architecture)                                         │
├─────────────────────────────────────────────────────────────────────┤
│  /design [Feature]        → Create SPEC.md + API.md (Opus)          │
├─────────────────────────────────────────────────────────────────────┤
│  IMPLEMENT PHASE (Execution)                                         │
├─────────────────────────────────────────────────────────────────────┤
│  /implement [Feature]     → Full implementation (Sonnet)            │
│                                                                      │
│  OR use layer commands independently:                                │
│  /server [Feature]        → Backend/Supabase layer                  │
│  /client [Feature]        → Network + Data + Domain layers          │
│  /feature [Feature]       → UI layer (ViewModel + Screen)           │
├─────────────────────────────────────────────────────────────────────┤
│  VERIFY PHASE (Validation)                                           │
├─────────────────────────────────────────────────────────────────────┤
│  /verify [Feature]        → Validate implementation vs spec         │
├─────────────────────────────────────────────────────────────────────┤
│  MODEL COMMANDS                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  /opus                    → Switch to Opus (for /design)            │
│  /sonnet                  → Switch to Sonnet (for /implement)       │
└─────────────────────────────────────────────────────────────────────┘
```

### Development Workflow

```
/design [Feature]     → Create blueprint (SPEC.md + API.md)
        ↓
/implement [Feature]  → Build from blueprint (all layers)
        ↓
/verify [Feature]     → Validate implementation
```

### Command Usage Guide

| Command | Phase | Purpose | Model |
|---------|-------|---------|-------|
| `/projectstatus` | Any | Session start - project overview | Any |
| `/design [Feature]` | **Design** | Create SPEC.md + API.md | **Opus** |
| `/implement [Feature]` | **Implement** | Full implementation | Sonnet |
| `/server [Feature]` | Implement | Backend layer only | Sonnet |
| `/client [Feature]` | Implement | Client layers only | Sonnet |
| `/feature [Feature]` | Implement | UI layer only | Sonnet |
| `/verify [Feature]` | **Verify** | Validate implementation | Sonnet |

### Recommended Session Flow

```
┌───────────────────────────────────────────────────────────────────┐
│  NEW SESSION CHECKLIST                                             │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. /projectstatus          → See project status                   │
│                                                                    │
│  2. Pick your work:                                                │
│     • New feature?                                                 │
│         /design [Feature]   → Create blueprint (Opus)              │
│         /implement [Feature]→ Build it (Sonnet)                    │
│         /verify [Feature]   → Validate                             │
│                                                                    │
│     • Spec exists, ready to build?                                 │
│         /implement [Feature]                                       │
│                                                                    │
│     • Work on specific layer?                                      │
│         /server, /client, or /feature                              │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## USAGE

```
/projectstatus                → Full project overview (START HERE!)
/projectstatus server         → Server/Supabase layer status
/projectstatus client         → Client layers (Network→Data→Domain)
/projectstatus feature        → Feature modules (UI layer)
/projectstatus [FeatureName]  → Specific feature deep dive
```

---

## COMMAND PARSING (FIRST!)

Parse the argument: $ARGUMENTS

| Argument | Action |
|----------|--------|
| (empty) | Show FULL PROJECT DASHBOARD |
| `server` | Show SERVER LAYER section |
| `client` | Show CLIENT LAYER section |
| `feature` | Show FEATURE LAYER section |
| Other | Treat as feature name, show FEATURE DEEP DIVE |

---

## FULL PROJECT DASHBOARD (when no argument)

**Steps:**
1. Read `claude-product-cycle/design-spec-layer/STATUS.md`
2. Count files in each layer using find commands
3. Display this visual:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PROJECT DASHBOARD                                         │
│                    Generated: [date]                                         │
├─────────────────────────────────────────────────────────────────────────────┤

📊 OVERALL PROGRESS
═══════════════════════════════════════════════════════════════════════════════

Phase 1 (Core MVP):    ████████████████████  100%  [X/X]
Phase 2 (Discovery):   ████████████████████  100%  [X/X]
Phase 3 (Social):      ███████░░░░░░░░░░░░░   33%  [X/X]

Total:                 ████████████████░░░░   XX%  [X/X features]

🏗️ LAYER HEALTH
═══════════════════════════════════════════════════════════════════════════════

┌─────────────┬─────────────┬─────────────┬─────────────┐
│   SERVER    │   NETWORK   │    DATA     │   FEATURE   │
│ (Supabase)  │ (Services)  │  (Repos)    │    (UI)     │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ Tables: X   │ Services: X │ Repos: X    │ Modules: X  │
│ RPCs: X     │ DTOs: ✅    │ Mappers: ✅ │ Screens: X  │
│ Cache: X    │             │ Paging: ✅  │ VMs: X      │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ /dashboard  │ /dashboard  │ /dashboard  │ /dashboard  │
│   server    │   client    │   client    │   feature   │
└─────────────┴─────────────┴─────────────┴─────────────┘

📋 FEATURE STATUS
═══════════════════════════════════════════════════════════════════════════════

[Read from STATUS.md and display feature table]

| Feature     | Server | Client | UI | Status   |
|-------------|--------|--------|-----|----------|
| Feature1    |   ✅   |   ✅   | ✅ | ✅ Done  |
| Feature2    |   🔄   |   ❌   | ❌ | 🔄 WIP   |

🎯 NEXT ACTIONS
═══════════════════════════════════════════════════════════════════════════════

Priority 1: /design [NextFeature]
Priority 2: /implement [InProgressFeature]

💡 LAYER DEEP DIVES
═══════════════════════════════════════════════════════════════════════════════

/projectstatus server    → Supabase tables, RPCs, cache details
/projectstatus client    → Services, Repositories, UseCases
/projectstatus feature   → Feature modules, components, navigation

└─────────────────────────────────────────────────────────────────────────────┘
```

---

## SERVER LAYER (`/projectstatus server`)

**Steps:**
1. Run `mcp__supabase__list_tables` to get actual tables
2. Read `claude-product-cycle/design-spec-layer/SCHEMA_REGISTRY.md` for RPC list
3. Display table/RPC inventory

---

## CLIENT LAYER (`/projectstatus client`)

**Steps:**
1. Count files: `find core/network/service -name "*Service.kt" | wc -l`
2. Count files: `find core/data/repository -name "*Repository*.kt" | wc -l`
3. Count files: `find core/domain -name "*UseCase.kt" | wc -l`
4. Display service/repository/usecase inventory

---

## FEATURE LAYER (`/projectstatus feature`)

**Steps:**
1. List directories in `feature/`
2. Check for Screen.kt, ViewModel.kt in each
3. Display module inventory with status

---

## FEATURE DEEP DIVE (`/projectstatus [FeatureName]`)

When argument is a feature name:

**Steps:**
1. Find feature directory
2. List all files in that feature
3. Find corresponding files in other layers
4. Display complete feature breakdown

---

## EXECUTION FLOW

1. **Parse $ARGUMENTS**
2. **Route to appropriate section:**
   - Empty → Full Dashboard
   - "server" → Server Layer
   - "client" → Client Layer
   - "feature" → Feature Layer
   - Other → Feature Deep Dive
3. **Gather data** (read files, run find commands)
4. **Generate visual output**
