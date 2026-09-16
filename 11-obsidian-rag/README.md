<!--
---
id: CopilotCLI-11
title: !translate Construire un pipeline RAG sur votre vault Obsidian
description: !translate Connectez Copilot CLI à vos notes Obsidian via deux serveurs MCP complémentaires pour poser des questions ancrées dans votre propre base de connaissances, avec une vraie recherche sémantique.
audience: Developers / Students / Terminal users
slug: rag-over-your-obsidian-vault
weight: 12
---
-->

![Chapitre 11 : RAG Obsidian](assets/chapter-header.png)

> **Et si Copilot CLI pouvait répondre à vos questions en s'appuyant sur *vos propres notes*, plutôt que sur sa seule connaissance générale ?**

Jusqu'ici, Copilot CLI a répondu à partir de ce qu'il sait déjà, ou de ce qu'il trouve dans les fichiers de votre dépôt. Ce chapitre bonus lui donne accès à une troisième source : votre coffre (« vault ») **Obsidian**, votre base de notes personnelles. Vous allez mettre en place un vrai pipeline de **RAG** (*Retrieval-Augmented Generation*, génération augmentée par la recherche) : Copilot CLI recherche d'abord les notes pertinentes par similarité de sens, lit leur contenu complet, puis répond en citant ses sources — au lieu de deviner.

Ce chapitre s'appuie directement sur les **serveurs MCP** (Chapitre 07) : vous allez en connecter deux, chacun avec un rôle distinct, pour reproduire les trois étapes du RAG (retrieval, augmentation, génération). Si le Chapitre 07 vous semble flou, c'est le bon moment d'y jeter un œil rapide avant de continuer.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Expliquer les trois étapes d'un pipeline RAG (retrieval, augmentation, génération) avec vos propres mots
- Connecter Copilot CLI à votre vault Obsidian via deux serveurs MCP complémentaires
- Distinguer une recherche littérale (mots-clés) d'une recherche sémantique (par similarité de sens)
- Poser à Copilot CLI une question de synthèse qui nécessite plusieurs notes, et vérifier ses citations
- Diagnostiquer les problèmes de connexion et d'indexation les plus courants

> ⏱️ **Durée estimée : ~55 minutes** (20 min de lecture + 35 min de pratique, installation des plugins Obsidian comprise)

---

## ✅ Prérequis

- Avoir terminé le [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) — ce chapitre réutilise le vocabulaire `mcp-config.json`, `/mcp show` et `/mcp config` sans les réexpliquer
- ⚠️ **Obsidian installé, avec un vault existant contenant déjà quelques notes** — c'est le seul prérequis de ce cours qui exige un outil en dehors de GitHub Copilot CLI lui-même ; ce chapitre est optionnel précisément pour cette raison
- ⚠️ Les plugins communautaires Obsidian **Local REST API** et **Smart Connections** installés, activés, et votre vault déjà indexé par Smart Connections (voir la première section pour la marche à suivre)
- Node.js (déjà nécessaire depuis le Chapitre 01, pour `npx`)

---

## 🧩 Analogie du monde réel

<img src="assets/obsidian-rag-analogy.png" alt="Un chercheur consultant un fichier classé par thème plutôt que de fouiller une pile de documents au hasard" width="800"/>

| Concept | Copilot CLI seul | Copilot CLI + RAG Obsidian |
|---|---|---|
| D'où vient la réponse | La connaissance générale du modèle | Le contenu réel de vos notes |
| Comment il trouve l'information | Il ne la trouve pas : il la déduit ou la devine | Il recherche par sens, pas seulement par mot-clé exact |
| Comment vous vérifiez | Vous ne pouvez pas remonter à une source | Il cite les notes utilisées : vous pouvez les rouvrir |
| Ce qui se passe si vous ajoutez une note | Rien : le modèle ne la connaît toujours pas | Elle devient consultable dès qu'elle est indexée |

Pensez à un chercheur qui, plutôt que de répondre de mémoire ou de fouiller une pile de documents page par page, consulte un fichier déjà classé par thème : il retrouve directement les bons dossiers, les lit, puis rédige sa réponse en citant ses sources.

---

## Je veux... | Aller à...

