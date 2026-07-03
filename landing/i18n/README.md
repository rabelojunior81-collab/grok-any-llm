# i18n — grok-any-llm landing

Locales padronizados: `pt-BR` (primario), `en`, `es`. Extensivel (fr/de/ja depois).

A landing (`index.html`) carrega as strings inline (zero-dependencia, funciona em file:// e GH Pages). Para migrar pra JSON externo (fetch), mova os blocos de `I18N` em `index.html` para `i18n/<locale>.json` e faca fetch em runtime (GH Pages serve via https). Estrutura de dirs ja pronta.
