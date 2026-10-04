#Requires -Version 5.1
<#
Installe Pyright et déclare le serveur LSP Python pour Copilot CLI (Windows).
Automatise la section F.1 (Python, Pyright) du Chapitre 01.
La config est fusionnée dans ~/.copilot/lsp-config.json (sauvegarde .bak) ; Java (F.2) et .NET (F.3) restent manuels.
#>
$ErrorActionPreference = 'Stop'

$CopilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME '.copilot' }
$Target = Join-Path $CopilotHome 'lsp-config.json'

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw "npm est requis : installez Node.js LTS (https://nodejs.org)." }

if (Get-Command pyright-langserver -ErrorAction SilentlyContinue) { Write-Host "OK : Pyright déjà installé." }
else { npm install -g pyright }

New-Item -ItemType Directory -Force -Path $CopilotHome | Out-Null
if (-not (Test-Path $Target)) { Set-Content -Path $Target -Value '{"lspServers":{}}' -Encoding UTF8 }
$config = Get-Content $Target -Raw | ConvertFrom-Json
Copy-Item $Target "$Target.bak" -Force
if (-not $config.lspServers) { $config | Add-Member -NotePropertyName lspServers -NotePropertyValue ([pscustomobject]@{}) }
if (-not $config.lspServers.PSObject.Properties['python']) {
    $python = [pscustomobject]@{
        command        = 'pyright-langserver'
        args           = @('--stdio')
        fileExtensions = [pscustomobject]@{ '.py' = 'python' }
    }
    $config.lspServers | Add-Member -NotePropertyName python -NotePropertyValue $python
}
$config | ConvertTo-Json -Depth 10 | Set-Content -Path $Target -Encoding UTF8
Write-Host "OK : serveur LSP Python déclaré dans $Target"

if (Get-Command copilot -ErrorAction SilentlyContinue) { copilot lsp list }
else { Write-Host "copilot introuvable : vérifiez plus tard avec 'copilot lsp list' (attendu : python (.py))." }
