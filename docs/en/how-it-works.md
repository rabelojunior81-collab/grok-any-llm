# How `gall` works

> Technical mechanism of `grok-any-llm` (`gall`). For context, see the [README](../../README.en.md).

## Principle
Grok Code (xAI's fork of [opencode](https://github.com/anomalyco/opencode)) has a **TUI gate** requiring a SuperGrok subscription. The gate is driven by `subscription_check`, which calls `GET /user?include=subscription` — **but only when a grok.com session exists** (token in `~/.grok/auth.json`). `gall` bypasses it via **`api_key_auth` mode** (no session), where the check doesn't fire → the TUI opens directly.

## Mechanism (non-persistent)
Each provider has a self-contained **profile** in `profiles/<provider>/config.toml`:
- `[endpoints] models_base_url` → provider endpoint (e.g. `https://api.kilo.ai/api/gateway`)
- `[models] default` → provider's default model
- `[model.grok-build]` → **override** redirecting internal planner calls (which use `grok-build` + `responses` backend) to a valid model on the provider via `chat_completions`, silencing the 400 error
- custom `[model.*]` entries where needed (e.g. `oc-*` for OpenCode Go)

The `gall` shim:
1. Parses the 1st arg: `or` | `kilo` | `oc` | (default).
2. Sets `GROK_HOME` → `profiles/<provider>/` (env, **process-scoped** — doesn't leak).
3. Sets `XAI_API_KEY` → provider key (from a user-level env var; overrides any global).
4. Optional: `--model X` → overrides `GROK_DEFAULT_MODEL` for this run only.
5. `exec grok "$@"` (launches the TUI inheriting the environment).

On TUI exit, the env vars vanish → the next `grok` uses the default `~/.grok` untouched. **No backup, no restore, no touching the persistent config.**

## Why per-profile `GROK_HOME` (not pure env-vars)?
Pure env-vars (`GROK_MODELS_BASE_URL` + `XAI_API_KEY` + `GROK_DEFAULT_MODEL`) can't inject the `[model.grok-build]` override (config-only). Without it, on a clean machine the 400 returns. `GROK_HOME` points to a dir with a `config.toml` that bakes in the override → **clean-machine-safe**.

## Providers (v0.0.1)
| Provider | Endpoint | Default | grok-build override → |
|---|---|---|---|
| OpenRouter (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` | `x-ai/grok-build-0.1` |
| Kilo Gateway (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` | `z-ai/glm-5.2` |
| OpenCode Go (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` (`oc-glm-52`) | `glm-5.2` |

## Edge cases handled
- **PowerShell `$env:` leaks to parent shell** → shim does save/restore (try/finally). On bash, `env VAR=val grok` is naturally scoped.
- **Missing key** → clear error with `export` instruction.
- **`grok` not on PATH** → detection + install guide.
- **Telemetry** → harness+llm+model+ts+session stamp to a local JSONL sink (`.telemetry/`, off by default).

## Technical audit
See [`audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html`](../library/audits/) (Rabelus DNA) for the gate-skip and override evidence.
