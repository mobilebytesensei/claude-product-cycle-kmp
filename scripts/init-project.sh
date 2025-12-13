#!/bin/bash

# Claude Product Cycle - Project Initializer
# Usage: ./init-project.sh --name "My App" --package "com.example.myapp" --output "../my-app"

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
PROJECT_NAME=""
PACKAGE=""
OUTPUT_DIR=""
BACKEND_TYPE="supabase"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --package)
            PACKAGE="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --backend)
            BACKEND_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --name \"Project Name\" --package \"com.example.app\" --output \"../output-dir\""
            echo ""
            echo "Options:"
            echo "  --name      Project name (e.g., \"My App\")"
            echo "  --package   Package name (e.g., \"com.example.myapp\")"
            echo "  --output    Output directory"
            echo "  --backend   Backend type: supabase (default), firebase, custom"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Validate required args
if [[ -z "$PROJECT_NAME" || -z "$PACKAGE" || -z "$OUTPUT_DIR" ]]; then
    echo -e "${RED}Error: --name, --package, and --output are required${NC}"
    echo "Run with --help for usage"
    exit 1
fi

# Get current date
DATE=$(date +%Y-%m-%d)

# Convert project name to lowercase for file naming
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Product Cycle - Project Initializer                   ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC}  Project:  ${GREEN}$PROJECT_NAME${NC}"
echo -e "${BLUE}║${NC}  Package:  ${GREEN}$PACKAGE${NC}"
echo -e "${BLUE}║${NC}  Output:   ${GREEN}$OUTPUT_DIR${NC}"
echo -e "${BLUE}║${NC}  Backend:  ${GREEN}$BACKEND_TYPE${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create output directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"

mkdir -p "$OUTPUT_DIR/.claude/commands"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/_shared"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/features"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/supabase/migrations"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/data-pipeline"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/client-layer"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/feature-layer"

# Copy commands
echo -e "${YELLOW}Copying slash commands...${NC}"
cp -r "$TEMPLATE_DIR/commands/"* "$OUTPUT_DIR/.claude/commands/"

# Copy shared patterns (no templating needed)
echo -e "${YELLOW}Copying shared patterns...${NC}"
cp "$TEMPLATE_DIR/templates/design-spec-layer/_shared/PATTERNS.md" "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/_shared/"
cp "$TEMPLATE_DIR/templates/design-spec-layer/_shared/CROSS_UPDATE_RULES.md" "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/_shared/"

# Process STATUS.md template
echo -e "${YELLOW}Creating STATUS.md...${NC}"
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{DATE}}/$DATE/g" \
    "$TEMPLATE_DIR/templates/design-spec-layer/STATUS.md.template" \
    > "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/STATUS.md"

# Create config file
echo -e "${YELLOW}Creating config file...${NC}"
cat > "$OUTPUT_DIR/.claude-product-cycle.yaml" << EOF
# Claude Product Cycle Configuration
# Generated: $DATE

template:
  version: "1.0.0"
  source: "github.com/mobilebytesensei/claude-product-cycle-kmp"

project:
  name: "$PROJECT_NAME"
  package: "$PACKAGE"
  type: "kmp"

architecture:
  pattern: "clean-mvi"
  layers:
    - network
    - data
    - domain
    - feature

backend:
  type: "$BACKEND_TYPE"
  has_data_pipeline: false

features: []
EOF

# Create SCHEMA_REGISTRY.md
echo -e "${YELLOW}Creating SCHEMA_REGISTRY.md...${NC}"
cat > "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/SCHEMA_REGISTRY.md" << EOF
# $PROJECT_NAME - Schema Registry

> Central registry for all database tables and RPC functions.
> **Last Updated**: $DATE

---

## Tables

| Table | Purpose | Population | Sync Script |
|-------|---------|------------|-------------|
| users | User profiles | Auto (trigger) | N/A |

---

## RPCs

| RPC | Purpose | Feature | Parameters |
|-----|---------|---------|------------|
| - | - | - | - |

---

## Triggers

| Trigger | Table | Purpose |
|---------|-------|---------|
| on_auth_user_created | auth.users | Auto-create user profile |

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Initial registry |
EOF

# Create SERVER_PLAN.md
echo -e "${YELLOW}Creating SERVER_PLAN.md...${NC}"
cat > "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/SERVER_PLAN.md" << EOF
# $PROJECT_NAME - Server Plan

> Backend implementation details.
> **Last Updated**: $DATE

---

## Architecture

\`\`\`
┌─────────────────────────────────────────────────────────────────────┐
│  KMP Client App                                                      │
│  └─→ Supabase Client SDK                                            │
│       └─→ RPCs (PostgreSQL functions)                                │
│            └─→ Tables with RLS                                       │
└─────────────────────────────────────────────────────────────────────┘
\`\`\`

---

## Migrations

Location: \`claude-product-cycle/server-layer/supabase/migrations/\`

| Migration | Purpose | Status |
|-----------|---------|--------|
| - | - | - |

---

## Deployment

\`\`\`bash
cd claude-product-cycle/server-layer/supabase
python3 master.py deploy
\`\`\`

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Initial plan |
EOF

# Copy sync script
echo -e "${YELLOW}Creating sync script...${NC}"
cp "$TEMPLATE_DIR/scripts/sync-template.sh" "$OUTPUT_DIR/claude-product-cycle/"
chmod +x "$OUTPUT_DIR/claude-product-cycle/sync-template.sh"

# Done
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Project initialized successfully!                         ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  Structure created:"
echo -e "${GREEN}║${NC}    $OUTPUT_DIR/"
echo -e "${GREEN}║${NC}    ├── .claude/commands/          # Slash commands"
echo -e "${GREEN}║${NC}    ├── .claude-product-cycle.yaml # Config"
echo -e "${GREEN}║${NC}    └── claude-product-cycle/      # Plans & specs"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  Next steps:"
echo -e "${GREEN}║${NC}    1. cd $OUTPUT_DIR"
echo -e "${GREEN}║${NC}    2. Start Claude Code"
echo -e "${GREEN}║${NC}    3. Run /projectstatus"
echo -e "${GREEN}║${NC}    4. Run /design [Feature] to create first feature"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
