#!/bin/bash

# Claude Product Cycle - Template Sync Script
# Syncs updates from template repository to project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

TEMPLATE_REPO="https://github.com/mobilebytesensei/claude-product-cycle-kmp.git"
TEMP_DIR="/tmp/claude-product-cycle-template"

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

# Parse arguments
ACTION="check"
VERBOSE=false
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
        --diff)
            ACTION="diff"
            shift
            ;;
        --changelog)
            ACTION="changelog"
            shift
            ;;
        --list)
            ACTION="list"
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --check      Check for updates (default)"
            echo "  --sync       Sync commands and shared files"
            echo "  --diff       Show what will change before syncing"
            echo "  --changelog  Show changelog between versions"
            echo "  --list       List all syncable files"
            echo "  -v,--verbose Show detailed output"
            echo "  -h,--help    Show this help"
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

# List syncable files
if [[ "$ACTION" == "list" ]]; then
    echo -e "${CYAN}Syncable files:${NC}"
    echo ""
    for mapping in "${SYNC_FILES[@]}"; do
        SRC="${mapping%%:*}"
        DST="${mapping##*:}"
        echo -e "  ${GREEN}Template:${NC} $SRC"
        echo -e "  ${YELLOW}Project:${NC}  $DST"
        echo ""
    done
    exit 0
fi

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

echo -e "${GRAY}Project root: $PROJECT_ROOT${NC}"

# Get current version
CURRENT_VERSION=$(grep 'version:' "$PROJECT_ROOT/.claude-product-cycle.yaml" | head -1 | sed 's/.*version: *"\([^"]*\)".*/\1/')
echo -e "${GRAY}Current version: $CURRENT_VERSION${NC}"

# Clone template to temp
echo -e "${GRAY}Fetching latest template...${NC}"
rm -rf "$TEMP_DIR"
git clone --depth 1 "$TEMPLATE_REPO" "$TEMP_DIR" 2>/dev/null

# Get template version
TEMPLATE_VERSION=$(cat "$TEMP_DIR/VERSION" | tr -d '[:space:]')
echo -e "${GRAY}Template version: $TEMPLATE_VERSION${NC}"
echo ""

# Parse versions for comparison
parse_version() {
    echo "$1" | awk -F. '{print $1, $2, $3}'
}

compare_versions() {
    local cur_major cur_minor cur_patch
    local tpl_major tpl_minor tpl_patch

    read cur_major cur_minor cur_patch <<< $(parse_version "$1")
    read tpl_major tpl_minor tpl_patch <<< $(parse_version "$2")

    if [[ "$tpl_major" -gt "$cur_major" ]]; then
        echo "MAJOR"
    elif [[ "$tpl_minor" -gt "$cur_minor" ]]; then
        echo "MINOR"
    elif [[ "$tpl_patch" -gt "$cur_patch" ]]; then
        echo "PATCH"
    else
        echo "NONE"
    fi
}

VERSION_CHANGE=$(compare_versions "$CURRENT_VERSION" "$TEMPLATE_VERSION")

