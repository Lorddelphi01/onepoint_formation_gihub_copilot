#Requires -Version 5.1
<#
Ajoute les serveurs MCP filesystem et context7 à ~/.copilot/mcp-config.json (Windows).
Automatise la section "Fichier de configuration complet" du Chapitre 07.
La config existante est fusionnée, jamais écrasée : une sauvegarde .bak est créée avant écriture.
GitHub MCP est intégré à Copilot CLI : il n'est volontairement pas ajouté.
#>
$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Source = Join-Path $RepoRoot 'samples\mcp-configs\mcp-config.json'
$CopilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME '.copilot' }
$Target = Join-Path $CopilotHome 'mcp-config.json'

New-Item -ItemType Directory -Force -Path $CopilotHome | Out-Null
if (-not (Test-Path $Target)) { Set-Content -Path $Target -Value '{"mcpServers":{}}' -Encoding UTF8 }

try { $config = Get-Content $Target -Raw | ConvertFrom-Json }
catch { throw "$Target n'est pas un JSON valide : corrigez-le avant de relancer ce script." }
$src = Get-Content $Source -Raw | ConvertFrom-Json

Copy-Item $Target "$Target.bak" -Force
if (-not $config.mcpServers) { $config | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{}) }

# Les serveurs déjà présents gardent la priorité (idempotent).
foreach ($name in 'filesystem', 'context7') {
    if (-not $config.mcpServers.PSObject.Properties[$name]) {
        $config.mcpServers | Add-Member -NotePropertyName $name -NotePropertyValue $src.mcpServers.$name
    }
}

$config | ConvertTo-Json -Depth 10 | Set-Content -Path $Target -Encoding UTF8
Write-Host "OK : configuration MCP mise à jour : $Target (sauvegarde : $Target.bak)"
$config.mcpServers.PSObject.Properties.Name | ForEach-Object { Write-Host "   - $_" }
Write-Host "Vérifiez dans Copilot CLI avec : copilot mcp list   (ou /mcp en session)"
