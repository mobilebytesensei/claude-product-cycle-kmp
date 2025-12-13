# Feature Implementation Session

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
│  /client [Feature]        → Network + Data + Domain layers          │
│  /feature [Feature]       → UI layer (ViewModel + Screen)        ◀  │
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

Read these for Feature layer (ViewModel + Screen):

1. `claude-product-cycle/design-spec-layer/STATUS.md` - **Single status tracker**
2. `claude-product-cycle/design-spec-layer/_shared/PATTERNS.md` - MVI, navigation, UI patterns
3. `claude-product-cycle/design-spec-layer/features/[feature]/SPEC.md` - Screen specs and user actions

---

## Feature Layer Structure

```kotlin
// 1. Create UiState, Event, Effect
data class FeatureState(...)
sealed interface FeatureEvent { ... }
sealed interface FeatureEffect { ... }

// 2. Create ViewModel (MVI)
class FeatureViewModel(useCase: ...) : BaseViewModel<S, E, A>

// 3. Create Screen composable
@Composable
fun FeatureScreen(viewModel: FeatureViewModel = koinViewModel())

// 4. Register in FeatureModule.kt
viewModelOf(::FeatureViewModel)

// 5. Add navigation route
```

---

## Critical Pattern

```kotlin
// UseCase: Creates Pager, returns Flow
fun invoke(): Flow<PagingData<T>> = Pager(config, pagingSourceFactory).flow

// ViewModel: Exposes Flow directly (NO stateIn!)
val items: Flow<PagingData<T>> = useCase()

// Screen: Collects as LazyPagingItems
val items = viewModel.items.collectAsLazyPagingItems()
```

---

## Preview Annotations (MANDATORY)

ALL new components and screens MUST include @Preview:

```kotlin
@Preview
@Composable
private fun MyComponentPreview() {
    MaterialTheme {
        MyComponent(/* sample data */)
    }
}
```

---

## Auto-Execution Behavior

After each step:
1. Brief what was implemented
2. Ask "Want to improve this, or continue?"
3. Wait for user response

---

## Cross-Update Rules (MANDATORY)

After ANY feature layer change:
```
New/Modified ViewModel → Update feature-layer/LAYER_STATUS.md (module status + changelog)
                       → Update [Feature]Module.kt registration

New/Modified Screen → Update feature-layer/LAYER_STATUS.md (changelog)
                    → Add navigation route if new

New/Modified Components → Update feature-layer/LAYER_STATUS.md (component count + changelog)

New Feature Module → Update feature-layer/LAYER_STATUS.md (module count + changelog)
                   → Update KoinModules.kt
                   → Update RootNavScreen.kt

Feature done → Update feature's STATUS.md
            → Update design-spec-layer/STATUS.md
            → Update feature-layer/LAYER_STATUS.md (status + changelog)
```

**LAYER_STATUS Location**: `claude-product-cycle/feature-layer/LAYER_STATUS.md`

---

## Next Commands

- `/implement [Feature]` - Full feature workflow
- `/client` - If client layers needed
- `/server` - If backend changes needed
