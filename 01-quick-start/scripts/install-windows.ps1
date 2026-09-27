#Requires -Version 5.1
<#
    Installe GitHub Copilot CLI et vérifie l'installation sur Windows / PowerShell.
    Automatise la section "Installation" et les Étapes 1-2 de "Vérifier que tout
    fonctionne" du Chapitre 01. L'authentification (/login) reste manuelle :
    elle nécessite un navigateur ou un code d'appareil, non scriptables.
#>

$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

Write-Host "Installation de GitHub Copilot CLI (Windows / PowerShell)..."

# --- 1. Installer Copilot CLI ---
if (Get-Command copilot -ErrorAction SilentlyContinue) {
    Write-Host "OK : Copilot CLI est deja installe."
}
elseif (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installation via winget..."
    winget install --id GitHub.Copilot -e --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Echec de l'installation via winget. Tentative via npm..."
        if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
            Write-Error "npm introuvable. Installez Node.js LTS (https://nodejs.org), puis relancez ce script."
            exit 1
        }
        npm install -g '@github/copilot'
    }
}
else {
    Write-Warning "winget introuvable, tentative via npm..."
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Error "npm introuvable. Installez Node.js LTS (https://nodejs.org), puis relancez ce script."
        exit 1
    }
    npm install -g '@github/copilot'
}

# --- 2. Verifier la version installee ---
Write-Host "Verification de la version installee..."
if (-not (Get-Command copilot -ErrorAction SilentlyContinue)) {
    Write-Error "'copilot' reste introuvable dans le PATH. Fermez et rouvrez votre terminal, puis relancez : copilot --version"
    exit 1
}
copilot --version

# --- 3. Verifier Python et la Book App ---
Write-Host "Verification de Python et de la Book App..."
$PythonCmd = $null
foreach ($candidate in @('python', 'py')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $PythonCmd = $candidate
        break
    }
}

if (-not $PythonCmd) {
    Write-Warning "Python introuvable : installez Python 3.10+ (https://www.python.org/downloads/) pour utiliser la Book App."
}
else {
    & $PythonCmd --version
    Push-Location (Join-Path $RepoRoot 'samples\book-app-project')
    try {
        & $PythonCmd 'book_app.py' 'list'
    }
    finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "----------------------------------------------------"
Write-Host "Installation et verifications terminees !" -ForegroundColor Green
Write-Host "----------------------------------------------------"
Write-Host "Etapes manuelles restantes (interactives, non automatisables) :"
Write-Host "1. Lancez 'copilot' puis tapez '/login' pour vous connecter avec votre compte GitHub."
Write-Host "2. Posez votre premiere question, par exemple :"
Write-Host "   > Say hello and tell me what you can help with"
