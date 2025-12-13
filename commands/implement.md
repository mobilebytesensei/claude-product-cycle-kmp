# Feature Implementation Session (E2E Automation)

## ALL COMMANDS (Quick Reference)

```
┌─────────────────────────────────────────────────────────────────────┐
│  DESIGN PHASE                                                        │
├─────────────────────────────────────────────────────────────────────┤
│  /design [Feature]        → Create SPEC.md + API.md (Opus)          │
├─────────────────────────────────────────────────────────────────────┤
│  IMPLEMENT PHASE (E2E AUTOMATED)                                     │
├─────────────────────────────────────────────────────────────────────┤
│  /implement [Feature]     → Full E2E implementation (Sonnet)     ◀  │
│                             Git → Validate → Server → Client →      │
│                             Feature → Build → Test → Lint → PR      │
│                                                                      │
│  OR use layer commands independently:                                │
│  /server [Feature]        → Backend/Supabase layer                  │
│  /client [Feature]        → Network + Data + Domain layers          │
│  /feature [Feature]       → UI layer (ViewModel + Screen)           │
├─────────────────────────────────────────────────────────────────────┤
│  VERIFY PHASE                                                        │
├─────────────────────────────────────────────────────────────────────┤
│  /verify [Feature]        → Validate implementation vs spec         │
├─────────────────────────────────────────────────────────────────────┤
│  UTILITIES                                                           │
├─────────────────────────────────────────────────────────────────────┤
│  /projectstatus           → Project overview                        │
│  /opus                    → Switch to Opus (for /design)            │
│  /sonnet                  → Switch to Sonnet (for /implement)       │
│  /implement --rollback    → Undo last implementation                │
└─────────────────────────────────────────────────────────────────────┘
```

---

## /implement VARIANTS

```
/implement                       → Show feature status list
/implement [Feature]             → Full E2E implementation
/implement [Feature] --quick     → Quick mode (skip validations)
/implement [Feature] --no-git    → Skip git integration
/implement [Feature] --no-test   → Skip test generation
/implement [Feature] --no-pr     → Skip PR preparation
/implement improve [Feature]     → Improve existing feature
/implement reverify [Feature]    → Verify only, no implementation
/implement rollback [Feature]    → Undo feature implementation
```

---

## ⚡ E2E AUTOMATED MODE (DEFAULT)

**Complete end-to-end implementation with all automation features.**

```
┌─────────────────────────────────────────────────────────────────────┐
│  /implement [Feature] - E2E AUTOMATED PIPELINE                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ✅ Git Integration     - Auto branch, commits after each phase     │
│  ✅ Dependency Check    - Validate all dependencies before start    │
│  ✅ Auto-Build          - Gradle build after each layer             │
│  ✅ Auto-Test           - Generate unit tests for each layer        │
│  ✅ Lint & Format       - Run detekt, spotless, ktlint              │
│  ✅ Checkpoints         - Review/improve after each layer           │
│  ✅ Progress Dashboard  - Real-time progress tracking               │
│  ✅ Hot Reload          - Trigger app refresh after feature layer   │
│  ✅ Rollback Support    - Undo any layer or entire feature          │
│  ✅ PR Preparation      - Auto-generate PR at the end               │
│                                                                      │
│  FULL PIPELINE:                                                      │
│  ┌───────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌─────────┐        │
│  │  GIT  │─▶│VALIDATE│─▶│ SERVER │─▶│ CLIENT │─▶│ FEATURE │        │
│  └───────┘  └────────┘  └───┬────┘  └───┬────┘  └────┬────┘        │
│   branch     deps           │           │            │              │
│                        [checkpoint] [checkpoint] [checkpoint]       │
│                             │           │            │              │
│                         ┌───▼───┐   ┌───▼───┐   ┌────▼────┐        │
│                         │ BUILD │   │ BUILD │   │  BUILD  │        │
│                         │ TEST  │   │ TEST  │   │  TEST   │        │
│                         │ LINT  │   │ LINT  │   │  LINT   │        │
│                         │COMMIT │   │COMMIT │   │ COMMIT  │        │
│                         └───────┘   └───────┘   └────┬────┘        │
│                                                      │              │
│                                                 ┌────▼────┐        │
│                                                 │   PR    │        │
│                                                 │  READY  │        │
│                                                 └─────────┘        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔟 E2E AUTOMATION FEATURES

### 1. Git Integration
```
[START]
→ git checkout -b feature/{feature-name}
→ git status (check clean working directory)

