#Requires -Version 5.1
<#
    Installe, désinstalle ou liste la part de la stack terminal moderne du
    Chapitre 00 disponible nativement sous Windows/PowerShell, via winget —
    tous les outils gérés à la fois, ou un outil précis, via un menu
    interactif ou des paramètres.

    zsh, eza, zsh-autosuggestions, zsh-syntax-highlighting, Tmux et TPM
    (tmux-resurrect/tmux-continuum) n'ont pas d'équivalent natif PowerShell :
    pour ces outils, installez WSL Debian puis exécutez install-linux.sh.

    Les identifiants winget d'Atuin n'ont pas pu être vérifiés sur une vraie
    machine Windows dans l'environnement qui a produit ce script — voir
    l'issue de suivi du dépôt si l'installation ou la désinstallation échoue.

    Utilisation :
      .\install-windows.ps1                       Ouvre le menu interactif.
      .\install-windows.ps1 -ListTools             Affiche l'état de chaque outil.
      .\install-windows.ps1 -Install starship      Installe un outil précis.
      .\install-windows.ps1 -Install all           Installe tous les outils gérés.
      .\install-windows.ps1 -Uninstall zoxide      Désinstalle un outil précis.
      .\install-windows.ps1 -Uninstall all         Désinstalle tous les outils gérés.
#>

param(
    [string]$Install,
    [string]$Uninstall,
    [switch]$ListTools,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

$Tools = [ordered]@{
    starship = @{ Id = 'Starship.Starship'; Name = 'Starship'; Command = 'starship' }
    fzf      = @{ Id = 'junegunn.fzf'; Name = 'fzf'; Command = 'fzf' }
    bat      = @{ Id = 'sharkdp.bat'; Name = 'bat'; Command = 'bat' }
    zoxide   = @{ Id = 'ajeetdsouza.zoxide'; Name = 'zoxide'; Command = 'zoxide' }
    atuin    = @{ Id = 'ellie.atuin'; Name = 'Atuin'; Command = 'atuin' }
}

function Show-Usage {
    Write-Host @"
Usage : install-windows.ps1 [option]

Sans option, ouvre un menu interactif.

Options :
  -ListTools                Affiche l'état (installé/absent) de chaque outil.
  -Install <outil|all>      Installe un outil précis, ou "all" pour tous.
  -Uninstall <outil|all>    Désinstalle un outil précis, ou "all" pour tous.
  -Help                     Affiche cette aide.

Outils gérés : $($Tools.Keys -join ', ')

eza, zsh, zsh-autosuggestions, zsh-syntax-highlighting, Tmux et TPM n'ont pas
d'équivalent natif PowerShell : installez WSL Debian puis exécutez
install-linux.sh depuis WSL.
"@
}

function Test-ToolInstalled {
    param([string]$Tool)
    [bool](Get-Command $Tools[$Tool].Command -ErrorAction SilentlyContinue)
}

function Install-Tool {
    param([string]$Tool)
    $meta = $Tools[$Tool]
    if (Test-ToolInstalled $Tool) {
        Write-Host "OK : $($meta.Name) est déjà installé."
        return
    }
    Write-Host "Installation de $($meta.Name) ($($meta.Id))..."
    winget install --id $meta.Id --accept-source-agreements --accept-package-agreements -e
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Échec de l'installation de $($meta.Name) via winget (id: $($meta.Id))."
    }
}

function Uninstall-Tool {
    param([string]$Tool)
    $meta = $Tools[$Tool]
    if (-not (Test-ToolInstalled $Tool)) {
        Write-Host "Absent : $($meta.Name) n'est pas installé."
        return
    }
    Write-Host "Désinstallation de $($meta.Name) ($($meta.Id))..."
    winget uninstall --id $meta.Id -e
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Échec de la désinstallation de $($meta.Name) via winget (id: $($meta.Id))."
    }
}

