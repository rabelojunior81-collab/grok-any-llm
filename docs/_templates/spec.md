# SPEC — {{slug}}

> Spec-Driven (Kiro 3-file). WHAT antes de HOW. Carimbo: `spec__{{slug}}__{{YYYY-MM-DDTHHMM-03:00}}__{{harness}}-{{llm}}`

## requirements.md
### Objetivo
{{o que esta fase/feature entrega, em 1-2 linhas}}

### Requisitos (EARS / user stories)
- **R1** — {{quando X, o sistema deve Y}}.
- **R2** — ...

### Fora de escopo
- {{...}}

### Critérios de aceitação (UAT)
- [ ] {{...}}

## design.md
### Arquitetura
{{diagrama/seq, decisões, api_backend, env vars envolvidas}}

### Trade-offs / alternativas
| Opção | Pró | Contra |
|---|---|---|

### Estratégia de erro/teste
{{...}}

## tasks.md
Tarefas em **waves** de dependência (paralelo dentro da wave).
### Wave 1
- [ ] T1.1 {{...}}
- [ ] T1.2 {{...}}
### Wave 2 (deps: W1)
- [ ] T2.1 {{...}}

---
_Artifacts de verificação: HTML findings report (DNA) em `docs/library/` após review adversarial._
