#!/usr/bin/env bash
# Crée un worktree, y lance Copilot CLI en mode programmatique (-p), puis le supprime.
# Automatise le "Défi bonus : un script de nettoyage automatique" du Chapitre 16.
# Usage : wt-parallel.sh <branche> "<prompt>" [--keep]
#   --keep : conserve le worktree à la fin (pour inspecter ou fusionner le résultat).
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage : $0 <branche> \"<prompt>\" [--keep]" >&2
    exit 2
fi
branch="$1"
prompt="$2"
keep="${3:-}"

for cmd in git copilot; do
    command -v "$cmd" &> /dev/null || { echo "❌ '$cmd' introuvable dans le PATH." >&2; exit 1; }
done

# Pré-contrôle : un dépôt propre évite de mélanger vos changements avec ceux du worktree.
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Le dépôt courant contient des modifications non commitées (le worktree partira de HEAD, sans elles)."
fi

path="../wt-${branch//\//-}"
if [ -e "$path" ]; then
    echo "❌ $path existe déjà : supprimez-le (git worktree remove $path) ou changez de branche." >&2
    exit 1
fi

git worktree add -b "$branch" "$path"

cleanup() {
    if [ "$keep" = "--keep" ]; then
        echo "ℹ️  Worktree conservé : $path (nettoyage : git worktree remove $path)"
    else
        git worktree remove --force "$path"
        echo "🧹 Worktree $path supprimé (la branche $branch est conservée)."
    fi
}
trap cleanup EXIT

(cd "$path" && copilot -p "$prompt")
echo "✅ Terminé. Worktrees actuels :"
git worktree list
