#!/usr/bin/env bash
# Installe/désinstalle la stack terminal moderne du Chapitre 00 sur Linux / WSL Debian,
# outil par outil ou en une seule fois, via un menu interactif ou des flags scriptables.
# Adapté de https://github.com/Lorddelphi01/outils-ia (install_wsl_debian.sh).
set -euo pipefail

readonly MARK_BEGIN="# BEGIN chapitre-00-terminal-stack"
readonly MARK_END="# END chapitre-00-terminal-stack"

TOOLS_ORDER=(zsh starship atuin zoxide fzf eza bat zsh-autosuggestions zsh-syntax-highlighting tmux tmux-plugins)

ASSUME_YES=0
_prereqs_ready=0

usage() {
    cat <<USAGE
Usage : install-linux.sh [option]

Sans option, ouvre un menu interactif.

Options :
  --list                    Affiche l'état (installé/absent) de chaque outil.
  --install=<outil|all>     Installe un outil précis, ou "all" pour tous.
  --uninstall=<outil|all>   Désinstalle un outil précis, ou "all" pour tous.
  --yes                     Ne pose pas de question de confirmation.
  -h, --help                Affiche cette aide.

Outils disponibles : ${TOOLS_ORDER[*]}
USAGE
}

# --- Bloc de config géré (~/.zshrc, ~/.tmux.conf) ---

write_managed_block() {
    local file="$1"
    local content="$2"
    touch "$file"
    awk -v begin="$MARK_BEGIN" -v end="$MARK_END" '
        index($0, begin) == 1 { skip = 1; next }
        skip && index($0, end) == 1 { skip = 0; next }
        !skip { print }
    ' "$file" > "${file}.tmp"
    if [ -n "$content" ]; then
        printf '%s\n' "$content" >> "${file}.tmp"
    fi
    mv "${file}.tmp" "$file"
}

any_tool_installed() {
    local t
    for t in "${TOOLS_ORDER[@]}"; do
        tool_is_installed "$t" && return 0
    done
    return 1
}

render_zshrc_block() {
    any_tool_installed || return 0

    printf '%s\n' "$MARK_BEGIN"
    cat <<'BLOCK'
# --- Variables d'environnement ---
export LANG=en_US.UTF-8
export EDITOR='nvim' # ou 'nano', 'code --wait', etc.

# --- PATH (binaires locaux : zoxide, atuin, starship sur Linux) ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
BLOCK

    if tool_is_installed zsh-autosuggestions || tool_is_installed zsh-syntax-highlighting; then
        printf '\n# --- Chargement des plugins zsh ---\n'
        tool_is_installed zsh-autosuggestions && printf 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh\n'
        tool_is_installed zsh-syntax-highlighting && printf 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh\n'
    fi

    if tool_is_installed starship || tool_is_installed zoxide || tool_is_installed atuin; then
        printf '\n# --- Initialisation des outils ---\n'
        tool_is_installed starship && printf 'eval "$(starship init zsh)" # Prompt minimaliste et rapide\n'
        tool_is_installed zoxide && printf 'eval "$(zoxide init zsh)"   # cd intelligent via Zoxide\n'
        tool_is_installed atuin && printf 'eval "$(atuin init zsh)"    # Historique de shell consultable\n'
    fi

    if tool_is_installed fzf; then
        printf '\n# --- Raccourcis et complétion fzf ---\n'
        printf '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh\n'
    fi

    printf '\n# --- Alias CLI modernes ---\n'
    if tool_is_installed eza; then
        printf "alias ls='eza --icons --group-directories-first' # 'ls' avec icônes et meilleur regroupement\n"
        printf "alias ll='eza -lh --icons --grid'                # 'ls -l' avec icônes et vue grille\n"
    fi
    tool_is_installed bat && printf "command -v bat &>/dev/null && alias cat='bat' || alias cat='batcat'\n"
    tool_is_installed zoxide && printf "alias cd='z'                                     # Fait de 'cd' un saut intelligent via Zoxide\n"
    printf "alias g='git'                                     # Raccourci pour Git\n"

    if tool_is_installed atuin; then
        printf '\n# --- Raccourcis clavier ---\n'
        printf "bindkey '^[[A' atuin-up-search\n"
    fi

    printf '%s\n' "$MARK_END"
}

