#Requires -Version 7
<#
  gall.ps1 — grok-any-llm shim (PowerShell)
  Lanca o harness Grok Code com um provider de LLM, de forma nao-persistente.
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

function Out-Diag([string]$msg) { Write-Output $msg }  # stdout (capturavel; diagnósticos só em dry-run/erros pré-grok)

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
    Out-Diag "[gall] perfil nao encontrado: $profileDir\config.toml"; exit 2
  }
  $key = [Environment]::GetEnvironmentVariable($p.keyEnv, 'Process')
  if (-not $key) {
    Out-Diag "[gall] ERRO: env var $($p.keyEnv) nao definida."
    Out-Diag "       defina com:  `$env:$($p.keyEnv) = 'sua-key'   (ou [Environment]::SetEnvironmentVariable('$($p.keyEnv)','sua-key','User'))"
    exit 3
  }
  $saveHome = $env:GROK_HOME; $saveKey = $env:XAI_API_KEY; $saveModel = $env:GROK_DEFAULT_MODEL
  try {
    $env:GROK_HOME = $profileDir
    $env:XAI_API_KEY = $key
    if ($overrideModel) { $env:GROK_DEFAULT_MODEL = $overrideModel }
    $defModel = if ($overrideModel) { $overrideModel } else { '(do perfil)' }
    if ($dryRun) {
      Out-Diag "[gall dry-run] provider=$provider  GROK_HOME=$profileDir  XAI_API_KEY=$($key.Substring(0,6))...  GROK_DEFAULT_MODEL=$defModel"
      Write-Telemetry $provider $(if($overrideModel){$overrideModel}else{'?'}) 'dry-run'; return
    }
    if (-not (Get-Command grok -ErrorAction SilentlyContinue)) {
      Out-Diag "[gall] ERRO: 'grok' nao esta no PATH. Instale: winget install xAI.GrokBuild"; exit 4
    }
    & grok @rest
    Write-Telemetry $provider $(if($overrideModel){$overrideModel}else{'?'}) 'ok'
  }
  finally {
    $env:GROK_HOME = $saveHome; $env:XAI_API_KEY = $saveKey; $env:GROK_DEFAULT_MODEL = $saveModel
  }
}
else {
  if (-not (Get-Command grok -ErrorAction SilentlyContinue)) {
    Out-Diag "[gall] ERRO: 'grok' nao esta no PATH."; exit 4
  }
  & grok @rest
}
