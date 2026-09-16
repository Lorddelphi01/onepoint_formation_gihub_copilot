#!/usr/bin/env bash
# Installe la stack terminal moderne du Chapitre 00 sur Linux / WSL Debian.
# Adapté de https://github.com/Lorddelphi01/outils-ia (install_wsl_debian.sh).
set -euo pipefail

echo "🚀 Installation de la stack terminal moderne (Linux / WSL Debian)..."

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

# --- 1. Prérequis : git, curl, zsh ---
echo "📦 Installation des prérequis : git, curl, zsh, wget, gpg..."
sudo apt update && sudo apt install -y git curl zsh wget gpg

# --- 2. zsh comme shell par défaut ---
echo "🐚 Changement du shell par défaut vers zsh..."
chsh -s "$(command -v zsh)"

# --- 3. Paquets disponibles via apt ---
echo "📦 Installation de tmux et bat..."
sudo apt install -y tmux bat

# Sur Debian, le paquet s'installe sous le nom 'batcat' : symlink pour cohérence.
mkdir -p ~/.local/bin
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    ln -sf "$(command -v batcat)" ~/.local/bin/bat
fi

# --- 4. eza via le dépôt officiel ---
echo "📦 Installation d'eza (remplacement moderne de ls)..."
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
sudo apt update && sudo apt install -y eza

# --- 5. fzf via git (génère ~/.fzf.zsh) ---
echo "🔍 Installation de fzf via git..."
if [ ! -d "$HOME/.fzf/.git" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
fi

# --- 6. starship, zoxide, atuin via leurs scripts officiels ---
echo "⭐ Installation de Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

echo "📂 Installation de Zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "🕰️  Installation d'Atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# --- 7. Plugins zsh (autosuggestions, syntax-highlighting) ---
echo "🔌 Installation des plugins zsh..."
mkdir -p ~/.zsh

if [ ! -d "$HOME/.zsh/zsh-autosuggestions/.git" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting/.git" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# --- 8. ~/.zshrc ---
echo "📝 Écriture de ~/.zshrc..."
append_managed_block "$HOME/.zshrc" "# BEGIN chapitre-00-terminal-stack" "# END chapitre-00-terminal-stack" << 'EOF'
# BEGIN chapitre-00-terminal-stack
# --- Variables d'environnement ---
export LANG=en_US.UTF-8
export EDITOR='nvim' # ou 'nano', 'code --wait', etc.

# --- PATH (binaires locaux : zoxide, atuin, starship sur Linux) ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

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
command -v bat &>/dev/null && alias cat='bat' || alias cat='batcat'
alias cd='z'                                     # Fait de 'cd' un saut intelligent via Zoxide
alias g='git'                                    # Raccourci pour Git

# --- Raccourcis clavier ---
bindkey '^[[A' atuin-up-search
# END chapitre-00-terminal-stack
EOF

# --- 9. Tmux + TPM ---
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
echo "1. Installez la police Anka/Coder côté Windows (pas dans WSL) :"
echo "   https://github.com/nicktindall/Anka-Coder-Font"
echo "   puis sélectionnez-la dans Windows Terminal ou Ghostty."
echo "2. Ouvrez une nouvelle session (ou lancez 'exec zsh') pour activer zsh."
echo "3. Tapez 'tmux' pour démarrer votre première session persistante."