render_tmux_conf_block() {
    tool_is_installed tmux || return 0

    printf '%s\n' "$MARK_BEGIN"
    cat <<'BLOCK'
set -g default-terminal "screen-256color" # Active les 256 couleurs
set -g mouse on                           # Active la souris pour redimensionner/défiler
set -s escape-time 0                      # Réduit le délai de la touche Échap (important pour Vim)
set -g history-limit 10000                # Augmente le tampon de défilement

bind | split-window -h -c "#{pane_current_path}" # Division verticale
bind - split-window -v -c "#{pane_current_path}" # Division horizontale
unbind '"'
unbind %

bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
BLOCK

    if tool_is_installed tmux-plugins; then
        printf '\n'
        printf "set -g @plugin 'tmux-plugins/tpm'            # Le gestionnaire de plugins Tmux lui-même\n"
        printf "set -g @plugin 'tmux-plugins/tmux-resurrect'  # Sauvegarde et restauration de l'environnement Tmux\n"
        printf "set -g @plugin 'tmux-plugins/tmux-continuum'  # Sauvegarde continue de l'environnement Tmux\n"
        printf "\nset -g @continuum-restore 'on'\n"
        printf "\n# Initialise TPM. Cette ligne DOIT être à la toute fin de .tmux.conf\n"
        printf "run '~/.tmux/plugins/tpm/tpm'\n"
    fi

    printf '%s\n' "$MARK_END"
}

apply_zshrc() { write_managed_block "$HOME/.zshrc" "$(render_zshrc_block)"; }
apply_tmux_conf() { write_managed_block "$HOME/.tmux.conf" "$(render_tmux_conf_block)"; }

# --- Prérequis système ---

ensure_prereqs() {
    [ "$_prereqs_ready" = 1 ] && return 0
    echo "📦 Vérification des prérequis système (git, curl, wget, gpg)..."
    sudo apt-get update
    sudo apt-get install -y git curl wget gpg
    _prereqs_ready=1
}

# --- Détection d'installation ---

# starship/atuin/zoxide s'installent chacun dans leur propre répertoire
# (~/.local/bin, ~/.atuin/bin...) que leurs installeurs ajoutent au PATH via
# ~/.zshrc — invisible pour ce script lui-même (bash non interactif, qui ne
# source pas .zshrc). On vérifie donc aussi ces chemins connus en plus de
# 'command -v', sans quoi le script se croit désinstallé juste après install.
locate_binary() {
    local name="$1" fallback="${2:-}"
    local p
    p="$(command -v "$name" 2> /dev/null)" && { printf '%s\n' "$p"; return 0; }
    if [ -n "$fallback" ] && [ -x "$fallback" ]; then
        printf '%s\n' "$fallback"
        return 0
    fi
    return 1
}

tool_is_installed() {
    case "$1" in
        zsh) command -v zsh &> /dev/null ;;
        starship) locate_binary starship "$HOME/.local/bin/starship" > /dev/null ;;
        atuin) locate_binary atuin "$HOME/.atuin/bin/atuin" > /dev/null ;;
        zoxide) locate_binary zoxide "$HOME/.local/bin/zoxide" > /dev/null ;;
        fzf) [ -d "$HOME/.fzf/.git" ] ;;
        eza) command -v eza &> /dev/null ;;
        bat) command -v bat &> /dev/null || command -v batcat &> /dev/null ;;
        zsh-autosuggestions) [ -d "$HOME/.zsh/zsh-autosuggestions/.git" ] ;;
        zsh-syntax-highlighting) [ -d "$HOME/.zsh/zsh-syntax-highlighting/.git" ] ;;
        tmux) command -v tmux &> /dev/null ;;
        tmux-plugins) [ -d "$HOME/.tmux/plugins/tpm/.git" ] ;;
        *) return 1 ;;
    esac
}

remove_binary() {
    local name="$1" fallback="${2:-}"
    local bin_path
    bin_path="$(locate_binary "$name" "$fallback")" || return 0
    if [ -w "$(dirname "$bin_path")" ]; then
        rm -f "$bin_path"
    else
        sudo rm -f "$bin_path"
    fi
}

# --- Installation par outil ---

