# Glossaire

Référence rapide des termes techniques utilisés tout au long de ce cours. Ne t'inquiète pas de les mémoriser dès maintenant - reviens-y au besoin.

---

## A

### Agent

Une personnalité IA spécialisée avec une expertise dans un domaine (par exemple, frontend, sécurité). Défini dans des fichiers `.agent.md` avec un frontmatter YAML contenant au minimum un champ `description`.

### API

Application Programming Interface (interface de programmation d'application). Un moyen pour les programmes de communiquer entre eux.

### Atuin

Un remplaçant de l'historique de commandes du shell : au lieu d'une simple liste plate, il stocke l'historique dans une base de données consultable en plein écran, avec recherche floue et filtrage par répertoire. Présenté au Chapitre 00.

### Autopilot (mode autopilote)

Un mode d'exécution de Copilot CLI qui implémente une tâche sans attendre d'approbation manuelle à chaque étape, souvent combiné à `--plan` (`--plan --mode autopilot`) pour planifier automatiquement puis exécuter directement. Présenté aux Chapitres 02 et 04.

---

## B

### Bat

Un remplaçant de la commande `cat` qui ajoute la coloration syntaxique, les numéros de ligne, et une intégration git. Sur Debian, le paquet APT s'appelle `batcat`. Présenté au Chapitre 00.

---

## C

### Chronicle

La commande `/chronicle` de Copilot CLI, qui analyse l'historique de vos sessions stockées localement et en tire des rapports d'activité (`standup`), des conseils personnalisés (`tips`, `cost-tips`), une recherche ciblée (`search`) ou des suggestions pour `.github/copilot-instructions.md` (`improve`). Présentée au Chapitre 11.

### CIMD (Client ID Metadata Document)

Un mécanisme de découverte de métadonnées d'identifiant client qui permet la connexion OAuth d'un serveur MCP distant sans enregistrement manuel préalable du client. Présenté au Chapitre 07.

### CI/CD

Continuous Integration/Continuous Deployment (intégration continue/déploiement continu). Des pipelines automatisés de test et de déploiement.

### CLI

Command Line Interface (interface en ligne de commande). Une manière textuelle d'interagir avec un logiciel (comme cet outil !).

### Context Window (fenêtre de contexte)

La quantité de texte qu'une IA peut prendre en compte à la fois. Comme un bureau qui ne peut contenir qu'une certaine quantité de choses. Quand tu ajoutes des fichiers, un historique de conversation, et des prompts système, ils occupent tous de l'espace dans cette fenêtre.

### Context Manager (gestionnaire de contexte)

Une construction Python utilisant l'instruction `with` qui gère automatiquement l'initialisation et le nettoyage (comme ouvrir et fermer des fichiers). Exemple : `with open("file.txt") as f:` garantit que le fichier est fermé même en cas d'erreur.

### Conventional Commit (commit conventionnel)

Un format de message de commit qui suit une structure standardisée : `type(scope): description`. Les types courants incluent `feat` (nouvelle fonctionnalité), `fix` (correction de bug), `docs` (documentation), `refactor`, et `test`. Exemple : `feat(auth): add password reset flow`.

### Dataclass

Un décorateur Python (`@dataclass`) qui génère automatiquement `__init__`, `__repr__`, et d'autres méthodes pour les classes qui stockent principalement des données. Utilisé dans l'application de gestion de livres pour définir la classe `Book` avec des champs comme `title`, `author`, `year`, et `read`.

---

## D

### Dev Container (conteneur de développement)

Un environnement de développement décrit par un fichier `devcontainer.json` : image Docker, outils préinstallés, extensions VS Code. Garantit que toute l'équipe travaille dans un environnement identique, utilisé par GitHub Codespaces et l'extension VS Code Dev Containers. Présenté au Chapitre 10.

---

## E

### Eza

Un remplaçant moderne de la commande `ls`, avec icônes, couleurs par type de fichier, regroupement automatique des répertoires, et une vue grille pour les listes détaillées. Présenté au Chapitre 00.

---

## F

### Frontmatter

Métadonnées en haut d'un fichier Markdown, délimitées par `---`. Utilisées dans les fichiers d'agents et de compétences (skills) pour définir des propriétés comme `description` et `name` au format YAML.

### Fzf

Un outil de recherche floue (« fuzzy finder ») qui s'intègre au shell pour filtrer n'importe quelle liste — fichiers, historique, processus — en tapant quelques caractères approximatifs. Présenté au Chapitre 00.

---

## G

### Glob Pattern (motif glob)

Un motif utilisant des caractères génériques pour faire correspondre des chemins de fichiers (par exemple, `*.py` correspond à tous les fichiers Python, `*.js` correspond à tous les fichiers JavaScript).

---

## J

### JWT

JSON Web Token. Un moyen sécurisé de transmettre des informations d'authentification entre systèmes.

---

## M

### MCP

Model Context Protocol. Un standard pour connecter des assistants IA à des sources de données externes.

---

### Memory (mémoire, Copilot CLI)

Une fonctionnalité qui permet à Copilot CLI de se souvenir de faits et de préférences *à travers toutes les sessions*, pas seulement au sein d'une seule. Contrairement à l'historique de session (qui enregistre une conversation spécifique), la mémoire persiste globalement et s'applique automatiquement dans les sessions futures. Gérée avec la commande slash `/memory` (`/memory on`, `/memory off`, `/memory show`). La mémoire peut être limitée à ton compte utilisateur (visible dans tous les dépôts) ou à un dépôt spécifique (partagée avec les collaborateurs).

### Model Policy (politique de modèle)

Un champ optionnel (`model-policy`) du frontmatter d'un agent personnalisé (`.agent.md`) qui, réglé sur `required`, verrouille le choix du modèle sur la liste déclarée dans le champ `model` pendant toute l'exécution de l'agent, empêchant un changement de modèle manuel en cours de session. Présenté au Chapitre 05.

---

## N

### n8n

Un outil open source d'automatisation de workflows par blocs visuels (« nœuds ») reliés entre eux, plutôt que par du code écrit ligne par ligne. Peut être connecté à Copilot CLI via son propre serveur MCP intégré. Présenté au Chapitre 09.

### Nœud (node, n8n)

Le bloc de base d'un workflow n8n : une étape unique (déclencheur, appel d'API, filtre, mise en forme de données...) que l'on relie à d'autres nœuds pour former un workflow complet. Présenté au Chapitre 09.

