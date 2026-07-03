<!-- PR Template — grok-any-llm -->

## Resumo
<!-- O que este PR faz, em 1-3 linhas. -->

## Motivação
<!-- Por quê? Link da issue (Closes #N) ou contexto. -->

## Mudanças
<!-- Bullet list das mudanças principais. -->

## Tipo de mudança
- [ ] feat (nova feature)
- [ ] fix (correção de bug)
- [ ] docs (documentação)
- [ ] refactor (refatoração)
- [ ] test (testes)
- [ ] chore/ci (infra)

## Testes rodados
- [ ] `Invoke-Pester tests/` (Windows)
- [ ] `bats tests/` (macOS/Linux)
- [ ] `shellcheck src/*.sh`
- [ ] `html-validate landing/`
- [ ] Smoke manual: `grok or` / `grok kilo` / `grok oc` funcionando

## Checklist
- [ ] Commits seguem Conventional Commits + **sign-off (DCO)** (`git commit -s`)
- [ ] [CHANGELOG.md](../CHANGELOG.md) atualizado (seção `[Unreleased]`)
- [ ] Nenhuma key/segredo commitado (keys só em env vars)
- [ ] Strings user-facing nos 3 locales (pt-BR, en, es) — se aplicável
- [ ] Carimbo de artifacts em timezone Curitiba (UTC−03:00) — se aplicável
- [ ] Falhas/becos documentados em `.archeology/` — se aplicável
