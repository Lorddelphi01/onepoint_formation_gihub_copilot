<!--
---
id: CopilotCLI-12
title: !translate Analyser sa consommation de tokens avec RTK et Tokscale
description: !translate Installez RTK pour réduire automatiquement la sortie de vos commandes, et Tokscale pour mesurer précisément votre consommation de tokens Copilot CLI dans la durée.
audience: Developers / Students / Terminal users
slug: analyze-token-consumption
weight: 13
---
-->

![Chapitre 12 : Analyser sa consommation de tokens](assets/chapter-header.png)

> **Et si vous pouviez voir, en une commande, combien de tokens vos `git status` et `npm test` ont fait consommer à Copilot CLI cette semaine — et réduire ce chiffre de 90 % ?**

Au [Chapitre 11](../11-chronicle-session-insights/README.md), `/chronicle cost-tips` vous a donné un premier aperçu de vos habitudes de consommation de tokens. Ce chapitre bonus va plus loin avec deux outils tiers complémentaires : **RTK**, qui réduit la sortie de vos commandes *à la source*, et **Tokscale**, qui mesure et visualise votre consommation *après coup*. Aucun des deux n'est un produit GitHub — ce sont des outils open source de la communauté, à installer séparément.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Expliquer la différence entre réduire la consommation de tokens à la source (RTK) et la mesurer a posteriori (Tokscale)
- Installer RTK et le connecter à Copilot CLI
- Lire un rapport `rtk gain` et l'interpréter correctement
- Activer l'export OpenTelemetry local de Copilot CLI
- Installer Tokscale et lire un rapport de consommation par session

> ⏱️ **Durée estimée : ~40 minutes** (10 min de lecture + 30 min de pratique, installation de deux outils tiers comprise)

---

## ✅ Prérequis

