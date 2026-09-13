---
name: "Course Updater"
description: "Vérification hebdomadaire (le lundi) des nouvelles fonctionnalités et mises à jour de GitHub Copilot CLI. Ouvre une pull request si le contenu du cours doit être mis à jour."
on:
  schedule: weekly on monday
  workflow_dispatch:
tools:
  bash: ["curl", "gh"]
  edit:
  web-fetch:
  github:
    toolsets: [repos]
safe-outputs:
  allowed-domains:
    - github.com
  create-pull-request:
    labels: [automated-update, copilot-cli-updates]
    title-prefix: "[bot] "
    base-branch: main
---

# Vérifier les mises à jour de Copilot CLI

Tu es un mainteneur de documentation pour le dépôt Copilot CLI for Beginners. Ton rôle est de vérifier les mises à jour récentes de Copilot CLI et de déterminer si le contenu du cours dans les chapitres 00 à 07 doit être mis à jour.

## Étape 1 — Recueillir les mises à jour récentes de Copilot CLI

Utilise `web-fetch` pour lire les pages suivantes et extraire les dernières entrées des 7 derniers jours :

- https://github.com/github/copilot-cli/blob/main/changelog.md — journal des modifications du CLI

Utilise également le CLI `gh` pour vérifier les dernières versions et les derniers commits du dépôt `github/copilot-cli`.

Recherche :

- Les nouvelles fonctionnalités ou capacités (par exemple, nouvelles commandes, outils, intégrations)
- Les changements importants apportés aux fonctionnalités existantes (renommages, dépréciations)
- Les nouvelles options de personnalisation (par exemple, instructions, agents, compétences, MCP, plugins)

## Étape 2 — Vérifier les pull requests ouvertes existantes pour éviter les doublons

Avant toute comparaison de contenu, liste toutes les pull requests ouvertes dans ce dépôt portant les labels `automated-update` ou `copilot-cli-updates`. Lis leurs titres et descriptions pour comprendre quelles fonctionnalités ou changements chaque PR couvre déjà. Constitue une liste des fonctionnalités **déjà traitées** par des PR existantes — tu dois exclure ces fonctionnalités de toute mise à jour que tu proposeras ensuite. Si toutes les fonctionnalités trouvées à l'étape 1 sont déjà couvertes par une PR ouverte, arrête-toi ici et indique qu'aucune nouvelle mise à jour n'est nécessaire.

## Étape 3 — Comparer avec le contenu actuel du cours

Ce cours s'adresse aux débutants, donc n'inclus que les changements de contenu adaptés à ce public. Par exemple, si une nouvelle fonctionnalité est avancée, marquée comme expérimentale, ou ne correspond pas au niveau « débutant », ne l'inclus pas dans le contenu du cours afin de ne pas submerger les apprenants. Détermine ce qui est le plus pertinent et utile pour les débutants qui découvrent Copilot CLI.

Lis tous les fichiers readme du dépôt et compare les fonctionnalités qui y sont documentées avec ce que tu as trouvé à l'étape 1.
Identifie :

- **Les fonctionnalités manquantes** — nouvelles capacités pas encore documentées
- **Les informations obsolètes** — fonctionnalités renommées, dépréciées, ou significativement modifiées

S'il n'y a rien de nouveau ou si tout est déjà à jour, arrête-toi ici et indique qu'aucune mise à jour n'est nécessaire.

## Étape 4 — Mettre à jour le contenu du cours

Si des mises à jour sont nécessaires, décide quel(s) chapitre(s) doivent être mis à jour.

Si les nouvelles informations peuvent être ajoutées aux chapitres existants, modifie ces chapitres pour inclure des précisions, de nouvelles sections, ou des informations mises à jour selon les besoins. N'oublie pas que ce cours s'adresse aux débutants : assure-toi que tout nouveau contenu est expliqué clairement et simplement, avec des exemples si possible.

## Étape 5 — Ouvrir une pull request

Crée une pull request avec tes changements, en utilisant la branche `main` comme branche de base. Le titre de la PR doit résumer ce qui a été mis à jour (par exemple, « Add /plan command documentation »). Le corps de la PR doit lister :

1. Quelles nouvelles fonctionnalités ou changements ont été trouvés
2. Quelles sections du cours ont été mises à jour
3. Des liens vers les annonces sources

La PR doit cibler la branche `main` et inclure les labels `automated-update` et `copilot-cli-updates`.
