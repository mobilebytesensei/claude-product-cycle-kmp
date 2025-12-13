#!/bin/bash

# Claude Product Cycle - Add Feature Script
# Usage: ./add-feature.sh FeatureName

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

FEATURE_NAME="$1"

if [[ -z "$FEATURE_NAME" ]]; then
    echo -e "${RED}Error: Feature name required${NC}"
    echo "Usage: $0 FeatureName"
    exit 1
fi

# Find project root
PROJECT_ROOT="$(pwd)"
while [[ ! -f "$PROJECT_ROOT/.claude-product-cycle.yaml" && "$PROJECT_ROOT" != "/" ]]; do
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

if [[ ! -f "$PROJECT_ROOT/.claude-product-cycle.yaml" ]]; then
    echo -e "${RED}Error: .claude-product-cycle.yaml not found${NC}"
    exit 1
fi

# Find template dir (for templates)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Get date
DATE=$(date +%Y-%m-%d)

# Convert feature name
FEATURE_NAME_LOWER=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]')

# Feature directory
FEATURE_DIR="$PROJECT_ROOT/claude-product-cycle/design-spec-layer/features/$FEATURE_NAME_LOWER"

if [[ -d "$FEATURE_DIR" ]]; then
    echo -e "${YELLOW}Feature '$FEATURE_NAME' already exists${NC}"
    exit 1
fi

echo -e "${BLUE}Creating feature: $FEATURE_NAME${NC}"

# Create feature directory
mkdir -p "$FEATURE_DIR"

# Create SPEC.md
cat > "$FEATURE_DIR/SPEC.md" << EOF
# $FEATURE_NAME - Feature Specification

> **Purpose**: [One-line description]
> **User Value**: [Why users need this]
> **Last Updated**: $DATE

---

## 1. Overview

### 1.1 Feature Summary
[2-3 sentences describing the feature]

### 1.2 User Stories
- As a user, I want to [action] so that [benefit]
- As a user, I want to [action] so that [benefit]

---

## 2. Screen Layout

### 2.1 ASCII Mockup

\`\`\`
┌─────────────────────────────────────────┐
│  ← Back          [Title]            ⋮   │  ← TopBar
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │     Section 1                    │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
\`\`\`

### 2.2 Sections Table

| # | Section | Description | API | Priority |
|---|---------|-------------|-----|----------|
| 1 | [Name] | [What it shows] | [RPC name] | P0 |

---

## 3. User Interactions

| Action | Trigger | Result | API Call |
|--------|---------|--------|----------|
| [Action] | [Trigger] | [Result] | [RPC] |

---

## 4. UI Components

| Component | Props | Reusable? |
|-----------|-------|-----------|
| [Name] | [props] | Yes/No |

---

## 5. Data Requirements

### State Model

\`\`\`kotlin
data class ${FEATURE_NAME}State(
    val isLoading: Boolean = false,
    val error: String? = null,
)
\`\`\`

---

## 6. API Requirements

| RPC Name | Parameters | Returns | Exists? |
|----------|------------|---------|---------|
| get_${FEATURE_NAME_LOWER} | [params] | [type] | ❌ |

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Initial spec |
EOF

# Create API.md
cat > "$FEATURE_DIR/API.md" << EOF
# $FEATURE_NAME - API Contract

> API definitions for $FEATURE_NAME feature.
> **Last Updated**: $DATE

---

## Required RPCs

| RPC | Purpose | Status |
|-----|---------|--------|
| get_${FEATURE_NAME_LOWER} | Main data fetch | ❌ Not Created |

---

## RPC Signatures

### get_${FEATURE_NAME_LOWER}

\`\`\`sql
CREATE OR REPLACE FUNCTION get_${FEATURE_NAME_LOWER}(
    p_user_id UUID,
    p_limit INTEGER DEFAULT 20,
    p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
    id UUID,
    created_at TIMESTAMPTZ
) AS \$\$
BEGIN
    RETURN QUERY
    SELECT ...
    LIMIT p_limit
    OFFSET p_offset;
END;
\$\$ LANGUAGE plpgsql;
\`\`\`

---

## DTOs

\`\`\`kotlin
@Serializable
data class ${FEATURE_NAME}Dto(
    @SerialName("id") val id: String,
    @SerialName("created_at") val createdAt: String,
)
\`\`\`

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Initial API design |
EOF

# Create STATUS.md
cat > "$FEATURE_DIR/STATUS.md" << EOF
# $FEATURE_NAME - Implementation Status

> Implementation progress for $FEATURE_NAME feature.

---

## Status: Not Started

---

## Layer Checklist

### Server Layer
- [ ] Tables created
- [ ] RPCs created
- [ ] RLS policies added

### Client Layer
- [ ] DTO created
- [ ] Service created
- [ ] Repository created
- [ ] UseCase created
- [ ] DI registered

### Feature Layer
- [ ] ViewModel created
- [ ] Screen created
- [ ] Components created
- [ ] Navigation registered
- [ ] DI registered

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Created status tracker |
EOF

# Update main STATUS.md to add feature
STATUS_FILE="$PROJECT_ROOT/claude-product-cycle/design-spec-layer/STATUS.md"
if [[ -f "$STATUS_FILE" ]]; then
    # Add feature to features list in config
    echo "| $FEATURE_NAME | ❌ | ❌ | ❌ | Not Started | \`/implement $FEATURE_NAME\` |" >> "$STATUS_FILE"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Feature '$FEATURE_NAME' created!                         ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  Files created:"
echo -e "${GREEN}║${NC}    $FEATURE_DIR/"
echo -e "${GREEN}║${NC}    ├── SPEC.md"
echo -e "${GREEN}║${NC}    ├── API.md"
echo -e "${GREEN}║${NC}    └── STATUS.md"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  Next steps:"
echo -e "${GREEN}║${NC}    1. Edit SPEC.md with feature details"
echo -e "${GREEN}║${NC}    2. Run /design $FEATURE_NAME to refine"
echo -e "${GREEN}║${NC}    3. Run /implement $FEATURE_NAME to build"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
