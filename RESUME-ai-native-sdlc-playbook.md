# Résumé — The AI-native SDLC Playbook (Claude Academy)

Source : https://academy.claude.com/courses/ai-native-sdlc-playbook

## Présentation générale

**"The AI-native SDLC playbook"** est un guide technique de la Claude Academy visant à transformer le cycle de vie du développement logiciel (SDLC) grâce à l'IA. Le cours explique comment adapter les processus de gestion du code à la vitesse de production accrue par les outils d'IA générative (Claude Code).

- **Durée** : ~1 heure
- **Public visé** : responsables d'ingénierie et de sécurité dans les grandes entreprises (notamment réglementées) qui utilisent déjà Claude Code mais dont les processus d'approbation restent lents
- **Prérequis** : utilisation quotidienne de Claude Code, accès à un dépôt Git modifiable, pipeline CI personnalisable
- **Structure** : 14 leçons organisées en 6 étapes (Plan, Design, Build, Test, Deploy, Maintain)

## Objectifs pédagogiques

- Identifier les goulets d'étranglement (révision, test, déploiement) qui demeurent au rythme humain malgré la génération rapide de code
- Utiliser le fichier `intent.md` pour documenter les spécifications techniques et transformer une idée en cahier des charges
- Maintenir les connaissances organisationnelles via les fichiers `CLAUDE.md` versionnés
- Intégrer l'évaluation continue et les révisions par agents IA
- Mettre en place la gouvernance avec des points d'approbation automatisés

## Le diagnostic de départ (leçon d'introduction)

Le cours part d'un constat : la génération de code s'est accélérée grâce à l'IA, mais les processus qui l'entourent (planification, revue, déploiement) sont restés au rythme humain. Trois dysfonctionnements en découlent :

1. **Les goulots d'étranglement migrent** — ils quittent l'écriture de code pour se déplacer vers la planification, la revue et le déploiement.
2. **Les contrôles deviennent obsolètes** — relire ligne par ligne n'a plus de sens quand le volume de code généré explose.
3. **Les coûts de gouvernance explosent** — les exceptions doivent transiter par des comités mensuels, incompatibles avec le rythme de production.

Message-clé qui chapeaute tout le cours : *"Humans remain accountable for every decision that requires judgment"* — l'IA accélère l'exécution, mais l'humain reste responsable de chaque décision qui exige du jugement, ces points de décision étant repositionnés aux bons endroits du cycle plutôt que supprimés.

Le playbook ne présente pas 6 phases séquentielles isolées mais **une boucle continue** où des artefacts versionnés (`intent.md`, `spec.md`, `plan.md`, diffs) déclenchent automatiquement le passage à l'étape suivante — ce fil (intent → spec → plan → code → eval → deploy → métriques → nouvel intent) relie les 6 étapes entre elles, plutôt qu'un enchaînement de silos comme dans le SDLC classique.

---

## Étape 1 — Plan

**Leçon : "Capture as intent.md"**

- Idée centrale : remplacer les tickets/user stories traditionnels par une session collaborative directe avec Claude qui transforme une idée brute en fichier `intent.md` (Markdown versionné dans Git).
- Processus en 5 étapes : décrire le problème → brainstorming itératif → génération de l'`intent.md` selon un template → correction par l'initiateur → commit dans un dépôt partagé.
- Template type : problème, résultat proposé, utilisateurs affectés, contraintes, questions ouvertes.
- Stockage recommandé : dossier `intent/` dans le repo produit (ou repo dédié si multi-projets) ; Claude.ai/Cowork pour les non-techniques.
- Gouvernance : le product owner approuve avant de passer à "Design".
- Exemple : portail self-service de statut de réclamation client (remplace les appels au centre de contact).
- Métriques : temps entre 1ère conversation et commit (semaines → heures) ; taux de "survie" des intentions (acceptées vs rejetées).

**Ce que ça change** : le goulot "rédaction de PRD" disparaît, remplacé par une session collaborative avec Claude.

---

## Étape 2 — Design

**Leçon : "Requirements and design"**

