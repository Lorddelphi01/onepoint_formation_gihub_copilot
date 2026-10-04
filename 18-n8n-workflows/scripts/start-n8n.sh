#!/usr/bin/env bash
# Lance n8n dans Docker et déclare son serveur MCP dans Copilot CLI (Linux / macOS / WSL).
# Automatise "Lancer n8n avec Docker" et le bloc n8n de la config MCP du Chapitre 18.
# Usage : start-n8n.sh [-d] [--no-mcp]
#   -d        : mode détaché (conteneur en arrière-plan) au lieu de -it --rm.
#   --no-mcp  : ne touche pas à ~/.copilot/mcp-config.json.
# Le réglage "Settings -> Instance-level MCP" reste manuel, dans l'interface n8n.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SOURCE="$REPO_ROOT/samples/mcp-configs/n8n-mcp-config.json"
TARGET="${COPILOT_HOME:-$HOME/.copilot}/mcp-config.json"
detach=0; mcp=1
for arg in "$@"; do
    case "$arg" in
        -d) detach=1 ;;
        --no-mcp) mcp=0 ;;
        *) echo "Option inconnue : $arg" >&2; exit 2 ;;
    esac
done

command -v docker &> /dev/null || { echo "❌ docker introuvable : installez Docker (Chapitre 09)." >&2; exit 1; }

# --- 1. Config MCP (fusion non destructive) ---
if [ "$mcp" -eq 1 ]; then
    if ! command -v jq &> /dev/null; then
        echo "⚠️  jq introuvable : bloc MCP n8n ignoré (voir la config manuelle du chapitre)."
    else
        mkdir -p "$(dirname "$TARGET")"
        [ -f "$TARGET" ] || echo '{"mcpServers":{}}' > "$TARGET"
        cp "$TARGET" "$TARGET.bak"
        TMP="$(mktemp)"
        jq --slurpfile src "$SOURCE" '.mcpServers = (($src[0].mcpServers) + (.mcpServers // {}))' "$TARGET" > "$TMP" && mv "$TMP" "$TARGET"
        echo "✅ Serveur MCP n8n déclaré dans $TARGET (sauvegarde : $TARGET.bak)"
    fi
fi

# --- 2. Lancer n8n ---
docker volume create n8n_data > /dev/null
if docker ps -a --format '{{.Names}}' | grep -qx n8n; then
    echo "❌ Un conteneur 'n8n' existe déjà : docker rm -f n8n, puis relancez." >&2
    exit 1
fi

echo "🚀 n8n démarre sur http://localhost:5678"
echo "   Puis activez Settings -> Instance-level MCP dans l'interface."
if [ "$detach" -eq 1 ]; then
    docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
    sleep 3
    docker exec n8n n8n --version || echo "⚠️  Conteneur pas encore prêt : réessayez 'docker exec n8n n8n --version'."
    echo "Arrêt : docker rm -f n8n"
else
    docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
fi
