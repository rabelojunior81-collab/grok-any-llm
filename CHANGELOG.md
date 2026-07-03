# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog 2.0.0](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Perfis de provider adicionais (placeholder P3).

## [0.0.1] - 2026-07-03

### Added
- Projeto `grok-any-llm` (alias `gall`) estabelecido — shim CLI cross-platform (PowerShell + bash) que lança o harness Grok Code com qualquer LLM provider, não-persistente, sem a subscription SuperGrok.
- Governança: `AGENTS.md` (roteamento), `ROADMAP.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1), `SECURITY.md`.
- READMEs trilíngues (pt-BR primário, EN, ES) com i18n estruturado extensível.
- `docs/library/` (Biblioteca de Conhecimentos) + `docs/_templates/` (audit-HTML DNA Rabelus, SPEC Kiro, ADR MADR, postmortem SRE).
- `docs/research/` para research tempo-real versionada por fase.
- `.archeology/` (arqueologia honesta, blameless) + `.telemetry/` (sink JSONL provisionado, off por default).
- `.github/`: `FUNDING.yml`, `ISSUE_TEMPLATE/` (Forms), `PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`, workflows `ci.yml` (matrix ubuntu/win/mac — Pester + bats + shellcheck + PSScriptAnalyzer + html-validate), `pages.yml`, `codeql.yml`.
- Esboço do shim `src/gall.ps1` + `src/gall.sh` + `src/install.*` + `profiles/` (or, kilo, oc) + `tests/`.
- `landing/index.html` (DNA visual Rabelus Lab, responsivo multi-device) + `landing/i18n/{pt-BR,en,es}/`.
- Honras às fundações open-source: [opencode](https://github.com/anomalyco/opencode) (Anomaly) + projetos irmãos (sst, opentui, models.dev) + menção pessoal ao CEO Dax.
- Tag `v0.0.1` + GitHub Release.
- Baseline de rollback em `.archeology/`.

[Unreleased]: https://github.com/rabelojunior81-collab/grok-any-llm/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/rabelojunior81-collab/grok-any-llm/releases/tag/v0.0.1