- Avoir terminé le [Chapitre 11 : Explorer l'historique de vos sessions avec /chronicle](../11-chronicle-session-insights/README.md), en particulier la sous-commande `/chronicle cost-tips`
- Connaître la notion de [Token](../GLOSSARY.md#token), présentée dès le début de ce cours
- ⚠️ Ce chapitre installe deux outils **tiers**, non maintenus par GitHub : [RTK](https://github.com/rtk-ai/rtk) et [Tokscale](https://github.com/junhoyeo/tokscale). Comme pour le Chapitre 09 (n8n), lisez le code avant de l'exécuter, comme pour tout outil externe
- Un terminal avec accès réseau pour l'installation (`curl`, `npx`, ou votre gestionnaire de paquets)

---

## 🧩 Analogie du monde réel

<img src="assets/token-tools-analogy.png" alt="D'un côté un compteur électrique qui affiche une consommation, de l'autre une ampoule basse consommation qui réduit cette consommation à la source" width="800"/>

| Concept | RTK | Tokscale |
|---|---|---|
| Rôle | Réduit la consommation **à la source** | Mesure et visualise la consommation **a posteriori** |
| Comment | Intercepte des commandes verbeuses (git, npm, cargo...) et en compresse la sortie avant qu'elle n'atteigne le modèle | Lit les journaux d'usage déjà produits par Copilot CLI (export OpenTelemetry) |
| Résultat | Moins de tokens envoyés au modèle dès la prochaine commande | Un tableau de bord de ce qui a été consommé, session par session |
| Analogie | Une ampoule basse consommation : elle change ce qui est produit | Un compteur électrique : il mesure ce qui a été produit, sans le changer |

Les deux outils ne sont pas concurrents : RTK agit en amont (moins de bruit envoyé), Tokscale observe en aval (comprendre où va votre budget de tokens). Utilisés ensemble, ils forment une boucle complète : mesurer, comprendre, réduire, remesurer.

---

## Je veux... | Aller à...

| Je veux... | Aller à |
|---|---|
| Réduire la sortie de mes commandes | [RTK — réduire la consommation à la source](#rtk-réduire-la-consommation-à-la-source) |
| Voir mes économies de tokens | [Lire un rapport rtk gain](#lire-un-rapport-rtk-gain) |
| Activer l'export de données Copilot CLI | [Activer l'export OpenTelemetry de Copilot CLI](#activer-lexport-opentelemetry-de-copilot-cli) |
| Visualiser ma consommation dans le temps | [Tokscale — mesurer la consommation après coup](#tokscale-mesurer-la-consommation-après-coup) |

---

## RTK — réduire la consommation à la source

<a id="rtk-réduire-la-consommation-à-la-source"></a>

[RTK](https://github.com/rtk-ai/rtk) (« Rust Token Killer ») est un proxy CLI écrit en Rust qui s'intercale entre Copilot CLI et plus d'une centaine de commandes de développement courantes (git, npm, cargo, pytest, docker, kubectl...). Il exécute la commande réelle, puis renvoie à l'agent une version compressée de sa sortie — sans changer le résultat, seulement son volume.

### Installer RTK

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh

# Alternative : via Homebrew
brew install rtk

# Alternative : via Cargo (toute plateforme)
cargo install --git https://github.com/rtk-ai/rtk

# Windows : winget install rtk-ai.rtk
```

Vérifiez l'installation :

```bash
rtk --version
which rtk
```

> ⚠️ **Collision de nom possible** : si `rtk --version` échoue ou affiche un comportement inattendu, un autre paquet nommé `rtk` (par exemple « Rust Type Kit ») pourrait déjà occuper ce nom sur votre système. Vérifiez la sortie de `which rtk` pour confirmer que le binaire pointe bien vers `rtk-ai/rtk`.

### Connecter RTK à Copilot CLI

RTK propose une commande d'installation automatique qui met en place un hook de réécriture transparente des commandes :

```bash
rtk init -g
```

Redémarrez ensuite votre session Copilot CLI. Vos commandes verbeuses (`git status`, `npm test`...) sont désormais automatiquement préfixées par `rtk` sans que vous ayez besoin d'y penser.

> 💡 **Méthode alternative sans hook** : le projet [rtk-for-copilot](https://github.com/Martin-Sciarrillo/rtk-for-copilot) propose une approche plus simple mais manuelle : copier un fichier `copilot-instructions.md` tout fait dans `~/.copilot/copilot-instructions.md` (ou l'ajouter au vôtre s'il existe déjà, voir [Chapitre 05](../05-agents-custom-instructions/README.md)). Ce fichier contient des instructions en langage naturel qui indiquent à Copilot CLI de préfixer lui-même les commandes concernées par `rtk` — aucun hook, aucune extension.

---

## Lire un rapport `rtk gain`

<a id="lire-un-rapport-rtk-gain"></a>

Après quelques commandes exécutées via RTK, consultez vos économies :

```bash
rtk gain
# Tableau de bord récapitulatif des économies de tokens accumulées

rtk gain --history
# Historique récent des commandes exécutées, avec leurs statistiques de compression

rtk gain --graph
# Visualisation ASCII des économies dans le temps

rtk discover
# Repère les commandes fréquentes que vous n'avez pas encore optimisées avec RTK

rtk proxy <commande>
# Exécute n'importe quelle commande en passthrough brut, tout en suivant ses statistiques
```

Exemple d'ordre de grandeur documenté par le projet RTK lui-même :

| Commande | Sans RTK | Avec RTK | Économie |
|---|---|---|---|
| `git status` | 529 caractères | 40 caractères | 92 % |
| `git log -5` | 2 400 caractères | 800 caractères | 67 % |
| `cargo test` | ~5 000 caractères | ~500 caractères | 90 % |

> 💡 **Ce que `rtk gain` mesure réellement** : la documentation de RTK est explicite sur ce point — ces chiffres mesurent la réduction de la **sortie de commandes bash**, pas directement votre facture finale. Cette sortie n'est qu'une partie des tokens d'entrée consommés par une session, qui elle-même n'est qu'une partie de la facture (qui compte aussi les tokens de sortie générés par le modèle). Utilisez `rtk gain` comme un indicateur de tendance, pas comme une facture exacte.

<details>
<summary>🎬 Voyez-le en action !</summary>

![Démo : rtk gain après plusieurs commandes git dans le projet du cours](assets/rtk-gain-demo.gif)

*Le résultat peut varier selon votre modèle, vos outils et votre contexte : ne soyez pas surpris si votre sortie diffère de celle présentée ici — les pourcentages d'économie dépendent directement des commandes que vous avez exécutées.*

</details>

---

## Activer l'export OpenTelemetry de Copilot CLI

<a id="activer-lexport-opentelemetry-de-copilot-cli"></a>

Tokscale ne se connecte pas directement à Copilot CLI : il lit des journaux déjà produits. Pour que Copilot CLI produise ces journaux localement, activez son export [OpenTelemetry](../GLOSSARY.md#opentelemetry-otel) (OTel), désactivé par défaut :

```bash
export COPILOT_OTEL_ENABLED=true
export COPILOT_OTEL_EXPORTER_TYPE=file
export COPILOT_OTEL_FILE_EXPORTER_PATH="$HOME/.copilot/otel/copilot-otel-$(date +%Y%m%d-%H%M%S).jsonl"
```

Lancez une session Copilot CLI et travaillez normalement : chaque appel modèle, exécution d'outil et compte de tokens est ajouté au fichier `.jsonl` indiqué.

> 💡 **Pourquoi le type `file` plutôt que `otlp`** : Copilot CLI peut aussi exporter vers un collecteur OpenTelemetry distant (`COPILOT_OTEL_EXPORTER_TYPE=otlp-http` + `OTEL_EXPORTER_OTLP_ENDPOINT`), utile en entreprise avec une stack d'observabilité déjà en place. Pour un usage personnel avec Tokscale, l'export fichier local ne demande aucune infrastructure.

---

## Tokscale — mesurer la consommation après coup

<a id="tokscale-mesurer-la-consommation-après-coup"></a>

[Tokscale](https://github.com/junhoyeo/tokscale) est un CLI/TUI open source qui agrège les journaux d'usage produits par une quarantaine d'agents IA, dont Copilot CLI, pour estimer coûts et consommation de tokens dans une interface terminal interactive.

Aucune installation globale n'est nécessaire :

```bash
npx tokscale@latest
# Lance l'interface TUI interactive

npx tokscale@latest --light
# Sortie en tableau simple, sans interface interactive

npx tokscale@latest models
# Répartition de la consommation par modèle

npx tokscale@latest --json
# Export JSON, utile pour scripter vos propres rapports
```

Une fois lancé, Tokscale doit détecter au moins une session Copilot CLI grâce au fichier `.jsonl` produit à l'étape précédente, avec une estimation de tokens et de coût associée.

> ⚠️ **Tokscale n'est ni un serveur MCP, ni un mécanisme de facturation officiel de GitHub.** Ses estimations de coût s'appuient sur des tables de prix tierces (LiteLLM) : utilisez-les comme un ordre de grandeur, pas comme une facture garantie exacte.

---

## Comparatif : quel outil pour quel besoin

| | `/chronicle cost-tips` | RTK | Tokscale |
|---|---|---|---|
| Portée | Une session à la fois, sur demande | Toute commande passée par le proxy | Toutes les sessions exportées en OTel |
| Ce que ça fait | Suggère des pistes en langage naturel | Réduit la sortie envoyée au modèle | Visualise la consommation dans le temps |
| Agit sur | Vos habitudes de prompt | Le volume de sortie des commandes | Rien — mesure seulement |
| Prérequis | Aucun (natif Copilot CLI) | Installation de RTK | Export OTel activé |

---

## Pratique

Activez l'export OTel (étape ci-dessus), puis effectuez trois interactions différentes avec Copilot CLI dans le projet du cours (une question simple, une lecture de fichier, une commande git via RTK).

### ▶️ À vous de jouer

1. Comparez la sortie de `git status` exécutée directement, puis via `rtk proxy git status` — notez la différence de volume
2. Lancez `rtk gain` et vérifiez qu'il liste bien vos commandes récentes
3. Lancez `npx tokscale@latest --light` et vérifiez qu'il affiche au moins une session Copilot CLI

---

## 📝 Devoir

**Défi principal** : installez RTK, puis comparez la sortie de `git log -10` et `npm test` (ou `python -m pytest tests/` dans `samples/book-app-project/`) avec et sans RTK. Notez les pourcentages de réduction obtenus.

**Défi bonus** : configurez l'export OTel et Tokscale, effectuez deux sessions Copilot CLI distinctes sur des tâches différentes, puis comparez leur coût estimé dans `tokscale --light`.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, `rtk proxy <commande>` force le passage par RTK même si le hook automatique n'est pas encore actif
- Pour le défi bonus, nommez vos sessions avec `--name` (vu au Chapitre 03) pour les retrouver facilement dans Tokscale

</details>

---

## 🔧 Erreurs courantes et dépannage

<details>
<summary>Cliquez pour voir les problèmes fréquents et leurs solutions</summary>

| Erreur | Ce qui se passe | Solution |
|---|---|---|
| `rtk gain` affiche « command not found » | Un autre paquet nommé `rtk` est installé, ou le binaire n'est pas dans le `PATH` | Vérifiez `which rtk` ; désinstallez l'autre paquet ou utilisez le chemin complet du binaire RTK |
| Les commandes ne sont pas automatiquement préfixées par `rtk` après `rtk init -g` | La session Copilot CLI en cours a démarré avant l'installation du hook | Fermez et redémarrez complètement Copilot CLI |
| Tokscale affiche 0 message pour Copilot CLI | Aucun fichier n'existe encore dans le chemin indiqué par `COPILOT_OTEL_FILE_EXPORTER_PATH` | Vérifiez que `COPILOT_OTEL_ENABLED=true` était bien exporté *avant* de lancer `copilot`, puis `ls ~/.copilot/otel/` |
| `rtk gain` affiche des économies très faibles malgré RTK actif | Les commandes exécutées produisent naturellement peu de sortie (elles n'ont donc pas besoin de compression) | Normal : essayez sur une commande volontairement verbeuse (`git log`, une suite de tests complète) pour voir l'effet |

</details>

---

## Résumé

Vous disposez maintenant de deux outils complémentaires pour piloter votre consommation de tokens dans la durée : RTK pour réduire le bruit envoyé au modèle à la source, et Tokscale pour mesurer précisément ce qui a été consommé, session après session.

### 🔑 Points clés à retenir

1. RTK et Tokscale sont des outils **tiers**, non maintenus par GitHub, à installer et connecter séparément
2. RTK agit **avant** l'envoi au modèle (compression de la sortie de commandes) ; Tokscale mesure **après coup** (lecture de journaux déjà produits)
3. `rtk gain` mesure la réduction de la sortie bash, pas directement votre facture finale — à interpréter comme une tendance
4. Tokscale dépend de l'export OpenTelemetry local de Copilot CLI (`COPILOT_OTEL_ENABLED`, `COPILOT_OTEL_EXPORTER_TYPE`, `COPILOT_OTEL_FILE_EXPORTER_PATH`), désactivé par défaut
5. `/chronicle cost-tips` (Chapitre 11), RTK et Tokscale se complètent : conseils en langage naturel, réduction automatique, mesure précise

---

## 📋 Référence rapide

- [github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk) — dépôt officiel de RTK
- [github.com/Martin-Sciarrillo/rtk-for-copilot](https://github.com/Martin-Sciarrillo/rtk-for-copilot) — intégration RTK ↔ Copilot CLI via `copilot-instructions.md`
- [github.com/junhoyeo/tokscale](https://github.com/junhoyeo/tokscale) — dépôt officiel de Tokscale
- [Chapitre 11 : /chronicle](../11-chronicle-session-insights/README.md) — pour `/chronicle cost-tips`, le premier niveau d'analyse, natif à Copilot CLI

---

## ➡️ Et ensuite ?

Vous avez maintenant les outils natifs (`/chronicle`) et tiers (RTK, Tokscale) pour comprendre et réduire votre consommation de tokens sur la durée — la même discipline de relecture et d'amélioration continue que vous appliquez déjà à votre code avec Copilot CLI.

**[← Chapitre précédent : Explorer l'historique de vos sessions avec /chronicle](../11-chronicle-session-insights/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
