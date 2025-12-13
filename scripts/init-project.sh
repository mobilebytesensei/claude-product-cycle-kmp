#!/bin/bash

# Claude Product Cycle - Project Initializer
# Usage: ./init-project.sh --name "My App" --package "com.example.myapp" --output "../my-app"

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
PROJECT_NAME=""
PACKAGE=""
OUTPUT_DIR=""
BACKEND_TYPE="supabase"
INTERACTIVE=false

# Layer configuration
LAYER_SERVER=true
LAYER_CLIENT=true
LAYER_FEATURE=true
DEFAULT_LAYERS="all"
GENERATE_MOCKS=true
GENERATE_TESTS=true
AUTO_BUILD=true
AUTO_LINT=true

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
        --interactive|-i)
            INTERACTIVE=true
            shift
            ;;
        # Layer options
        --no-server)
            LAYER_SERVER=false
            shift
            ;;
        --no-client)
            LAYER_CLIENT=false
            shift
            ;;
        --no-feature)
            LAYER_FEATURE=false
            shift
            ;;
        --default-layers)
            DEFAULT_LAYERS="$2"
            shift 2
            ;;
        --no-mocks)
            GENERATE_MOCKS=false
            shift
            ;;
        --no-tests)
            GENERATE_TESTS=false
            shift
            ;;
        --no-build)
            AUTO_BUILD=false
            shift
            ;;
        --no-lint)
            AUTO_LINT=false
            shift
            ;;
        # Presets
        --preset)
            case $2 in
                api-first)
                    LAYER_SERVER=true
                    LAYER_CLIENT=false
                    LAYER_FEATURE=false
                    DEFAULT_LAYERS="server"
                    ;;
                backend-data)
                    LAYER_SERVER=true
                    LAYER_CLIENT=true
                    LAYER_FEATURE=false
                    DEFAULT_LAYERS="server,client"
                    ;;
                frontend-only)
                    LAYER_SERVER=false
                    LAYER_CLIENT=true
                    LAYER_FEATURE=true
                    DEFAULT_LAYERS="client,feature"
                    ;;
                ui-prototype)
                    LAYER_SERVER=false
                    LAYER_CLIENT=false
                    LAYER_FEATURE=true
                    DEFAULT_LAYERS="feature"
                    GENERATE_MOCKS=true
                    ;;
                *)
                    echo -e "${RED}Unknown preset: $2${NC}"
                    echo "Available presets: api-first, backend-data, frontend-only, ui-prototype"
                    exit 1
                    ;;
            esac
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --name \"Project Name\" --package \"com.example.app\" --output \"../output-dir\""
            echo ""
            echo "Required Options:"
            echo "  --name       Project name (e.g., \"My App\")"
            echo "  --package    Package name (e.g., \"com.example.myapp\")"
            echo "  --output     Output directory"
            echo ""
            echo "Backend Options:"
            echo "  --backend    Backend type: supabase (default), firebase, custom"
            echo ""
            echo "Layer Configuration:"
            echo "  --no-server          Disable server layer"
            echo "  --no-client          Disable client layer"
            echo "  --no-feature         Disable feature layer"
            echo "  --default-layers     Default layers: all | prompt | server,client | etc."
            echo ""
            echo "Automation Options:"
            echo "  --no-mocks           Don't auto-generate mocks"
            echo "  --no-tests           Don't auto-generate tests"
            echo "  --no-build           Don't auto-run builds"
            echo "  --no-lint            Don't auto-run lint"
            echo ""
            echo "Presets (shorthand for common configs):"
            echo "  --preset api-first       Server only (API-first development)"
            echo "  --preset backend-data    Server + Client (no UI)"
            echo "  --preset frontend-only   Client + Feature (external API)"
            echo "  --preset ui-prototype    Feature only (with mocks)"
            echo ""
            echo "Other:"
            echo "  -i, --interactive    Interactive mode (prompts for options)"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Interactive mode
