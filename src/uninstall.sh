#!/usr/bin/env bash
# uninstall.sh — remove o grok-any-llm (gall) de macOS/Linux. License: MIT.
set -euo pipefail

DEST="$HOME/.grok-any-llm"
RC="$HOME/.bashrc"; [ -n "${ZSH_VERSION:-}" ] && RC="$HOME/.zshrc"

rm -rf "$DEST" && echo "[gall] removido $DEST"

if [ -f "$RC" ]; then
  sed -i '/# >>> grok-any-llm (gall) >>>/,/# <<< grok-any-llm (gall) <<</d' "$RC"
  echo "[gall] funcoes removidas de $RC"
fi
echo "[gall] desinstalado. (seu ~/.grok e keys de env nao foram tocados)"
