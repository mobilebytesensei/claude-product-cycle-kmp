# Design/Spec Session (Feature SPEC.md)

## ALL COMMANDS (Quick Reference)

```
┌─────────────────────────────────────────────────────────────────────┐
│  DESIGN PHASE                                                        │
├─────────────────────────────────────────────────────────────────────┤
│  /design [Feature]        → Create SPEC.md + API.md (Opus)       ◀  │
├─────────────────────────────────────────────────────────────────────┤
│  IMPLEMENT PHASE                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  /implement [Feature]     → Full implementation (Sonnet)            │
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
└─────────────────────────────────────────────────────────────────────┘
```

---

## /design VARIANTS

```
/design                                     → Show feature list
/design [Feature]                           → Full spec review/create
/design [Feature] from figma [node]         → Design from Figma
/design [Feature] add [section]             → Add specific section
/design [Feature] research [topic]          → Research-based design
```

**Examples:**
```
/design MyMood                              # Full spec review
/design MyMood from figma 70410:8727        # Design from Figma node
/design Home add hero carousel              # Add new section
/design SurpriseMe research Netflix shuffle # Research-based design
```

---

## MODEL CHECK

**This command is designed for OPUS.**

| Task | Why Opus |
|------|----------|
| Figma analysis | Complex visual interpretation |
| Research (Netflix, Disney+) | Multi-source synthesis |
| Architecture decisions | Cross-system impact analysis |
| Spec writing | Precise, comprehensive documentation |

**If on Sonnet, suggest:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ 🔄 MODEL SWITCH SUGGESTED                                            │
├─────────────────────────────────────────────────────────────────────┤
│ /design is architecture/spec work - Opus excels here.               │
│                                                                      │
│ For implementation, use /implement in a Sonnet session.             │
├─────────────────────────────────────────────────────────────────────┤
│ Switch? "yes" → /opus | "no" → Continue (may miss nuances)          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## KEY FILES

```
claude-product-cycle/design-spec-layer/
├── STATUS.md                         # ENTRY POINT - All features
├── features/[feature]/
│   ├── SPEC.md                       # What to build (UI, flows)
│   ├── API.md                        # APIs needed (RPC signatures)
│   └── STATUS.md                     # Feature implementation status
├── SERVER_PLAN.md                    # Backend implementation
└── SCHEMA_REGISTRY.md                # Central table/RPC registry
```

---

## DESIGN WORKFLOW

```
┌───────────────────────────────────────────────────────────────────┐
│                    /design [Feature] WORKFLOW                      │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  STEP 1: GATHER CONTEXT                                           │
│  ├─→ Read claude-product-cycle/design-spec-layer/STATUS.md (overall status)                   │
│  ├─→ Read features/[feature]/SPEC.md (current spec)               │
│  ├─→ Read features/[feature]/API.md (available APIs)              │
│  └─→ Fetch Figma design (if URL/node provided)                    │
│                                                                    │
│  STEP 2: ANALYZE & COMPARE                                        │
│  ├─→ Compare Figma vs current spec                                │
│  ├─→ Identify gaps, outdated sections, missing features           │
│  ├─→ Research patterns (Netflix, Disney+, etc.) if needed         │
│  └─→ Report findings to user                                      │
│                                                                    │
│  STEP 3: UPDATE SPEC.md                                           │
│  ├─→ Update/add sections with ASCII mockups                       │
│  ├─→ Update API tables                                            │
│  ├─→ Update user actions                                          │
│  └─→ Add changelog entry                                          │
│                                                                    │
│  STEP 4: CROSS-UPDATE (MANDATORY)                                 │
│  ├─→ features/[feature]/STATUS.md → "Needs Update"                │
│  ├─→ claude-product-cycle/design-spec-layer/STATUS.md (main tracker)                          │
│  ├─→ features/[feature]/API.md (if new APIs)                      │
│  ├─→ SERVER_PLAN.md (if new RPCs needed)                          │
│  └─→ SCHEMA_REGISTRY.md (if new tables/RPCs)                      │
│                                                                    │
│  STEP 5: GENERATE IMPLEMENTATION SUMMARY                          │
│  └─→ Output clear requirements for /implement                     │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## STEP 1: GATHER CONTEXT

Read these files:
1. `claude-product-cycle/design-spec-layer/STATUS.md` - Overall project status
2. `claude-product-cycle/design-spec-layer/features/[feature]/SPEC.md` - Current feature spec
3. `claude-product-cycle/design-spec-layer/features/[feature]/API.md` - Available APIs

**If Figma URL provided**, fetch design context:
```
mcp__figma__get_design_context(fileKey, nodeId)
mcp__figma__get_screenshot(fileKey, nodeId)
```

**If user provides local screenshot path**, read it with Read tool.

---

## STEP 2: ANALYZE & COMPARE

**Report Template:**
```
🔍 DESIGN ANALYSIS: [Feature]

