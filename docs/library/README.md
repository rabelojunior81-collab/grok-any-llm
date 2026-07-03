# Biblioteca de Conhecimentos — `docs/library/`

> Padrão de registro, consulta e entrega **agente↔agente** (agnostic-de-harness, sempre rastreável). Cada artifact relevante tem fonte `.md` + render `.html` no **DNA visual Rabelus** (template em `docs/_templates/audit.html`).

## Carimbo canônico
`<artifact>__<slug>__<YYYY-MM-DDTHHMM-03:00>__<harness>-<llm>.<ext>` — timezone Curitiba (UTC−03:00).

## Estrutura
```
docs/library/
├── research/      researches tempo-real versionadas (evidence + confidence)
├── audits/        auditorias técnicas (HTML DNA) — o padrão de entrega
├── qa/            logs QA agente↔dev (id+ts+question→decision+commit+severity)
├── adr/           ADRs (MADR) — o porquê das decisões
└── benchmarks/    benchmarks cross-provider/model/harness
```

## Convenções
- **Audits** → `.html` (DNA Rabelus) + `.md` fonte. Sempre com carimbo.
- **Research** → evidence-quoted + nível de confiança (High/Med/Low) + next-probes + versões das fontes.
- **QA** → todo gate de story passa por review adversarial (zero-findings halt); emitir HTML findings.
- **ADR** → MADR (options + pros/cons + confirmation + lifecycle).
- Arquivos legados → `.archeology/`. Nada órfão.

## Index
_(vazio em v0.0.1 — preenchido conforme as fases evoluem)_

| Data | Artifact | Fase | Carimbo |
|---|---|---|---|
| 2026-07-03 | [Baseline de rollback](../../.archeology/) | P0 | `baseline__2026-07-03T0800-03-00__opencode-glm-5.2` |
