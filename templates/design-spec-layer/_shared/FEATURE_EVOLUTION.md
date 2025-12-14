# Feature Evolution Guide

> **Purpose**: How to enhance, update, or evolve existing features while keeping design specs in sync
> **Audience**: Developers, Product Managers, Designers
> **Last Updated**: {{DATE}}

---

## Overview

Features evolve over time. This guide defines the proper workflow to:
1. Request changes to existing features
2. Communicate requirements to the design layer
3. Keep specs and implementation synchronized
4. Track evolution history

---

## The Design-Implementation Loop

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      FEATURE EVOLUTION LOOP                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                   │
│   │  DISCOVER   │ ──► │   DESIGN    │ ──► │  IMPLEMENT  │                   │
│   │  (Gap/Need) │     │  (Update    │     │  (Code      │                   │
│   │             │     │   SPEC.md)  │     │   Changes)  │                   │
│   └─────────────┘     └──────┬──────┘     └──────┬──────┘                   │
│         ▲                    │                   │                          │
│         │                    │                   │                          │
│         │              ┌─────▼─────┐             │                          │
│         │              │  VERIFY   │◄────────────┘                          │
│         │              │  (Spec vs │                                        │
│         │              │   Code)   │                                        │
│         │              └─────┬─────┘                                        │
│         │                    │                                              │
│         └────────────────────┘                                              │
│                    Feedback Loop                                            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Method 1: Enhancement Request (Structured)

Use this format when requesting feature enhancements:

### Template: `ENHANCEMENT_REQUEST.md`

```markdown
# Enhancement Request: [Feature Name]

## Current Behavior
> Describe what the feature currently does

[Describe current behavior]

## Desired Behavior
> Describe what you want it to do

[Describe desired behavior]

## Why This Change?
> Business/UX justification

- [ ] User feedback
- [ ] Analytics insight
- [ ] Competitive feature
- [ ] Bug/UX issue
- [ ] Performance improvement

## Affected Areas

| Layer | Impact | Files |
|-------|--------|-------|
| Server | Low/Medium/High | [RPCs affected] |
| Client | Low/Medium/High | [Repositories/UseCases] |
| Feature | Low/Medium/High | [Screens/ViewModels] |

## Visual Changes (if any)

[ASCII mockup or Figma link]

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Priority

- [ ] P1: Critical (blocking users)
- [ ] P2: High (major improvement)
- [ ] P3: Medium (nice to have)
- [ ] P4: Low (future consideration)
```

### Example: Enhance Mood Selection Flow

```markdown
# Enhancement Request: Manage Moods

## Current Behavior
User must complete 4-step mood selection flow. No way to skip or quick-select.

## Desired Behavior
Add "Quick Mood" option: user can tap an emoji to instantly set mood without full flow.

## Why This Change?
- [ ] User feedback ✓ (users find 4 steps tedious for daily use)
- [ ] Analytics insight ✓ (60% drop-off at step 3)

## Affected Areas

| Layer | Impact | Files |
|-------|--------|-------|
| Server | Low | None (existing RPC works) |
| Client | Medium | CreateUserMoodUseCase (add quick mode) |
| Feature | High | New QuickMoodSheet component |

## Visual Changes

```
Home Screen (new floating button)
┌─────────────────────────────┐
│                      [😊]   │  ← Quick Mood FAB
│                             │
│   [Movie Cards...]          │
│                             │
└─────────────────────────────┘

Quick Mood Sheet (bottom sheet)
┌─────────────────────────────┐
│     How are you feeling?    │
│                             │
│  😊  😢  🤩  😌  💕  😤    │
│                             │
│  [Full Selection →]         │
└─────────────────────────────┘
```

## Acceptance Criteria

- [ ] FAB visible on Home screen
- [ ] Bottom sheet shows 6 primary moods
- [ ] Tap emoji → instant mood set
- [ ] "Full Selection" → existing 4-step flow
- [ ] Existing flow unchanged

## Priority
- [x] P2: High (major improvement)
```

---

## Method 2: Spec Update Commands

Use slash commands to update specs directly:

### `/design update [Feature]`

Updates an existing feature spec based on new requirements.

```
User: /design update ManageMoods --add "Quick Mood selection via FAB"

Claude:
1. Reads existing SPEC.md
2. Analyzes enhancement request
3. Updates relevant sections:
   - Visual Design (new mockups)
   - Component Hierarchy (new components)
   - User Interactions (new actions)
   - State Management (new states)
   - API Requirements (if needed)
4. Marks STATUS.md as "Needs Update"
5. Adds changelog entry
```

### `/design diff [Feature]`

Shows differences between spec and implementation.

```
User: /design diff ManageMoods

Claude:
┌──────────────────────────────────────────────────────────┐
│  SPEC vs IMPLEMENTATION DIFF: ManageMoods                │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ✅ IN SYNC                                               │
│  ├── 4-step flow                                         │
│  ├── ADD/UPDATE modes                                    │
│  └── All components implemented                          │
│                                                           │
│  ⚠️  SPEC AHEAD (not yet implemented)                    │
│  └── Quick Mood FAB (added 2024-12-14)                   │
│                                                           │
│  🔴 CODE AHEAD (not in spec)                             │
│  └── None                                                │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## Method 3: Inline Spec Comments

Add enhancement notes directly in SPEC.md:

### Format

```markdown
## 4. User Interactions

### 4.1 Actions Matrix

| Action | Trigger | Result |
|--------|---------|--------|
| Select mood | Tap card | Highlight + enable continue |

