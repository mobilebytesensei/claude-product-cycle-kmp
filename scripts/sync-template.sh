#!/bin/bash

# Claude Product Cycle - Template Sync Script
# Syncs updates from template repository to project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TEMPLATE_REPO="https://github.com/mobilebytesensei/claude-product-cycle-kmp.git"
TEMP_DIR="/tmp/claude-product-cycle-template"

# Parse arguments
ACTION="check"
while [[ $# -gt 0 ]]; do
    case $1 in
        --check)
            ACTION="check"
            shift
            ;;
        --sync)
            ACTION="sync"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--check|--sync]"
            echo ""
            echo "Options:"
            echo "  --check  Check for updates (default)"
            echo "  --sync   Sync commands and shared files"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Product Cycle - Template Sync                         ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Find project root (where .claude-product-cycle.yaml is)
PROJECT_ROOT="$(pwd)"
while [[ ! -f "$PROJECT_ROOT/.claude-product-cycle.yaml" && "$PROJECT_ROOT" != "/" ]]; do
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

if [[ ! -f "$PROJECT_ROOT/.claude-product-cycle.yaml" ]]; then
    echo -e "${RED}Error: .claude-product-cycle.yaml not found${NC}"
    echo "Run this script from your project root"
    exit 1
fi

echo -e "${YELLOW}Project root: $PROJECT_ROOT${NC}"

# Get current version
CURRENT_VERSION=$(grep 'version:' "$PROJECT_ROOT/.claude-product-cycle.yaml" | head -1 | sed 's/.*version: *"\([^"]*\)".*/\1/')
echo -e "${YELLOW}Current version: $CURRENT_VERSION${NC}"

# Clone template to temp
echo -e "${YELLOW}Fetching latest template...${NC}"
rm -rf "$TEMP_DIR"
git clone --depth 1 "$TEMPLATE_REPO" "$TEMP_DIR" 2>/dev/null

# Get template version
TEMPLATE_VERSION=$(cat "$TEMP_DIR/VERSION" | tr -d '[:space:]')
echo -e "${YELLOW}Template version: $TEMPLATE_VERSION${NC}"

if [[ "$ACTION" == "check" ]]; then
    echo ""
    if [[ "$CURRENT_VERSION" == "$TEMPLATE_VERSION" ]]; then
        echo -e "${GREEN}✅ You are on the latest version ($CURRENT_VERSION)${NC}"
    else
        echo -e "${YELLOW}⚠️  Update available: $CURRENT_VERSION → $TEMPLATE_VERSION${NC}"
        echo ""
        echo "Run with --sync to update:"
        echo "  ./sync-template.sh --sync"
    fi
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Sync mode
echo ""
echo -e "${YELLOW}Syncing files...${NC}"

# Files to sync (commands and shared patterns)
SYNC_FILES=(
    "commands/implement.md:.claude/commands/implement.md"
    "commands/design.md:.claude/commands/design.md"
    "commands/server.md:.claude/commands/server.md"
    "commands/client.md:.claude/commands/client.md"
    "commands/feature.md:.claude/commands/feature.md"
    "commands/verify.md:.claude/commands/verify.md"
    "commands/projectstatus.md:.claude/commands/projectstatus.md"
    "templates/design-spec-layer/_shared/PATTERNS.md:claude-product-cycle/design-spec-layer/_shared/PATTERNS.md"
    "templates/design-spec-layer/_shared/CROSS_UPDATE_RULES.md:claude-product-cycle/design-spec-layer/_shared/CROSS_UPDATE_RULES.md"
)

for mapping in "${SYNC_FILES[@]}"; do
    SRC="${mapping%%:*}"
    DST="${mapping##*:}"

    if [[ -f "$TEMP_DIR/$SRC" ]]; then
        mkdir -p "$(dirname "$PROJECT_ROOT/$DST")"
        cp "$TEMP_DIR/$SRC" "$PROJECT_ROOT/$DST"
        echo -e "  ${GREEN}✓${NC} $DST"
    fi
done

# Update version in config
sed -i.bak "s/version: \"$CURRENT_VERSION\"/version: \"$TEMPLATE_VERSION\"/" "$PROJECT_ROOT/.claude-product-cycle.yaml"
rm -f "$PROJECT_ROOT/.claude-product-cycle.yaml.bak"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Sync complete! Updated to v$TEMPLATE_VERSION                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Changes synced:"
echo "  - Slash commands updated"
echo "  - Shared patterns updated"
echo "  - Config version updated"
echo ""
echo "Note: Your project-specific files (SPEC.md, STATUS.md, etc.) were preserved."
