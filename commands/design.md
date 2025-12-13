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
/design [Feature] --mockup [path/url]       → Design from mockup image
/design [Feature] --figma [node]            → Design from Figma node
/design [Feature] --research [competitor]   → Research-based design
/design [Feature] --add [section]           → Add specific section
/design [Feature] --quick                   → Quick spec (minimal)
```

**Examples:**
```bash
# From local mockup screenshot
/design MyMood --mockup /path/to/mockup.png

# From Figma
/design MyMood --figma 70410:8727

# Research competitor patterns
/design SurpriseMe --research "Netflix shuffle, Spotify discover"

# Add section to existing spec
/design Home --add "hero carousel"

# Quick spec for simple feature
/design Settings --quick
```

---

## 🎨 MOCKUP INTEGRATION

### Supported Mockup Sources

```
┌─────────────────────────────────────────────────────────────────────┐
│  MOCKUP SOURCES                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. LOCAL SCREENSHOT                                                 │
│     /design Reviews --mockup /path/to/reviews-screen.png            │
│     /design Reviews --mockup ~/Desktop/mockup.jpg                   │
│     → Reads image with Read tool, analyzes visually                 │
│                                                                      │
│  2. FIGMA (via MCP)                                                  │
│     /design Reviews --figma FILE_KEY:NODE_ID                        │
│     → Uses mcp__figma__get_design_context + get_screenshot          │
│                                                                      │
│  3. URL (Web Image)                                                  │
│     /design Reviews --mockup https://example.com/mockup.png         │
│     → Fetches and analyzes image                                    │
│                                                                      │
│  4. CLIPBOARD REFERENCE                                              │
│     "I have a mockup in my clipboard" or "see attached image"       │
│     → User provides path, Claude reads it                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Mockup Analysis Process

```
┌─────────────────────────────────────────────────────────────────────┐
│  INTELLIGENT MOCKUP ANALYSIS                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 1: VISUAL EXTRACTION                                          │
│  ├─→ Identify screen sections (header, content, footer)             │
│  ├─→ Extract component hierarchy                                    │
│  ├─→ Identify UI patterns (cards, lists, grids, tabs)              │
│  ├─→ Detect interactive elements (buttons, inputs, gestures)        │
│  └─→ Note empty states, loading states if visible                   │
│                                                                      │
│  STEP 2: DESIGN TOKEN EXTRACTION                                    │
│  ├─→ Colors (background, text, accent, surface)                     │
│  ├─→ Typography (sizes, weights, styles)                            │
│  ├─→ Spacing (margins, padding, gaps)                               │
│  ├─→ Corner radius patterns                                         │
│  ├─→ Shadow/elevation levels                                        │
│  └─→ Icon styles                                                    │
│                                                                      │
│  STEP 3: COMPONENT MAPPING                                          │
│  ├─→ Map to existing Design System components                       │
│  ├─→ Identify new components needed                                 │
│  ├─→ Define component variants/states                               │
│  └─→ Create component hierarchy tree                                │
│                                                                      │
│  STEP 4: INTERACTION INFERENCE                                      │
│  ├─→ Infer tap targets                                              │
│  ├─→ Infer scroll behavior                                          │
│  ├─→ Infer navigation patterns                                      │
│  ├─→ Suggest animations                                             │
│  └─→ Identify gestures (swipe, long-press, etc.)                   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Mockup Analysis Report

After analyzing mockup, output:

```
╔══════════════════════════════════════════════════════════════════════╗
║  🎨 MOCKUP ANALYSIS: [Feature Name]                                   ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  📱 SCREEN STRUCTURE                                                  ║
║  ┌─────────────────────────────────────────┐                         ║
║  │ [TopBar] Title + Actions                │                         ║
║  ├─────────────────────────────────────────┤                         ║
║  │ [Section 1] Hero/Featured               │                         ║
║  │ [Section 2] Horizontal List             │                         ║
║  │ [Section 3] Grid Layout                 │                         ║
║  │ [Section 4] Action Button               │                         ║
║  └─────────────────────────────────────────┘                         ║
║                                                                       ║
║  🎯 COMPONENTS IDENTIFIED                                             ║
║  ├─ TopBar (back, title, menu)                                       ║
║  ├─ MovieCard (poster, title, rating) × 6                            ║
║  ├─ SectionHeader (title, "See All")                                 ║
║  ├─ FilterChips (genre, year, mood)                                  ║
║  └─ FloatingActionButton (surprise me)                               ║
║                                                                       ║
║  🎨 DESIGN TOKENS EXTRACTED                                           ║
║  ├─ Primary: #6366F1 (Indigo)                                        ║
║  ├─ Background: #0F0F0F (Dark)                                       ║
║  ├─ Surface: #1A1A1A (Card background)                               ║
║  ├─ Text Primary: #FFFFFF                                            ║
║  ├─ Text Secondary: #9CA3AF                                          ║
║  ├─ Corner Radius: 12dp (cards), 24dp (buttons)                      ║
║  └─ Spacing: 16dp (margin), 12dp (gap)                               ║
║                                                                       ║
║  ⚡ INTERACTIONS INFERRED                                             ║
║  ├─ Tap movie card → Navigate to detail                              ║
║  ├─ Horizontal scroll → Browse movies                                ║
║  ├─ Pull down → Refresh content                                      ║
║  ├─ Tap FAB → Trigger surprise action                                ║
║  └─ Long press card → Show options menu                              ║
║                                                                       ║
║  🔧 NEW COMPONENTS NEEDED                                             ║
║  ├─ SurpriseButton (animated FAB)                                    ║
║  └─ MoodFilterBar (horizontal chip group)                            ║
║                                                                       ║
║  ✅ EXISTING COMPONENTS TO USE                                        ║
║  ├─ SenseiTopBar → TopBar                                            ║
║  ├─ MoviePosterCard → Movie cards                                    ║
║  ├─ SenseiChip → Filter chips                                        ║
║  └─ SenseiButton → Action buttons                                    ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝

