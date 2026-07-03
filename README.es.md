# grok-any-llm · `gall`

> Usa el harness de **Grok Code** (xAI) con **cualquier proveedor de LLM** — OpenRouter, Kilo Gateway, OpenCode Go — de forma **no persistente**, **sin la suscripción SuperGrok**. _AI-Born, not AI-assisted._

[![License: MIT](https://img.shields.io/badge/License-MIT-8fb054.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/version-0.0.1-ff6b35.svg)](./CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-00d4ff.svg)](#plataformas)
[![by Rabelus Lab](https://img.shields.io/badge/by-Rabelus%20Lab-1e2612.svg)](https://rabelus.xyz)

**Idiomas:** [Português (BR)](./README.md) · [English](./README.en.md) · [Español](./README.es.md)

## Qué es

`grok-any-llm` (alias **`gall`**) es un **shim CLI multiplataforma** (PowerShell + bash) que lanza el harness **Grok Code** — el agente de coding de xAI, fork de [opencode](https://github.com/anomalyco/opencode) — apuntado al proveedor de inferencia que elijas:

```bash
grok kilo                         # usa Kilo Gateway
grok or                           # usa OpenRouter
grok oc                           # usa OpenCode Go (GLM 5.2)
grok kilo --model z-ai/glm-5.2    # sobrescribe el modelo solo en esta sesión
grok                              # vuelve al default persistente (~/.grok)
```

Al salir del TUI, las variables de entorno desaparecen — la app vuelve a su estado default. **Sin backup, sin `--restore`, sin tocar el config persistente.** Es el patrón de [`ollama launch`](https://docs.ollama.com) en su variante no persistente (env-var), pero más limpio.

## Por qué existe

El harness de Grok Code es excelente, pero su gate de TUI requiere la suscripción **SuperGrok**. `gall` lo evita usando el **modo `api_key_auth`** (sin sesión), que salta el `subscription_check` — manteniendo 100% del harness (agentes, skills, tools, edición) sobre cualquier proveedor que ya tengas.

- ✅ **Sin suscripción** — funciona con keys que ya posees (OpenRouter, Kilo, OpenCode Go).
- ✅ **No persistente** — `GROK_HOME` por perfil (process-scoped); salir del TUI → vuelve al default.
- ✅ **Clean-machine-safe** — cada perfil es auto-contenido (incluye el override de `grok-build`, silenciando el error 400 interno).
- ✅ **Multiplataforma** — PowerShell (Windows) + bash (macOS/Linux).
- ✅ **Trazable** — telemetría local provisionada (carimbado harness+llm+timestamp) para benchmark constante.

## Instalación

```powershell
irm https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.ps1 | iex
```
```bash
curl -fsSL https://raw.githubusercontent.com/rabelojunior81-collab/grok-any-llm/main/src/install.sh | bash
```

Luego define tus keys una vez (ámbito de usuario):

```bash
export OPENROUTER_API_KEY="sk-or-..."
export KILO_API_KEY="eyJhbGc..."
export OPENCODE_GO_API_KEY="sk-..."
```

> Requiere el binario `grok` (`winget install xAI.GrokBuild` en Windows, o `curl -fsSL https://x.ai/cli/install.sh | bash`).

## Cómo funciona

Cada proveedor tiene un **perfil** auto-contenido en `profiles/<provider>/config.toml` (con `[endpoints] models_base_url`, `[models] default`, el override `[model.grok-build]`, y entradas custom donde hace falta). El shim `gall` setea `GROK_HOME` a ese perfil + la `XAI_API_KEY` del proveedor — solo para ese proceso — y lanza `grok`. Ver [CÓMO-FUNCIONA](./docs/es/como-funciona.md) y la [auditoría técnica](./docs/library/audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html).

## Proveedores (v0.0.1)

| Proveedor | Endpoint | Modelo default |
|---|---|---|
| **OpenRouter** (`or`) | `https://openrouter.ai/api/v1` | `x-ai/grok-build-0.1` |
| **Kilo Gateway** (`kilo`) | `https://api.kilo.ai/api/gateway` | `z-ai/glm-5.2` |
| **OpenCode Go** (`oc`) | `https://opencode.ai/zen/go/v1` | `glm-5.2` |

## Roadmap

Ver [ROADMAP.md](./ROADMAP.md). Resumen: P1 shim core MVP → P2 landing → P3 expansión de proveedores → P4 TUI instalador `gall` → P5 telemetría & benchmark → P6 ruteo propietario.

## Gobernanza de desarrollo

Este proyecto sigue **BMAD-style / Spec-Driven / TDD / Documentación Holística / "antes, durante y después — siempre"**. Ver [AGENTS.md](./AGENTS.md), la [Biblioteca de Conocimientos](./docs/library), y la [arqueología honesta](./.archeology) (incluyendo fallos).

## Fundaciones open-source — honores

- **[opencode](https://github.com/anomalyco/opencode)** — _"The open source coding agent."_ (MIT, 182k★) · [opencode.ai](https://opencode.ai) · [docs](https://opencode.ai/docs) — el harness-base del que deriva Grok Code, y del que este proyecto aprendió el mecanismo de proveedores.
- **[Anomaly](https://anoma.ly)** — _"For whatever you build."_ — la empresa detrás de opencode, y sus proyectos hermanos: **[sst](https://github.com/anomalyco/sst)**, **[opentui](https://github.com/anomalyco/opentui)**, y **[models.dev](https://github.com/anomalyco/models.dev)**.
- **Inspiración personal:** _Dax_, fundador/CEO de Anomaly — referência de construcción AI-first, en soberanía y autonomía.

## Contribuir

Colaborativo, **bajo aprobación** (PRs bienvenidos; rama `main` protegida). Ver [CONTRIBUTING.md](./CONTRIBUTING.md) y el [Código de Conducta](./CODE_OF_CONDUCT.md).

## Licencia

[MIT](./LICENSE) © 2026 Adilson Rabelo Junior / [Rabelus Lab](https://rabelus.xyz).

---

**by Rabelus Lab** · AI-Born, not AI-assisted · Curitiba, Brasil · 2024–2026
