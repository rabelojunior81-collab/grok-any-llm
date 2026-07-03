# ROADMAP — grok-any-llm (`gall`)

> O mapa. Cada fase tem objetivo + sub-fases por complexidade. Referência para os PLANs. v0.0.1 = P0 concluído.

Legenda de status: ✅ feito · 🚧 em andamento · ⏳ planejado · 🔮 horizonte

---

## P0 — Fundação & Governança ✅
Estabelecer o projeto, governança, repo público, landing, CI.
- ✅ 0.1 `git init` + `gh repo create` (público) + redirect `gall`
- ✅ 0.2 Governança raiz: AGENTS.md, READMEs (pt/en/es), LICENSE, CHANGELOG, CONTRIBUTING, COC, SECURITY
- ✅ 0.3 `.github/` (FUNDING, ISSUE_TEMPLATE forms, PR template, CODEOWNERS, workflows ci/pages/codeql)
- ✅ 0.4 `docs/` (library, _templates, pt-BR/en/es) + `.archeology/` + `.telemetry/`
- ✅ 0.5 Landing DNA Rabelus (responsiva, i18n pt/en/es) + GH Pages
- ✅ 0.6 Tag `v0.0.1` + GitHub Release + baseline de rollback

## P1 — Shim core (MVP) ⏳
O `gall` funcional cross-platform, com perfis auto-contidos.
- ⏳ 1.1 Schema de perfil por provider (`profiles/<p>/config.toml`)
- ⏳ 1.2 Shim PowerShell `src/gall.ps1` (save/restore env, `GROK_HOME` por perfil)
- ⏳ 1.3 Espelho bash `src/gall.sh`
- ⏳ 1.4 Override `[model.grok-build]` por perfil (silencia 400)
- ⏳ 1.5 Validação de key do provider (erro claro se ausente)
- ⏳ 1.6 `--model X` override pontual
- ⏳ 1.7 `install.ps1` / `install.sh` / `uninstall.*`
- ⏳ 1.8 TDD: Pester (PS) + bats (bash)
- ⏳ 1.9 Verificação empírica das 3 pendências (GROK_HOME standalone, /zen/go/v1/models, save/restore PS)

## P2 — Landing (aprimoramento) ⏳
Landing 100% polida + deploy contínuo.
- ⏳ 2.1 Refinar `landing/index.html` (DNA Rabelus, cantos vivos)
- ⏳ 2.2 Responsividade multi-device (clamp, grid, media queries)
- ⏳ 2.3 i18n pt-BR/en/es (locale switcher)
- ⏳ 2.4 Demo terminal animado (`rabelus@lab:~$ grok kilo`)
- ⏳ 2.5 Deploy GH Pages (automático via action)
- 🔮 2.6 CNAME/redirecionamento rabelus.xyz (fase final manual do Pai)

## P3 — Expansão de providers + research tempo-real ⏳
- ⏳ 3.1 Research versionada de novos providers (foco segurança/backend)
- ⏳ 3.2 Novos presets (ex.: Together, Groq, DeepSeek, Anthropic direto, Ollama local)
- ⏳ 3.3 Cache/validação de `model-list` por provider
- ⏳ 3.4 `gall list` (lista modelos do provider ativo)

## P4 — TUI instalador `gall` 🔮
Caminho pra virar harness.
- 🔮 4.1 `gall install` / `gall add <provider>` / `gall use <provider>`
- 🔮 4.2 TUI de seleção de provider/modelo
- 🔮 4.3 Auto-detecção de keys e do binário `grok`

## P5 — Telemetria & benchmark 🔮
- 🔮 5.1 Sink JSONL `.telemetry/` ativo (harness+llm+model+ts+session+outcome+latência+tokens)
- 🔮 5.2 Dashboards audit-DNA (HTML) cross-provider/model
- 🔮 5.3 Benchmarks automatizados (custo, latência, qualidade)

## P6 — Roteamento proprietário (horizonte) 🔮
- 🔮 6.1 Raw telemetry → inteligência de roteamento cross-harness/llm
- 🔮 6.2 Routing engine (decisão de provider/modelo por tarefa/custo/latência)

---

_Toda fase segue: research tempo-real → SPEC (Kiro) → PLAN → TDD → execute → verify → review adversarial (HTML) → arqueologia se incidente → docs. Carimbo em Curitiba (UTC−03:00)._