Proceed to generate comprehensive SPEC.md from this analysis?
```

---

## MODEL CHECK

**This command is designed for OPUS.**

| Task | Why Opus |
|------|----------|
| Mockup visual analysis | Complex image interpretation |
| Figma analysis | Visual + structural understanding |
| Research (Netflix, Disney+) | Multi-source synthesis |
| Architecture decisions | Cross-system impact analysis |
| Spec writing | Precise, comprehensive documentation |

**If on Sonnet, suggest:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ 🔄 MODEL SWITCH SUGGESTED                                            │
├─────────────────────────────────────────────────────────────────────┤
│ /design requires visual analysis and comprehensive spec writing.    │
│ Opus excels at these tasks.                                          │
│                                                                      │
│ For implementation, use /implement in a Sonnet session.             │
├─────────────────────────────────────────────────────────────────────┤
│ Switch? "yes" → /opus | "no" → Continue (may miss visual details)   │
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
│   ├── STATUS.md                     # Feature implementation status
│   └── mockups/                      # Reference mockups (optional)
│       └── [feature]-main.png
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
│  STEP 0: MOCKUP INTAKE (If provided)                              │
│  ├─→ Read mockup image (local path, Figma, or URL)                │
│  ├─→ Perform visual analysis (components, tokens, interactions)   │
│  ├─→ Generate Mockup Analysis Report                              │
│  └─→ Get user confirmation on extracted elements                  │
│                                                                    │
│  STEP 1: GATHER CONTEXT                                           │
│  ├─→ Read STATUS.md (overall status)                              │
│  ├─→ Read features/[feature]/SPEC.md (current spec)               │
│  ├─→ Read features/[feature]/API.md (available APIs)              │
│  └─→ Read existing design system components                       │
│                                                                    │
│  STEP 2: ANALYZE & COMPARE                                        │
│  ├─→ Compare mockup vs current spec                               │
│  ├─→ Identify gaps, outdated sections, missing features           │
│  ├─→ Research competitor patterns if needed                       │
│  └─→ Report findings to user                                      │
│                                                                    │
│  STEP 3: CREATE COMPREHENSIVE SPEC.md                             │
│  ├─→ Use Production-Quality SPEC Template                         │
│  ├─→ Include all sections from mockup analysis                    │
│  ├─→ Map components to design system                              │
│  ├─→ Define all states and transitions                            │
│  ├─→ Specify animations and micro-interactions                    │
│  └─→ Add accessibility requirements                               │
│                                                                    │
│  STEP 4: CROSS-UPDATE (MANDATORY)                                 │
│  ├─→ features/[feature]/STATUS.md → "Needs Update"                │
│  ├─→ STATUS.md (main tracker)                                     │
│  ├─→ features/[feature]/API.md (if new APIs)                      │
│  ├─→ SERVER_PLAN.md (if new RPCs needed)                          │
│  └─→ SCHEMA_REGISTRY.md (if new tables/RPCs)                      │
│                                                                    │
│  STEP 5: GENERATE IMPLEMENTATION BRIEF                            │
│  └─→ Output detailed requirements for /implement                  │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## PRODUCTION-QUALITY SPEC TEMPLATE

This template creates specs that enable production-level implementation:

```markdown
# [Feature Name] - Feature Specification

