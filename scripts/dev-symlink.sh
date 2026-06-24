#!/usr/bin/env bash
# Dev install: symlink the /product skill into ~/.claude/skills so edits go live without reinstall.
# Gives a clean `/product` invocation (user-level skills are not plugin-namespaced).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/plugins/product/skills/product"
DEST="$HOME/.claude/skills/product"

if [[ ! -d "$SRC" ]]; then
  echo "error: skill source not found at $SRC" >&2
  exit 1
fi

if [[ -e "$DEST" && ! -L "$DEST" ]]; then
  echo "error: $DEST exists and is not a symlink — refusing to overwrite." >&2
  echo "       move it aside, then re-run." >&2
  exit 1
fi

ln -sfn "$SRC" "$DEST"
echo "linked: $DEST -> $SRC"
echo "invoke with: /product"
