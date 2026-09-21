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
**Format** : autoportant — lisible seul ou animé par un formateur, TP guidés sur une app exemple (gestion de bibliothèque)

---

# Comment utiliser ce support

Ce document est conçu pour être compris **sans formateur présent** : chaque chapitre suit toujours la même mécanique.

1. **Slide de chapitre** : l'analogie et ce qu'on va apprendre, expliqués en clair.
2. **Slides de concepts** : chaque notion est décrite en une phrase complète, pas juste un mot-clé.
3. **Slides de TP** (rôle → déroulé → exercice) : de quoi refaire le TP seul, pas à pas.
4. **Slide de quiz** : questions seules — **répondez par écrit avant de tourner la page.**
5. **Slide de corrigé** : réponse + explication détaillée, pensée pour être apprenante même en simple lecture.
6. **Slide de transition** : le lien logique vers le chapitre suivant.

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

Ces 5 pistes s'enchaînent dans un ordre logique : on équipe d'abord son terminal et son installation, puis on apprend à dialoguer avec l'IA, avant de lui déléguer des workflows entiers, puis de l'automatiser, et enfin d'aller plus loin à son rythme.

---

<!-- _class: lead -->

# 🧭 Piste 1 — Fondamentaux
## Chapitres 00 à 02

**Pourquoi commencer ici ?** Avant de parler à l'IA, il faut un terminal confortable (Ch00), l'outil installé et authentifié (Ch01), puis apprendre ses 3 façons de l'utiliser (Ch02). Sans ces bases, tout le reste de la formation serait plus lent à suivre.

---

# Chapitre 00 — Équipez votre terminal
### *(optionnel, ~35–60 min)*

**Analogie** : piloter un avion depuis un cockpit nu (quelques cadrans) est possible, mais un cockpit instrumenté — radar, GPS, boîte noire, copilote — rend chaque décision plus sûre et plus rapide. Un terminal par défaut, c'est le cockpit nu ; la stack de ce chapitre, c'est l'instrumentation complète.

**Ce que les apprenants vont apprendre** :
- Pourquoi un terminal "augmenté" accélère tout le reste de la formation (moins de friction = plus d'attention sur l'IA elle-même)
- Installer et relier entre eux 11 outils complémentaires
- Remplacer durablement leurs réflexes de commandes

---

# Chapitre 00 — Concepts clés

- **Prompt intelligent (Starship)** : remplace l'invite de commande basique par un affichage contextuel (branche Git, langage détecté, durée de la dernière commande) — l'état du projet est visible en un coup d'œil, sans taper `git status`.
- **Historique indexé (Atuin)** : enregistre toutes les commandes tapées dans une base consultable par mots-clés, partagée entre toutes les sessions — plus besoin de se souvenir d'une commande complexe tapée la semaine dernière.
- **Navigation par fréquence (Zoxide)** : apprend les dossiers les plus visités et y saute avec un simple fragment de nom (`z proj` au lieu de `cd /chemin/long/vers/projet`).
- **Multiplexeur persistant (Tmux + TPM)** : garde plusieurs terminaux organisés dans une seule fenêtre, avec sauvegarde/restauration automatique même après redémarrage de la machine.
- **Recherche et affichage enrichis (fzf, eza, bat)** : recherche floue interactive, listing de fichiers avec icônes/métadonnées, affichage de fichiers avec coloration syntaxique.

---

# TP — Chapitre 00 — Rôle et objectif

**Rôle pédagogique** : TP de **découverte par installation guidée** — chaque outil est installé puis vérifié immédiatement, un bloc à la fois, pour qu'une éventuelle erreur reste facile à isoler.

**Pourquoi ce TP existe** : sans stack terminal fonctionnelle, les chapitres suivants (qui reposent tous sur le terminal) seraient plus pénibles à suivre. C'est un investissement ponctuel qui paie sur toute la formation.

**Support** : machine locale de l'apprenant (macOS, Linux ou Windows).

---

# TP — Chapitre 00 — Déroulé pas à pas

1. Choisir le script d'installation correspondant à son OS (`scripts/install-{macos,linux,windows}`).
2. Exécuter le script — il est **idempotent** : le relancer ne casse rien s'il a déjà tourné partiellement.
3. Vérifier que le prompt Starship s'affiche correctement à l'ouverture d'un nouveau terminal.
4. Tester `z <fragment>` pour sauter vers un dossier fréquemment visité.
5. Créer une session Tmux, la scinder en plusieurs panneaux, s'en détacher, puis s'y rattacher.

---

# TP — Chapitre 00 — Exercice & critères de réussite

**Exercice principal** : réaliser les 5 étapes du déroulé ci-dessus dans l'ordre.

**Critère de réussite** : le prompt Starship affiche bien la branche Git courante, `z` retrouve un dossier visité récemment, et une session Tmux détachée est retrouvée intacte après ré-attachement (`tmux attach`).

**Bonus** : ajouter un alias personnalisé ou un module Starship sur mesure (ex. afficher la version de Python active).

---

# Quiz — Chapitre 00

1. **Vrai ou faux** : le script d'installation peut être relancé sans danger s'il a déjà été exécuté.
2. Quel raccourci historique Atuin remplace-t-il, et pour quel bénéfice concret ?
3. Citer un outil de la stack et l'ancienne commande qu'il remplace.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 00

1. **Vrai** — le script est idempotent : il détecte ce qui est déjà installé et ne le réinstalle pas, donc le relancer après une interruption ne pose aucun risque.
2. Il remplace **`Ctrl+R`** (recherche d'historique native du shell). Le bénéfice : la recherche devient floue (pas besoin du texte exact) et l'historique est **partagé entre toutes les sessions de terminal**, pas seulement la session courante.
3. Exemples possibles : `eza` remplace `ls` (listing enrichi), `bat` remplace `cat` (coloration syntaxique), `z` (Zoxide) remplace `cd` (navigation par fréquence). Le point commun : chaque remplaçant garde la même logique d'usage mais ajoute du contexte visuel ou de l'intelligence.

---

# Transition → Chapitre 01

Le terminal est maintenant confortable et rapide. Il manque encore l'outil principal de la formation : **Copilot CLI lui-même**. Le chapitre 01 couvre son installation, son authentification, et la vérification que tout fonctionne — la dernière étape avant de commencer à réellement dialoguer avec l'IA.

---

# Chapitre 01 — Démarrage rapide
### *(~10 min de socle + blocs optionnels, jusqu'à ~90–120 min si tout est fait)*

**Ce que les apprenants vont apprendre** :
- Installer Copilot CLI via la méthode adaptée à leur environnement (npm, brew, winget, script curl, ou directement dans un Codespace)
- S'authentifier auprès de GitHub et vérifier que l'installation répond
- Découvrir, en option, tout l'outillage avancé autour de l'outil (sélection automatique de modèle, statusline, compression de sortie, télémétrie, tableau de bord de coût, serveurs LSP)

---

# Chapitre 01 — Concepts clés

- **Méthodes d'installation multiples** : `npm`, `brew`, `winget`, un script `curl` officiel, ou un environnement Codespaces déjà prêt — l'apprenant choisit celle compatible avec son poste, sans dépendre d'un OS unique.
- **Authentification (`/login`)** : depuis la v1.0.77, le flux par défaut ouvre un navigateur pour se connecter à GitHub ; un flux alternatif par code à saisir (device-code) existe si le navigateur n'est pas accessible (poste distant, serveur…).
- **Vérification** : `copilot --version` confirme que le binaire est bien installé et accessible depuis le terminal — le même réflexe qu'on aura pour tout outil CLI installé dans la formation.
- **Télémétrie et coût (optionnel)** : Copilot CLI peut exporter ses métriques d'usage via OpenTelemetry, que des outils comme Tokscale peuvent ensuite lire pour visualiser combien chaque interaction a coûté.

---

# TP — Chapitre 01 — Rôle et objectif

**Rôle pédagogique** : TP de **premier contact** — installer, s'authentifier, et poser sa toute première question à l'IA sur du vrai code.

**Pourquoi ce TP existe** : vérifier concrètement, avant d'aller plus loin, que la chaîne complète (installation → authentification → réponse de l'IA) fonctionne sur le poste de l'apprenant.

**Support** : l'app exemple du cours, `book_app.py` (gestion de bibliothèque).

---

# TP — Chapitre 01 — Déroulé pas à pas