[AFTER EACH LAYER]
→ git add .
→ git commit -m "feat({feature}): Add {layer} layer"

[END]
→ Ready for: git push -u origin feature/{feature-name}
```

### 2. Dependency Validation
```
[BEFORE IMPLEMENTATION]
Validating dependencies...
├─ ✅ Required tables exist (movies, users, moods)
├─ ✅ Required RPCs exist (get_movies, get_user_profile)
├─ ⚠️ Missing: user_follows table (will create)
├─ ✅ Kotlin dependencies available
├─ ✅ Gradle sync successful
└─ ✅ All checks passed - proceeding
```

### 3. Auto-Build Verification
```
[AFTER EACH LAYER]
🔨 Running: ./gradlew :core:network:build
   ✅ BUILD SUCCESSFUL in 12s

🔨 Running: ./gradlew :feature:{name}:build
   ✅ BUILD SUCCESSFUL in 8s
```

### 4. Auto-Test Generation
```
[FOR EACH CREATED FILE]
Created:
├─ ReviewRepository.kt
├─ ReviewRepositoryTest.kt  ← Auto-generated
│   └─ testGetReviews()
│   └─ testCreateReview()
│   └─ testDeleteReview()
├─ ReviewsViewModel.kt
└─ ReviewsViewModelTest.kt  ← Auto-generated
    └─ testInitialState()
    └─ testLoadReviews()
    └─ testCreateReviewAction()

🧪 Running tests...
   ✅ 12 tests passed
```

### 5. Lint & Format
```
[AFTER CODE GENERATION]
🧹 Running code quality checks...

./gradlew detekt
   ✅ No issues found

./gradlew spotlessApply
   ✅ 3 files formatted

./gradlew ktlintFormat
   ✅ All files compliant
```

### 6. Progress Dashboard
```
╔══════════════════════════════════════════════════════════════════════╗
║  /implement Reviews - PROGRESS                                        ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  [████████████████░░░░░░░░░░░░░░] 55%                                 ║
║                                                                       ║
║  ✅ GIT        ✅ VALIDATE    ✅ SERVER      🔄 CLIENT    ⏳ FEATURE  ║
║                                                                       ║
║  Current: Creating ReviewRepositoryImpl.kt                            ║
║  Files created: 8/15                                                  ║
║  ETA: ~3 minutes remaining                                            ║
║                                                                       ║
║  Recent:                                                              ║
║  └─ ✅ ReviewDto.kt                                                   ║
║  └─ ✅ ReviewService.kt                                               ║
║  └─ 🔄 ReviewRepositoryImpl.kt (in progress)                          ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

### 7. Rollback Support
```
/implement rollback Reviews

╔══════════════════════════════════════════════════════════════════════╗
║  ROLLBACK OPTIONS                                                     ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  1. Undo FEATURE layer only                                          ║
║     └─ Remove: ViewModel, Screen, Components (6 files)               ║
║                                                                       ║
║  2. Undo CLIENT + FEATURE layers                                     ║
║     └─ Remove: DTO, Service, Repository, UseCase + Feature (14 files)║
║                                                                       ║
║  3. Undo ENTIRE implementation                                        ║
║     └─ Remove: All files + Revert migration + Delete branch          ║
║     └─ Total: 18 files, 1 migration, 3 commits                       ║
║                                                                       ║
║  4. Cancel                                                            ║
║                                                                       ║
║  Select [1-4]: _                                                      ║
╚══════════════════════════════════════════════════════════════════════╝

[If user selects 3]
Rolling back...
├─ ✅ Removed 18 files
├─ ✅ Reverted DI module changes
├─ ✅ Reverted navigation changes
├─ ✅ Dropped migration: 20251213_001_reviews.sql
├─ ✅ Reset git: git checkout dev && git branch -D feature/reviews
└─ ✅ Rollback complete
```

