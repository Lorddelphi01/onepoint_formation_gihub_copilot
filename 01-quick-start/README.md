<!--
---
id: CopilotCLI-01
title: !translate Démarrage rapide
description: !translate Installez GitHub Copilot CLI, connectez-vous avec votre compte GitHub, vérifiez que tout fonctionne, puis explorez en option le modèle Auto, la Statusline, l'observabilité OpenTelemetry et les serveurs LSP.
audience: Developers / Students / Terminal users
slug: quick-start
weight: 2
---
-->

![Chapitre 01 : Démarrage rapide](assets/chapter-header.png)

Bienvenue ! Dans ce chapitre, vous allez installer GitHub Copilot CLI (Command Line Interface), vous connecter avec votre compte GitHub, et vérifier que tout fonctionne. C'est un chapitre de configuration rapide. (Si vous avez sauté le Chapitre 00, optionnel, qui équipe votre terminal, pas de souci : vous pouvez toujours y revenir plus tard.) Une fois que vous serez opérationnel, les vraies démonstrations commencent au Chapitre 02 !

Une fois le cœur du chapitre terminé (« ✅ Vous êtes prêt ! »), une section entièrement **optionnelle** — « Pour aller plus loin » — vous attend si vous voulez tout de suite creuser des sujets plus avancés : sélection automatique de modèle, personnalisation de l'interface, outils tiers, observabilité, et serveurs de langage (LSP). Vous pouvez aussi l'ignorer pour l'instant et y revenir après le Chapitre 02.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous aurez :

- Installé GitHub Copilot CLI
- Connecté votre compte GitHub
- Vérifié que tout fonctionne avec un test simple

Et si vous complétez la section optionnelle « Pour aller plus loin », vous aurez en plus :

- Activé et vérifié le modèle Auto
- Personnalisé la Statusline, y compris son mode expérimental à base de script
- Installé et testé deux outils tiers réels pour Copilot CLI (Caveman et peon-ping)
- Activé l'export de métriques OpenTelemetry et lu une trace produite par Copilot CLI
- Lu un rapport d'usage Copilot CLI avec Tokscale, et compris à quoi sert Graphiti
- Configuré au moins un serveur LSP (Python, Java, .NET ou Terraform)

> ⏱️ **Durée estimée** : ~10 minutes pour le cœur du chapitre (5 min de lecture + 5 min de pratique) + ~90 à 120 minutes si vous complétez la section optionnelle « Pour aller plus loin »

---

## ✅ Prérequis