> **Purpose**: [One-line description]
> **User Value**: [Why users need this]
> **Complexity**: [Simple | Medium | Complex]
> **Last Updated**: [Date]
> **Mockup**: [Path or Figma link]

---

## 1. Overview

### 1.1 Feature Summary
[2-3 sentences describing the feature and its core value proposition]

### 1.2 User Stories
| Priority | As a... | I want to... | So that... |
|----------|---------|--------------|------------|
| P0 | User | [action] | [benefit] |
| P1 | User | [action] | [benefit] |
| P2 | User | [action] | [benefit] |

### 1.3 Success Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| Load time | < 500ms | Analytics |
| User engagement | +20% | Session tracking |
| Error rate | < 1% | Crash analytics |

### 1.4 Out of Scope
- [What this feature does NOT include]
- [Future enhancements to consider later]

---

## 2. Visual Design

### 2.1 Screen Layout (ASCII from Mockup)

```
┌─────────────────────────────────────────────────────────────┐
│  ← Back          Feature Title              ⋮ More        │ TopBar
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SECTION 1: [Name]                                   │   │
│  │  [Description of what this section contains]         │   │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                    │   │
│  │  │ ▢ 1 │ │ ▢ 2 │ │ ▢ 3 │ │ ▢ 4 │ ← Horizontal     │   │
│  │  └─────┘ └─────┘ └─────┘ └─────┘   Scroll           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SECTION 2: [Name]                                   │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │  Grid Item 1   │   Grid Item 2   │           │    │   │
│  │  ├─────────────────────────────────────────────┤    │   │
│  │  │  Grid Item 3   │   Grid Item 4   │           │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│                        ┌─────────┐                          │
│                        │   FAB   │ ← Floating Action       │
│                        └─────────┘                          │
├─────────────────────────────────────────────────────────────┤
│  🏠 Home  │  🎭 Mood  │  ✨ Surprise  │  📋 List  │  👤    │ BottomNav
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Sections Breakdown

| # | Section | Content | Scroll | API | Priority |
|---|---------|---------|--------|-----|----------|
| 1 | TopBar | Title, back, menu | Fixed | - | P0 |
| 2 | [Name] | [Content description] | Horizontal | [RPC] | P0 |
| 3 | [Name] | [Content description] | Vertical | [RPC] | P1 |

### 2.3 Design Tokens (from Mockup)

```kotlin
// Colors extracted from mockup
object FeatureColors {
    val background = Color(0xFF0F0F0F)
    val surface = Color(0xFF1A1A1A)
    val surfaceVariant = Color(0xFF2A2A2A)
    val primary = Color(0xFF6366F1)
    val onPrimary = Color(0xFFFFFFFF)
    val textPrimary = Color(0xFFFFFFFF)
    val textSecondary = Color(0xFF9CA3AF)
    val divider = Color(0xFF2A2A2A)
}

// Dimensions
object FeatureDimens {
    val screenPadding = 16.dp
    val sectionGap = 24.dp
    val cardGap = 12.dp
    val cardCornerRadius = 12.dp
    val buttonCornerRadius = 24.dp
    val iconSize = 24.dp
    val thumbnailHeight = 180.dp
}