if [[ "$INTERACTIVE" == true ]]; then
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Claude Product Cycle - Interactive Setup                     ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Project basics
    if [[ -z "$PROJECT_NAME" ]]; then
        read -p "Project name: " PROJECT_NAME
    fi
    if [[ -z "$PACKAGE" ]]; then
        read -p "Package name (e.g., com.example.app): " PACKAGE
    fi
    if [[ -z "$OUTPUT_DIR" ]]; then
        read -p "Output directory: " OUTPUT_DIR
    fi

    # Backend type
    echo ""
    echo -e "${CYAN}Backend type:${NC}"
    echo "  1) supabase (PostgreSQL + RLS)"
    echo "  2) firebase (Firestore + Functions)"
    echo "  3) custom (REST/GraphQL API)"
    read -p "Select [1-3] (default: 1): " backend_choice
    case $backend_choice in
        2) BACKEND_TYPE="firebase" ;;
        3) BACKEND_TYPE="custom" ;;
        *) BACKEND_TYPE="supabase" ;;
    esac

    # Layer configuration
    echo ""
    echo -e "${CYAN}Layer configuration:${NC}"
    echo "  Which layers will your project use?"
    echo ""

    read -p "  Enable SERVER layer (migrations, RPCs)? [Y/n]: " server_choice
    [[ "$server_choice" =~ ^[Nn] ]] && LAYER_SERVER=false

    read -p "  Enable CLIENT layer (DTO, Service, Repo, UseCase)? [Y/n]: " client_choice
    [[ "$client_choice" =~ ^[Nn] ]] && LAYER_CLIENT=false

    read -p "  Enable FEATURE layer (ViewModel, Screen, UI)? [Y/n]: " feature_choice
    [[ "$feature_choice" =~ ^[Nn] ]] && LAYER_FEATURE=false

    # Default behavior
    echo ""
    echo -e "${CYAN}Default /implement behavior:${NC}"
    echo "  1) all      - Run all enabled layers"
    echo "  2) prompt   - Always ask which layers"
    echo "  3) Custom   - Specify layers (e.g., server,client)"
    read -p "Select [1-3] (default: 1): " default_choice
    case $default_choice in
        2) DEFAULT_LAYERS="prompt" ;;
        3)
            read -p "  Enter default layers (comma-separated): " DEFAULT_LAYERS
            ;;
        *) DEFAULT_LAYERS="all" ;;
    esac

    # Automation options
    echo ""
    echo -e "${CYAN}Automation options:${NC}"

    read -p "  Auto-generate mocks when skipping client? [Y/n]: " mock_choice
    [[ "$mock_choice" =~ ^[Nn] ]] && GENERATE_MOCKS=false

    read -p "  Auto-generate tests for each layer? [Y/n]: " test_choice
    [[ "$test_choice" =~ ^[Nn] ]] && GENERATE_TESTS=false

    read -p "  Auto-run builds after each layer? [Y/n]: " build_choice
    [[ "$build_choice" =~ ^[Nn] ]] && AUTO_BUILD=false

    read -p "  Auto-run lint/format after code generation? [Y/n]: " lint_choice
    [[ "$lint_choice" =~ ^[Nn] ]] && AUTO_LINT=false

    echo ""
fi

# Validate required args
if [[ -z "$PROJECT_NAME" || -z "$PACKAGE" || -z "$OUTPUT_DIR" ]]; then
    echo -e "${RED}Error: --name, --package, and --output are required${NC}"
    echo "Run with --help for usage or -i for interactive mode"
    exit 1
fi

# Get current date
DATE=$(date +%Y-%m-%d)

# Convert project name to lowercase for file naming
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Build enabled layers string for display
ENABLED_LAYERS=""
[[ "$LAYER_SERVER" == true ]] && ENABLED_LAYERS+="server "
[[ "$LAYER_CLIENT" == true ]] && ENABLED_LAYERS+="client "
[[ "$LAYER_FEATURE" == true ]] && ENABLED_LAYERS+="feature "

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Product Cycle - Project Initializer                   ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC}  Project:  ${GREEN}$PROJECT_NAME${NC}"
echo -e "${BLUE}║${NC}  Package:  ${GREEN}$PACKAGE${NC}"
echo -e "${BLUE}║${NC}  Output:   ${GREEN}$OUTPUT_DIR${NC}"
echo -e "${BLUE}║${NC}  Backend:  ${GREEN}$BACKEND_TYPE${NC}"
echo -e "${BLUE}║${NC}  Layers:   ${GREEN}$ENABLED_LAYERS${NC}"
echo -e "${BLUE}║${NC}  Default:  ${GREEN}$DEFAULT_LAYERS${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create output directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"