install_zsh() {
    if tool_is_installed zsh; then echo "✅ zsh est déjà installé."; return 0; fi
    echo "📦 Installation de zsh..."
    sudo apt-get install -y zsh
    echo "🐚 Changement du shell par défaut vers zsh..."
    # Passe par sudo (plutôt que 'chsh' en direct) : root peut changer le shell
    # d'un utilisateur sans repasser par une authentification PAM de ce compte.
    sudo chsh -s "$(command -v zsh)" "$(whoami)"
}

install_starship() {
    if tool_is_installed starship; then echo "✅ Starship est déjà installé."; return 0; fi
    echo "⭐ Installation de Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_atuin() {
    if tool_is_installed atuin; then echo "✅ Atuin est déjà installé."; return 0; fi
    echo "🕰️  Installation d'Atuin..."
    # --non-interactive : sans elle, l'installeur attend une réponse au prompt
    # "configurer le shell automatiquement ?" — absent d'un terminal (Docker,
    # CI...), ce qui coupe le pipe et fait échouer curl silencieusement.
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
}

install_zoxide() {
    if tool_is_installed zoxide; then echo "✅ Zoxide est déjà installé."; return 0; fi
    echo "📂 Installation de Zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_fzf() {
    if tool_is_installed fzf; then echo "✅ fzf est déjà installé."; return 0; fi
    echo "🔍 Installation de fzf via git..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
}

install_eza() {
    if tool_is_installed eza; then echo "✅ eza est déjà installé."; return 0; fi
    echo "📦 Installation d'eza (remplacement moderne de ls)..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
    sudo apt-get update && sudo apt-get install -y eza
}

install_bat() {
    if tool_is_installed bat; then echo "✅ bat est déjà installé."; return 0; fi
    echo "📦 Installation de bat..."
    sudo apt-get install -y bat
    # Sur Debian, le paquet s'installe sous le nom 'batcat' : symlink pour cohérence.
    mkdir -p ~/.local/bin
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        ln -sf "$(command -v batcat)" ~/.local/bin/bat
    fi
}

install_zsh_autosuggestions() {
    if tool_is_installed zsh-autosuggestions; then echo "✅ zsh-autosuggestions est déjà installé."; return 0; fi
    echo "🔌 Installation de zsh-autosuggestions..."
    mkdir -p ~/.zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
}

install_zsh_syntax_highlighting() {
    if tool_is_installed zsh-syntax-highlighting; then echo "✅ zsh-syntax-highlighting est déjà installé."; return 0; fi
    echo "🔌 Installation de zsh-syntax-highlighting..."
    mkdir -p ~/.zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
}

install_tmux() {
    if tool_is_installed tmux; then echo "✅ tmux est déjà installé."; return 0; fi
    echo "📦 Installation de tmux..."
    sudo apt-get install -y tmux
}

install_tmux_plugins() {
    if ! tool_is_installed tmux; then
        echo "⚠️  tmux doit être installé avant tmux-plugins (--install=tmux)." >&2
        return 1
    fi
    if tool_is_installed tmux-plugins; then echo "✅ tmux-plugins (TPM) est déjà installé."; return 0; fi
    echo "🪟 Installation de TPM (gestionnaire de plugins tmux)..."
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # TPM lit les lignes '@plugin' de .tmux.conf : on régénère le fichier avant de l'exécuter.
    apply_tmux_conf
    echo "⚙️  Installation automatique des plugins tmux (resurrect, continuum)..."
    ~/.tmux/plugins/tpm/bin/install_plugins
}

# --- Désinstallation par outil ---

uninstall_zsh() {
    if ! tool_is_installed zsh; then echo "⬜ zsh n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de zsh..."
    sudo apt-get remove -y zsh
    echo "ℹ️  Le shell par défaut n'est pas modifié automatiquement ; utilisez 'chsh -s /bin/bash' si besoin."
}

uninstall_starship() {
    if ! tool_is_installed starship; then echo "⬜ Starship n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de Starship..."
    remove_binary starship "$HOME/.local/bin/starship"
}

uninstall_atuin() {
    if ! tool_is_installed atuin; then echo "⬜ Atuin n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation d'Atuin..."
    echo "ℹ️  L'historique chiffré local (~/.local/share/atuin ou ~/.atuin) est conservé."
    remove_binary atuin "$HOME/.atuin/bin/atuin"
}

uninstall_zoxide() {
    if ! tool_is_installed zoxide; then echo "⬜ Zoxide n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de Zoxide..."
    remove_binary zoxide "$HOME/.local/bin/zoxide"
}