- **Un compte GitHub** avec accès à Copilot. [Voir les options d'abonnement](https://github.com/features/copilot/plans). Les étudiants/enseignants peuvent accéder à Copilot Pro gratuitement via [GitHub Education](https://education.github.com/pack).
- **Notions de base du terminal** : être à l'aise avec des commandes comme `cd` et `ls`

> ⚠️ **Version recommandée** : Copilot CLI v1.0.81 ou plus récent. L'outil est en disponibilité générale (GA) depuis février 2026 et évolue vite — pensez à le mettre à jour régulièrement (`npm update -g @github/copilot`, `brew upgrade copilot-cli`, etc.).

### Ce que signifie « avoir accès à Copilot »

GitHub Copilot CLI nécessite un abonnement Copilot actif. Vous pouvez vérifier votre statut sur [github.com/settings/copilot](https://github.com/settings/copilot). Vous devriez voir l'une des mentions suivantes :

- **Copilot Individual** - Abonnement personnel
- **Copilot Business** - Via votre organisation
- **Copilot Enterprise** - Via votre entreprise
- **GitHub Education** - Gratuit pour les étudiants/enseignants vérifiés

Si vous voyez « You don't have access to GitHub Copilot », vous devrez utiliser l'option gratuite, souscrire à un abonnement, ou rejoindre une organisation qui fournit l'accès.

---

## Installation

> ⏱️ **Durée estimée** : L'installation prend 2 à 5 minutes. L'authentification ajoute 1 à 2 minutes supplémentaires.

### GitHub Codespaces (aucune configuration nécessaire)

Si vous ne voulez installer aucun des prérequis, vous pouvez utiliser GitHub Codespaces, qui a GitHub Copilot CLI prêt à l'emploi (vous devrez vous connecter), et préinstalle Python et pytest.

1. [Forkez ce dépôt](https://github.com/github/copilot-cli-for-beginners/fork) sur votre compte GitHub
2. Sélectionnez **Code** > **Codespaces** > **Create codespace on main**
3. Attendez quelques minutes que le conteneur se construise
4. Vous êtes prêt ! Le terminal s'ouvrira automatiquement dans l'environnement Codespace.

> 💡 **Vérification dans Codespace** : Exécutez `cd samples/book-app-project && python book_app.py help` pour confirmer que Python et l'application d'exemple fonctionnent.

### Installation locale

Suivez ces étapes si vous souhaitez exécuter Copilot CLI sur votre machine locale avec les exemples du cours.

1. Clonez le dépôt pour récupérer les exemples du cours sur votre machine :

    ```bash
    git clone https://github.com/github/copilot-cli-for-beginners
    cd copilot-cli-for-beginners
    ```

2. Installez Copilot CLI en utilisant l'une des options suivantes.

    > 💡 **Vous ne savez pas laquelle choisir ?** Utilisez `npm` si vous avez Node.js installé. Sinon, choisissez l'option qui correspond à votre système.

    ### Toutes plateformes (npm)

    ```bash
    # Si vous avez Node.js installé, c'est un moyen rapide d'obtenir le CLI
    npm install -g @github/copilot
    ```

    ### macOS/Linux (Homebrew)

    ```bash
    brew install copilot-cli
    ```

    ### Windows (WinGet)

    ```bash
    winget install GitHub.Copilot
    ```

    ### macOS/Linux (script d'installation)

    ```bash
    curl -fsSL https://gh.io/copilot-install | bash
    ```

<details>
<summary>Optionnel : activer l'autocomplétion du shell</summary>

L'autocomplétion du shell vous permet d'appuyer sur **Tab** pour compléter les sous-commandes `copilot`, les options de commande, et certaines valeurs d'options. C'est optionnel, mais cela peut être pratique une fois que vous êtes à l'aise avec le CLI.

Copilot CLI prend actuellement en charge les scripts de complétion pour Bash, Zsh, et Fish :

```shell
# Bash, session en cours uniquement
source <(copilot completion bash)

# Bash, persistant sur Linux
copilot completion bash | sudo tee /etc/bash_completion.d/copilot

# Zsh
copilot completion zsh > "${fpath[1]}/_copilot"

# Fish
copilot completion fish > ~/.config/fish/completions/copilot.fish
```

Redémarrez votre shell après avoir ajouté la complétion persistante. PowerShell est pris en charge pour exécuter Copilot CLI sur Windows, mais `copilot completion` ne prend actuellement en charge que Bash, Zsh, et Fish.

</details>

---

## Authentification

Ouvrez une fenêtre de terminal à la racine du dépôt `copilot-cli-for-beginners`, démarrez le CLI et autorisez l'accès au dossier.

```bash
copilot
```

Il vous sera demandé de faire confiance au dossier contenant le dépôt (si ce n'est pas déjà fait). Vous pouvez lui faire confiance une seule fois ou pour toutes les sessions futures.

<img src="assets/copilot-trust.png" alt="Trusting files in a folder with the Copilot CLI" width="800"/>

Après avoir approuvé le dossier, vous pouvez vous connecter avec votre compte GitHub.

```
> /login
```

**Ce qui se passe ensuite (terminal local interactif) :**

Depuis Copilot CLI v1.0.77, le **flux par navigateur est le flux par défaut** lorsque vous lancez `/login` depuis un terminal local interactif :

1. Choisissez de vous connecter à votre compte GitHub.com ou à un compte d'entreprise.
2. Le flux navigateur est proposé par défaut (`Sign in with your browser`).
3. Votre navigateur s'ouvre automatiquement sur la page d'autorisation de GitHub. Connectez-vous à GitHub si ce n'est pas déjà fait.
4. Sélectionnez « Authorize » pour accorder l'accès à GitHub Copilot CLI.
5. Retournez à votre terminal — vous êtes maintenant connecté !

> 💡 **Terminaux distants ou sans interface graphique (SSH, CI, conteneurs, IDE sans TTY)** : Dans ces environnements, Copilot CLI utilise par défaut le **flux de code d'appareil (device code flow)**, sans navigateur disponible. Vous verrez un code à usage unique du type `ABCD-1234`. Rendez-vous sur [github.com/login/device](https://github.com/login/device) dans un navigateur sur une autre machine et saisissez le code pour terminer la connexion.
>
> Pour forcer explicitement un flux plutôt que de laisser Copilot CLI choisir selon le contexte, utilisez `copilot login --web-flow` (navigateur) ou `copilot login --device-code` (code d'appareil). Vous pouvez aussi choisir de façon interactive avec `/login`.
>
> <img src="assets/auth-device-flow.png" alt="Device Authorization Flow - showing the 5-step process from terminal login to signed-in confirmation" width="800"/>
>
 
*Le flux par défaut selon le contexte (depuis Copilot CLI v1.0.77) : navigateur en local interactif — votre navigateur s'ouvre automatiquement et vous autorisez en un clic — et code d'appareil en distant/headless, où un code à saisir sur `github.com/login/device` est affiché à la place.*

**Astuce** : La connexion persiste entre les sessions. Vous n'avez besoin de le faire qu'une seule fois, sauf si votre jeton expire ou que vous vous déconnectez explicitement.

---

## Vérifier que tout fonctionne

### Étape 1 : Tester Copilot CLI

Maintenant que vous êtes connecté, vérifions que Copilot CLI fonctionne pour vous. Dans le terminal, démarrez le CLI si ce n'est pas déjà fait :

```bash
> Say hello and tell me what you can help with
```

Après avoir reçu une réponse, vous pouvez quitter le CLI :

```bash
> /exit
```

---

<details>
<summary>🎬 Voir en action !</summary>

![Hello Demo](assets/hello-demo.gif)

*Le résultat de la démonstration peut varier. Votre modèle, vos outils et vos réponses différeront de ce qui est montré ici.*

</details>

---

**Résultat attendu** : Une réponse amicale listant les capacités de Copilot CLI.

### Étape 2 : Exécuter l'application d'exemple Book App

Le cours fournit une application d'exemple que vous allez explorer et améliorer tout au long du cours en utilisant le CLI *(vous pouvez voir le code dans /samples/book-app-project)*. Vérifiez que l'*application terminal Python de collection de livres* fonctionne avant de commencer. Exécutez `python` ou `python3` selon votre système.

> **Remarque :** Les exemples principaux présentés tout au long du cours utilisent Python (`samples/book-app-project`), vous devrez donc avoir [Python 3.10+](https://www.python.org/downloads/) disponible sur votre machine locale si vous avez choisi cette option (le Codespace l'a déjà installé). Des versions JavaScript (`samples/book-app-project-js`) et C# (`samples/book-app-project-cs`) sont également disponibles si vous préférez travailler avec ces langages. Chaque exemple dispose d'un README avec les instructions pour exécuter l'application dans ce langage.

```bash
cd samples/book-app-project
python book_app.py list
```

**Résultat attendu** : Une liste de 5 livres, dont « The Hobbit », « 1984 », et « Dune ».

### Étape 3 : Essayer Copilot CLI avec la Book App

Revenez d'abord à la racine du dépôt (si vous avez exécuté l'étape 2) :

```bash
cd ../..   # Retour à la racine du dépôt si nécessaire
copilot 
> What does @samples/book-app-project/book_app.py do?
```

**Résultat attendu** : Un résumé des principales fonctions et commandes de la Book App.

Si vous voyez une erreur, consultez la [section de dépannage](#dépannage) ci-dessous.

Une fois terminé, vous pouvez quitter Copilot CLI :

```bash
> /exit
```

---

## ✅ Vous êtes prêt !

C'est tout pour l'installation. Si vous n'avez pas encore équipé votre terminal, le **[Chapitre 00 : Équipez votre terminal](../00-modern-terminal-stack/README.md)** reste disponible (en option, mais recommandé) avant d'aller plus loin. Le vrai plaisir commence ensuite au Chapitre 02, où vous allez :

- Regarder l'IA passer en revue la Book App et détecter instantanément des problèmes de qualité de code
- Apprendre trois façons différentes d'utiliser Copilot CLI
- Générer du code fonctionnel à partir de langage naturel

**[Continuer vers le Chapitre 02 : Premiers pas →](../02-setup-and-first-steps/README.md)**

Vous pouvez continuer directement vers le Chapitre 02, ou rester ici pour la section optionnelle ci-dessous.

---

## Pour aller plus loin (optionnel)

> 💡 **Cette section est entièrement optionnelle.** Le cœur du chapitre s'arrête ci-dessus : vous avez déjà installé, authentifié et vérifié Copilot CLI, ce qui suffit pour attaquer le Chapitre 02. Les six blocs qui suivent creusent des sujets plus avancés (sélection de modèle, personnalisation de l'interface, outils tiers, observabilité, intelligence de code) pour qui veut approfondir sa configuration avant de continuer. Traitez-les dans l'ordre, piochez-en un seul, ou revenez-y plus tard.

> ⏱️ **Durée indicative de l'ensemble** : ~90 à 120 minutes pour les six blocs.

### A. Comprendre et activer le modèle Auto

**Objectif pédagogique** : comprendre le principe de sélection automatique de modèle, l'activer, vérifier quel modèle a réellement traité votre requête, et connaître ses limites.

> ⏱️ **Durée indicative** : ~10 minutes
> ✅ **Prérequis** : avoir terminé l'installation et l'authentification ci-dessus.

Copilot CLI peut choisir lui-même, à chaque requête, le modèle qu'il juge le plus adapté — en tenant compte de la disponibilité en temps réel des modèles et, depuis le 1er juillet 2026, de la complexité estimée de la tâche (raisonnement, génération de code, diagnostic de bug, orchestration d'outils). Le CLI évite volontairement de changer de modèle en cours de session : un changement mi-session coûterait plus cher pour un gain de qualité jugé insuffisant par GitHub.

> 💡 **Copilot CLI vs VS Code vs les autres IDE** : le modèle Auto avec routage par tâche est disponible en version stable (GA) à la fois dans **Copilot CLI** et dans **VS Code**, avec trois profils sélectionnables (`efficiency`, `balance`, `intelligence`). Dans **JetBrains, Eclipse, Xcode et Visual Studio**, Auto existe aussi mais se limite à un routage « fiabilité seule », sans ces profils. Ne partez donc pas du principe qu'Auto se comporte à l'identique partout.

**Étapes** :

1. Lancez Copilot CLI et ouvrez le sélecteur de modèle :

    ```bash
    copilot
    > /model
    ```

2. Sélectionnez **Auto** dans la liste.
3. Posez une question qui demande un peu de raisonnement, par exemple :

    ```
    > Explique la différence entre une liste et un tuple en Python, puis donne un exemple où le choix a un impact sur les performances
    ```

4. Regardez le nom du modèle affiché avec la réponse : c'est le modèle qu'Auto a réellement choisi pour cette requête.
5. *(Optionnel)* Forcez un profil de routage pour la session :

    ```bash
    copilot --model auto --auto-tier intelligence
    ```

    Les profils possibles sont `efficiency` (rapide et économique), `balance` (par défaut) et `intelligence` (priorité à la qualité de réponse). Vous pouvez aussi fixer ce choix durablement avec la variable d'environnement `COPILOT_AUTO_TIER`.
6. *(Optionnel)* Pour qu'Auto soit le modèle par défaut de **toutes vos futures sessions** (pas seulement celle-ci), utilisez `/config model` plutôt que `/model`, qui ne change le modèle que pour la session en cours — ou ajoutez `"model": "auto"` dans `~/.copilot/settings.json`.

**Résultat attendu** : après chaque réponse, un nom de modèle concret s'affiche (jamais littéralement « Auto ») — c'est la preuve qu'un routage a bien eu lieu.

**Critères de validation** : vous avez sélectionné Auto, posé au moins une question, et identifié dans la sortie le nom du modèle réellement utilisé.

<details>
<summary>🔧 Dépannage</summary>

| Erreur / Situation | Ce qui se passe | Solution |
|---|---|---|
| Auto ne route jamais vers le modèle attendu | Auto exclut les modèles hors de votre abonnement, exclus par une politique d'administrateur, à résidence de données/FedRAMP, ou marqués « évaluation » ; il est aussi actuellement limité aux modèles à multiplicateur 0x–1x | C'est un comportement documenté, pas un bug — vérifiez `/model` pour voir la liste réellement disponible pour votre compte |
| `--auto-tier` semble ignoré | Le réglage n'a d'effet que si le modèle effectif est Auto | Confirmez d'abord que `/model` affiche bien Auto comme sélection active |

</details>

> ⚠️ **Limite connue** : la documentation officielle ne précise pas de version minimale exacte de Copilot CLI pour voir apparaître Auto dans le sélecteur — le repère fiable est la fonctionnalité elle-même : si `/model` ne propose pas Auto, mettez à jour le CLI (`copilot update`).

**Défi** : relancez la même question avec `--auto-tier efficiency` puis `--auto-tier intelligence`, et comparez le modèle choisi dans chaque cas.

> 📚 Source officielle : [About Copilot auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection). Pour la table complète des commandes liées au modèle, voir la section *Changer de modèle* du [Chapitre 02](../02-setup-and-first-steps/README.md).

---

### B. Personnaliser la Statusline (expérimentale)

**Objectif pédagogique** : distinguer les deux niveaux de personnalisation de la barre d'état de Copilot CLI, activer le mode expérimental à base de script, et savoir le désactiver.

> ⏱️ **Durée indicative** : ~15 minutes
> ✅ **Prérequis** : un terminal Bash (le script de cet exercice utilise `jq` ; sous Windows, utilisez WSL ou adaptez-le en PowerShell).

> ⚠️ **Ne confondez pas** la Statusline de Copilot CLI avec celle d'autres outils en ligne de commande : ce sont des fonctionnalités distinctes, même si GitHub s'est ouvertement inspiré du concept (voir l'issue [`github/copilot-cli#2266`](https://github.com/github/copilot-cli/issues/2266)). Ce n'est pas non plus la barre d'état de VS Code.

Copilot CLI a en réalité **deux** mécanismes de personnalisation de la ligne affichée en bas de l'interface interactive :

| Mécanisme | Statut | Ce qu'il permet |
|---|---|---|
| `/statusline` (alias `/footer`) | Stable, documenté officiellement | Active/désactive des indicateurs prédéfinis : modèle et effort, répertoire, branche git, fenêtre de contexte, quota, agent actif, usage IA, lignes modifiées, nom d'utilisateur, sandbox, mode YOLO |
| `statusLine.command` (script personnalisé) | **Expérimental**, sujet à changement | Exécute votre propre script à chaque réponse et affiche ce qu'il retourne |

**Étapes — activer les indicateurs prédéfinis (stable)** :

1. Dans une session Copilot CLI, tapez `/statusline` (ou `/footer`) et cochez les indicateurs qui vous intéressent (par exemple la fenêtre de contexte et le quota).
2. **Résultat attendu** : la ligne en bas de l'écran affiche désormais ces informations après chaque réponse.

**Étapes — activer le mode script personnalisé (expérimental)** :

1. Ouvrez (ou créez) `~/.copilot/settings.json` et ajoutez :

    ```json
    {
      "experimental": true,
      "feature_flags": { "enabled": ["STATUS_LINE"] },
      "statusLine": {
        "type": "command",
        "command": "~/.copilot/statusline.sh",
        "padding": 1
      }
    }
    ```

2. Créez `~/.copilot/statusline.sh` (exécutable) : le CLI lui envoie sur son entrée standard un payload JSON (répertoire courant, modèle, tokens de contexte utilisés, coût de la session...) après chaque réponse, et affiche tel quel ce que le script écrit sur sa sortie standard. Exemple minimal :

    ```bash
    #!/usr/bin/env bash
    set -eu
    payload=$(cat)
    model=$(echo "$payload" | jq -r '.model.display_name // "?"')
    pct=$(echo "$payload" | jq -r '.context_window.current_context_used_percentage // "?"')
    echo "🤖 $model · contexte utilisé : ${pct}%"
    ```

    ```bash
    chmod +x ~/.copilot/statusline.sh
    ```

3. Redémarrez Copilot CLI et posez une question.

**Résultat attendu** : après la réponse, la ligne personnalisée générée par votre script s'affiche en bas de l'écran.

**Critères de validation** : vous avez activé au moins un indicateur via `/statusline`, **et** vu votre propre script s'afficher après avoir activé le mode expérimental.

**Désactivation** : repassez les indicateurs à faux via `/statusline`/`/footer` ; pour le mode script, supprimez le bloc `statusLine` ou repassez `"experimental"` à `false`, puis redémarrez.

<details>
<summary>🔧 Dépannage</summary>

| Erreur / Situation | Ce qui se passe | Solution |
|---|---|---|
| Le script ne s'affiche jamais | `experimental` est à `false`, ou le flag `STATUS_LINE` n'est pas activé | Vérifiez les deux clés dans `settings.json`, puis redémarrez le CLI |
| `jq: command not found` dans le script | `jq` n'est pas installé | Installez-le (`apt install jq`, `brew install jq`...) ou parsez le JSON autrement |

</details>

**Défi** : modifiez le script pour afficher aussi la branche git courante (`git symbolic-ref --short HEAD`).

> 📚 Sources : [référence des commandes CLI](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) et [référence du dossier de configuration](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference) pour les indicateurs `footer` (stable). Le mode script `statusLine.command` est corroboré par plusieurs sources communautaires cohérentes (dont la configuration active utilisée pour rédiger ce chapitre) mais n'a pas été retrouvé mot pour mot sur une page officielle : traitez-le comme expérimental et sujet à changement.

---

### C. « Peon Caveman » : mise au point et deux vrais outils

**Objectif pédagogique** : ne pas confondre deux projets réels distincts, comprendre ce que chacun fait, et l'installer.

> ⏱️ **Durée indicative** : ~15 minutes (environ 7 minutes par outil)
> ✅ **Prérequis** : Node.js installé (les deux outils s'installent via `npx`).

> ⚠️ **Aucun projet ne s'appelle « Peon Caveman ».** Ce nom semble croiser deux outils réels et sans rapport entre eux. Les deux sont présentés ci-dessous, sous leur vrai nom, pour éviter toute confusion.

#### C.1. Caveman — compression de tokens pour agents IA

**Ce que c'est** : un skill + proxy open source qui réduit la consommation de tokens d'un agent IA : il rend la prose de l'agent plus concise, tout en préservant le code, les commandes et les messages d'erreur tels quels, et compresse les logs/diffs/JSON volumineux avant qu'ils n'atteignent le modèle.

**Intégration avec Copilot CLI** : documentée par le projet lui-même, puisque Copilot CLI s'appuie sur des fichiers de règles statiques plutôt que sur des hooks.

```bash
npx -y github:JuliusBrussee/caveman -- --only copilot
# --with-init génère en plus un .github/copilot-instructions.md pour tout le dépôt
```

**Vérification** : relancez `copilot` et observez si les réponses en langage naturel sont plus courtes/denses qu'avant (le code et les commandes, eux, ne doivent pas changer).

**Limite** : projet tiers non officiel, à évaluer comme n'importe quelle dépendance externe avant de l'adopter en équipe.

Dépôt officiel : [`github.com/JuliusBrussee/caveman`](https://github.com/JuliusBrussee/caveman)

#### C.2. peon-ping — notifications sonores multi-agents

**Ce que c'est** : un outil qui joue des bruitages (voix Warcraft) lorsqu'un agent IA en ligne de commande a besoin d'attention ou termine une tâche. Il implémente un format ouvert, le *Coding Event Sound Pack Specification* (CESP), et fonctionne avec de nombreux agents — Claude Code, Copilot CLI, Cursor, Codex, et d'autres. Copilot CLI n'est qu'un des clients compatibles parmi d'autres : ce n'est pas un outil spécifique à GitHub.

```bash
npx -y peon-ping
```

**Vérification** : lancez une commande longue via Copilot CLI et vérifiez qu'un son se déclenche à la fin.

**Limite** : les bruitages proviennent d'œuvres tierces (Blizzard notamment), utilisées par le projet sous fair use, sans affiliation officielle revendiquée.

Dépôt officiel : [`github.com/PeonPing/peon-ping`](https://github.com/PeonPing/peon-ping) — site : [peonping.com](https://www.peonping.com/)

**Défi** : installez les deux, puis décidez lequel garde sa place dans votre configuration quotidienne — et pourquoi.

---

### D. Activer les métriques OpenTelemetry

**Objectif pédagogique** : comprendre traces/métriques/logs dans un workflow agentique, activer l'export OpenTelemetry de Copilot CLI, observer une interaction réelle, puis désactiver l'instrumentation.

> ⏱️ **Durée indicative** : ~20 minutes
> ✅ **Prérequis** : `jq` installé pour lire confortablement le fichier produit.

**Traces, métriques, logs — la différence** : une **trace** est l'arbre des étapes d'une interaction (l'agent invoqué → un appel modèle → l'exécution d'un outil...) ; une **métrique** est une valeur numérique agrégée dans le temps (durée moyenne, nombre de tokens...) ; un **log** est un message d'événement ponctuel. Copilot CLI exporte des traces et des métriques suivant les *OTel GenAI Semantic Conventions* — pas de logs applicatifs au sens strict dans cet export.

OpenTelemetry est **désactivé par défaut** dans Copilot CLI. L'activation se déclenche dès que l'une de ces variables est définie : `COPILOT_OTEL_ENABLED=true`, `OTEL_EXPORTER_OTLP_ENDPOINT`, ou `COPILOT_OTEL_FILE_EXPORTER_PATH`.

**Étapes — exporteur fichier (le plus simple pour un TP, aucune infrastructure requise)** :

1. Lancez Copilot CLI avec l'export fichier activé :

    ```bash
    COPILOT_OTEL_FILE_EXPORTER_PATH=/tmp/copilot-otel.jsonl copilot
    ```

2. Posez une question qui déclenche un outil, par exemple :

    ```
    > Liste les fichiers du dossier samples/book-app-project
    ```

3. Quittez (`/exit`) puis inspectez le fichier produit :

    ```bash
    wc -l /tmp/copilot-otel.jsonl
    jq -c 'select(.type == "span") | {name, attributes}' /tmp/copilot-otel.jsonl | head -5
    jq -c 'select(.type == "metric") | {name, unit}' /tmp/copilot-otel.jsonl | head -5
    ```

**Résultat attendu** : chaque ligne est un objet JSON `{"type": "span", ...}` ou `{"type": "metric", ...}`. Vous devez pouvoir repérer un span `execute_tool` avec le nom de l'outil appelé et sa durée (`startTime`/`endTime`), et des métriques comme `gen_ai.client.token.usage` ou `github.copilot.tool.call.count`.

**Critères de validation** : le fichier `.jsonl` existe et contient au moins un span de type `execute_tool` et une métrique liée aux tokens.

> ⚠️ **Confidentialité** : par défaut, **aucun contenu de prompt, de réponse ou d'argument d'outil n'est capturé** — seules des métadonnées (nom de modèle, durée, compteurs de tokens, nom d'outil) le sont. La capture complète du contenu (`OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT=true`) peut exposer du code, des chemins de fichiers ou des données sensibles : ne l'activez qu'en environnement de confiance, jamais sur un poste partagé ou en présence de données clients.

<details>
<summary>💡 Pour aller plus loin : exporter vers un collecteur local</summary>

Pour visualiser les traces dans une interface graphique (Jaeger, Grafana Tempo...), pointez vers un collecteur OTLP/HTTP local :

```bash
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318 copilot
```

Seul le protocole `otlp-http` est supporté par le CLI (pas de gRPC), même si vous forcez `OTEL_EXPORTER_OTLP_PROTOCOL`. Pour un backend distant avec authentification : `OTEL_EXPORTER_OTLP_HEADERS="Authorization=Bearer <votre-jeton>"`.

</details>

**Désactivation** : ne définissez plus aucune des trois variables d'activation — c'est le comportement par défaut. Si votre entreprise impose l'export via un `managed-settings.json`, vous ne pourrez pas forcément le désactiver localement.

<details>
<summary>🔧 Dépannage</summary>

| Erreur / Situation | Ce qui se passe | Solution |
|---|---|---|
| Le fichier `.jsonl` reste vide ou n'apparaît pas | La variable n'était pas exportée dans le shell qui lance `copilot`, ou aucune interaction n'a eu lieu | Vérifiez `echo $COPILOT_OTEL_FILE_EXPORTER_PATH` puis relancez une vraie question |
| Rien ne part vers mon collecteur `http://...` | Le CLI refuse silencieusement d'envoyer en clair vers un endpoint non sécurisé ; l'avertissement n'apparaît que dans les logs (`~/.copilot/logs/`), pas dans le terminal | Utilisez `https://` pour un collecteur distant, ou relancez avec `--log-level debug` |

</details>

**Défi** : comparez le nombre de spans `execute_tool` produits par une question simple face à une question qui demande d'éditer plusieurs fichiers.

> 📚 Source officielle : `copilot help monitoring` (dans le CLI lui-même) et [docs.github.com/.../opentelemetry](https://docs.github.com/en/copilot/concepts/agents/opentelemetry).

---

### E. Tokscale et Graphiti

#### E.1. Tokscale — tableau de bord d'usage local

**Objectif pédagogique** : installer Tokscale, comprendre qu'il dépend de l'export OpenTelemetry (bloc D) pour lire l'usage de Copilot CLI, et lire un rapport de consommation.

> ⏱️ **Durée indicative** : ~15 minutes
> ✅ **Prérequis** : avoir complété le bloc **D** au moins une fois (Tokscale lit l'usage Copilot CLI depuis les fichiers produits par l'export OTel local, `~/.copilot/otel/`).

**Ce que c'est** : une CLI/TUI open source (pas un serveur MCP, pas un mécanisme de facturation officiel de GitHub — le projet ne revendique aucune affiliation officielle) qui agrège localement les journaux d'usage déjà produits par une cinquantaine d'agents IA, dont Copilot CLI, pour calculer coûts et statistiques de tokens.

**Étapes** :

1. Installez et lancez Tokscale (aucune installation globale nécessaire) :

    ```bash
    npx tokscale@latest clients
    ```

2. Repérez la ligne **Copilot CLI** dans la sortie — elle indique le chemin scanné (`~/.copilot/otel`) et le nombre de messages détectés. Si ce nombre est à 0, aucun export OTel fichier n'a encore été généré : refaites le bloc D d'abord.
3. Ouvrez le tableau de bord interactif :

    ```bash
    npx tokscale@latest tui
    ```

4. Naviguez jusqu'à la vue par modèle ou par mois pour Copilot CLI.

**Résultat attendu** : Tokscale affiche au moins une session Copilot CLI, avec une estimation de tokens/coût.

**Critères de validation** : `tokscale clients` répertorie « Copilot CLI » avec un nombre de messages supérieur à 0.

<details>
<summary>🔧 Dépannage</summary>

| Erreur / Situation | Ce qui se passe | Solution |
|---|---|---|
| Copilot CLI affiche 0 messages dans Tokscale | Aucun fichier n'existe encore dans `~/.copilot/otel/` | Refaites le bloc D avec `COPILOT_OTEL_FILE_EXPORTER_PATH`, ou vérifiez le contenu du dossier avec `ls ~/.copilot/otel/` |

</details>

**Défi** : comparez le coût estimé de deux sessions Copilot CLI différentes dans `tokscale tui`.

> 📚 Source : [`github.com/junhoyeo/tokscale`](https://github.com/junhoyeo/tokscale) — projet communautaire, non affilié à GitHub.

#### E.2. Graphiti — graphe de connaissances temporel pour la mémoire d'agent (aperçu)

**Objectif pédagogique** : comprendre à quoi sert Graphiti et pourquoi il ne s'installe pas en cinq minutes dans un Quick Start — cette sous-section reste volontairement conceptuelle.

**Ce que c'est** : un framework open source (par Zep) qui construit un graphe de connaissances *temporel* — mis à jour en continu plutôt que recalculé par lots — pour donner à un agent IA une mémoire persistante et interrogeable, au-delà du contexte d'une seule session.

**Ce que ça change par rapport à la mémoire native de Copilot** : Copilot CLI dispose d'une mémoire scopée à la session/au dépôt (`copilot memories`) ; aucune documentation ne mentionne de mémoire native de type graphe interrogeable comparable à Graphiti.

**Architecture et prérequis** : Python 3.10+, une clé API de fournisseur LLM (OpenAI, Anthropic, Gemini, Groq ou Azure OpenAI), un fournisseur d'embeddings, et une base de données graphe (FalkorDB par défaut, ou Neo4j 5.26+). Le paquet principal est `graphiti-core` (PyPI) ; le projet fournit aussi un **serveur MCP officiel** (`mcp_server/` du dépôt) exposant des outils comme `add_memory` ou `search_nodes`.

> ⚠️ **Compatibilité avec Copilot CLI : non confirmée officiellement.** Copilot CLI sait se connecter à n'importe quel serveur MCP standard via `~/.copilot/mcp-config.json` (`copilot mcp add`) ou `.github/mcp.json` — le mécanisme générique devrait donc, en principe, accepter le serveur MCP de Graphiti. Mais ni la documentation de GitHub ni celle de Zep ne confirment ce couplage précis (Zep documente Claude Desktop, Cursor et VS Code + Copilot Chat — pas explicitement Copilot CLI). Ne présentez pas cette intégration comme testée et garantie.

**Défi bonus (hors guidage pas-à-pas, installation complète)** : si vous voulez aller plus loin, suivez le guide officiel de Zep pour lancer le serveur MCP de Graphiti (`uv sync` puis `uv run graphiti_mcp_server.py` dans `mcp_server/`), puis ajoutez-le à `~/.copilot/mcp-config.json` avec `copilot mcp add` et vérifiez si Copilot CLI parvient à s'y connecter (`/mcp` pour voir le statut).

> 📚 Source : [`github.com/getzep/graphiti`](https://github.com/getzep/graphiti), [documentation du serveur MCP](https://help.getzep.com/graphiti/getting-started/mcp-server).

---

### F. Ajouter des serveurs LSP (Python, Java, .NET, Terraform)

**Objectif pédagogique** : comprendre pourquoi Copilot CLI utilise des serveurs de langage (LSP), en configurer un pour chaque langage demandé, et savoir vérifier qu'il fonctionne.

> ⏱️ **Durée indicative** : ~30 minutes (dont ~10 min pour l'exemple Java, déjà prêt à tester)
> ✅ **Prérequis** : selon le langage — voir chaque sous-section.

**Pourquoi un LSP plutôt que la recherche texte de l'agent ?** Un serveur de langage (Language Server Protocol) est un processus qui comprend la structure réelle de votre code, comme le ferait le compilateur ou l'analyseur du langage — pas une simple recherche de motif. Quand un LSP est configuré pour un langage, Copilot CLI l'utilise automatiquement pour aller à la définition réelle d'un symbole (pas un texte qui y ressemble), renommer un symbole dans tout le projet, ou lister les symboles d'un fichier — avec des résultats structurés compacts, ce qui économise du contexte par rapport à la lecture de fichiers entiers.

> ⚠️ **LSP dans Copilot CLI ≠ LSP dans un IDE.** Dans VS Code, le LSP alimente *toutes* les fonctionnalités de l'éditeur (auto-complétion, soulignés d'erreur, info-bulles...). Dans Copilot CLI, le LSP n'alimente que quelques opérations ciblées que l'agent utilise pour ses propres appels d'outils — il n'y a pas d'éditeur ni d'UI associée. Ne présumez pas qu'un serveur qui fonctionne dans VS Code se comporte identiquement dans Copilot CLI.

**Configuration** : deux emplacements possibles, avec le même schéma JSON — `~/.copilot/lsp-config.json` (utilisateur, toutes vos sessions) ou `.github/lsp.json` (projet, partagé avec l'équipe via git) :

```json
{
  "lspServers": {
    "NOM-DU-SERVEUR": {
      "command": "COMMANDE",
      "args": ["ARG1", "ARG2"],
      "fileExtensions": { ".ext": "identifiant-langage" }
    }
  }
}
```

Commandes utiles : `/lsp` (ou `/lsp show`) dans une session pour voir l'état des serveurs configurés, `/lsp test NOM` pour vérifier qu'un serveur démarre, `/lsp reload` pour recharger la config sans redémarrer ; hors session, `copilot lsp list`.

#### F.1. Python — Pyright

**Prérequis** : Node.js (déjà nécessaire pour installer Copilot CLI lui-même) ou Python/pip.

```bash
npm install -g pyright
```

```json
{
  "lspServers": {
    "python": {
      "command": "pyright-langserver",
      "args": ["--stdio"],
      "fileExtensions": { ".py": "python" }
    }
  }
}
```

**Vérification** : `copilot lsp list` doit afficher `python (.py)` ; en session, `/lsp test python`.

#### F.2. Java — Eclipse JDT Language Server (jdtls)

**Prérequis** : **Java 21 ou plus récent**. Installation : `brew install jdtls` (macOS), ou téléchargement manuel depuis le [dépôt Eclipse JDT LS](https://github.com/eclipse-jdtls/eclipse.jdt.ls).

```json
{
  "lspServers": {
    "java": {
      "command": "jdtls",
      "args": [],
      "fileExtensions": { ".java": "java" }
    }
  }
}
```

*(Configuration vérifiée fonctionnelle lors de la rédaction de ce chapitre : avec jdtls installé, `copilot lsp list` affiche bien `java (.java)`.)*

**Vérification** : `copilot lsp list` → `java (.java)` ; `/lsp test java` en session.

#### F.3. .NET/C# — serveur Roslyn (via `dnx`)

**Prérequis** : **.NET SDK 10 ou plus récent** (la sous-commande `dnx`, qui lance le serveur Roslyn à la volée, est une nouveauté du SDK 10 — sans elle, cette section n'est pas applicable ; passez-la et revenez-y après mise à jour de votre SDK).

```json
{
  "lspServers": {
    "csharp": {
      "command": "dotnet",
      "args": ["dnx", "roslyn-language-server", "--yes", "--prerelease", "--", "--stdio", "--autoLoadProjects"],
      "fileExtensions": { ".cs": "csharp" }
    }
  }
}
```

> 💡 Cette configuration provient du skill officiel `lsp-setup` du dépôt `github/awesome-copilot`, pas de la page principale de documentation Copilot CLI — elle reste une source GitHub officielle, avec cette nuance. D'autres serveurs C# existent (OmniSharp, csharp-ls) mais ne sont documentés nulle part pour Copilot CLI : n'en installez qu'un seul pour éviter les conflits, et privilégiez celui ci-dessus, activement recommandé par GitHub.

**Vérification** : `copilot lsp list` → `csharp (.cs)`.

#### F.4. Terraform — terraform-ls (non confirmé officiellement)

> ⚠️ **À la différence des trois langages précédents, cette intégration n'est confirmée par aucune documentation officielle GitHub Copilot CLI.** terraform-ls est bien le serveur de langage officiel de HashiCorp pour Terraform, activement maintenu — mais il n'apparaît ni dans la documentation Copilot CLI, ni dans la liste des langages du skill `lsp-setup`. La configuration ci-dessous suit le même schéma générique que les autres langages, par analogie, mais **n'a pas été validée par GitHub** : traitez-la comme une piste à tester vous-même, pas comme une fonctionnalité garantie.

**Prérequis** : `terraform-ls` installé ([`github.com/hashicorp/terraform-ls`](https://github.com/hashicorp/terraform-ls)).

```json
{
  "lspServers": {
    "terraform": {
      "command": "terraform-ls",
      "args": ["serve"],
      "fileExtensions": { ".tf": "terraform" }
    }
  }
}
```

**Vérification** : `copilot lsp list` → `terraform (.tf)` si le serveur démarre correctement ; sinon, consultez `/lsp logs` en session pour diagnostiquer.

<details>
<summary>🔧 Dépannage (section F)</summary>

| Erreur / Situation | Ce qui se passe | Solution |
|---|---|---|
| `/lsp test NOM` échoue avec « commande introuvable » | Le binaire du serveur n'est pas dans le `PATH` | Vérifiez avec `which <commande>` (ex. `which jdtls`) et réinstallez si besoin |
| jdtls ne démarre pas | Version de Java insuffisante | `java -version` doit afficher 21 ou plus ; sinon installez un JDK 21+ |
| Le serveur C# ne démarre pas | .NET SDK antérieur à 10, ou sous-commande `dnx` absente | `dotnet --version` doit afficher 10.x ou plus ; sinon, passez cette sous-section |

</details>

**Défi** : configurez le serveur correspondant à un langage que vous utilisez au quotidien (même hors de cette liste) en suivant le même schéma JSON, et vérifiez-le avec `/lsp test`.

> 📚 Sources officielles : [Using LSP servers with GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers), [Adding LSP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers), [référence des serveurs du skill `lsp-setup`](https://github.com/github/awesome-copilot/blob/main/skills/lsp-setup/references/lsp-servers.md).

---

## 📝 Devoir

### Défi principal : reliez observabilité et usage

Activez l'export OpenTelemetry fichier (bloc D), effectuez trois interactions différentes avec Copilot CLI (une question simple, une lecture de fichier, une édition de fichier), puis utilisez Tokscale (bloc E.1) pour retrouver ces trois sessions et comparer leur coût estimé.

<details>
<summary>💡 Indices (cliquez pour développer)</summary>

- N'oubliez pas d'exporter `COPILOT_OTEL_FILE_EXPORTER_PATH` **avant** de lancer `copilot`, dans le même terminal.
- `tokscale clients` doit afficher un nombre de messages Copilot CLI supérieur à 0 avant de passer à `tokscale tui`.

</details>

### Défi bonus : Graphiti

Installez le serveur MCP de Graphiti (bloc E.2) et tentez de le connecter à Copilot CLI via `copilot mcp add`. Documentez ce qui fonctionne, ce qui échoue, et pourquoi — ce cas est volontairement non garanti par la documentation officielle, l'exercice consiste à le vérifier vous-même.

---

## Dépannage

### « copilot: command not found »

Le CLI n'est pas installé. Essayez une méthode d'installation différente :

```bash
# Si brew a échoué, essayez npm :
npm install -g @github/copilot

# Ou le script d'installation :
curl -fsSL https://gh.io/copilot-install | bash
```

### « You don't have access to GitHub Copilot »

1. Vérifiez que vous avez un abonnement Copilot sur [github.com/settings/copilot](https://github.com/settings/copilot)
2. Vérifiez que votre organisation autorise l'accès au CLI si vous utilisez un compte professionnel

### « Authentication failed »

Réauthentifiez-vous :

```bash
copilot
> /login
```

### Le navigateur ne s'ouvre pas automatiquement

Sur les terminaux distants ou sans interface graphique, le flux de code d'appareil est utilisé à la place. Votre terminal affichera un code à usage unique. Rendez-vous sur [github.com/login/device](https://github.com/login/device), saisissez le code, puis autorisez l'accès.

### Jeton expiré

Exécutez simplement à nouveau `/login` :

```bash
copilot
> /login
```

### Le modèle Auto ne route pas comme prévu

C'est un comportement documenté (exclusions d'abonnement, de politique d'administrateur, ou de résidence des données), pas un bug. Voir le bloc **A** de la section « Pour aller plus loin » ci-dessus.

### La Statusline personnalisée ne s'affiche pas

Vérifiez que `"experimental": true` et `"feature_flags": {"enabled": ["STATUS_LINE"]}` sont bien présents dans `~/.copilot/settings.json`, puis redémarrez Copilot CLI. Voir le bloc **B**.

### Une variable `COPILOT_OTEL_...` ne produit aucun fichier

La variable doit être exportée dans le même shell qui lance `copilot`, et une vraie interaction doit avoir eu lieu avant de quitter la session. Voir le bloc **D**.

### Un serveur LSP refuse de démarrer

Vérifiez d'abord que la commande existe dans votre `PATH` (`which <commande>`) et que les prérequis de version sont respectés (Java 21+ pour jdtls, .NET SDK 10+ pour le serveur C#). Voir le bloc **F**.

### Toujours bloqué ?

- Consultez la [documentation de GitHub Copilot CLI](https://docs.github.com/copilot/concepts/agents/about-copilot-cli)
- Recherchez dans les [GitHub Issues](https://github.com/github/copilot-cli/issues)

---

## 🔑 Points clés à retenir

1. **Un GitHub Codespace est un moyen rapide de démarrer** - Python, pytest, et GitHub Copilot CLI sont tous préinstallés pour que vous puissiez passer directement aux démonstrations
2. **Plusieurs méthodes d'installation** - Choisissez celle qui convient à votre système (Homebrew, WinGet, npm, ou script d'installation)
3. **Authentification unique** - La connexion persiste jusqu'à l'expiration du jeton
4. **La Book App fonctionne** - Vous utiliserez `samples/book-app-project` tout au long du cours
5. **La section « Pour aller plus loin » est optionnelle** - Modèle Auto, Statusline, Caveman/peon-ping, OpenTelemetry, Tokscale/Graphiti et serveurs LSP approfondissent votre configuration, mais rien de tout cela n'est requis pour continuer le cours

> 📚 **Documentation officielle** : [Installer Copilot CLI](https://docs.github.com/copilot/how-tos/copilot-cli/cli-getting-started) pour les options d'installation et les prérequis. Pour la section optionnelle : [sélection automatique de modèle](https://docs.github.com/en/copilot/concepts/models/auto-model-selection), [serveurs LSP](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers), [OpenTelemetry](https://docs.github.com/en/copilot/concepts/agents/opentelemetry), [référence du dossier de configuration](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference).

> 📋 **Référence rapide** : Consultez la [référence des commandes GitHub Copilot CLI](https://docs.github.com/en/copilot/reference/cli-command-reference) pour une liste complète des commandes et raccourcis.

---

**[← Retour au Chapitre 00 : Équipez votre terminal](../00-modern-terminal-stack/README.md)** | **[Continuer vers le Chapitre 02 : Premiers pas →](../02-setup-and-first-steps/README.md)**
