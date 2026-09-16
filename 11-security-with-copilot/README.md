<!--
---
id: CopilotCLI-11
title: !translate Sécuriser votre code avec Copilot CLI
description: !translate Utilisez la revue de sécurité dédiée de Copilot CLI, protégez vos secrets avec les exclusions de contenu, et entraînez-vous à détecter de vraies vulnérabilités dans du code volontairement vulnérable.
audience: Developers / Students / Terminal users
slug: security-with-copilot
weight: 12
---
-->

![Chapitre 11 : Sécurité](assets/chapter-header.png)

> **Et si Copilot CLI pouvait repérer une faille de sécurité dans votre code avant même que vous ne la commitiez ?**

Depuis le Chapitre 04, vous avez déjà croisé la sécurité à plusieurs reprises : un aparté sur l'audit d'un fichier bugué (Chapitre 04), un skill `security-audit` maison basé sur le Top 10 OWASP (Chapitre 06), et un hook de pre-commit qui lance une revue automatique avant chaque commit (Chapitre 08). Ce chapitre rassemble ces briques et ajoute la pièce qui manquait : la commande **`/security-review`**, une revue de sécurité native de Copilot CLI, conçue spécifiquement pour scanner vos changements avant qu'ils ne partent en revue de code humaine.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Activer et utiliser la commande `/security-review` pour scanner vos changements locaux
- Distinguer les catégories de vulnérabilités couvertes par cette revue, et celles qui ne le sont pas
- Écrire des instructions personnalisées qui orientent Copilot vers des pratiques de code sécurisées par défaut
- Protéger vos secrets avec les exclusions de contenu, et connaître leurs limites
- Adopter les réflexes de prudence nécessaires face aux risques d'exécution de commandes non supervisées
- Mener un audit de sécurité complet sur du code volontairement vulnérable

> ⏱️ **Durée estimée : ~40 minutes** (15 min de lecture + 25 min de pratique)

---

## ✅ Prérequis

