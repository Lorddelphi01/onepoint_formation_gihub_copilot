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
| `samples/book-app-project/` | **Exemple principal** : application CLI Python de gestion de collection de livres utilisée tout au long des chapitres |
| `samples/book-app-project-cs/` | Version C# de l'application de collection de livres |
| `samples/book-app-project-js/` | Version JavaScript de l'application de collection de livres |
| `samples/book-app-buggy/` | **Bugs intentionnels** pour les exercices de débogage (Ch 03) |
| `samples/agents/` | Exemples de modèles d'agents (python-reviewer, pytest-helper, hello-world) |
| `samples/skills/` | Exemples de modèles de skills (code-checklist, pytest-gen, commit-message, hello-world) |
| `samples/mcp-configs/` | Exemples de configuration de serveurs MCP |
| `samples/buggy-code/` | **Extra optionnel** : code bogué axé sécurité (JS et Python) |
| `samples/src/` | **Extra optionnel** : anciens exemples JS/React d'une version précédente du cours |
| `appendices/` | Documentation de référence complémentaire |

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

## Build

```bash
npm install && npm run release
```
</content>
