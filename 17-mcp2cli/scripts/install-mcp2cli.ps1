#Requires -Version 5.1
<#
Chapitre 17 : mcp2cli.
L'installeur officiel (curl | sh) cible Linux / macOS. Sous Windows, ce script détecte WSL
et y délègue install-mcp2cli.sh ; sans WSL, il explique la marche à suivre.
#>
$ErrorActionPreference = 'Stop'

if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "WSL est introuvable. Installe-le (wsl --install) puis relance ce script,"
    Write-Host "ou suis la page d'installation officielle : https://mcp2cli.dev"
    exit 1
}

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$WslScript = (wsl wslpath -a (Join-Path $RepoRoot '17-mcp2cli\scripts\install-mcp2cli.sh')).Trim()
wsl bash $WslScript @args
exit $LASTEXITCODE
