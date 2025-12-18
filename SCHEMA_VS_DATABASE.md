# Understanding: Schema Definition vs Actual Database

## Common Confusion: "It's in SIMPLE_EFP_DATABASE_SCHEMAS but doesn't work!"

### The Key Distinction

```
Being in SIMPLE_EFP_DATABASE_SCHEMAS ≠ Database exists in MySQL
```

### What Each Thing Means

| Thing | What It Is | What It Does |
|-------|------------|--------------|
| **SIMPLE_EFP_DATABASE_SCHEMAS** | Schema definition (blueprint) | Tells the system HOW to create the database |
| **ORM Model** | Python class | Auto-generated from schema (in memory) |
| **MySQL Database** | Actual database | Must be created via bootstrap script |
| **SQLite File** | Local mirror | Fallback for offline development |

### The Flow

```
1. SIMPLE_EFP_DATABASE_SCHEMAS
   ↓ (schema is defined)

2. api/models/efp_dynamic.py
   ↓ (ORM model auto-generated at import)

3. scripts/bootstrap_simple_efp_dbs.py
   ↓ (YOU MUST RUN THIS!)

4. MySQL Server
   ↓ (actual database now exists)

5. Queries work!
```

### Example: Embryo Database

**Status Check:**
- ✅ Schema defined in `SIMPLE_EFP_DATABASE_SCHEMAS`
- ✅ ORM model `EmbryoSampleData` exists
- ✅ SQLite file `config/databases/embryo.db` exists
- ❓ MySQL database `embryo` - **DEPENDS ON ENVIRONMENT**

**On Your Local Machine:**
- Config uses SQLite → Works with `.db` file
- No MySQL needed for development

**On Production Server:**
- Config uses MySQL → **Requires bootstrap**
- Must run: `./config/init.sh` or bootstrap script

### Why You're Getting MySQL Error for Embryo

**Most Likely Reasons:**

1. **Testing on production server**
   - Server config has MySQL bind for embryo
   - MySQL database wasn't bootstrapped yet
   - **Fix:** SSH to server, run `./config/init.sh`

2. **Flask app not restarted after config change**
   - Old config cached with MySQL bind
   - **Fix:** Restart Flask app

3. **Wrong environment**
   - Environment variable pointing to different config
   - **Fix:** Check `echo $BAR_API_PATH` or config loading

### How to Diagnose

Run this to see which config is loaded:

```python
from api import app

with app.app_context():
    embryo_bind = app.config['SQLALCHEMY_BINDS'].get('embryo')
    print(f"Embryo bind: {embryo_bind}")

    if embryo_bind and 'mysql' in embryo_bind:
        print("→ Using MySQL (needs bootstrap)")
    elif embryo_bind and 'sqlite' in embryo_bind:
        print("→ Using SQLite (should work)")
    else:
        print("→ No bind configured!")
```

### Quick Fixes

**If on LOCAL machine (want SQLite):**
```bash
# Verify config uses SQLite
grep embryo ~/.config/BAR_API.cfg

# Should show:
# "embryo": "sqlite:////Users/.../embryo.db"

# Restart Flask
pkill -f flask
flask run
```

**If on PRODUCTION server (need MySQL):**
```bash
# Bootstrap the database
./config/init.sh

# Or specifically for embryo:
python scripts/bootstrap_simple_efp_dbs.py \
    --host BAR_mysqldb \
    --user root \
    --password $DB_PASSWORD \
    --databases embryo
```

### Remember

**Schema definition (in code)** is NOT the same as **database creation (in MySQL)**.

Think of it like:
- **Recipe book** (schema) vs **Actual cooked meal** (database)
- **Blueprint** (schema) vs **Built house** (database)
- **Class definition** (schema) vs **Object instance** (database)

You need BOTH!
