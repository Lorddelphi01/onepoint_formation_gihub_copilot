#Requires -Version 5.1
<#
    Installe la part de la stack terminal moderne du Chapitre 00 disponible
    nativement sous Windows/PowerShell, via winget.

    zsh, zsh-autosuggestions, zsh-syntax-highlighting, Tmux et TPM
    (tmux-resurrect/tmux-continuum) n'ont pas d'équivalent natif PowerShell :
    pour ces outils, installez WSL Debian puis exécutez install-linux.sh.

    Les identifiants winget d'Atuin et d'eza n'ont pas pu être vérifiés sur une
    vraie machine Windows dans l'environnement qui a produit ce script — voir
    l'issue de suivi du dépôt si l'installation échoue.
#>

$ErrorActionPreference = 'Stop'

function Install-WithWinget {
    param(
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][string]$Name
    )

    $installed = winget list --id $Id --accept-source-agreements 2>$null | Select-String -SimpleMatch $Id
    if ($installed) {
        Write-Host "OK : $Name est deja installe."
        return
    }

    Write-Host "Installation de $Name ($Id)..."
    winget install --id $Id --accept-source-agreements --accept-package-agreements -e
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Echec de l'installation de $Name via winget (id: $Id). Verifiez le nom du paquet ou installez-le manuellement."
    }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget est introuvable. Installez 'App Installer' depuis le Microsoft Store, puis relancez ce script."
    exit 1
}

Write-Host "Installation de la stack terminal moderne (Windows / PowerShell)..."

Install-WithWinget -Id 'Starship.Starship' -Name 'Starship'
Install-WithWinget -Id 'junegunn.fzf' -Name 'fzf'
Install-WithWinget -Id 'sharkdp.bat' -Name 'bat'
Install-WithWinget -Id 'ajeetdsouza.zoxide' -Name 'zoxide'
Install-WithWinget -Id 'ellie.atuin' -Name 'Atuin'

Write-Host ""
Write-Host "eza n'a pas de paquet winget officiel confirme : installez-le depuis WSL (install-linux.sh) ou via 'cargo install eza' si Rust est installe." -ForegroundColor Yellow

Write-Host ""
Write-Host "zsh, zsh-autosuggestions, zsh-syntax-highlighting, Tmux et TPM (resurrect/continuum)" -ForegroundColor Yellow
Write-Host "n'ont pas d'equivalent natif PowerShell : installez WSL Debian puis executez install-linux.sh depuis WSL." -ForegroundColor Yellow

Write-Host ""
Write-Host "Configuration du profil PowerShell ($PROFILE)..."
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = if (Test-Path $PROFILE) { Get-Content -Path $PROFILE -Raw } else { '' }
$beginMarker = '# BEGIN chapitre-00-terminal-stack'
$endMarker = '# END chapitre-00-terminal-stack'
$escapedBegin = [regex]::Escape($beginMarker)
$escapedEnd = [regex]::Escape($endMarker)
$profileContent = [regex]::Replace(
    $profileContent,
    "(?s)\r?\n?$escapedBegin.*?$escapedEnd\r?\n?",
    ''
).TrimEnd()
$managedBlock = @"
$beginMarker
# --- Initialisation des outils (ajoute par install-windows.ps1) ---
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
$endMarker
"@
Set-Content -Path $PROFILE -Value (($profileContent + "`r`n`r`n" + $managedBlock).Trim() + "`r`n")
Write-Host "Bloc de configuration du profil mis a jour dans $PROFILE."
}

Write-Host ""
Write-Host "Installation terminee. Ouvrez un nouveau terminal PowerShell pour voir Starship et zoxide actifs." -ForegroundColor Green
