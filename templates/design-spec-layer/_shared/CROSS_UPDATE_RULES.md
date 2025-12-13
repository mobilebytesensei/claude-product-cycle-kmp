# Cross-Update Rules

**MANDATORY**: When modifying any plan file, Claude MUST automatically update all related files.

---

## Cross-Update Matrix

| When You Change... | MUST Also Update... | What to Update |
|-------------------|---------------------|----------------|
| `features/[feature]/SPEC.md` | `features/[feature]/STATUS.md` | Status → "Needs Update" |
| `features/[feature]/SPEC.md` | `STATUS.md` | Main status tracker |
| `features/[feature]/API.md` | `SERVER_PLAN.md` | RPC references |
| `features/[feature]/API.md` | `SCHEMA_REGISTRY.md` | RPC registry section |
| `SERVER_PLAN.md` (new table) | `SCHEMA_REGISTRY.md` | Table registry section |
| `SERVER_PLAN.md` (new RPC) | `features/[feature]/API.md` | Full RPC signature |
| `features/[feature]/STATUS.md` | `STATUS.md` | Sync feature status |
| Any plan | Same plan | Add changelog entry |

---

## Automatic Cross-Update Workflow

```
┌───────────────────────────────────────────────────────────────────┐
│              MANDATORY CROSS-UPDATE WORKFLOW                       │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. MAKE CHANGE to primary plan file                              │
│                                                                    │
│  2. CHECK MATRIX above for required updates                        │
│                                                                    │
│  3. UPDATE each related plan:                                      │
│     ├─→ Add/modify relevant sections                              │
│     ├─→ Update status trackers (e.g., "Needs Update")             │
│     └─→ Add CHANGELOG entry with date + description               │
│                                                                    │
│  4. REPORT cross-updates to user:                                 │
│     "📋 Cross-updates applied:                                     │
│      - STATUS.md: Feature status → Needs Update                    │
│      - SERVER_PLAN.md: Added filter params table                   │
│      - API.md: Added section reference"                            │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## Status Values

| Status | Meaning | Trigger |
|--------|---------|---------|
| **Not Started** | No implementation begun | New feature |
| **In Progress** | Currently being implemented | Work started |
| **Done** | All spec sections + APIs complete | All checkboxes ✅ |
| **Needs Update** | Spec changed, implementation out of sync | SPEC.md change |
| **Planned** | In backlog | Future work |

---

## When to Set "Needs Update"

- SPEC.md adds new sections to a feature
- SPEC.md adds new APIs to a feature
- API.md adds new parameters to existing RPC
- Design changes that affect implementation

---

## Example: Feature SPEC.md Change

```
User: Update the filters in SPEC.md

Claude:
1. ✅ Updated features/[feature]/SPEC.md (filters section)
2. 📋 Cross-updates applied:
   - features/[feature]/STATUS.md:
     - Status: "In Progress" → "Needs Update"
     - Changelog: "2025-12-13 | SPEC changed"
   - STATUS.md:
     - [Feature] row updated to "Needs Update"
   - features/[feature]/API.md:
     - Added new filter parameters
     - Changelog: "2025-12-13 | New filter params"
```

---

## Layer-Specific Cross-Updates

### After Server Layer Changes

```
New/Modified Table → Update SCHEMA_REGISTRY.md (table registry)
                   → Update feature's API.md (if needed)

New/Modified RPC → Update SCHEMA_REGISTRY.md (RPC registry)
                 → Update feature's API.md (add full signature)
                 → Update SERVER_PLAN.md (implementation details)

Migration Created → Update feature's STATUS.md (server: ✅)
```

### After Client Layer Changes

```
New/Modified Service → Update NetworkModule.kt registration
                     → Update feature's STATUS.md (network: ✅)

New/Modified Repository → Update RepositoryModule.kt registration
                        → Update feature's STATUS.md (data: ✅)

New/Modified UseCase → Update DomainModule.kt registration
                     → Update feature's STATUS.md (domain: ✅)
```

### After Feature Layer Changes

```
New/Modified ViewModel → Update FeatureModule.kt registration

New/Modified Screen → Update navigation if new route

New Feature Module → Update KoinModules.kt
                   → Update RootNavScreen.kt
                   → Update feature's STATUS.md (ui: ✅)

Feature Complete → Update feature's STATUS.md → "Done"
                 → Update main STATUS.md → "Done"
```

---

## Report Template

After ANY implementation, output:

```
📋 CROSS-UPDATES APPLIED:
├─ [file1]: [what changed]
├─ [file2]: [what changed]
└─ [file3]: [what changed]
```