uninstall_fzf() {
    if ! tool_is_installed fzf; then echo "⬜ fzf n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de fzf..."
    # Le script ~/.fzf/uninstall varie selon les versions (options différentes
    # selon l'âge du clone) : on supprime directement les fichiers connus
    # plutôt que de dépendre de son interface, moins stable.
    rm -rf "$HOME/.fzf" "$HOME/.fzf.zsh" "$HOME/.fzf.bash"
}

uninstall_eza() {
    if ! tool_is_installed eza; then echo "⬜ eza n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation d'eza..."
    sudo apt-get remove -y eza
    sudo rm -f /etc/apt/sources.list.d/gierens.list /etc/apt/keyrings/gierens.gpg
}

uninstall_bat() {
    if ! tool_is_installed bat; then echo "⬜ bat n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de bat..."
    sudo apt-get remove -y bat
    rm -f "$HOME/.local/bin/bat"
}

uninstall_zsh_autosuggestions() {
    if ! tool_is_installed zsh-autosuggestions; then echo "⬜ zsh-autosuggestions n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de zsh-autosuggestions..."
    rm -rf "$HOME/.zsh/zsh-autosuggestions"
}

uninstall_zsh_syntax_highlighting() {
    if ! tool_is_installed zsh-syntax-highlighting; then echo "⬜ zsh-syntax-highlighting n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de zsh-syntax-highlighting..."
    rm -rf "$HOME/.zsh/zsh-syntax-highlighting"
}

uninstall_tmux() {
    if tool_is_installed tmux-plugins; then
        echo "⚠️  tmux-plugins (TPM) dépend de tmux : désinstallez-le d'abord (--uninstall=tmux-plugins)." >&2
        return 1
    fi
    if ! tool_is_installed tmux; then echo "⬜ tmux n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de tmux..."
    sudo apt-get remove -y tmux
}

uninstall_tmux_plugins() {
    if ! tool_is_installed tmux-plugins; then echo "⬜ tmux-plugins n'est pas installé."; return 0; fi
    echo "🗑️  Désinstallation de tmux-plugins (TPM)..."
    rm -rf "$HOME/.tmux/plugins"
}

# --- Dispatch générique ---

tool_install() {
    local tool="$1"
    ensure_prereqs
    case "$tool" in
        zsh) install_zsh ;;
        starship) install_starship ;;
        atuin) install_atuin ;;
        zoxide) install_zoxide ;;
        fzf) install_fzf ;;
        eza) install_eza ;;
        bat) install_bat ;;
        zsh-autosuggestions) install_zsh_autosuggestions ;;
        zsh-syntax-highlighting) install_zsh_syntax_highlighting ;;
        tmux) install_tmux ;;
        tmux-plugins) install_tmux_plugins ;;
        *) echo "❌ Outil inconnu : $tool" >&2; return 1 ;;
    esac
}

tool_uninstall() {
    local tool="$1"
    case "$tool" in
        zsh) uninstall_zsh ;;
        starship) uninstall_starship ;;
        atuin) uninstall_atuin ;;
        zoxide) uninstall_zoxide ;;
        fzf) uninstall_fzf ;;
        eza) uninstall_eza ;;
        bat) uninstall_bat ;;
        zsh-autosuggestions) uninstall_zsh_autosuggestions ;;
        zsh-syntax-highlighting) uninstall_zsh_syntax_highlighting ;;
        tmux) uninstall_tmux ;;
        tmux-plugins) uninstall_tmux_plugins ;;
        *) echo "❌ Outil inconnu : $tool" >&2; return 1 ;;
    esac
}

is_known_tool() {
    local t
    for t in "${TOOLS_ORDER[@]}"; do
        [ "$t" = "$1" ] && return 0
    done
    return 1
}

do_install_all() {
    local t
    for t in "${TOOLS_ORDER[@]}"; do tool_install "$t"; done
    apply_zshrc
    apply_tmux_conf
}