// Typography
object FeatureTypography {
    val sectionTitle = TextStyle(fontSize = 20.sp, fontWeight = FontWeight.Bold)
    val cardTitle = TextStyle(fontSize = 14.sp, fontWeight = FontWeight.Medium)
    val cardSubtitle = TextStyle(fontSize = 12.sp, fontWeight = FontWeight.Normal)
}
```

---

## 3. Component Hierarchy

### 3.1 Component Tree

```
[Feature]Screen
├── Scaffold
│   ├── TopBar
│   │   ├── BackButton
│   │   ├── Title
│   │   └── MenuButton
│   │
│   ├── Content (LazyColumn)
│   │   ├── Section1
│   │   │   ├── SectionHeader
│   │   │   └── HorizontalList
│   │   │       └── ItemCard (× N)
│   │   │
│   │   ├── Section2
│   │   │   ├── SectionHeader
│   │   │   └── GridLayout
│   │   │       └── GridItem (× N)
│   │   │
│   │   └── Section3
│   │       └── [Component]
│   │
│   └── FloatingActionButton
│
└── BottomSheet (conditional)
    └── [BottomSheetContent]
```

### 3.2 Component Specifications

#### 3.2.1 [ComponentName]

```
┌─────────────────────────────────────────┐
│  ┌─────────┐                            │
│  │ 🎬      │  Title Text                │
│  │ Image   │  Subtitle text             │
│  │         │  ⭐ 8.5                    │
│  └─────────┘                            │
└─────────────────────────────────────────┘
```

| Property | Type | Description |
|----------|------|-------------|
| imageUrl | String | Poster/thumbnail URL |
| title | String | Primary text |
| subtitle | String? | Secondary text (optional) |
| rating | Float? | Rating value (optional) |
| onClick | () -> Unit | Tap handler |

**States:**
- Default: Normal display
- Loading: Shimmer placeholder
- Error: Fallback image
- Pressed: Scale down 0.95 + ripple

**Design System Mapping:**
- Use `MoviePosterCard` from core:designsystem
- Customize with feature-specific colors

---

## 4. User Interactions

### 4.1 Actions Matrix

| # | Element | Gesture | Action | Feedback | API |
|---|---------|---------|--------|----------|-----|
| 1 | MovieCard | Tap | Navigate to detail | Ripple + scale | - |
| 2 | MovieCard | Long press | Show options menu | Haptic + menu | - |
| 3 | Section | Horizontal swipe | Scroll items | Smooth scroll | - |
| 4 | Screen | Pull down | Refresh content | Refresh indicator | [RPC] |
| 5 | FAB | Tap | Trigger surprise | Haptic + animation | [RPC] |
| 6 | Filter chip | Tap | Toggle filter | Chip state change | [RPC] |

### 4.2 Navigation Flows

```
[Feature]Screen
    │
    ├──[Tap movie]──→ MovieDetailScreen(movieId)
    │                      │
    │                      └──[Back]──→ [Feature]Screen
    │
    ├──[Tap filter]──→ FilterBottomSheet
    │                      │
    │                      └──[Apply]──→ [Feature]Screen (filtered)
    │
    └──[Tap FAB]──→ SurpriseResultScreen
                        │
                        └──[Dismiss]──→ [Feature]Screen
```

### 4.3 Gesture Details

| Gesture | Area | Behavior |
|---------|------|----------|
| Swipe left/right | Horizontal list | Scroll with momentum |
| Pull down | Top of screen | Refresh (60dp threshold) |
| Fling | Any list | Fast scroll with deceleration |
| Pinch | Image (if applicable) | Zoom (if enabled) |

---

## 5. State Management

### 5.1 Screen State

```kotlin
data class [Feature]State(
    // Loading states
    val isLoading: Boolean = false,
    val isRefreshing: Boolean = false,

    // Content
    val sections: List<Section> = emptyList(),
    val featuredItems: List<Item> = emptyList(),

    // Filters
    val selectedFilters: Set<FilterType> = emptySet(),
    val availableFilters: List<Filter> = emptyList(),

    // Pagination
    val hasMoreItems: Boolean = true,
    val currentPage: Int = 0,

    // Error handling
    val error: ErrorState? = null,

    // UI state
    val isFilterSheetVisible: Boolean = false,
    val scrollPosition: Int = 0,
)

