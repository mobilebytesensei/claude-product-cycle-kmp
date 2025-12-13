# Contributing to Claude Product Cycle

This guide explains how to evolve the template and maintain sync across projects.

---

## Evolution Strategy

### Core Principles

```
┌─────────────────────────────────────────────────────────────────────────┐
│  TEMPLATE EVOLUTION PRINCIPLES                                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. TEMPLATE IS GENERIC       - No project-specific content             │
│  2. BACKWARD COMPATIBLE       - Don't break existing projects           │
│  3. VERSIONED CHANGES         - Bump VERSION for every change           │
│  4. DOCUMENTED                - Update CHANGELOG.md                      │
│  5. TESTED                    - Validate against sample project          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Change Classification

### Syncable Files (Auto-Sync)

These files are synced to projects when running `sync-template.sh`:

| File | Location in Template | Location in Project |
|------|---------------------|---------------------|
| `implement.md` | `commands/` | `.claude/commands/` |
| `design.md` | `commands/` | `.claude/commands/` |
| `server.md` | `commands/` | `.claude/commands/` |
| `client.md` | `commands/` | `.claude/commands/` |
| `feature.md` | `commands/` | `.claude/commands/` |
| `verify.md` | `commands/` | `.claude/commands/` |
| `projectstatus.md` | `commands/` | `.claude/commands/` |
| `PATTERNS.md` | `templates/design-spec-layer/_shared/` | `claude-product-cycle/design-spec-layer/_shared/` |
| `CROSS_UPDATE_RULES.md` | `templates/design-spec-layer/_shared/` | `claude-product-cycle/design-spec-layer/_shared/` |

### Non-Syncable Files (Project-Specific)

These files are created once during init but NOT synced:

| File | Reason |
|------|--------|
| `SPEC.md` | Contains project-specific feature specs |
| `API.md` | Contains project-specific API definitions |
| `STATUS.md` (feature) | Contains project-specific progress |
| `STATUS.md` (global) | Contains project-specific feature list |
| `CLAUDE.md` | Contains project-specific context |
| `.claude-product-cycle.yaml` | Contains project config |

---

## Semantic Versioning

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes (require manual migration)
MINOR: New features (backward compatible)
PATCH: Bug fixes, improvements (backward compatible)
```

### Version Bump Triggers

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| New command added | MINOR | Add `/optimize` command |
| Command behavior change (breaking) | MAJOR | Change `/implement` phases |
| Command improvement (compatible) | PATCH | Better error messages |
| New template file | MINOR | Add `TESTING.md.template` |
| Pattern update | PATCH | Update PATTERNS.md |
| Bug fix | PATCH | Fix sync script issue |
| Documentation only | None | Update README.md |

---

## Making Changes

### 1. Create Feature Branch

```bash
git checkout -b feature/description
```

### 2. Make Changes

Edit files in:
- `commands/` - Slash commands
- `templates/` - Project scaffolding
- `scripts/` - Automation scripts

### 3. Update CHANGELOG.md

```markdown
## [1.1.0] - 2024-12-14

### Added
- New `/optimize` command for performance tuning

### Changed
- `/implement` now shows progress bar

### Fixed
- Sync script handling spaces in paths
```

### 4. Bump VERSION

```bash
echo "1.1.0" > VERSION
```

### 5. Update Sync Mapping (if needed)

If adding new syncable files, update `scripts/sync-template.sh`:

```bash
SYNC_FILES=(
    # ... existing mappings
    "commands/optimize.md:.claude/commands/optimize.md"  # NEW
)
```

### 6. Test Changes

```bash
# Test with a sample project
./scripts/init-project.sh \
  --name "Test App" \
  --package "com.test.app" \
  --output "/tmp/test-app"

# Verify commands work
cd /tmp/test-app
# Use Claude Code with the commands
```

### 7. Submit PR

```bash
git add .
git commit -m "feat: Add optimize command"
git push origin feature/description
gh pr create --title "Add optimize command" --body "..."
```

---

## Sync Strategy for Projects

### When to Sync

| Scenario | Action |
|----------|--------|
| New command released | Run `./sync-template.sh --sync` |
| Pattern updated | Run `./sync-template.sh --sync` |
| Bug fix released | Run `./sync-template.sh --sync` |
| Breaking change | Read migration guide, then sync |

### How Sync Works

```
┌───────────────────────────────────────────────────────────────────────┐
│  SYNC FLOW                                                             │
├───────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  1. Clone template to /tmp                                             │
│  2. Compare versions (project vs template)                             │
│  3. Copy ONLY syncable files                                           │
│  4. Update version in .claude-product-cycle.yaml                       │
│  5. Preserve all project-specific files                                │
│                                                                        │
└───────────────────────────────────────────────────────────────────────┘
```

### Handling Breaking Changes

When MAJOR version changes:

1. **Read CHANGELOG.md** for migration guide
2. **Backup project files** before sync
3. **Run sync with --dry-run** to preview changes
4. **Apply manual migrations** as documented
5. **Run sync** to update files
6. **Test project** thoroughly

---

## File Change Checklist

### Adding a New Command

- [ ] Create `commands/newcommand.md`
- [ ] Add mapping in `scripts/sync-template.sh`
- [ ] Update `README.md` commands table
- [ ] Update `CHANGELOG.md`
- [ ] Bump VERSION (MINOR)
- [ ] Test in sample project

### Modifying Existing Command

