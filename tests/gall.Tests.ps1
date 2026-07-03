#Requires -Version 7
# gall.Tests.ps1 — TDD Pester para o shim gall.ps1
# License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab
BeforeAll {
  $script:gall = Join-Path $PSScriptRoot '..\src\gall.ps1' | Resolve-Path
  $script:fakeKey = 'sk-fake-test-key-1234567890'
}

Describe 'gall.ps1 arg parsing' {
  It 'reconhece provider or em --dry-run' {
    $env:OPENROUTER_API_KEY = $script:fakeKey
    $out = & $script:gall or --dry-run 2>&1
    $out | Should -Match 'provider=or'
    $out | Should -Match 'GROK_HOME'
    $out | Should -Match 'sk-fak\.\.\.'   # key mascarada (primeiros 6)
  }

  It 'reconhece --model X em --dry-run' {
    $env:OPENROUTER_API_KEY = $script:fakeKey
    $out = & $script:gall kilo --model z-ai/glm-5.2 --dry-run 2>&1
    # kilo precisa de KILO_API_KEY
    $env:KILO_API_KEY = $script:fakeKey
    $out = & $script:gall kilo --model z-ai/glm-5.2 --dry-run 2>&1
    $out | Should -Match 'provider=kilo'
    $out | Should -Match 'GROK_DEFAULT_MODEL=z-ai/glm-5.2'
  }

  It 'erro claro quando key do provider ausente' {
    Remove-Item Env:\OPENCODE_GO_API_KEY -ErrorAction SilentlyContinue
    # garantir que nao ha heranca user-level no processo de teste
    $out = & $script:gall oc --dry-run 2>&1
        $LASTEXITCODE | Should -Be 3
    ($out -join ' ') | Should -Match 'OPENCODE_GO_API_KEY'
  }
}

Describe 'gall.ps1 nao-persistencia' {
  It 'restaura GROK_HOME/XAI_API_KEY apos dry-run (save/restore)' {
    $env:GROK_HOME = 'BEFORE'
    $env:XAI_API_KEY = 'BEFOREKEY'
    $env:OPENROUTER_API_KEY = $script:fakeKey
    & $script:gall or --dry-run | Out-Null
    $env:GROK_HOME | Should -Be 'BEFORE'
    $env:XAI_API_KEY | Should -Be 'BEFOREKEY'
  }
}
