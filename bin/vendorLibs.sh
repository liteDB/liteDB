#!/usr/bin/env bash

### official SQLite extensions

curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/json1.c --output src/sqlite3-json1.c
curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/series.c --output src/sqlite3-series.c
curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/spellfix.c --output src/sqlite3-spellfix.c
curl -L https://github.com/sqlite/sqlite/raw/master/ext/misc/memstat.c --output src/sqlite3-memstat.c

### community-maintained extensions

curl -L https://github.com/shawnw/useful_sqlite_extensions/raw/master/src/math_funcs.c --output src/sqlite3-shawnw_math.c
patch -p0 < diffs/sqlite3-shawnw_math.diff

curl -L https://github.com/shawnw/useful_sqlite_extensions/raw/master/src/bloom_filter.c --output src/sqlite3-bloom_filter.c
patch -p0 < diffs/sqlite3-bloom_filter.diff

curl -L https://github.com/abetlen/sqlite3-bfsvtab-ext/raw/main/bfsvtab.c --output src/sqlite3-bfsvtab.c
curl -L https://github.com/jakethaw/pivot_vtab/raw/main/pivot_vtab.c --output src/sqlite3-pivot_vtab.c
curl -L https://github.com/daschr/sqlite3_extensions/raw/master/cron.c --output src/sqlite3-cron.c


## distance between 2 points (lat / lng)
curl -L https://github.com/cwarden/sqlite-distance/raw/master/distance.c --output src/sqlite3-distance.c
patch -p0 < diffs/sqlite3-distance.diff