| Je veux... | Aller à |
|---|---|
| Installer et indexer les plugins Obsidian | [Préparer votre vault](#préparer-votre-vault) |
| Connecter Copilot CLI à Obsidian | [Connecter Copilot CLI aux deux serveurs MCP](#connecter-copilot-cli-aux-deux-serveurs-mcp) |
| Poser une vraie question RAG | [Poser votre première question RAG](#poser-votre-première-question-rag) |
| Dépanner une connexion | [Erreurs courantes et dépannage](#-erreurs-courantes-et-dépannage) |

---

## Préparer votre vault

<a id="préparer-votre-vault"></a>

Deux plugins communautaires Obsidian jouent chacun un rôle différent dans ce pipeline RAG :

- **[Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api)** : expose votre vault (lecture, écriture, recherche littérale) à un client MCP. C'est la couche « accès au vault ».
- **[Smart Connections](https://github.com/brianpetro/obsidian-smart-connections)** : génère des embeddings locaux (aucune clé API, aucune donnée envoyée à l'extérieur) pour permettre une recherche **par sens** plutôt que par mot-clé exact. C'est la couche « recherche sémantique ».

Dans Obsidian, ouvrez **Settings → Community plugins → Browse**, cherchez puis installez les deux plugins, et activez-les.

> ⚠️ **Laissez Smart Connections terminer son indexation avant de continuer.** À la première activation, il génère les embeddings de toutes vos notes en arrière-plan — une barre de progression s'affiche dans les réglages du plugin. Sur un vault de quelques centaines de notes, comptez quelques minutes.

### Récupérer votre clé API

Ouvrez **Settings → Local REST API** : votre clé API s'affiche en haut de ce panneau, avec un bouton de copie à côté. Notez également le port utilisé — par défaut `27123` en HTTP ou `27124` en HTTPS (certificat auto-signé). Pour ce chapitre, activez l'option HTTP dans les réglages du plugin : cela évite d'avoir à faire confiance manuellement à un certificat auto-signé pour un usage local.

---

## Connecter Copilot CLI aux deux serveurs MCP

<a id="connecter-copilot-cli-aux-deux-serveurs-mcp"></a>

Comme vu au Chapitre 07, un serveur MCP distant se configure avec une URL, et un serveur MCP local se lance via une commande. Ici, vous avez besoin des deux à la fois. Ajoutez ceci à votre `.mcp.json` (à la racine du projet) ou à votre `~/.copilot/mcp-config.json` :

```json
{
  "mcpServers": {
    "obsidian": {
      "type": "http",
      "url": "http://127.0.0.1:27123/mcp/",
      "headers": {
        "Authorization": "Bearer <votre-clé-api-local-rest-api>"
      }
    },
    "smart-connections": {
      "type": "local",
      "command": "npx",
      "args": ["-y", "smart-connections-mcp"],
      "env": {
        "SMART_VAULT_PATH": "/chemin/absolu/vers/votre/vault"
      }
    }
  }
}
```

Remplacez `<votre-clé-api-local-rest-api>` par la clé copiée à l'étape précédente, et `/chemin/absolu/vers/votre/vault` par le chemin réel de votre vault sur disque (plusieurs vaults peuvent être séparés par des virgules).

Vérifiez ensuite la connexion :

```bash
copilot

> /mcp config
```

Sélectionnez chaque serveur pour finaliser sa configuration, puis vérifiez avec `/mcp show` : `obsidian` et `smart-connections` doivent tous les deux apparaître comme activés.

> 💡 **`obsidian` répond mais `smart-connections` échoue au démarrage ?** Vérifiez que `SMART_VAULT_PATH` pointe bien vers le dossier racine de votre vault (celui qui contient le dossier `.obsidian`), avec un chemin absolu.

---

## Poser votre première question RAG

<a id="poser-votre-première-question-rag"></a>

Posez une question dont la réponse est dispersée entre plusieurs notes de votre vault — pas une seule note isolée, mais une vraie synthèse :

```bash
copilot

> D'après mes notes, fais-moi une synthèse de ce que je sais sur <un sujet
> présent dans plusieurs de vos notes>. Utilise la recherche sémantique pour
> trouver les notes pertinentes, lis leur contenu complet, puis cite le titre
> de chaque note que tu as utilisée dans ta réponse.
```

Copilot CLI va typiquement : appeler `search_notes` (serveur `smart-connections`) pour retrouver les notes pertinentes par similarité de sens, puis `vault_read` (serveur `obsidian`) pour en lire le contenu complet, avant de rédiger une réponse qui cite ses sources.

<details>
<summary>🎬 Voyez-le en action !</summary>

![Démo : question RAG sur un vault Obsidian avec Copilot CLI](assets/obsidian-rag-demo.gif)

*Le résultat peut varier selon votre modèle, vos outils et votre contexte : ne soyez pas surpris si votre sortie diffère de celle présentée ici — les notes retrouvées et leur ordre de citation dépendent entièrement du contenu de votre propre vault.*

</details>

Ouvrez ensuite les notes citées dans Obsidian : vérifiez qu'elles contiennent bien l'information utilisée dans la réponse. C'est le même réflexe de relecture qu'avec du code généré par IA — ne faites jamais confiance à une citation sans la vérifier au moins une fois.

---

## Pratique

### ▶️ À vous de jouer

1. Reformulez votre question pour forcer Copilot CLI à citer au moins trois notes différentes
2. Ajoutez une nouvelle note à votre vault, attendez que Smart Connections l'indexe (ou déclenchez une réindexation manuelle depuis ses réglages), puis reposez une question qui devrait maintenant l'inclure
3. Demandez à Copilot CLI d'écrire une note de synthèse *dans votre vault* (via `vault_write`), avec des liens `[[wikilink]]` vers chacune des notes sources qu'il a utilisées

---

## 📝 Devoir

**Défi principal** : posez une question dont la réponse nécessite de synthétiser au moins trois notes de votre vault, et vérifiez une par une que chaque citation renvoie bien à une note pertinente.

**Défi bonus** : ajoutez un second chemin de vault à `SMART_VAULT_PATH` (séparé par une virgule) et posez une question qui ne peut être répondue qu'en croisant une information présente dans chacun des deux vaults.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, choisissez un sujet que vous avez noté à plusieurs reprises, à des dates différentes ou sous des angles différents — c'est ce genre de sujet qui révèle le mieux l'intérêt de la synthèse
- Pour le défi bonus, demandez explicitement à Copilot CLI de préciser de quel vault provient chaque note citée

</details>

---

## 🔧 Erreurs courantes et dépannage

<details>
<summary>Cliquez pour voir les problèmes fréquents et leurs solutions</summary>

| Erreur | Ce qui se passe | Solution |
|---|---|---|
| `obsidian` absent de `/mcp show` | Le plugin Local REST API n'est pas activé, ou l'URL/le port est incorrect | Vérifiez Settings → Local REST API dans Obsidian, confirmez le port (27123 en HTTP), redémarrez Copilot CLI |
| Erreur `401 Unauthorized` sur le serveur `obsidian` | La clé API est absente ou incorrecte dans le header `Authorization` | Recopiez la clé depuis Settings → Local REST API, sans espace superflu |
| Erreur de certificat sur le port 27124 | Vous utilisez l'URL HTTPS, qui repose sur un certificat auto-signé | Passez à l'URL HTTP sur le port 27123 (à activer dans les réglages du plugin), ou acceptez explicitement le certificat |
| `smart-connections` absent de `/mcp show` ou plante au démarrage | `SMART_VAULT_PATH` pointe vers un chemin incorrect | Vérifiez que le chemin est absolu et pointe vers le dossier qui contient `.obsidian` |
| La recherche renvoie `"mode": "keyword"` au lieu de `"mode": "semantic"` | Smart Connections n'a pas encore terminé (ou pas commencé) l'indexation de vos notes | Ouvrez Obsidian, attendez la fin de la barre de progression d'indexation dans les réglages du plugin, puis réessayez |
| Une note récente n'apparaît jamais dans les réponses | Elle n'a pas encore été indexée par Smart Connections | Attendez la réindexation automatique, ou déclenchez-en une manuellement depuis les réglages du plugin |

</details>

---

## Résumé

Vous avez connecté Copilot CLI à votre vault Obsidian via deux serveurs MCP complémentaires — l'un pour la recherche sémantique, l'autre pour l'accès au contenu — et obtenu des réponses ancrées dans vos propres notes, citations à l'appui.

### 🔑 Points clés à retenir

1. Un pipeline RAG combine trois étapes : **retrieval** (retrouver les bonnes notes), **augmentation** (leur contenu complet devient du contexte), **génération** (la réponse s'appuie dessus)
2. La recherche sémantique (par sens) et la recherche littérale (par mot-clé) sont complémentaires : la première trouve des notes que la seconde raterait
3. Deux serveurs MCP peuvent jouer des rôles différents et complémentaires dans un même pipeline, exactement comme vous connecteriez plusieurs outils à un même flux de travail
4. Vérifiez toujours les citations d'une réponse RAG en rouvrant les notes sources, exactement comme vous relisez du code généré

---

## 📋 Référence rapide

- [Exemple de config MCP pour ce chapitre](../samples/mcp-configs/obsidian-rag-mcp-config.json) — à copier-coller dans votre `.mcp.json`
- [obsidian-local-rest-api](https://github.com/coddingtonbear/obsidian-local-rest-api) — plugin d'accès au vault
- [obsidian-smart-connections](https://github.com/brianpetro/obsidian-smart-connections) — plugin d'embeddings locaux
- [smart-connections-mcp](https://github.com/msdanyg/smart-connections-mcp) — serveur MCP de recherche sémantique
- [Chapitre 07 : Serveurs MCP](../07-mcp-servers/README.md) — pour approfondir la configuration MCP

---

## ➡️ Et ensuite ?

Vous avez maintenant vu Copilot CLI puiser dans trois sources différentes au fil de ce cours : sa connaissance générale, les fichiers de votre dépôt, et vos notes personnelles. Le principe reste le même partout — plus la source est vérifiable, plus vous pouvez faire confiance à la réponse.

**[← Chapitre précédent : Environnements isolés](../10-isolated-environments/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