sealed interface ErrorState {
    data object NetworkError : ErrorState
    data object ServerError : ErrorState
    data class CustomError(val message: String) : ErrorState
}
```

### 5.2 State Transitions

```
┌─────────────────────────────────────────────────────────────────────┐
│                        STATE MACHINE                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  [Initial]                                                           │
│      │                                                               │
│      ▼                                                               │
│  [Loading] ─────────────────┬─────────────────┐                     │
│      │                      │                 │                      │
│      ▼                      ▼                 ▼                      │
│  [Content]             [Empty]            [Error]                    │
│      │                      │                 │                      │
│      │                      │                 │                      │
│      ├──[Pull refresh]──→ [Refreshing] ──────┤                      │
│      │                      │                 │                      │
│      ├──[Load more]─────→ [LoadingMore]       │                      │
│      │                      │                 │                      │
│      ├──[Filter]────────→ [Filtering] ───────┤                      │
│      │                      │                 │                      │
│      └──[Tap item]──────→ [Navigation] ◀─────┘                      │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.3 Empty & Error States

| State | Illustration | Title | Message | Action |
|-------|--------------|-------|---------|--------|
| Empty | 🎬 | No movies found | Try adjusting filters | Clear filters |
| Network error | 📡 | No connection | Check your internet | Retry |
| Server error | ⚠️ | Something went wrong | We're working on it | Retry |
| Auth required | 🔐 | Sign in required | Log in to continue | Sign in |

---

## 6. Animations & Micro-interactions

### 6.1 Screen Transitions

| Transition | Animation | Duration | Easing |
|------------|-----------|----------|--------|
| Enter screen | Slide up + Fade in | 300ms | EaseOutCubic |
| Exit screen | Slide down + Fade out | 250ms | EaseInCubic |
| Navigate to detail | Shared element (poster) | 400ms | FastOutSlowIn |

### 6.2 Component Animations

| Component | Trigger | Animation | Duration |
|-----------|---------|-----------|----------|
| Card press | Touch down | Scale to 0.95 | 100ms |
| Card release | Touch up | Scale to 1.0 | 150ms |
| Shimmer | Loading | Shimmer sweep | 1000ms loop |
| FAB | Appear | Scale + Fade | 200ms |
| Filter chip | Select | Background color | 200ms |
| Refresh | Pull | Rotate indicator | Continuous |

### 6.3 Micro-interactions

```kotlin
// Card press animation
val scale by animateFloatAsState(
    targetValue = if (isPressed) 0.95f else 1f,
    animationSpec = spring(stiffness = Spring.StiffnessMedium)
)

// Staggered list animation
items.forEachIndexed { index, item ->
    val delay = index * 50
    AnimatedVisibility(
        visible = true,
        enter = fadeIn(animationSpec = tween(300, delayMillis = delay))
    )
}
```

---

## 7. API Requirements

### 7.1 Required RPCs

| RPC | Method | Parameters | Returns | Exists? |
|-----|--------|------------|---------|---------|
| get_[feature]_data | SELECT | user_id, filters | List<Item> | ❌ |
| get_[feature]_filters | SELECT | category | List<Filter> | ❌ |
| update_[feature]_preference | UPDATE | user_id, pref | Boolean | ❌ |

### 7.2 RPC Specifications

#### 7.2.1 get_[feature]_data

```sql
-- Purpose: Fetch main content for [Feature] screen
-- Expected response time: < 50ms
-- Caching: 5 minutes (invalidate on filter change)

CREATE OR REPLACE FUNCTION get_[feature]_data(
    p_user_id UUID,
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0,
    p_filters JSONB DEFAULT '{}'
)
RETURNS TABLE (
    id UUID,
    title TEXT,
    poster_path TEXT,
    rating DECIMAL,
    -- additional fields
)
AS $$ ... $$
```

### 7.3 Response Models

```kotlin
@Serializable
data class [Feature]ResponseDto(
    val items: List<ItemDto>,
    @SerialName("has_more")
    val hasMore: Boolean,
    @SerialName("total_count")
    val totalCount: Int,
)

@Serializable
data class ItemDto(
    val id: String,
    val title: String,
    @SerialName("poster_path")
    val posterPath: String?,
    val rating: Double?,
)
```

---

## 8. Accessibility (A11y)

### 8.1 Requirements Checklist

| Requirement | Implementation |
|-------------|----------------|
| Touch targets | Min 48dp × 48dp |
| Color contrast | 4.5:1 minimum |
| Content descriptions | All images labeled |
| Focus order | Logical top-to-bottom |
| Screen reader | Proper semantics |
| Dynamic text | Support up to 200% |
| Reduce motion | Respect system setting |