📄 CURRENT SPEC (features/[feature]/SPEC.md):
- Sections defined: [list]
- APIs referenced: [list]
- Last updated: [date]

🎨 FIGMA DESIGN (if provided):
- Components found: [list]
- New elements: [list not in spec]
- Changed elements: [list differences]

📊 IMPLEMENTATION STATUS:
- Status: [from STATUS.md]
- Gaps: [list]

⚠️ PROPOSED CHANGES:
1. [Change 1]
2. [Change 2]
3. [Change 3]

Proceed with these changes?
```

---

## STEP 3: CREATE/UPDATE SPEC.md

Use this comprehensive template to create awesome specs:

### SPEC.md TEMPLATE

```markdown
# [Feature Name] - Feature Specification

> **Purpose**: [One-line description of what this feature does]
> **User Value**: [Why users need this feature]
> **Last Updated**: [Date]

---

## 1. Overview

### 1.1 Feature Summary
[2-3 sentences describing the feature]

### 1.2 User Stories
- As a user, I want to [action] so that [benefit]
- As a user, I want to [action] so that [benefit]

### 1.3 Success Metrics
| Metric | Target | How to Measure |
|--------|--------|----------------|
| [metric] | [target] | [method] |

---

## 2. Screen Layout

### 2.1 ASCII Mockup

```
┌─────────────────────────────────────────┐
│  ← Back          [Feature Title]    ⋮   │  ← TopBar
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │     Section 1: [Name]            │   │
│  │     [Description]                │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │     Section 2: [Name]            │   │
│  │     [Description]                │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

### 2.2 Sections Table

| # | Section | Description | API | Priority |
|---|---------|-------------|-----|----------|
| 1 | [Name] | [What it shows] | [RPC name] | P0 |
| 2 | [Name] | [What it shows] | [RPC name] | P1 |

---

## 3. User Interactions

### 3.1 Actions Table

| Action | Trigger | Result | API Call |
|--------|---------|--------|----------|
| Tap movie | Click card | Navigate to detail | - |
| Pull refresh | Swipe down | Reload data | [RPC] |
| Filter | Tap filter chip | Filter list | [RPC] |

### 3.2 State Transitions

```
[Initial] → Loading → [Content | Empty | Error]
                          ↓
                    User Action
                          ↓
                    [New State]
```

---

## 4. UI Components

### 4.1 Component List

| Component | Props | Reusable? | Design System? |
|-----------|-------|-----------|----------------|
| [Name] | [props] | Yes/No | Use Sensei[X] |

### 4.2 Component Details

#### 4.2.1 [Component Name]
```
┌─────────────────────────────┐
│  [ASCII of component]       │
└─────────────────────────────┘
```
- **Props**: `title: String`, `onClick: () -> Unit`
- **States**: Default, Loading, Error
- **Animations**: [describe any animations]

---

## 5. Data Requirements

### 5.1 Domain Models

```kotlin
data class [Model](
    val id: String,
    val field1: Type,
    val field2: Type,
)
```

### 5.2 State Model

```kotlin
data class [Feature]State(
    val isLoading: Boolean = false,
    val items: List<Model> = emptyList(),
    val error: String? = null,
    // filters, pagination, etc.
)
```

---

## 6. API Requirements

### 6.1 Required RPCs

| RPC Name | Parameters | Returns | Exists? |
|----------|------------|---------|---------|
| [name] | [params] | [return type] | ✅/❌ |

### 6.2 RPC Details

#### 6.2.1 [RPC Name]
```sql
-- Purpose: [description]
-- Performance: [expected ms]

SELECT * FROM [function_name](
    p_param1 TYPE,
    p_param2 TYPE
) RETURNS TABLE (...)
```

---

## 7. Edge Cases & Error Handling

| Scenario | Behavior | UI Feedback |
|----------|----------|-------------|
| No internet | Show cached | Toast + cache indicator |
| Empty results | Show empty state | Illustration + message |
| API error | Retry logic | Snackbar + retry button |
| Invalid input | Validate locally | Inline error message |

---

## 8. Accessibility

| Element | Requirement |
|---------|-------------|
| Images | contentDescription |
| Buttons | min 48dp touch target |
| Text | min 14sp, high contrast |
| Screen reader | proper focus order |

---

## 9. Performance Considerations

| Aspect | Target | Implementation |
|--------|--------|----------------|
| Initial load | < 500ms | Prefetch, skeleton |
| Scroll | 60fps | LazyColumn, key() |
| Memory | < 50MB | Image caching |

---

## 10. Testing Checklist

- [ ] Unit tests for ViewModel
- [ ] UI tests for Screen
- [ ] Integration tests for Repository
- [ ] Manual test on all platforms

---

## 11. Figma References

| Screen/Component | Figma Node | Link |
|------------------|------------|------|
| Main screen | [node_id] | [url] |
| Component X | [node_id] | [url] |

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| [date] | Initial spec | Claude |
```

