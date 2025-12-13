# Sync Strategy Guide

Quick reference for projects using Claude Product Cycle template.

---

## TL;DR

```bash
# Check for updates
./claude-product-cycle/sync-template.sh --check

# Sync latest changes
./claude-product-cycle/sync-template.sh --sync
```

---

## What Gets Synced

### Synced (Updated Automatically)

| Files | Purpose |
|-------|---------|
| `.claude/commands/*.md` | Slash commands |
| `claude-product-cycle/_shared/PATTERNS.md` | Architecture patterns |
| `claude-product-cycle/_shared/CROSS_UPDATE_RULES.md` | Plan sync rules |

### Preserved (Never Overwritten)

| Files | Purpose |
|-------|---------|
| `features/*/SPEC.md` | Your feature specs |
| `features/*/API.md` | Your API definitions |
| `features/*/STATUS.md` | Your implementation status |
| `STATUS.md` | Your project status |
| `CLAUDE.md` | Your project context |
| `.claude-product-cycle.yaml` | Your project config |

---

## When to Sync

| Template Change | Action |
|-----------------|--------|
| New command | Sync immediately |
| Command bugfix | Sync when convenient |
| Pattern update | Sync when starting new work |
| Breaking change | Read CHANGELOG first |

---

## Sync Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  SAFE SYNC WORKFLOW                                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Check current version:                                   │
│     ./claude-product-cycle/sync-template.sh --check          │
│                                                              │
│  2. Read CHANGELOG if version differs:                       │
│     https://github.com/.../CHANGELOG.md                      │
│                                                              │
│  3. Sync if safe:                                            │
│     ./claude-product-cycle/sync-template.sh --sync           │
│                                                              │
│  4. Test your commands still work                            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Handling Version Differences

### PATCH Update (1.0.0 → 1.0.1)

```bash
# Safe to sync immediately
./claude-product-cycle/sync-template.sh --sync
```

### MINOR Update (1.0.0 → 1.1.0)

```bash
# Review changelog, then sync
./claude-product-cycle/sync-template.sh --sync
# May have new commands to explore
```

### MAJOR Update (1.0.0 → 2.0.0)

```bash
# STOP! Read migration guide in CHANGELOG.md first
# May require manual changes
```

---

## Troubleshooting

### Sync Failed

```bash
# Check git access
git ls-remote https://github.com/mobilebytesensei/claude-product-cycle-kmp.git

# Try again
./claude-product-cycle/sync-template.sh --sync
```

### Version Not Updating

```bash
# Check config file exists
cat .claude-product-cycle.yaml

# Verify version line format
grep "version:" .claude-product-cycle.yaml
```

### Custom Commands Overwritten

Custom commands should be placed in `.claude/commands/` with names that don't conflict with template commands:

```
.claude/commands/
├── implement.md      # Template (synced)
├── my-custom.md      # Your custom (preserved)
└── project-lint.md   # Your custom (preserved)
```

---

## Adding Feedback

Found an improvement for the template?

1. **Open Issue**: https://github.com/mobilebytesensei/claude-product-cycle-kmp/issues
2. **Submit PR**: See CONTRIBUTING.md
3. **Discuss**: https://github.com/mobilebytesensei/claude-product-cycle-kmp/discussions

Your feedback helps improve the template for everyone!
