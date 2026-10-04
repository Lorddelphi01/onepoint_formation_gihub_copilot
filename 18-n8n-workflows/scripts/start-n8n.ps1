#Requires -Version 5.1
<#
Lance n8n dans Docker et déclare son serveur MCP dans Copilot CLI (Windows).
Automatise "Lancer n8n avec Docker" et le bloc n8n de la config MCP du Chapitre 18.
  -Detach : mode détaché (arrière-plan) au lieu de -it --rm.
  -NoMcp  : ne touche pas à ~/.copilot/mcp-config.json.
Le réglage "Settings -> Instance-level MCP" reste manuel, dans l'interface n8n.
#>
param([switch]$Detach, [switch]$NoMcp)
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Source = Join-Path $RepoRoot 'samples\mcp-configs\n8n-mcp-config.json'
$CopilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME '.copilot' }
$Target = Join-Path $CopilotHome 'mcp-config.json'

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "docker introuvable : installez Docker Desktop (Chapitre 09)." }

if (-not $NoMcp) {
    New-Item -ItemType Directory -Force -Path $CopilotHome | Out-Null
    if (-not (Test-Path $Target)) { Set-Content -Path $Target -Value '{"mcpServers":{}}' -Encoding UTF8 }
    $config = Get-Content $Target -Raw | ConvertFrom-Json
    Copy-Item $Target "$Target.bak" -Force
    if (-not $config.mcpServers) { $config | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) }
    if (-not $config.mcpServers.PSObject.Properties['n8n']) {
        $src = Get-Content $Source -Raw | ConvertFrom-Json
        $config.mcpServers | Add-Member -NotePropertyName n8n -NotePropertyValue $src.mcpServers.n8n
    }
    $config | ConvertTo-Json -Depth 10 | Set-Content -Path $Target -Encoding UTF8
    Write-Host "OK : serveur MCP n8n déclaré dans $Target (sauvegarde : $Target.bak)"
}

docker volume create n8n_data | Out-Null
if (docker ps -a --format '{{.Names}}' | Select-String -Pattern '^n8n$' -Quiet) {
    throw "Un conteneur 'n8n' existe déjà : docker rm -f n8n, puis relancez."
}

Write-Host "n8n démarre sur http://localhost:5678"
Write-Host "Puis activez Settings -> Instance-level MCP dans l'interface."
if ($Detach) {
    docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
    Start-Sleep -Seconds 3
    docker exec n8n n8n --version
    Write-Host "Arrêt : docker rm -f n8n"
} else {
    docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
}