### 8. Hot Reload Integration
```
[AFTER FEATURE LAYER]
📱 Hot Reload...
├─ Detecting connected devices...
├─ Found: Pixel 7 (emulator-5554)
├─ Triggering hot reload...
└─ ✅ App refreshed - ReviewsScreen now available

Note: Navigate to Profile → Reviews to test
```

### 9. Parallel Execution
```
[WHERE POSSIBLE - Run tasks in parallel]

CLIENT LAYER (parallel execution):
├─┬─ Creating ReviewDto.kt ─────────┐
│ ├─ Creating ReviewService.kt ─────┼─→ 0.8s total (vs 2.4s sequential)
│ └─ Creating ReviewMapper.kt ──────┘
│
└─┬─ Creating ReviewRepository.kt ──┐
  └─ Creating ReviewUseCase.kt ─────┴─→ 0.6s total

BUILD (parallel modules):
├─┬─ :core:network:build ───────────┐
│ ├─ :core:data:build ──────────────┼─→ 15s total (vs 45s sequential)
│ └─ :core:domain:build ────────────┘
```

### 10. PR Preparation
```
[AT THE END]

╔══════════════════════════════════════════════════════════════════════╗
║  🎉 IMPLEMENTATION COMPLETE - PR READY                                ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  Branch: feature/reviews                                              ║
║  Commits: 4                                                           ║
║  Files: +18, ~5 modified                                              ║
║                                                                       ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │  PR Title:                                                       │ ║
║  │  feat(reviews): Add user reviews feature                         │ ║
║  │                                                                   │ ║
║  │  ## Summary                                                       │ ║
║  │  Implements user reviews functionality allowing users to:         │ ║
║  │  - View their movie reviews                                       │ ║
║  │  - Write new reviews with ratings (1-10)                          │ ║
║  │  - Edit and delete existing reviews                               │ ║
║  │                                                                   │ ║
║  │  ## Changes                                                       │ ║
║  │  ### Server                                                       │ ║
║  │  - Added `user_reviews` table with RLS policies                   │ ║
║  │  - Added RPCs: get_user_reviews, create_review, delete_review     │ ║
║  │                                                                   │ ║
║  │  ### Client                                                       │ ║
║  │  - Added ReviewDto, ReviewService, ReviewRepository               │ ║
║  │  - Added GetUserReviewsUseCase with pagination                    │ ║
║  │                                                                   │ ║
║  │  ### Feature                                                      │ ║
║  │  - Added ReviewsScreen with MVI architecture                      │ ║
║  │  - Added components: ReviewCard, WriteReviewSheet, RatingBar      │ ║
║  │                                                                   │ ║
║  │  ## Test Plan                                                     │ ║
║  │  - [ ] Unit tests pass (12/12)                                    │ ║
║  │  - [ ] Build successful on all modules                            │ ║
║  │  - [ ] Manual test: Create review                                 │ ║
║  │  - [ ] Manual test: Edit review                                   │ ║
║  │  - [ ] Manual test: Delete review                                 │ ║
║  │                                                                   │ ║
║  │  🤖 Generated with Claude Code                                    │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║                                                                       ║
║  Options:                                                             ║
║  • p / push   → git push -u origin feature/reviews                   ║
║  • c / create → Create PR via gh pr create                           ║
║  • e / edit   → Edit PR description                                  ║
║  • s / skip   → Skip PR creation                                     ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## Key Files

1. `claude-product-cycle/design-spec-layer/STATUS.md` - **Single status tracker** (all features)
2. `claude-product-cycle/design-spec-layer/features/[feature]/SPEC.md` - What to build
3. `claude-product-cycle/design-spec-layer/features/[feature]/API.md` - APIs needed
4. `claude-product-cycle/design-spec-layer/features/[feature]/STATUS.md` - Feature-specific status
5. `claude-product-cycle/design-spec-layer/_shared/PATTERNS.md` - Implementation patterns

---

## STEP 0: VERIFICATION (MANDATORY)

Before implementing, verify spec vs actual code:

```
PHASE 1: Read feature's SPEC.md
   └─→ Extract all UI sections, APIs, filters, user actions

