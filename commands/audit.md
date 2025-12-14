# Feature Audit Command

Perform a comprehensive audit of all features in the project.

## Instructions

You are performing a **feature audit**. This command analyzes all features in the project and generates a comprehensive audit report identifying gaps, quality issues, and priorities.

---

## Phase 1: Discovery

### Step 1.1: Read Project Configuration

```
READ: .claude-product-cycle.yaml
```

Extract:
- Project name
- All listed features and their status
- Backend type

### Step 1.2: Discover All Features

```
READ: claude-product-cycle/design-spec-layer/STATUS.md
SCAN: claude-product-cycle/design-spec-layer/features/*/
```

Build a complete feature list with current status.

---

## Phase 2: Spec Quality Assessment

### Step 2.1: Check Each Feature Spec

For each feature, read SPEC.md and assess against 12-section template:

```
12-SECTION TEMPLATE CHECKLIST:
1. Overview (Purpose, User Stories, Success Metrics)
2. Visual Design (ASCII mockups, Design Tokens)
3. Component Hierarchy
4. User Interactions (Actions Matrix, Navigation Flows)
5. State Management (State classes, State Transitions)
6. Animations (Micro-interactions, timing, easing)
7. API Requirements (RPC signatures, DTOs)
8. Accessibility (A11y requirements, Screen Reader Flow)
9. Performance (Targets, Optimizations)
10. Testing (Unit, UI, Integration test requirements)
11. Mockup References (Figma nodes)
12. Implementation Checklist (Server, Client, Feature status)
```

Rate each spec:
- **None**: No spec exists
- **Basic**: 1-4 sections
- **Good**: 5-8 sections
- **Excellent**: 9-12 sections

### Step 2.2: Check Figma References

Verify each feature has linked Figma node IDs.

---

## Phase 3: Implementation Verification

### Step 3.1: Server Layer Check

For each feature, verify RPCs exist:

```
SCAN: core/network/src/commonMain/kotlin/**/service/**
CHECK: RPC methods match API.md
```

### Step 3.2: Client Layer Check

For each feature, verify layers exist:

```
SCAN: core/network/src/commonMain/kotlin/**/service/[feature]/
SCAN: core/data/src/commonMain/kotlin/**/repository/
SCAN: core/domain/src/commonMain/kotlin/**/usecase/
```

### Step 3.3: Feature Layer Check

For each feature, verify UI exists:

```
SCAN: feature/[feature]/src/commonMain/kotlin/
CHECK: ViewModel, Screen, Components, DI Module
```

---

## Phase 4: Generate Report

### Step 4.1: Create/Update FEATURE_AUDIT.md

```
WRITE: claude-product-cycle/design-spec-layer/FEATURE_AUDIT.md
```

Use the template and fill in:
- Executive Summary with counts
- Feature-by-feature audit tables
- Spec Quality Matrix
- Implementation Gap Analysis
- Priority Action Plan
- Recommendations

### Step 4.2: Calculate Metrics

| Metric | Calculation |
|--------|-------------|
| Total Features | Count of all features |
| Done Features | Count with all layers complete |
| Spec Quality Issues | Count of Basic/None specs |
| Implementation Gaps | Count of missing layers |

---

## Phase 5: Summary Output

### Output Format

```
┌─────────────────────────────────────────────────────────────┐
│  FEATURE AUDIT COMPLETE                                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📊 Summary                                                  │
│  ├── Total Features: X                                       │
│  ├── Done: X | In Progress: X | Planned: X                  │
│  ├── Spec Quality: X Excellent, X Good, X Basic, X None     │
│  └── Implementation: X Complete, X Partial, X Missing       │
│                                                              │
│  ⚠️  Critical Issues (X)                                    │
│  ├── Issue 1                                                 │
│  └── Issue 2                                                 │
│                                                              │
│  📋 Priority Actions                                         │
│  ├── P1: [Action 1]                                         │
│  ├── P1: [Action 2]                                         │
│  └── P2: [Action 3]                                         │
│                                                              │
│  📁 Report: claude-product-cycle/design-spec-layer/         │
│            FEATURE_AUDIT.md                                  │
│                                                              │
│  Next: /design [Feature] to create/upgrade specs            │
│        /implement [Feature] to implement                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Options

| Option | Behavior |
|--------|----------|
| `/audit` | Full audit of all features |
| `/audit [Feature]` | Audit single feature only |
| `/audit --quick` | Quick summary without details |
| `/audit --specs` | Spec quality only |
| `/audit --impl` | Implementation status only |

---

## Cross-Update Rules

After audit, if issues found:
1. Update STATUS.md with any corrections
2. Create FEATURE_AUDIT.md with findings
3. Suggest next actions

---

## Examples

### Example 1: Full Audit
```
User: /audit
Claude: [Performs full audit, generates report]
```

### Example 2: Single Feature
```
User: /audit Home
Claude: [Audits Home feature only, shows detailed status]
```

### Example 3: Quick Summary
```
User: /audit --quick
Claude: [Shows summary counts only, no detailed report]
```
