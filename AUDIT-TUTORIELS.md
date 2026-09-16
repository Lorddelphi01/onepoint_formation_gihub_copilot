# Audit des tutoriels GitHub Copilot CLI

**Date de l'audit :** 16 septembre 2026  
**Périmètre :** chapitres `00` à `18`, illustrations référencées dans les README, blocs d'instructions et GIF de démonstration.

## Synthèse exécutive

Le parcours est globalement cohérent et suit bien la progression annoncée : installation, premières interactions, contexte, workflows, agents, skills, MCP, puis sujets avancés. Les chapitres `00` à `07` disposent d'un socle d'illustrations et de GIF opérationnel.

Les principaux écarts à corriger sont les suivants :

1. **15 références d'illustrations ou de GIF sont absentes du dépôt.**
2. **Les chapitres `08` à `18` ne sont pas couverts par le fichier `.github/scripts/demos.json`**, donc ils ne sont pas intégrés au pipeline automatisé de génération des démos.
3. **Le nombre de blocs d'instructions est très supérieur au nombre de GIF** dans plusieurs chapitres. Les GIF existants illustrent les démos principales, mais pas les étapes importantes de configuration, de reprise ou de dépannage.
4. **Deux liens du chapitre 15 pointent vers `../09-n8n-workflows/README.md` au lieu de `../18-n8n-workflows/README.md`.**
5. Le chapitre 12 documente lui-même une illustration manquante (`adoption-analogy.png`) dans `12-ai-developer-acceptance/assets/README.md`.

## Contrôle des illustrations et GIF

| Chapitre | Blocs d'instructions détectés | GIF référencés | GIF présents | Illustrations manquantes | Diagnostic |
|---|---:|---:|---:|---|---|
| 00 — Stack terminal | 0 | 11 | 11 | Aucune | Conforme pour les GIF ; vérifier les variantes OS |
| 01 — Démarrage rapide | 21 | 1 | 1 | Aucune | Couverture GIF faible au regard du nombre d'étapes |
| 02 — Premiers pas | 15 | 3 | 3 | Aucune | Les trois démos principales sont couvertes |
| 03 — Contexte et conversations | 35 | 3 | 3 | Aucune | Les cas avancés (`resume`, sessions, `--add-dir`) ne sont pas illustrés |
| 04 — Workflows | 40 | 5 | 5 | Aucune | Les cinq workflows sont couverts, mais pas leurs étapes complètes |
| 05 — Agents | 16 | 1 | 1 | Aucune | Création, sélection et diagnostic des agents non illustrés |
| 06 — Skills | 19 | 2 | 2 | Aucune | Installation, partage et dépannage non illustrés |
| 07 — MCP | 25 | 2 | 2 | Aucune | Configuration et OAuth manquent de démonstrations visuelles |
| 08 — Tout assembler | 8 | 0 | 0 | Aucune | GIF de synthèse manquant |
| 09 — Environnements isolés | 8 | 1 | 0 | `devcontainer-demo.gif` | GIF référencé mais absent |
| 10 — RAG Obsidian | 2 | 1 | 0 | `obsidian-rag-analogy.png`, `obsidian-rag-demo.gif` | Illustration et GIF absents |
| 11 — Sécurité | 2 | 1 | 0 | `security-checkpoint-analogy.png`, `security-review-demo.gif` | Illustration et GIF absents |
| 12 — Acceptation de l'IA | 0 | 0 | 0 | `adoption-analogy.png` | Illustration explicitement attendue mais non produite |
| 13 — Chronicle | 6 | 1 | 0 | `rewind-vs-chronicle.png`, `chronicle-standup-demo.gif` | Illustration et GIF absents |
| 14 — Tokens, RTK et Tokscale | 6 | 1 | 0 | `token-tools-analogy.png`, `rtk-gain-demo.gif` | Illustration et GIF absents |
| 15 — Prompt engineering | 4 | 1 | 0 | `prompt-clarity-analogy.png`, `prompt-template-demo.gif` | Illustration et GIF absents |
| 16 — Worktrees parallèles | 0 détecté par le script lexical | 1 | 0 | `worktree-new-demo.gif` | GIF référencé mais absent |
| 17 — mcp2cli | 0 détecté par le script lexical | 0 | 0 | Aucune | Démonstration visuelle à ajouter |
| 18 — n8n | 5 détectés par le script lexical | 1 | 0 | `n8n-analogy.png`, `n8n-workflow-demo.gif` | Illustration et GIF absents |

