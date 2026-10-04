#Requires -Version 5.1
<#
Crée un worktree, y lance Copilot CLI en mode programmatique (-p), puis le supprime.
Automatise le "Défi bonus : un script de nettoyage automatique" du Chapitre 16.
Usage : .\wt-parallel.ps1 -Branch feature/x -Prompt "..." [-Keep]
  -Keep : conserve le worktree à la fin (pour inspecter ou fusionner le résultat).
#>
param(
    [Parameter(Mandatory)][string]$Branch,
    [Parameter(Mandatory)][string]$Prompt,
    [switch]$Keep
)
$ErrorActionPreference = 'Stop'

foreach ($cmd in 'git', 'copilot') {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "'$cmd' introuvable dans le PATH." }
}

if (git status --porcelain) {
    Write-Warning "Le dépôt courant contient des modifications non commitées (le worktree partira de HEAD, sans elles)."
}

$Path = "..\wt-$($Branch -replace '/', '-')"
if (Test-Path $Path) { throw "$Path existe déjà : supprime-le (git worktree remove $Path) ou change de branche." }

git worktree add -b $Branch $Path
if ($LASTEXITCODE -ne 0) { throw "Échec de git worktree add." }

try {
    Push-Location $Path
    try { copilot -p $Prompt } finally { Pop-Location }
    Write-Host "OK : terminé. Worktrees actuels :"
    git worktree list
} finally {
    if ($Keep) {
        Write-Host "Worktree conservé : $Path (nettoyage : git worktree remove $Path)"
    } else {
        git worktree remove --force $Path
        Write-Host "Worktree $Path supprimé (la branche $Branch est conservée)."
    }
}