### npx

Un outil Node.js qui exécute des paquets npm sans les installer globalement. Utilisé dans les configurations de serveurs MCP pour lancer des serveurs (par exemple, `npx @modelcontextprotocol/server-filesystem`).

---

## O

### OpenTelemetry (OTel)

Un standard ouvert d'observabilité (traces, métriques, logs). Copilot CLI peut exporter ses propres métriques (appels modèle, exécutions d'outils, tokens, latence), désactivé par défaut : activation via `COPILOT_OTEL_ENABLED=true`, avec un export vers un fichier local (`COPILOT_OTEL_EXPORTER_TYPE=file` + `COPILOT_OTEL_FILE_EXPORTER_PATH`) ou vers un collecteur distant (`COPILOT_OTEL_EXPORTER_TYPE=otlp-http` + `OTEL_EXPORTER_OTLP_ENDPOINT`). Présenté au Chapitre 12, comme prérequis à Tokscale.

### OWASP

Open Web Application Security Project. Une organisation qui publie des bonnes pratiques de sécurité et maintient la liste « OWASP Top 10 » des risques de sécurité les plus critiques pour les applications web.

---

## P

### PEP 8

Python Enhancement Proposal 8. Le guide de style officiel pour le code Python, couvrant les conventions de nommage (snake_case pour les fonctions, PascalCase pour les classes), l'indentation (4 espaces), et la mise en forme du code. Suivre PEP 8 rend le code Python cohérent et lisible.

### Plugins Dashboard (tableau de bord des plugins)

Une interface unifiée de Copilot CLI (depuis la v1.0.81), ouverte indifféremment via `/plugin`, `/mcp` ou `/skills` sans argument, qui liste et gère en un seul endroit les skills, agents personnalisés, serveurs MCP et plugins installés, avec leurs statuts et indicateurs de mise à jour disponible. Elle a remplacé la commande `/plugins` (au pluriel), supprimée. Présenté aux Chapitres 06 et 07.

### Pre-commit Hook (hook de pré-commit)

Un script qui s'exécute automatiquement avant chaque `git commit`. Peut être utilisé pour exécuter des revues de sécurité Copilot ou des vérifications de qualité de code avant que le code ne soit committé.

### pytest

Un framework de test Python populaire, connu pour sa syntaxe simple, ses fixtures puissantes, et son riche écosystème de plugins. Utilisé tout au long de ce cours pour tester l'application de gestion de livres. Les tests sont exécutés avec `python -m pytest tests/`.

### Programmatic Mode (mode programmatique)

Exécuter Copilot avec le drapeau `-p` pour des commandes uniques sans interaction.

---

## R

### Rate Limiting (limitation de débit)

Restrictions sur le nombre de requêtes que tu peux effectuer vers une API pendant une période donnée. Copilot peut temporairement limiter les réponses si tu dépasses le quota d'utilisation de ton forfait.

### Rewind (rembobinage)

La commande `/rewind` de Copilot CLI, qui annule une ou plusieurs étapes d'une session. Depuis la v1.0.78, elle ne nécessite plus de dépôt git, restaure uniquement les fichiers effectivement modifiés par Copilot, et propose un choix entre « conversation seule » et « conversation + fichiers ». Présentée aux Chapitres 03 et 08.

