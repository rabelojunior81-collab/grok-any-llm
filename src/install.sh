#!/usr/bin/env bash
# install.sh — grok-any-llm (gall) installer for macOS/Linux (bash)
# Uso: curl -fsSL https://.../install.sh | bash
# License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab
set -euo pipefail

DEST="$HOME/.grok-any-llm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
echo "[gall] instalando em $DEST"

mkdir -p "$DEST/src" "$DEST/profiles" "$DEST/.telemetry"
touch "$DEST/.telemetry/.gitkeep"
cp "$SCRIPT_DIR/gall.sh" "$DEST/src/"
chmod +x "$DEST/src/gall.sh"
[ -d "$REPO_ROOT/profiles" ] && cp -r "$REPO_ROOT/profiles/"* "$DEST/profiles/"

# shell rc
RC="$HOME/.bashrc"
[ -n "${ZSH_VERSION:-}" ] && RC="$HOME/.zshrc"
MARKER='# >>> grok-any-llm (gall) >>>'
BLOCK="$MARKER
alias gall=\"$DEST/src/gall.sh\"
grok() {
  if [ \$# -gt 0 ] && [ \"\$1\" = or -o \"\$1\" = kilo -o \"\$1\" = oc ]; then
    \"$DEST/src/gall.sh\" \"\$@\"
  else
    command grok \"\$@\"
  fi
}
# <<< grok-any-llm (gall) <<<"

touch "$RC"
if ! grep -qF "$MARKER" "$RC"; then
  printf '\n%s\n' "$BLOCK" >> "$RC"
  echo "[gall] funcoes 'gall' e 'grok' adicionadas a $RC"
else
  echo "[gall] ja presente em $RC (skip)"
fi

echo
echo "[gall] pronto. Reinicie o terminal (ou 'source $RC')."
echo "      Use:  grok kilo | grok or | grok oc | grok"
echo "      Keys: export OPENROUTER_API_KEY / KILO_API_KEY / OPENCODE_GO_API_KEY"
echo "      Requer: binario 'grok' (curl -fsSL https://x.ai/cli/install.sh | bash)"
