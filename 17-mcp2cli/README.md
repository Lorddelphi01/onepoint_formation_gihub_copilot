<!--
---
id: CopilotCLI-17
title: !translate Aller plus loin avec MCP : mcp2cli et le coût en tokens
description: !translate Comprenez pourquoi MCP a un coût en tokens, puis découvrez mcp2cli, un pont CLI qui transforme un serveur MCP en outil de terminal natif, pour interroger Context7 sans passer par une session Copilot.
audience: Developers / Students / Terminal users
slug: mcp2cli-and-token-cost
weight: 18
---
-->

![Chapitre 17 : mcp2cli](assets/chapter-header.png)

> **Et si vous pouviez interroger un serveur MCP directement depuis votre terminal, sans faire transiter chaque échange par un modèle d'IA ?**

Au [Chapitre 07](../07-mcp-servers/README.md), vous avez connecté Copilot CLI à des serveurs MCP : GitHub, le système de fichiers, Context7. Chaque fois que Copilot utilise l'un de ces serveurs, deux choses se produisent en coulisses : le modèle doit d'abord « connaître » les outils disponibles (leurs noms, leurs paramètres, leurs descriptions), puis il doit lire chaque résultat renvoyé par le serveur. Les deux consomment des tokens, à chaque tour de conversation, pour chaque serveur connecté.

Ce chapitre bonus revient sur ce coût, et vous fait découvrir **mcp2cli**, un outil tiers qui transforme n'importe quel serveur MCP en ligne de commande native. Vous l'utiliserez pour interroger le serveur Context7 (déjà configuré au Chapitre 07) directement depuis votre terminal, sans passer par Copilot du tout.

> ⚠️ **Ce chapitre suppose que vous avez terminé le [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md)**, en particulier la configuration du serveur Context7. Sans cela, vous n'aurez rien à interroger.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Expliquer pourquoi chaque serveur MCP connecté a un coût en tokens, même quand vous ne l'utilisez pas activement
- Installer mcp2cli et l'utiliser pour découvrir les outils d'un serveur MCP existant
- Inspecter puis invoquer un outil MCP directement depuis le terminal, en JSON
- Choisir entre Copilot + MCP et mcp2cli selon ce que vous cherchez à faire

> ⏱️ **Durée estimée** : ~35 minutes (10 min de lecture + 25 min de pratique)

---

## ✅ Prérequis

> ⚠️ **[Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) obligatoire.** Ce chapitre réutilise le serveur Context7 que vous y avez configuré.