> Le nombre de blocs est un indicateur de volume, pas une obligation de produire un GIF pour chaque commande. Un GIF est recommandé pour chaque parcours utilisateur complet ou étape à risque, pas pour chaque commande élémentaire.

## Corrections et améliorations par tutoriel

### 00 — Équipez votre terminal

- Conserver les GIF existants : les 11 références correspondent bien aux 11 fichiers présents.
- Ajouter, au début de chaque famille d'outils, un encart **macOS / Linux / WSL / Windows** avec la commande réellement supportée.
- Vérifier que les scripts d'installation sont idempotents : une seconde exécution ne doit pas dupliquer les lignes dans `.zshrc`, `.bashrc` ou `.tmux.conf`.
- Ajouter un contrôle final copiable (`zsh --version`, `starship --version`, `tmux -V`, etc.) afin que le débutant puisse valider chaque étape.
- Ajouter un GIF global de la feuille de route uniquement si l'objectif est de montrer la stack finale ; les GIF unitaires actuels sont suffisants pour le contenu technique.

### 01 — Démarrage rapide

- Réduire la densité du chapitre : installation, authentification, statusline, OpenTelemetry, Tokscale et LSP forment presque plusieurs tutoriels.
- Déplacer les sujets avancés (OpenTelemetry, Tokscale et LSP) dans une section bonus clairement marquée ou une annexe.
- Ajouter des GIF pour : installation/authentification, première commande fonctionnelle, vérification de version et dépannage d'authentification.
- Ajouter une matrice de compatibilité synthétique : système, méthode d'installation, prérequis, solution de repli.
- Vérifier régulièrement les commandes d'installation et les noms de paquets ; afficher la version minimale lorsque le comportement dépend d'une version.

### 02 — Premiers pas

- Les trois démos principales sont correctement couvertes par un GIF.
- Ajouter une courte démonstration du mode `--plan`, du mode programmatique et de `--remote`, car ces modes font partie des objectifs du chapitre.
- Séparer visuellement **commande à saisir** et **sortie attendue** pour éviter que les débutants copient une sortie dans le terminal.
- Ajouter un critère de réussite à l'exercice : fichier modifié, test exécuté et résultat attendu.

### 03 — Contexte et conversations

- Les GIF existants couvrent le contexte fichier, multi-fichier et multi-tour ; conserver cette sélection.
- Ajouter un GIF sur `--resume` et le nommage de session, puis un second sur `--add-dir`.
- Ajouter une étape explicite de nettoyage du fichier temporaire créé par `echo ... > test.py`.
- Clarifier dans un encart la différence entre contexte fourni par `@`, répertoire courant et `--add-dir`.
- Ajouter un tableau **quand utiliser quel niveau de contexte** avec un exemple et une limite pour chaque option.

### 04 — Flux de travail de développement

- Les cinq workflows disposent chacun d'un GIF : c'est le meilleur niveau de couverture du cours.
- Compléter les GIF par un schéma ou une capture de l'enchaînement complet : préparer, demander, vérifier, tester, consulter le diff, committer.
- Vérifier systématiquement que les exemples de diff staged incluent bien `git add` avant `git diff --staged`.
- Ajouter un avertissement visible lorsque l'exemple utilise `samples/book-app-buggy/` : les bugs sont intentionnels et ne doivent pas être corrigés hors exercice.
- Pour chaque workflow, ajouter un résultat observable et mesurable : test qui passe, fichier généré, problème reproduit ou message de commit produit.

### 05 — Agents et instructions personnalisées

- Ajouter des GIF pour la sélection d'un agent intégré, l'invocation de `python-reviewer`, la création d'un agent et l'utilisation de `--no-custom-instructions`.
- Uniformiser les noms d'agents dans les textes, commandes et exemples (`python-reviewer`, `pytest-helper`, etc.).
- Ajouter un tableau de décision : agent intégré, agent projet, agent personnel ou skill.
- Montrer le chemin de recherche des agents et le comportement attendu lorsqu'un agent n'est pas détecté.
- Ajouter une validation pratique : demander à l'agent de produire un résultat vérifiable dans `samples/book-app-project/`.

### 06 — Skills

- Les deux GIF actuels couvrent la liste et le déclenchement ; ajouter des GIF pour créer, modifier et partager une skill.
- Rappeler explicitement la différence entre une skill chargée automatiquement et une commande slash invoquée manuellement.
- Vérifier que les exemples `.github/skills/` et `samples/skills/` restent synchronisés.
- Ajouter un exemple de description de skill trop vague, puis corrigée, afin d'enseigner le déclenchement fiable.
- Ajouter une vérification de sécurité avant installation d'une skill externe : origine, contenu de `SKILL.md`, commandes exécutées et permissions demandées.

