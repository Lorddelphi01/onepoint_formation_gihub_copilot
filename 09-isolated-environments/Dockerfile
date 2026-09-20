FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    SHELL=/bin/zsh \
    PATH=/root/.atuin/bin:/root/.local/bin:/root/.fzf/bin:$PATH

# --- Paquets de base ---
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git gnupg ca-certificates wget \
        zsh tmux \
    && rm -rf /var/lib/apt/lists/*

# --- Node.js (dépôt NodeSource — requis par `npm install -g @github/copilot`) ---
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# --- GitHub CLI (dépôt apt officiel cli.github.com) ---
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -nv -O /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# --- GitHub Copilot CLI ---
# Le paquet binaire spécifique à la plateforme (ex. @github/copilot-linux-x64) est une
# dépendance npm "optionnelle" : si sa récupération échoue sur un réseau instable, `npm
# install` ne remonte PAS d'erreur — il installe silencieusement un `copilot` cassé. On
# tente donc l'installation une première fois sans bloquer sur un échec (`|| true`), une
# seconde fois pour de bon (le cache npm du premier essai la rend quasi instantanée), puis
# on vérifie explicitement avec `copilot --version` pour faire échouer le build si besoin.
RUN npm install -g @github/copilot --fetch-retries=5 --fetch-retry-mintimeout=2000 || true \
    && npm install -g @github/copilot --fetch-retries=5 --fetch-retry-mintimeout=2000 \
    && copilot --version

# --- Starship, Atuin, zoxide (scripts d'installation officiels — identiques au Chapitre 00) ---
# Ces trois scripts téléchargent un binaire précompilé depuis les releases GitHub, ce qui
# peut occasionnellement rester bloqué plusieurs minutes sur un réseau instable avant
# d'échouer — pire, un `curl ... | sh` avale silencieusement un échec de curl (le code de
# sortie du pipe est celui de `sh`, pas de `curl` : un script vide "réussit" sans rien
# installer). On télécharge donc chaque script séparément, on l'exécute avec un timeout
# borné à 90s et jusqu'à 3 tentatives, puis on vérifie explicitement le binaire installé.
RUN curl -sS https://starship.rs/install.sh -o /tmp/install.sh \
    && ( for i in 1 2 3; do \
           timeout 90 sh /tmp/install.sh --yes && break; \
           echo "Tentative $i (Starship) échouée, nouvel essai..."; \
         done ) \
    && rm -f /tmp/install.sh && command -v starship

RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh -o /tmp/install.sh \
    && ( for i in 1 2 3; do \
           timeout 90 sh /tmp/install.sh --non-interactive && break; \
           echo "Tentative $i (Atuin) échouée, nouvel essai..."; \
         done ) \
    && rm -f /tmp/install.sh && command -v atuin

RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh -o /tmp/install.sh \
    && ( for i in 1 2 3; do \
           timeout 90 sh /tmp/install.sh && break; \
           echo "Tentative $i (zoxide) échouée, nouvel essai..."; \
         done ) \
    && rm -f /tmp/install.sh && command -v zoxide

# --- fzf ---
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --all --no-bash --no-fish

# --- eza (dépôt apt dédié — identique au Chapitre 00) ---
RUN mkdir -p /etc/apt/keyrings \
    && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        > /etc/apt/sources.list.d/gierens.list \
    && apt-get update && apt-get install -y eza \
    && rm -rf /var/lib/apt/lists/*

# --- bat (le paquet Debian s'appelle `batcat`) ---
RUN apt-get update && apt-get install -y bat && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/local/bin \
    && ln -sf "$(which batcat)" /usr/local/bin/bat

# --- zsh-autosuggestions + zsh-syntax-highlighting (l'ordre de source compte) ---
RUN mkdir -p ~/.zsh \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# --- TPM + tmux-resurrect + tmux-continuum ---
RUN mkdir -p ~/.tmux/plugins \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# --- Configuration shell (~/.zshrc), identique au Chapitre 00 ---
RUN { \
      echo 'eval "$(starship init zsh)"'; \
      echo 'eval "$(atuin init zsh)"'; \
      echo 'eval "$(zoxide init zsh)"'; \
      echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'; \
      echo "alias ls='eza --icons --group-directories-first'"; \
      echo "alias ll='eza -lh --icons --grid'"; \
      echo 'command -v bat >/dev/null && alias cat=bat'; \
      echo "alias cd='z'"; \
      echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh'; \
      echo 'source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'; \
    } >> ~/.zshrc

# --- Configuration tmux (~/.tmux.conf), plugins déclarés — installation via `prefix + I` au premier lancement ---
RUN { \
      echo 'set -g default-terminal "screen-256color"'; \
      echo 'set -g mouse on'; \
      echo 'set -sg escape-time 0'; \
      echo 'set -g history-limit 10000'; \
      echo "set -g @plugin 'tmux-plugins/tpm'"; \
      echo "set -g @plugin 'tmux-plugins/tmux-resurrect'"; \
      echo "set -g @plugin 'tmux-plugins/tmux-continuum'"; \
      echo "set -g @continuum-restore 'on'"; \
      echo "run '~/.tmux/plugins/tpm/tpm'"; \
    } >> ~/.tmux.conf

WORKDIR /workspace
CMD ["zsh"]
