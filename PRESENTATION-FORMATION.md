---
marp: true
theme: default
paginate: true
size: 16:9
lang: fr
title: Formation GitHub Copilot CLI
---

<!-- _paginate: false -->

# Formation GitHub Copilot CLI
## Du terminal nu à l'automatisation IA de bout en bout

**Public** : débutants en IA/ML, à l'aise avec un terminal et Git
**Durée totale** : ~19h (9h de tronc commun + ~10h de modules bonus)
**Format** : présentation + démonstrations + TP guidés sur une app exemple (gestion de bibliothèque)

---

# Objectifs pédagogiques globaux

À l'issue de la formation, les apprenants sauront :

- Utiliser GitHub Copilot CLI dans ses 3 modes (Interactive, Plan, Programmatic)
- Fournir le bon **contexte** (`@`, sessions, fenêtre de contexte) pour des réponses fiables
- Appliquer les workflows de dev courants (revue, refactoring, debug, tests, Git/PR)
- Créer des **agents personnalisés** et des **skills** réutilisables en équipe
- Connecter Copilot CLI à des systèmes externes via **MCP** (GitHub, filesystem, Context7…)
- Enchaîner idée → plan → code → tests → revue → PR en une seule session
- (Bonus) Sécuriser, isoler, mesurer et automatiser plus loin (sandbox, sécurité, tokens, n8n…)

---

# Programme — vue d'ensemble

| Piste | Chapitres | Durée |
|---|---|---|
| 🧭 Fondamentaux | 00, 01, 02 | ~1h30–2h30 |
| ⚡ Flux de travail quotidiens | 03, 04 | ~1h50 |
| 🤖 Automatisation & agents IA | 05, 06, 07, 08 | ~3h55 |
| 🎓 Aller plus loin (commandes natives) | 11, 13 | ~1h10 |
| 🎁 Modules bonus | 09, 10, 12, 14, 15, 16, 17, 18 | ~6h30 |

Chaque chapitre suit la même structure : **analogie du monde réel → concepts clés → démonstration → TP/exercice → et ensuite**.

---

<!-- _class: lead -->

# 🧭 Piste 1 — Fondamentaux
## Chapitres 00 à 02

---

# Chapitre 00 — Équipez votre terminal
### *(optionnel, ~35–60 min)*

**Analogie** : un cockpit nu (terminal par défaut) vs un cockpit instrumenté (radar, GPS, boîte noire, copilote).

**Ce que les apprenants vont apprendre** :
- Installer une stack terminal moderne de 11 outils : zsh, Starship, Atuin, Zoxide, fzf, eza, bat, zsh-autosuggestions/syntax-highlighting, Tmux, TPM+resurrect+continuum
- Remplacer leurs réflexes (`ls`→`eza`, `cat`→`bat`, `cd`→`z`, `Ctrl+R`→Atuin)
- Utiliser Tmux pour des sessions persistantes

---

# TP — Chapitre 00

**Rôle du TP** : installation guidée, bloc par bloc, avec vérification immédiate après chaque outil.

**Déroulé** : exécuter le script d'installation de la plateforme (`scripts/install-{macos,linux,windows}`), qui est idempotent.

**Exercice principal** : lancer le script d'installation, vérifier que le prompt Starship s'affiche, que `z <fragment>` fonctionne, puis créer/scinder/détacher/rattacher une session Tmux.

**Bonus** : ajouter un alias personnalisé ou un module Starship custom.

---

# Quiz — Chapitre 00

1. **Vrai ou faux** : le script d'installation peut être relancé sans danger s'il a déjà été exécuté.
   *Réponse : Vrai — le script est idempotent.*