- Idée centrale : Claude prend `intent.md` et produit une spec technique (`spec.md`), contrainte par les "skills" organisationnelles (marque, sécurité, conformité, UX), avec les zones de risque signalées automatiquement.
- Processus en 6 étapes : ouverture de session avec les skills chargées + `intent.md` joint → automatisation progressive (manuel → slash command → CI/CD) → revue par le product owner → résolution des points d'inquiétude avec les policy owners → versioning conjoint de `spec.md`+`intent.md` → décision humaine de passage à "Build".
- Outils cités : **Claude Design** (bêta, maquettage), **Claude Code**.
- Bonnes pratiques : les conflits de politique sont détectés pendant la rédaction, pas en revue a posteriori ; traçabilité complète (versions des skills, prompt utilisé, approbations).
- Métriques : délai `intent.md` → `spec.md` ; nombre de commits `spec.md` après le premier `plan.md`.

**Ce que ça change** : le goulot "silo requirements/design" disparaît, fusionné dans une génération contrainte par les skills.

---

## Étape 3 — Build

### a) "Claude Code plan mode as the default starting point"

- Le mode plan (lecture seule) devient le point de départ par défaut : Claude génère un plan écrit avant tout code, l'ingénieur peut le questionner (dépendances, risques, alternatives rejetées) avant approbation.
- Processus : session en mode plan → fournir `intent.md`+`spec.md` → itérer jusqu'à ce qu'un tiers puisse implémenter à partir du seul plan → sauvegarder `plan.md` → laisser Claude implémenter en une passe → mettre à jour `plan.md` si écart.
- Exemple : "Plan: claims status self-service" avec fichiers modifiés, ordre des étapes, risques (rate-limiting API), critères de validation.
- Concept avancé : le **mode auto** applique les changements sans validation étape par étape une fois le plan approuvé (avec garde-fous CLAUDE.md/tests renforcés).
- Intégration des systèmes hérités (Jira, Figma, ServiceNow) via 3 approches possibles (repo source de vérité / système hérité source + copies Markdown / liaison par identifiants croisés) et MCP.
- Métriques : part des changements mergés au 1er passage, délai plan→validation→merge, cycles de révision par changement.

### b) "The CLAUDE.md"

- Fichier central donnant à Claude le contexte qu'un nouvel arrivant aurait besoin : conventions, commandes, architecture, erreurs fréquentes.
- 4 sections clés : commandes essentielles, conventions, architecture, erreurs fréquentes.
- Processus : `/init` pour générer une base → élaguer à l'essentiel → commit à la racine du repo → règle "chaque erreur répétée par Claude = une entrée dans CLAUDE.md".
- Contrainte forte : rester sous une page, car Claude lit tout le fichier à chaque session (contexte gaspillé sinon).
- Métriques : fréquence des erreurs répétées ; délai avant le 1er merge d'un nouvel arrivant.

### c) "Skills as institutional knowledge"

- Les skills encodent le savoir organisationnel comme "contrôles consultatifs" (rendent la conformité probable, sans la forcer techniquement — contrairement aux hooks).
- Structure : dossier `.claude/skills/<name>/SKILL.md` avec frontmatter de déclenchement + corps documentant les actions requises.
- Processus en 6 étapes : identifier un savoir appliqué de façon incohérente → rédiger à partir de la source de vérité → distribuer via repo/plugin → valider le déclenchement → maintenir la synchro avec les évolutions de politique → assurer l'adoption.
- Exemple : skill `secure-api-review` couvrant authentification (JWT), validation (schémas OpenAPI), audit (événements), classification des données sensibles.
- Complémentarité avec les hooks : skills = guident pendant l'implémentation ; hooks = imposent la limite techniquement, sans exception.
- Métriques : délai approbation politique → merge du skill ; réduction des findings PR citant la politique (tendance vers zéro).

### d) "Parallel sessions and subagents"

