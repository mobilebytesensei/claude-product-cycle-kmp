# /server Command

Backend/Supabase operations. **Smart table management with auto-population detection.**

## Variants

```
/server              → Show status + gaps
/server [Feature]    → Implement backend for feature
/server sync         → Sync all data to Supabase
/server deploy       → Deploy pending migrations
```

---

## CROSS-REFERENCE ARCHITECTURE (READ FIRST)

```
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER FLOW: /implement → /server → movie-pipeline                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. /implement [Feature]                                             │
│     ↓ reads                                                          │
│     design-spec-layer/features/{Feature}/API.md                      │
│     (defines what tables, RPCs, DTOs are needed)                     │
│                                                                      │
│  2. /server [Feature]                                                │
│     ↓ reads API.md to know requirements                              │
│     ↓ creates migrations in server-layer/supabase/migrations/        │
│     ↓ checks if population needed (decision tree below)              │
│                                                                      │
│  3. movie-pipeline (if population needed)                            │
│     ↓ reads/creates tables in global_database_movies.db              │
│     ↓ syncs to Supabase via sync_*.py scripts                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### API.md Location

```
claude-product-cycle/design-spec-layer/features/{Feature}/API.md
```

**Always read the feature's API.md first** - it defines:
- Required tables and columns
- RPC signatures
- DTO structures
- Edge cases

### Table Naming Synchronization (CRITICAL)

**Tables MUST have the SAME NAME in both databases:**

| SQLite (movie-pipeline) | PostgreSQL (Supabase) | Notes |
|-------------------------|----------------------|-------|
| `movies` | `movies` | ✓ Same |
| `moods` | `moods` | ✓ Same |
| `emotions` | `emotions` | ✓ Same |
| `genres` | `genres` | ✓ Same |
| `movie_moods` | `movie_moods` | ✓ Same |
| `movie_emotions` | `movie_emotions` | ✓ Same |
| `movie_genres` | `movie_genres` | ✓ Same |

**When creating new tables:**
1. If table needs data from SQLite → Use SAME name in both
2. If table is user-generated only → Only exists in Supabase
3. Document in SCHEMA_REGISTRY.md which tables exist where

---

## /server [Feature] - COMPLETE WORKFLOW

```
┌─────────────────────────────────────────────────────────────────────┐
│  /server [Feature] - STEP BY STEP                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  STEP 1: READ API.md                                                 │
│  ────────────────────                                                │
│  File: design-spec-layer/features/{Feature}/API.md                   │
│  Extract: All tables, RPCs, DTOs required                            │
│                                                                      │
│  STEP 2: CHECK WHAT EXISTS                                           │
│  ─────────────────────────                                           │
│  • mcp__supabase__list_tables                                        │
│  • mcp__supabase__execute_sql("SELECT proname FROM pg_proc...")      │
│  • Skip items that already exist                                     │
│                                                                      │
│  STEP 3: FOR EACH MISSING ITEM → RUN DECISION TREE                   │
│  ─────────────────────────────────────────────────                   │
│  Q1: User-generated? → Table only, no population                     │
│  Q2: Auto-generated? → Table + Trigger                               │
│  Q3: Cache table? → Table + Rebuild RPC                              │
│  Q4: In SQLite? → Table + Sync script                                │
│  Q5: Static reference? → Table + Hardcode data                       │
│  Q6: External API? → Table + Document source + Fetch script          │
│                                                                      │
│  STEP 4: CREATE MIGRATION                                            │
│  ────────────────────────                                            │
│  File: server-layer/supabase/migrations/YYYYMMDD_NNN_feature.sql     │
│  Contains: CREATE TABLE, INDEX, RLS, POLICY, RPC, TRIGGER            │
│                                                                      │
│  STEP 5: DEPLOY                                                      │
│  ─────────                                                           │
│  cd server-layer/supabase && python3 master.py deploy                │
│                                                                      │
│  STEP 6: POPULATE DATA                                               │
│  ─────────────────────                                               │
│  • User-generated: Nothing (app creates)                             │
│  • Triggers: Auto-handled by Supabase                                │
│  • Cache: python3 master.py sync --caches                            │
│  • SQLite: python3 master.py sync --catalogs/--movies                │
│  • External: Run fetch script first, then sync                       │
│                                                                      │
│  STEP 7: VERIFY                                                      │
│  ───────────                                                         │
│  • mcp__supabase__execute_sql("SELECT COUNT(*) FROM new_table")      │
│  • Test RPC: mcp__supabase__execute_sql("SELECT * FROM rpc(...)")    │
│                                                                      │
│  STEP 8: UPDATE REGISTRY                                             │
│  ────────────────────────                                            │
│  Add to: design-spec-layer/SCHEMA_REGISTRY.md                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## SMART TABLE CREATION WORKFLOW (CRITICAL)

