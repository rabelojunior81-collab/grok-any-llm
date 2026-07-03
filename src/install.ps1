#Requires -Version 7
<#
  install.ps1 — grok-any-llm (gall) installer for Windows (PowerShell)
  Uso: irm https://.../install.ps1 | iex   OU   pwsh install.ps1
  License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab
#>
[CmdletBinding()] param()
$ErrorActionPreference = 'Stop'

$dest = Join-Path $env:USERPROFILE '.grok-any-llm'
$srcRoot = Split-Path -Parent $MyInvocation.MyCommand.Path   # repo/src ou temp
$repoRoot = Split-Path -Parent $srcRoot
Write-Host "[gall] instalando em $dest" -ForegroundColor DarkGray

# 1. copiar src + profiles
New-Item -ItemType Directory -Path "$dest\src","$dest\profiles" -Force | Out-Null
Copy-Item "$srcRoot\gall.ps1" "$dest\src\" -Force -ErrorAction SilentlyContinue
if (Test-Path "$repoRoot\profiles") {
  Copy-Item "$repoRoot\profiles\*" "$dest\profiles\" -Recurse -Force
} elseif (Test-Path "$srcRoot\..\profiles") {
  Copy-Item "$srcRoot\..\profiles\*" "$dest\profiles\" -Recurse -Force
}
New-Item -ItemType Directory -Path "$dest\.telemetry" -Force | Out-Null
Set-Content "$dest\.telemetry\.gitkeep" "# telemetry sink (off default)"

# 2. profile function (gall + grok wrapper)
$profileFile = $PROFILE.CurrentUserCurrentHost
$profileDir = Split-Path -Parent $profileFile
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
$marker = '# >>> grok-any-llm (gall) >>>'
$block = @"
$marker
function gall { & '$dest\src\gall.ps1' @args }
function grok {
  if ($args.Count -gt 0 -and $args[0] -in 'or','kilo','oc') { & '$dest\src\gall.ps1' @args }
  else { & grok.exe @args }   # fallback p/ o binario real
}
# <<< grok-any-llm (gall) <<<
"@
$existing = if (Test-Path $profileFile) { Get-Content $profileFile -Raw -ErrorAction SilentlyContinue } else { '' }
if ($existing -notmatch [regex]::Escape($marker)) {
  Add-Content -Path $profileFile -Value "`n$block" -Encoding utf8
  Write-Host "[gall] funcoes 'gall' e 'grok' adicionadas a $profileFile" -ForegroundColor Green
} else {
  Write-Host "[gall] funcoes ja presentes em $profileFile (skip)" -ForegroundColor DarkGray
}

Write-Host "`n[gall] pronto. Reinicie o terminal (ou '. `$PROFILE')." -ForegroundColor Green
Write-Host "      Use:  grok kilo  |  grok or  |  grok oc  |  grok" -ForegroundColor Cyan
Write-Host "      Keys: defina OPENROUTER_API_KEY, KILO_API_KEY, OPENCODE_GO_API_KEY (env user)" -ForegroundColor DarkGray
Write-Host "      Requer: binario 'grok' (winget install xAI.GrokBuild)" -ForegroundColor DarkGray