### 8.2 Semantic Labels

```kotlin
// Card semantic
Modifier.semantics {
    contentDescription = "Movie: $title, Rating: $rating stars"
    role = Role.Button
}

// Section semantic
Modifier.semantics {
    heading()
    contentDescription = "Section: $sectionTitle, $itemCount items"
}

// Action semantic
Modifier.semantics {
    contentDescription = "Surprise me button, double tap to get random movie"
}
```

---

## 9. Performance Requirements

### 9.1 Targets

| Metric | Target | How to Achieve |
|--------|--------|----------------|
| Initial load | < 500ms | Skeleton + prefetch |
| List scroll | 60fps | LazyColumn + key() |
| Image load | < 200ms | Coil caching |
| Memory | < 50MB | Image downsampling |
| APK impact | < 200KB | Code splitting |

### 9.2 Optimizations

```kotlin
// Use stable keys for list items
LazyColumn {
    items(
        items = items,
        key = { it.id }  // Stable key
    ) { item ->
        ItemCard(item)
    }
}

// Image optimization
AsyncImage(
    model = ImageRequest.Builder(context)
        .data(imageUrl)
        .size(Size.ORIGINAL)
        .crossfade(true)
        .memoryCachePolicy(CachePolicy.ENABLED)
        .build()
)
```

---

## 10. Testing Requirements

### 10.1 Test Coverage

| Layer | Test Type | Coverage Target |
|-------|-----------|-----------------|
| ViewModel | Unit | 90% |
| Repository | Unit | 85% |
| UseCase | Unit | 100% |
| Screen | UI/Snapshot | Key states |
| Integration | E2E | Happy path |

### 10.2 Test Cases

```kotlin
// ViewModel tests
class [Feature]ViewModelTest {
    @Test
    fun `initial state is loading`()

    @Test
    fun `successful load updates state with content`()

    @Test
    fun `error sets error state`()

    @Test
    fun `refresh triggers reload`()

    @Test
    fun `filter changes trigger filtered load`()
}
```

---

## 11. Mockup References

| Screen/State | Source | Link/Path |
|--------------|--------|-----------|
| Main screen | Figma | [node_id] |
| Empty state | Figma | [node_id] |
| Loading state | Local | mockups/loading.png |
| Error state | Local | mockups/error.png |

---

## 12. Implementation Checklist

### Server Layer
- [ ] Create/update database tables
- [ ] Create RPC functions
- [ ] Add RLS policies
- [ ] Update SCHEMA_REGISTRY.md

### Client Layer
- [ ] Create DTOs
- [ ] Create Service interface + impl
- [ ] Create Repository
- [ ] Create UseCase(s)
- [ ] Register in DI modules

### Feature Layer
- [ ] Create State/Event/Action
- [ ] Create ViewModel
- [ ] Create Screen
- [ ] Create Components
- [ ] Add Navigation
- [ ] Add @Preview functions
- [ ] Add to string resources

### Quality
- [ ] Unit tests written
- [ ] Accessibility verified
- [ ] Performance tested
- [ ] All platforms checked

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| [date] | Initial spec from mockup | Claude |
```

---

## SPEC QUALITY SCORING

After creating spec, self-evaluate:

```
╔══════════════════════════════════════════════════════════════════════╗
║  📊 SPEC QUALITY SCORE                                                ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  COMPLETENESS (40 points)                                            ║
║  ├── [10] Visual design documented                           ✅ 10   ║
║  ├── [10] Component hierarchy defined                        ✅ 10   ║
║  ├── [10] All interactions listed                            ✅ 10   ║
║  └── [10] State management complete                          ✅ 10   ║
║                                                                       ║
║  CLARITY (30 points)                                                 ║
║  ├── [10] ASCII mockup matches design                        ✅ 10   ║
║  ├── [10] No ambiguous requirements                          ✅ 10   ║
║  └── [10] Design tokens specified                            ✅ 10   ║
║                                                                       ║
║  IMPLEMENTATION READY (30 points)                                    ║
║  ├── [10] APIs fully specified                               ✅ 10   ║
║  ├── [10] Animations defined                                 ✅ 10   ║
║  └── [10] Edge cases covered                                 ✅ 10   ║
║                                                                       ║
║  ════════════════════════════════════════════════════════════════    ║
║  TOTAL SCORE: 100/100 - PRODUCTION READY ✅                          ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## IMPLEMENTATION BRIEF OUTPUT

