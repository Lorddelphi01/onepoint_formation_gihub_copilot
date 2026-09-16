#!/usr/bin/env bash
# Installe la stack terminal moderne du Chapitre 00 sur macOS.
# Adapté de https://github.com/Lorddelphi01/outils-ia (install_mac.sh) :
# l'installation de Ghostty et de la police Anka/Coder (Homebrew Cask) a été
# retirée car elle sort du périmètre des 11 outils documentés dans ce chapitre.
set -euo pipefail

echo "🚀 Installation de la stack terminal moderne (macOS)..."

append_managed_block() {
    local file="$1"
    local begin="$2"
    local end="$3"
    local block
    block="$(mktemp)"
    cat > "$block"
    touch "$file"
    awk -v begin="$begin" -v end="$end" '
        index($0, begin) == 1 { skip = 1; next }
        skip && index($0, end) == 1 { skip = 0; next }
        !skip { print }
    ' "$file" > "${file}.tmp"
    cat "$block" >> "${file}.tmp"
    mv "${file}.tmp" "$file"
    rm -f "$block"
}

# --- 1. Homebrew ---
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew introuvable, installation..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew déjà installé."
fi

# --- 2. Outils principaux ---
echo "📦 Installation de tmux, atuin, starship, zoxide, fzf, eza, bat..."
brew install tmux atuin zoxide fzf eza bat starship

# --- 3. Plugins zsh (autosuggestions, syntax-highlighting) ---
echo "🔌 Installation des plugins zsh..."
mkdir -p ~/.zsh

if [ ! -d "$HOME/.zsh/zsh-autosuggestions/.git" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting/.git" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# --- 4. ~/.zshrc ---
echo "📝 Écriture de ~/.zshrc..."
append_managed_block "$HOME/.zshrc" "# BEGIN chapitre-00-terminal-stack" "# END chapitre-00-terminal-stack" << 'EOF'
# BEGIN chapitre-00-terminal-stack
# --- Variables d'environnement ---
export LANG=en_US.UTF-8
export EDITOR='nvim' # ou 'nano', 'code --wait', etc.

# --- Chargement des plugins zsh ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Initialisation des outils ---
eval "$(starship init zsh)" # Prompt minimaliste et rapide
eval "$(zoxide init zsh)"   # 'cd' intelligent
eval "$(atuin init zsh)"    # Historique de shell consultable

# --- Raccourcis et complétion fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Alias CLI modernes ---
alias ls='eza --icons --group-directories-first' # 'ls' avec icônes et meilleur regroupement
alias ll='eza -lh --icons --grid'                # 'ls -l' avec icônes et vue grille
alias cat='bat'                                  # 'cat' avec coloration syntaxique
alias cd='z'                                     # Fait de 'cd' un saut intelligent via Zoxide
alias g='git'                                    # Raccourci pour Git

# --- Raccourcis clavier ---
bindkey '^[[A' atuin-up-search
# END chapitre-00-terminal-stack
EOF

# --- 5. Tmux + TPM ---
echo "🪟 Écriture de ~/.tmux.conf et installation de TPM..."
mkdir -p ~/.tmux/plugins

if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

append_managed_block "$HOME/.tmux.conf" "# BEGIN chapitre-00-terminal-stack" "# END chapitre-00-terminal-stack" << 'EOF'
# BEGIN chapitre-00-terminal-stack
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

set -g @plugin 'tmux-plugins/tpm'            # Le gestionnaire de plugins Tmux lui-même
set -g @plugin 'tmux-plugins/tmux-resurrect'  # Sauvegarde et restauration de l'environnement Tmux
set -g @plugin 'tmux-plugins/tmux-continuum'  # Sauvegarde continue de l'environnement Tmux

set -g @continuum-restore 'on'

# Initialise TPM. Cette ligne DOIT être à la toute fin de .tmux.conf
run '~/.tmux/plugins/tpm/tpm'
# END chapitre-00-terminal-stack
EOF

echo "⚙️  Installation automatique des plugins tmux..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "----------------------------------------------------"
echo "✅ Installation terminée !"
echo "----------------------------------------------------"
echo "1. Ouvrez un nouveau terminal (zsh est déjà votre shell par défaut sur macOS)."
echo "2. Tapez 'source ~/.zshrc' pour charger la configuration immédiatement."
echo "3. Tapez 'tmux' pour démarrer votre première session persistante."