- Avoir terminé le [Chapitre 04 : Flux de travail de développement](../04-development-workflows/README.md) — ce chapitre réutilise le réflexe de revue de code établi là-bas
- Avoir terminé le [Chapitre 06 : Automatiser les tâches répétitives](../06-skills/README.md) — pour comparer la commande native `/security-review` à un skill `security-audit` personnalisé
- ⚠️ **Copilot CLI dans une version récente, avec le mode expérimental activé** — `/security-review` est une fonctionnalité en préversion publique (voir la section [Comprendre les limites et les risques](#comprendre-les-limites-et-les-risques)) ; si la commande n'apparaît pas, mettez à jour Copilot CLI et consultez `copilot --help` ou la documentation officielle pour la syntaxe d'activation propre à votre version
- Un dépôt avec des changements locaux (fichiers modifiés ou stagés) à scanner — un diff vide n'a rien à analyser

---

## 🧩 Analogie du monde réel

<img src="assets/security-checkpoint-analogy.png" alt="Un poste de contrôle rapide à l'entrée d'un bâtiment, avec en arrière-plan un service de douane qui inspecte en profondeur" width="800"/>

| Concept | `/security-review` (Copilot CLI) | Code Scanning / Dependabot / Snyk |
|---|---|---|
| Ce qu'il regarde | Votre diff local, avant commit | L'historique complet du dépôt, les dépendances publiées |
| Vitesse | Quelques secondes, dans le terminal | Minutes, en CI/CD |
| Ce qu'il détecte | Des failles de code (injection, XSS, secrets en dur, etc.) | Des CVE connues, des chaînes de dépendances vulnérables, des flux de données inter-fichiers |
| Quand l'utiliser | Avant de committer, en continu pendant que vous codez | En CI/CD, sur chaque pull request, en continu sur les dépendances |

Pensez à `/security-review` comme au vigile qui contrôle rapidement votre sac à l'entrée d'un bâtiment : utile et immédiat, mais il ne remplace pas le service douanier qui inspecte en profondeur (Code Scanning avec CodeQL, Dependabot, Snyk) — les deux se complètent, ils n'interviennent pas au même moment ni sur le même périmètre.

---

## Je veux... | Aller à...

| Je veux... | Aller à |
|---|---|
| Scanner mes changements avant de commit | [Lancer une revue avec /security-review](#lancer-une-revue-avec-security-review) |
| Définir des règles de sécurité par défaut | [Écrire des instructions de sécurité par défaut](#écrire-des-instructions-de-sécurité-par-défaut) |
| Empêcher Copilot de voir mes secrets | [Protéger vos secrets](#protéger-vos-secrets) |
| Comprendre les limites et les risques | [Comprendre les limites et les risques](#comprendre-les-limites-et-les-risques) |

---

## Lancer une revue avec /security-review

<a id="lancer-une-revue-avec-security-review"></a>

Une fois le mode expérimental activé, lancez la commande depuis n'importe quel projet contenant des changements locaux :

```bash
copilot

> /security-review
```

Copilot CLI analyse alors le même diff que celui que vous vous apprêteriez à committer, et renvoie une liste de failles classées par **sévérité** (Critique/Élevée/Moyenne/Faible) et par **niveau de confiance**, chacune accompagnée d'une explication et d'une correction suggérée que vous pouvez appliquer sans quitter le terminal.

Les catégories couvertes sont larges :

| Catégorie | Exemple typique |
|---|---|
| Injection (SQL, commande shell, etc.) | Entrée utilisateur concaténée directement dans une requête ou une commande |
| Cross-Site Scripting (XSS) | Contenu utilisateur affiché sans échappement |
| Contrôle d'accès défaillant / traversée de chemin | Vérification d'autorisation manquante, `../` non filtré dans un chemin de fichier |
| SSRF (Server-Side Request Forgery) | Requête sortante construite à partir d'une entrée utilisateur non validée |
| Désérialisation non sécurisée / pollution de prototype | `pickle.loads()` sur des données non fiables, fusion d'objets non contrôlée |
| Cryptographie faible | MD5/SHA1 pour des mots de passe, générateur aléatoire non sécurisé |
| Secrets en dur | Clés API ou mots de passe écrits directement dans le code source |
| Fuite de données sensibles | Mots de passe ou numéros de carte écrits dans les logs |
| Authentification / CORS défaillants | Sessions mal invalidées, en-tête `Access-Control-Allow-Origin` trop permissif |
| Mauvaise configuration de sécurité | Dépendances non figées à une version précise (risque de chaîne d'approvisionnement) |
| Injection de prompt inter-agents (XPIA) | Contenu non fiable qui s'injecte dans un prompt destiné à une IA |

> 💡 **Cette commande ne remplace pas une analyse de vulnérabilités connues (CVE) ni un audit de dépendances.** Elle se concentre sur des schémas de code à risque, pas sur des correspondances avec des bases de CVE ou une analyse de flux de données inter-fichiers approfondie (« taint analysis »). Détail complet dans [Comprendre les limites et les risques](#comprendre-les-limites-et-les-risques).

---

## Écrire des instructions de sécurité par défaut

<a id="écrire-des-instructions-de-sécurité-par-défaut"></a>

`/security-review` réagit *après coup*, sur du code déjà écrit. Pour prévenir une partie des failles *avant* qu'elles n'apparaissent, complétez votre `.github/copilot-instructions.md` (vu au [Chapitre 05](../05-agents-custom-instructions/README.md)) avec des règles de sécurité explicites :

```markdown
## Sécurité

- Ne jamais coder en dur une clé API, un mot de passe ou un jeton : utiliser des variables d'environnement
- Toujours utiliser des requêtes paramétrées, jamais de concaténation de chaînes dans une requête SQL
- Hacher les mots de passe avec un algorithme dédié (bcrypt, argon2) — jamais MD5 ni SHA1
- Valider et échapper toute entrée utilisateur avant de l'afficher ou de l'exécuter
```

Ces instructions se chargent automatiquement à chaque session, sans que vous ayez à les répéter : c'est une défense en profondeur qui complète `/security-review`, plutôt qu'un doublon — l'une prévient, l'autre détecte ce qui est passé au travers.

---

## Protéger vos secrets

<a id="protéger-vos-secrets"></a>

Les **exclusions de contenu** (configurables au niveau organisation ou dépôt sur GitHub) permettent d'empêcher certains fichiers d'alimenter les suggestions, le chat ou la revue de code Copilot. C'est une bonne pratique à mettre en place, mais elle a une limite documentée qu'il faut connaître : **les exclusions de contenu ne couvrent pas Copilot CLI ni le mode agent**. Un fichier exclu côté suggestions IDE peut donc rester parfaitement lisible par Copilot CLI dans votre terminal.

La règle qui en découle est simple et ne dépend d'aucun réglage : **ne laissez jamais un secret réel dans un fichier que Copilot peut lire**, exclusion de contenu ou non. En pratique :

- Gardez vos secrets dans un fichier `.env` non versionné (déjà listé dans votre `.gitignore`), ou dans un gestionnaire de secrets qui les injecte à l'exécution
- Ne collez jamais une vraie clé d'API dans un prompt, même pour « juste tester »
- Si vous devez partager un fichier de configuration en exemple, remplacez chaque valeur sensible par un placeholder explicite (`YOUR_API_KEY_HERE`)

---

## Comprendre les limites et les risques

<a id="comprendre-les-limites-et-les-risques"></a>

`/security-review` est une fonctionnalité **expérimentale, en préversion publique** : le nombre de failles détectées, leur formulation ou leur sévérité peuvent évoluer d'une version à l'autre de Copilot CLI. Elle ne fait ni correspondance avec des CVE connues, ni analyse de dépendances, ni analyse de flux de données inter-fichiers approfondie — c'est le rôle de GitHub Code Scanning (CodeQL), Dependabot et d'outils tiers comme Snyk, en complément et non en remplacement.

> ⚠️ **Gardez aussi un œil sur ce que Copilot CLI *exécute*, pas seulement sur ce qu'il *écrit*.** Des chercheurs en sécurité ont documenté des cas où une entrée conçue pour l'occasion contournait la liste de commandes en lecture seule normalement approuvées sans confirmation, jusqu'à faire exécuter une commande réseau (téléchargement puis exécution d'un script) sans validation explicite. GitHub a qualifié ce cas de risque faible et n'a pas annoncé de correctif immédiat au moment de la rédaction. La bonne pratique reste la même que celle déjà rencontrée au Chapitre 09 pour un workflow n8n généré : **relisez toujours une commande proposée avant de l'approuver**, et évitez de faire tourner un dépôt non fiable en mode entièrement autonome (autopilot) sans supervision. Si vous avez besoin de ce mode entièrement autonome (`--allow-all`), construisez d'abord l'environnement sûr qui le rend acceptable : voir le [Chapitre 10 : Environnements isolés](../10-isolated-environments/README.md).

<details>
<summary>🎬 Voyez-le en action !</summary>

![Démo : /security-review sur un fichier vulnérable](assets/security-review-demo.gif)

*Le résultat peut varier selon votre modèle, vos outils et votre contexte : ne soyez pas surpris si votre sortie diffère de celle présentée ici — le nombre de failles détectées, leur sévérité, ou le texte exact des corrections proposées peuvent changer d'une session à l'autre.*

</details>

---

## Pratique

Le dossier [`samples/buggy-code/`](../samples/buggy-code/README.md) contient du code volontairement vulnérable (injection SQL, secrets en dur, désérialisation dangereuse, etc.) — le même terrain d'exercice utilisé au Chapitre 04. Utilisez-le ici pour comparer la revue native à celle de votre skill `security-audit` du Chapitre 06 :

```bash
cd samples/buggy-code
git add python/user_service.py

copilot

> /security-review
```

### ▶️ À vous de jouer

1. Lancez `/security-review` sur `python/payment_processor.py` et notez le nombre de failles détectées par niveau de sévérité
2. Comparez ce résultat avec celui de votre skill `security-audit` (Chapitre 06) sur le même fichier : quelles failles chacun trouve-t-il, et lesquelles seulement l'un des deux repère-t-il ?
3. Choisissez une faille « Critique » ou « Élevée » et demandez à Copilot CLI d'expliquer, ligne par ligne, pourquoi elle est dangereuse

---

## 📝 Devoir

**Défi principal** : appliquez la correction proposée par `/security-review` pour une faille critique de `samples/buggy-code`, puis relancez la commande pour confirmer qu'elle a disparu. Ne committez pas cette correction dans le vrai dépôt du cours : ce dossier est un terrain d'exercice intentionnellement bugué, gardez votre correction en local.

**Défi bonus** : sur un projet personnel, ajoutez une section « Sécurité » à votre propre `.github/copilot-instructions.md`, puis vérifiez avec un prompt neutre (« écris-moi une fonction qui stocke un mot de passe ») que Copilot applique désormais ces règles par défaut.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, demandez explicitement « Applique la correction proposée pour la faille [nom] dans ce fichier »
- Pour le défi bonus, formulez des règles courtes et impératives (« Ne jamais... », « Toujours... ») plutôt que des explications longues — Copilot les respecte mieux ainsi

</details>

---

## 🔧 Erreurs courantes et dépannage

<details>
<summary>Cliquez pour voir les problèmes fréquents et leurs solutions</summary>

| Erreur | Ce qui se passe | Solution |
|---|---|---|
| `/security-review` introuvable ou ignorée | Mode expérimental non activé, ou version de Copilot CLI trop ancienne | Mettez à jour Copilot CLI et activez le mode expérimental (`copilot --help` ou la documentation officielle pour la syntaxe de votre version) |
| « Aucun changement à analyser » | Aucun fichier modifié ou stagé dans le dépôt courant | Modifiez ou stagez (`git add`) au moins un fichier avant de relancer la commande |
| Résultat différent d'une exécution à l'autre | La commande est encore en préversion publique, le modèle sous-jacent peut évoluer | Normal pour une fonctionnalité expérimentale — recoupez avec une revue manuelle ou votre skill `security-audit` |
| Aucune CVE ni dépendance vulnérable signalée | Ce n'est pas le rôle de `/security-review` : elle analyse des schémas de code, pas des bases de CVE | Utilisez GitHub Code Scanning (CodeQL) et Dependabot en complément |
| Copilot exécute une commande shell sans confirmation attendue | Une liste de commandes en lecture seule peut être détournée par une entrée malveillante | Ne désactivez jamais les approbations sur un dépôt non fiable ; relisez chaque commande proposée avant de l'approuver |

</details>

---

## Résumé

Vous avez ajouté une dernière brique à votre flux de travail sécurité : une commande native pour scanner vos changements en quelques secondes, des instructions par défaut qui préviennent certaines failles avant même qu'elles n'apparaissent, et les réflexes de prudence nécessaires face aux limites réelles de l'outil.

### 🔑 Points clés à retenir

1. `/security-review` scanne votre diff local sur plusieurs catégories de vulnérabilités, directement dans le terminal (fonctionnalité expérimentale, en évolution)
2. Elle complète, sans les remplacer, les outils qui analysent l'historique du dépôt et les dépendances (Code Scanning/CodeQL, Dependabot, Snyk)
3. Des instructions de sécurité par défaut dans `.github/copilot-instructions.md` préviennent des failles avant même qu'elles ne soient écrites
4. Les exclusions de contenu ne couvrent pas Copilot CLI : la seule protection fiable pour un secret reste de ne jamais le placer dans un fichier lisible par l'IA
5. Relisez toujours une commande proposée par Copilot CLI avant de l'approuver, exactement comme vous relisez du code généré

---

## 📋 Référence rapide

- [Dedicated security review command now available in Copilot CLI](https://github.blog/changelog/2026-06-10-dedicated-security-review-command-now-available-in-copilot-cli/) — annonce officielle de `/security-review`
- [Best practices for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices) — bonnes pratiques générales, dont la sécurité
- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/enterprise-cloud@latest/copilot/responsible-use/copilot-cli) — limites et usage responsable
- [Chapitre 06 : Automatiser les tâches répétitives](../06-skills/README.md) — le skill `security-audit` maison
- [samples/buggy-code](../samples/buggy-code/README.md) — le code volontairement vulnérable utilisé dans ce chapitre

---

## ➡️ Et ensuite ?

Vous avez terminé le parcours de ce cours : de l'installation de Copilot CLI à la sécurisation de votre code, en passant par les agents, les skills, les serveurs MCP et les environnements isolés. La suite vous appartient : appliquez ces réflexes sur vos propres projets, et gardez toujours la relecture humaine comme dernière ligne de défense.

**[← Chapitre précédent : Environnements isolés](../10-isolated-environments/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