### 07 — Serveurs MCP

- Ajouter des GIF pour `/mcp show`, `/mcp config`, l'ajout d'un serveur local, l'authentification OAuth et la combinaison de plusieurs serveurs.
- Distinguer plus nettement serveur intégré, serveur local `stdio` et serveur distant HTTP.
- Ajouter une section **diagnostic minimal** : configuration détectée, serveur démarré, outil listé, appel réussi.
- Pour chaque serveur d'exemple, documenter les permissions et les données auxquelles il donne accès.
- Ajouter une procédure de repli lorsque le registre MCP ou l'authentification distante n'est pas disponible.

### 08 — Tout assembler

- Ajouter au moins un GIF d'end-to-end montrant le parcours idée → plan → agent spécialisé → tests → diff → PR.
- Ajouter une illustration de synthèse ou réutiliser explicitement un schéma existant avec une légende adaptée.
- Découper le scénario principal en jalons vérifiables afin que le débutant ne soit pas confronté à une longue session opaque.
- Ajouter une variante sans agent personnalisé pour les lecteurs qui n'ont pas encore suivi les chapitres 05 et 06.

### 09 — Environnements isolés

- Produire `assets/devcontainer-demo.gif` ou supprimer la référence si la démonstration n'est pas maintenue.
- Ajouter un second GIF montrant la sandbox Docker et la politique réseau restrictive ; c'est le point pédagogique le plus important du chapitre.
- Vérifier la disponibilité réelle de `sbx` selon la version de Docker Desktop et conserver le repli `docker run`.
- Rendre explicite ce qui est monté dans la sandbox et ce qui ne l'est pas.
- Ajouter une vérification de non-accès à un fichier hors projet, sans demander aux lecteurs de tester un chemin sensible réel.

### 10 — RAG Obsidian

- Produire `assets/obsidian-rag-analogy.png` et `assets/obsidian-rag-demo.gif`.
- Ajouter un schéma du flux **question → recherche sémantique → lecture du vault → réponse avec citations**.
- Ajouter un encart sur la confidentialité : clé API, notes envoyées au modèle et limites du périmètre local.
- Détailler les ports HTTP/HTTPS, le certificat auto-signé et le comportement attendu de `/mcp show`.
- Ajouter un exemple de réponse avec citation de note et un critère de réussite vérifiable.

### 11 — Sécuriser le code avec Copilot CLI

- Produire `assets/security-checkpoint-analogy.png` et `assets/security-review-demo.gif`.
- Ajouter un scénario complet sur `samples/buggy-code/` avec le tableau de résultats attendu, sans corriger les bugs intentionnels.
- Séparer clairement détection, validation manuelle, correction et relecture ; une revue de sécurité n'est pas une preuve d'absence de vulnérabilité.
- Documenter précisément la version ou le mode expérimental requis, avec mise à niveau et alternative manuelle.
- Ajouter une checklist de protection des secrets avant toute exécution en mode automatisé.

### 12 — Acceptation de l'IA par les développeurs

- Produire `assets/adoption-analogy.png` et supprimer la mention « reste à produire » une fois l'image ajoutée.
- Ajouter les URL, dates, populations étudiées et limites méthodologiques directement sous chaque étude.
- Distinguer clairement corrélation, perception et mesure expérimentale.
- Ajouter une activité de comparaison avant/après sur une tâche du cours, avec métriques simples : temps, reprises, erreurs et confiance.
- Un GIF n'est pas indispensable pour ce chapitre analytique ; une infographie ou un graphique statique est plus pertinent.

### 13 — Chronicle

- Produire `assets/rewind-vs-chronicle.png` et `assets/chronicle-standup-demo.gif`.
- Ajouter un GIF pour `standup`, puis montrer au moins une sortie de `tips`, `search` et `improve` sous forme de captures statiques si plusieurs GIF sont trop coûteux.
- Clarifier la disponibilité de `/chronicle` selon la version du CLI et le périmètre de l'historique consulté.
- Ajouter une consigne de confidentialité sur les données de session potentiellement sensibles.

### 14 — Tokens, RTK et Tokscale

- Produire `assets/token-tools-analogy.png` et `assets/rtk-gain-demo.gif`.
- Montrer visuellement une commande avant/après RTK et expliquer que la compression de sortie n'est pas une réduction magique de tous les tokens envoyés au modèle.
- Distinguer précisément : tokens de sortie shell, tokens de contexte Copilot et métriques Tokscale.
- Ajouter une commande de vérification pour chaque installation et une alternative Windows documentée.
- Ajouter une activité mesurée sur une même commande exécutée avec et sans RTK.

