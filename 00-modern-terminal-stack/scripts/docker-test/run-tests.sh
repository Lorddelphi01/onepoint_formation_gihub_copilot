#!/usr/bin/env bash
# Construit et exécute, dans des conteneurs Docker jetables, une suite de
# vérifications de bout en bout pour install-linux.sh / install-macos.sh /
# install-windows.ps1 : état initial propre, installation d'un outil unique,
# désinstallation de ce même outil, installation globale, désinstallation
# globale, et garde-fou de dépendance (tmux-plugins nécessite tmux).
#
# Outil local uniquement (non branché en CI) : à lancer à la demande avant de
# merger un changement sur ces scripts. Voir README.md dans ce dossier pour
# les limites de fidélité de chaque conteneur.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" # .../00-modern-terminal-stack/scripts
DOCKER_TEST_DIR="$SCRIPT_DIR/docker-test"

FAILED=0
fail() { echo "❌ ÉCHEC : $1" >&2; FAILED=1; }
pass() { echo "✅ $1"; }

cleanup() {
    for c in c00-test-linux c00-test-macos c00-test-windows; do
        docker rm -f "$c" &> /dev/null || true
    done
}
trap cleanup EXIT

container_home() {
    docker exec "$1" sh -c 'echo $HOME'
}

# --- Suite commune Linux / macOS (scripts bash) ---
run_bash_suite() {
    local image_tag="$1" dockerfile="$2" container="$3" script_path="$4" tool="$5"

    echo "=== Construction de l'image ($container) ==="
    docker build -q -f "$DOCKER_TEST_DIR/$dockerfile" -t "$image_tag" "$SCRIPT_DIR" > /dev/null

    docker run -d --name "$container" --entrypoint sleep "$image_tag" infinity > /dev/null
    local home
    home="$(container_home "$container")"

    exec_script() { docker exec "$container" bash "$script_path" "$@"; }

    echo "--- [$container] --list initial : tout doit être absent ---"
    local out
    out="$(exec_script --list)"
    if echo "$out" | grep -q "^✅ "; then
        fail "$container : un outil apparaît déjà installé au départ"
    else
        pass "$container : état initial propre"
    fi

    echo "--- [$container] --install=$tool --yes ---"
    exec_script --install="$tool" --yes > /dev/null
    out="$(exec_script --list)"
    if echo "$out" | grep -E "^✅ ${tool}[[:space:]]" > /dev/null; then
        pass "$container : $tool installé seul"
    else
        fail "$container : $tool absent après --install=$tool"
    fi
    if [ "$(echo "$out" | grep -c "^✅ ")" != "1" ]; then
        fail "$container : plus d'un outil marqué installé après --install=$tool"
    fi

    echo "--- [$container] --uninstall=$tool --yes ---"
    exec_script --uninstall="$tool" --yes > /dev/null
    out="$(exec_script --list)"
    if echo "$out" | grep -q "^✅ "; then
        fail "$container : un outil reste installé après --uninstall=$tool"
    else
        pass "$container : retour à l'état propre après désinstallation unitaire"
    fi

    echo "--- [$container] --install=all --yes ---"
    exec_script --install=all --yes > /dev/null
    out="$(exec_script --list)"
    if echo "$out" | grep -q "^⬜ "; then
        fail "$container : au moins un outil manquant après --install=all"
    else
        pass "$container : tous les outils installés"
    fi
    if docker exec "$container" grep -q "chapitre-00-terminal-stack" "$home/.zshrc"; then
        pass "$container : bloc de config présent dans ~/.zshrc"
    else
        fail "$container : bloc de config absent de ~/.zshrc après --install=all"
    fi

    echo "--- [$container] --uninstall=all --yes ---"
    exec_script --uninstall=all --yes > /dev/null
    out="$(exec_script --list)"
    if echo "$out" | grep -q "^✅ "; then
        fail "$container : au moins un outil reste installé après --uninstall=all"
    else
        pass "$container : tous les outils désinstallés"
    fi
    if docker exec "$container" sh -c "grep -q chapitre-00-terminal-stack '$home/.zshrc' 2>/dev/null"; then
        fail "$container : le bloc de config n'a pas été retiré de ~/.zshrc après --uninstall=all"
    else
        pass "$container : bloc de config retiré de ~/.zshrc"
    fi

    echo "--- [$container] garde-fou : tmux-plugins sans tmux doit échouer ---"
    if exec_script --install=tmux-plugins --yes > /dev/null 2>&1; then
        fail "$container : --install=tmux-plugins aurait dû échouer sans tmux installé"
    else
        pass "$container : garde-fou tmux-plugins -> tmux respecté"
    fi

    docker rm -f "$container" > /dev/null
}

echo "############ install-linux.sh (conteneur Debian réel) ############"
run_bash_suite "c00-test-linux-img" "Dockerfile.linux" "c00-test-linux" "/home/tester/install-linux.sh" "eza"

echo
echo "############ install-macos.sh (logique via Linuxbrew — pas une fidélité macOS complète) ############"
run_bash_suite "c00-test-macos-img" "Dockerfile.macos-logic" "c00-test-macos" "/tmp/install-macos.sh" "eza"

echo
echo "############ install-windows.ps1 (logique via faux winget — pas une vraie installation Windows) ############"
docker build -q -f "$DOCKER_TEST_DIR/Dockerfile.windows-logic" -t c00-test-windows-img "$SCRIPT_DIR" > /dev/null
docker run -d --name c00-test-windows --entrypoint sleep c00-test-windows-img infinity > /dev/null

exec_ps() { docker exec c00-test-windows pwsh -NoProfile -File /tmp/install-windows.ps1 "$@"; }

out="$(exec_ps -ListTools)"
if echo "$out" | grep -q "installé"; then
    fail "windows : un outil apparaît déjà installé au départ"
else
    pass "windows : état initial propre"
fi

exec_ps -Install starship > /dev/null
out="$(exec_ps -ListTools)"
if echo "$out" | grep "starship" | grep -q "installé"; then
    pass "windows : starship installé (simulation winget)"
else
    fail "windows : starship absent après -Install starship"
fi

exec_ps -Uninstall starship > /dev/null
out="$(exec_ps -ListTools)"
if echo "$out" | grep -q "installé"; then
    fail "windows : un outil reste installé après -Uninstall starship"
else
    pass "windows : retour à l'état propre après désinstallation unitaire"
fi

if exec_ps -Install outil-inexistant > /dev/null 2>&1; then
    fail "windows : -Install outil-inexistant aurait dû échouer"
else
    pass "windows : nom d'outil invalide correctement rejeté"
fi

docker rm -f c00-test-windows > /dev/null

echo
if [ "$FAILED" -eq 0 ]; then
    echo "✅ Toutes les vérifications sont passées."
    exit 0
else
    echo "❌ Au moins une vérification a échoué. Voir le détail ci-dessus."
    exit 1
fi