<!-- ENHANCEMENT_REQUEST: 2024-12-14
@requester: developer
@priority: P2
@description: Add quick mood selection via emoji tap
@status: pending_review
-->
```

### Processing

When `/design update` runs, it processes these inline requests:
1. Extracts enhancement comments
2. Incorporates into spec sections
3. Removes processed comments
4. Updates changelog

---

## Method 4: Chat-Based Spec Evolution

Have a conversation with Claude to evolve specs:

### Conversation Pattern

```
User: I want to enhance the mood selection flow. Currently users
      have to go through 4 steps every time they want to change
      their mood. Can we add a quick selection option?

Claude: I understand you want to add a Quick Mood option. Let me
        analyze the current SPEC.md...

        Current flow: Onboarding → Select Mood → Select Emotion →
        Movie Finder Engine

        For quick selection, I suggest:

        Option A: Quick Mood FAB on Home
        - Floating button shows emoji picker
        - Tap emoji → set mood instantly
        - Full flow still accessible

        Option B: Mood Swipe Widget
        - Horizontal emoji row at top of Home
        - Swipe to change mood
        - Tap for full flow

        Which approach would you prefer?

User: Option A sounds good. Can you update the spec?

Claude: I'll update the SPEC.md with Quick Mood FAB...

        [Updates SPEC.md sections 2, 3, 4, 5]
        [Marks STATUS.md as "Needs Update"]
        [Adds changelog entry]

        Done! Here's a summary of changes:
        - Added QuickMoodFAB to Component Hierarchy
        - Added QuickMoodSheet visual design
        - Added new actions to Actions Matrix
        - Added QuickMoodState to State Management

        Ready for implementation with /implement ManageMoods
```

---

## Spec Update Checklist

When updating a feature spec, ensure these sections are reviewed:

### Mandatory Updates

- [ ] **Section 1: Overview** - Update user stories if new behavior
- [ ] **Section 2: Visual Design** - Add/modify mockups
- [ ] **Section 3: Component Hierarchy** - Add new components
- [ ] **Section 4: User Interactions** - Update actions matrix
- [ ] **Section 5: State Management** - Add new states/transitions
- [ ] **Section 12: Implementation Checklist** - Uncheck affected items

### Conditional Updates

- [ ] **Section 6: Animations** - If new micro-interactions
- [ ] **Section 7: API Requirements** - If new RPCs needed
- [ ] **Section 8: Accessibility** - If new UI elements
- [ ] **Section 9: Performance** - If performance-sensitive change
- [ ] **Section 10: Testing** - Add new test requirements

### Always Update

- [ ] **Version History** - Add changelog entry
- [ ] **STATUS.md** - Mark as "Needs Update"
- [ ] **Cross-update** - Update related features if affected

---

## Cross-Feature Communication

When an enhancement affects multiple features:

### Impact Analysis Template

```markdown
## Cross-Feature Impact: [Enhancement Name]

### Primary Feature
- **Feature**: ManageMoods
- **Change**: Add Quick Mood FAB

### Affected Features

| Feature | Impact | Required Updates |
|---------|--------|------------------|
| Home | High | Add FAB to screen |
| MyMood | Medium | Show quick mood in header |
| Profile | Low | Update mood display |

### Shared Components

| Component | Current Location | Change Required |
|-----------|------------------|-----------------|
| MoodChip | core/ui | Add "quick" variant |
| MoodEmoji | managemoods | Move to core/ui |

### Data Flow Changes

```
Before: Home ─────────────────────────► ManageMoods (full flow)

After:  Home ──┬── QuickMoodSheet ──► CreateUserMood (quick)
               │
               └── ManageMoods (full flow)
```
```

---

## Version Control for Specs

### Semantic Versioning for Specs

```
SPEC Version: X.Y.Z

X = Major (breaking changes, complete redesign)
Y = Minor (new features, enhancements)
Z = Patch (bug fixes, clarifications)
```

### Changelog Format

```markdown
## Version History

| Date | Version | Change |
|------|---------|--------|
| 2024-12-14 | 1.1.0 | Added Quick Mood FAB feature |
| 2024-12-13 | 1.0.1 | Clarified emotion selection behavior |
| 2024-12-10 | 1.0.0 | Initial 12-section production spec |
```

---

## Workflow Summary

### For Developers

1. **Found a gap?** → Create Enhancement Request
2. **Quick idea?** → Add inline comment in SPEC.md
3. **Complex change?** → Chat with Claude using `/design update`
4. **Ready to implement?** → `/implement [Feature]`

### For Product/Design

1. **New requirement?** → Update SPEC.md directly or use Enhancement Request
2. **Visual change?** → Update Section 2 (Visual Design) with mockups
3. **Behavior change?** → Update Sections 4-5 (Interactions, State)
4. **Verify sync** → `/design diff [Feature]`

### For Everyone

1. **Check status** → Read feature STATUS.md
2. **Understand flow** → Read USER_FLOWS.md
3. **See patterns** → Read PATTERNS.md
4. **Track progress** → Check main STATUS.md

---

## Quick Reference Commands

| Command | Purpose |
|---------|---------|
| `/design [Feature]` | Create new spec |
| `/design update [Feature]` | Update existing spec |
| `/design diff [Feature]` | Show spec vs code diff |
| `/implement [Feature]` | Implement from spec |
| `/verify [Feature]` | Verify implementation vs spec |
| `/audit` | Full project audit |
| `/audit [Feature]` | Single feature audit |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| `SPEC.md` | Feature specification (12 sections) |
| `API.md` | API contracts and DTOs |
| `STATUS.md` | Implementation status |
| `USER_FLOWS.md` | Navigation intelligence |
| `PATTERNS.md` | Implementation patterns |
| `CROSS_UPDATE_RULES.md` | Spec synchronization rules |