PHASE 2: Check actual code
   └─→ Does component exist? Does API call exist?

PHASE 3: Check plan sync
   └─→ Are SCHEMA_REGISTRY.md, STATUS.md up to date?

PHASE 4: Generate gap report
   └─→ List missing implementations
```

---

## Implementation Flow (E2E PIPELINE)

```
┌─────────────────────────────────────────────────────────────────────┐
│  E2E IMPLEMENTATION PIPELINE                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  PHASE 0: GIT SETUP                                                  │
│  ├─→ Check working directory is clean                               │
│  ├─→ Create branch: git checkout -b feature/{name}                  │
│  └─→ [AUTO-CONTINUE]                                                │
│                                                                      │
│  PHASE 1: DEPENDENCY VALIDATION                                      │
│  ├─→ Read SPEC.md + API.md                                          │
│  ├─→ Check Supabase tables/RPCs exist                               │
│  ├─→ Check Kotlin dependencies available                            │
│  ├─→ Identify gaps                                                   │
│  └─→ [AUTO-CONTINUE if all deps satisfied]                          │
│                                                                      │
│  PHASE 2: SERVER ──────────────────────────────────────────────────  │
│  ├─→ Create migration for missing tables/RPCs                       │
│  ├─→ Deploy: python3 master.py deploy                               │
│  ├─→ Populate data from SQLite if needed                            │
│  ├─→ Update SCHEMA_REGISTRY.md                                      │
│  ├─→ 🔨 BUILD: Verify migration success                             │
│  ├─→ 📝 COMMIT: git commit -m "feat({name}): Add server layer"      │
│  └─→ ⏸️ CHECKPOINT: Server Summary + Options                         │
│                                                                      │
│  PHASE 3: CLIENT ──────────────────────────────────────────────────  │
│  ├─→ Create DTOs in core/network/model/ (parallel)                  │
│  ├─→ Create Service in core/network/service/ (parallel)             │
│  ├─→ Create Mapper in core/network/mapper/ (parallel)               │
│  ├─→ Create Repository in core/data/repository/                     │
│  ├─→ Create UseCase in core/domain/                                 │
│  ├─→ Register in DI modules                                         │
│  ├─→ 🧪 TEST: Generate + run unit tests                             │
│  ├─→ 🔨 BUILD: ./gradlew :core:network:build :core:data:build       │
│  ├─→ 🧹 LINT: detekt + spotlessApply                                │
│  ├─→ 📝 COMMIT: git commit -m "feat({name}): Add client layer"      │
│  └─→ ⏸️ CHECKPOINT: Client Summary + Options                         │
│                                                                      │
│  PHASE 4: FEATURE ─────────────────────────────────────────────────  │
│  ├─→ Create ViewModel (State, Event, Action)                        │
│  ├─→ Create Screen (Compose UI)                                     │
│  ├─→ Create Components + @Preview                                   │
│  ├─→ Create Destination (Navigation)                                │
│  ├─→ Register in DI module + navigation graph                       │
│  ├─→ 🧪 TEST: Generate ViewModel tests                              │
│  ├─→ 🔨 BUILD: ./gradlew :feature:{name}:build                      │
│  ├─→ 🧹 LINT: detekt + spotlessApply                                │
│  ├─→ 📱 HOT RELOAD: Refresh connected device                        │
│  ├─→ 📝 COMMIT: git commit -m "feat({name}): Add feature layer"     │
│  └─→ ⏸️ CHECKPOINT: Feature Summary + Options                        │
│                                                                      │
│  PHASE 5: FINALIZE ────────────────────────────────────────────────  │
│  ├─→ Update feature's STATUS.md                                     │
│  ├─→ Update main STATUS.md                                          │
│  ├─→ Add changelog entries                                          │
│  ├─→ 📝 COMMIT: git commit -m "docs({name}): Update status"         │
│  ├─→ 🧪 FINAL BUILD: ./gradlew build (full project)                 │
│  └─→ 🎉 PR READY: Generate PR description                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

