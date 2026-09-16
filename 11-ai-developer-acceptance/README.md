<!--
---
id: CopilotCLI-11
title: !translate Comprendre l'acceptation de l'IA par les développeurs
description: !translate Découvrez ce que les études de GitHub, McKinsey, DORA et Stack Overflow révèlent sur les impacts positifs de l'IA sur les développeurs, et confrontez ces résultats à votre propre expérience de Copilot CLI.
audience: Developers / Students / Terminal users
slug: developer-acceptance-of-ai
weight: 12
---
-->

![Chapitre 11 : Acceptation de l'IA](assets/chapter-header.png)

> **Et si vos impressions sur l'IA pouvaient être vérifiées par des chiffres ?**

Depuis le Chapitre 01, vous avez installé, testé et pratiqué Copilot CLI sur des tâches concrètes : revue de code, débogage, génération de tests, agents personnalisés, skills, serveurs MCP, workflows n8n. Ce chapitre bonus change de nature : il ne vous apprend pas une nouvelle commande, mais vous invite à prendre du recul. Que dit la recherche indépendante — et pas seulement le discours commercial des éditeurs d'outils — de l'impact réel de l'IA sur le travail des développeurs et développeuses ? Et où se situe votre propre expérience par rapport à ces données ?

## 🎯 Objectifs d'apprentissage

À la fin de ce chapitre, vous serez capable de :

- Citer quatre études de référence sur l'IA et la productivité des développeurs (GitHub, McKinsey, DORA, Stack Overflow)
- Distinguer un chiffre de productivité mesurée d'un chiffre de productivité perçue ou autodéclarée
- Identifier les facteurs qui font varier les bénéfices de l'IA d'une équipe à l'autre
- Mener votre propre auto-évaluation et la confronter aux données présentées

> ⏱️ **Durée estimée : ~30 minutes** (20 min de lecture + 10 min d'auto-évaluation)

---

## ✅ Prérequis

- Avoir pratiqué au moins les [Chapitres 01 à 04](../04-development-workflows/README.md) — une expérience réelle de Copilot CLI est nécessaire pour l'auto-évaluation de ce chapitre
- Les Chapitres 09 et 10 (bonus) ne sont pas nécessaires pour suivre celui-ci
- Aucun outil supplémentaire requis : ce chapitre se lit et se pratique sans installation

---

## 🧩 Analogie du monde réel

<img src="assets/adoption-analogy.png" alt="Une frise chronologique montrant le passage de manuels papier à la recherche en ligne, puis à l'assistance IA" width="800"/>

| Concept | Adoption de « chercher sa réponse en ligne » (années 2000-2010) | Adoption de l'IA de codage (aujourd'hui) |
|---|---|---|
| Scepticisme initial | « Un vrai développeur lit la documentation officielle, pas des réponses de forum » | « Un vrai développeur écrit son code lui-même, il ne le délègue pas à une IA » |
| Ce que les études ont fini par montrer | Les développeurs qui cherchaient en ligne résolvaient certains problèmes plus vite qu'en épluchant des manuels | Les développeurs qui utilisent l'IA complètent certaines tâches nettement plus vite, avec une charge mentale réduite |
| Ce qui reste vrai malgré l'adoption | Il faut toujours vérifier la réponse trouvée et son contexte avant de l'utiliser | Il faut toujours relire et valider ce que l'IA produit avant de l'utiliser |

Chaque vague d'outillage a connu le même cycle : scepticisme légitime, puis données à l'appui, puis adoption prudente plutôt qu'aveugle. Ce chapitre vous donne les données ; à vous d'en tirer une adoption réfléchie plutôt qu'un simple effet de mode.

---

## Pourquoi cette question compte

L'IA de codage fait l'objet d'un discours à deux vitesses : d'un côté des annonces d'éditeurs qui promettent des gains spectaculaires, de l'autre un scepticisme tout aussi répandu chez les développeurs qui ont vu passer une IA générer du code erroné avec assurance. Entre les deux, la recherche indépendante — enquêtes à grande échelle, expériences contrôlées, études de cas en entreprise — offre un terrain plus solide pour se faire une opinion. Voici ce qu'elle dit.

## Ce que montrent les études

### GitHub Research : une expérience contrôlée sur la vitesse de complétion

En 2022 (mise à jour en 2024), la chercheuse Eirini Kalliamvakou et son équipe ont publié l'une des études les plus citées sur le sujet. Une expérience contrôlée a réparti 95 développeurs professionnels en deux groupes, avec pour tâche d'écrire un serveur HTTP en JavaScript : le groupe utilisant GitHub Copilot a terminé **55 % plus vite** (1 h 11 en moyenne, contre 2 h 41 pour le groupe témoin), avec un taux de réussite de 78 % contre 70 %. Le résultat est statistiquement significatif (P = .0017).

Une enquête complémentaire menée auprès de plus de 2 000 développeurs a mesuré des effets moins chronométrables mais tout aussi concrets : 73 % déclarent rester plus facilement « en flow », 87 % économisent de l'effort mental sur les tâches répétitives, et entre 60 et 75 % se sentent plus épanouis et moins frustrés dans leur travail. Un ingénieur senior interrogé résume ainsi son expérience : *« I have to think less, and when I have to think it's the fun stuff. »*

### McKinsey : des gains qui dépendent du type de tâche

L'étude McKinsey *« Unleashing developer productivity with generative AI »* (2023) montre que les gains de productivité varient fortement selon la nature de la tâche : jusqu'à deux fois plus rapide sur des tâches bien cadrées, avec des gains de 35 à 50 % sur la rédaction de documentation, environ 50 % sur la génération de nouveau code, et près des deux tiers sur le refactoring.

Le même rapport apporte une nuance importante : sur des tâches complexes ou faisant appel à un framework peu familier au développeur, le gain de temps tombe sous les 10 %. Les auteurs recommandent un accompagnement structuré (formation, sélection des cas d'usage) plutôt qu'un déploiement sans préparation.

### DORA : l'IA comme « amplificateur », pas comme solution magique

Le rapport 2025 de DORA (DevOps Research and Assessment, adossé à Google Cloud), *« State of AI-Assisted Software Development »*, indique que 90 % des répondants utilisent déjà l'IA dans leur travail, et plus de 80 % déclarent une productivité accrue. Sa thèse centrale est plus nuancée que ce seul chiffre : l'IA agirait comme un **amplificateur** des pratiques déjà en place, plutôt que comme un facteur de progrès universel.

Deux études de cas l'illustrent. Chez Adidas, les équipes travaillant sur une architecture faiblement couplée ont vu leur productivité progresser de 20 à 30 %, avec une hausse de 50 % du « Happy Time » (le temps réellement passé à coder plutôt qu'en tâches administratives) — tandis que les équipes dépendantes d'un ERP historique fortement couplé n'en ont tiré presque aucun bénéfice. Chez Booking.com, une formation ciblée des équipes a permis jusqu'à 30 % de merge requests supplémentaires, accompagnée d'une amélioration notable de la satisfaction au travail.

### Stack Overflow : une adoption qui grimpe, une confiance qui recule

L'enquête *Stack Overflow Developer Survey 2025* documente un paradoxe intéressant. L'adoption continue de progresser : 84 % des développeurs utilisent ou prévoient d'utiliser des outils IA, contre 76 % en 2024, et 52 % constatent un effet positif sur leur productivité.

Mais la confiance, elle, recule : le sentiment positif global vis-à-vis de l'IA est passé de plus de 70 % en 2023-2024 à 60 % en 2025, et 46 % des développeurs se méfient désormais de l'exactitude des réponses de l'IA, contre 33 % qui lui font confiance. La frustration la plus citée (66 % des répondants) : des réponses IA « presque justes, mais pas tout à fait ».

### Synthèse

| Étude | Échantillon | Résultat clé |
|---|---|---|
| GitHub Research (2022-2024) | 95 développeurs (expérience contrôlée) + 2 000+ (enquête) | Tâche test terminée 55 % plus vite ; 73 % restent « en flow » |
| McKinsey (2023) | Panel de développeurs sur des tâches types (documentation, code, refactoring) | Jusqu'à 2x plus rapide sur tâches bien cadrées ; moins de 10 % de gain sur tâches complexes |
| DORA (2025) | Enquête à grande échelle + études de cas (Adidas, Booking.com) | Plus de 80 % déclarent une productivité accrue ; l'IA amplifie les forces et les faiblesses organisationnelles existantes |
| Stack Overflow Developer Survey (2025) | Communauté mondiale de développeurs | 84 % utilisent ou prévoient d'utiliser l'IA (+8 points vs 2024) ; sentiment positif en recul (70 %+ → 60 %) |

## Ce qu'il faut nuancer

Ces quatre études racontent la même histoire à des degrés différents : des bénéfices réels et mesurés, mais ni uniformes ni automatiques. La thèse « amplificateur » de DORA explique pourquoi deux équipes utilisant le même outil peuvent obtenir des résultats opposés. Le paradoxe confiance/adoption de Stack Overflow rappelle qu'utiliser un outil plus souvent ne veut pas dire lui faire une confiance aveugle. Et la limite identifiée par McKinsey sur les tâches complexes confirme ce que vous avez sans doute déjà observé en pratiquant Copilot CLI : plus une tâche est bien cadrée, plus l'IA y excelle.

<details>
<summary>🎬 Voyez-le en action !</summary>

Ce chapitre ne comporte pas de commande à exécuter ni de démo à filmer. Voici à la place un exemple (fictif, à titre d'illustration) de ce à quoi peut ressembler une auto-évaluation une fois remplie, pour vous donner un modèle avant de faire la vôtre à la section Pratique :

| Question | Exemple de réponse |
|---|---|
| Tâche répétitive déléguée à Copilot CLI cette semaine | Génération de tests unitaires (Chapitre 04) |
| Temps gagné perçu | Environ 20 minutes sur une tâche qui en prenait 45 |
| Moment où il a fallu corriger l'IA | Un test généré ignorait un cas limite (liste vide) |
| Chiffre d'étude qui correspond le mieux à mon ressenti | « 87 % économisent de l'effort mental sur les tâches répétitives » (GitHub Research) |

*Le résultat de votre propre auto-évaluation variera selon vos tâches, votre projet et votre contexte : ne soyez pas surpris si vos réponses diffèrent largement de cet exemple.*

</details>

<details>
<summary>Approfondir : comment lire une étude d'adoption technologique sans se faire biaiser</summary>

- **Autodéclaration vs mesure directe** : un chiffre du type « 88 % se sentent plus productifs » décrit un ressenti, pas une mesure chronométrée. Les deux se complètent mais ne se remplacent pas — croisez enquête et expérience contrôlée quand c'est possible, comme le fait l'étude GitHub Research.
- **Taille et composition de l'échantillon** : une expérience sur 95 développeurs volontaires n'est pas représentative de toute la profession ; une enquête à 2 000+ réponses est plus solide, mais reste soumise au profil de qui répond (les utilisateurs déjà convaincus répondent souvent plus volontiers).
- **Qui finance et publie l'étude** : une étude publiée par l'éditeur d'un outil IA a un intérêt à en montrer les bénéfices — cela ne rend pas ses chiffres faux, mais justifie de les croiser avec une source indépendante, comme DORA ou Stack Overflow, qui ne vendent pas d'outil IA.
- **Le biais de sélection des cas publiés** : les études de cas à succès (comme Adidas dans le rapport DORA) sont choisies pour illustrer un potentiel, pas une moyenne garantie — le même rapport documente aussi des équipes qui n'en tirent presque aucun bénéfice.

</details>

---

## Pratique

Reprenez vos notes (ou votre mémoire) des chapitres précédents : les tâches où vous avez délégué du travail à Copilot CLI, le temps que cela vous a semblé faire gagner, et les moments où il a fallu corriger ou ignorer sa proposition.

### ▶️ À vous de jouer

1. Listez trois tâches où Copilot CLI vous a fait gagner du temps depuis le début de ce cours
2. Pour chacune, estimez le temps gagné en pourcentage, comme le font les études de ce chapitre
3. Identifiez laquelle des quatre études présentées correspond le mieux à votre propre expérience, et expliquez pourquoi

---

## 📝 Devoir

**Défi principal** : rédigez un bilan personnel de 3 à 5 phrases comparant votre expérience de Copilot CLI aux résultats présentés dans ce chapitre — sur quels points vos observations rejoignent-elles les études, sur quels points s'en écartent-elles ?

**Défi bonus** : recherchez une étude récente (2025 ou 2026) sur l'IA et les développeurs que ce chapitre ne cite pas, et résumez en quelques phrases sa méthode et son résultat principal.

<details>
<summary>💡 Indices</summary>

- Pour le défi principal, appuyez-vous sur un exemple concret plutôt qu'une impression générale (« le Chapitre 04, sur la génération de tests, m'a fait gagner... »)
- Pour le défi bonus, privilégiez une source qui indique clairement sa méthode (taille d'échantillon, enquête ou expérience contrôlée) plutôt qu'un article qui se contente de citer des chiffres sans les sourcer

</details>

---

## 🔧 Erreurs courantes et dépannage

<details>
<summary>Cliquez pour voir les pièges d'interprétation les plus fréquents</summary>

| Piège | Ce qui se passe | Comment l'éviter |
|---|---|---|
| Confondre ressenti et mesure | Un chiffre d'enquête (« 88 % se sentent plus productifs ») est traité comme une mesure chronométrée | Vérifiez si l'étude décrit une enquête déclarative ou une expérience contrôlée — les deux ont une valeur différente |
| Généraliser un chiffre moyen à son propre cas | « L'IA fait gagner 55 % de temps » est appliqué tel quel à une tâche très différente de celle testée | Repérez la tâche exacte utilisée dans l'étude (ici, un serveur HTTP en JavaScript) avant de comparer à votre contexte |
| Ignorer qui publie l'étude | Un chiffre très favorable venant d'un éditeur d'outil IA est pris pour une vérité absolue | Croisez toujours avec au moins une source indépendante (DORA, Stack Overflow) avant de tirer une conclusion |
| Oublier l'effet « amplificateur » | On attend les mêmes gains d'IA quelle que soit la maturité de son équipe ou de son organisation | Rappelez-vous que le rapport DORA montre des gains très inégaux selon les pratiques d'ingénierie déjà en place (architecture, formation, etc.) |

</details>

---

## Résumé

Les études indépendantes convergent sur un point : l'IA de codage produit des bénéfices mesurables sur la vitesse, la charge mentale et la satisfaction des développeurs, mais ces bénéfices ne sont ni uniformes ni automatiques — ils dépendent du type de tâche, de l'organisation et de l'esprit critique avec lequel on interprète les chiffres. Votre propre expérience de Copilot CLI depuis le début de ce cours est une donnée tout aussi valable que celles présentées ici.

### 🔑 Points clés à retenir

1. Les expériences contrôlées (GitHub Research) et les enquêtes déclaratives (Stack Overflow) mesurent des choses différentes — ne les confondez pas
2. Les gains de productivité varient fortement selon le type de tâche : très élevés sur les tâches répétitives et bien cadrées (McKinsey), beaucoup plus faibles sur les tâches complexes
3. L'IA agit comme un amplificateur des pratiques existantes, pas comme une solution universelle — c'est la thèse centrale du rapport DORA
4. L'adoption de l'IA progresse plus vite que la confiance qu'on lui accorde (Stack Overflow) — un scepticisme mesuré reste une posture saine, pas un obstacle à l'usage

---

## 📋 Référence rapide

- [GitHub Research : quantifier l'impact de Copilot sur la productivité et le bien-être](https://github.blog/news-insights/research/research-quantifying-github-copilots-impact-on-developer-productivity-and-happiness/)
- [McKinsey : Unleashing developer productivity with generative AI](https://www.mckinsey.com/capabilities/tech-and-ai/our-insights/unleashing-developer-productivity-with-generative-ai)
- [DORA : State of AI-Assisted Software Development 2025](https://dora.dev/dora-report-2025/)
- [Stack Overflow Developer Survey 2025 — section IA](https://survey.stackoverflow.co/2025/ai)
- [Chapitre 04 : Flux de travail de développement](../04-development-workflows/README.md) — pour revoir les tâches déléguées à Copilot CLI que vous allez confronter à ces études

---

## ➡️ Et ensuite ?

Vous avez terminé la partie pratique de ce cours et pris du recul sur ce que la recherche indépendante dit de l'IA en développement. La suite vous appartient : continuer à pratiquer, mesurer votre propre expérience, et rester aussi critique envers vos propres impressions qu'envers les chiffres des études.

**[← Chapitre précédent : Environnements isolés](../10-isolated-environments/README.md)** | **[Retour à l'accueil du cours →](../README.md)**
