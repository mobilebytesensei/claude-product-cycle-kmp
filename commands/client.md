# Client/Mobile Session

## ALL COMMANDS (Quick Reference)

```
┌─────────────────────────────────────────────────────────────────────┐
│  DESIGN PHASE                                                        │
├─────────────────────────────────────────────────────────────────────┤
│  /design [Feature]        → Create SPEC.md + API.md (Opus)          │
├─────────────────────────────────────────────────────────────────────┤
│  IMPLEMENT PHASE                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  /implement [Feature]     → Full implementation (Sonnet)            │
│                                                                      │
│  OR use layer commands independently:                                │
│  /server [Feature]        → Backend/Supabase layer                  │
│  /client [Feature]        → Network + Data + Domain layers       ◀  │
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
└─────────────────────────────────────────────────────────────────────┘
```

---

Read these for KMP client development:

1. `claude-product-cycle/design-spec-layer/STATUS.md` - **Single status tracker** (WHERE we are)
2. `claude-product-cycle/design-spec-layer/_shared/PATTERNS.md` - Implementation patterns (HOW to build)
3. `claude-product-cycle/design-spec-layer/features/[feature]/` - Feature bundles (SPEC.md, API.md, STATUS.md)

---

## Workflow

1. **Check Status**: Read `claude-product-cycle/design-spec-layer/STATUS.md` for overall status
2. **Pick Feature**: Choose feature from status (Not Started → In Progress)
3. **Read Feature Bundle**: `claude-product-cycle/design-spec-layer/features/[feature]/` has:
   - `SPEC.md` - What to build
   - `API.md` - APIs needed
   - `STATUS.md` - Current implementation status
4. **Read Patterns**: `claude-product-cycle/design-spec-layer/_shared/PATTERNS.md` for layer templates
5. **Implement Layers**: Network → Data → Domain → Feature
6. **Update Status**: Mark completed in feature's `STATUS.md` and main `claude-product-cycle/design-spec-layer/STATUS.md`

---

## Layer Implementation Order

```kotlin
// 1. Network Layer (core/network)
//    - Create DTO matching feature's API.md
//    - Create Service interface + Impl
//    - Register in NetworkModule.kt

// 2. Data Layer (core/data)
//    - Create Mapper (DTO → Domain Model)
//    - Create Repository interface + Impl
//    - Create PagingSource if paginated
//    - Register in RepositoryModule.kt

// 3. Domain Layer (core/domain)
//    - Create UseCase
//    - Register in DomainModule.kt
```

---

## Auto-Execution Behavior

After completing EACH layer:
1. **Brief**: Summarize what was implemented
2. **Ask**: "Want to improve this, or should I continue?"
3. **Wait**: For user response

---

## Cross-Update Rules (MANDATORY)

After modifying ANY client layer:
```
New/Modified Service → Update client-layer/LAYER_STATUS.md (service count + changelog)
                     → Update NetworkModule.kt registration

New/Modified Repository → Update client-layer/LAYER_STATUS.md (repo count + changelog)
                        → Update RepositoryModule.kt registration

New/Modified UseCase → Update client-layer/LAYER_STATUS.md (usecase count + changelog)
                     → Update DomainModule.kt registration

New/Modified PagingSource → Update client-layer/LAYER_STATUS.md (changelog)

Feature STATUS.md changed → Update design-spec-layer/STATUS.md
New RPC needed → Update SCHEMA_REGISTRY.md
```

**LAYER_STATUS Location**: `claude-product-cycle/client-layer/LAYER_STATUS.md`

---

## Next Commands

After client work:
- `/feature` - Implement Feature layer
- `/implement [Feature]` - Full feature workflow
- `/server` - If backend changes needed