**Total estimated time: 8-12 minutes (includes build, test, lint)**

---

## Checkpoint Templates

### After SERVER Layer:

```
┌──────────────────────────────────────────────────────────────────────┐
│  ✅ SERVER LAYER COMPLETE                                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Created:                                                             │
│  ├─ Migration: 20251213_001_surpriseme.sql                           │
│  ├─ Tables: surprise_filters, surprise_history                       │
│  ├─ RPCs: get_surprise_movie, get_surprise_filters                   │
│  └─ Data: Synced 1.3M movies with mood mappings                      │
│                                                                       │
│  Deployed to Supabase: ✅                                             │
│  Updated SCHEMA_REGISTRY.md: ✅                                       │
│                                                                       │
│  🔨 BUILD: Migration deployed successfully                            │
│  📝 COMMIT: feat(surpriseme): Add server layer [abc1234]             │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│  Options:                                                             │
│  • c / continue  → Proceed to CLIENT layer                           │
│  • i / improve   → Describe what to improve (e.g., add index)        │
│  • v / view      → Show migration SQL                                │
│  • r / rollback  → Undo this migration                               │
└──────────────────────────────────────────────────────────────────────┘
```

### After CLIENT Layer:

```
┌──────────────────────────────────────────────────────────────────────┐
│  ✅ CLIENT LAYER COMPLETE                                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Created Files (5):                                                   │
│  ├─ core/network/model/SurpriseDto.kt                                │
│  ├─ core/network/service/SurpriseService.kt                          │
│  ├─ core/network/mapper/SurpriseMapper.kt                            │
│  ├─ core/data/repository/SurpriseRepository.kt                       │
│  └─ core/domain/surprise/GetSurpriseMovieUseCase.kt                  │
│                                                                       │
│  Generated Tests (3):                                                 │
│  ├─ SurpriseServiceTest.kt                                           │
│  ├─ SurpriseRepositoryTest.kt                                        │
│  └─ GetSurpriseMovieUseCaseTest.kt                                   │
│                                                                       │
│  Registered in DI:                                                    │
│  ├─ NetworkModule: SurpriseService ✅                                 │
│  ├─ DataModule: SurpriseRepository ✅                                 │
│  └─ DomainModule: GetSurpriseMovieUseCase ✅                          │
│                                                                       │
│  🧪 TESTS: 8/8 passed                                                 │
│  🔨 BUILD: :core:network ✅ :core:data ✅ :core:domain ✅ (18s)        │
│  🧹 LINT: detekt ✅ spotless ✅ (2 files formatted)                   │
│  📝 COMMIT: feat(surpriseme): Add client layer [def5678]             │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│  Options:                                                             │
│  • c / continue  → Proceed to FEATURE layer                          │
│  • i / improve   → Describe what to change (e.g., add caching)       │
│  • v / view [file] → Show specific file content                      │
│  • t / test      → Re-run unit tests                                 │
│  • r / rollback  → Undo client layer                                 │
└──────────────────────────────────────────────────────────────────────┘
```

### After FEATURE Layer:

