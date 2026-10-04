#!/usr/bin/env bash
# Ajoute les serveurs MCP filesystem et context7 à ~/.copilot/mcp-config.json (Linux / macOS / WSL).
# Automatise la section "Fichier de configuration complet" du Chapitre 07.
# La config existante est fusionnée, jamais écrasée : une sauvegarde .bak est créée avant écriture.
# GitHub MCP est intégré à Copilot CLI : il n'est volontairement pas ajouté.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SOURCE="$REPO_ROOT/samples/mcp-configs/mcp-config.json"
TARGET="${COPILOT_HOME:-$HOME/.copilot}/mcp-config.json"

if ! command -v jq &> /dev/null; then
    echo "❌ jq est requis pour fusionner le JSON sans perdre votre config (sudo apt install jq / brew install jq)." >&2
    exit 1
fi

mkdir -p "$(dirname "$TARGET")"
[ -f "$TARGET" ] || echo '{"mcpServers":{}}' > "$TARGET"

if ! jq -e . "$TARGET" &> /dev/null; then
    echo "❌ $TARGET n'est pas un JSON valide : corrigez-le avant de relancer ce script." >&2
    exit 1
fi

cp "$TARGET" "$TARGET.bak"
TMP="$(mktemp)"
# Les serveurs déjà présents dans la config utilisateur gardent la priorité (idempotent).
jq --slurpfile src "$SOURCE" '
    .mcpServers = ((($src[0].mcpServers | {filesystem, context7})) + (.mcpServers // {}))
' "$TARGET" > "$TMP" && mv "$TMP" "$TARGET"

echo "✅ Configuration MCP mise à jour : $TARGET (sauvegarde : $TARGET.bak)"
jq -r '.mcpServers | keys[] | "   - " + .' "$TARGET"
echo "Vérifiez dans Copilot CLI avec : copilot mcp list   (ou /mcp en session)"
