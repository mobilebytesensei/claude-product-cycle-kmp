# Mockups Folder

> Drop your mockup images here for Claude to analyze during design/implementation.

---

## Folder Structure

```
mockups/
├── README.md              ← This file
├── main-screen.png        ← Primary screen mockup
├── states/                ← Alternative states
│   ├── loading.png
│   ├── empty.png
│   └── error.png
├── components/            ← Individual component mockups
│   ├── header.png
│   ├── card.png
│   └── button.png
└── ai-generated/          ← AI-generated mockups
    ├── midjourney/
    └── dalle/
```

---

## How to Use

### 1. Drop Mockup for Design Phase

When running `/design [Feature]`, Claude will automatically check this folder and analyze any images found.

```bash
# Just drop your image and run
/design Reviews
```

Claude will:
- Analyze the visual elements
- Extract components and layout
- Generate SPEC.md sections based on mockup
- Create component hierarchy

### 2. Explicit Mockup Reference

You can also explicitly reference a mockup:

```bash
/design Reviews --mockup mockups/main-screen.png
```

### 3. Multiple Mockups

Drop multiple images for different states:
- `main-screen.png` - Main content view
- `empty-state.png` - When no data
- `loading-state.png` - Loading skeleton
- `detail-view.png` - Expanded/detail view

---

## Image Requirements

| Requirement | Value | Reason |
|------------|-------|--------|
| **Resolution** | Min 1080px wide | Clear component visibility |
| **Format** | PNG or JPG | Best compatibility |
| **Clarity** | High contrast | Better analysis |
| **Coverage** | Full screen | Complete context |
| **Naming** | Descriptive | Easy reference |

### Good Naming Examples

```
✅ reviews-main-dark.png
✅ reviews-empty-state.png
✅ reviews-card-component.png
✅ reviews-loading-skeleton.png

❌ IMG_001.png
❌ screenshot.jpg
❌ new.png
```

---

## Auto-Detection

When you run `/design [Feature]`, Claude automatically:

1. **Scans** `mockups/` folder for images
2. **Reads** each image (PNG, JPG, JPEG, WEBP)
3. **Analyzes** visual elements:
   - Layout structure
   - Component hierarchy
   - Color palette
   - Typography
   - Spacing
4. **Generates** SPEC sections:
   - Visual Design (Section 2)
   - Component Hierarchy (Section 3)
   - Design Tokens (Section 2.3)

---

## Mockup Sources

### From Figma

1. Select frame in Figma
2. Export as PNG (2x recommended)
3. Drop in `mockups/`

### From AI Tools

Use the prompts in SPEC.md Section 9:

**Midjourney:**
```
/imagine Mobile app screen, iOS/Android, Material Design 3,
dark mode, movie app, [your feature description],
purple accent (#8B5CF6), clean minimal UI --ar 9:19
```

**DALL-E:**
```
High fidelity mobile app UI mockup showing [feature description],
Material Design 3, dark theme with purple accents,
movie streaming app aesthetic, modern typography
```

### From Competitors

Take screenshots of competitor apps for inspiration:
- Place in `mockups/inspiration/`
- Reference in SPEC.md Section 10.2

---

## Verification Checklist

Before dropping a mockup:

- [ ] Image is clear and readable
- [ ] Shows complete screen (not cropped)
- [ ] Includes all key UI elements
- [ ] File named descriptively
- [ ] Placed in correct subfolder

---

## Example Workflow

```bash
# 1. Create mockup in Figma or AI tool

# 2. Drop in folder
cp ~/Downloads/reviews-screen.png mockups/main-screen.png

# 3. Run design command
/design Reviews

# Claude will:
# - Read mockups/main-screen.png
# - Analyze visual elements
# - Generate SPEC.md with:
#   - ASCII mockup matching image
#   - Component hierarchy
#   - Design tokens extracted from image
#   - Implementation checklist
```

---

## Tips

1. **Multiple Views**: Drop mockups for different states (main, empty, error)
2. **Component Focus**: Add close-up mockups for complex components
3. **Dark + Light**: If supporting both themes, add mockups for each
4. **Annotations**: Add text annotations to highlight specific elements
5. **Version Control**: Consider `.gitignore` for large AI-generated files
