# grok-any-llm · `gall`

> Use o harness do **Grok Code** (xAI) com **qualquer LLM provider** — OpenRouter, Kilo Gateway, OpenCode Go — de forma **não-persistente**, **sem a subscription SuperGrok**. _AI-Born, not AI-assisted._

[![License: MIT](https://img.shields.io/badge/License-MIT-8fb054.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/version-0.0.1-ff6b35.svg)](./CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-00d4ff.svg)](#plataformas)
[![Status](https://img.shields.io/badge/status-alpha%20%7C%20experimental-ffd700.svg)](./ROADMAP.md)
[![by Rabelus Lab](https://img.shields.io/badge/by-Rabelus%20Lab-1e2612.svg)](https://rabelus.xyz)

**Idiomas:** [Português (BR)](./README.md) · [English](./README.en.md) · [Español](./README.es.md)

---

## O que é

`grok-any-llm` (alias **`gall`**) é um **shim CLI cross-platform** (PowerShell + bash) que lança o harness **Grok Code** — o agente de coding da xAI, fork do [opencode](https://github.com/anomalyco/opencode) — configurado pontualmente para um provider de inferência à sua escolha. Você alterna de provider com um comando curto:

```bash
grok kilo                         # usa Kilo Gateway
grok or                           # usa OpenRouter
grok oc                           # usa OpenCode Go (GLM 5.2)
grok kilo --model z-ai/glm-5.2    # sobrescreve o modelo só nesta sessão
grok                               # volta ao default persistente (~/.grok)
```

Ao sair do TUI, as variáveis de ambiente somem — o app volta ao estado padrão. **Sem backup, sem `--restore`, sem mexer no config persistente.** É o padrão do [`ollama launch`](https://docs.ollama.com) na variante não-persistente (env-var), porém mais limpa.

## Por que existe

O Grok Code é um harness excelente, mas seu gate de TUI exige a subscription **SuperGrok**. O `gall` contorna isso usando o **modo `api_key_auth`** (sem sessão), que pula o `subscription_check` — mantendo 100% do harness (agentes, skills, tools, edição) rodando sobre qualquer provider que você já tenha.

- ✅ **Sem subscription** — funciona com keys que você já possui (OpenRouter, Kilo, OpenCode Go).
- ✅ **Não-persistente** — `GROK_HOME` por perfil (process-scoped); sai do TUI → volta ao default.
- ✅ **Clean-machine-safe** — cada perfil é auto-contido (já embute o override do `grok-build`, silenciando o erro 400 interno).
- ✅ **Cross-platform** — PowerShell (Windows) + bash (macOS/Linux).
- ✅ **Rastreável** — telemetria local provisionada (carimbo harness+llm+timestamp) para benchmark constante.

## Instalação

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.ps1 | iex
```
```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.sh | bash
```

Depois defina suas keys (uma vez, em escopo de usuário):

```bash
export OPENROUTER_API_KEY="sk-or-..."
export KILO_API_KEY="eyJhbGc..."          # Kilo Gateway
export OPENCODE_GO_API_KEY="sk-..."        # OpenCode Go
```

> Requer o binário `grok` instalado (`winget install xAI.GrokBuild` no Windows, ou `curl -fsSL https://x.ai/cli/install.sh | bash`).

## Como funciona

Cada provider tem um **perfil** auto-contido em `profiles/<provider>/config.toml` (com `[endpoints] models_base_url`, `[models] default`, o override `[model.grok-build]`, e entries custom onde preciso). O shim `gall` seta `GROK_HOME` para esse perfil + a `XAI_API_KEY` do provider — somente para aquele processo — e lança `grok`. Veja [COMO-FUNCIONA](./docs/pt-BR/como-funciona.md) e a [auditoria técnica](./docs/library/audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html).

## Providers suportados (v0.0.1)

| Provider | Endpoint | Default model |
|---|---|---|
| **OpenRouter** (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` |
| **Kilo Gateway** (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` |
| **OpenCode Go** (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` |

## Roadmap

Ver [ROADMAP.md](./ROADMAP.md). Resumo: P1 shim core MVP → P2 landing → P3 expansão de providers → P4 TUI instalador `gall` → P5 telemetria & benchmark → P6 roteamento proprietário.

## Governança de desenvolvimento

Este projeto segue **BMAD-style / Spec-Driven / TDD / Documentação Holística / "antes, durante e depois — sempre"**. Veja [AGENTS.md](./AGENTS.md) para o roteamento completo, [docs/library/](./docs/library) para a Biblioteca de Conhecimentos, e [.archeology/](./.archeology) para a arqueologia honesta (incluindo falhas).

## Fundações open-source — honras

Este projeto não existiria sem estas fundações:

- **[opencode](https://github.com/anomalyco/opencode)** — _"The open source coding agent."_ (MIT, 182k★) · [opencode.ai](https://opencode.ai) · [docs](https://opencode.ai/docs) — o harness-base de onde o Grok Code deriva, e de onde este projeto aprendeu o mecanismo de providers.
- **[Anomaly](https://anoma.ly)** — _"For whatever you build."_ — a empresa por trás do opencode, e seus projetos irmãos: **[sst](https://github.com/anomalyco/sst)** (full-stack na sua infra), **[opentui](https://github.com/anomalyco/opentui)** (TUIs), e **[models.dev](https://github.com/anomalyco/models.dev)** (banco aberto de modelos de IA).
- **Inspiração pessoal:** _Dax_, fundador/CEO da Anomaly — referência de construção AI-first, em soberania e autonomia.

## Contribuindo

Colaborativo, **sob aprovação** (PRs bem-vindos; branch `main` protegida). Veja [CONTRIBUTING.md](./CONTRIBUTING.md) e o [Código de Conduta](./CODE_OF_CONDUCT.md).

## Licença

[MIT](./LICENSE) © 2026 Adilson Rabelo Junior / [Rabelus Lab](https://rabelus.xyz).

---

**by Rabelus Lab** · AI-Born, not AI-assisted · _Construindo com IA. Construindo IA._ · Curitiba, Brasil · 2024–2026