- [ ] Edit command file
- [ ] Update `CHANGELOG.md`
- [ ] Bump VERSION (PATCH or MAJOR if breaking)
- [ ] Test in sample project
- [ ] Document any migration needed

### Adding a Template File

- [ ] Create file in `templates/`
- [ ] Update `scripts/init-project.sh` to copy it
- [ ] If syncable, add to `scripts/sync-template.sh`
- [ ] Update `README.md` directory structure
- [ ] Update `CHANGELOG.md`
- [ ] Bump VERSION (MINOR)

### Updating Patterns

- [ ] Edit `templates/design-spec-layer/_shared/PATTERNS.md`
- [ ] Update `CHANGELOG.md`
- [ ] Bump VERSION (PATCH)
- [ ] Notify projects to sync

---

## Testing Checklist

Before submitting PR:

### Basic Tests

- [ ] `./scripts/init-project.sh` creates valid project
- [ ] `./scripts/sync-template.sh --check` works
- [ ] `./scripts/sync-template.sh --sync` works
- [ ] All commands have valid markdown syntax

### Integration Tests

- [ ] Commands work in Claude Code
- [ ] No project-specific references exist
- [ ] Placeholders are properly formatted (`{{NAME}}`)
- [ ] Backward compatibility maintained

---

## Project-Specific Customizations

Projects can extend the template:

### Custom Commands

```
your-project/.claude/commands/
├── implement.md         # From template (synced)
├── design.md            # From template (synced)
└── custom-command.md    # Project-specific (not synced)
```

### Custom Patterns

Add project-specific patterns after the synced content:

```markdown
<!-- templates/design-spec-layer/_shared/PATTERNS.md -->
<!-- SYNCED CONTENT ABOVE -->

---

## Project-Specific Patterns

### Custom Caching Strategy
...
```

---

## Adding New Backend Types

The template supports multiple backend types. Currently supported:
- **Supabase** - PostgreSQL with RLS, RPCs, real-time
- **Firebase** - Firestore, Cloud Functions, Firebase Auth
- **Custom** - Any REST/GraphQL API

### Contributing a New Backend Type

If you're using a different backend (e.g., AWS Amplify, PocketBase, Appwrite), you can contribute it!

#### Step 1: Create Template Structure

```bash
templates/server-layer/{backend-name}/
├── CLAUDE.md.template     # Claude instructions for this backend
├── migrations/            # Migration templates (if applicable)
│   └── .gitkeep
└── scripts/               # Backend-specific scripts
    └── .gitkeep
```

#### Step 2: CLAUDE.md.template Requirements

Your template must include:

| Section | Required | Description |
|---------|----------|-------------|
| Quick Context | Yes | One-liner about the backend |
| Architecture | Yes | ASCII diagram showing client→backend flow |
| Directory Structure | Yes | File organization |
| CLI Commands | Yes | Common commands for the backend |
| Migration Template | If applicable | How to create migrations |
| Common Patterns | Yes | User data, triggers, caching |
| Deployment | Yes | How to deploy |
| Environment Variables | Yes | Required config |

#### Step 3: Update init-project.sh

Add your backend to the initialization script:

```bash
# scripts/init-project.sh
case "$BACKEND_TYPE" in
    supabase)
        cp -r "$TEMPLATE_ROOT/templates/server-layer/supabase" "$PROJECT_SERVER"
        ;;
    firebase)
        cp -r "$TEMPLATE_ROOT/templates/server-layer/firebase" "$PROJECT_SERVER"
        ;;
    your-backend)  # ADD THIS
        cp -r "$TEMPLATE_ROOT/templates/server-layer/your-backend" "$PROJECT_SERVER"
        ;;
esac
```

#### Step 4: Update README.md

Add your backend to the configuration section:

```yaml
backend:
  type: "your-backend"  # ADD TO LIST: supabase | firebase | custom | your-backend
```

#### Step 5: Checklist for Backend PRs

- [ ] Created `templates/server-layer/{backend}/CLAUDE.md.template`
- [ ] Template includes all required sections
- [ ] No hardcoded project names (use `{{PROJECT_NAME}}`)
- [ ] Added to `scripts/init-project.sh`
- [ ] Added to README.md backend options
- [ ] Updated CHANGELOG.md
- [ ] Bumped VERSION (MINOR)
- [ ] Tested with a sample project

### Example: Adding AWS Amplify

```
templates/server-layer/amplify/
├── CLAUDE.md.template
│   # Includes:
│   # - Amplify CLI commands
│   # - GraphQL schema patterns
│   # - Lambda function templates
│   # - AppSync integration
│   # - Cognito auth patterns
├── graphql/
│   └── schema.graphql.template
└── functions/
    └── .gitkeep
```

### Backend-Specific Server Commands

When adding a backend, you can optionally create a backend-specific `/server` command variant:

```markdown
# commands/server-amplify.md (optional)
# Custom server command for Amplify-specific workflows
```

---

## Release Process

1. **Merge PR to main**
2. **Create GitHub release**
   ```bash
   VERSION=$(cat VERSION)
   gh release create "v$VERSION" --title "v$VERSION" --notes "See CHANGELOG.md"
   ```
3. **Notify projects** (optional)
   - Post update in discussions
   - Update sample projects

---

## Questions?

- Open an issue: https://github.com/mobilebytesensei/claude-product-cycle-kmp/issues
- Start a discussion: https://github.com/mobilebytesensei/claude-product-cycle-kmp/discussions