When implementing ANY new feature that needs tables (social, recommendations, stats, etc.), follow this workflow:

### Step 1: Read API.md

```
claude-product-cycle/design-spec-layer/features/{Feature}/API.md
```

Extract ALL requirements:
- Tables (with columns, types, constraints)
- RPCs (function signatures, parameters, return types)
- DTOs (for KMP client reference)

### Step 2: Check What Exists

```bash
# List all tables
mcp__supabase__list_tables

# Check specific table
mcp__supabase__execute_sql("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'table_name'")

# Check RPCs
mcp__supabase__execute_sql("SELECT proname, prosrc FROM pg_proc WHERE proname = 'rpc_name'")

# Check triggers
mcp__supabase__execute_sql("SELECT trigger_name, event_manipulation, action_statement FROM information_schema.triggers WHERE trigger_schema = 'public'")
```

**Skip items that already exist and match spec.**

### Step 3: Run Decision Tree for Each Missing Item

```
┌───────────────────────────────────────────────────────────────────┐
│  DECISION TREE: How should table be populated?                    │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Q1: Is it USER-GENERATED data?                                    │
│      (user_reviews, user_follows, user_activities)                 │
│      YES → No population needed, app creates data                  │
│      NO  → Continue to Q2                                          │
│                                                                    │
│  Q2: Should data be AUTO-GENERATED via triggers?                   │
│      (counts, activity feeds, audit logs, computed fields)         │
│      YES → Create trigger in migration (see AUTO-GEN below)        │
│      NO  → Continue to Q3                                          │
│                                                                    │
│  Q3: Is it a CACHE table derived from existing data?               │
│      (mood_movies_cache, trending_movies, user_stats)              │
│      YES → Create RPC to rebuild + optionally schedule refresh     │
│      NO  → Continue to Q4                                          │
│                                                                    │
│  Q4: Does data exist in movie-pipeline SQLite?                     │
│      YES → Sync from SQLite via sync_*.py                          │
│      NO  → Continue to Q5                                          │
│                                                                    │
│  Q5: Is it static REFERENCE data?                                  │
│      (countries, languages, certification_types)                   │
│      YES → Add to sync_catalogs.py with hardcoded data             │
│      NO  → Continue to Q6                                          │
│                                                                    │
│  Q6: Does it need EXTERNAL API data?                               │
│      (TMDB credits, streaming providers, trailers)                 │
│      YES → Create fetch script + table + sync (see EXTERNAL below) │
│      NO  → Document as manual entry or future work                 │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

## AUTO-GENERATED DATA (Triggers & Computed Tables)

### When to Use Triggers (Q2 = YES)

| Pattern | Use Trigger | Example |
|---------|-------------|---------|
| **Count fields** | ✅ Yes | `followers_count`, `reviews_count`, `watch_count` |
| **Activity feeds** | ✅ Yes | Insert to `user_activities` when user follows/reviews |
| **Audit logs** | ✅ Yes | Track changes to sensitive tables |
| **Computed timestamps** | ✅ Yes | `last_activity_at`, `last_login_at` |
| **Denormalized cache** | ⚠️ Consider | May be better as scheduled RPC |
| **Complex aggregations** | ❌ No | Use scheduled RPC instead |

### Trigger Patterns

**Pattern 1: Auto-Update Count**
```sql
-- When user_follows is inserted, update followers_count
CREATE OR REPLACE FUNCTION update_followers_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE users SET followers_count = followers_count + 1
        WHERE id = NEW.following_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE users SET followers_count = followers_count - 1
        WHERE id = OLD.following_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_followers_count