2. Quel raccourci Atuin remplace-t-il et pour quel bénéfice ?
   *Réponse : `Ctrl+R` (recherche d'historique) — recherche floue et partagée entre sessions.*
3. Citer un outil de la stack et l'ancienne commande qu'il remplace.
   *Réponse : ex. `eza` remplace `ls`, `bat` remplace `cat`, `z` (Zoxide) remplace `cd`.*

---

# Chapitre 01 — Démarrage rapide
### *(~10 min + blocs optionnels, ~90–120 min si tout est fait)*

**Ce que les apprenants vont apprendre** :
- Installer Copilot CLI (npm/brew/winget/curl/Codespaces)
- S'authentifier (`/login`, flux navigateur ou device-code)
- Vérifier l'installation (`copilot --version`)
- (Optionnel) Auto model selection, statusline, caveman/peon-ping, export OpenTelemetry, tableau de bord Tokscale, serveurs LSP

---

# TP — Chapitre 01

**Rôle du TP** : premier contact — installation, authentification, et première question posée à Copilot sur l'app exemple.

**Déroulé** : `python book_app.py list`, puis poser une première question à Copilot CLI. Six blocs optionnels approfondissent l'outillage (A–F : modèle auto, statusline, caveman/peon-ping, OTel, Tokscale/Graphiti, LSP).

**Exercice principal** : activer l'export OTel en fichier, faire 3 interactions, puis utiliser Tokscale pour comparer leurs coûts.

**Bonus** : installer le serveur MCP Graphiti et tester sa connexion à Copilot CLI.

---

# Quiz — Chapitre 01

1. Quelle commande vérifie que l'installation a réussi ?
   *Réponse : `copilot --version`.*
2. **Vrai ou faux** : le flux d'authentification par défaut depuis la v1.0.77 est le device-code.
   *Réponse : Faux — c'est le flux navigateur qui est par défaut ; le device-code est le repli.*
3. À quoi sert Tokscale par rapport à l'export OpenTelemetry ?
   *Réponse : Tokscale lit les logs OTel exportés pour donner un tableau de bord de coût/consommation.*

---

# Chapitre 02 — Premiers pas
### *(~45 min)*

**Analogie** : un restaurant — Plan = itinéraire GPS, Interactive = discuter avec le serveur, Programmatic = drive-through.

**Ce que les apprenants vont apprendre** :
- Les 3 modes d'interaction : Interactive, Plan, Programmatic (`-p`)
- Les commandes slash essentielles (`/ask`, `/clear`, `/config`, `/help`, `/model`, `/plan`, `/refine`, `/research`, `/exit`)
- Faire une revue de code, expliquer du code confus, générer du code

---

# TP — Chapitre 02

**Rôle du TP** : pratique guidée par démonstrations successives (découverte des 3 modes), puis exploration libre.

**Déroulé** : 3 démos sur `book_app.py`/`books.py` (revue de code, explication, génération), puis exploration interactive, un `/plan` pour une fonctionnalité de recherche, et une revue programmatique en boucle sur tous les fichiers `.py`.

**Exercice principal** : améliorer `utils.py` (résumer → valider → gérer les erreurs → docstring), validé par `pytest -v` (aucun échec/erreur).

**Bonus** : comparer les 3 modes sur une même tâche nouvelle (`list_by_year()`).

---

# Quiz — Chapitre 02

1. Quel mode utiliser pour une tâche automatisée sans interaction, dans un script ?
   *Réponse : le mode Programmatic (`copilot -p`).*
2. Quel critère valide la réussite de l'exercice sur `utils.py` ?
   *Réponse : `pytest -v` ne doit remonter aucun test en échec ou en erreur.*
3. **Vrai ou faux** : le mode Plan exécute directement les modifications proposées.
   *Réponse : Faux — il propose un plan à valider avant exécution.*

---

<!-- _class: lead -->

# ⚡ Piste 2 — Flux de travail quotidiens
## Chapitres 03 à 04

---

# Chapitre 03 — Contexte et conversations
### *(~50 min)*

**Ce que les apprenants vont apprendre** :
- La syntaxe `@` (fichier, dossier, multi-fichiers, glob, image)
- La gestion de session (`--continue`, `--resume`, `--name`, `/rename`, `/session`)
- Copilot Memory, la fenêtre de contexte (`/context`, `/compact`), les checkpoints
- Le seuil de troncature des sorties d'outils volumineuses (20 KiB)

---

# TP — Chapitre 03

**Rôle du TP** : mise en situation — montrer la différence entre une IA "aveugle" et une IA qui voit tout le projet.

**Déroulé** : revue full-projet, détection de bug cross-fichiers, "comprendre la base de code en 60 secondes", refactoring multi-fichiers consolidé, persistance de session sur plusieurs jours (lundi → mercredi).

**Exercice principal** : tracer le flux de données (`books.py` + `book_app.py` + `data.json`), nommer la session `data-flow-analysis`, la reprendre avec `--continue`.

**Bonus** : charger tout le projet avec `@samples/book-app-project/`, surveiller `/context`, pratiquer `/compact` et le dosage précision/exhaustivité des références.

---

# Quiz — Chapitre 03

1. Comment reprendre une session nommée précédemment interrompue ?
   *Réponse : avec `--continue` (ou `--resume` pour choisir parmi plusieurs sessions).*
2. À quel seuil approximatif la compaction automatique du contexte se déclenche-t-elle ?
   *Réponse : autour de 80–95 % de la fenêtre de contexte.*
3. **Vrai ou faux** : `/compact focus on...` permet de cibler ce qui doit être conservé lors de la compaction.
   *Réponse : Vrai.*

---

# Chapitre 04 — Flux de travail de développement
### *(~60 min)*

**Analogie** : les ateliers d'un charpentier (construire / réparer / contrôler qualité).

**Ce que les apprenants vont apprendre** :
- 5 workflows autonomes : Revue de code (`/review`, `/rubber-duck`), Refactoring, Debugging (`!commande` inline), Génération de tests, Intégration Git (`/pr`, `/delegate`, `/diff`, `/branch`, `/worktree`)
- Enchaîner un correctif de bug jusqu'au commit

---

# TP — Chapitre 04

**Rôle du TP** : pipeline complet de bout en bout, reproduisant un vrai cycle de correction de bug.

**Déroulé** : rapport de bug → correctif → tests → `git add` → `/diff` → message de commit → commit. Le debugging s'appuie sur `samples/book-app-buggy/` et `samples/buggy-code/` (bugs de sécurité inclus).

**Exercice principal** : review → refactor → test → review → commit sur la fonction `remove_book()`.

**Bonus** : exercice externe GitHub Skills "Create applications with the Copilot CLI" (Node.js).

**✅ Point de contrôle** : à ce stade, les apprenants maîtrisent l'essentiel (Ch02–04).

---

# Quiz — Chapitre 04

1. Quelle commande ouvre un mode de revue interactif du diff avant commit ?
   *Réponse : `/diff`.*
2. Sur quels dossiers s'appuie le TP de debugging et pourquoi ne faut-il jamais les "réparer" définitivement dans le dépôt ?
   *Réponse : `samples/book-app-buggy/` et `samples/buggy-code/` — leurs bugs sont intentionnels pour les exercices, donc on ne corrige jamais le dépôt lui-même, seulement une copie de travail.*
3. **Vrai ou faux** : `/pr auto` peut créer une PR automatiquement.
   *Réponse : Vrai.*

---

<!-- _class: lead -->

# 🤖 Piste 3 — Automatisation & agents IA
## Chapitres 05 à 08

---

# Chapitre 05 — Créer des assistants IA spécialisés
### *(~55 min)*

**Analogie** : recruter des artisans spécialisés (plombier, électricien, couvreur) plutôt qu'un généraliste.

**Ce que les apprenants vont apprendre** :
- Les agents intégrés (Plan, Code-review, Init, Explore, Task) vs agents personnalisés `.agent.md`
- Où les placer (`.github/agents/` projet vs `~/.copilot/agents/` personnel)
- Les fichiers de config projet : `AGENTS.md`, `.github/copilot-instructions.md`, `.instructions.md` (`applyTo`, `@import`)
- La différence agent / skill / fichier d'instructions

---

# TP — Chapitre 05

**Rôle du TP** : démonstration comparative (spécialiste vs générique) puis collaboration multi-agents.

**Déroulé** : comparer un agent spécialisé à une invite générique, faire collaborer un agent `python-reviewer` et un agent `pytest-helper`.

**Exercice principal** : créer 3 agents personnalisés (`data-validator`, `error-handler`, `doc-writer`) — la suite pytest doit rester à ≥5 tests réussis avant/après.

**Bonus** : construire une bibliothèque de 3 fichiers `.instructions.md`.

---

# Quiz — Chapitre 05

1. Où placer un agent partagé avec toute l'équipe sur un projet ?
   *Réponse : `.github/agents/`.*
2. Quel champ du frontmatter `.agent.md` est obligatoire ?
   *Réponse : `description`.*
3. **Vrai ou faux** : un agent personnalisé peut restreindre les outils qu'il est autorisé à utiliser.
   *Réponse : Vrai (champ `tools`).*

---

# Chapitre 06 — Automatiser les tâches répétitives (Skills)
### *(~55 min)*

**Analogie** : les embouts interchangeables d'une perceuse.

**Ce que les apprenants vont apprendre** :
- Les Agent Skills : dossiers `SKILL.md` (name + description obligatoires) auto-déclenchés
- Invocation directe (`/nom-du-skill <prompt>`), combinaison de plusieurs skills
- Le cycle de vie d'un skill (créer → tester → éditer → partager → maintenir) et la checklist sécurité avant d'installer un skill tiers

---

# TP — Chapitre 06

**Rôle du TP** : construction progressive de plusieurs skills, du plus simple au plus élaboré.

**Déroulé** : construire `security-audit` (checklist OWASP), puis `pytest-gen` et `pr-review` à partir de zéro.

**Exercice principal** : créer le skill `book-summary` qui produit un tableau Markdown avec statut ✅/❌ de lecture, en testant à la fois l'auto-déclenchement et l'invocation directe `/book-summary`.

**Bonus** : créer un skill `commit-message`, le partager sur GitHub avec le tag `copilot-skill`.

---

# Quiz — Chapitre 06

1. Quels sont les deux champs obligatoires d'un `SKILL.md` ?
   *Réponse : `name` et `description`.*
2. Comment invoquer un skill directement sans attendre le déclenchement automatique ?
   *Réponse : `/nom-du-skill <prompt>`.*
3. **Vrai ou faux** : il faut vérifier un skill avant de l'installer, comme on vérifierait une dépendance externe.
   *Réponse : Vrai — checklist sécurité recommandée avant installation d'un skill tiers.*

---

# Chapitre 07 — Se connecter à GitHub, bases de données et API (MCP)
### *(~50 min)*

**Analogie** : des extensions de navigateur (GitHub MCP = gestionnaire de mots de passe, Context7 = correcteur, Filesystem = gestionnaire cloud).

**Ce que les apprenants vont apprendre** :
- Les 3 types de serveurs MCP (intégré GitHub, local `stdio`, distant HTTP/OAuth)
- Configurer `mcp-config.json`, utiliser `/mcp`, `/mcp search`
- Diagnostiquer un serveur MCP en 4 étapes (config → démarrage → outils → appel)

---

# TP — Chapitre 07

**Rôle du TP** : démonstrations serveur par serveur, puis workflows combinant plusieurs serveurs.

**Déroulé** : démos individuelles (GitHub, Filesystem, Context7), puis workflows combinés (exploration, issue→PR, tableau de bord santé).

**Exercice principal** : combiner Filesystem MCP + GitHub MCP sur `book-app-project` pour trouver une anomalie de données ("Mysterious Book" — auteur vide, année=0) et comparer la couverture de tests.

**Bonus** : construire un serveur MCP personnalisé (`mcp-custom-server.md`).

---

# Quiz — Chapitre 07

1. Quelles sont les 3 catégories de serveurs MCP ?
   *Réponse : intégré (ex. GitHub), local (`stdio`), distant (HTTP/OAuth).*
2. Quelle anomalie de données l'exercice principal demande-t-il de retrouver ?
   *Réponse : un livre "Mysterious Book" avec un auteur vide et une année à 0.*
3. Quelles sont les 4 étapes du diagnostic d'un serveur MCP en panne ?
   *Réponse : configuration → démarrage → outils disponibles → appel effectif.*

---

# Chapitre 08 — Tout assembler
### *(~75 min — dernier chapitre du tronc commun)*

**Analogie** : un orchestre (cordes = workflows de base, cuivres = agents, bois = skills, percussions = MCP).

**Ce que les apprenants vont apprendre** :
- Enchaîner idée → plan → implémentation → tests → revue → PR, avec seulement les fondamentaux des chapitres 00–04
- Le "pattern d'intégration" : rassembler le contexte → analyser/planifier → exécuter → conclure
- Auditer sa configuration chargée avec `/env`

---

# TP — Chapitre 08

**Rôle du TP** : mise en situation finale — parcours guidé complet, seul exercice à la fois TP et évaluation de synthèse du tronc commun.

**Déroulé** : construire la fonctionnalité "recherche par plage d'années" de bout en bout, avec jalons vérifiables à chaque étape (idée → plan → code → tests → revue → PR).

**Exercice principal** : documenter le déroulé complet de la fonctionnalité construite.

*À ce stade, le tronc commun (00–08) est terminé — direction les modules bonus (09–18).*

---

# Quiz — Chapitre 08

1. Quelles sont les 4 étapes du "pattern d'intégration" présenté dans ce chapitre ?
   *Réponse : rassembler le contexte → analyser/planifier → exécuter → conclure.*
2. Quelle commande permet d'auditer la configuration (agents/skills/instructions) réellement chargée dans la session ?
   *Réponse : `/env`.*
3. **Vrai ou faux** : ce chapitre s'appuie sur des fonctionnalités avancées (agents, skills, MCP) vues aux chapitres 05–07.
   *Réponse : Faux — le parcours guidé principal n'utilise que les fondamentaux des chapitres 00–04 (une variante enrichie avec agents existe en option).*

---

<!-- _class: lead -->

# 🎓 Piste 4 — Aller plus loin avec les commandes natives
## Chapitres 11 et 13

---

# Chapitre 11 — Sécuriser votre code avec Copilot CLI
### *(~40 min)*

**Analogie** : un contrôle de sécurité rapide (`/security-review`) vs une inspection douanière approfondie (CodeQL/Dependabot/Snyk).

**Ce que les apprenants vont apprendre** :
- Utiliser `/security-review` (expérimental) pour scanner un diff, classé par sévérité (Critical/High/Medium/Low)
- Reconnaître les catégories de vulnérabilités (injection, XSS, SSRF, désérialisation, crypto faible, secrets en dur, XPIA…)
- Configurer les permissions d'outils fines (`--allow-tool`/`--deny-tool`)

---

# TP — Chapitre 11

**Rôle du TP** : audit de sécurité complet, dans un environnement de travail jetable pour ne jamais modifier le code source réel.

**Déroulé** : sur une copie temporaire de `samples/buggy-code/python/user_service.py` — détecter (injection SQL, mot de passe loggé, secret JWT en dur, MD5, `pickle.loads()`) → valider manuellement → corriger **uniquement dans la copie de labo** → re-scanner pour confirmer la résolution.

**Exercice principal** : répéter le même scénario sur `payment_processor.py` dans un nouveau labo temporaire.

**Bonus** : ajouter une section "Sécurité" à ses propres `.github/copilot-instructions.md`, vérifier avec une invite neutre.

---

# Quiz — Chapitre 11

1. Pourquoi le TP travaille-t-il toujours sur une **copie temporaire** du code vulnérable ?
   *Réponse : pour ne jamais modifier le code source réel du dépôt d'exercices, qui doit rester vulnérable pour les prochains passages.*
2. Citer deux catégories de vulnérabilités détectables par `/security-review`.
   *Réponse : ex. injection SQL, secrets en dur, désérialisation non sûre, crypto faible (MD5), XPIA…*
3. **Vrai ou faux** : `/security-review` est une commande stable, activée par défaut.
   *Réponse : Faux — elle est expérimentale et nécessite `/experimental`.*

---

# Chapitre 13 — Explorer l'historique de vos sessions avec `/chronicle`
### *(~30 min)*

**Analogie** : `/rewind` est la touche "annuler" (session en cours) ; `/chronicle` est le journal de bord du capitaine (toutes les sessions passées).

**Ce que les apprenants vont apprendre** :
- Les sous-commandes `/chronicle` : `standup`, `tips`/`cost-tips`, `search`, `improve`, `skills review`, `reindex`
- Comment `/chronicle improve` peut suggérer des ajouts à `copilot-instructions.md` à partir de frictions répétées

---

# TP — Chapitre 13

**Rôle du TP** : découverte pratique de chaque sous-commande sur un historique réel de session.

**Déroulé** : exécuter `standup`, `tips`, `search <mot-clé>` sur un ancien correctif de bug, `improve`, `skills review`.

**Exercice principal** : utiliser `/chronicle search` pour retrouver une session touchant `books.py`/`utils.py` et résumer la décision prise.

**Bonus** : exécuter `/chronicle cost-tips` et noter la première recommandation d'optimisation (fait le pont vers le chapitre 14).

---

# Quiz — Chapitre 13

1. Quelle sous-commande génère un rapport d'activité (par défaut sur les dernières 24h) ?
   *Réponse : `/chronicle standup`.*
2. Quelle sous-commande peut proposer d'ajouter des règles à `copilot-instructions.md` ?
   *Réponse : `/chronicle improve`.*
3. **Vrai ou faux** : `/chronicle search` recherche uniquement dans la session en cours.
   *Réponse : Faux — elle recherche à travers l'historique de toutes les sessions passées.*

---

<!-- _class: lead -->

# 🎁 Piste 5 — Modules bonus
## Chapitres 09, 10, 12, 14–18

---

# Chapitre 09 — Environnements isolés
### *(bonus, ~60 min, Docker recommandé)*

**Analogie** : atelier partagé (dev container) / cage grillagée (sandbox natif) / atelier verrouillé (Docker Sandbox).

**Ce que les apprenants vont apprendre** :
- Utiliser un dev container (`.devcontainer/devcontainer.json`, Feature officielle `copilot-cli`)
- Activer le sandbox natif (`/sandbox enable`, politique deny-by-default, `--allow-tool`/`--deny-tool`)
- Lancer Copilot dans un Docker Sandbox avec politique réseau (`sbx run copilot`, `sbx policy init deny-all`)
- Construire sa propre image Docker outillée

---

# TP — Chapitre 09

**Rôle du TP** : parcours en 4 temps, du plus simple (dev container) au plus verrouillé (image Docker custom).

**Déroulé** : ouvrir le dev container ; activer et tester l'isolation du sandbox natif (créer un fichier "côté hôte" et vérifier que Copilot ne peut pas le lire) ; lancer une revue automatisée en Docker Sandbox avec politique réseau ; construire et vérifier une image Docker personnalisée.

**Exercice principal** : script de revue automatisée totalement verrouillé (politique réseau deny-all + `sbx run copilot` → `review.md`).

**Bonus** : combiner dev container + sandbox natif.

---

# Quiz — Chapitre 09

1. Quelle est la politique de fichiers par défaut du sandbox natif ?
   *Réponse : deny-by-default (accès refusé sauf autorisation explicite).*
2. Quelle commande initialise une politique réseau "tout refuser" pour Docker Sandbox ?
   *Réponse : `sbx policy init deny-all`.*
3. **Vrai ou faux** : dans le TP, on vérifie l'isolation en créant un fichier côté hôte et en confirmant que Copilot ne peut pas y accéder depuis le sandbox.
   *Réponse : Vrai.*

---

# Chapitre 10 — RAG sur votre vault Obsidian
### *(bonus, ~55 min, nécessite Obsidian)*

**Analogie** : un chercheur qui utilise un dossier indexé par thème plutôt qu'une pile de documents en vrac.

**Ce que les apprenants vont apprendre** :
- Les 3 étapes du RAG (récupération, augmentation, génération)
- Deux serveurs MCP complémentaires : Local REST API (accès direct au vault) et Smart Connections (recherche sémantique locale)
- La recherche hybride (`search_simple` littérale + `search_notes` sémantique)

---

# TP — Chapitre 10

**Rôle du TP** : mise en place d'un pipeline RAG complet, avec vérification manuelle de la fiabilité des réponses.

**Déroulé** : installer/indexer les deux plugins Obsidian, connecter les deux serveurs MCP (clé API en variable d'environnement, jamais en dur), poser une question de synthèse nécessitant ≥3 notes avec citations `[[wikilink]]`.

**Exercice principal** : vérifier manuellement chaque citation de la réponse générée.

**Bonus** : ajouter un second vault (`SMART_VAULT_PATH`), poser une question inter-vaults.

---

# Quiz — Chapitre 10

1. Quelles sont les 3 étapes classiques du RAG ?
   *Réponse : récupération (retrieval), augmentation, génération.*
2. Pourquoi vérifier manuellement les citations `[[wikilink]]` produites par l'IA ?
   *Réponse : pour s'assurer que la réponse s'appuie réellement sur les notes citées et éviter les hallucinations de sources.*
3. **Vrai ou faux** : la clé API du serveur Local REST API doit être écrite en dur dans `.mcp.json`.
   *Réponse : Faux — elle doit être passée via une variable d'environnement (`${OBSIDIAN_API_KEY}`).*

---

# Chapitre 12 — Comprendre l'acceptation de l'IA par les développeurs
### *(bonus, ~30 min)*

**Ce que les apprenants vont apprendre** :
- Analyser 5 études sourcées : GitHub Research, McKinsey, DORA (thèse de l'"amplificateur"), Stack Overflow Developer Survey 2025, LinearB (taxe de vérification)
- Distinguer 3 types de preuves : mesure expérimentale / corrélation observée / auto-déclaratif

---

# TP — Chapitre 12

**Rôle du TP** : auto-évaluation réflexive, sans commande Copilot — le seul chapitre "TP sans terminal" du cursus.

**Déroulé** : remplir un tableau personnel "avant/après" (temps, essais, erreurs, confiance avec vs sans Copilot CLI).

**Exercice principal** : rédiger un bilan personnel de 3 à 5 phrases comparant sa propre expérience aux études citées.

**Bonus** : trouver et résumer une étude 2025/2026 supplémentaire non citée dans le chapitre.

---

# Quiz — Chapitre 12

1. Quels sont les 3 types de preuves distingués dans ce chapitre ?
   *Réponse : mesure expérimentale, corrélation observée, auto-déclaratif (self-report).*
2. Que désigne la "taxe de vérification" évoquée par l'étude LinearB ?
   *Réponse : le temps/effort supplémentaire nécessaire pour vérifier le code généré par IA avant de le fusionner (taux de fusion des PR IA nettement inférieur à celui des PR humaines).*
3. **Vrai ou faux** : toutes les études citées concluent unanimement à un gain de productivité systématique, sans nuance.
   *Réponse : Faux — les gains sont présentés comme dépendants de la tâche et du contexte (ex. thèse de l'"amplificateur" de DORA).*

---

# Chapitre 14 — Analyser sa consommation de tokens avec RTK et Tokscale
### *(bonus, ~45 min)*

**Analogie** : un compteur électrique (Tokscale, mesure a posteriori) vs une ampoule basse consommation (RTK, réduit à la source).

**Ce que les apprenants vont apprendre** :
- La facturation en crédits IA GitHub et les contrôles natifs de budget (`/usage`, `/context`, `/limits`)
- RTK, un proxy qui compresse les sorties verbeuses (git/npm/pytest/docker…)
- **Point de vigilance** : un benchmark indépendant JetBrains a montré que les 99,8 % de "gains" auto-déclarés par RTK correspondaient, dans certaines conditions, à une **hausse réelle de +7,6 %** de la facturation

---

# TP — Chapitre 14

**Rôle du TP** : mesure comparative — apprendre à ne pas se fier aveuglément aux statistiques auto-déclarées d'un outil.

**Déroulé** : comparer le volume de `git status` brut vs `rtk proxy git status` ; consulter `rtk gain` ; lancer `npx tokscale@latest --light`.

**Exercice principal** : installer RTK, comparer `git log -10`/des tests avec et sans RTK, noter le pourcentage de réduction observé.

**Bonus** : combiner export OTel + Tokscale pour comparer le coût réel de deux sessions distinctes.

---

# Quiz — Chapitre 14

1. Quelle est la mise en garde centrale de ce chapitre concernant RTK ?
   *Réponse : ses statistiques de gain auto-déclarées (`rtk gain`) peuvent diverger fortement de la facturation réelle, voire l'augmenter dans certaines conditions (benchmark JetBrains : +7,6 %).*
2. Quelle commande native permet de consulter sa consommation de crédits IA sans outil tiers ?
   *Réponse : `/usage` (avec aussi `/context` et `/limits`).*
3. **Vrai ou faux** : Tokscale nécessite une installation préalable via un gestionnaire de paquets.
   *Réponse : Faux — il se lance directement via `npx`, sans installation.*

---

# Chapitre 15 — Rédiger des instructions IA efficaces et réutilisables
### *(bonus, ~40 min)*

**Analogie** : un post-it griffonné vs un cahier des charges structuré (objectif + contraintes + format de sortie).

**Ce que les apprenants vont apprendre** :
- Le cadre en 3 questions : objectif / contraintes / format de sortie
- Ancrer ses prompts dans le vocabulaire métier réel du projet
- Utiliser des templates de prompt réutilisables (`samples/prompt-templates/`)
- Les 3 modes de livraison d'un prompt (interactif / fichier Markdown / programmatique)

---

# TP — Chapitre 15

**Rôle du TP** : pratique comparative — mesurer la différence de qualité entre un prompt structuré et un prompt vague.

**Déroulé** : remplir `code-review-prompt.md` ciblant `utils.py` et comparer à une invite vague ; remplir `bug-fix-prompt.md`.

**Exercice principal** : créer un 4ᵉ template (par ex. `refactor-prompt.md`).

**Bonus** : tester une implémentation `mcp2cli` contre le serveur MCP n8n du chapitre 18.

---

# Quiz — Chapitre 15

1. Quelles sont les 3 questions du cadre de prompt présenté ?
   *Réponse : quel est l'objectif ? quelles sont les contraintes ? quel format de sortie attendu ?*
2. Pourquoi les templates de prompts sont-ils de simples fichiers Markdown copier-coller plutôt que des commandes slash natives ?
   *Réponse : Copilot CLI ne propose pas nativement de slash-commands `.prompt.md` comme VS Code/JetBrains.*
3. **Vrai ou faux** : un prompt vague et un prompt structuré produisent généralement des résultats de qualité équivalente.
   *Réponse : Faux — c'est justement l'objet du TP de démontrer la différence de qualité.*

---

# Chapitre 16 — Sessions parallèles avec les worktrees Git
### *(bonus, ~35 min)*

**Analogie** : un hôtel avec une seule réception/infrastructure mais plusieurs chambres indépendantes.

**Ce que les apprenants vont apprendre** :
- Les commandes natives `git worktree` (add/list/remove/prune/lock/unlock)
- Les raccourcis Copilot CLI depuis la v1.0.79 : `/worktree new`, `/worktree [branch]`, `/move`, `/fork`/`/branch`
- Que l'environnement (venv, dépendances) n'est PAS dupliqué automatiquement entre worktrees

---

# TP — Chapitre 16

**Rôle du TP** : cycle de vie complet d'un worktree, de la création à la preuve du nettoyage.

**Déroulé** : créer/vérifier → travailler → fusionner/gérer un conflit → nettoyer → prouver le nettoyage (`git worktree list` vide).

**Exercice principal** : simuler un 3ᵉ worktree urgent pendant que les deux premiers sont actifs, vérifier que les 3 coexistent.

**Bonus** : écrire un script bash automatisant créer → `copilot -p` → nettoyage automatique du worktree.

---

# Quiz — Chapitre 16

1. Quelle commande native liste tous les worktrees actifs d'un dépôt ?
   *Réponse : `git worktree list`.*
2. Quelle différence essentielle entre `/worktree [branch]` et `/move` ?
   *Réponse : `/worktree [branch]` change de session en laissant les modifications non commitées derrière lui, alors que `/move` change de session en emportant les modifications avec lui.*
3. **Vrai ou faux** : un environnement virtuel Python installé dans le dépôt principal est automatiquement disponible dans un nouveau worktree.
   *Réponse : Faux — l'environnement doit être réinstallé dans chaque worktree.*

---

# Chapitre 17 — mcp2cli et le coût en tokens
### *(bonus, ~35 min, complète le chapitre 07)*

**Analogie** : un standardiste qui relaie chaque appel (Copilot + MCP) vs une ligne directe (mcp2cli).

**Ce que les apprenants vont apprendre** :
- Pourquoi MCP a un coût en tokens (découverte des schémas d'outils + lecture de chaque résultat par le modèle)
- Comment mcp2cli transforme un serveur MCP en CLI typée native, sans passer par un modèle
- Les deux modes de connexion (ad hoc `--url`/`--stdio`, ou alias nommé via `link create`)

---

# TP — Chapitre 17

**Rôle du TP** : comparaison directe côte à côte entre un appel MCP classique (via le modèle) et un appel via mcp2cli (sans modèle).

**Déroulé** : créer un alias Context7, `context7 ls --tools`, `context7 resolve-library-id --help`, enchaîner `resolve-library-id` → `query-docs` pour une question sur pytest, puis reproduire la même requête directement via Copilot CLI.

**Exercice principal** : documenter le flux complet (découvrir → inspecter → enchaîner → sauvegarder en JSON → comparer avec Copilot) et justifier par écrit le choix le plus adapté.

**Bonus** : essayer mcp2cli sur le serveur Filesystem du chapitre 07.

---

# Quiz — Chapitre 17

1. Pourquoi une requête MCP classique coûte-t-elle des tokens, contrairement à mcp2cli ?
   *Réponse : le modèle doit découvrir les schémas d'outils au démarrage et lire chaque résultat, alors que mcp2cli appelle directement le serveur MCP sans passer par le modèle.*
2. Quelle commande crée un alias nommé réutilisable vers un serveur MCP ?
   *Réponse : `link create`.*
3. **Vrai ou faux** : mcp2cli.dev est le même projet que d'autres outils portant un nom similaire.
   *Réponse : Faux — le chapitre précise qu'il s'agit d'un projet distinct (Apache 2.0) d'autres projets homonymes.*

---

# Chapitre 18 — Automatiser un workflow visuel avec n8n
### *(bonus, ~50 min, nécessite Docker)*

**Analogie** : un établi avec des briques visuelles préfabriquées plutôt que du code écrit ligne par ligne.

**Ce que les apprenants vont apprendre** :
- Lancer n8n via Docker et activer le serveur MCP au niveau instance (n8n ≥ 2.13.0)
- Connecter n8n à Copilot CLI via `.mcp.json` (`"type":"http"`)
- Utiliser les skills officiels n8n-io (copiés dans `.github/skills/` pour compatibilité Copilot CLI)

---

# TP — Chapitre 18

**Rôle du TP** : construction d'un vrai workflow d'automatisation à partir d'une simple description en langage naturel.

**Déroulé** : construire un workflow webhook à 3 nœuds (Webhook → requête HTTP vers l'API Open Library → nœud Set) uniquement via prompt en langage naturel, activer le workflow, le tester avec `curl` contre l'URL webhook de **production** (pas de test).

**Exercice principal** : ajouter un nœud `If`/gestion d'erreur pour le cas "aucun résultat trouvé".

**Bonus** : reproduire un autre workflow n8n trouvé en ligne, à partir de sa seule description en langage naturel.

---

# Quiz — Chapitre 18

1. Pourquoi teste-t-on le webhook en production plutôt qu'en mode test dans ce TP ?
   *Réponse : le chapitre fait explicitement tester contre l'URL webhook de production (et non l'URL de test) pour valider le comportement réel du workflow activé.*
2. Quel service externe le nœud HTTP Request interroge-t-il dans le TP principal ?
   *Réponse : l'API Open Library.*
3. **Vrai ou faux** : les skills n8n-io utilisés dans ce chapitre sont nativement compatibles Copilot CLI sans aucune adaptation.
   *Réponse : Faux — ils sont conçus pour Claude Code et ont été copiés manuellement dans `.github/skills/` pour fonctionner avec Copilot CLI.*

---

# Annexes complémentaires
### *(non numérotées, hors parcours principal)*

| Annexe | Contenu | Prérequis |
|---|---|---|
| `additional-context.md` | Contexte image (`@screenshot.png`), permissions multi-dossiers | Chapitre 03 |
| `ci-cd-integration.md` | Revue automatisée via GitHub Actions sur PR | Chapitre 08 |
| `web-data-retrieval-and-autocli.md` | Récupération de données web fiable avec AutoCLI | Chapitre 04 |

---

<!-- _paginate: false -->

# Merci — et ensuite ?

**Parcours complet effectué** : tronc commun (00–08) + modules bonus choisis parmi 09–18.

**Pour continuer** :
- Pratiquer sur ses propres projets avec les workflows du chapitre 04
- Construire sa propre bibliothèque d'agents/skills/instructions
- Explorer les modules bonus non couverts en session
- Contribuer au dépôt du cours (`CONTRIBUTING.md`) avec ses retours d'expérience

**Questions ?**