- Le serveur Context7 configuré dans `~/.copilot/mcp-config.json` ou `.mcp.json` (voir [Serveur Context7](../07-mcp-servers/README.md#context7-server-documentation))
- Être à l'aise avec les commandes de terminal de base
- `curl` disponible sur votre système (pour l'installation)

---

## 🧩 Analogie du monde réel : standardiste vs ligne directe

Pensez à Copilot + MCP comme à un standard téléphonique : vous décrivez ce que vous voulez à un ou une standardiste (le modèle), qui comprend votre demande, sait quel poste (quel outil MCP) appeler, transmet votre question, écoute la réponse complète, puis vous la reformule. C'est précieux : le ou la standardiste peut interpréter une demande ambiguë, enchaîner plusieurs appels, et faire la synthèse. Mais chaque échange occupe son attention, et donc du temps.

mcp2cli, c'est la ligne directe : quand vous savez déjà exactement quel poste appeler et quoi lui dire, vous composez le numéro vous-même. C'est plus rapide, ça ne mobilise personne d'autre, mais vous n'avez plus personne pour interpréter une réponse ambiguë ou décider quoi faire ensuite.

| Standard téléphonique | Ligne directe |
|---|---|
| **Copilot + MCP** : le modèle lit les outils disponibles, comprend votre demande, appelle le bon outil, interprète le résultat | **mcp2cli** : vous appelez directement l'outil, vous lisez vous-même le résultat brut |
| Coûte des tokens à chaque échange (schémas d'outils + résultats) | Coûte zéro token de modèle : rien ne transite par une IA |
| Utile pour une tâche complexe, ambiguë, ou multi-étapes | Utile pour une recherche ciblée et répétée, ou un script |

> 💡 **Point clé** : Les deux approches parlent le même protocole MCP au même serveur. Ce n'est pas Context7 qui change, c'est qui — ou quoi — se trouve entre vous et lui.

---

## Pourquoi MCP coûte des tokens

Un [Token](../GLOSSARY.md#token) est l'unité de texte que Copilot traite, et la [fenêtre de contexte](../GLOSSARY.md#context-window-fenêtre-de-contexte) est la place disponible pour tous les tokens d'une conversation : vos prompts, l'historique, les fichiers partagés — et les serveurs MCP.

Concrètement, quand un serveur MCP est activé, deux coûts s'ajoutent :

1. **Le coût de découverte** : au démarrage d'une session (et à chaque reconnexion), Copilot reçoit la liste des outils de chaque serveur activé — leurs noms, leurs descriptions, le schéma JSON de leurs paramètres. Plus vous avez de serveurs actifs, avec `"tools": ["*"]`, plus cette liste est longue, et plus elle occupe de place dans la fenêtre de contexte *avant même votre premier prompt*.
2. **Le coût d'appel** : chaque fois que Copilot appelle un outil, les arguments de l'appel et le résultat complet renvoyé par le serveur passent par le modèle. Un résultat volumineux (une longue page de documentation, par exemple) coûte des tokens à lire, même si vous n'en avez besoin que d'un court extrait.

Vous avez déjà croisé deux leviers pour réduire ce coût au Chapitre 07, sans que le lien avec les tokens soit fait explicitement :

- **Limiter `"tools"` dans la configuration** plutôt que `["*"]`, pour n'exposer que les outils réellement utiles d'un serveur.
- **`/mcp disable <server-name>`** pour désactiver un serveur que vous n'utilisez pas dans la session en cours (voir [Commandes MCP supplémentaires](../07-mcp-servers/README.md#-additional-mcp-commands)).

mcp2cli propose une troisième option, plus radicale : sortir complètement le modèle de l'équation pour les requêtes où vous n'avez pas besoin de raisonnement, seulement d'une donnée.

---

## Découvrir mcp2cli

[mcp2cli](https://mcp2cli.dev/) est un outil tiers (licence Apache 2.0) qui « transforme n'importe quel serveur MCP en application de ligne de commande native ». Il se connecte à un serveur MCP, découvre automatiquement ses outils, ressources et prompts, puis les expose comme des commandes de terminal typées : les champs obligatoires du schéma deviennent des flags obligatoires, et le schéma JSON pilote l'analyse des arguments.

> 💡 **mcp2cli n'est pas un produit GitHub ni Microsoft.** C'est un outil tiers indépendant. Il communique avec un serveur MCP via le même protocole standard que Copilot CLI — MCP 2026-07-28 et 2025-11-25 — mais c'est un projet distinct, à évaluer comme n'importe quel outil tiers avant de l'installer.

### Installation

```bash
curl -fsSL https://mcp2cli.dev/install.sh | sh
```

> ⚠️ **Avant d'exécuter un script d'installation via `curl | sh`**, il est prudent d'en inspecter le contenu (`curl -fsSL https://mcp2cli.dev/install.sh | less`) plutôt que de l'exécuter les yeux fermés — une bonne pratique pour n'importe quel script tiers, pas seulement celui-ci.

Une fois installé, mcp2cli peut se connecter à un serveur MCP de deux façons : en pointant vers une URL distante (`--url`), ou en lançant un serveur local via la même commande que celle utilisée dans votre configuration Copilot (`--stdio`). C'est cette seconde option que vous utiliserez pour Context7, puisqu'il s'exécute localement via `npx`.

---

## TP : interroger Context7 sans passer par Copilot

<img src="../assets/practice.png" alt="Warm desk setup with monitor showing code, lamp, coffee cup, and headphones ready for hands-on practice" width="800"/>

Rappelez-vous la configuration du serveur Context7 vue au Chapitre 07 :

```json
{
  "mcpServers": {
    "context7": {
      "type": "local",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "tools": ["*"]
    }
  }
}
```

La commande qui démarre ce serveur est `npx -y @upstash/context7-mcp`. C'est exactement cette commande que vous allez donner à mcp2cli avec `--stdio`, pour qu'il lance le même serveur — mais en lui parlant directement, sans Copilot au milieu.

### Étape 1 : découvrir les outils exposés

```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" ls
```

Cette commande se connecte au serveur Context7, effectue la découverte MCP, et affiche la liste de ses outils. C'est l'équivalent de ce que Copilot fait silencieusement à chaque démarrage de session — sauf que là, vous le voyez.

> 💡 **Ce que vous devriez voir** : une courte liste d'outils avec leur nom et leur description (généralement un outil pour résoudre le nom d'une bibliothèque vers un identifiant Context7, et un outil pour récupérer sa documentation). Les noms exacts et leur libellé peuvent varier selon la version du serveur — fiez-vous à la sortie de `ls`, pas à ce paragraphe.

### Étape 2 : inspecter un outil

Choisissez un des outils listés à l'étape 1, et inspectez son schéma complet :

```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" inspect <nom-outil>
```

**Résultat attendu** : le schéma JSON complet de l'outil — ses paramètres, lesquels sont obligatoires, leur type. C'est l'information que mcp2cli utilise pour générer les flags de la commande d'invocation à l'étape suivante, et c'est exactement l'information que Copilot lit pour chaque outil de chaque serveur activé, à chaque session.

### Étape 3 : invoquer l'outil

En vous basant sur le schéma obtenu à l'étape 2, invoquez l'outil avec un argument réel (par exemple, le nom d'une bibliothèque que vous utilisez dans l'application de gestion de livres, comme `pytest`) :

```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" <nom-outil> --<argument> "pytest" --json
```

**Résultat attendu** : une réponse JSON brute du serveur Context7, affichée directement dans votre terminal — sans qu'aucun modèle d'IA n'ait rien lu ni reformulé.

### Étape 4 : comparer avec l'approche Copilot

Relancez la même recherche, mais cette fois via Copilot, comme au Chapitre 07 :

```bash
copilot

> What are the best practices for using pytest fixtures?
```

**Auto-vérification** : vous comprenez la différence quand vous pouvez expliquer pourquoi la réponse de Copilot est plus lisible et contextualisée, mais que l'obtenir a coûté des tokens (schéma de l'outil + résultat complet lus par le modèle), alors que la commande mcp2cli de l'étape 3 n'en a coûté aucun — au prix de devoir lire une réponse brute vous-même.

---

# Pratique

**🎉 Vous savez maintenant pourquoi MCP a un coût, et comment le contourner quand vous n'avez pas besoin d'un modèle pour interpréter la réponse.** Passons à la pratique.

## ▶️ À vous de jouer

### Exercice 1 : Vérifier l'installation

```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" ls
```

**Résultat attendu** : la commande se connecte au serveur et affiche sa liste d'outils, sans erreur.

> 💡 **Ça échoue ?** Vérifiez que le serveur Context7 fonctionne déjà avec Copilot (`/mcp show` au Chapitre 07) avant d'accuser mcp2cli — si Copilot n'arrive pas à parler à `npx -y @upstash/context7-mcp` non plus, le problème est ailleurs.

---

### Exercice 2 : Inspecter chaque outil disponible

Pour chaque outil listé à l'exercice 1, exécutez `mcp2cli --stdio "npx -y @upstash/context7-mcp" inspect <nom-outil>` et notez ses paramètres obligatoires.

**Résultat attendu** : vous savez, pour chaque outil, quels arguments lui passer sans avoir eu besoin de lire une seule ligne de documentation Context7.

---

### Exercice 3 : Récupérer de la documentation pour l'application de gestion de livres

Utilisez mcp2cli pour rechercher de la documentation sur une bibliothèque utilisée par `samples/book-app-project/` (par exemple `pytest` ou `json`), en enchaînant les outils inspectés à l'exercice 2 si plusieurs étapes sont nécessaires (résolution du nom, puis récupération de la doc).

**Résultat attendu** : une réponse JSON exploitable, obtenue sans passer par une session Copilot.

---

### Exercice 4 : Mesurer la différence par vous-même

Posez la même question à Copilot (Chapitre 07, section Context7) et comparez :

- La longueur et la lisibilité de chaque réponse
- Ce qu'il vous reste à faire dans chaque cas (copier-coller un résultat brut vs. une réponse déjà synthétisée)

**Résultat attendu** : vous pouvez formuler, dans vos propres mots, un critère pour choisir entre les deux approches selon la tâche.

---

## 📝 Devoir

### Défi principal : Construire un mini-flux de documentation avec mcp2cli

Utilisez mcp2cli pour construire, en une suite de commandes, un flux complet de recherche de documentation :

1. **Découvrez** les outils du serveur Context7 avec `ls`
2. **Inspectez** chaque outil pour connaître ses paramètres
3. **Enchaînez** les outils nécessaires pour aller d'un nom de bibliothèque à sa documentation (par exemple, si un outil résout un identifiant et qu'un autre récupère la doc, utilisez la sortie du premier comme entrée du second)
4. **Sauvegardez** le résultat JSON final dans un fichier (`> resultat.json`)
5. **Comparez** avec le même besoin résolu via Copilot, et notez par écrit (2-3 phrases) quand vous choisiriez l'une ou l'autre approche dans votre travail quotidien

**Critères de réussite** : vous obtenez une réponse JSON exploitable en local sans jamais démarrer `copilot`, et vous pouvez justifier votre choix d'approche pour une tâche donnée en termes de coût (tokens, temps) et de bénéfice (interprétation, synthèse).

<details>
<summary>💡 Indices (cliquez pour développer)</summary>

**Étape 1-2 : Découverte et inspection**
```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" ls
mcp2cli --stdio "npx -y @upstash/context7-mcp" inspect <nom-outil>
```

**Étape 3 : Enchaîner les outils**

Si le premier outil renvoie un identifiant de bibliothèque, réutilisez cet identifiant comme argument du second appel — le même principe que la synthèse manuelle que Copilot ferait pour vous automatiquement.

**Étape 4 : Sauvegarder la sortie**
```bash
mcp2cli --stdio "npx -y @upstash/context7-mcp" <nom-outil> --json > resultat.json
```

**Si mcp2cli ne se connecte pas :** vérifiez que `npx -y @upstash/context7-mcp` fonctionne seul dans votre terminal (sans mcp2cli) — un problème de connexion au serveur touche les deux outils de la même façon.

</details>

### Défi bonus : Essayer un autre serveur déjà configuré

Si vous avez configuré le serveur Filesystem au Chapitre 07, répétez l'exercice 1 avec :

```bash
mcp2cli --stdio "npx -y @modelcontextprotocol/server-filesystem ." ls
```

Comparez la liste d'outils obtenue avec celle de Context7 — chaque serveur MCP expose un jeu d'outils différent, et mcp2cli s'adapte automatiquement à chacun sans configuration supplémentaire.

---

<details>
<summary>🔧 <strong>Erreurs courantes et dépannage</strong> (cliquez pour développer)</summary>

### Erreurs courantes

| Erreur | Ce qui se passe | Correction |
|---------|--------------|-----|
| Script d'installation bloqué par une politique de sécurité | `curl \| sh` échoue ou est refusé silencieusement | Téléchargez le script (`curl -fsSL https://mcp2cli.dev/install.sh -o install.sh`), inspectez-le, puis exécutez-le manuellement (`sh install.sh`) |
| Premier démarrage lent ou en timeout | `npx` télécharge le paquet `@upstash/context7-mcp` à la première exécution | Relancez la commande ; les exécutions suivantes seront plus rapides grâce au cache npm |
| Nom d'outil incorrect dans la commande | mcp2cli renvoie une erreur du type « commande inconnue » | Relancez `mcp2cli --stdio "..." ls` pour obtenir le nom exact avant d'inspecter ou d'invoquer un outil |
| Argument obligatoire manquant | mcp2cli refuse la commande avant même de contacter le serveur | Relancez `mcp2cli --stdio "..." inspect <nom-outil>` pour voir quels flags sont obligatoires |

### Dépannage

**« La commande mcp2cli est introuvable »** - Vérifiez que le script d'installation a bien ajouté mcp2cli à votre `PATH`, puis ouvrez un nouveau terminal.

**« Le serveur ne répond pas »** - Testez la commande du serveur seule, sans mcp2cli :
```bash
npx -y @upstash/context7-mcp
```
Si elle échoue déjà à ce niveau, le problème vient de la configuration du serveur (revoyez le [Chapitre 07](../07-mcp-servers/README.md)), pas de mcp2cli.

**« Un serveur MCP distant demande une authentification »** - mcp2cli propose une sous-commande `auth` dédiée pour ce cas ; consultez `mcp2cli --stdio "..." auth --help` (Context7 n'en a pas besoin).

</details>

---

# Résumé

## 🔑 Points clés à retenir

1. **Chaque serveur MCP connecté a un coût en tokens** : les schémas de ses outils occupent la fenêtre de contexte, et chaque résultat renvoyé transite par le modèle
2. **Vous connaissiez déjà deux leviers** pour réduire ce coût : limiter `"tools"` dans la configuration plutôt que `["*"]`, et `/mcp disable` un serveur inutilisé
3. **mcp2cli transforme un serveur MCP en CLI native** : il parle le même protocole MCP que Copilot, mais sans modèle d'IA au milieu
4. **`--stdio` lance un serveur local** avec la même commande que celle de votre configuration Copilot (`npx ...`) ; `--url` cible un serveur distant
5. **`ls`, `inspect` et l'invocation directe** couvrent tout le flux découverte → schéma → appel, sans jamais démarrer `copilot`
6. **Ce n'est pas un remplacement de Copilot** : mcp2cli convient aux requêtes ciblées et répétées ; Copilot reste préférable dès qu'il faut interpréter, enchaîner ou synthétiser

> 📋 **Référence rapide** : [Documentation mcp2cli](https://mcp2cli.dev/docs) pour la liste complète des sous-commandes et options ; [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) pour revoir la configuration des serveurs.

---

## ➡️ Et ensuite

Ce chapitre bonus clôt le parcours du cours. Vous savez maintenant configurer des serveurs MCP, les utiliser depuis Copilot, et sortir le modèle de l'équation avec mcp2cli quand c'est plus efficace de le faire.

### Ressources

- [mcp2cli.dev](https://mcp2cli.dev/) — site officiel et documentation
- [Spécification MCP](https://modelcontextprotocol.io/specification/2025-11-25)
- [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) — pour revoir la configuration des serveurs

---

**[← Chapitre précédent : Sessions parallèles avec les worktrees Git](../16-parallel-worktrees/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
