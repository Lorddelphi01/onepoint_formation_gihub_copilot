<!--
---
id: CopilotCLI-Appendix-AutoCLI
title: !translate Récupérer des données web pour tes projets IA avec AutoCLI
description: !translate Utilise l'outil AutoCLI pour récupérer des données réelles depuis le web, et comprends les pièges du scraping/API quand tu développes avec l'IA.
audience: Developers / Students / Terminal users
slug: web-data-retrieval-with-autocli
weight: 93
---
-->

# Récupérer des données web pour tes projets IA avec AutoCLI

> 📖 **Prérequis** : termine le [Chapitre 04 : Workflows de développement](../04-development-workflows/README.md) avant de lire cette annexe.
>
> ⚠️ **Cette annexe te fait installer un binaire tiers (AutoCLI, non maintenu par GitHub ni Microsoft) et, en option, une extension Chrome à privilèges larges.** Lis la section [Problématiques](#pourquoi-la-récupération-de-données-web-est-un-problème-en-dev-ia) avant d'installer quoi que ce soit : elle explique précisément ce que tu accordes comme accès.

Tout au long de ce cours, tu as demandé à Copilot CLI de générer du code à partir de tes instructions. Mais dès qu'une tâche a besoin de **données réelles et à jour** — un cours de bourse, le contenu d'une page web, les derniers messages d'un forum — un LLM seul ne peut pas te les fournir : il ne fait que prédire du texte plausible à partir de ce qu'il a appris à l'entraînement, qui a une date de coupure. Cette annexe montre comment combler ce manque avec [AutoCLI](https://github.com/nashsu/AutoCLI), un outil de récupération de données web, et revient sur les précautions à prendre chaque fois que tu fais entrer des données d'internet dans un développement assisté par IA.

---

## Pourquoi la récupération de données web est un problème en dev IA

<a id="pourquoi-la-récupération-de-données-web-est-un-problème-en-dev-ia"></a>

Avant le TP, prends le temps de comprendre pourquoi ce sujet mérite une annexe à part entière.

| Problème | Ce qui se passe concrètement | Ce qu'il faut faire |
|---|---|---|
| **Connaissances figées du LLM** | Un modèle IA répond à partir de ce qu'il a appris à l'entraînement, avec une date de coupure. Demande-lui « quelle est la structure actuelle de l'API X ? » sans lui donner de données réelles, et il peut inventer des champs, des URLs ou des versions obsolètes avec une confiance trompeuse | Ne demande jamais à un LLM de « se souvenir » d'un format d'API ou d'un contenu web : récupère les données réelles (via un outil comme AutoCLI, un appel API documenté, ou un MCP dédié — voir [Chapitre 07](../07-mcp-servers/README.md)) et donne-les-lui en contexte |
| **Fragilité du scraping** | Un site web change sa structure HTML sans préavis ; un parseur écrit (ou généré) pour l'ancienne version casse silencieusement ou renvoie des données incomplètes | Préfère toujours une API publique documentée quand elle existe ; si tu scrapes, ajoute des vérifications qui font échouer bruyamment le pipeline plutôt que de renvoyer des données tronquées |
| **Conditions d'utilisation et limites de débit** | Beaucoup de sites interdisent le scraping dans leurs conditions d'utilisation (ToS) ou l'encadrent via `robots.txt` ; les bombarder de requêtes peut faire bannir ton IP | Vérifie les ToS et `robots.txt` du site avant d'automatiser sa récupération ; espace tes requêtes ; privilégie les API publiques quand elles existent |
| **Accès authentifié vs accès public** | Récupérer des données derrière une connexion (réseau social, service payant) implique de réutiliser une session ou des cookies — donc de donner à un outil tiers un accès qui va bien au-delà de la simple lecture de page | N'autorise un mode authentifié que pour des outils de confiance, sur des comptes dédiés si possible, jamais avec tes identifiants principaux |
| **Provenance et licence des données** | Une donnée récupérée sur le web n'est pas automatiquement réutilisable dans ton produit : texte protégé par le droit d'auteur, données personnelles, contenu sous licence incompatible | Avant de réutiliser une donnée récupérée, note sa source, sa date de récupération et sa licence — c'est l'objet du « Devoir » de cette annexe |

Retiens le principe général : **une IA qui doit raisonner sur le monde réel a besoin qu'on lui fournisse le monde réel** — pas qu'on lui demande de le deviner. Le rôle d'un outil comme AutoCLI est justement de faire ce pont, mais cela ne dispense d'aucune des précautions ci-dessus.

---

## Présentation d'AutoCLI

<a id="présentation-d-autocli"></a>

[AutoCLI](https://github.com/nashsu/AutoCLI) est un outil en ligne de commande open source (licence Apache-2.0), écrit en Rust, qui se présente comme une alternative plus rapide et plus légère à un projet équivalent en TypeScript (OpenCLI). Son objectif : récupérer des informations depuis n'importe quel site web avec une seule commande, sans que tu aies à écrire toi-même un scraper.

Son fonctionnement repose sur une **architecture pipeline déclarative en YAML** : chaque site pris en charge est décrit par un adaptateur qui enchaîne des étapes (`fetch`, `evaluate`, `navigate`, `click`, `map`, `filter`, `sort`, `limit`, `intercept`, etc.). AutoCLI fournit plus de 55 adaptateurs prêts à l'emploi (Hacker News, Wikipedia, Bilibili, Zhihu, Xiaohongshu, Twitter/X, Reddit, Douban, entre autres), et couvre quatre stratégies de récupération :

| Stratégie | Principe | Nécessite l'extension Chrome ? |
|---|---|---|
| `public` | Appels directs à des API publiques, sans authentification | Non |
| `cookie` | Réutilisation d'une session navigateur déjà connectée | Oui |
| `intercept` | Interception des requêtes réseau du site | Oui |
| `ui` | Interaction directe avec l'interface (clics, saisie) | Oui |

Fait notable : AutoCLI intègre une capacité de génération d'adaptateur assistée par IA (`autocli generate <url> --ai`), qui explore la surface API d'un site et propose automatiquement un fichier YAML pour le récupérer. Comme tout code généré par IA, cet adaptateur doit être relu avant d'être utilisé en confiance — voir la section TP.

L'outil est distribué sous forme de binaire unique (~4,7 Mo) sans dépendance runtime, disponible pour macOS, Linux et Windows.

---

## Installation

### Installation en une ligne (macOS/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/nashsu/autocli/main/scripts/install.sh | sh
```

> ⚠️ **Avant d'exécuter un `curl | sh`, prends l'habitude de lire le script.** Ouvre l'URL dans ton navigateur, vérifie ce qu'il fait (où il installe le binaire, s'il modifie ton `PATH`), puis relance la commande. C'est la même discipline que celle que tu appliques déjà à toute sortie générée par une IA : on relit avant d'exécuter.

### Installation manuelle

Télécharge le binaire correspondant à ton système depuis les [GitHub Releases](https://github.com/nashsu/AutoCLI/releases) du projet, puis rends-le exécutable et place-le dans ton `PATH`.

Vérifie ensuite l'installation :

```bash
autocli --help
```

### Extension Chrome (optionnelle)

Les modes `cookie`, `intercept` et `ui` nécessitent l'extension Chrome d'AutoCLI. Télécharge le fichier `.zip` correspondant depuis les Releases, puis charge-le manuellement dans `chrome://extensions/` (mode développeur activé).

> ⚠️ **Cette extension a accès à chaque page web que tu visites** — c'est une conséquence directe de ce qu'elle doit faire (réutiliser tes sessions, intercepter des requêtes). Le mode `public`, utilisé dans le TP ci-dessous, ne nécessite pas cette extension : commence par lui, et n'installe l'extension que si un site précis l'exige vraiment.

---

## 🧪 Mise en pratique

Ce TP reste volontairement en mode `public` (aucune authentification, aucune extension Chrome requise) pour se concentrer sur la récupération de données elle-même.

Crée un dossier de travail dédié à ce TP, séparé de l'application de gestion de livres utilisée dans le reste du cours :

```bash
mkdir tp-autocli && cd tp-autocli
```

### Étape 1 — Récupérer des données réelles

Interroge l'adaptateur Hacker News en mode public, au format JSON :

```bash
autocli hackernews top --limit 10 --format json > hn-top.json
```

Inspecte le résultat :

```bash
cat hn-top.json
```

### Étape 2 — Faire écrire un script par Copilot CLI à partir de ces données réelles

C'est le cœur de l'exercice : tu donnes à Copilot CLI un **fichier de données réel**, plutôt que de lui demander de deviner un format.

```bash
copilot

> Écris un script Python autonome, script.py, qui lit hn-top.json dans le
> répertoire courant et affiche pour chaque article son titre, son nombre de
> points et son URL, trié par nombre de points décroissant. N'utilise que la
> bibliothèque standard.
```

Exécute le script généré et vérifie que la sortie correspond bien au contenu de `hn-top.json`.

### ▶️ À toi de jouer

1. Refais la même récupération sur un autre adaptateur public, par exemple `autocli wikipedia search "intelligence artificielle" --format json`
2. Demande cette fois une sortie au format CSV (`--format csv`) plutôt que JSON, et observe comment cela change la structure du fichier obtenu
3. Compare : que se passerait-il si tu avais simplement demandé à Copilot CLI « donne-moi les articles populaires de Hacker News » sans passer par AutoCLI ? Teste la question dans une session Copilot CLI et confronte sa réponse aux données réelles de `hn-top.json`

---

## 📝 Devoir

**Défi principal** : à côté de `hn-top.json`, crée un fichier `PROVENANCE.md` qui documente pour ce jeu de données : sa source exacte (URL/adaptateur AutoCLI utilisé), la date et l'heure de récupération, et la licence ou les conditions d'utilisation applicables aux données de Hacker News. C'est exactement le réflexe de traçabilité évoqué dans la section [Problématiques](#pourquoi-la-récupération-de-données-web-est-un-problème-en-dev-ia) — à reproduire à chaque fois que tu réutilises une donnée externe dans un vrai projet.

**Défi bonus** : choisis un site simple non couvert par les adaptateurs intégrés d'AutoCLI, puis génère un adaptateur automatiquement :

```bash
autocli generate https://example.com --ai
```

Ouvre le fichier YAML généré et relis-le ligne par ligne avant de l'exécuter — comme tu le ferais pour toute sortie de code produite par une IA.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, vérifie la page « Terms of Use » du site source de l'adaptateur (Hacker News appartient à Y Combinator) plutôt que de supposer que « c'est public donc libre de droits »
- Pour le défi bonus, préfère un site simple avec peu de JavaScript dynamique : l'adaptateur généré automatiquement sera plus facile à relire et à comprendre

</details>

---

## 🔧 Dépannage

<details>
<summary>Clique pour voir les problèmes fréquents et leurs solutions</summary>

| Erreur | Ce qui se passe | Solution |
|---|---|---|
| `autocli: command not found` | Le binaire n'est pas dans ton `PATH` | Relance le script d'installation, ou déplace manuellement le binaire téléchargé dans un répertoire de ton `PATH` (ex. `/usr/local/bin`) |
| Une commande en mode `cookie`/`intercept`/`ui` échoue silencieusement | L'extension Chrome n'est pas chargée ou pas activée pour ce site | Vérifie `chrome://extensions/`, recharge l'extension, réessaie en mode `public` si un adaptateur public existe pour ce site |
| Le site bloque ou renvoie des erreurs 429 | Tu dépasses la limite de débit imposée par le site | Espace tes requêtes, réduis `--limit`, vérifie les ToS du site avant d'automatiser davantage |
| Téléchargement vidéo qui échoue | `yt-dlp` n'est pas installé séparément | Installe `yt-dlp` sur ton système, c'est une dépendance externe requise pour les commandes de téléchargement vidéo |
| Une commande précise ne fonctionne pas alors qu'elle est documentée | AutoCLI est un outil jeune : son propre projet indique un taux de réussite de tests d'environ 84 % (103/122 commandes) | Considère chaque commande comme potentiellement instable avant de l'automatiser en production ; vérifie toujours la sortie obtenue |

</details>

---

## Résumé

Tu as utilisé AutoCLI pour récupérer des données réelles et à jour depuis le web en mode public, puis donné ces données réelles à Copilot CLI plutôt que de lui demander de les deviner. Tu as aussi vu, avec les avertissements officiels du projet lui-même (accès large de l'extension Chrome, fiabilité partielle, dépendances externes), que récupérer des données depuis internet n'est jamais une opération neutre.

### 🔑 Points clés à retenir

1. Un LLM ne connaît pas le web en temps réel : donne-lui des données récupérées, ne lui demande pas de les inventer
2. Le mode `public` d'un outil de récupération de données suffit dans la majorité des cas et évite d'accorder des accès larges (session, extension navigateur)
3. Toute donnée récupérée sur le web mérite une note de provenance (source, date, licence) avant réutilisation dans un projet
4. Un adaptateur ou un script généré par IA pour récupérer des données se relit avant exécution, exactement comme du code généré par IA pour toute autre tâche

---

## 📋 Référence rapide

- [Dépôt AutoCLI](https://github.com/nashsu/AutoCLI) — code source, documentation, Releases
- [Licence Apache-2.0](https://github.com/nashsu/AutoCLI/blob/main/LICENSE) — licence du projet AutoCLI
- [Chapitre 04 : Workflows de développement](../04-development-workflows/README.md) — pour approfondir la délégation de tâches à Copilot CLI
- [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) — alternative pour connecter Copilot CLI à des sources de données en direct

---

## ➡️ Et ensuite ?

Tu sais maintenant reconnaître les situations où un LLM a besoin de données réelles plutôt que de sa mémoire d'entraînement, et tu disposes d'un réflexe de traçabilité à appliquer à toute donnée externe que tu injectes dans un projet assisté par IA.

**[← Chapitre 04 : Workflows de développement](../04-development-workflows/README.md)** | **[Retour aux annexes](README.md)**
