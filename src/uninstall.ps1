#Requires -Version 7
<# uninstall.ps1 — remove o grok-any-llm (gall) do Windows. License: MIT. #>
[CmdletBinding()] param()
$ErrorActionPreference = 'SilentlyContinue'

$dest = Join-Path $env:USERPROFILE '.grok-any-llm'
$profileFile = $PROFILE.CurrentUserCurrentHost

# remove dir de instalacao
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force; Write-Host "[gall] removido $dest" -ForegroundColor Green }

# remove bloco do profile
if (Test-Path $profileFile) {
  $c = Get-Content $profileFile -Raw
  $c = $c -replace '(?s)\n?# >>> grok-any-llm \(gall\) >>>.*?# <<< grok-any-llm \(gall\) <<<\n?', ''
  Set-Content $profileFile -Value $c.TrimEnd() -Encoding utf8
  Write-Host "[gall] funcoes removidas de $profileFile" -ForegroundColor Green
}
Write-Host "[gall] desinstalado. (seu ~/.grok e keys de env nao foram tocados)" -ForegroundColor Cyan