AFTER INSERT OR DELETE ON user_follows
FOR EACH ROW EXECUTE FUNCTION update_followers_count();
```

**Pattern 2: Auto-Create Activity**
```sql
-- When user follows someone, create activity entry
CREATE OR REPLACE FUNCTION create_follow_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_activities (user_id, activity_type, target_user_id, created_at)
    VALUES (NEW.user_id, 'follow', NEW.following_id, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_follow_activity
AFTER INSERT ON user_follows
FOR EACH ROW EXECUTE FUNCTION create_follow_activity();
```

**Pattern 3: Auto-Create User Profile (Existing)**
```sql
-- Already exists: on_auth_user_created trigger
-- Automatically creates public.users row when auth.users row is created
```

### When to Use Cache RPCs (Q3 = YES)

| Pattern | Use Cache RPC | Example |
|---------|---------------|---------|
| **Movie lists by mood** | ✅ Yes | `rebuild_mood_movies_cache()` |
| **Trending/Popular** | ✅ Yes | `rebuild_trending_cache()` |
| **User recommendations** | ✅ Yes | `rebuild_user_recommendations()` |
| **Statistics** | ✅ Yes | `rebuild_genre_stats()` |

**Cache RPC Pattern:**
```sql
-- Cache table
CREATE TABLE mood_movies_cache (
    mood_id UUID REFERENCES moods(id),
    movie_id UUID REFERENCES movies(id),
    relevance_score NUMERIC,
    cached_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (mood_id, movie_id)
);

-- Rebuild RPC
CREATE OR REPLACE FUNCTION rebuild_mood_movies_cache()
RETURNS INTEGER AS $$
DECLARE
    rows_inserted INTEGER;
BEGIN
    -- Clear old cache
    DELETE FROM mood_movies_cache WHERE cached_at < NOW() - INTERVAL '1 day';

    -- Rebuild from source tables
    INSERT INTO mood_movies_cache (mood_id, movie_id, relevance_score)
    SELECT mm.mood_id, mm.movie_id,
           (m.vote_average * 10 + m.popularity / 100) as relevance_score
    FROM movie_moods mm
    JOIN movies m ON mm.movie_id = m.id
    WHERE m.vote_count > 100
    ON CONFLICT (mood_id, movie_id) DO UPDATE
    SET relevance_score = EXCLUDED.relevance_score, cached_at = NOW();

    GET DIAGNOSTICS rows_inserted = ROW_COUNT;
    RETURN rows_inserted;
END;
$$ LANGUAGE plpgsql;
```

### Decision Examples

**Example 1: Social Feature**
```
user_follows table:
├─ Q1: User-generated? YES → No population needed ✓
├─ followers_count field on users:
│   └─ Q2: Auto-generated? YES → Create trigger ✓
└─ activity_feed entries:
    └─ Q2: Auto-generated? YES → Create trigger ✓
```

**Example 2: Trending Movies**
```
trending_movies_cache table:
├─ Q1: User-generated? NO
├─ Q2: Auto-generated via trigger? NO (too complex)
├─ Q3: Cache from existing data? YES → Create rebuild RPC ✓
└─ Schedule: Call RPC daily via cron/edge function
```

**Example 3: Movie Credits**
```
movie_credits table:
├─ Q1: User-generated? NO
├─ Q2: Auto-generated? NO
├─ Q3: Cache table? NO
├─ Q4: In SQLite? PARTIAL (only 10 movies have full credits)
├─ Q5: Static reference? NO
├─ Q6: External API? YES → TMDB API
└─ Action: Create fetch script, fetch data, then sync
```

---

## EXTERNAL API DATA (Q6 = YES)

When data needs to be fetched from external APIs (TMDB, JustWatch, etc.):

### Pattern: Fetch → Store in SQLite → Sync to Supabase

```
┌─────────────────────────────────────────────────────────────────┐
│  EXTERNAL API WORKFLOW                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. CREATE FETCH SCRIPT                                          │
│     Location: movie-pipeline/importers/fetch_*.py                │
│     Purpose: Fetch from API, store in SQLite                     │
│                                                                  │
│  2. ADD COLUMNS/TABLE TO SQLITE                                  │
│     Either: Add columns to movies table (credits, videos)        │
│     Or: Create new table (streaming_providers)                   │
│                                                                  │
│  3. RUN FETCH (rate-limited, resumable)                          │
│     python3 manage_db.py fetch-tmdb-details --batch-size 100     │
│                                                                  │
│  4. CREATE SUPABASE TABLE (migration)                            │
│     Same structure as SQLite                                     │
│                                                                  │
│  5. ADD SYNC SCRIPT                                              │
│     In: supabase/data/sync_*.py                                  │
│                                                                  │
│  6. RUN SYNC                                                     │
│     python3 master.py sync --movies (or custom flag)             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Available External APIs

| API | Data | Rate Limit | Env Variable |
|-----|------|------------|--------------|
| TMDB | Credits, videos, images, keywords | 40 req/10s | `TMDB_API_KEY` |
| TMDB | Watch providers | 40 req/10s | `TMDB_API_KEY` |
| IMDB | Ratings, basics, crew | No limit (files) | N/A (public datasets) |

### Example: Fetching TMDB Credits

```bash
# 1. Check current state
cd claude-product-cycle/server-layer/movie-pipeline
sqlite3 data/global_database_movies.db "SELECT COUNT(*) FROM movies WHERE credits IS NOT NULL"
# Result: 10 (only 10 movies have credits)

# 2. Fetch more credits (requires TMDB_API_KEY in .env)
python3 manage_db.py fetch-tmdb-details --batch-size 100 --type credits

# 3. After fetch completes, sync to Supabase
cd ../supabase
python3 master.py sync --movies
```

---

## CACHE REFRESH SCHEDULING

For cache tables that need periodic refresh:

### Option 1: Edge Function (Recommended)

```typescript
// edge-functions/refresh-caches/index.ts
import { createClient } from '@supabase/supabase-js'

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Rebuild caches
  await supabase.rpc('rebuild_mood_movies_cache')
  await supabase.rpc('rebuild_trending_cache')

  return new Response('Caches refreshed')
})
```

Deploy and schedule:
```bash
# Deploy
npx supabase functions deploy refresh-caches

# Schedule via Supabase Dashboard → Database → Extensions → pg_cron
SELECT cron.schedule('refresh-caches', '0 */6 * * *',
  $$SELECT net.http_post('https://your-project.supabase.co/functions/v1/refresh-caches')$$
);
```

### Option 2: Manual Rebuild via master.py

```bash
# Run periodically via system cron or manually
cd claude-product-cycle/server-layer/supabase
python3 master.py sync --caches
```

---

### Step 4: Create Migration

```bash
cd claude-product-cycle/server-layer/supabase

# Naming: YYYYMMDD_NNN_description.sql
# Example: 20251212_001_social_tables.sql
```

**Migration Template:**
```sql
-- =============================================
-- Migration: 20251212_001_feature_name
-- Purpose: Brief description
-- Tables: table1, table2
-- RPCs: rpc_name (if any)
-- Population: Yes/No (describe source)
-- =============================================

-- 1. Create tables
CREATE TABLE IF NOT EXISTS table_name (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- columns
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create indexes
CREATE INDEX IF NOT EXISTS idx_table_column ON table_name(column);

-- 3. Enable RLS
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- 4. Create policies
CREATE POLICY "..." ON table_name FOR SELECT USING (...);

-- 5. Create RPCs (if needed)
CREATE OR REPLACE FUNCTION rpc_name(...)
RETURNS ... AS $$
BEGIN
    -- logic
END;
$$ LANGUAGE plpgsql;

-- 6. Create triggers (if needed)
CREATE TRIGGER trg_name
AFTER INSERT ON table_name
FOR EACH ROW EXECUTE FUNCTION function_name();
```

### Step 2: Deploy Migration

```bash
python3 master.py deploy           # Deploy to Supabase
python3 master.py deploy --dry-run # Preview first
```

### Step 3: Population (If Needed)

**Based on decision tree above:**

#### A) No Population Needed (User-Generated)
```
✓ Done - tables are ready for app to write data
```

#### B) Static/Catalog Data
```bash
# Add to supabase/data/sync_catalogs.py
# Then run:
python3 master.py sync --catalogs
```

#### C) Movie-Related Data (from SQLite)

**Bridge Pattern: movie-pipeline → supabase (ONE-WAY)**

```
┌─────────────────────────────────────────────────────────────────┐
│  SINGLE SOURCE OF TRUTH: global_database_movies.db              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ★ SOURCE (SQLite) - AUTHORITATIVE                              │
│  movie-pipeline/data/global_database_movies.db                  │
│  • 1.3M+ movies with moods, emotions, genres                    │
│  • IMDB data (ratings, crew, akas)                              │
│  • All relations pre-computed                                   │
│  • ALL changes happen here FIRST                                │
│                                                                  │
│                    ↓ ONE-WAY SYNC ↓                              │
│                                                                  │
│  DESTINATION (PostgreSQL) - READ-ONLY CONSUMER                   │
│  supabase/ (production PostgreSQL)                               │
│  • Filtered subset for production                               │
│  • Optimized for KMP app queries                                │
│  • NEVER edit movie data directly in Supabase                   │
│                                                                  │
│  SYNC SCRIPTS: supabase/data/                                   │
│  • sync_movies.py - Movie data                                  │
│  • sync_catalogs.py - Reference data (moods, emotions, genres)  │
│  • rebuild_caches.py - Cache tables                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**IMPORTANT:**
- Movie data flows ONE-WAY: SQLite → Supabase
- Never manually edit movies in Supabase (will be overwritten)
- All enrichments (importers/, enrichers/) update SQLite first

**To add new movie-related sync:**

1. Check if data exists in SQLite:
```bash
cd claude-product-cycle/server-layer/movie-pipeline
sqlite3 data/global_database_movies.db ".schema" | grep -i "table_name"
sqlite3 data/global_database_movies.db "SELECT COUNT(*) FROM table_name"
```

2. Add sync function to appropriate file:
```python
# In supabase/data/sync_catalogs.py or new sync_*.py file
def sync_new_table(dry_run=False):
    """Sync new_table from SQLite to Supabase."""
    # Read from SQLite
    sqlite_conn = sqlite3.connect(config.sqlite_db)
    rows = sqlite_conn.execute("SELECT * FROM table_name").fetchall()

    # Upsert to Supabase (uses psycopg2 for bulk ops)
    # ...
```

3. Register in master.py if new file
4. Run sync:
```bash
python3 master.py sync --catalogs  # or custom flag
```

#### D) Cache/Derived Tables
```bash
# Add rebuild logic to supabase/data/rebuild_caches.py
python3 master.py sync --caches
```

### Step 4: Update Registry

**ALWAYS update SCHEMA_REGISTRY.md:**
```markdown
| Table | Purpose | Population | Sync Script |
|-------|---------|------------|-------------|
| new_table | Description | Yes/No | sync_*.py or N/A |
```

---

## Quick Reference

```bash
cd claude-product-cycle/server-layer/supabase

python3 master.py status    # Status
python3 master.py check     # Gap detection
python3 master.py deploy    # Deploy migrations
python3 master.py sync      # Sync data
python3 master.py all       # Full deployment
```

## Key Patterns

### RPC vs selectAsFlow (KMP)

| Use RPC | Use selectAsFlow |
|---------|------------------|
| Complex queries, joins | Simple single-table queries |
| Cached queries (~6ms) | Real-time updates |
| Aggregations, counts | Basic CRUD |

### Sync Uses psycopg2 (NOT REST)

- psycopg2: ~10,000 rows/sec (use for all bulk ops)
- REST API: ~500 rows/sec (never for bulk)

## Migration Naming

```
YYYYMMDD_NNN_description.sql
Example: 20251212_001_social_tables.sql
```

## Table Categories (Quick Reference)

| Category | Population | Source | Sync Script |
|----------|------------|--------|-------------|
| User-generated | No | App usage | N/A |
| Reference/Catalog | Yes | Static or SQLite | sync_catalogs.py |
| Movie data | Yes | SQLite | sync_movies.py |
| Junction tables | Yes | SQLite | sync_catalogs.py |
| Cache tables | Yes | RPC/SQL | rebuild_caches.py |
| Social tables | No | App usage | N/A |
| Stats tables | Yes | RPC/SQL | Custom or caches |

## Triggers (Auto-Handled)

| Trigger | Purpose |
|---------|---------|
| `on_auth_user_created` | Auto-creates user profile on signup |
| `trg_update_*_count` | Auto-updates counts (followers, reviews, etc.) |
| `trg_create_*_activity` | Auto-creates social activity entries |

**Don't manually create user profiles in KMP - trigger handles it.**

## Files

```
server-layer/
├── supabase/
│   ├── master.py          # Single entry point
│   ├── migrations/        # SQL migrations
│   ├── data/
│   │   ├── sync_catalogs.py   # Reference data sync
│   │   ├── sync_movies.py     # Movie sync from SQLite
│   │   └── rebuild_caches.py  # Cache table rebuilds
│   └── .env               # Credentials
└── movie-pipeline/
    ├── CLAUDE.md          # ← READ THIS for pipeline sessions
    ├── movie_pipeline.sh  # Main CLI
    └── data/
        ├── global_database_movies.db  # Source SQLite (1.3M+ movies)
        └── sources/                   # Raw data files
```

## Movie Pipeline (Local Data)

**For movie data work, read:** `server-layer/movie-pipeline/CLAUDE.md`

```bash
cd claude-product-cycle/server-layer/movie-pipeline

./movie_pipeline.sh status       # Pipeline status
./movie_pipeline.sh sources      # Data source status
./movie_pipeline.sh imdb-full    # IMDB enrichment
```

## MCP Tools

```
mcp__supabase__list_tables
mcp__supabase__execute_sql("SELECT ...")
mcp__supabase__apply_migration("name", "SQL")
```

## Example: Adding Social Feature Tables

```
1. ANALYZE: user_follows, user_reviews → User-generated (no population)
           activity_feed → Derived (needs trigger-based population)

2. CREATE MIGRATION:
   migrations/20251212_001_social_tables.sql
   - CREATE TABLE user_follows (user_id, following_id, ...)
   - CREATE TABLE user_reviews (user_id, movie_id, ...)
   - CREATE TRIGGER trg_create_follow_activity ...

3. DEPLOY:
   python3 master.py deploy

4. POPULATION:
   - user_follows: None (app will create on user action)
   - user_reviews: None (app will create on user action)
   - activity_feed: Auto-populated via trigger

5. UPDATE REGISTRY:
   Add to SCHEMA_REGISTRY.md
```

## Cross-Update

See `CLAUDE.md` → MANDATORY RULES for full cross-update matrix.
