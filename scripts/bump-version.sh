#!/bin/bash

# Claude Product Cycle - Version Bump Script
# Automates semantic versioning for template releases

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$TEMPLATE_ROOT/VERSION"
CHANGELOG_FILE="$TEMPLATE_ROOT/CHANGELOG.md"

# Get current version
CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

show_help() {
    echo "Usage: $0 <bump_type> [message]"
    echo ""
    echo "Bump types:"
    echo "  major    Breaking changes (1.0.0 → 2.0.0)"
    echo "  minor    New features (1.0.0 → 1.1.0)"
    echo "  patch    Bug fixes (1.0.0 → 1.0.1)"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help"
    echo "  --dry-run     Show what would happen without making changes"
    echo ""
    echo "Examples:"
    echo "  $0 patch \"Fixed sync script path handling\""
    echo "  $0 minor \"Added new /optimize command\""
    echo "  $0 major \"Restructured command interface\""
    echo ""
    echo "Current version: $CURRENT_VERSION"
}

DRY_RUN=false
BUMP_TYPE=""
MESSAGE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        major|minor|patch)
            BUMP_TYPE="$1"
            shift
            ;;
        *)
            if [[ -z "$MESSAGE" ]]; then
                MESSAGE="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$BUMP_TYPE" ]]; then
    echo -e "${RED}Error: Bump type required (major, minor, patch)${NC}"
    echo ""
    show_help
    exit 1
fi

# Calculate new version
case "$BUMP_TYPE" in
    major)
        NEW_MAJOR=$((MAJOR + 1))
        NEW_VERSION="$NEW_MAJOR.0.0"
        CHANGE_TYPE="### Changed"
        ;;
    minor)
        NEW_MINOR=$((MINOR + 1))
        NEW_VERSION="$MAJOR.$NEW_MINOR.0"
        CHANGE_TYPE="### Added"
        ;;
    patch)
        NEW_PATCH=$((PATCH + 1))
        NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"
        CHANGE_TYPE="### Fixed"
        ;;
esac

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Product Cycle - Version Bump                          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Current version:${NC} $CURRENT_VERSION"
echo -e "${GREEN}New version:${NC}     $NEW_VERSION"
echo -e "${CYAN}Bump type:${NC}       $BUMP_TYPE"
echo ""

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}DRY RUN - No changes will be made${NC}"
    echo ""
fi

# Generate changelog entry
TODAY=$(date +%Y-%m-%d)
CHANGELOG_ENTRY="## [$NEW_VERSION] - $TODAY

$CHANGE_TYPE
- ${MESSAGE:-"Update description here"}"

echo -e "${CYAN}Changelog entry:${NC}"
echo "─────────────────────────────────────"
echo "$CHANGELOG_ENTRY"
echo "─────────────────────────────────────"
echo ""

if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}Would update:${NC}"
    echo "  - VERSION file: $CURRENT_VERSION → $NEW_VERSION"
    echo "  - CHANGELOG.md: Add new entry"
    exit 0
fi

# Confirm
read -p "Proceed with version bump? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

# Update VERSION file
echo "$NEW_VERSION" > "$VERSION_FILE"
echo -e "${GREEN}✓${NC} Updated VERSION to $NEW_VERSION"

# Update CHANGELOG.md
if [[ -f "$CHANGELOG_FILE" ]]; then
    # Insert new entry after the header
    # Find the line with first ## and insert before it
    if grep -q "^## \[" "$CHANGELOG_FILE"; then
        # Has existing entries, insert before first one
        sed -i.bak "/^## \[/i\\
\\
$CHANGELOG_ENTRY\\
" "$CHANGELOG_FILE"
        rm -f "$CHANGELOG_FILE.bak"
    else
        # No entries yet, append to file
        echo "" >> "$CHANGELOG_FILE"
        echo "$CHANGELOG_ENTRY" >> "$CHANGELOG_FILE"
    fi
else
    # Create new changelog
    cat > "$CHANGELOG_FILE" << EOF
# Changelog

All notable changes to Claude Product Cycle template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

$CHANGELOG_ENTRY
EOF
fi
echo -e "${GREEN}✓${NC} Updated CHANGELOG.md"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Version bumped to $NEW_VERSION                               ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Review CHANGELOG.md and edit if needed"
echo "  2. Commit changes:"
echo "     git add VERSION CHANGELOG.md"
echo "     git commit -m \"chore: bump version to $NEW_VERSION\""
echo "  3. Create release tag:"
echo "     git tag v$NEW_VERSION"
echo "  4. Push:"
echo "     git push && git push --tags"
