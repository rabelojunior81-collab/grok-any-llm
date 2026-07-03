# AGENTS.md — Roteiro para Agentes (e Humanos)

> Ponto único de entrada/navegação para qualquer agente de IA (opencode, grok, codex, cursor, etc.) ou humano colaborar neste repositório. _"Antes, durante e depois — sempre."_

## Visão geral

`grok-any-llm` (alias `gall`) é um shim CLI cross-platform que lança o harness Grok Code (fork xAI do opencode) com qualquer LLM provider, de forma **não-persistente** e **sem a subscription SuperGrok**. MIT, pt-BR/EN/ES, por [Rabelus Lab](https://rabelus.xyz).

**Não confunda desenvolvimento com produto:**
- **Produto** (`src/`, `profiles/`, `landing/`) = o que o usuário final instala e usa.
- **Desenvolvimento** (governança, `docs/library/`, `.archeology/`, `.telemetry/`, skills `gsd-*`) = como _nós_ construímos o produto.

## Mapa do filesystem

```
AGENTS.md              ← você está aqui (roteamento)
README.md / .en.md / .es.md   face do projeto (pt-BR primário)
ROADMAP.md             o mapa → fases → sub-fases
CHANGELOG.md           Keep a Changelog 2.0 (fonte da verdade de release)
src/
  gall.ps1 · gall.sh   shim cross-platform (grok <provider> [--model X])
  providers/           presets/fragments por provider (or, kilo, oc)
  install.ps1 · install.sh · uninstall.*
profiles/              preset dirs por provider (config.toml auto-contido)
config/                config.toml.example (default persistente ~/.grok)
tests/                 TDD — Pester (PS) + bats (bash)
landing/               index.html (DNA Rabelus) + i18n/{pt-BR,en,es}/ + assets/
docs/
  library/             Biblioteca de Conhecimentos: researches, audits (HTML DNA),
                       qa, adr, benchmarks
  research/<fase>/     research tempo-real versionada (segurança/backend em foco)
  pt-BR/ · en/ · es/   guias por idioma
  _templates/          audit-html, spec (Kiro), adr (MADR), postmortem (SRE)
.archeology/           falhas/erros honestos (postmortems blameless) + baseline
.telemetry/            sink JSONL local (off default; carimbo harness+llm+ts)
.github/               FUNDING, ISSUE_TEMPLATE forms, PR template, CODEOWNERS,
                       workflows (ci.yml, pages.yml, codeql.yml)
```

## Convenções (obrigatórias)

### Carimbo canônico de artifacts
`<artifact>__<slug>__<YYYY-MM-DDTHHMM-03:00>__<harness>-<llm>.<ext>`

- **Timezone:** Curitiba, Paraná, Brasil (America/Sao_Paulo, **UTC−03:00**). Sempre com offset `-03:00` (não `Z`).
- Ex.: `audit__grok-build-override__2026-07-03T0800-03-00__opencode-glm-5.2.html`
- **Stamp harness-llm:** formato `<harness>-<llm>`, ex.: `opencode-glm-5.2`, `grok-grok-build`, `opencode-go-glm-5.2`.

### Arqueologia honesta
Toda falha/erro/beco-sem-saída vai em `.archeology/` (template SRE blameless postmortem em `docs/_templates/`). _Não só acertos._ É matéria-prima do meta-processo evolutivo.

### Telemetria (provisionada, off por default)
Sink JSONL em `.telemetry/`: `{ts, harness, llm, model, session, outcome, latency_ms, tokens}`. Carimbo rastreável agnostic-de-harness. RAW material para roteamento proprietário futuro (ROADMAP P6).

### Poda & nomenclatura
Filesystem sempre prunado e organizado. Nada órfão. Arquivos legados → `.archeology/`. Nomeclatura semântica + carimbo.

## Workflow de desenvolvimento (BMAD-style via skills `gsd-*`)

Engine: **GSD v1.42.3** (`get-shit-done-cc`, perfil `full`). Paradigmas: **BMAD V6 · Spec-Driven (Kiro 3-file) · TDD · Documentação Holística**.

Por fase:
1. **Research tempo-real** (`gsd-phase-researcher` / `gsd-research-synthesizer`) — web, versões atuais, foco segurança/backend → `docs/research/<fase>/`.
2. **SPEC** (`gsd-spec-phase`) — `requirements.md` / `design.md` / `tasks.md` (Kiro). WHAT antes de HOW.
3. **Plano** (`gsd-plan-phase`) — `PLAN.md` com sub-fases por complexidade.
4. **Execução** (`gsd-execute-phase`) — commits atômicos Conventional Commits (`feat:`, `fix:`, `docs:`).
5. **Verificação** (`gsd-verify-work`) — UAT conversacional.
6. **Review adversarial** (`gsd-code-review` / `gsd-audit-fix`) — zero-findings halt; severity HIGH/MED/LOW; emitir **HTML findings report** (DNA Rabelus) em `docs/library/`.
7. **Arqueologia** (`gsd-forensics`) se houver incidente — postmortem blameless.
8. **Docs** (`gsd-docs-update`) — holístico, verificado contra o codebase.

Cada artifact relevante tem fonte `.md` + render `.html` no **DNA visual Rabelus** (o padrão de entrega agente↔agente, como o Killian pratica). Templates em `docs/_templates/`.

## Build & test

```powershell
# PowerShell (Windows)
Invoke-Pester tests/ -Output Detailed          # testes PS
& src/gall.ps1 or --dry-run                     # smoke do shim
```
```bash
# bash (macOS/Linux)
bats tests/                                     # testes bash
shellcheck src/gall.sh src/install.sh           # lint bash
```
CI (`.github/workflows/ci.yml`): matrix ubuntu/windows/macos — Pester + bats + shellcheck + PSScriptAnalyzer + html-validate.

## Security

- Nunca commitear keys. As keys vivem em env vars user-level (fora do repo).
- Profiles referenciam `env_key` (OPENROUTER_API_KEY, KILO_API_KEY, OPENCODE_GO_API_KEY), nunca `api_key` hardcoded.
- Reportar vulns via [SECURITY.md](./SECURITY.md) (canal privado).

## Roteamento rápido
- Quero entender o produto → [README.md](./README.md)
- Quero o mapa de fases → [ROADMAP.md](./ROADMAP.md)
- Quero construir uma feature → `gsd-spec-phase` → SPEC em `docs/`
- Quero ver decisões → `docs/library/adr/` (MADR)
- Quero ver auditorias/research → `docs/library/` (HTML DNA)
- Quero ver falhas/lições → `.archeology/`