function Update-ProfileBlock {
    $beginMarker = '# BEGIN chapitre-00-terminal-stack'
    $endMarker = '# END chapitre-00-terminal-stack'
    $escapedBegin = [regex]::Escape($beginMarker)
    $escapedEnd = [regex]::Escape($endMarker)

    if (-not (Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    $profileContent = Get-Content -Path $PROFILE -Raw
    if ($null -eq $profileContent) { $profileContent = '' }
    $profileContent = [regex]::Replace(
        $profileContent,
        "(?s)\r?\n?$escapedBegin.*?$escapedEnd\r?\n?",
        ''
    ).TrimEnd()

    $initLines = @()
    if (Test-ToolInstalled 'starship') { $initLines += 'Invoke-Expression (&starship init powershell)' }
    if (Test-ToolInstalled 'zoxide') { $initLines += 'Invoke-Expression (& { (zoxide init powershell | Out-String) })' }

    if ($initLines.Count -eq 0) {
        Set-Content -Path $PROFILE -Value ($profileContent.TrimEnd() + "`r`n")
        Write-Host "Bloc de configuration retiré de $PROFILE (aucun outil avec hook de profil installé)."
        return
    }

    $managedBlock = @($beginMarker, '# --- Initialisation des outils (ajouté par install-windows.ps1) ---') + $initLines + @($endMarker)
    $managedBlockText = $managedBlock -join "`r`n"
    Set-Content -Path $PROFILE -Value (($profileContent + "`r`n`r`n" + $managedBlockText).Trim() + "`r`n")
    Write-Host "Bloc de configuration du profil mis à jour dans $PROFILE."
}

function Show-ToolList {
    Write-Host "Outil      État"
    Write-Host "-------------------------"
    foreach ($key in $Tools.Keys) {
        $state = if (Test-ToolInstalled $key) { 'installé' } else { 'absent' }
        Write-Host ("{0,-10} {1}" -f $key, $state)
    }
}

function Invoke-InstallAll {
    foreach ($key in $Tools.Keys) { Install-Tool $key }
    Update-ProfileBlock
}

function Invoke-UninstallAll {
    foreach ($key in $Tools.Keys) { Uninstall-Tool $key }
    Update-ProfileBlock
}

function Confirm-Action {
    param([string]$Prompt)
    $reply = Read-Host "$Prompt [o/N]"
    return ($reply -match '^(o|oui|y|yes)$')
}

function Show-InteractiveMenu {
    while ($true) {
        Write-Host ""
        Write-Host "==== Stack terminal moderne - Chapitre 00 (Windows) ===="
        $i = 1
        $keys = @($Tools.Keys)
        foreach ($key in $keys) {
            $state = if (Test-ToolInstalled $key) { 'installé' } else { 'absent' }
            Write-Host ("  {0}) {1} ({2})" -f $i, $key, $state)
            $i++
        }
        Write-Host "   a) Installer tous les outils"
        Write-Host "   u) Désinstaller tous les outils"
        Write-Host "   q) Quitter"
        $choice = Read-Host "Votre choix"

        switch -Regex ($choice) {
            '^[aA]$' { Invoke-InstallAll }
            '^[uU]$' {
                if (Confirm-Action "Désinstaller TOUS les outils ?") { Invoke-UninstallAll } else { Write-Host "Annulé." }
            }
            '^[qQ]$' { return }
            '^\d+$' {
                $idx = [int]$choice - 1
                if ($idx -ge 0 -and $idx -lt $keys.Count) {
                    $tool = $keys[$idx]
                    if (Test-ToolInstalled $tool) {
                        if (Confirm-Action "Désinstaller $tool ?") { Uninstall-Tool $tool; Update-ProfileBlock } else { Write-Host "Annulé." }
                    } else {
                        Install-Tool $tool
                        Update-ProfileBlock
                    }
                } else {
                    Write-Host "Choix invalide."
                }
            }
            default { Write-Host "Choix invalide." }
        }
    }
}

if ($Help) {
    Show-Usage
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget est introuvable. Installez 'App Installer' depuis le Microsoft Store, puis relancez ce script."
    exit 1
}

Write-Host "Stack terminal moderne - Chapitre 00 (Windows / PowerShell)"

if ($ListTools) {
    Show-ToolList
    exit 0
}

if ($Install) {
    if ($Install -eq 'all') {
        Invoke-InstallAll
    } elseif ($Tools.Contains($Install)) {
        Install-Tool $Install
        Update-ProfileBlock
    } else {
        Write-Error "Outil inconnu : $Install (outils gérés : $($Tools.Keys -join ', '))"
        exit 1
    }
    exit 0
}

if ($Uninstall) {
    if ($Uninstall -eq 'all') {
        Invoke-UninstallAll
    } elseif ($Tools.Contains($Uninstall)) {
        Uninstall-Tool $Uninstall
        Update-ProfileBlock
    } else {
        Write-Error "Outil inconnu : $Uninstall (outils gérés : $($Tools.Keys -join ', '))"
        exit 1
    }
    exit 0
}

Show-InteractiveMenu
Write-Host ""
Write-Host "Terminé. Ouvrez un nouveau terminal PowerShell pour charger la configuration." -ForegroundColor Green