```
┌──────────────────────────────────────────────────────────────────────┐
│  ✅ FEATURE LAYER COMPLETE                                           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Created Files (6):                                                   │
│  ├─ feature/surpriseme/SurpriseMeViewModel.kt                        │
│  ├─ feature/surpriseme/SurpriseMeScreen.kt                           │
│  ├─ feature/surpriseme/components/SurpriseCard.kt                    │
│  ├─ feature/surpriseme/components/FilterBottomSheet.kt               │
│  ├─ feature/surpriseme/SurpriseMeDestination.kt                      │
│  └─ feature/surpriseme/di/SurpriseMeModule.kt                        │
│                                                                       │
│  Generated Tests (2):                                                 │
│  ├─ SurpriseMeViewModelTest.kt                                       │
│  └─ SurpriseMeScreenTest.kt                                          │
│                                                                       │
│  Navigation:                                                          │
│  ├─ Route registered: SurpriseMeRoute ✅                              │
│  └─ Added to bottom nav: ✅                                           │
│                                                                       │
│  🧪 TESTS: 6/6 passed                                                 │
│  🔨 BUILD: :feature:surpriseme ✅ (8s)                                │
│  🧹 LINT: detekt ✅ spotless ✅ ktlint ✅                              │
│  📱 HOT RELOAD: Device refreshed - Navigate to SurpriseMe tab        │
│  📝 COMMIT: feat(surpriseme): Add feature layer [ghi9012]            │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│  Options:                                                             │
│  • c / continue  → Complete implementation, update status            │
│  • i / improve   → Describe improvement (e.g., add animation)        │
│  • v / view [file] → Show specific file content                      │
│  • p / preview   → Generate @Preview composables                     │
│  • a / animation → Add screen transitions/animations                 │
│  • t / test      → Re-run unit tests                                 │
│  • r / rollback  → Undo feature layer                                │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Quick Response Shortcuts

| Input | Action |
|-------|--------|
| `c` or `continue` or just **Enter** | Proceed to next layer |
| `i` or `improve` + description | Apply improvement, then continue |
| `v` or `view` | Show file contents |
| `r` or `rollback` | Undo current layer (if possible) |
| `skip` | Skip remaining layers |

---

## SERVER LAYER (Step 2) - DETAILED WORKFLOW

When implementing a feature's backend, follow this flow:

### Step 2.1: Read API.md

```
claude-product-cycle/design-spec-layer/features/{Feature}/API.md
```

Extract:
- Required RPCs (SQL functions)
- Required tables
- Required DTOs

### Step 2.2: Check What Exists

```bash
# Check Supabase tables
mcp__supabase__list_tables

# Check specific table
mcp__supabase__execute_sql("SELECT * FROM information_schema.tables WHERE table_name = 'table_name'")

# Check RPCs exist
mcp__supabase__execute_sql("SELECT proname FROM pg_proc WHERE proname LIKE 'get_%'")
```

### Step 2.3: Decision Tree - How Should Table Be Populated?

```
┌─────────────────────────────────────────────────────────────────┐
│  FOR EACH TABLE/RPC IN API.md:                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Q1: Does table already exist?                                   │
│      YES → Check if RPC exists, skip to Step 2.4 if all good    │
│      NO  → Continue to Q2                                        │
│                                                                  │
│  Q2: Is it user-generated data?                                  │
│      (user_reviews, user_follows, user_watch_list)               │
│      YES → Create table only, no population needed               │
│      NO  → Continue to Q3                                        │
│                                                                  │
│  Q3: Should data be AUTO-GENERATED via Supabase triggers?        │
│      (counts, activity feeds, computed timestamps)               │
│      YES → Create trigger in migration                           │
│      │     Examples:                                             │
│      │     • followers_count → trigger on user_follows           │
│      │     • user_activities → trigger on follow/review/etc      │
│      │     • last_activity_at → trigger on any user action       │
│      NO  → Continue to Q4                                        │
│                                                                  │
│  Q4: Is it a CACHE table (derived from existing data)?           │
│      (mood_movies_cache, trending_movies, user_stats)            │
│      YES → Create rebuild RPC + call from sync_caches            │
│      NO  → Continue to Q5                                        │
│                                                                  │
│  Q5: Does data exist in movie-pipeline SQLite?                   │
│      Check: sqlite3 global_database_movies.db ".tables"          │
│      YES → Create table + sync from SQLite                       │
│      NO  → Continue to Q6                                        │
│                                                                  │
│  Q6: Is it static reference data?                                │
│      (countries, languages, certifications)                      │
│      YES → Add hardcoded data to sync_catalogs.py                │
│      NO  → Document external source needed (API, manual)         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**See `/server` command for detailed trigger and cache RPC patterns.**

