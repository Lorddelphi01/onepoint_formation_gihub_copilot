<!--
---
id: CopilotCLI-09
title: !translate Environnements isolés
description: !translate Exécutez GitHub Copilot CLI dans un dev container, puis isolez-le complètement dans une sandbox Docker pour automatiser en toute confiance avec --allow-all.
audience: Developers / Students / Terminal users
slug: isolated-environments
weight: 10
---
-->

![Chapitre 09 : Environnements isolés](assets/chapter-header.png)

> **Et si vous pouviez laisser Copilot CLI travailler en pleine autonomie — `--allow-all`, aucune confirmation à chaque étape — sans jamais craindre pour le reste de votre machine ?**

Au [Chapitre 02](../02-setup-and-first-steps/README.md) et dans l'annexe [Fonctionnalités de contexte supplémentaires](../appendices/additional-context.md), vous avez découvert `--allow-all` (et son alias `--yolo`) : le drapeau qui désactive toutes les invites de permission, indispensable pour automatiser Copilot CLI sans supervision humaine. Ces annexes le disaient déjà : *« N'utilisez `--allow-all` qu'avec des prompts que vous avez écrits vous-même et dans des répertoires en lesquels vous avez confiance. »* Ce chapitre bonus construit exactement ce contexte de confiance : un environnement où `--allow-all` devient sûr par construction, pas seulement par prudence.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Ouvrir ce dépôt dans un **dev container** cohérent et reproductible
- Distinguer un dev container (environnement d'équipe cohérent) d'une **sandbox** (isolation stricte pensée pour l'automatisation)
- Lancer GitHub Copilot CLI dans une **Docker Sandbox** isolée avec `sbx run copilot`
- Configurer une politique réseau *deny-by-default* qui n'autorise que les domaines dont Copilot a réellement besoin
- Automatiser une revue de code avec `--allow-all` sans surveillance humaine, en toute sécurité

> ⏱️ **Durée estimée** : ~60 minutes (20 min de lecture + 40 min de pratique)

---

## ✅ Prérequis

- [Chapitre 01 : Démarrage rapide](../01-quick-start/README.md) terminé (Copilot CLI installé et vérifié)
- Avoir lu l'encart sur `--allow-all` du [Chapitre 02](../02-setup-and-first-steps/README.md#découvrez-la-puissance-du-mode-programmatique) ou de l'annexe [Fonctionnalités de contexte supplémentaires](../appendices/additional-context.md)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installé
- ⚠️ **Partie 2 uniquement** : Docker Desktop **4.50+** pour la fonctionnalité Docker Sandboxes. Si votre version est plus ancienne, mettez à jour Docker Desktop, ou repliez-vous sur l'isolation manuelle décrite dans l'encadré de repli — vous pouvez suivre la Partie 1 (dev container) sans cette contrainte.

---

## 🧩 Analogie du monde réel : l'atelier partagé et l'atelier verrouillé

Imaginez deux ateliers de menuiserie :

- Un **atelier partagé** : chaque membre de l'équipe y retrouve les mêmes établis, les mêmes outils, rangés au même endroit. Personne ne perd de temps à adapter son matériel — c'est le rôle du **dev container**.
- Un **atelier verrouillé** : ses murs sont pleins, sa seule porte est filtrée (on y entre et on en sort uniquement par des passages surveillés). C'est là qu'on laisse un apprenti travailler seul toute une journée, sans craindre qu'il n'abîme le reste du bâtiment. C'est le rôle de la **sandbox**.

| | Dev container | Sandbox |
|---|---|---|
| **Objectif** | Un environnement de développement cohérent pour toute l'équipe | Une isolation stricte pour exécuter un agent en autonomie |
| **Ce qui est isolé** | Les outils et versions (mais pas l'accès au reste de votre système) | Le système de fichiers **et** le réseau, avec un pare-feu par défaut |
| **Quand l'utiliser** | Développement quotidien, onboarding, Codespaces | Automatisation `--allow-all`/`--yolo` sans surveillance |

Les deux sont complémentaires : vous pouvez très bien lancer une sandbox *depuis* un dev container. Commençons par le premier niveau.

---

## Partie 1 : Copilot CLI dans un dev container

Un **dev container** est un environnement de développement décrit par un fichier `devcontainer.json` : une image Docker, des outils préinstallés, des extensions VS Code. Ouvrez-le avec l'extension VS Code **Dev Containers**, ou laissez GitHub Codespaces s'en charger pour vous (c'est exactement ce que fait le Chapitre 01 quand vous choisissez l'option Codespaces) — vous obtenez le même environnement, peu importe la machine.

Ce dépôt en a déjà un, à sa racine :

```json
// .devcontainer/devcontainer.json
{
  "name": "GitHub Copilot CLI for Beginners",
  "image": "mcr.microsoft.com/devcontainers/python:2-3.13-bullseye",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/node:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": ["ms-python.python"]
    }
  },
  "onCreateCommand": "pip install pytest && npm install -g @github/copilot",
  "postStartCommand": "echo '✅ Python, pytest, GitHub CLI, and Copilot CLI are ready. Run: cd samples/book-app-project && python book_app.py help'"
}
```

`onCreateCommand` installe Copilot CLI via npm à la création du conteneur — c'est cette même configuration que Codespaces utilise au Chapitre 01.

### Une alternative : la Dev Container Feature officielle

Plutôt que d'installer Copilot CLI à la main dans `onCreateCommand`, vous pouvez utiliser la [Feature officielle `copilot-cli`](https://github.com/devcontainers/features/tree/main/src/copilot-cli), maintenue par l'équipe `devcontainers` :

```json
{
  "name": "GitHub Copilot CLI for Beginners",
  "image": "mcr.microsoft.com/devcontainers/python:2-3.13-bullseye",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/devcontainers/features/copilot-cli:1": {
      "version": "latest"
    }
  },
  "onCreateCommand": "pip install pytest",
  "postStartCommand": "echo '✅ Python, pytest, GitHub CLI, and Copilot CLI are ready.'"
}
```

> 💡 **Version de la Feature** : `1` suit la dernière version mineure disponible. Pour figer une version précise (utile en CI, pour la reproductibilité), utilisez par exemple `ghcr.io/devcontainers/features/copilot-cli:1.1.3` au lieu de `:1`. Si votre organisation restreint l'accès aux registres de Features (registre d'entreprise fermé), gardez simplement l'approche `onCreateCommand: npm install -g @github/copilot` déjà en place dans ce dépôt — les deux méthodes installent le même paquet.

<details>
<summary>🎬 Voyez-le en action !</summary>

![Démo d'ouverture du dev container](assets/devcontainer-demo.gif)

*Le résultat peut varier selon votre version de VS Code et votre système d'exploitation : ne soyez pas surpris si l'enchaînement des écrans diffère légèrement de celui présenté ici.*

</details>

### ▶️ À vous de jouer : TP 1 — ouvrir le dev container

1. Installez l'extension VS Code **Dev Containers** (`ms-vscode-remote.remote-containers`) si ce n'est pas déjà fait.
2. Ouvrez ce dépôt dans VS Code, puis **Palette de commandes** (`Ctrl+Shift+P` / `Cmd+Shift+P`) > **Dev Containers: Reopen in Container**.
3. Patientez pendant la construction du conteneur (la première fois seulement — les suivantes réutilisent le cache).
4. Dans le terminal intégré (déjà à l'intérieur du conteneur) :
   ```bash
   copilot --version
   cd samples/book-app-project && python book_app.py help
   ```
5. **Défi** : faites une copie de `.devcontainer/devcontainer.json` (ne la committez pas), remplacez la ligne `onCreateCommand` par la Feature `ghcr.io/devcontainers/features/copilot-cli:1` montrée ci-dessus, puis **Dev Containers: Rebuild Container**. Vérifiez que `copilot --version` fonctionne toujours.

---

## Partie 2 : Copilot CLI dans une sandbox Docker

Un dev container donne un environnement **cohérent**, mais Copilot y a toujours accès à tout votre espace de travail monté et à votre réseau habituel. Pour utiliser `--allow-all`/`--yolo` sans surveillance humaine, il faut une isolation plus stricte — c'est le rôle d'une **sandbox**.

> 💬 Le même principe existe pour d'autres agents IA en ligne de commande — voir par exemple le [guide d'isolation par sandbox Docker de Claude Code](https://cc.bruniaux.com/guide/sandbox-isolation/), qui documente la fonctionnalité **Docker Sandboxes** pour Claude Code. Pour GitHub Copilot CLI, Docker publie la même fonctionnalité, avec des commandes équivalentes : [docs.docker.com/ai/sandboxes/agents/copilot](https://docs.docker.com/ai/sandboxes/agents/copilot/).

### Docker Sandboxes : une microVM par agent

Depuis Docker Desktop 4.50+, la fonctionnalité **Docker Sandboxes** (commande `sbx`) lance chaque agent dans sa propre microVM : son propre noyau, son propre démon Docker, un système de fichiers isolé, et un pare-feu réseau qui peut bloquer tout par défaut.

> ⚠️ **Repli si `sbx` n'est pas disponible** : si votre Docker Desktop est trop ancien ou que la fonctionnalité Sandboxes n'est pas activée, mettez à jour Docker Desktop (ou activez les Sandboxes dans ses paramètres), ou repliez-vous sur un conteneur classique avec des montages restreints :
> ```bash
> docker run -it --rm \
>   -v "$(pwd)":/workspace -w /workspace \
>   node:22 bash -lc "npm install -g @github/copilot && copilot"
> ```
> Ce repli isole moins bien (pas de microVM ni de pare-feu par domaine), mais reste préférable à une exécution `--allow-all` directement sur votre machine hôte.

### Authentification

```bash
# Stocker votre token GitHub pour la sandbox
sbx secret set github --command 'gh auth token'
```

### Lancer Copilot CLI dans la sandbox

```bash
# Lance Copilot dans le répertoire courant
sbx run copilot

# Lance Copilot dans un projet précis
sbx run copilot samples/book-app-project

# Passe des arguments à Copilot (-- sépare les args de sbx de ceux de copilot)
sbx run copilot -- -p "Review @book_app.py for issues"
```

Par défaut, la sandbox exécute `copilot --yolo` — l'alias de `--allow-all` que vous connaissez déjà. Puisque l'isolation est assurée par la microVM elle-même, il n'y a plus besoin d'approuver chaque action une par une : c'est exactement le compromis que l'encart `--allow-all` vous invitait à rechercher.

> 💡 **Configuration non reprise** : la sandbox ne récupère pas votre configuration utilisateur habituelle (`~/.copilot`, instructions personnalisées globales) — seule la configuration au niveau du projet, dans le répertoire de travail, est prise en compte. C'est volontaire : cela évite qu'une configuration personnelle ne s'exporte dans un environnement automatisé.

### Restreindre l'accès réseau

Le système de fichiers est déjà isolé par la microVM, mais le réseau reste ouvert par défaut. Pour un vrai « deny-by-default », configurez une politique réseau qui n'autorise que les domaines dont Copilot a réellement besoin :

```bash
docker sandbox network proxy my-sandbox \
  --policy deny \
  --allow-host api.githubcopilot.com \
  --allow-host github.com \
  --allow-host api.github.com
```

Ces trois domaines correspondent à la [liste d'autorisation officielle de GitHub Copilot](https://docs.github.com/en/copilot/reference/copilot-allowlist-reference) — ajoutez `*.githubusercontent.com` si vos prompts référencent des assets GitHub (releases, gists, avatars).

### ▶️ À vous de jouer : TP 2 — automatiser une revue en sandbox

1. Configurez l'authentification : `sbx secret set github --command 'gh auth token'`.
2. Depuis la racine du dépôt, lancez une revue automatisée du sample Python, entièrement non surveillée :
   ```bash
   sbx run copilot samples/book-app-project -- -p "Review @book_app.py for issues. List only critical issues."
   ```
3. Configurez la politique réseau en deny-by-default avec les trois domaines Copilot ci-dessus, puis relancez la même commande : elle doit toujours fonctionner, ce sont les seuls domaines nécessaires.
4. **Vérifiez l'isolation** : dans le même prompt, demandez à Copilot de lire un fichier hors du répertoire monté (par exemple un chemin absolu vers votre dossier personnel). L'accès doit échouer — c'est la frontière de la microVM qui protège le reste de votre machine, pas une simple invite de permission que vous auriez pu accepter par réflexe.
5. **Comparez avec le TP 1** : dans le dev container, la même tentative de lecture hors-projet aurait probablement réussi, car le conteneur partage votre système de fichiers monté plus largement. C'est la différence clé entre un **environnement de développement cohérent** (dev container) et un **bac à sable d'automatisation** (sandbox).

---

## 📝 Devoir

### Défi principal : revue automatisée verrouillée

En partant du TP 2, écrivez un court script bash qui : configure la politique réseau deny-by-default, lance `sbx run copilot` sur `samples/book-app-project` avec un prompt de revue de sécurité (inspirez-vous de l'exemple du [Chapitre 08](../08-putting-it-together/README.md#workflow-2--automatisation-de-la-revue-de-code-optionnel)), et écrit le résultat dans un fichier `review.md`.

<details>
<summary>💡 Indices</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

docker sandbox network proxy my-sandbox \
  --policy deny \
  --allow-host api.githubcopilot.com \
  --allow-host github.com \
  --allow-host api.github.com

sbx run copilot samples/book-app-project -- \
  -p "Security review of @book_app.py. List only critical issues." \
  > review.md
```

</details>

### Défi bonus : combiner dev container et sandbox

Modifiez le `Dockerfile` implicite du dev container (ou créez-en un dérivé) pour qu'il inclue déjà les outils nécessaires à `sbx`, afin de pouvoir lancer une sandbox *depuis l'intérieur* du dev container, sans dupliquer l'installation des dépendances entre les deux couches.

---

<details>
<summary>🔧 <strong>Erreurs courantes et dépannage</strong> (cliquez pour développer)</summary>

### Erreurs courantes

| Erreur | Ce qui se passe | Correction |
|---------|--------------|-----|
| `sbx: command not found` | Docker Desktop est trop ancien ou la fonctionnalité Sandboxes n'est pas activée | Mettez à jour vers Docker Desktop 4.50+, activez les Sandboxes dans les paramètres, ou utilisez le repli `docker run` manuel |
| `sbx run copilot` échoue avec une erreur d'authentification | `gh auth token` n'a rien retourné | Vérifiez que `gh auth status` fonctionne sur l'hôte avant `sbx secret set github --command 'gh auth token'` — la sandbox rejoue cette commande, elle ne peut pas authentifier `gh` elle-même |
| La politique réseau bloque des requêtes légitimes | Le pare-feu filtre par domaine, pas par contenu | Ajoutez le domaine manquant avec `--allow-host` plutôt que de repasser en `--policy allow` (ce qui annulerait l'isolation) |
| `copilot` introuvable après un rebuild du dev container | Les deux méthodes d'installation (npm dans `onCreateCommand` et Feature `copilot-cli`) sont actives en même temps et entrent en conflit sur le `PATH` | Gardez une seule méthode d'installation à la fois |

</details>

---

## Résumé

Vous savez maintenant faire tourner Copilot CLI aussi bien dans un environnement de développement partagé que dans un bac à sable strictement isolé — le même outil, deux niveaux de confiance différents selon le contexte.

### 🔑 Points clés à retenir

1. **Dev container ≠ sandbox** : le premier donne un environnement cohérent, la seconde isole strictement le système de fichiers et le réseau
2. **`sbx run copilot` exécute `--yolo` par défaut** : sûr uniquement parce que l'isolation de la microVM remplace les invites de permission
3. **Le pare-feu filtre par domaine, pas par contenu** : `--allow-host` construit une liste blanche minimale, pas une inspection du trafic
4. **Toujours un repli documenté** : sans Docker Desktop 4.50+, un `docker run` classique avec des montages restreints reste une isolation utile

## 📋 Référence rapide

- [Docker Sandboxes pour Copilot CLI](https://docs.docker.com/ai/sandboxes/agents/copilot/) — documentation officielle
- [Liste d'autorisation réseau de GitHub Copilot](https://docs.github.com/en/copilot/reference/copilot-allowlist-reference)
- [Dev Container Feature `copilot-cli`](https://github.com/devcontainers/features/tree/main/src/copilot-cli)
- [Référence des commandes GitHub Copilot CLI](https://docs.github.com/en/copilot/reference/cli-command-reference)

---

## ➡️ Et ensuite ?

Vous avez maintenant vu Copilot CLI dans trois contextes d'exécution différents à travers ce cours : votre machine locale, un dev container cohérent, et une sandbox strictement isolée. Le principe reste le même partout — plus vous automatisez, plus l'environnement qui vous entoure doit inspirer confiance.

**[← Chapitre précédent : Tout assembler](../08-putting-it-together/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
