#!/usr/bin/env bash
# Dev install: symlink the whole agent-stack (all skills + agents) into ~/.claude so edits go live
# without reinstall. Gives clean, un-namespaced names (/product, /prototype, subagent: prototyper).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() { # $1 = source, $2 = dest
  local src="$1" dest="$2"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "skip: $dest exists and is not a symlink — move it aside, then re-run." >&2
    return
  fi
  ln -sfn "$src" "$dest"
  echo "linked: $dest -> $src"
}

mkdir -p "$HOME/.claude/skills" "$HOME/.claude/agents"

# Skills: each subdir of skills/ -> ~/.claude/skills/<name>
for d in "$REPO_ROOT"/skills/*/; do
  [[ -d "$d" ]] || continue
  link "${d%/}" "$HOME/.claude/skills/$(basename "$d")"
done

# Agents: each .md in agents/ -> ~/.claude/agents/<name>.md
for f in "$REPO_ROOT"/agents/*.md; do
  [[ -f "$f" ]] || continue
  link "$f" "$HOME/.claude/agents/$(basename "$f")"
done

echo "done. invoke skills with /<name>; agents via subagent_type."
