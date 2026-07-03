#Requires -Version 7
<#
  gall.ps1 — grok-any-llm shim (PowerShell)
  Lança o harness Grok Code com um provider de LLM, de forma nao-persistente.
  Uso:  gall <provider> [--model X] [args...]
        gall [args...]            # passthrough p/ o grok default
  Providers: or (OpenRouter) | kilo (Kilo Gateway) | oc (OpenCode Go)
  License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab
#>
[CmdletBinding()]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$ErrorActionPreference = 'Stop'

# --- resolve repo/instalacao ---
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$profilesRoot = Join-Path $scriptRoot '..\profiles' | Resolve-Path -ErrorAction SilentlyContinue
if (-not $profilesRoot) { $profilesRoot = Join-Path $scriptRoot 'profiles' }

# --- mapa de providers ---
$providers = @{
  or   = @{ profile = 'or';   keyEnv = 'OPENROUTER_API_KEY' }
  kilo = @{ profile = 'kilo'; keyEnv = 'KILO_API_KEY' }
  oc   = @{ profile = 'oc';   keyEnv = 'OPENCODE_GO_API_KEY' }
}

# --- parse ---
$provider = $null
$overrideModel = $null
$dryRun = $false
$rest = New-Object System.Collections.Generic.List[string]
$i = 0
while ($i -lt $Args.Count) {
  $a = $Args[$i]
  if ($i -eq 0 -and $providers.ContainsKey($a)) { $provider = $a; $i++; continue }
  if ($a -eq '--dry-run') { $dryRun = $true; $i++; continue }
  if ($a -eq '--model') { $i++; if ($i -lt $Args.Count) { $overrideModel = $Args[$i] }; $i++; continue }
  if ($a -like '--model=*') { $overrideModel = $a.Substring(8); $i++; continue }
  $rest.Add($a); $i++
}

function Write-Telemetry([string]$prov, [string]$model, [string]$outcome) {
  $sink = Join-Path $env:USERPROFILE '.grok-any-llm\.telemetry\gall.jsonl'
  if (-not (Test-Path (Split-Path $sink))) { return }
  $ts = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss-03:00')
  $rec = @{ ts=$ts; harness='gall'; llm=$model; model=$model; provider=$prov; session=$PID; outcome=$outcome } | ConvertTo-Json -Compress
  Add-Content -Path $sink -Value $rec -Encoding utf8
}

# --- provider dispatch ---
if ($provider) {
  $p = $providers[$provider]
  $profileDir = Join-Path $profilesRoot $p.profile
  if (-not (Test-Path (Join-Path $profileDir 'config.toml'))) {
    Write-Error "[gall] perfil nao encontrado: $profileDir\config.toml"; exit 2
  }
  $key = [Environment]::GetEnvironmentVariable($p.keyEnv, 'User')
  if (-not $key) { $key = [Environment]::GetEnvironmentVariable($p.keyEnv, 'Process') }
  if (-not $key) {
    Write-Host "[gall] ERRO: env var $($p.keyEnv) nao definida." -ForegroundColor Red
    Write-Host "       defina com:  `$env:$($p.keyEnv) = 'sua-key'   (ou [Environment]::SetEnvironmentVariable('$($p.keyEnv)','sua-key','User'))"
    exit 3
  }
  # save/restore (nao-persistente no shell pai)
  $saveHome = $env:GROK_HOME; $saveKey = $env:XAI_API_KEY; $saveModel = $env:GROK_DEFAULT_MODEL
  try {
    $env:GROK_HOME = $profileDir
    $env:XAI_API_KEY = $key
    if ($overrideModel) { $env:GROK_DEFAULT_MODEL = $overrideModel }
    if ($dryRun) {
      Write-Host "[gall dry-run] provider=$provider  GROK_HOME=$profileDir  XAI_API_KEY=$($key.Substring(0,6))...  GROK_DEFAULT_MODEL=$(if($overrideModel){$overrideModel}else{'(do perfil)'})"
      Write-Telemetry $provider $(if($overrideModel){$overrideModel}else{'?'}) 'dry-run'; return
    }
    if (-not (Get-Command grok -ErrorAction SilentlyContinue)) {
      Write-Host "[gall] ERRO: 'grok' nao esta no PATH. Instale: winget install xAI.GrokBuild" -ForegroundColor Red; exit 4
    }
    & grok @rest
    Write-Telemetry $provider $(if($overrideModel){$overrideModel}else{'?'}) 'ok'
  }
  finally {
    $env:GROK_HOME = $saveHome; $env:XAI_API_KEY = $saveKey; $env:GROK_DEFAULT_MODEL = $saveModel
  }
}
else {
  # passthrough: grok default
  if (-not (Get-Command grok -ErrorAction SilentlyContinue)) {
    Write-Host "[gall] ERRO: 'grok' nao esta no PATH." -ForegroundColor Red; exit 4
  }
  & grok @rest
}
