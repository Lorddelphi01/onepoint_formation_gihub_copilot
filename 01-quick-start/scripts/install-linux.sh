#!/usr/bin/env bash
# Installe GitHub Copilot CLI et vérifie l'installation sur Linux / WSL Debian.
# Automatise la section "Installation" et les Étapes 1-2 de "Vérifier que tout
# fonctionne" du Chapitre 01. L'authentification (/login) reste manuelle :
# elle nécessite un navigateur ou un code d'appareil, non scriptables.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "🚀 Installation de GitHub Copilot CLI (Linux / WSL Debian)..."

# --- 1. Installer Copilot CLI ---
if command -v copilot &> /dev/null; then
    echo "✅ Copilot CLI déjà installé."
else
    echo "📦 Installation via le script officiel..."
    if ! (curl -fsSL https://gh.io/copilot-install | bash); then
        echo "⚠️  Le script d'installation a échoué, tentative via npm..."
        if ! command -v npm &> /dev/null; then
            echo "❌ npm introuvable. Installez Node.js LTS (https://nodejs.org), puis relancez ce script." >&2
            exit 1
        fi
        npm install -g @github/copilot
    fi
fi

# --- 2. Vérifier la version installée ---
echo "🔎 Vérification de la version installée..."
if ! command -v copilot &> /dev/null; then
    echo "❌ 'copilot' reste introuvable dans le PATH. Fermez et rouvrez votre terminal, puis relancez : copilot --version" >&2
    exit 1
fi
copilot --version

# --- 3. Vérifier Python et la Book App ---
echo "🐍 Vérification de Python et de la Book App..."
PYTHON_BIN=""
if command -v python3 &> /dev/null; then
    PYTHON_BIN="python3"
elif command -v python &> /dev/null; then
    PYTHON_BIN="python"
fi

if [ -z "$PYTHON_BIN" ]; then
    echo "⚠️  Python introuvable : installez Python 3.10+ (https://www.python.org/downloads/) pour utiliser la Book App."
else
    "$PYTHON_BIN" --version
    (cd "$REPO_ROOT/samples/book-app-project" && "$PYTHON_BIN" book_app.py list)
fi

echo "----------------------------------------------------"
echo "✅ Installation et vérifications terminées !"
echo "----------------------------------------------------"
echo "Étapes manuelles restantes (interactives, non automatisables) :"
echo "1. Lancez 'copilot' puis tapez '/login' pour vous connecter avec votre compte GitHub."
echo "2. Posez votre première question, par exemple :"
echo "   > Say hello and tell me what you can help with"