do_uninstall_all() {
    local t
    for ((i = ${#TOOLS_ORDER[@]} - 1; i >= 0; i--)); do
        t="${TOOLS_ORDER[i]}"
        tool_uninstall "$t"
    done
    apply_zshrc
    apply_tmux_conf
}

# --- Interface utilisateur ---

confirm() {
    if [ "$ASSUME_YES" = 1 ]; then return 0; fi
    local reply
    read -r -p "$1 [o/N] " reply
    case "$reply" in
        o | O | oui | Oui | y | Y | yes | Yes) return 0 ;;
        *) return 1 ;;
    esac
}

print_status_list() {
    echo "Outil                        État"
    echo "----------------------------------"
    local t
    for t in "${TOOLS_ORDER[@]}"; do
        if tool_is_installed "$t"; then
            printf "✅ %-26s installé\n" "$t"
        else
            printf "⬜ %-26s absent\n" "$t"
        fi
    done
}

print_footer() {
    echo "----------------------------------------------------"
    echo "1. Installez la police Anka/Coder côté Windows (pas dans WSL) :"
    echo "   https://github.com/nicktindall/Anka-Coder-Font"
    echo "   puis sélectionnez-la dans Windows Terminal ou Ghostty."
    echo "2. Ouvrez une nouvelle session (ou lancez 'exec zsh') pour activer les changements."
    echo "3. Tapez 'tmux' pour démarrer votre première session persistante."
}

run_interactive_menu() {
    local choice tool
    while true; do
        echo
        echo "==== Stack terminal moderne — Chapitre 00 ===="
        local i=1
        for t in "${TOOLS_ORDER[@]}"; do
            if tool_is_installed "$t"; then
                printf "  %2d) ✅ %s (installé)\n" "$i" "$t"
            else
                printf "  %2d) ⬜ %s (absent)\n" "$i" "$t"
            fi
            i=$((i + 1))
        done
        echo "   a) Installer tous les outils"
        echo "   u) Désinstaller tous les outils"
        echo "   q) Quitter"
        read -r -p "Votre choix : " choice
        case "$choice" in
            a | A) do_install_all ;;
            u | U)
                if confirm "Désinstaller TOUS les outils ?"; then do_uninstall_all; else echo "Annulé."; fi
                ;;
            q | Q) break ;;
            '' | *[!0-9]*) echo "Choix invalide." ;;
            *)
                if [ "$choice" -ge 1 ] && [ "$choice" -le "${#TOOLS_ORDER[@]}" ]; then
                    tool="${TOOLS_ORDER[$((choice - 1))]}"
                    if tool_is_installed "$tool"; then
                        if confirm "Désinstaller $tool ?"; then
                            tool_uninstall "$tool" && { apply_zshrc; apply_tmux_conf; }
                        else
                            echo "Annulé."
                        fi
                    else
                        tool_install "$tool" && { apply_zshrc; apply_tmux_conf; }
                    fi
                else
                    echo "Choix invalide."
                fi
                ;;
        esac
    done
    print_footer
}

# --- Point d'entrée ---

ACTION=""
TARGET=""

for arg in "$@"; do
    case "$arg" in
        --list) ACTION="list" ;;
        --install=*) ACTION="install"; TARGET="${arg#--install=}" ;;
        --uninstall=*) ACTION="uninstall"; TARGET="${arg#--uninstall=}" ;;
        --yes) ASSUME_YES=1 ;;
        -h | --help) usage; exit 0 ;;
        *)
            echo "❌ Option inconnue : $arg" >&2
            usage
            exit 1
            ;;
    esac
done

echo "🚀 Stack terminal moderne — Chapitre 00 (Linux / WSL Debian)"

case "$ACTION" in
    list)
        print_status_list
        ;;
    install)
        if [ "$TARGET" = "all" ]; then
            do_install_all
            print_footer
        elif is_known_tool "$TARGET"; then
            tool_install "$TARGET"
            apply_zshrc
            apply_tmux_conf
        else
            echo "❌ Outil inconnu : $TARGET" >&2
            usage
            exit 1
        fi
        ;;
    uninstall)
        if [ "$TARGET" = "all" ]; then
            if [ "$ASSUME_YES" = 1 ] || confirm "Désinstaller TOUS les outils ?"; then
                do_uninstall_all
            else
                echo "Annulé."
            fi
        elif is_known_tool "$TARGET"; then
            tool_uninstall "$TARGET"
            apply_zshrc
            apply_tmux_conf
        else
            echo "❌ Outil inconnu : $TARGET" >&2
            usage
            exit 1
        fi
        ;;
    "")
        if [ -t 0 ]; then
            run_interactive_menu
        else
            echo "Aucune option fournie et entrée standard non interactive." >&2
            usage
            exit 1
        fi
        ;;
esac
