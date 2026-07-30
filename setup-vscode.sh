#!/usr/bin/env bash
#
# setup-vscode.sh — one-shot VSCode setup for presidium-styling-base.
#
# This repo is SCSS/assets only (no Hugo layouts), so it gets the stylelint +
# prettier tooling, search excludes that hide vendored Bootstrap and
# node_modules, and a task to regenerate STYLES.md (mixins / tokens / component
# classes). Safe to re-run; existing .vscode files are backed up to *.bak.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSC="$REPO_DIR/.vscode"
mkdir -p "$VSC"

info() { printf '\033[1;34m▶\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }

write_file() { # $1 = destination path; content on stdin
  local path="$1"
  if [ -f "$path" ]; then cp "$path" "$path.bak"; warn "backed up $(basename "$path") -> $(basename "$path").bak"; fi
  cat > "$path"
  ok "wrote ${path#$REPO_DIR/}"
}

EXTS=(
  stylelint.vscode-stylelint
  esbenp.prettier-vscode
)

info "Configuring $(basename "$REPO_DIR") for VSCode"

write_file "$VSC/extensions.json" <<'JSON'
{
  "recommendations": [
    "stylelint.vscode-stylelint",
    "esbenp.prettier-vscode"
  ]
}
JSON

write_file "$VSC/settings.json" <<'JSON'
{
  // Let stylelint own SCSS diagnostics; silence VSCode's built-in CSS linter.
  "scss.validate": false,
  "stylelint.validate": ["css", "scss"],
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  // Keep Cmd/Ctrl+P and search on Presidium's own SCSS, not vendored Bootstrap.
  "search.exclude": {
    "**/node_modules": true,
    "**/assets/_sass/bootstrap/**": true,
    "**/.git": true
  }
}
JSON

write_file "$VSC/tasks.json" <<'JSON'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Presidium: Regenerate STYLES.md",
      "type": "shell",
      "command": "python3",
      "args": ["${workspaceFolder}/../gen_styles.py"],
      "detail": "Rescan assets/_sass and rewrite the SCSS catalog (mixins, tokens, component classes).",
      "problemMatcher": []
    }
  ]
}
JSON

# --- install extensions --------------------------------------------------------
if command -v code >/dev/null 2>&1; then
  for e in "${EXTS[@]}"; do
    info "installing extension: $e"
    code --install-extension "$e" --force >/dev/null 2>&1 && ok "$e" || warn "could not install $e"
  done
else
  warn "'code' CLI not found. In VSCode: Cmd+Shift+P -> \"Shell Command: Install 'code' command in PATH\", then re-run this script."
fi

# --- refresh the catalog (optional) -------------------------------------------
GEN="$REPO_DIR/../gen_styles.py"
if command -v python3 >/dev/null 2>&1 && [ -f "$GEN" ]; then
  info "regenerating STYLES.md"
  python3 "$GEN" >/dev/null 2>&1 && ok "STYLES.md refreshed" || warn "generator failed (run 'python3 $GEN' to see why)"
else
  warn "skipped catalog refresh (needs python3 and ../gen_styles.py alongside the repos)"
fi

cat <<'TIP'

Done. Next:
  • Open the multi-root workspace: code ../presidium.code-workspace  (all three repos together)
  • Reload VSCode so the new extensions apply.
  • Browse the reusable SCSS surface (mixins, design tokens, component classes): open STYLES.md.
  • Regenerate anytime: Cmd+Shift+P -> "Run Task" -> "Presidium: Regenerate STYLES.md".
TIP
