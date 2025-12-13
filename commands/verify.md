# Verify Feature Implementation

## ALL COMMANDS (Quick Reference)

```
┌─────────────────────────────────────────────────────────────────────┐
│  WORKFLOW                                                            │
├─────────────────────────────────────────────────────────────────────┤
│  /projectstatus           → Project overview                        │
│  /design [Feature]        → Create blueprint (Opus)                 │
│  /implement [Feature]     → Build from blueprint (Sonnet)           │
│  /verify [Feature]        → Validate implementation              ◀  │
├─────────────────────────────────────────────────────────────────────┤
│  LAYER COMMANDS                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  /server [Feature]        → Backend layer                           │
│  /client [Feature]        → Network + Data + Domain                 │
│  /feature [Feature]       → UI layer                                │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Purpose

Validate that implementation matches the spec. Catches gaps before they become bugs.

---

## Verification Phases

### Phase 1: SPEC vs Code

```
Read: claude-product-cycle/design-spec-layer/features/[feature]/SPEC.md

Check:
□ All screen sections implemented?
□ All user actions handled?
□ All state models match spec?
□ All components exist?
□ ASCII mockup matches actual UI?
```

### Phase 2: API vs Implementation

```
Read: claude-product-cycle/design-spec-layer/features/[feature]/API.md

Check:
□ All RPCs called from client?
□ All DTOs created?
□ All parameters passed correctly?
□ Error handling implemented?
```

### Phase 3: Layer Integrity

```
Check:
□ Feature → Domain → Data → Network flow?
□ No layer violations (Data not using SupabaseClient directly)?
□ All DI modules registered?
□ Build passes for all layers?
```

### Phase 4: Status Sync

```
Check:
□ Feature's STATUS.md matches implementation?
□ Main STATUS.md updated?
□ SCHEMA_REGISTRY.md has all RPCs?
```

---

## Verification Commands

```bash
# Build verification
./gradlew :core:network:build
./gradlew :core:data:build
./gradlew :core:domain:build
./gradlew :feature:[name]:build

# Full project build
./gradlew build
```

---

## Output Format

### If Gaps Found

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️  VERIFICATION REPORT: [Feature]                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SPEC GAPS:                                                          │
│  □ Section "Hero Carousel" not implemented                          │
│  □ User action "Pull to refresh" not handled                        │
│                                                                      │
│  API GAPS:                                                           │
│  □ RPC get_featured_movies not called                               │
│  □ DTO missing field: release_date                                  │
│                                                                      │
│  LAYER ISSUES:                                                       │
│  □ Repository importing SupabaseClient directly                     │
│                                                                      │
│  STATUS SYNC:                                                        │
│  □ STATUS.md says "Done" but 3 gaps found                           │
│                                                                      │
│  ════════════════════════════════════════════════════════════════   │
│                                                                      │
│  FIX COMMANDS:                                                       │
│  /feature [Feature]    → Fix UI gaps                                │
│  /client [Feature]     → Fix API/layer gaps                         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### If All Good

```
┌─────────────────────────────────────────────────────────────────────┐
│  ✅ VERIFICATION PASSED: [Feature]                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SPEC:    ✅ All sections implemented                                │
│  API:     ✅ All RPCs integrated                                     │
│  LAYERS:  ✅ Clean architecture maintained                           │
│  STATUS:  ✅ Documentation in sync                                   │
│  BUILD:   ✅ All modules compile                                     │
│                                                                      │
│  Feature is ready for production!                                    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Usage

```
/verify Home           # Verify Home feature
/verify MovieDetail    # Verify MovieDetail feature
/verify all            # Verify ALL features (master report)
```