At the end, output this for `/implement`:

```
╔══════════════════════════════════════════════════════════════════════╗
║  📋 IMPLEMENTATION BRIEF                                              ║
║  Ready for: /implement [Feature] in Sonnet session                   ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  FEATURE: [Feature Name]                                             ║
║  SPEC: features/[feature]/SPEC.md                                    ║
║  MOCKUP: [path or Figma link]                                        ║
║  QUALITY SCORE: 95/100                                               ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  SERVER LAYER                                                         ║
║  ├── Tables: [list new tables]                                       ║
║  ├── RPCs: [list new RPCs with signatures]                           ║
║  └── Effort: [Low/Medium/High]                                       ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  CLIENT LAYER                                                         ║
║  ├── DTOs: [list]                                                    ║
║  ├── Services: [list]                                                ║
║  ├── Repositories: [list]                                            ║
║  ├── UseCases: [list]                                                ║
║  └── Effort: [Low/Medium/High]                                       ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  FEATURE LAYER                                                        ║
║  ├── Screen: [Feature]Screen                                         ║
║  ├── ViewModel: [Feature]ViewModel                                   ║
║  ├── Components:                                                     ║
║  │   ├── [Component1] (new)                                          ║
║  │   ├── [Component2] (new)                                          ║
║  │   └── [ExistingComponent] (reuse from designsystem)               ║
║  ├── Animations: [list key animations]                               ║
║  └── Effort: [Low/Medium/High]                                       ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  DESIGN SYSTEM COMPONENTS TO USE                                      ║
║  ├── SenseiTopBar                                                    ║
║  ├── SenseiButton                                                    ║
║  ├── MoviePosterCard                                                 ║
║  └── [others from core:designsystem]                                 ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  CROSS-UPDATES APPLIED                                               ║
║  ├── ✅ features/[feature]/STATUS.md → "Needs Update"                ║
║  ├── ✅ STATUS.md → Updated                                          ║
║  ├── ✅ API.md → Added [N] new RPCs                                  ║
║  └── ✅ SCHEMA_REGISTRY.md → Added entries                           ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  ESTIMATED EFFORT                                                     ║
║  ├── Server: 15 min                                                  ║
║  ├── Client: 20 min                                                  ║
║  ├── Feature: 30 min                                                 ║
║  └── Total: ~1 hour                                                  ║
║                                                                       ║
╠══════════════════════════════════════════════════════════════════════╣
║  NEXT STEP                                                           ║
║  In Sonnet session, run:                                             ║
║                                                                       ║
║    /implement [Feature]                                              ║
║                                                                       ║
║  Or for specific layers:                                             ║
║    /implement [Feature] --layers server,client                       ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## QUICK SPEC MODE

For simple features, use `--quick`:

```
/design Settings --quick

Creates minimal spec with:
- Overview (1 paragraph)
- Simple ASCII layout
- Basic actions table
- Required APIs
- No animations/a11y details
```

---

## WORKFLOW SUMMARY

```
┌─────────────────────────────────────────────────────────────────────┐
│                    OPUS SESSION: /design [Feature]                   │
├─────────────────────────────────────────────────────────────────────┤
│  0. Analyze mockup (if provided) → Extract components, tokens       │
│  1. Read STATUS.md + feature bundle                                  │
│  2. Compare mockup vs current spec                                   │
│  3. Propose changes → get user approval                             │
│  4. Create comprehensive SPEC.md                                     │
│  5. Cross-update all related files                                  │
│  6. Output IMPLEMENTATION BRIEF                                      │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    SONNET SESSION: /implement [Feature]              │
├─────────────────────────────────────────────────────────────────────┤
│  1. Read comprehensive SPEC.md (ready from Opus)                     │
│  2. Detect "Needs Update" status                                     │
│  3. Implement: Server → Client → Feature                            │
│  4. Use exact design tokens from spec                                │
│  5. Implement specified animations                                   │
│  6. Update STATUS.md → "Done"                                       │
└─────────────────────────────────────────────────────────────────────┘
```