---

### SPEC QUALITY CHECKLIST

Before finishing, verify:

```
✅ SPEC COMPLETENESS
├── [ ] ASCII mockup matches Figma
├── [ ] All sections documented
├── [ ] All user actions listed
├── [ ] All API requirements defined
├── [ ] Edge cases covered
├── [ ] Error states defined
├── [ ] Accessibility considered
├── [ ] Performance targets set

✅ IMPLEMENTATION READY
├── [ ] State model defined
├── [ ] Domain models defined
├── [ ] RPC signatures complete
├── [ ] Component list clear
├── [ ] No ambiguous requirements
```

---

## STEP 4: CROSS-UPDATE (MANDATORY)

After updating SPEC.md, MUST update:

| File | What to Update |
|------|----------------|
| `features/[feature]/STATUS.md` | Status → "Needs Update", add changelog |
| `claude-product-cycle/design-spec-layer/STATUS.md` | Update feature row |
| `features/[feature]/API.md` | Add new API signatures if needed |
| `SERVER_PLAN.md` | Add RPC details if new server work needed |
| `SCHEMA_REGISTRY.md` | Add new tables/RPCs to registry |

---

## STEP 5: IMPLEMENTATION SUMMARY

**Output this at the end:**

```
┌───────────────────────────────────────────────────────────────────┐
│            IMPLEMENTATION REQUIREMENTS                             │
│            Ready for /implement in Sonnet session                  │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  FEATURE: [Feature Name]                                          │
│  SPEC UPDATED: features/[feature]/SPEC.md                         │
│                                                                    │
│  ════════════════════════════════════════════════════════════════ │
│                                                                    │
│  SERVER WORK NEEDED:                                              │
│  [ ] New RPC: [name] - [description]                              │
│  [ ] Modified RPC: [name] - [what changed]                        │
│  [x] No server changes needed                                     │
│                                                                    │
│  CLIENT WORK NEEDED:                                              │
│  [ ] Network: [DTO/Service changes]                               │
│  [ ] Data: [Repository changes]                                   │
│  [ ] Domain: [UseCase changes]                                    │
│                                                                    │
│  FEATURE WORK NEEDED:                                             │
│  [ ] New component: [name]                                        │
│  [ ] Modified screen: [what to change]                            │
│  [ ] New section: [name]                                          │
│                                                                    │
│  ════════════════════════════════════════════════════════════════ │
│                                                                    │
│  CROSS-UPDATES APPLIED:                                           │
│  ✅ features/[feature]/STATUS.md → "Needs Update"                 │
│  ✅ claude-product-cycle/design-spec-layer/STATUS.md → Updated                                │
│  ✅ [other files if changed]                                      │
│                                                                    │
│  ════════════════════════════════════════════════════════════════ │
│                                                                    │
│  NEXT STEP:                                                       │
│  In Sonnet session, run:  /implement [Feature]                    │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## IF NO FEATURE NAME PROVIDED

Show feature list from STATUS.md:

```
📋 FEATURES AVAILABLE FOR DESIGN:

| Feature | Status | Last Updated | Command |
|---------|--------|--------------|---------|
| Home | ✅ Done | 2025-12-09 | /design Home |
| MyMood | ✅ Done | 2025-12-10 | /design MyMood |
| MovieDetail | 🔄 In Progress | 2025-12-10 | /design MovieDetail |
| WatchList | 🔄 In Progress | 2025-12-10 | /design WatchList |
| SurpriseMe | 📋 Planned | - | /design SurpriseMe |
| Search | 📋 Planned | - | /design Search |
| Profile | 📋 Planned | - | /design Profile |
| AllFilters | ✅ Done | 2025-12-11 | /design AllFilters |
| Onboarding | ✅ Done | 2025-12-09 | /design Onboarding |

Which feature do you want to design?
```

---

## WORKFLOW SUMMARY

```
┌─────────────────────────────────────────────────────────────────────┐
│                    OPUS SESSION: /design [Feature]                   │
├─────────────────────────────────────────────────────────────────────┤
│  1. Read STATUS.md + feature bundle (SPEC, API, STATUS)             │
│  2. Analyze (Figma, research, current spec)                         │
│  3. Propose changes → get user approval                             │
│  4. Update SPEC.md                                                  │
│  5. Cross-update all related files                                  │
│  6. Output IMPLEMENTATION REQUIREMENTS                              │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    SONNET SESSION: /implement [Feature]              │
├─────────────────────────────────────────────────────────────────────┤
│  1. Read updated SPEC.md (ready from Opus)                          │
│  2. Detect "Needs Update" status                                    │
│  3. Implement: Server → Client → Feature                            │
│  4. Update STATUS.md → "Done"                                       │
└─────────────────────────────────────────────────────────────────────┘
```
