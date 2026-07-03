# Como funciona o `gall`

> Mecanismo técnico do `grok-any-llm` (`gall`). Para o contexto, veja o [README](../../README.md).

## Princípio
O Grok Code (fork xAI do [opencode](https://github.com/anomalyco/opencode)) tem um **gate de TUI** que exige a subscription SuperGrok. Esse gate é acionado pelo `subscription_check`, que chama `GET /user?include=subscription` — **mas só quando há uma sessão grok.com** (token em `~/.grok/auth.json`). O `gall` contorna isso usando o **modo `api_key_auth`** (sem sessão), onde o check não dispara → o TUI abre direto.

## Mecanismo (não-persistente)
Cada provider tem um **perfil** auto-contido em `profiles/<provider>/config.toml`:
- `[endpoints] models_base_url` → endpoint do provider (ex.: `https://api.kilo.ai/api/gateway`)
- `[models] default` → modelo padrão daquele provider
- `[model.grok-build]` → **override** que redireciona as chamadas internas do planner (que usam `grok-build` + backend `responses`) para um modelo válido no provider via `chat_completions`, silenciando o erro 400
- entries `[model.*]` custom onde preciso (ex.: `oc-*` no perfil OpenCode Go)

O shim `gall` faz:
1. Interpreta o 1º arg: `or` | `kilo` | `oc` | (default).
2. Seta `GROK_HOME` → `profiles/<provider>/` (env, **process-scoped** — não vaza).
3. Seta `XAI_API_KEY` → key do provider (lida de env var user-level; sobrescreve qualquer global).
4. Opcional: `--model X` → sobrescreve `GROK_DEFAULT_MODEL` só nesta run.
5. `exec grok "$@"` (lança o TUI/herdando o ambiente).

Ao sair do TUI, as env vars somem → o próximo `grok` usa o default `~/.grok` intocado. **Sem backup, sem restore, sem mexer no config persistente.**

## Por que `GROK_HOME` por perfil (e não só env-var puro)?
Env-vars puros (`GROK_MODELS_BASE_URL` + `XAI_API_KEY` + `GROK_DEFAULT_MODEL`) não conseguem injetar o override `[model.grok-build]` (é config-only). Sem ele, numa máquina limpa, o erro 400 retorna. O `GROK_HOME` aponta pra um dir com `config.toml` que já embute o override → **clean-machine-safe**.

## Providers (v0.0.1)
| Provider | Endpoint | Default | Override grok-build → |
|---|---|---|---|
| OpenRouter (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` | `x-ai/grok-build-0.1` (chat_completions) |
| Kilo Gateway (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` | `z-ai/glm-5.2` |
| OpenCode Go (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` (via `oc-glm-52`) | `glm-5.2` |

## Edge cases tratados
- **PowerShell `$env:` vaza pro shell pai** → shim faz save/restore (try/finally). No bash, `env VAR=val grok` é scoped natural.
- **Key ausente** → erro claro com instrução de `export`.
- **`grok` fora do PATH** → detecção + guia de instalação.
- **Telemetria** → carimbo harness+llm+model+ts+session em sink JSONL local (`.telemetry/`, off default).

## Auditoria técnica
Ver [`audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html`](../library/audits/) (DNA Rabelus) para a evidência do gate-skip e do override.