mkdir -p "$OUTPUT_DIR/.claude/commands"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/_shared"
mkdir -p "$OUTPUT_DIR/claude-product-cycle/design-spec-layer/features"

# Create server layer directories if enabled
if [[ "$LAYER_SERVER" == true ]]; then
    case $BACKEND_TYPE in
        supabase)
            mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/supabase/migrations"
            ;;
        firebase)
            mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/firebase/functions"
            ;;
        custom)
            mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/custom/migrations"
            ;;
    esac
    mkdir -p "$OUTPUT_DIR/claude-product-cycle/server-layer/data-pipeline"
fi

# Create client/feature layer directories if enabled
[[ "$LAYER_CLIENT" == true ]] && mkdir -p "$OUTPUT_DIR/claude-product-cycle/client-layer"
[[ "$LAYER_FEATURE" == true ]] && mkdir -p "$OUTPUT_DIR/claude-product-cycle/feature-layer"

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

# Create config file with layer configuration
echo -e "${YELLOW}Creating config file...${NC}"
cat > "$OUTPUT_DIR/.claude-product-cycle.yaml" << EOF
# Claude Product Cycle Configuration
# Project: $PROJECT_NAME
# Generated: $DATE

template:
  version: "1.1.0"
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

# Implementation Layer Configuration
implementation:
  layers:
    server: $LAYER_SERVER
    client: $LAYER_CLIENT
    feature: $LAYER_FEATURE
  default_layers: "$DEFAULT_LAYERS"
  generate_mocks: $GENERATE_MOCKS
  generate_tests: $GENERATE_TESTS
  auto_build: $AUTO_BUILD
  auto_lint: $AUTO_LINT

features: []
EOF

# Create SCHEMA_REGISTRY.md (only if server layer enabled)
if [[ "$LAYER_SERVER" == true ]]; then
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
│  └─→ ${BACKEND_TYPE^} Client SDK                                    │
│       └─→ RPCs / Functions                                          │
│            └─→ Database with security rules                         │
└─────────────────────────────────────────────────────────────────────┘
\`\`\`

---

## Migrations

Location: \`claude-product-cycle/server-layer/$BACKEND_TYPE/migrations/\`

| Migration | Purpose | Status |
|-----------|---------|--------|
| - | - | - |

---

## Deployment

\`\`\`bash
cd claude-product-cycle/server-layer/$BACKEND_TYPE
# Add deployment commands here
\`\`\`

---

## Changelog

| Date | Change |
|------|--------|
| $DATE | Initial plan |
EOF
fi

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
echo -e "${GREEN}║${NC}  Layer configuration:"
echo -e "${GREEN}║${NC}    Server:  $([ "$LAYER_SERVER" == true ] && echo "✅ Enabled" || echo "❌ Disabled")"
echo -e "${GREEN}║${NC}    Client:  $([ "$LAYER_CLIENT" == true ] && echo "✅ Enabled" || echo "❌ Disabled")"
echo -e "${GREEN}║${NC}    Feature: $([ "$LAYER_FEATURE" == true ] && echo "✅ Enabled" || echo "❌ Disabled")"
echo -e "${GREEN}║${NC}    Default: $DEFAULT_LAYERS"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC}  Next steps:"
echo -e "${GREEN}║${NC}    1. cd $OUTPUT_DIR"
echo -e "${GREEN}║${NC}    2. Start Claude Code"
echo -e "${GREEN}║${NC}    3. Run /projectstatus"
echo -e "${GREEN}║${NC}    4. Run /design [Feature] to create first feature"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
