# Contribuindo com o grok-any-llm

Obrigado por considerar contribuir! Este é um projeto **colaborativo, sob aprovação** — PRs são bem-vindos e revisados.

## Antes de começar
- Leia o [AGENTS.md](./AGENTS.md) (roteamento) e o [ROADMAP.md](./ROADMAP.md).
- Abra uma _issue_ para discutir mudanças grandes antes de codar (evita retrabalho).
- Respeite o [Código de Conduta](./CODE_OF_CONDUCT.md).

## Setup
```bash
git clone https://github.com/rabelojunior81-collab/grok-any-llm.git
cd grok-any-llm
```
Requer: `git`, `grok` (binário), PowerShell 7+ _ou_ bash, e as keys de provider em env vars (ver [README](./README.md)).

## Fluxo de PR (branch `main` protegida)
1. Crie um branch a partir de `main`: `feat/<slug>`, `fix/<slug>`, `docs/<slug>`.
2. Commits atômicos no padrão **Conventional Commits**: `feat:`, `fix:`, `docs:`, `test:`, `chore:`, `refactor:`.
3. **Sign-off** (DCO): `git commit -s` — atesta autoria.
4. Garanta: `Invoke-Pester tests/` (Windows) e `bats tests/` + `shellcheck src/*.sh` (macOS/Linux) passando; `html-validate landing/` sem erros.
5. Atualize o [CHANGELOG.md](./CHANGELOG.md) (seção `[Unreleased]`).
6. Abra o PR preenchendo o [template](./.github/PULL_REQUEST_TEMPLATE.md).
7. Os checks de CI (matrix ubuntu/win/mac) + CodeQL devem passar; um membro aprova.

## Workflow de desenvolvimento (BMAD-style via GSD)
Toda feature/non-trivial change segue: **research → SPEC (Kiro 3-file) → PLAN → TDD → execute → verify → review adversarial → docs**. Artifacts em `docs/` e `docs/library/` (HTML DNA). Veja [AGENTS.md](./AGENTS.md).

## Convenções
- **Carimbo de artifacts:** `<artifact>__<slug>__<YYYY-MM-DDTHHMM-03:00>__<harness>-<llm>.<ext>` (timezone Curitiba, UTC−03:00).
- **Arqueologia:** falhas/erros vão em `.archeology/` (postmortem blameless). _Não só acertos._
- **Keys:** nunca commitear. Profiles usam `env_key`, nunca `api_key` hardcoded.
- **i18n:** toda string user-facing nos 3 locales (pt-BR, en, es).

## Reportar bugs / sugerir features
Use os [Issue Forms](./.github/ISSUE_TEMPLATE/). Inclua: ambiente, provider, modelo, passos pra reproduzir, logs (sem keys).

## Contato
[rabelo.work@gmail.com](mailto:rabelo.work@gmail.com) · [github.com/rabelojunior81-collab](https://github.com/rabelojunior81-collab)

— _by Rabelus Lab_