### Step 2.4: Create Migration

```bash
cd claude-product-cycle/server-layer/supabase

# Create migration file
# Naming: YYYYMMDD_NNN_feature_description.sql
```

Migration includes:
1. CREATE TABLE statements
2. CREATE INDEX statements
3. RLS policies
4. RPC functions
5. Triggers (if needed)

### Step 2.5: Deploy Migration

```bash
cd claude-product-cycle/server-layer/supabase
python3 master.py deploy
```

### Step 2.6: Populate Data (If Needed)

**From SQLite (movie-pipeline):**
```bash
cd claude-product-cycle/server-layer/movie-pipeline

# Check data exists
sqlite3 data/global_database_movies.db "SELECT COUNT(*) FROM table_name"

# If table doesn't exist in SQLite but needed:
# Create it in SQLite first, then sync
```

**Sync to Supabase:**
```bash
cd claude-product-cycle/server-layer/supabase
python3 master.py sync --catalogs  # or appropriate flag
```

### Step 2.7: Update SCHEMA_REGISTRY.md

Add new tables/RPCs to registry:
```markdown
| Table | Purpose | Population | Sync Script |
|-------|---------|------------|-------------|
| new_table | Description | Yes/No | sync_*.py |
```

### Example: MovieDetail Feature

```
API.md requires:
├─ get_movie_details → Uses movies table (exists) ✓
├─ get_movie_credits → Needs movie_credits table
│   └─ Check SQLite: has credits? YES → sync from SQLite
│   └─ Check SQLite: has credits? NO → need TMDB API import first
├─ get_similar_movies → Can derive from movie_moods/genres
│   └─ Create RPC that joins existing tables
├─ get_movie_streaming_availability → External API
│   └─ Create table, document: needs JustWatch API
```

---

## Feature Status List

When `/implement` runs without feature name, show:

```
| Feature | Status | Gaps | Command |
|---------|--------|------|---------|
| Home | ✅ Done | 0 | /implement improve Home |
| MyMood | ⚠️ Needs Update | 4 | /implement MyMood |
| MovieDetail | 🔄 In Progress | 5 | /implement MovieDetail |
| WatchList | 🆕 Not Started | 6 | /implement WatchList |
```

Read status from: `claude-product-cycle/design-spec-layer/STATUS.md`

---

## Auto-Execution Behavior

**SMART AUTOMATIC WITH CHECKPOINTS:**

1. **Execute**: Run each layer completely
2. **Checkpoint**: Show brief summary after each layer
3. **Options**: User can continue, improve, or view
4. **Continue**: Quick response (c/Enter) proceeds immediately
5. **Report**: Final summary at the END

**Checkpoint Flow:**
```
Layer completes → Show summary → Wait for input → Process → Next layer
                                     │
                                     ├─ "c" or Enter → Continue immediately
                                     ├─ "i add cache" → Apply improvement, continue
                                     ├─ "v file.kt" → Show file, wait again
                                     └─ "skip" → Jump to final report
```

**Error Handling:**
- If a layer fails → Show error in checkpoint, offer retry option
- User can fix issue and continue, or skip to next layer
- Final report shows all successes and failures

---

## Final Report Template

At the END of automatic execution, output this summary:

