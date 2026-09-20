# AGENTS.md

Cours pour débutants enseignant GitHub Copilot CLI. Contenu pédagogique, pas un logiciel.

## Structure

| Chemin | Objectif |
|------|---------|
| `00-08/` | Chapitres : analogie → concepts → pratique → devoir → suite. `00-modern-terminal-stack/` est un chapitre complémentaire (stack terminal) qui précède l'installation de Copilot CLI (01) et les premiers pas (02) |
| `09-isolated-environments/` | Chapitre bonus (optionnel, nécessite Docker) : exécuter Copilot CLI dans un dev container puis dans une sandbox Docker isolée, pour automatiser avec `--allow-all` sans risque |
| `10-obsidian-rag/` | Chapitre bonus (optionnel, nécessite Obsidian) : connecter Copilot CLI à un vault Obsidian via deux serveurs MCP (recherche sémantique + accès au vault) pour construire un pipeline RAG local sur ses propres notes |
| `11-security-with-copilot/` | Chapitre : la commande native `/security-review`, des instructions de sécurité par défaut, la protection des secrets, et un audit pratique sur `samples/buggy-code/` |
| `12-ai-developer-acceptance/` | Chapitre bonus : études (GitHub, McKinsey, DORA, Stack Overflow) sur les impacts positifs de l'IA sur les développeurs, avec auto-évaluation personnelle |
| `13-chronicle-session-insights/` | Chapitre sur la commande native `/chronicle` : rapports d'activité, conseils personnalisés, recherche et amélioration des instructions à partir de l'historique de sessions |
| `14-token-consumption-analysis/` | Chapitre bonus (outils tiers) : réduire la sortie de commandes avec RTK et mesurer la consommation de tokens avec Tokscale |
| `15-prompt-engineering/` | Chapitre bonus : rédiger des instructions claires et ancrées dans le vocabulaire métier, construire des templates de prompts réutilisables, et le principe d'une CLI générée depuis un serveur MCP |
| `16-parallel-worktrees/` | Chapitre bonus (optionnel) : isoler plusieurs sessions Copilot CLI dans des worktrees Git pour paralléliser des tâches indépendantes sur le même dépôt |
| `17-mcp2cli/` | Chapitre bonus (optionnel), complète le Chapitre 07 : le coût en tokens de MCP, et mcp2cli pour interroger un serveur MCP (Context7) directement depuis le terminal sans passer par Copilot |
| `18-n8n-workflows/` | Chapitre bonus (optionnel, nécessite Docker) : connecter Copilot CLI au serveur MCP de n8n et utiliser les skills n8n officielles pour construire un workflow visuel |
| `samples/book-app-project/` | **Exemple principal** : application CLI Python de gestion de collection de livres utilisée tout au long des chapitres |
| `samples/book-app-project-cs/` | Version C# de l'application de collection de livres |
| `samples/book-app-project-js/` | Version JavaScript de l'application de collection de livres |
| `samples/book-app-buggy/` | **Bugs intentionnels** pour les exercices de débogage (Ch 03) |
| `samples/agents/` | Exemples de modèles d'agents (python-reviewer, pytest-helper, hello-world) |
| `samples/skills/` | Exemples de modèles de skills (code-checklist, pytest-gen, commit-message, hello-world) |
| `samples/mcp-configs/` | Exemples de configuration de serveurs MCP |
| `samples/prompt-templates/` | Templates de prompts réutilisables (revue de code, correction de bug, nouvelle fonctionnalité) utilisés au Chapitre 15 |
| `samples/buggy-code/` | **Extra optionnel** : code bogué axé sécurité (JS et Python) |
| `samples/src/` | **Extra optionnel** : anciens exemples JS/React d'une version précédente du cours |
| `appendices/` | Documentation de référence complémentaire |

## Pistes (tracks) du README

Le catalogue de formation du `README.md` regroupe les 19 chapitres en 5
pistes, calquées sur le découpage tronc-commun/bonus déjà en vigueur (pas de
thématique inventée) :

| Piste | Chapitres |
|---|---|
| 🧭 Fondamentaux | 00, 01, 02 |
| ⚡ Flux de travail quotidiens | 03, 04 |
| 🤖 Automatisation & agents IA | 05, 06, 07, 08 |
| 🎓 Aller plus loin avec les commandes natives | 11, 13 |
| 🎁 Modules bonus (optionnels) | 09, 10, 12, 14, 15, 16, 17, 18 |

Chaque carte de chapitre affiche une durée estimée (lecture + pratique),
calculée à partir du nombre de mots du `README.md` du chapitre divisé par 130
mots/minute, arrondie aux 5 minutes les plus proches. Recalculer cette
estimation si le contenu d'un chapitre change significativement.

## À faire

- Garder des explications accessibles aux débutants ; expliquer le jargon IA/ML lorsqu'il est utilisé
- S'assurer que les exemples bash sont prêts à copier-coller
- Ton : amical, encourageant, pratique
- Utiliser les chemins de `samples/book-app-project/` dans tous les exemples principaux
- Utiliser un contexte Python/pytest pour les exemples de code

## À ne pas faire

- Corriger les bugs dans `samples/book-app-buggy/` ou `samples/buggy-code/` — ils sont intentionnels
- Ajouter des chapitres sans mettre à jour le tableau du cours dans README.md
- Supposer que les lecteurs connaissent la terminologie IA/ML
- Modifier le regroupement en pistes du README sans le répercuter dans la table « Pistes (tracks) du README » ci-dessus

## Build

```bash
npm install && npm run release
npm run audit
```

`npm run audit` vérifie les références locales Markdown/HTML et la cohérence des
GIF/tapes avec `.github/scripts/demos.json`. Il signale aussi les GIF orphelins
et les chapitres contenant des commandes Copilot qui ne sont pas encore couverts.
Les nouveaux assets utilisent les noms `<concept>-demo.gif` et
`<concept>-analogy.png`.
</content>
