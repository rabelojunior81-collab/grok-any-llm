# Cómo funciona `gall`

> Mecanismo técnico de `grok-any-llm` (`gall`). Para contexto, ver el [README](../../README.es.md).

## Principio
Grok Code (fork de xAI de [opencode](https://github.com/anomalyco/opencode)) tiene un **gate de TUI** que exige la suscripción SuperGrok. El gate lo dispara `subscription_check`, que llama `GET /user?include=subscription` — **pero solo cuando existe una sesión grok.com** (token en `~/.grok/auth.json`). `gall` lo evita con el **modo `api_key_auth`** (sin sesión), donde el check no se dispara → el TUI abre directo.

## Mecanismo (no persistente)
Cada proveedor tiene un **perfil** auto-contenido en `profiles/<provider>/config.toml`:
- `[endpoints] models_base_url` → endpoint del proveedor (ej.: `https://api.kilo.ai/api/gateway`)
- `[models] default` → modelo default del proveedor
- `[model.grok-build]` → **override** que redirige las llamadas internas del planner (que usan `grok-build` + backend `responses`) a un modelo válido en el proveedor vía `chat_completions`, silenciando el error 400
- entradas `[model.*]` custom donde haga falta (ej.: `oc-*` para OpenCode Go)

El shim `gall`:
1. Interpreta el 1º arg: `or` | `kilo` | `oc` | (default).
2. Setea `GROK_HOME` → `profiles/<provider>/` (env, **process-scoped** — no filtra).
3. Setea `XAI_API_KEY` → key del proveedor (de una env var user-level; sobrescribe cualquier global).
4. Opcional: `--model X` → sobrescribe `GROK_DEFAULT_MODEL` solo en esta run.
5. `exec grok "$@"` (lanza el TUI heredando el entorno).

Al salir del TUI, las env vars desaparecen → el próximo `grok` usa el default `~/.grok` sin tocar. **Sin backup, sin restore, sin tocar el config persistente.**

## ¿Por qué `GROK_HOME` por perfil (y no solo env-var puro)?
Env-vars puros (`GROK_MODELS_BASE_URL` + `XAI_API_KEY` + `GROK_DEFAULT_MODEL`) no pueden inyectar el override `[model.grok-build]` (es config-only). Sin él, en una máquina limpia, el error 400 vuelve. `GROK_HOME` apunta a un dir con `config.toml` que ya incluye el override → **clean-machine-safe**.

## Proveedores (v0.0.1)
| Proveedor | Endpoint | Default | override grok-build → |
|---|---|---|---|
| OpenRouter (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` | `x-ai/grok-build-0.1` |
| Kilo Gateway (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` | `z-ai/glm-5.2` |
| OpenCode Go (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` (`oc-glm-52`) | `glm-5.2` |

## Edge cases manejados
- **PowerShell `$env:` filtra al shell padre** → shim hace save/restore (try/finally). En bash, `env VAR=val grok` es scoped natural.
- **Key ausente** → error claro con instrucción de `export`.
- **`grok` fuera del PATH** → detección + guía de instalación.
- **Telemetría** → carimbado harness+llm+model+ts+session a un sink JSONL local (`.telemetry/`, off por default).

## Auditoría técnica
Ver [`audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html`](../library/audits/) (DNA Rabelus) para la evidencia del gate-skip y del override.