### 15 — Prompt engineering

- Produire `assets/prompt-clarity-analogy.png` et `assets/prompt-template-demo.gif`.
- Corriger les deux liens `../09-n8n-workflows/README.md` en `../18-n8n-workflows/README.md`.
- Ajouter un exemple de sortie attendue et un contre-exemple pour chaque template.
- Distinguer prompt interactif multi-ligne, fichier Markdown à coller et appel programmatique.
- Éviter de présenter `mcp2cli` comme une solution standardisée : conserver l'avertissement sur les implémentations indépendantes et ajouter une date de vérification.

### 16 — Worktrees parallèles

- Produire `assets/worktree-new-demo.gif`.
- Ajouter au moins une démonstration montrant création, travail dans le second répertoire, fusion et nettoyage.
- Clarifier les règles Git : une branche par worktree, aucun partage simultané du même répertoire, résolution des conflits depuis le dépôt principal.
- Ajouter une section de nettoyage après interruption ou échec de session.
- Ajouter un critère de réussite : `git worktree list` ne doit plus afficher le worktree supprimé.

### 17 — mcp2cli

- Ajouter un GIF montrant le flux complet : découvrir les outils, inspecter la signature, invoquer une commande, puis comparer avec Copilot CLI.
- Ajouter une illustration simple du coût de contexte **MCP complet** contre **CLI générée**.
- Documenter l'implémentation exacte utilisée dans les commandes, sa version et ses limites.
- Ajouter une alternative manuelle lorsque `mcp2cli` n'est pas disponible.
- Mesurer la comparaison avec le même outil, la même requête et le même résultat attendu ; sinon la comparaison de tokens est difficile à interpréter.

### 18 — n8n

- Produire `assets/n8n-analogy.png` et `assets/n8n-workflow-demo.gif`.
- Corriger la cohérence des références croisées : ce chapitre est le chapitre 18, alors que certains textes du chapitre 15 le nomment chapitre 09.
- Ajouter une capture statique du workflow final avec les trois nœuds et leurs connexions.
- Ajouter un avertissement sur les identifiants, les webhooks publics et l'activation d'un workflow avant test.
- Vérifier la version n8n et la disponibilité du réglage **Instance-level MCP** à chaque mise à jour du cours.

## Plan de correction priorisé

### P0 — À corriger avant la prochaine publication

- Restaurer ou retirer les 15 références d'illustrations/GIF absentes.
- Corriger les deux liens du chapitre 15 vers `18-n8n-workflows`.
- Produire au minimum un GIF de synthèse pour le chapitre 08 et les GIF explicitement référencés dans les chapitres 09 à 18.
- Décider si les chapitres 08 à 18 entrent dans le pipeline `.github/scripts/demos.json`; s'ils y entrent, ajouter leurs entrées et leurs tapes.

### P1 — Amélioration pédagogique importante

- Ajouter des GIF ciblés pour les étapes avancées des chapitres 01, 03, 05, 06 et 07.
- Ajouter un résultat attendu ou un critère de réussite à chaque exercice.
- Uniformiser les encarts de prérequis, versions minimales, solutions de repli et avertissements de sécurité.
- Ajouter des schémas statiques pour les concepts qui ne bénéficient pas d'un GIF : RAG, adoption de l'IA, coût des tokens, mcp2cli.

### P2 — Qualité et maintenance

- Automatiser un contrôle CI des références locales (`.png`, `.gif`, liens Markdown et liens HTML).
- Automatiser un rapport comparant GIF référencés, GIF présents et entrées de `demos.json`.
- Ajouter une convention de nommage documentée pour les GIF (`<concept>-demo.gif`) et les illustrations (`<concept>-analogy.png`).
- Refaire l'audit après chaque ajout de chapitre ou modification de commande Copilot CLI.

## Conclusion

Le cours dispose d'une bonne base pédagogique et d'une couverture visuelle solide sur les chapitres fondamentaux `00` à `07`. La priorité est maintenant de traiter la rupture entre les références Markdown et les fichiers réellement versionnés dans les chapitres bonus, puis d'étendre le pipeline de démos aux chapitres `08` à `18`. Une fois ces corrections appliquées, un contrôle automatisé empêchera la réapparition de liens d'illustrations cassés et de chapitres non couverts par les GIF.