1. Lancer `python book_app.py list` pour vérifier que l'app exemple fonctionne.
2. Ouvrir Copilot CLI et poser une première question libre sur le code affiché.
3. *(Optionnel)* Explorer un ou plusieurs des 6 blocs avancés : sélection automatique de modèle, personnalisation de la statusline, compression de sortie (caveman) et notifications sonores (peon-ping), export OpenTelemetry, tableau de bord Tokscale + aperçu de Graphiti, serveurs LSP (Python, Java, C#, Terraform).

---

# TP — Chapitre 01 — Exercice & critères de réussite

**Exercice principal** : activer l'export OpenTelemetry vers un fichier, réaliser 3 interactions avec Copilot CLI, puis utiliser Tokscale pour comparer le coût de ces 3 interactions entre elles.

**Critère de réussite** : le fichier d'export OTel contient bien 3 événements, et Tokscale affiche un coût distinct pour chacun.

**Bonus** : installer le serveur MCP Graphiti et vérifier qu'il se connecte correctement à Copilot CLI.

---

# Quiz — Chapitre 01

1. Quelle commande vérifie que l'installation de Copilot CLI a réussi ?
2. **Vrai ou faux** : le flux d'authentification par défaut depuis la v1.0.77 est le device-code (code à saisir).
3. À quoi sert Tokscale par rapport à l'export OpenTelemetry ?

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 01

1. **`copilot --version`** — elle affiche le numéro de version installé ; une erreur "commande introuvable" signale un problème d'installation ou de PATH.
2. **Faux** — c'est le flux par **navigateur** qui est utilisé par défaut depuis la v1.0.77 ; le device-code n'est qu'un **repli** pour les environnements sans navigateur accessible (ex. serveur distant en SSH).
3. OpenTelemetry **produit** les données brutes (logs d'usage exportés à chaque interaction) ; Tokscale les **lit et les visualise** ensuite sous forme de tableau de bord de coût. L'un génère la donnée, l'autre l'exploite — ce sont deux étapes complémentaires, pas deux alternatives.

---

# Transition → Chapitre 02

L'outil est installé, authentifié, et on sait déjà poser une question simple. Mais Copilot CLI propose en réalité **3 façons différentes** de l'utiliser selon la situation (discuter, planifier, ou automatiser). Le chapitre 02 les détaille toutes — la base de tout le reste de la formation.

---

# Chapitre 02 — Premiers pas
### *(~45 min)*

**Analogie** : au restaurant, on peut demander l'itinéraire GPS avant de partir (**Plan**), discuter en direct avec le serveur pour ajuster sa commande (**Interactive**), ou commander au service au volant sans échange (**Programmatic**). Ces 3 façons d'obtenir le même résultat — un repas — correspondent aux 3 modes de Copilot CLI.

**Ce que les apprenants vont apprendre** :
- Choisir le bon mode d'interaction selon le contexte
- Utiliser les commandes slash essentielles au quotidien
- Faire réaliser à l'IA une revue de code, une explication, et une génération de code

---

# Chapitre 02 — Concepts clés

- **Mode Interactive** : conversation continue dans le terminal, comme discuter avec un collègue — idéal pour explorer, itérer, poser des questions de suivi.
- **Mode Plan** : Copilot propose d'abord un **plan d'action détaillé**, que l'apprenant valide (ou ajuste) avant toute exécution — utile pour les tâches à risque ou complexes.
- **Mode Programmatic (`-p`)** : exécution en une seule commande, sans dialogue, pensée pour être appelée depuis un script ou une automatisation (CI, boucle sur plusieurs fichiers…).
- **Commandes slash essentielles** : `/ask` (poser une question sans agir), `/clear` (vider le contexte), `/config`, `/help`, `/model` (changer de modèle), `/plan`, `/refine`, `/research`, `/exit`.

---

# TP — Chapitre 02 — Rôle et objectif

**Rôle pédagogique** : TP de **pratique guidée** — 3 démonstrations ciblées (une par mode) avant de laisser l'apprenant explorer librement.

**Pourquoi ce TP existe** : comprendre un mode en le lisant est une chose ; voir la différence de comportement de l'IA entre les 3 modes sur le **même** code en est une autre, beaucoup plus parlante.

**Support** : `book_app.py` et `books.py` de l'app exemple.

---

# TP — Chapitre 02 — Déroulé pas à pas

1. Démo 1 — demander une revue de code sur `books.py` (mode Interactive).
2. Démo 2 — faire expliquer une portion de code confuse.
3. Démo 3 — faire générer une nouvelle fonction.
4. Exploration interactive libre, puis utiliser `/plan` pour préparer une fonctionnalité de recherche.
5. Lancer une revue programmatique en boucle sur tous les fichiers `.py` du projet (mode Programmatic).

---

# TP — Chapitre 02 — Exercice & critères de réussite

**Exercice principal** : améliorer `utils.py` en 4 étapes guidées par l'IA — résumer le fichier, ajouter de la validation, gérer les erreurs, ajouter des docstrings.

**Critère de réussite** : `pytest -v` s'exécute sans **aucun** test en échec ni en erreur après les modifications.

**Bonus** : réaliser la même tâche nouvelle (`list_by_year()`) avec chacun des 3 modes, et comparer lequel a semblé le plus naturel pour ce cas précis.

---

# Quiz — Chapitre 02

1. Quel mode utiliser pour une tâche automatisée, sans interaction, appelée depuis un script ?
2. Quel critère valide la réussite de l'exercice sur `utils.py` ?
3. **Vrai ou faux** : le mode Plan exécute directement les modifications qu'il propose.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 02

1. Le mode **Programmatic** (`copilot -p`) — il n'attend aucune saisie interactive et retourne un résultat exploitable par un script, exactement comme n'importe quelle autre commande CLI qu'on chaînerait dans une automatisation.
2. `pytest -v` **doit s'exécuter sans test en échec ni en erreur** après les modifications — c'est un critère objectif et automatisable, pas une simple impression subjective de "ça a l'air bon".
3. **Faux** — le mode Plan **propose** une séquence d'actions détaillée mais attend une validation explicite de l'apprenant avant d'exécuter quoi que ce soit ; c'est justement ce qui le distingue du mode Interactive, où les actions peuvent s'enchaîner plus directement.

---

# Transition → Piste 2

Les fondamentaux sont posés : terminal équipé, outil installé, 3 modes maîtrisés. Mais jusqu'ici, chaque interaction repartait de zéro. La piste suivante répond à une question centrale : **comment donner à l'IA le bon contexte**, et **comment enchaîner des workflows de développement complets** plutôt que des échanges isolés ?

---

<!-- _class: lead -->

# ⚡ Piste 2 — Flux de travail quotidiens
## Chapitres 03 à 04

**Pourquoi cette piste maintenant ?** Une fois les modes maîtrisés (Ch02), l'enjeu devient la qualité des réponses : elle dépend directement du contexte fourni (Ch03) et de la capacité à enchaîner un workflow complet plutôt que des questions isolées (Ch04).

---

# Chapitre 03 — Contexte et conversations
### *(~50 min)*

**Ce que les apprenants vont apprendre** :
- Référencer précisément fichiers, dossiers ou images dans une invite
- Gérer des sessions qui survivent à la fermeture du terminal, y compris sur plusieurs jours
- Comprendre et maîtriser la fenêtre de contexte pour éviter les réponses dégradées sur de gros projets

---

# Chapitre 03 — Concepts clés

- **Syntaxe `@`** : `@fichier.py` référence un fichier précis, `@dossier/` tout un dossier, `@*.py` un glob, `@image.png` une image — Copilot lit exactement ce qui est référencé, sans deviner.
- **Sessions persistantes** : `--name` nomme une session, `--continue` reprend la dernière, `--resume` permet de choisir parmi plusieurs sessions sauvegardées — le travail peut reprendre plusieurs jours après, avec tout l'historique intact.
- **Copilot Memory** : mémoire au niveau du compte (activable avec `--enable-memory`), qui persiste des informations **au-delà** d'une seule session.
- **Fenêtre de contexte et compaction** : `/context` affiche l'espace utilisé ; au-delà d'un seuil (~80–95 %), une compaction automatique résume l'historique pour continuer à travailler ; `/compact focus on...` permet de cibler ce qui doit être conservé en priorité.
- **Troncature des sorties volumineuses** : au-delà de 20 KiB, la sortie d'un outil est tronquée automatiquement pour ne pas saturer le contexte inutilement.

---

# TP — Chapitre 03 — Rôle et objectif

**Rôle pédagogique** : TP de **mise en situation comparative** — montrer concrètement la différence entre une IA qui ne voit qu'un fragment de code et une IA qui voit tout le projet.

**Pourquoi ce TP existe** : la qualité des réponses de Copilot CLI dépend directement du contexte fourni ; ce chapitre apprend à doser ce contexte plutôt que de le subir.

**Support** : l'ensemble du projet `book-app-project`.

---

# TP — Chapitre 03 — Déroulé pas à pas

1. Faire réaliser une revue de l'intégralité du projet (`@samples/book-app-project/`).
2. Observer l'IA détecter un bug qui traverse plusieurs fichiers.
3. Demander "comprendre la base de code en 60 secondes" pour tester une synthèse rapide.
4. Réaliser un refactoring consolidé touchant plusieurs fichiers à la fois.
5. Simuler une reprise de session sur plusieurs jours (lundi → mercredi) avec `--continue`.

---

# TP — Chapitre 03 — Exercice & critères de réussite

**Exercice principal** : tracer le flux de données à travers `books.py` + `book_app.py` + `data.json`, dans une session nommée `data-flow-analysis`, puis la reprendre avec `--continue`.

**Critère de réussite** : la session reprise conserve bien le fil de l'analyse précédente (l'IA n'a pas "oublié" ce qui a été tracé).

**Bonus** : charger tout le projet avec `@samples/book-app-project/`, surveiller la croissance de `/context`, et pratiquer `/compact` pour la maîtriser.

---

# Quiz — Chapitre 03

1. Comment reprendre une session nommée précédemment interrompue ?
2. À quel seuil approximatif la compaction automatique du contexte se déclenche-t-elle ?
3. **Vrai ou faux** : `/compact focus on...` permet de cibler ce qui doit être conservé lors de la compaction.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 03

1. Avec **`--continue`** pour reprendre directement la dernière session, ou **`--resume`** si plusieurs sessions existent et qu'il faut en choisir une précise dans une liste.
2. Autour de **80 à 95 %** de la fenêtre de contexte — la compaction se déclenche avant la saturation complète pour que le travail puisse continuer sans interruption brutale.
3. **Vrai** — au lieu d'une compaction générique qui résume tout de façon égale, cette variante indique explicitly quel sujet garder en priorité dans le résumé, ce qui évite de perdre le fil sur ce qui compte pour la tâche en cours.

---

# Transition → Chapitre 04

Le contexte est maîtrisé : l'IA voit maintenant ce qu'il faut, ni plus ni moins. Reste à structurer **comment** l'utiliser au quotidien : revue, refactoring, debug, tests, intégration Git. Le chapitre 04 assemble ces briques en un vrai cycle de développement, du bug au commit.

---

# Chapitre 04 — Flux de travail de développement
### *(~60 min)*

**Analogie** : un charpentier a des ateliers distincts pour construire, réparer et contrôler la qualité de son ouvrage. De la même façon, ce chapitre présente 5 workflows indépendants, chacun dédié à une étape du cycle de développement.

**Ce que les apprenants vont apprendre** :
- Les 5 workflows autonomes de Copilot CLI pour le développement quotidien
- Enchaîner un correctif de bug jusqu'au commit, de bout en bout

---

# Chapitre 04 — Concepts clés

- **Revue de code (`/review`, `/rubber-duck`)** : analyse automatisée du code, avec `/rubber-duck` pour obtenir un second avis en formulant le problème à voix haute — une forme de "canard en plastique" numérique.
- **Refactoring** : restructuration du code guidée par l'IA, en s'appuyant sur le contexte déjà établi au chapitre 03.
- **Debugging (`!commande`)** : le préfixe `!` exécute une commande shell directement dans la conversation, pour croiser un message d'erreur réel avec l'analyse de l'IA.
- **Génération de tests** : à partir de 2-3 tests écrits manuellement, l'IA peut en générer 15+ en suivant le même style et les mêmes conventions.
- **Intégration Git (`/pr`, `/diff`, `/branch`, `/worktree`)** : Copilot peut rédiger un message de commit, ouvrir/corriger/fusionner une PR (`/pr view|create|fix|auto|automerge`), ou proposer une revue interactive du diff (`/diff`) avant de valider.

---

# TP — Chapitre 04 — Rôle et objectif

**Rôle pédagogique** : TP de **pipeline complet de bout en bout** — reproduire un vrai cycle de correction de bug, de la découverte jusqu'au commit.

**Pourquoi ce TP existe** : en conditions réelles, les workflows s'enchaînent rarement isolément ; ce TP entraîne à les relier dans un ordre cohérent.

**Support** : `samples/book-app-buggy/` et `samples/buggy-code/` (bugs intentionnels, y compris des failles de sécurité).

---

# TP — Chapitre 04 — Déroulé pas à pas

1. Partir d'un rapport de bug et le reproduire.
2. Faire proposer et appliquer un correctif par l'IA.
3. Générer ou compléter les tests correspondants.
4. `git add` puis ouvrir `/diff` pour une revue interactive du changement.
5. Faire rédiger un message de commit par l'IA, puis valider le commit.

---

# TP — Chapitre 04 — Exercice & critères de réussite

**Exercice principal** : appliquer le cycle complet (review → refactor → test → review → commit) sur la fonction `remove_book()`.

**Critère de réussite** : le commit final contient un message clair généré ou validé par l'IA, et les tests couvrant `remove_book()` passent.

**Bonus** : réaliser l'exercice externe GitHub Skills "Create applications with the Copilot CLI" (Node.js).

**✅ Point de contrôle** : à ce stade, les apprenants maîtrisent l'essentiel du quotidien (Ch02–04) — le reste de la formation ajoute de l'automatisation par-dessus ces bases.

---

# Quiz — Chapitre 04

1. Quelle commande ouvre un mode de revue interactif du diff avant commit ?
2. Sur quels dossiers s'appuie le TP de debugging, et pourquoi ne faut-il jamais les "réparer" définitivement dans le dépôt ?
3. **Vrai ou faux** : `/pr auto` peut créer une PR automatiquement.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 04

1. **`/diff`** — elle affiche le changement en cours sous une forme interactive, permettant de le parcourir et de le valider avant de committer, plutôt que de committer à l'aveugle.
2. **`samples/book-app-buggy/`** et **`samples/buggy-code/`** — leurs bugs sont **intentionnels**, ajoutés spécifiquement pour servir d'exercices de debugging à tous les apprenants qui suivront la formation après vous. Les corriger définitivement dans le dépôt priverait les prochains apprenants de l'exercice : on corrige uniquement une copie de travail.
3. **Vrai** — `/pr auto` automatise la création de la pull request à partir des changements en cours, sans nécessiter une série manuelle de commandes Git séparées.

---

# Transition → Piste 3

Le cycle "un développeur + Copilot CLI" est maîtrisé. La piste suivante change d'échelle : au lieu de dialoguer à chaque fois, on va apprendre à **déléguer** des tâches entières à des assistants spécialisés, des automatismes réutilisables, et des connexions à des systèmes externes — jusqu'à enchaîner un projet complet en une seule session.

---

<!-- _class: lead -->

# 🤖 Piste 3 — Automatisation & agents IA
## Chapitres 05 à 08

**Pourquoi cette piste maintenant ?** Une fois les workflows de base acquis (Ch02–04), on peut les industrialiser : des agents spécialisés (Ch05), des automatismes déclenchés seuls (Ch06), des connexions à l'extérieur (Ch07), puis tout assembler dans un projet réel (Ch08).

---

# Chapitre 05 — Créer des assistants IA spécialisés
### *(~55 min)*

**Analogie** : pour rénover une maison, on recrute un plombier, un électricien, un couvreur — chacun expert sur son domaine — plutôt qu'un seul généraliste pour tout faire. Les agents personnalisés jouent ce rôle pour Copilot CLI.

**Ce que les apprenants vont apprendre** :
- Créer un agent spécialisé via un fichier `.agent.md`
- Distinguer agent, skill et fichier d'instructions
- Faire collaborer plusieurs agents sur une même tâche

---

# Chapitre 05 — Concepts clés

- **Agents intégrés** : Plan, Code-review, Init, Explore, Task — déjà fournis avec Copilot CLI, sans configuration.
- **Agents personnalisés (`.agent.md`)** : fichier avec un frontmatter YAML (`name`, **`description`** obligatoire, `tools`, `target`, `model`, `model-policy`) qui définit un assistant dédié à une tâche précise.
- **Emplacement** : `.github/agents/` pour un agent partagé avec toute l'équipe sur un projet, `~/.copilot/agents/` pour un agent personnel disponible partout.
- **Fichiers de configuration projet** : `AGENTS.md` (vue d'ensemble du projet pour l'IA), `.github/copilot-instructions.md` (règles globales), `.instructions.md` avec `applyTo` (règles ciblées sur certains fichiers) — trois niveaux de granularité différents.
- **Agent vs skill vs instructions** : un agent est un **assistant qu'on invoque**, un skill est une **procédure qui se déclenche automatiquement**, un fichier d'instructions est une **règle passive toujours appliquée** — trois mécanismes complémentaires, pas interchangeables.

---

# TP — Chapitre 05 — Rôle et objectif

**Rôle pédagogique** : TP **comparatif** — opposer un agent spécialisé à une invite générique sur la même tâche, puis faire collaborer deux agents.

**Pourquoi ce TP existe** : la valeur d'un agent spécialisé n'est évidente qu'en la comparant directement à l'alternative générique, sur le même problème.

**Support** : `book-app-project`, suite `pytest` existante comme filet de sécurité.

---

# TP — Chapitre 05 — Déroulé pas à pas

1. Comparer une invite générique et un agent spécialisé sur la même demande.
2. Créer un agent `python-reviewer` dédié à la revue de code Python.
3. Créer un agent `pytest-helper` dédié aux tests.
4. Faire collaborer les deux agents sur une même tâche et observer leur complémentarité.

---

# TP — Chapitre 05 — Exercice & critères de réussite

**Exercice principal** : créer 3 agents personnalisés — `data-validator`, `error-handler`, `doc-writer` — et vérifier que la suite pytest reste à **au moins 5 tests réussis** avant et après leur utilisation.

**Critère de réussite** : les 3 agents existent avec un frontmatter valide, et le nombre de tests pytest réussis n'a pas régressé.

**Bonus** : construire une bibliothèque de 3 fichiers `.instructions.md` ciblés (`applyTo`).

---

# Quiz — Chapitre 05

1. Où placer un agent destiné à être partagé avec toute l'équipe sur un projet ?
2. Quel champ du frontmatter `.agent.md` est obligatoire ?
3. **Vrai ou faux** : un agent personnalisé peut restreindre les outils qu'il est autorisé à utiliser.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 05

1. **`.github/agents/`** — cet emplacement, versionné avec le projet, rend l'agent disponible à tous les membres de l'équipe qui clonent le dépôt, contrairement à `~/.copilot/agents/` qui reste personnel à une machine.
2. **`description`** — c'est le champ que Copilot utilise pour décider **quand** proposer cet agent ; sans description claire, l'agent existe mais ne sera jamais suggéré au bon moment.
3. **Vrai** — le champ `tools` du frontmatter permet de limiter précisément les capacités de l'agent (par exemple l'empêcher d'exécuter des commandes shell), ce qui réduit les risques si l'agent est partagé avec toute une équipe.

---

# Transition → Chapitre 06

Les agents personnalisés se déclenchent quand on les **invoque explicitement**. Le chapitre 06 introduit un mécanisme complémentaire : des automatismes qui se déclenchent **seuls**, dès que le contexte de la conversation le justifie — les skills.

---

# Chapitre 06 — Automatiser les tâches répétitives (Skills)
### *(~55 min)*

**Analogie** : une perceuse à embouts interchangeables — le même outil de base, mais un embout spécifique pour chaque type de vis. Les skills sont ces embouts pour Copilot CLI : des procédures prêtes à l'emploi qui s'activent au bon moment.

**Ce que les apprenants vont apprendre** :
- Créer un skill qui se déclenche automatiquement selon le contexte
- L'invoquer aussi directement quand on le souhaite
- Évaluer la sécurité d'un skill avant de l'installer

---

# Chapitre 06 — Concepts clés

- **Agent Skill** : un dossier contenant un fichier `SKILL.md` avec deux champs obligatoires — `name` et `description` — c'est cette description qui permet à Copilot de savoir quand se déclencher tout seul.
- **Invocation directe** : `/nom-du-skill <prompt>` force le déclenchement immédiat, sans attendre que le contexte le justifie ; plusieurs skills peuvent même être combinés dans un seul message.
- **Emplacement** : `.github/skills/` pour un skill de projet, `~/.copilot/skills/` pour un skill personnel — même logique de portée que pour les agents.
- **Cycle de vie** : créer → tester → éditer → partager → maintenir — un skill n'est jamais figé, il s'affine avec l'usage.
- **Sécurité** : un skill tiers exécute des instructions écrites par quelqu'un d'autre ; une checklist de vérification est recommandée avant toute installation, exactement comme pour une dépendance de code externe.

---

# TP — Chapitre 06 — Rôle et objectif

**Rôle pédagogique** : TP de **construction progressive** — enchaîner la création de plusieurs skills, du plus simple au plus élaboré.

**Pourquoi ce TP existe** : comprendre la structure d'un skill est simple ; savoir en écrire une description qui déclenche fiablement au bon moment demande de la pratique répétée.

**Support** : `book-app-project`.

---

# TP — Chapitre 06 — Déroulé pas à pas

1. Construire `security-audit`, un skill appliquant une checklist OWASP.
2. Construire `pytest-gen`, un skill de génération de tests, à partir de zéro.
3. Construire `pr-review`, un skill de revue de pull request, à partir de zéro.
4. Vérifier pour chacun que le déclenchement automatique fonctionne dans le bon contexte.

---

# TP — Chapitre 06 — Exercice & critères de réussite

**Exercice principal** : créer le skill `book-summary`, qui produit un tableau Markdown listant les livres avec un statut ✅/❌ de lecture. Tester à la fois son **déclenchement automatique** et son **invocation directe** (`/book-summary`).

**Critère de réussite** : le tableau généré est correct dans les deux modes de déclenchement.

**Bonus** : créer un skill `commit-message`, le partager sur GitHub avec le tag `copilot-skill`.

---

# Quiz — Chapitre 06

1. Quels sont les deux champs obligatoires d'un `SKILL.md` ?
2. Comment invoquer un skill directement, sans attendre son déclenchement automatique ?
3. **Vrai ou faux** : il faut vérifier un skill avant de l'installer, comme on vérifierait une dépendance externe.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 06

1. **`name`** et **`description`** — le `name` identifie le skill (notamment pour l'invocation directe), et la `description` est le texte que Copilot compare au contexte de la conversation pour décider de se déclencher automatiquement ou non.
2. **`/nom-du-skill <prompt>`** — cette syntaxe court-circuite la détection automatique et force l'exécution immédiate, utile quand on sait déjà précisément quel skill on veut utiliser.
3. **Vrai** — un skill tiers contient des instructions écrites par une personne extérieure à l'équipe ; comme pour une librairie logicielle externe, il faut en lire le contenu avant de l'exécuter, car il peut potentiellement accéder à des fichiers ou exécuter des commandes.

---

# Transition → Chapitre 07

Les agents et les skills automatisent des tâches **internes** au projet. Mais Copilot CLI reste, par défaut, isolé du reste de l'écosystème (GitHub, bases de données, API…). Le chapitre 07 ouvre cette connexion via le protocole **MCP**.

---

# Chapitre 07 — Se connecter à GitHub, bases de données et API (MCP)
### *(~50 min)*

**Analogie** : les extensions de navigateur ajoutent des capacités précises sans changer le navigateur lui-même — un gestionnaire de mots de passe, un correcteur orthographique, un gestionnaire de fichiers cloud. Les serveurs MCP jouent exactement ce rôle pour Copilot CLI.

**Ce que les apprenants vont apprendre** :
- Les 3 types de serveurs MCP et quand utiliser chacun
- Configurer et diagnostiquer un serveur MCP
- Combiner plusieurs serveurs dans un même workflow

---

# Chapitre 07 — Concepts clés

- **Serveur MCP intégré** : par exemple le serveur GitHub, déjà fourni, sans configuration à écrire soi-même.
- **Serveur MCP local (`stdio`)** : un processus lancé localement (ex. Filesystem), qui communique avec Copilot CLI via son entrée/sortie standard.
- **Serveur MCP distant (HTTP/OAuth)** : un service accessible en ligne (ex. Context7), avec authentification.
- **Configuration (`mcp-config.json`)** et **dashboard unifié (`/mcp`)** : point d'entrée unique pour lister, configurer et rechercher des serveurs (`/mcp search`).
- **Diagnostic en 4 étapes** en cas de panne : la configuration est-elle valide ? le serveur démarre-t-il ? expose-t-il des outils ? un appel d'outil aboutit-il ?

---

# TP — Chapitre 07 — Rôle et objectif

**Rôle pédagogique** : TP en deux temps — des démonstrations serveur par serveur, puis des workflows qui en combinent plusieurs.

**Pourquoi ce TP existe** : un serveur MCP pris isolément a un intérêt limité ; c'est leur **combinaison** qui démontre la vraie valeur ajoutée (croiser des données locales et distantes dans une seule requête).

**Support** : `book-app-project`, GitHub, Filesystem MCP, Context7 MCP.

---

# TP — Chapitre 07 — Déroulé pas à pas

1. Démonstration du serveur GitHub MCP seul.
2. Démonstration du serveur Filesystem MCP seul.
3. Démonstration du serveur Context7 MCP seul.
4. Workflow combiné : exploration croisée, transformation d'une issue GitHub en PR, tableau de bord de santé du projet.

---

# TP — Chapitre 07 — Exercice & critères de réussite

**Exercice principal** : combiner Filesystem MCP et GitHub MCP sur `book-app-project` pour retrouver une anomalie de données (un livre "Mysterious Book" avec un auteur vide et une année à 0), puis comparer la couverture de tests actuelle du projet.

**Critère de réussite** : l'anomalie est identifiée avec précision (quel livre, quels champs) et documentée.

**Bonus** : construire un serveur MCP personnalisé, en suivant `mcp-custom-server.md`.

---

# Quiz — Chapitre 07

1. Quelles sont les 3 catégories de serveurs MCP ?
2. Quelle anomalie de données l'exercice principal demande-t-il de retrouver ?
3. Quelles sont les 4 étapes du diagnostic d'un serveur MCP en panne ?

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 07

1. **Intégré** (fourni nativement, ex. GitHub), **local** (processus `stdio` lancé sur la machine, ex. Filesystem), **distant** (service HTTP/OAuth accessible en ligne, ex. Context7) — la différence porte sur **où** s'exécute le serveur et comment il s'authentifie.
2. Un livre nommé **"Mysterious Book"**, avec un **auteur vide** et une **année à 0** — un exemple typique de donnée mal saisie qu'une combinaison Filesystem + GitHub MCP permet de repérer puis de documenter dans une issue.
3. **Configuration** (le fichier `mcp-config.json` est-il valide ?) → **démarrage** (le processus/serveur répond-il ?) → **outils** (expose-t-il bien une liste d'outils exploitables ?) → **appel** (un appel réel à un outil aboutit-il au résultat attendu ?). Diagnostiquer dans cet ordre évite de chercher un bug d'appel alors que le serveur ne démarre même pas.

---

# Transition → Chapitre 08

Modes d'interaction, contexte, workflows, agents, skills, MCP : toutes les briques sont désormais posées séparément. Le chapitre 08, dernier du tronc commun, les assemble dans **un seul parcours guidé**, de l'idée initiale jusqu'à la pull request fusionnée.

---

# Chapitre 08 — Tout assembler
### *(~75 min — dernier chapitre du tronc commun)*

**Analogie** : dans un orchestre, les cordes posent la base rythmique (workflows de base), les cuivres portent la mélodie (agents), les bois ajoutent de la nuance (skills), les percussions structurent l'ensemble (MCP) — c'est leur combinaison qui produit une œuvre complète, pas un seul pupitre isolé.

**Ce que les apprenants vont apprendre** :
- Enchaîner idée → plan → implémentation → tests → revue → PR sans interruption
- Appliquer un "pattern d'intégration" réutilisable sur n'importe quelle nouvelle fonctionnalité

---

# Chapitre 08 — Concepts clés

- **Pattern d'intégration** : rassembler le contexte → analyser/planifier → exécuter → conclure — une boucle générique applicable à toute tâche de développement, pas seulement à l'exemple du chapitre.
- **Parcours guidé principal** : volontairement limité aux fondamentaux des chapitres 00–04, pour prouver qu'un cycle complet ne nécessite pas forcément d'agents ou de skills avancés.
- **Variante enrichie (optionnelle)** : la même fonctionnalité peut être reconstruite en s'appuyant sur des agents personnalisés, pour comparer les deux approches.
- **Audit de configuration (`/env`)** : commande qui liste précisément quels agents, skills et instructions sont réellement chargés dans la session en cours — utile pour comprendre pourquoi l'IA se comporte d'une certaine façon.

---

# TP — Chapitre 08 — Rôle et objectif

**Rôle pédagogique** : TP de **synthèse finale** du tronc commun — à la fois exercice d'application et évaluation implicite de tout ce qui a été appris depuis le chapitre 00.

**Pourquoi ce TP existe** : c'est le seul exercice qui force à enchaîner **toutes** les étapes d'un vrai cycle de développement dans une seule session continue, sans étape sautée.

**Support** : `book-app-project`.

---

# TP — Chapitre 08 — Déroulé pas à pas

1. Partir d'une idée de fonctionnalité ("recherche par plage d'années").
2. Utiliser le mode Plan pour structurer l'implémentation.
3. Implémenter le code avec l'IA.
4. Générer et exécuter les tests correspondants.
5. Faire une revue du diff, puis ouvrir et documenter la pull request.

---

# TP — Chapitre 08 — Exercice & critères de réussite

**Exercice principal** : construire la fonctionnalité "recherche par plage d'années" de bout en bout, en documentant chaque étape du processus suivi.

**Critère de réussite** : chaque étape du pattern d'intégration (contexte → plan → exécution → conclusion) est identifiable dans la documentation produite, et les tests de la fonctionnalité passent.

*À ce stade, le tronc commun (00–08) est terminé — direction les modules bonus (09–18), à choisir librement selon les besoins.*

---

# Quiz — Chapitre 08

1. Quelles sont les 4 étapes du "pattern d'intégration" présenté dans ce chapitre ?
2. Quelle commande permet d'auditer la configuration (agents/skills/instructions) réellement chargée dans la session ?
3. **Vrai ou faux** : ce chapitre s'appuie sur des fonctionnalités avancées (agents, skills, MCP) vues aux chapitres 05–07.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 08

1. **Rassembler le contexte → analyser/planifier → exécuter → conclure.** C'est un cycle générique : "rassembler le contexte" correspond à ce qui a été appris au Ch03, "analyser/planifier" au mode Plan du Ch02, "exécuter" aux workflows du Ch04, et "conclure" à l'intégration Git également du Ch04.
2. **`/env`** — elle liste la configuration réellement active dans la session (agents, skills, fichiers d'instructions chargés), ce qui permet de comprendre pourquoi l'IA réagit d'une certaine façon plutôt que d'une autre.
3. **Faux** — le parcours guidé principal n'utilise volontairement que les fondamentaux des chapitres 00–04, pour prouver qu'un cycle complet est possible sans outillage avancé. Une variante enrichie avec agents existe, mais reste optionnelle.

---

<!-- _class: lead -->

# 🎓 Piste 4 — Aller plus loin avec les commandes natives
## Chapitres 11 et 13

**Pourquoi cette piste maintenant ?** Une fois le cycle complet maîtrisé (Ch08), deux commandes natives méritent un chapitre dédié : la sécurisation systématique du code avant commit (Ch11), et l'exploitation de l'historique des sessions passées pour progresser (Ch13).

---

# Chapitre 11 — Sécuriser votre code avec Copilot CLI
### *(~40 min)*

**Analogie** : `/security-review` est un contrôle de sécurité rapide à l'aéroport — efficace et systématique — tandis que des outils comme CodeQL, Dependabot ou Snyk sont une inspection douanière approfondie, plus lente mais plus exhaustive. Les deux sont complémentaires, pas substituables.

**Ce que les apprenants vont apprendre** :
- Scanner un diff avec `/security-review` et interpréter sa classification par sévérité
- Reconnaître les grandes catégories de vulnérabilités courantes
- Restreindre finement les outils autorisés à l'IA

---

# Chapitre 11 — Concepts clés

- **`/security-review`** (expérimental, nécessite `/experimental`) : scanne le diff staged/unstaged et classe chaque trouvaille par sévérité — Critical, High, Medium, Low.
- **Catégories de vulnérabilités** : injection (SQL notamment), XSS, SSRF, désérialisation non sûre, cryptographie faible, secrets en dur dans le code, failles d'authentification/CORS, et XPIA (injection de prompt via un contenu externe).
- **Instructions de sécurité par défaut** : `.github/copilot-instructions.md` peut porter des règles de sécurité systématiquement appliquées par l'IA sur le projet.
- **Permissions fines d'outils** : `--allow-tool`/`--deny-tool` (et leurs équivalents de session `--available-tools`/`--excluded-tools`) permettent de restreindre précisément ce que l'IA a le droit de faire — un refus explicite (`deny`) l'emporte toujours sur une autorisation.

---

# TP — Chapitre 11 — Rôle et objectif

**Rôle pédagogique** : TP d'**audit de sécurité complet**, mené dans un environnement de travail **jetable** pour ne jamais modifier le code source réel des exercices.

**Pourquoi ce TP existe** : détecter une vulnérabilité est une chose, la valider manuellement et la corriger correctement en est une autre — ce TP entraîne le cycle complet.

**Support** : une copie temporaire de `samples/buggy-code/python/user_service.py`.

---

# TP — Chapitre 11 — Déroulé pas à pas

1. Copier `user_service.py` dans un dossier de travail temporaire (jamais dans le dépôt).
2. Lancer `/security-review` et lister les vulnérabilités trouvées (injection SQL, mot de passe loggé, secret JWT en dur, MD5, `pickle.loads()`).
3. Valider **manuellement** chaque trouvaille (éviter les faux positifs).
4. Corriger **uniquement dans la copie de labo**.
5. Relancer `/security-review` pour confirmer la résolution.

---

# TP — Chapitre 11 — Exercice & critères de réussite

**Exercice principal** : répéter exactement le même scénario sur `payment_processor.py`, dans un nouveau dossier de labo temporaire distinct.

**Critère de réussite** : un second scan de sécurité après correction ne remonte plus les vulnérabilités initialement identifiées.

**Bonus** : ajouter une section "Sécurité" à ses propres `.github/copilot-instructions.md`, puis vérifier son effet avec une invite neutre (sans mentionner la sécurité).

---

# Quiz — Chapitre 11

1. Pourquoi le TP travaille-t-il toujours sur une **copie temporaire** du code vulnérable ?
2. Citer deux catégories de vulnérabilités détectables par `/security-review`.
3. **Vrai ou faux** : `/security-review` est une commande stable, activée par défaut.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 11

1. Pour ne **jamais modifier le code source réel** du dépôt d'exercices — ces fichiers doivent rester vulnérables pour que les prochains apprenants puissent refaire le même exercice de détection. On corrige uniquement une copie de travail, jetable après l'exercice.
2. Exemples valides : injection SQL, secrets en dur, désérialisation non sûre (`pickle.loads()`), cryptographie faible (MD5), XPIA (injection de prompt). Le point commun : ce sont des catégories reconnaissables indépendamment du langage de programmation utilisé.
3. **Faux** — `/security-review` est explicitement **expérimentale** et doit être activée via `/experimental` ; elle n'est pas disponible par défaut, contrairement à des commandes comme `/review`.

---

# Transition → Chapitre 13

La sécurité protège le code produit. Mais après plusieurs semaines d'utilisation de Copilot CLI, une autre question se pose : **que s'est-il passé dans mes sessions précédentes ?** Le chapitre 13 répond à cette question avec `/chronicle`, l'historique complet des sessions passées.

---

# Chapitre 13 — Explorer l'historique de vos sessions avec `/chronicle`
### *(~30 min)*

**Analogie** : `/rewind` est la touche "annuler" d'une session en cours — utile mais limitée au présent. `/chronicle` est le journal de bord d'un capitaine : il retrace **toutes** les sessions passées, pas seulement la dernière.

**Ce que les apprenants vont apprendre** :
- Interroger l'historique complet de ses sessions passées
- Obtenir des recommandations personnalisées d'amélioration de sa configuration

---

# Chapitre 13 — Concepts clés

- **`/chronicle standup`** : génère un rapport d'activité, par défaut sur les dernières 24h.
- **`/chronicle tips` / `cost-tips`** : conseils personnalisés, notamment pour réduire les coûts.
- **`/chronicle search`** : recherche littérale à travers **toutes** les sessions passées, pas seulement la session en cours.
- **`/chronicle improve`** : détecte des frictions répétées dans l'historique et propose des ajouts concrets à `.github/copilot-instructions.md`.
- **`/chronicle skills review`** : propose des brouillons de `SKILL.md` détectés à partir de workflows répétés, que l'apprenant peut accepter ou rejeter.

---

# TP — Chapitre 13 — Rôle et objectif

**Rôle pédagogique** : TP de **découverte pratique**, sous-commande par sous-commande, sur un historique réel de sessions déjà accumulé pendant la formation.

**Pourquoi ce TP existe** : `/chronicle` n'a de valeur que si l'apprenant a déjà un historique substantiel — ce chapitre arrive volontairement après plusieurs heures d'usage cumulé.

**Support** : l'historique de sessions de l'apprenant lui-même.

---

# TP — Chapitre 13 — Déroulé pas à pas

1. Exécuter `/chronicle standup` et lire le rapport d'activité généré.
2. Exécuter `/chronicle tips`.
3. Exécuter `/chronicle search <mot-clé>` sur un ancien correctif de bug.
4. Exécuter `/chronicle improve`.
5. Exécuter `/chronicle skills review` et examiner les propositions.

---

# TP — Chapitre 13 — Exercice & critères de réussite

**Exercice principal** : utiliser `/chronicle search` pour retrouver une session ayant touché `books.py` ou `utils.py`, puis résumer par écrit la décision technique qui y avait été prise.

**Critère de réussite** : le résumé écrit correspond fidèlement à ce que révèle la session retrouvée.

**Bonus** : exécuter `/chronicle cost-tips` et noter la première recommandation d'optimisation (elle prépare directement le chapitre 14).

---

# Quiz — Chapitre 13

1. Quelle sous-commande génère un rapport d'activité, par défaut sur les dernières 24h ?
2. Quelle sous-commande peut proposer d'ajouter des règles à `copilot-instructions.md` ?
3. **Vrai ou faux** : `/chronicle search` recherche uniquement dans la session en cours.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 13

1. **`/chronicle standup`** — pensée comme un point d'équipe quotidien, elle résume l'activité récente (24h par défaut) sans avoir à relire manuellement chaque session.
2. **`/chronicle improve`** — elle analyse les frictions répétées dans l'historique (mêmes corrections demandées plusieurs fois, mêmes erreurs) et en déduit des règles concrètes à ajouter aux instructions du projet.
3. **Faux** — contrairement à `/rewind` qui agit sur la session en cours, `/chronicle search` recherche à travers **l'historique complet de toutes les sessions passées**, c'est justement ce qui en fait son intérêt.

---

# Transition → Modules bonus

Le tronc commun et les commandes natives couvrent tout ce dont un usage quotidien de Copilot CLI a besoin. Les 8 chapitres bonus suivants sont **indépendants les uns des autres** : chaque équipe ou apprenant peut piocher selon ses besoins (isolation, sécurité renforcée, coûts, prompt engineering, automatisation visuelle…), sans ordre imposé.

---

<!-- _class: lead -->

# 🎁 Piste 5 — Modules bonus
## Chapitres 09, 10, 12, 14–18

**Comment les aborder ?** Aucun ordre n'est requis entre ces chapitres. Un mot-clé par chapitre pour s'orienter : 09 = isolation, 10 = RAG documentaire, 12 = recul critique, 14 = coûts, 15 = prompt engineering, 16 = parallélisme, 17 = coûts MCP, 18 = automatisation visuelle.

---

# Chapitre 09 — Environnements isolés
### *(bonus, ~60 min, Docker recommandé)*

**Analogie** : un dev container est un atelier partagé (bien rangé, mais accessible à d'autres), un sandbox natif est une cage grillagée (visible mais contenue), un Docker Sandbox est un atelier verrouillé (isolation maximale). Trois niveaux de confinement pour trois niveaux de risque.

**Ce que les apprenants vont apprendre** :
- Utiliser un dev container prêt à l'emploi pour Copilot CLI
- Activer un sandbox natif qui limite l'accès aux fichiers par défaut
- Lancer Copilot dans un Docker Sandbox avec politique réseau stricte

---

# Chapitre 09 — Concepts clés

- **Dev container** (`.devcontainer/devcontainer.json`) : environnement de développement conteneurisé standard, avec une Feature officielle `copilot-cli` prête à l'emploi.
- **Sandbox natif** (`/sandbox enable`) : applique une politique **deny-by-default** sur les fichiers — tout accès doit être explicitement autorisé (lecture, écriture, lecture seule, ou refusé) ; `--allow-tool`/`--deny-tool` affinent ce comportement.
- **Docker Sandbox** (`sbx run copilot`) : isolation complète avec une politique réseau configurable (`sbx policy init deny-all` bloque tout accès réseau par défaut, puis on ajoute une liste blanche si nécessaire).
- **Image Docker personnalisée** : possibilité de construire sa propre image embarquant GitHub CLI et toute la stack terminal du chapitre 00.

---

# TP — Chapitre 09 — Rôle et objectif

**Rôle pédagogique** : TP en **4 temps progressifs**, du confinement le plus léger (dev container) au plus strict (image Docker personnalisée).

**Pourquoi ce TP existe** : donner à l'IA un accès large (`--allow-all`) est parfois nécessaire pour aller vite ; ce chapitre apprend à le faire **sans risque** pour le reste de la machine.

**Support** : un dev container, le sandbox natif, Docker Sandbox.

---

# TP — Chapitre 09 — Déroulé pas à pas

1. Ouvrir le projet dans le dev container.
2. Activer le sandbox natif et tester son isolation : créer un fichier "côté hôte" (hors du périmètre autorisé) et vérifier que Copilot ne peut pas le lire.
3. Lancer une revue automatisée dans un Docker Sandbox, avec une politique réseau restrictive.
4. Construire et vérifier une image Docker personnalisée embarquant tout l'outillage nécessaire.

---

# TP — Chapitre 09 — Exercice & critères de réussite

**Exercice principal** : écrire un script de revue automatisée totalement verrouillé — politique réseau `deny-all` + `sbx run copilot` — qui produit un fichier `review.md`.

**Critère de réussite** : le script s'exécute sans accès réseau non autorisé, et `review.md` est bien généré.

**Bonus** : combiner dev container **et** sandbox natif dans un même environnement de travail.

---

# Quiz — Chapitre 09

1. Quelle est la politique de fichiers par défaut du sandbox natif ?
2. Quelle commande initialise une politique réseau "tout refuser" pour Docker Sandbox ?
3. **Vrai ou faux** : dans le TP, on vérifie l'isolation en créant un fichier côté hôte et en confirmant que Copilot ne peut pas y accéder depuis le sandbox.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 09

1. **Deny-by-default** — par défaut, aucun accès fichier n'est autorisé ; chaque accès (lecture, écriture) doit être explicitement accordé, ce qui inverse la logique habituelle d'un terminal classique où tout est accessible sauf restriction explicite.
2. **`sbx policy init deny-all`** — elle initialise une politique réseau qui bloque tout accès sortant par défaut ; une liste blanche peut ensuite être ajoutée pour les destinations légitimes.
3. **Vrai** — c'est précisément la méthode de vérification utilisée dans le TP : créer un fichier hors du périmètre autorisé et confirmer que le sandbox empêche bien Copilot de le lire, preuve concrète que l'isolation fonctionne (et pas seulement en théorie).

---

# Chapitre 10 — RAG sur votre vault Obsidian
### *(bonus, ~55 min, nécessite Obsidian)*

**Analogie** : un chercheur qui consulte un dossier indexé par thème répond bien plus vite et plus précisément qu'un autre qui fouille une pile de documents en vrac. Le RAG (retrieval-augmented generation) donne à l'IA cette capacité de recherche indexée sur ses propres notes.

**Ce que les apprenants vont apprendre** :
- Les 3 étapes du RAG et à quoi chacune sert
- Connecter Copilot CLI à un vault Obsidian personnel via deux serveurs MCP complémentaires

---

# Chapitre 10 — Concepts clés

- **RAG en 3 étapes** : **récupération** (retrouver les notes pertinentes), **augmentation** (les injecter dans le contexte de la question), **génération** (produire une réponse qui s'appuie dessus, avec citations).
- **Serveur Local REST API** : accès direct au vault Obsidian (lecture/écriture de notes), pensé pour une recherche **littérale** (`search_simple`).
- **Serveur Smart Connections** : embeddings calculés localement, pour une recherche **sémantique** (`search_notes`) qui trouve des notes pertinentes même sans mot-clé exact commun.
- **Recherche hybride** : combiner les deux serveurs donne à la fois la précision du littéral et la couverture du sémantique.
- **Localité des données** : les embeddings et l'index restent locaux ; seul le texte effectivement envoyé au modèle quitte la machine.

---

# TP — Chapitre 10 — Rôle et objectif

**Rôle pédagogique** : TP de **mise en place d'un pipeline RAG complet**, avec une étape systématique de vérification manuelle des réponses générées.

**Pourquoi ce TP existe** : un RAG mal vérifié peut produire des réponses qui semblent sourcées mais citent en réalité les mauvaises notes — ce TP entraîne le réflexe de vérification.

**Support** : un vault Obsidian personnel de l'apprenant.

---

# TP — Chapitre 10 — Déroulé pas à pas

1. Installer et indexer les deux plugins Obsidian (Local REST API, Smart Connections).
2. Connecter les deux serveurs MCP dans `.mcp.json`, avec la clé API passée en variable d'environnement (jamais en dur dans le fichier).
3. Poser une question de synthèse nécessitant de croiser au moins 3 notes distinctes.
4. Observer les citations `[[wikilink]]` produites dans la réponse.

---

# TP — Chapitre 10 — Exercice & critères de réussite

**Exercice principal** : vérifier manuellement chaque citation `[[wikilink]]` de la réponse générée — la note citée contient-elle réellement l'information attribuée ?

**Critère de réussite** : toutes les citations de la réponse sont confirmées exactes après vérification manuelle.

**Bonus** : ajouter un second vault (`SMART_VAULT_PATH` avec plusieurs chemins séparés par des virgules), puis poser une question qui traverse les deux vaults.

---

# Quiz — Chapitre 10

1. Quelles sont les 3 étapes classiques du RAG ?
2. Pourquoi vérifier manuellement les citations `[[wikilink]]` produites par l'IA ?
3. **Vrai ou faux** : la clé API du serveur Local REST API doit être écrite en dur dans `.mcp.json`.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 10

1. **Récupération** (retrouver les notes pertinentes dans le vault), **augmentation** (les ajouter au contexte de la question posée à l'IA), **génération** (produire la réponse finale en s'appuyant sur ce contexte enrichi). Sans la première étape, l'IA répondrait uniquement à partir de ses connaissances générales, sans lien avec les notes personnelles.
2. Pour s'assurer que la réponse s'appuie **réellement** sur les notes citées, et détecter une éventuelle hallucination de source — un modèle peut produire une citation plausible qui ne correspond pas exactement au contenu réel de la note.
3. **Faux** — la clé API doit être passée via une **variable d'environnement** (`${OBSIDIAN_API_KEY}`), jamais écrite en clair dans un fichier de configuration versionné, pour éviter de l'exposer accidentellement.

---

# Chapitre 12 — Comprendre l'acceptation de l'IA par les développeurs
### *(bonus, ~30 min)*

**Analogie** : l'adoption du "chercher en ligne" dans les années 2000 a mis du temps à devenir un réflexe fiable et généralisé. L'adoption de l'IA de codage aujourd'hui suit une trajectoire comparable — ce chapitre prend du recul sur des données chiffrées plutôt que sur des impressions.

**Ce que les apprenants vont apprendre** :
- Distinguer les types de preuves derrière une affirmation sur l'IA de codage
- Situer sa propre expérience par rapport à des études publiées

---

# Chapitre 12 — Concepts clés

- **GitHub Research (2022/2024)** : expérience contrôlée mesurant un gain de vitesse de l'ordre de 55 % sur une tâche précise — un exemple de **mesure expérimentale**.
- **McKinsey (2023)** : gains observés, mais fortement **dépendants de la tâche** réalisée.
- **DORA (2025)** : thèse de l'"amplificateur" — l'IA amplifie les pratiques existantes (bonnes ou mauvaises), illustrée par des cas concrets (Adidas, Booking.com).
- **Stack Overflow Developer Survey (2025)** : l'adoption de l'IA augmente, mais la **confiance** des développeurs envers ses réponses diminue.
- **LinearB (2026)** : sur 8,1 millions de PR analysées, le taux de fusion des PR générées par IA (32,7 %) reste très inférieur à celui des PR humaines (84,5 %) — la "taxe de vérification".

---

# TP — Chapitre 12 — Rôle et objectif

**Rôle pédagogique** : TP d'**auto-évaluation réflexive** — le seul chapitre du cursus sans aucune commande à taper dans un terminal.

**Pourquoi ce TP existe** : confronter son ressenti personnel à des données publiées évite de généraliser une bonne (ou mauvaise) expérience isolée à l'ensemble de l'outil.

**Support** : aucun — un tableau personnel à remplir.

---

# TP — Chapitre 12 — Déroulé pas à pas

1. Repenser à 2-3 tâches récentes réalisées avec et sans Copilot CLI.
2. Remplir un tableau "avant/après" : temps passé, nombre d'essais, erreurs rencontrées, niveau de confiance dans le résultat.
3. Comparer ce tableau personnel aux tendances des 5 études présentées.

---

# TP — Chapitre 12 — Exercice & critères de réussite

**Exercice principal** : rédiger un bilan personnel de 3 à 5 phrases comparant sa propre expérience aux études citées dans le chapitre.

**Critère de réussite** : le bilan mentionne explicitement au moins une étude et indique si l'expérience personnelle la confirme ou la nuance.

**Bonus** : trouver et résumer une étude 2025/2026 supplémentaire, non citée dans le chapitre.

---

# Quiz — Chapitre 12

1. Quels sont les 3 types de preuves distingués dans ce chapitre ?
2. Que désigne la "taxe de vérification" évoquée par l'étude LinearB ?
3. **Vrai ou faux** : toutes les études citées concluent unanimement à un gain de productivité systématique, sans nuance.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 12

1. **Mesure expérimentale** (comme l'expérience contrôlée de GitHub Research), **corrélation observée** (comme les cas d'usage DORA), et **auto-déclaratif** (comme le Stack Overflow Developer Survey, basé sur des réponses subjectives). Chaque type a un niveau de fiabilité différent — une mesure expérimentale contrôlée est plus robuste qu'une simple déclaration d'intention.
2. Le temps et l'effort supplémentaires nécessaires pour **vérifier** le code généré par IA avant de pouvoir le fusionner en confiance — l'étude LinearB l'illustre par le taux de fusion bien plus faible des PR IA (32,7 %) comparé aux PR humaines (84,5 %) sur 8,1 millions de PR analysées.
3. **Faux** — les études présentées nuancent systématiquement leurs conclusions (dépendance à la tâche pour McKinsey, thèse de l'amplificateur pour DORA qui peut jouer dans les deux sens) : aucune n'affirme un gain automatique et universel.

---

# Chapitre 14 — Analyser sa consommation de tokens avec RTK et Tokscale
### *(bonus, ~45 min)*

**Analogie** : Tokscale est un compteur électrique — il mesure la consommation après coup. RTK se veut une ampoule basse consommation — il réduit la consommation à la source, en compressant les sorties verbeuses avant qu'elles n'atteignent le modèle.

**Ce que les apprenants vont apprendre** :
- Consulter sa consommation de crédits IA avec les outils natifs
- Comprendre ce que RTK compresse concrètement — et ses limites
- Garder un regard critique sur des statistiques d'outil auto-déclarées

---

# Chapitre 14 — Concepts clés

- **Crédits IA GitHub** : modèle de facturation où 1 crédit = 0,01 $, avec une allocation qui varie selon le plan (Free/Pro/Pro+/Max).
- **Contrôles natifs de budget** : `/usage` (consommation actuelle), `/context` (occupation de la fenêtre de contexte), `/limits` (plafonds configurés), `--max-ai-credits` (plafond par commande).
- **RTK** : proxy Rust qui compresse les sorties verbeuses de commandes courantes (git, npm, cargo, pytest, docker, kubectl) avant qu'elles n'atteignent le modèle.
- **Point de vigilance central** : un benchmark **indépendant** mené par JetBrains a montré que les 99,8 % de "gains" auto-déclarés par `rtk gain` correspondaient, dans certaines conditions, à une **hausse réelle de +7,6 %** de la facturation. Une statistique auto-déclarée par un outil n'est pas la même chose qu'une facture réelle.

---

# TP — Chapitre 14 — Rôle et objectif

**Rôle pédagogique** : TP de **mesure comparative** — le but explicite n'est pas seulement d'utiliser RTK, mais d'apprendre à **ne pas se fier aveuglément** à ses statistiques auto-déclarées.

**Pourquoi ce TP existe** : sans esprit critique, un outil qui affiche "99,8 % d'économie" pourrait être adopté sans vérification, malgré un impact réel opposé documenté par un tiers indépendant.

**Support** : commandes `git`/`npm`/tests du projet.

---

# TP — Chapitre 14 — Déroulé pas à pas

1. Comparer le volume brut de `git status` à celui de `rtk proxy git status`.
2. Consulter `rtk gain` et lire son rapport d'économie auto-déclarée.
3. Lancer `npx tokscale@latest --light` pour un premier tableau de bord de coût réel.

---

# TP — Chapitre 14 — Exercice & critères de réussite

**Exercice principal** : installer RTK, comparer `git log -10` (et une exécution de tests) avec et sans RTK, puis noter le pourcentage de réduction réellement observé.

**Critère de réussite** : le pourcentage noté s'appuie sur une comparaison directe mesurée, pas uniquement sur le chiffre affiché par `rtk gain`.

**Bonus** : combiner export OTel + Tokscale pour comparer le coût réel de deux sessions distinctes.

---

# Quiz — Chapitre 14

1. Quelle est la mise en garde centrale de ce chapitre concernant RTK ?
2. Quelle commande native permet de consulter sa consommation de crédits IA sans outil tiers ?
3. **Vrai ou faux** : Tokscale nécessite une installation préalable via un gestionnaire de paquets.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 14

1. Les statistiques de gain **auto-déclarées** par RTK (`rtk gain`) peuvent diverger fortement de la **facturation réelle**, voire l'augmenter dans certaines conditions — un benchmark indépendant JetBrains a mesuré +7,6 % de facturation réelle malgré 99,8 % de "gains" affichés par l'outil lui-même.
2. **`/usage`** (complétée par `/context` pour la fenêtre de contexte et `/limits` pour les plafonds configurés) — ces commandes natives ne nécessitent aucune installation tierce.
3. **Faux** — Tokscale se lance directement via `npx tokscale@latest`, sans étape d'installation préalable, ce qui le rend rapide à essayer ponctuellement.

---

# Chapitre 15 — Rédiger des instructions IA efficaces et réutilisables
### *(bonus, ~40 min)*

**Analogie** : un post-it griffonné à la hâte laisse trop de place à l'interprétation ; un cahier des charges structuré (objectif, contraintes, format attendu) élimine l'ambiguïté avant même de commencer. La qualité d'un prompt suit la même logique.

**Ce que les apprenants vont apprendre** :
- Structurer un prompt efficace en 3 questions simples
- Réutiliser des templates de prompt plutôt que de repartir de zéro à chaque fois

---

# Chapitre 15 — Concepts clés

- **Cadre en 3 questions** : quel est l'**objectif** ? quelles sont les **contraintes** ? quel **format de sortie** est attendu ? — poser ces 3 questions avant d'écrire un prompt élimine la majorité des ambiguïtés.
- **Vocabulaire métier réel** : ancrer le prompt dans les noms de champs et concepts réels du projet (plutôt que des termes génériques) améliore nettement la pertinence des réponses.
- **Templates réutilisables** (`samples/prompt-templates/`) : fichiers Markdown prêts à remplir pour des tâches récurrentes (revue de code, correction de bug…) — Copilot CLI n'a pas de slash-commands `.prompt.md` natives comme VS Code ou JetBrains, donc ces templates restent de simples fichiers à copier-coller.
- **3 modes de livraison d'un prompt** : interactif (collé dans la conversation), fichier Markdown (référencé avec `@`), ou programmatique (`--prompt --allow-all-tools`).

---

# TP — Chapitre 15 — Rôle et objectif

**Rôle pédagogique** : TP **comparatif** — mesurer concrètement l'écart de qualité entre un prompt structuré et un prompt vague sur la même tâche.

**Pourquoi ce TP existe** : la théorie du "bon prompt" convainc peu ; voir la différence de résultat sur son propre code est bien plus marquant.

**Support** : `code-review-prompt.md`, `bug-fix-prompt.md` (dans `samples/prompt-templates/`).

---

# TP — Chapitre 15 — Déroulé pas à pas

1. Remplir `code-review-prompt.md` en ciblant `utils.py`.
2. Poser la même demande sous forme d'invite vague, sans structure.
3. Comparer les deux résultats obtenus.
4. Remplir `bug-fix-prompt.md` sur un bug réel.

---

# TP — Chapitre 15 — Exercice & critères de réussite

**Exercice principal** : créer un 4ᵉ template réutilisable, par exemple `refactor-prompt.md`, en suivant le cadre en 3 questions.

**Critère de réussite** : le template créé contient bien une section objectif, une section contraintes, et une section format de sortie.

**Bonus** : tester une implémentation `mcp2cli` contre le serveur MCP n8n du chapitre 18.

---

# Quiz — Chapitre 15

1. Quelles sont les 3 questions du cadre de prompt présenté ?
2. Pourquoi les templates de prompts sont-ils de simples fichiers Markdown copier-coller plutôt que des commandes slash natives ?
3. **Vrai ou faux** : un prompt vague et un prompt structuré produisent généralement des résultats de qualité équivalente.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 15

1. **Quel est l'objectif ? Quelles sont les contraintes ? Quel format de sortie attendu ?** — ces 3 questions couvrent respectivement le "pourquoi", les limites à respecter, et la forme exploitable du résultat ; les oublier une seule mène souvent à une réponse techniquement correcte mais inutilisable telle quelle.
2. Parce que **Copilot CLI ne propose pas nativement de slash-commands `.prompt.md`**, contrairement à VS Code ou aux IDE JetBrains — les templates restent donc de simples fichiers à copier-coller manuellement dans la conversation ou à référencer avec `@`.
3. **Faux** — c'est justement l'objet de ce TP de démontrer, sur un cas concret, que le prompt structuré produit un résultat significativement plus exploitable que le prompt vague, en particulier sur des tâches où l'ambiguïté est facile (revue de code, correction de bug).

---

# Chapitre 16 — Sessions parallèles avec les worktrees Git
### *(bonus, ~35 min)*

**Analogie** : un hôtel a une seule réception et une seule infrastructure, mais plusieurs chambres totalement indépendantes. Un worktree Git permet la même chose : un seul dépôt, mais plusieurs copies de travail actives en parallèle, chacune sur sa propre branche.

**Ce que les apprenants vont apprendre** :
- Utiliser `git worktree` pour travailler sur plusieurs branches simultanément
- Utiliser les raccourcis Copilot CLI dédiés aux worktrees

---

# Chapitre 16 — Concepts clés

- **`git worktree`** : commandes natives `add`/`list`/`remove`/`prune`/`lock`/`unlock` — chaque worktree est un dossier séparé, sur sa propre branche, mais partage le même historique Git.
- **Comparaison avec les alternatives** : cloner le dépôt duplique tout (lourd), changer de branche perd le travail en cours si non commité (risqué) — le worktree évite les deux inconvénients.
- **Raccourcis Copilot CLI (depuis v1.0.79)** : `/worktree new` (nouvelle conversation, en parallèle), `/worktree [branch]` (change de session, laisse les modifications non commitées derrière), `/move` (change de session en **emportant** les modifications), `/fork`/`/branch` (fork de conversation, sans nouveau dossier).
- **Environnement non dupliqué** : un venv Python ou des `node_modules` installés dans le dépôt principal ne sont **pas** automatiquement disponibles dans un nouveau worktree — il faut les réinstaller.

---

# TP — Chapitre 16 — Rôle et objectif

**Rôle pédagogique** : TP de **cycle de vie complet** — de la création d'un worktree jusqu'à la preuve concrète de son nettoyage.

**Pourquoi ce TP existe** : un worktree mal nettoyé s'accumule silencieusement ; ce TP entraîne le réflexe de vérifier explicitement l'état final.

**Support** : le dépôt `book-app-project` lui-même.

---

# TP — Chapitre 16 — Déroulé pas à pas

1. Créer un worktree, vérifier son existence (`git worktree list`).
2. Travailler dedans (modifications, commits).
3. Fusionner le travail, en gérant un éventuel conflit.
4. Nettoyer le worktree (`git worktree remove`).
5. Prouver le nettoyage : `git worktree list` ne doit plus le mentionner.

---

# TP — Chapitre 16 — Exercice & critères de réussite

**Exercice principal** : simuler un 3ᵉ worktree urgent pendant que deux autres sont déjà actifs, et vérifier que les 3 coexistent sans interférence.

**Critère de réussite** : `git worktree list` affiche bien les 3 worktrees simultanément, chacun sur sa propre branche.

**Bonus** : écrire un script bash automatisant créer → `copilot -p` → nettoyage automatique du worktree.

---

# Quiz — Chapitre 16

1. Quelle commande native liste tous les worktrees actifs d'un dépôt ?
2. Quelle différence essentielle entre `/worktree [branch]` et `/move` ?
3. **Vrai ou faux** : un environnement virtuel Python installé dans le dépôt principal est automatiquement disponible dans un nouveau worktree.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 16

1. **`git worktree list`** — elle affiche chaque worktree actif avec son chemin et sa branche associée, la commande de référence pour vérifier l'état réel avant et après un nettoyage.
2. **`/worktree [branch]`** change de session en **laissant** les modifications non commitées dans le worktree d'origine, tandis que **`/move`** change de session en **emportant** ces modifications avec lui — le choix dépend de si le travail en cours doit rester isolé ou suivre la nouvelle session.
3. **Faux** — l'environnement (venv, `node_modules`, dépendances installées) n'est **pas** dupliqué automatiquement ; chaque worktree nécessite sa propre réinstallation, ce qui est une source fréquente d'erreurs "ça marchait pourtant dans l'autre dossier".

---

# Chapitre 17 — mcp2cli et le coût en tokens
### *(bonus, ~35 min, complète le chapitre 07)*

**Analogie** : un standardiste relaie chaque appel entre deux interlocuteurs — pratique, mais chaque relais prend du temps. Une ligne directe évite cet intermédiaire. Un appel MCP classique passe toujours par le modèle (le standardiste) ; mcp2cli établit une ligne directe.

**Ce que les apprenants vont apprendre** :
- Comprendre pourquoi un appel MCP classique consomme des tokens, même sans génération de texte
- Utiliser mcp2cli pour appeler un serveur MCP sans passer par le modèle

---

# Chapitre 17 — Concepts clés

- **Coût de découverte** : au démarrage d'une session, le modèle doit "lire" les schémas de tous les outils exposés par les serveurs MCP connectés — un coût fixe, même si ces outils ne sont jamais utilisés.
- **Coût d'appel** : chaque résultat renvoyé par un outil MCP est lu par le modèle avant d'être reformulé — un coût récurrent à chaque appel.
- **mcp2cli** (mcp2cli.dev, Apache 2.0, projet distinct d'autres projets homonymes) : transforme un serveur MCP en **CLI typée native**, appelable directement sans passer par le modèle, donc sans ces deux coûts.
- **Deux modes de connexion** : ad hoc (`--url` ou `--stdio`, pour un usage ponctuel) ou alias nommé persistant via `link create` (pour un usage répété).

---

# TP — Chapitre 17 — Rôle et objectif

**Rôle pédagogique** : TP de **comparaison directe côte à côte** entre un appel MCP classique (via le modèle) et un appel via mcp2cli (sans modèle), sur exactement la même question.

**Pourquoi ce TP existe** : la différence de coût n'est vraiment convaincante que mesurée sur un cas identique, pas seulement expliquée en théorie.

**Support** : le serveur MCP Context7 (déjà connu depuis le chapitre 07).

---

# TP — Chapitre 17 — Déroulé pas à pas

1. Créer un alias nommé vers Context7.
2. Lister ses outils disponibles (`context7 ls --tools`).
3. Consulter l'aide d'un outil précis (`context7 resolve-library-id --help`).
4. Enchaîner `resolve-library-id` → `query-docs` pour une question sur les scopes de fixtures pytest.
5. Reproduire exactement la même question, cette fois directement via Copilot CLI (donc via le modèle).

---

# TP — Chapitre 17 — Exercice & critères de réussite

**Exercice principal** : documenter le flux complet (découvrir → inspecter → enchaîner → sauvegarder le résultat en JSON → comparer avec l'appel via Copilot), et justifier par écrit quelle approche est la plus adaptée selon le contexte.

**Critère de réussite** : la justification écrite s'appuie sur une observation concrète (coût, rapidité, ou simplicité) et pas uniquement sur une préférence.

**Bonus** : essayer mcp2cli sur le serveur Filesystem du chapitre 07.

---

# Quiz — Chapitre 17

1. Pourquoi une requête MCP classique coûte-t-elle des tokens, contrairement à mcp2cli ?
2. Quelle commande crée un alias nommé réutilisable vers un serveur MCP ?
3. **Vrai ou faux** : mcp2cli.dev est le même projet que d'autres outils portant un nom similaire.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 17

1. Parce qu'un appel MCP classique passe **toujours par le modèle** : celui-ci doit d'abord découvrir les schémas d'outils au démarrage, puis lire chaque résultat renvoyé — deux coûts en tokens. mcp2cli appelle le serveur MCP **directement**, sans jamais passer par le modèle, donc sans ces coûts.
2. **`link create`** — elle enregistre un alias persistant vers un serveur MCP donné, pour ne pas avoir à repréciser `--url`/`--stdio` à chaque appel.
3. **Faux** — le chapitre précise explicitement que **mcp2cli.dev** (Apache 2.0) est un projet **distinct** d'autres outils portant un nom similaire ; ne pas les confondre évite d'installer le mauvais outil.

---

# Chapitre 18 — Automatiser un workflow visuel avec n8n
### *(bonus, ~50 min, nécessite Docker)*

**Analogie** : un établi avec des briques visuelles préfabriquées permet d'assembler un mécanisme sans écrire de code ligne par ligne. n8n applique cette logique à l'automatisation de workflows, et Copilot CLI peut piloter cet assemblage en langage naturel.

**Ce que les apprenants vont apprendre** :
- Lancer n8n et activer son serveur MCP
- Faire construire un workflow n8n complet par Copilot CLI, à partir d'une simple description

---

# Chapitre 18 — Concepts clés

- **n8n via Docker** (`docker run ... n8nio/n8n`) : lance une instance n8n locale prête à l'emploi.
- **Serveur MCP au niveau instance** (n8n ≥ 2.13.0, endpoint `/mcp-server/http`) : expose n8n comme un serveur MCP que Copilot CLI peut piloter.
- **Connexion via `.mcp.json`** (`"type":"http"`) : relie Copilot CLI à cette instance n8n exposée.
- **Skills officiels n8n-io** : 14 skills conçus à l'origine pour Claude Code, copiés manuellement dans `.github/skills/` pour fonctionner avec Copilot CLI (pas de compatibilité native automatique).

---

# TP — Chapitre 18 — Rôle et objectif

**Rôle pédagogique** : TP de **construction réelle d'automatisation** — un vrai workflow n8n bâti uniquement à partir d'une description en langage naturel, puis testé en conditions réelles.

**Pourquoi ce TP existe** : démontrer que l'IA peut piloter un outil visuel externe entièrement via le langage naturel, sans que l'apprenant touche l'interface n8n lui-même.

**Support** : instance n8n locale (Docker), API Open Library.

---

# TP — Chapitre 18 — Déroulé pas à pas

1. Décrire en langage naturel un workflow à 3 nœuds : Webhook → requête HTTP vers l'API Open Library → nœud Set (mise en forme du résultat).
2. Laisser Copilot CLI construire ce workflow dans n8n via le serveur MCP.
3. Activer le workflow.
4. Le tester avec `curl` contre l'URL webhook de **production** (et non l'URL de test), pour valider le comportement réel.

---

# TP — Chapitre 18 — Exercice & critères de réussite

**Exercice principal** : ajouter un nœud `If`/gestion d'erreur qui gère le cas "aucun résultat trouvé" par l'API Open Library.

**Critère de réussite** : une requête `curl` sur un titre inexistant renvoie une réponse maîtrisée (pas une erreur brute non gérée).

**Bonus** : reproduire, à partir de sa seule description en langage naturel, un autre workflow n8n trouvé en ligne.

---

# Quiz — Chapitre 18

1. Pourquoi teste-t-on le webhook en production plutôt qu'en mode test dans ce TP ?
2. Quel service externe le nœud HTTP Request interroge-t-il dans le TP principal ?
3. **Vrai ou faux** : les skills n8n-io utilisés dans ce chapitre sont nativement compatibles Copilot CLI sans aucune adaptation.

*Notez vos réponses avant de continuer.*

---

# Corrigé — Chapitre 18

1. Le chapitre fait explicitement tester contre l'URL webhook de **production** (et non de test) pour valider le comportement **réel** du workflow une fois activé — un test en mode test ne garantit pas toujours le même comportement qu'en production.
2. **L'API Open Library** — le nœud HTTP Request y envoie une requête pour rechercher des informations sur un livre, à partir du titre reçu par le webhook.
3. **Faux** — ces skills sont conçus à l'origine pour Claude Code ; ils ont dû être **copiés manuellement** dans `.github/skills/` pour fonctionner avec Copilot CLI, il n'y a pas de compatibilité native automatique entre les deux écosystèmes.

---

# Annexes complémentaires
### *(non numérotées, hors parcours principal)*

| Annexe | Contenu | Prérequis |
|---|---|---|
| `additional-context.md` | Contexte image (`@screenshot.png`), permissions multi-dossiers | Chapitre 03 |
| `ci-cd-integration.md` | Revue automatisée via GitHub Actions sur PR | Chapitre 08 |
| `web-data-retrieval-and-autocli.md` | Récupération de données web fiable avec AutoCLI | Chapitre 04 |

Ces annexes ne font pas partie du parcours numéroté : elles approfondissent un point précis d'un chapitre déjà suivi, à consulter au besoin.

---

<!-- _paginate: false -->

# Merci — et ensuite ?

**Parcours complet effectué** : tronc commun (00–08) + modules "aller plus loin" (11, 13) + modules bonus choisis parmi (09, 10, 12, 14–18).

**Pour continuer** :
- Pratiquer sur ses propres projets avec les workflows du chapitre 04
- Construire sa propre bibliothèque d'agents, de skills et d'instructions
- Explorer les modules bonus non couverts en session
- Contribuer au dépôt du cours (`CONTRIBUTING.md`) avec ses retours d'expérience

**Questions ?**
