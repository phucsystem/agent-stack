#!/usr/bin/env bash
# The ONLY way to bump agent-stack's version. Syncs version across all files, rolls the changelog,
# commits, tags, and pushes. The pushed tag triggers .github/workflows/release.yml to cut the
# GitHub Release. Never hand-edit version fields — that is how drift happens.
#
# Usage: scripts/bump.sh <major|minor|patch>
set -euo pipefail

LEVEL="${1:-}"
case "$LEVEL" in major|minor|patch) ;; *) echo "usage: scripts/bump.sh <major|minor|patch>" >&2; exit 1;; esac

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
PLUGIN=.claude-plugin/plugin.json
MARKET=.claude-plugin/marketplace.json
README=README.md
CHANGELOG=CHANGELOG.md

[[ -z "$(git status --porcelain)" ]] || { echo "working tree not clean — commit or stash first." >&2; exit 1; }
grep -q '## \[Unreleased\]' "$CHANGELOG" || { echo "CHANGELOG.md missing an [Unreleased] section." >&2; exit 1; }

CUR=$(python3 -c "import json;print(json.load(open('$PLUGIN'))['version'])")
IFS=. read -r MA MI PA <<<"$CUR"
case "$LEVEL" in
  major) MA=$((MA+1)); MI=0; PA=0;;
  minor) MI=$((MI+1)); PA=0;;
  patch) PA=$((PA+1));;
esac
NEW="$MA.$MI.$PA"
DATE=$(date +%F)
echo "bump: $CUR -> $NEW ($DATE)"

# Version fields (JSON edited via python to stay valid); README old->new; changelog rolled.
python3 - "$PLUGIN" "$MARKET" "$README" "$CHANGELOG" "$CUR" "$NEW" "$DATE" <<'PY'
import json, sys, re
plugin, market, readme, changelog, cur, new, date = sys.argv[1:8]

d = json.load(open(plugin)); d["version"] = new
json.dump(d, open(plugin, "w"), indent=2); open(plugin, "a").write("\n")

m = json.load(open(market)); m["metadata"]["version"] = new
json.dump(m, open(market, "w"), indent=2); open(market, "a").write("\n")

r = open(readme).read().replace(cur, new); open(readme, "w").write(r)

c = open(changelog).read()
c = c.replace("## [Unreleased]", f"## [Unreleased]\n\n## [{new}] - {date}", 1)
open(changelog, "w").write(c)
PY

git add -A
git commit -q -m "chore(release): v$NEW"
git tag "v$NEW"
git push -q origin HEAD
git push -q origin "v$NEW"
echo "released v$NEW — tag pushed; release workflow will publish the GitHub Release."