- Sessions parallèles = instances Claude Code indépendantes (chacune dans son propre worktree Git), qui ne se connaissent pas entre elles — seul l'ingénieur coordonne.
- Sous-agents = assistants spécialisés dans une même session, avec leur propre fenêtre de contexte, pour tâches récurrentes (ex : un "vérificateur" qui lance l'app, teste, et rapporte sans corriger).
- Prérequis : CLAUDE.md commun + boucle de feedback (étape 4) pour l'auto-vérification.
- Processus : diviser en tâches indépendantes → créer des worktrees (`claude --worktree feature-auth`) → démarrer avec 2-3 sessions puis augmenter → documenter les sous-agents récurrents dans `.claude/agents/`.
- Changement de rôle : l'ingénieur passe d'exécutant à orchestrateur.
- Métriques : sessions concurrentes/ingénieur, part du temps en orchestration, changements mergés/semaine, taux de révisions.

**Ce que ça change** : le goulot "attente de revue de conception" disparaît, le plan mode rend la revue immédiate et peu coûteuse.

---

## Étape 4 — Test

### a) "Give Claude a feedback loop"

- Différence clé avec le sous-agent vérificateur : la boucle de feedback s'exécute en continu pendant la tâche (pas juste une fois à la fin), permettant à Claude de se corriger avant que l'ingénieur ne voie l'erreur.
- Prérequis : une commande unique regroupant tous les contrôles (`make test`/`npm test`), documentée dans CLAUDE.md avec sorties attendues.
- Pour les bugfix : écrire le test en échec d'abord → demander à Claude de reproduire le bug → valider que le test échoue pour la bonne raison → protéger le fichier de test via un hook (non modifiable pendant la correction).
- Pour l'UI : fournir capture d'écran/outils navigateur + maquette de référence, laisser Claude itérer visuellement.
- Principe : "faire de la vérification une partie de la définition de terminé" (tous les tests doivent passer avant de considérer la tâche finie).
- Outils cités : make/npm, capture d'écran, MCP, OpenTelemetry.
- Métriques : taux de succès au 1er essai en CI ; temps de revue par PR ; taux d'échec en prod.

### b) "Continuous evals in CI"

- Équivalent IA-natif du contrôle qualité : une suite d'évaluations qui tourne à chaque changement de la config de l'agent (CLAUDE.md, skills, hooks).
- La suite est "vivante" : évolue avec les modèles, remplace les cas obsolètes.
- Processus : collecter 20-50 tâches réelles avec résultats attendus → formaliser en evals (prompt + critères d'acceptation : tests OK, lint propre, comportement inchangé, conformité) → exécution programmée (schedule + à chaque changement de config) → blocage des changements jusqu'à validation (régression = revue avant merge) → chaque incident de prod génère une éval permanente.
- Exemple de workflow GitHub Actions fourni (`agent-evals.yml`, déclenché sur PR touchant CLAUDE.md/.claude/** + cron quotidien).
- Outils : Claude Code non-interactif, GitHub Actions, jq, scripts shell.
- Métriques : taux de réussite des evals à chaque run ; rapidité de conversion incident→éval permanente ; proportion régressions détectées en CI vs en prod.

**Ce que ça change** : le goulot "CI lente/tests tardifs" disparaît, la boucle de feedback et les evals continues détectent en instantané.

---

## Étape 5 — Deploy

### a) "AI in the PR review loop"

- Toutes les PR reçoivent le même ensemble de passes de revue automatisées, classées par gravité — l'attention humaine se concentre sur l'intention/le risque stratégique.
- Passes définies dans `REVIEW.md` : bugs/erreurs logiques, sécurité/vulnérabilités, conformité aux specs/plans, principes de conception.
- Infrastructure : service Code Review géré ou `claude-code-action` en CI/CD, protection de branche exigeant l'approbation d'un code owner, CLAUDE.md/plan.md/spec.md déjà en place.
- Bonnes pratiques : distinguer "Important" (comportement/sécurité/conformité) des "nits" (max 5 par revue) ; les findings récurrents remontent dans CLAUDE.md ; tag `@claude` en commentaire déclenche une correction + push automatique ; ajustement mensuel de la précision par le lead technique.
- Intégrations cloud citées : Amazon Bedrock, Google Vertex AI, Microsoft Foundry.
- Métriques : temps jusqu'à la 1ère revue (minutes) ; défauts détectés avant merge vs incidents en prod.

### b) "Hooks as approval gates"

- Les hooks ont deux rôles : garde-fou (étape 3, bloquer/autoriser sans humain) et porte d'approbation (étape 5, suspendre en attendant validation humaine désignée) — pas spécifiques au déploiement.
- Deux niveaux de config : settings d'équipe (`.claude/settings.json`, versionné, éditable par les ingénieurs) vs settings managés (centralisés, immuables, déployés via MDM/console admin).
- Exemple de script : bloquer toute commande contenant "deploy" + "production" sans approbation présente, avec message expliquant la raison et le chemin d'approbation.
- Contrôles entreprise réglementée : listes de refus (secrets, requêtes réseau libres) / listes d'autorisation ; sandbox OS avec domaines autorisés ; blocage des fichiers de credentials ; seuls les hooks managés s'exécutent, plugins uniquement via marketplace d'entreprise approuvée, version minimale imposée.
- Toutes les décisions sont horodatées (OpenTelemetry).
- Métriques : temps d'attente par porte d'approbation ; nombre de violations atteignant la prod avant/après implémentation.

### c) "CI/CD integration and deployment"

- Passage de pipelines déterministes à des pipelines "intelligents" : Claude exécute les étapes de jugement (triage de tests instables, changelog, diagnostic de pannes) de façon non-interactive (`claude -p`), en sandbox avec credentials à portée limitée.
- Isolation : jobs en conteneurs, politique réseau, tokens temporaires, aucune credential de prod par défaut.
- MCP pour le déploiement : remplace les scripts shell avec credentials en dur par des outils MCP à permissions limitées par environnement.
- Tiering d'autonomie : dev = libre, staging = autonomie modérée, production = l'agent prépare seulement, un release manager humain autorise.
- 4 phases : jugement lecture seule (diagnostic) → écritures contrôlées (lint, doc, via PR uniquement) → déploiement sécurisé via MCP → rollback "le chemin le plus répété du pipeline", une seule commande, testé régulièrement en staging.
- Principe directeur : l'agent peut agir jusqu'à la porte de production mais jamais la franchir seul.
- Métriques : % de pannes pipeline triées sans alerter d'humain ; métriques DORA (Deployment Frequency, Lead Time, Change Failure Rate, MTTR).

**Ce que ça change** : le goulot "revue humaine systématique + comités" disparaît, remplacé par une revue IA systématique et des hooks d'approbation ciblés uniquement sur les décisions qui comptent.

---

## Étape 6 — Maintain

**Leçon : "Closing the loop on metrics"**

- Transformation de la maintenance en boucle autonome et continue : un agent Claude tourne en arrière-plan, détecte une anomalie (seuil dépassé, ticket, message Slack), diagnostique, et génère un `intent.md` qui retraverse tout le cycle (Plan→Design→Build→Test→Deploy).
- Processus : choisir une métrique stable avec baseline sur 30 jours (ex : taux d'échec CI, erreurs 5xx post-déploiement, cycle time des PR) → script de détection déterministe (sans IA), basé sur des règles statistiques classiques (écart-type, règles de Western Electric) pour détecter dérives lentes et pics rapides.
- Niveaux de réponse dans `bands.yaml` : 1σ = enregistrement seul, 2σ = Claude diagnostique en lecture seule, 3σ = Claude peut proposer une PR ou déclencher un runbook pré-approuvé.
- Triage : l'équipe on-call revoit la file `intent.md`, priorise (maintenant/planifier/rejeter), ajuste les seuils pour réduire les faux positifs.
- Contrôles de sécurité : seuils versionnés, permissions refusant l'accès prod, chaque action horodatée/loguée, runbooks pré-approuvés uniquement.
- Nouveauté citée : **Claude Tag** (bêta publique) — Claude rejoint Slack/Teams comme premier répondant sur incidents, rédige les post-mortems, peut aussi traiter des tickets et créer des PR ou des `intent.md`.
- Métriques : temps entre détection et `intent.md` en file (vs cycle incident→post-mortem classique) ; % de findings convertis en corrections mergées ; réduction des incidents répétitifs.

**Ce que ça change** : le goulot "attente qu'un humain remarque l'incident" disparaît, la détection et le diagnostic sont autonomes, l'humain ne fait que trier/approuver.

---

## Conclusion et ressources (leçon "Closing thoughts and resources")

Le message de clôture réaffirme que l'IA transforme tout le SDLC, pas seulement l'écriture de code, tout en préservant le jugement humain et les exigences de gouvernance des grandes organisations.

13 ressources documentaires sont listées, dans l'ordre de déploiement recommandé :

- **Configuration organisationnelle** : guide d'admin Claude Code, référence des paramètres
- **Contrôles de sécurité** : gestion des permissions, sandboxing/isolation système
- **Orchestration** : hooks, skills, marketplaces privées de plugins
- **Infrastructure entreprise** : déploiement via AWS Bedrock, Google Vertex AI, Microsoft Foundry
- **Surveillance** : observabilité OpenTelemetry, tableau de bord analytique
- **Conformité** : API Enterprise pour audit d'activité et gestion des données