```
╔══════════════════════════════════════════════════════════════════════╗
║  /implement [Feature] - COMPLETE                                      ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  ✅ PHASE 0: GIT SETUP                                                ║
║     └─ Branch: feature/reviews (created from dev)                     ║
║                                                                       ║
║  ✅ PHASE 1: DEPENDENCY VALIDATION                                    ║
║     └─ All dependencies satisfied (tables: 3, RPCs: 2, libs: OK)      ║
║                                                                       ║
║  ✅ PHASE 2: SERVER                                                   ║
║     ├─ Migration: 20251213_001_reviews.sql                            ║
║     ├─ Deployed: 2 tables, 3 RPCs                                     ║
║     ├─ Data synced: 50,000 rows from SQLite                           ║
║     ├─ Updated: SCHEMA_REGISTRY.md                                    ║
║     └─ Commit: feat(reviews): Add server layer [abc1234]              ║
║                                                                       ║
║  ✅ PHASE 3: CLIENT                                                   ║
║     ├─ Files: 5 created (DTO, Service, Mapper, Repo, UseCase)         ║
║     ├─ Tests: 8/8 passed                                              ║
║     ├─ Build: :core:network ✅ :core:data ✅ :core:domain ✅           ║
║     ├─ Lint: detekt ✅ spotless ✅ (3 files formatted)                ║
║     └─ Commit: feat(reviews): Add client layer [def5678]              ║
║                                                                       ║
║  ✅ PHASE 4: FEATURE                                                  ║
║     ├─ Files: 6 created (ViewModel, Screen, Components, Destination)  ║
║     ├─ Tests: 6/6 passed                                              ║
║     ├─ Build: :feature:reviews ✅                                     ║
║     ├─ Lint: detekt ✅ spotless ✅ ktlint ✅                           ║
║     ├─ Hot Reload: Device refreshed ✅                                ║
║     └─ Commit: feat(reviews): Add feature layer [ghi9012]             ║
║                                                                       ║
║  ✅ PHASE 5: FINALIZE                                                 ║
║     ├─ Updated: STATUS.md, SCHEMA_REGISTRY.md                         ║
║     ├─ Final Build: ./gradlew build ✅ (all modules)                  ║
║     └─ Commit: docs(reviews): Update status [jkl3456]                 ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  📊 SUMMARY                                                           ║
║  ├─ Files: +18 created, ~5 modified                                   ║
║  ├─ Tests: 14/14 passed                                               ║
║  ├─ Commits: 4                                                        ║
║  ├─ Time: 8m 23s                                                      ║
║  └─ Errors: 0                                                         ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  🎉 PR READY                                                          ║
║                                                                       ║
║  Branch: feature/reviews                                              ║
║  Base: dev                                                            ║
║                                                                       ║
║  Options:                                                             ║
║  • p / push   → git push -u origin feature/reviews                   ║
║  • c / create → Create PR via gh pr create                           ║
║  • e / edit   → Edit PR description                                  ║
║  • s / skip   → Skip PR creation                                     ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

**If errors occurred:**
```
╠══════════════════════════════════════════════════════════════════════╣
║  ⚠️  ISSUES ENCOUNTERED                                               ║
║  ├─ Server: Migration deploy failed (connection error)                ║
║  ├─ Client: FeatureService.kt skipped (table not created)             ║
║  └─ Build: :core:network FAILED (see error log)                       ║
║                                                                       ║
║  Recovery Options:                                                    ║
║  • retry          → Retry failed phase                                ║
║  • rollback       → Undo all changes                                  ║
║  • /implement [F] → Start fresh                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## Cross-Update Rules

```
After ANY implementation:
├─→ Update feature's STATUS.md
├─→ Update main claude-product-cycle/design-spec-layer/STATUS.md
├─→ New RPC → Update SCHEMA_REGISTRY.md
└─→ Add changelog entries
```

---

## IMPROVE MODE

For `/implement improve [Feature]`:
1. Locate existing code
2. Assess current state vs spec
3. Identify improvements (animations, performance, etc.)
4. Apply improvements
5. Report changes

---

## REVERIFY MODE

For `/implement reverify [Feature]`:
1. Run full verification (4 phases)
2. Output gap report
3. NO implementation changes
4. Suggest commands to fix gaps
