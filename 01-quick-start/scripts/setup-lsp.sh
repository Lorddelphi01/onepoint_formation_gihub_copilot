#!/usr/bin/env bash
# Installe Pyright et déclare le serveur LSP Python pour Copilot CLI (Linux / macOS / WSL).
# Automatise la section F.1 (Python, Pyright) du Chapitre 01.
# La config est fusionnée dans ~/.copilot/lsp-config.json (sauvegarde .bak) ; Java (F.2) et .NET (F.3) restent manuels.
set -euo pipefail

TARGET="${COPILOT_HOME:-$HOME/.copilot}/lsp-config.json"

for cmd in npm jq; do
    command -v "$cmd" &> /dev/null || { echo "❌ '$cmd' est requis mais introuvable." >&2; exit 1; }
done

if command -v pyright-langserver &> /dev/null; then
    echo "✅ Pyright déjà installé."
else
    npm install -g pyright
fi

mkdir -p "$(dirname "$TARGET")"
[ -f "$TARGET" ] || echo '{"lspServers":{}}' > "$TARGET"
cp "$TARGET" "$TARGET.bak"
TMP="$(mktemp)"
jq '.lspServers = ({python: {command: "pyright-langserver", args: ["--stdio"], fileExtensions: {".py": "python"}}} + (.lspServers // {}))' \
    "$TARGET" > "$TMP" && mv "$TMP" "$TARGET"
echo "✅ Serveur LSP Python déclaré dans $TARGET"

if command -v copilot &> /dev/null; then
    copilot lsp list
else
    echo "⚠️  'copilot' introuvable : vérifie plus tard avec 'copilot lsp list' (attendu : python (.py))."
fi