### RTK (Rust Token Killer)

Un outil tiers open source (`rtk-ai/rtk`), écrit en Rust, qui agit comme un proxy CLI : il intercepte des commandes de développement verbeuses (git, npm, cargo, pytest...), les exécute normalement, puis renvoie à l'agent une version compressée de leur sortie. Se connecte à Copilot CLI via `rtk init -g` (hook de réécriture automatique) ou via un fichier `copilot-instructions.md` fourni par le projet `rtk-for-copilot`. Commande d'analyse principale : `rtk gain`. Présenté au Chapitre 12.

---

## S

### Sandbox

Un environnement d'exécution isolé (conteneur ou microVM) qui restreint l'accès de Copilot CLI au système de fichiers et au réseau, permettant d'utiliser `--allow-all`/`--yolo` sans surveillance humaine constante. Présenté au Chapitre 10 via Docker Sandboxes (`sbx run copilot`).

### Session

Une conversation avec Copilot qui maintient le contexte et peut être reprise plus tard.

### Skill (compétence)

Un dossier contenant des instructions que Copilot charge automatiquement lorsqu'elles sont pertinentes pour ton prompt. Défini dans des fichiers `SKILL.md` avec un frontmatter YAML.

### Slash Command (commande slash)

Commandes commençant par `/` qui contrôlent Copilot (par exemple, `/help`, `/clear`, `/model`).

### Starship

Une invite de commandes (prompt) minimaliste et rapide, écrite en Rust, qui affiche automatiquement le contexte utile (répertoire, branche git, langage détecté). Présenté au Chapitre 00.

---

## T

### Tmux

Un multiplexeur de terminal : il permet de créer des sessions persistantes avec plusieurs volets (panes) dans une seule fenêtre. Une session peut être détachée puis retrouvée intacte plus tard, y compris après une déconnexion SSH. Présenté au Chapitre 00.

### Token

Une unité de texte que les modèles d'IA traitent. Environ 4 caractères ou 0,75 mot. Utilisé pour mesurer à la fois l'entrée (tes prompts et le contexte) et la sortie (les réponses de l'IA).

### Tokscale

Un outil tiers open source (`junhoyeo/tokscale`), CLI et interface terminal (TUI), qui agrège localement les journaux d'usage déjà produits par une quarantaine d'agents IA, dont Copilot CLI, pour estimer coûts et consommation de tokens. Pour Copilot CLI, il dépend de l'export OpenTelemetry local (voir [OpenTelemetry (OTel)](#opentelemetry-otel)). N'est ni un serveur MCP ni un mécanisme de facturation officiel de GitHub. Présenté au Chapitre 12.

### TPM (Tmux Plugin Manager)

Le gestionnaire de plugins de Tmux. Utilisé notamment pour installer `tmux-resurrect` (sauvegarde de l'état d'une session) et `tmux-continuum` (sauvegarde automatique périodique et restauration au démarrage). Présenté au Chapitre 00.

### Type Hints (indications de type)

Annotations Python qui indiquent les types attendus des paramètres de fonction et des valeurs de retour (par exemple, `def add_book(title: str, year: int) -> Book:`). Elles n'imposent pas les types à l'exécution mais aident à la clarté du code, au support des IDE, et aux outils d'analyse statique comme mypy.

---

## W

### Webhook

Une URL générée par un service (ici, un nœud Déclencheur n8n) qui écoute les requêtes HTTP entrantes et déclenche une action dès qu'elle en reçoit une, plutôt que d'être interrogée activement. Présenté au Chapitre 09.

### WCAG

Web Content Accessibility Guidelines (règles pour l'accessibilité des contenus web). Normes publiées par le W3C pour rendre le contenu web accessible aux personnes en situation de handicap. WCAG 2.1 AA est un objectif de conformité courant.

### Worktree

Une copie de travail git additionnelle, associée à sa propre branche et disposant de son propre dossier sur disque, qui permet d'isoler une session Copilot CLI (via `/worktree new` ou `--worktree`) sans changer de branche dans le répertoire de travail principal. Présenté aux Chapitres 02, 04 et 08.

---

## Y

### YAML

YAML Ain't Markup Language. Un format de données lisible par les humains utilisé pour la configuration. Dans ce cours, le YAML apparaît dans le frontmatter des agents et des compétences (le bloc délimité par `---` en haut des fichiers `.agent.md` et `SKILL.md`).

---

## Z

### Zoxide

Un remplaçant intelligent de `cd` qui retient la fréquence et la récence de vos déplacements, pour sauter directement vers un projet fréquent avec quelques lettres (`z monrepo`). Présenté au Chapitre 00.

### zsh

Un shell Unix alternatif à bash, offrant une autocomplétion plus riche et un écosystème de plugins plus étendu (suggestions, coloration syntaxique, thèmes). Socle de la stack terminal présentée au Chapitre 00.
