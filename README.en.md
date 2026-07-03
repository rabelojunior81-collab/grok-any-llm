# grok-any-llm · `gall`

> Run the **Grok Code** harness (xAI) with **any LLM provider** — OpenRouter, Kilo Gateway, OpenCode Go — **non-persistently**, **without the SuperGrok subscription**. _AI-Born, not AI-assisted._

[![License: MIT](https://img.shields.io/badge/License-MIT-8fb054.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/version-0.0.1-ff6b35.svg)](./CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-00d4ff.svg)](#platforms)
[![by Rabelus Lab](https://img.shields.io/badge/by-Rabelus%20Lab-1e2612.svg)](https://rabelus.xyz)

**Languages:** [Português (BR)](./README.md) · [English](./README.en.md) · [Español](./README.es.md)

## What it is

`grok-any-llm` (alias **`gall`**) is a **cross-platform CLI shim** (PowerShell + bash) that launches the **Grok Code** harness — xAI's coding agent, a fork of [opencode](https://github.com/anomalyco/opencode) — pointed at an inference provider of your choice:

```bash
grok kilo                         # use Kilo Gateway
grok or                           # use OpenRouter
grok oc                           # use OpenCode Go (GLM 5.2)
grok kilo --model z-ai/glm-5.2    # override the model for this session only
grok                              # back to the persistent default (~/.grok)
```

When you exit the TUI, the environment variables vanish — the app returns to its default state. **No backup, no `--restore`, no touching the persistent config.** It's the [`ollama launch`](https://docs.ollama.com) pattern in its non-persistent (env-var) variant, but cleaner.

## Why it exists

The Grok Code harness is excellent, but its TUI gate requires a **SuperGrok** subscription. `gall` bypasses this using **`api_key_auth` mode** (no session), which skips the `subscription_check` — keeping 100% of the harness (agents, skills, tools, editing) running on any provider you already have.

- ✅ **No subscription** — works with keys you already own (OpenRouter, Kilo, OpenCode Go).
- ✅ **Non-persistent** — per-profile `GROK_HOME` (process-scoped); exit TUI → back to default.
- ✅ **Clean-machine-safe** — each profile is self-contained (bakes in the `grok-build` override, silencing the internal 400).
- ✅ **Cross-platform** — PowerShell (Windows) + bash (macOS/Linux).
- ✅ **Traceable** — local telemetry provisioned (harness+llm+timestamp stamp) for constant benchmarking.

## Install

```powershell
irm https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.ps1 | iex
```
```bash
curl -fsSL https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.sh | bash
```

Then set your keys once (user scope):

```bash
export OPENROUTER_API_KEY="sk-or-..."
export KILO_API_KEY="eyJhbGc..."
export OPENCODE_GO_API_KEY="sk-..."
```

> Requires the `grok` binary (`winget install xAI.GrokBuild` on Windows, or `curl -fsSL https://x.ai/cli/install.sh | bash`).

## How it works

Each provider has a self-contained **profile** in `profiles/<provider>/config.toml` (with `[endpoints] models_base_url`, `[models] default`, the `[model.grok-build]` override, and custom entries where needed). The `gall` shim sets `GROK_HOME` to that profile + the provider's `XAI_API_KEY` — for that process only — and launches `grok`. See [HOW-IT-WORKS](./docs/en/how-it-works.md) and the [technical audit](./docs/library/audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html).

## Providers (v0.0.1)

| Provider | Endpoint | Default model |
|---|---|---|
| **OpenRouter** (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` |
| **Kilo Gateway** (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` |
| **OpenCode Go** (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` |

## Roadmap

See [ROADMAP.md](./ROADMAP.md). Summary: P1 shim core MVP → P2 landing → P3 provider expansion → P4 `gall` installer TUI → P5 telemetry & benchmarking → P6 proprietary routing.

## Development governance

This project follows **BMAD-style / Spec-Driven / TDD / Holistic Documentation / "before, during, and after — always"**. See [AGENTS.md](./AGENTS.md), the [Knowledge Library](./docs/library), and the honest [archeology](./.archeology) (including failures).

## Open-source foundations — honors

- **[opencode](https://github.com/anomalyco/opencode)** — _"The open source coding agent."_ (MIT, 182k★) · [opencode.ai](https://opencode.ai) · [docs](https://opencode.ai/docs) — the base harness from which Grok Code derives, and from which this project learned the provider mechanism.
- **[Anomaly](https://anoma.ly)** — _"For whatever you build."_ — the company behind opencode, and its sister projects: **[sst](https://github.com/anomalyco/sst)**, **[opentui](https://github.com/anomalyco/opentui)**, and **[models.dev](https://github.com/anomalyco/models.dev)**.
- **Personal inspiration:** _Dax_, founder/CEO of Anomaly — a reference for AI-first, sovereign, autonomous building.

## Contributing

Collaborative, **under approval** (PRs welcome; `main` branch protected). See [CONTRIBUTING.md](./CONTRIBUTING.md) and the [Code of Conduct](./CODE_OF_CONDUCT.md).

## License

[MIT](./LICENSE) © 2026 Adilson Rabelo Junior / [Rabelus Lab](https://rabelus.xyz).

---

**by Rabelus Lab** · AI-Born, not AI-assisted · Curitiba, Brazil · 2024–2026