# Check mode
if [[ "$ACTION" == "check" ]]; then
    if [[ "$CURRENT_VERSION" == "$TEMPLATE_VERSION" ]]; then
        echo -e "${GREEN}✅ You are on the latest version ($CURRENT_VERSION)${NC}"
    else
        case "$VERSION_CHANGE" in
            MAJOR)
                echo -e "${RED}🚨 MAJOR update available: $CURRENT_VERSION → $TEMPLATE_VERSION${NC}"
                echo -e "${RED}   This may contain breaking changes!${NC}"
                echo ""
                echo "Before syncing:"
                echo "  1. Read CHANGELOG: $0 --changelog"
                echo "  2. Preview changes: $0 --diff"
                echo "  3. Sync: $0 --sync"
                ;;
            MINOR)
                echo -e "${YELLOW}✨ MINOR update available: $CURRENT_VERSION → $TEMPLATE_VERSION${NC}"
                echo -e "${YELLOW}   New features added (backward compatible)${NC}"
                echo ""
                echo "Commands:"
                echo "  $0 --diff      # Preview changes"
                echo "  $0 --sync      # Apply update"
                ;;
            PATCH)
                echo -e "${GREEN}🔧 PATCH update available: $CURRENT_VERSION → $TEMPLATE_VERSION${NC}"
                echo -e "${GREEN}   Bug fixes and improvements${NC}"
                echo ""
                echo "Safe to sync: $0 --sync"
                ;;
        esac
    fi
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Changelog mode
if [[ "$ACTION" == "changelog" ]]; then
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  CHANGELOG                                                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    if [[ -f "$TEMP_DIR/CHANGELOG.md" ]]; then
        cat "$TEMP_DIR/CHANGELOG.md"
    else
        echo "No changelog found"
    fi
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Diff mode
if [[ "$ACTION" == "diff" ]]; then
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  CHANGES PREVIEW                                              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    CHANGED_COUNT=0
    NEW_COUNT=0
    UNCHANGED_COUNT=0

    for mapping in "${SYNC_FILES[@]}"; do
        SRC="${mapping%%:*}"
        DST="${mapping##*:}"

        if [[ -f "$TEMP_DIR/$SRC" ]]; then
            if [[ -f "$PROJECT_ROOT/$DST" ]]; then
                # File exists, check for differences
                if ! diff -q "$PROJECT_ROOT/$DST" "$TEMP_DIR/$SRC" > /dev/null 2>&1; then
                    echo -e "${YELLOW}MODIFIED:${NC} $DST"
                    CHANGED_COUNT=$((CHANGED_COUNT + 1))

                    if [[ "$VERBOSE" == true ]]; then
                        echo -e "${GRAY}─────────────────────────────────────${NC}"
                        diff --color=always "$PROJECT_ROOT/$DST" "$TEMP_DIR/$SRC" | head -50 || true
                        echo -e "${GRAY}─────────────────────────────────────${NC}"
                        echo ""
                    fi
                else
                    UNCHANGED_COUNT=$((UNCHANGED_COUNT + 1))
                    if [[ "$VERBOSE" == true ]]; then
                        echo -e "${GREEN}UNCHANGED:${NC} $DST"
                    fi
                fi
            else
                echo -e "${GREEN}NEW:${NC} $DST"
                NEW_COUNT=$((NEW_COUNT + 1))
            fi
        fi
    done

    echo ""
    echo -e "${CYAN}Summary:${NC}"
    echo -e "  ${YELLOW}Modified:${NC}  $CHANGED_COUNT files"
    echo -e "  ${GREEN}New:${NC}       $NEW_COUNT files"
    echo -e "  ${GRAY}Unchanged:${NC} $UNCHANGED_COUNT files"

    if [[ $CHANGED_COUNT -gt 0 || $NEW_COUNT -gt 0 ]]; then
        echo ""
        echo "Run '$0 --sync' to apply these changes"
    fi

    rm -rf "$TEMP_DIR"
    exit 0
fi

# Sync mode
echo -e "${YELLOW}Syncing files...${NC}"
echo ""

SYNCED_COUNT=0
SKIPPED_COUNT=0

for mapping in "${SYNC_FILES[@]}"; do
    SRC="${mapping%%:*}"
    DST="${mapping##*:}"

    if [[ -f "$TEMP_DIR/$SRC" ]]; then
        mkdir -p "$(dirname "$PROJECT_ROOT/$DST")"

        # Check if file changed
        if [[ -f "$PROJECT_ROOT/$DST" ]]; then
            if diff -q "$PROJECT_ROOT/$DST" "$TEMP_DIR/$SRC" > /dev/null 2>&1; then
                SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
                if [[ "$VERBOSE" == true ]]; then
                    echo -e "  ${GRAY}⊘${NC} $DST (unchanged)"
                fi
                continue
            fi
        fi

        cp "$TEMP_DIR/$SRC" "$PROJECT_ROOT/$DST"
        echo -e "  ${GREEN}✓${NC} $DST"
        SYNCED_COUNT=$((SYNCED_COUNT + 1))
    fi
done

# Update version in config
if [[ "$CURRENT_VERSION" != "$TEMPLATE_VERSION" ]]; then
    sed -i.bak "s/version: \"$CURRENT_VERSION\"/version: \"$TEMPLATE_VERSION\"/" "$PROJECT_ROOT/.claude-product-cycle.yaml"
    rm -f "$PROJECT_ROOT/.claude-product-cycle.yaml.bak"
    echo -e "  ${GREEN}✓${NC} .claude-product-cycle.yaml (version updated)"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Sync complete! Updated to v$TEMPLATE_VERSION                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Summary:"
echo -e "  ${GREEN}Synced:${NC}    $SYNCED_COUNT files"
echo -e "  ${GRAY}Unchanged:${NC} $SKIPPED_COUNT files"
echo ""
echo -e "${GRAY}Note: Your project-specific files (SPEC.md, STATUS.md, etc.) were preserved.${NC}"
