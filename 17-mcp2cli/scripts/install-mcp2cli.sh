#!/usr/bin/env bash
# Installe mcp2cli et crée l'alias `context7` (Linux / macOS / WSL).
# Automatise les commandes d'installation de "Un parcours exactement reproductible" du Chapitre 17.
# Le serveur Context7 est celui du Chapitre 07 (npx, sans clé API) : Node.js est requis.
# Passez --yes pour exécuter l'installeur distant sans confirmation.
set -euo pipefail

INSTALL_URL="https://mcp2cli.dev/install.sh"

if ! command -v npx &> /dev/null; then
    echo "❌ npx introuvable. Installez Node.js LTS (https://nodejs.org), puis relancez ce script." >&2
    exit 1
fi

# --- 1. Installer mcp2cli ---
if command -v mcp2cli &> /dev/null; then
    echo "✅ mcp2cli déjà installé."
else
    echo "⚠️  Le script distant $INSTALL_URL va être exécuté. Lisez-le d'abord : curl -fsSL $INSTALL_URL"
    if [ "${1:-}" != "--yes" ]; then
        read -r -p "Continuer ? [y/N] " answer
        [[ "$answer" =~ ^[yYoO]$ ]] || { echo "Abandon."; exit 1; }
    fi
    curl -fsSL "$INSTALL_URL" | sh
fi

if ! command -v mcp2cli &> /dev/null; then
    echo "❌ 'mcp2cli' reste introuvable. Ajoutez son dossier d'installation au PATH ou rouvrez le terminal, puis relancez." >&2
    exit 1
fi

# --- 2. Configurer Context7 et créer l'alias ---
if mcp2cli config show --name context7 &> /dev/null; then
    echo "✅ Config 'context7' déjà présente."
else
    mcp2cli config init --name context7 --app bridge \
        --transport stdio --stdio-command npx \
        --stdio-arg -y --stdio-arg @upstash/context7-mcp
fi
mcp2cli link create --name context7 || echo "⚠️  Alias déjà existant ou création impossible (ignoré)."

# --- 3. Vérifier ---
mcp2cli --version
mcp2cli config show --name context7
echo "✅ Terminé. Si 'context7' est introuvable, rouvrez le terminal ou ajoutez le dossier de mcp2cli au PATH."
echo "Étape suivante (Chapitre 17, Étape 1) : context7 ls --tools"
