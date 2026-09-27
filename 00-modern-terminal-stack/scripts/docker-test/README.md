# Tests Docker des scripts d'installation (Chapitre 00)

Outil de développement **local uniquement** (non branché dans `.github/workflows/`) pour valider
`install-linux.sh`, `install-macos.sh` et `install-windows.ps1` dans des conteneurs jetables, sans
jamais toucher à la machine de la personne qui développe.

## Usage

```bash
bash 00-modern-terminal-stack/scripts/docker-test/run-tests.sh
```

Nécessite Docker. Le script construit trois images, exécute une séquence de vérifications
(liste initiale, installation d'un outil unique, désinstallation de ce même outil, installation
globale, désinstallation globale, garde-fou de dépendance `tmux-plugins` → `tmux`), puis nettoie les
conteneurs. Il termine en erreur (`exit 1`) si une vérification échoue.

## Fidélité par plateforme

| Conteneur | Base | Fidélité |
|---|---|---|
| `Dockerfile.linux` | `debian:bookworm-slim` + utilisateur non root avec sudo | **Réelle** : exécute `install-linux.sh` tel quel, cible proche d'une vraie session WSL Debian. |
| `Dockerfile.macos-logic` | image officielle `homebrew/brew` (Linuxbrew) | **Logique uniquement** : `brew install`/`brew uninstall` fonctionnent réellement, mais ce n'est pas macOS (zsh n'y est pas le shell par défaut). Valide le menu, les flags et la génération des blocs de config, pas l'expérience macOS complète. |
| `Dockerfile.windows-logic` | `mcr.microsoft.com/powershell` + faux `winget` (`fake-winget.sh`) | **Logique uniquement** : le faux `winget` simule l'installation/désinstallation en créant/supprimant des exécutables factices, ce qui permet de tester le menu, les paramètres et la régénération du bloc de profil — mais ne valide jamais une vraie installation Windows ni les identifiants winget réels. |

Avant de fusionner un changement touchant à ces trois scripts, exécutez `run-tests.sh` puis faites si
possible un test manuel unique sur une vraie machine par plateforme concernée par le changement.
