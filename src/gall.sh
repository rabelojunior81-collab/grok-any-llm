#!/usr/bin/env bash
# gall.sh — grok-any-llm shim (bash, macOS/Linux)
# Lança o harness Grok Code com um provider de LLM, de forma nao-persistente.
# Uso:  gall <provider> [--model X] [args...]
#       gall [args...]            # passthrough p/ o grok default
# Providers: or (OpenRouter) | kilo (Kilo Gateway) | oc (OpenCode Go)
# License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_ROOT="$(cd "$SCRIPT_DIR/../profiles" 2>/dev/null && pwd || echo "$SCRIPT_DIR/profiles")"

declare -A PROVIDERS=(
  [or]="or:OPENROUTER_API_KEY"
  [kilo]="kilo:KILO_API_KEY"
  [oc]="oc:OPENCODE_GO_API_KEY"
)

provider=""
override_model=""
dry_run=0
rest=()

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) dry_run=1; shift ;;
    --model) override_model="$2"; shift 2 ;;
    --model=*) override_model="${1#--model=}"; shift ;;
    *)
      if [ -z "$provider" ] && [[ -n "${PROVIDERS[$1]:-}" ]]; then provider="$1"; shift
      else rest+=("$1"); shift
      fi ;;
  esac
done

telemetry() {
  local sink="$HOME/.grok-any-llm/.telemetry/gall.jsonl"
  [ -d "$(dirname "$sink")" ] || return 0
  local ts; ts="$(date +%Y-%m-%dT%H:%M:%S-03:00)"
  printf '{"ts":"%s","harness":"gall","llm":"%s","model":"%s","provider":"%s","session":%s,"outcome":"%s"}\n' \
    "$ts" "${2:-?}" "${2:-?}" "$1" "$$" "$3" >> "$sink"
}

if [ -n "$provider" ]; then
  IFS=':' read -r prof keyenv <<< "${PROVIDERS[$provider]}"
  profile_dir="$PROFILES_ROOT/$prof"
  [ -f "$profile_dir/config.toml" ] || { echo "[gall] perfil nao encontrado: $profile_dir/config.toml" >&2; exit 2; }
  key="${!keyenv:-}"
  [ -n "$key" ] || { echo "[gall] ERRO: env var $keyenv nao definida.  export $keyenv='sua-key'" >&2; exit 3; }
  if [ "$dry_run" -eq 1 ]; then
    echo "[gall dry-run] provider=$provider  GROK_HOME=$profile_dir  XAI_API_KEY=${key:0:6}...  GROK_DEFAULT_MODEL=${override_model:-(do perfil)}"
    telemetry "$provider" "${override_model:-?}" "dry-run"; exit 0
  fi
  command -v grok >/dev/null 2>&1 || { echo "[gall] ERRO: 'grok' nao esta no PATH. Instale: curl -fsSL https://x.ai/cli/install.sh | bash" >&2; exit 4; }
  export GROK_HOME="$profile_dir"
  export XAI_API_KEY="$key"
  [ -n "$override_model" ] && export GROK_DEFAULT_MODEL="$override_model"
  grok "${rest[@]}"
  telemetry "$provider" "${override_model:-?}" "ok"
else
  command -v grok >/dev/null 2>&1 || { echo "[gall] ERRO: 'grok' nao esta no PATH." >&2; exit 4; }
  grok "${rest[@]}"
fi
