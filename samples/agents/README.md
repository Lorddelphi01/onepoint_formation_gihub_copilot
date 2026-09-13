# Exemples de définitions d'agents

Ce dossier contient quelques modèles simples d'agents pour GitHub Copilot CLI, destinés à t'aider à démarrer avec les agents.

## Démarrage rapide

```bash
# Copier un agent vers ton dossier d'agents personnel
cp hello-world.agent.md ~/.copilot/agents/

# Ou copier vers ton projet pour le partage en équipe
cp python-reviewer.agent.md .github/agents/
```

## Exemples de fichiers dans ce dossier

| Fichier | Description | Idéal pour |
|------|-------------|----------|
| `hello-world.agent.md` | Exemple minimal (11 lignes) | Apprendre le format |
| `python-reviewer.agent.md` | Relecteur de qualité de code Python | Revues de code, PEP 8, indications de type |
| `pytest-helper.agent.md` | Spécialiste des tests pytest | Génération de tests, fixtures, cas limites |

## Trouver plus d'agents

- **[github/awesome-copilot](https://github.com/github/awesome-copilot)** - Ressources officielles de GitHub avec des agents et instructions communautaires

---

## Format des fichiers d'agent

Chaque fichier d'agent nécessite un frontmatter YAML avec au moins un champ `description` :

```markdown
---
name: my-agent
description: Brève description de ce que fait cet agent
tools: ["read", "edit", "search"]  # Optionnel : limite les outils disponibles
---

# Nom de l'agent

Les instructions de l'agent vont ici...
```

**Propriétés YAML disponibles :**

| Propriété | Requise | Description |
|----------|----------|-------------|
| `description` | **Oui** | Ce que fait l'agent |
| `name` | Non | Nom d'affichage (par défaut, le nom du fichier) |
| `tools` | Non | Liste des outils autorisés (omis = tous). Voir les alias ci-dessous. |
| `target` | Non | Limiter à `vscode` ou `github-copilot` uniquement |

**Alias d'outils** : `read`, `edit`, `search`, `execute` (shell), `web`, `agent`

> 💡 **Remarque** : la propriété `model` fonctionne dans VS Code mais n'est pas encore prise en charge dans Copilot CLI.
>
> 📖 **Documentation officielle** : [Configuration des agents personnalisés](https://docs.github.com/copilot/reference/custom-agents-configuration)

## Emplacements des fichiers d'agent

Les agents peuvent être stockés dans :
- `~/.copilot/agents/` - Agents globaux disponibles dans tous les projets
- `.github/agents/` - Agents spécifiques au projet
- Fichiers `.agent.md` - Format compatible avec VS Code

Chaque agent est un fichier séparé avec l'extension `.agent.md`.

---

## Exemples d'utilisation

```bash
# Démarrer avec un agent spécifique
copilot --agent python-reviewer

# Ou sélectionner un agent de manière interactive pendant une session
copilot
> /agent
# Sélectionne "python-reviewer" dans la liste

# L'expertise de l'agent s'applique à tes prompts
> @samples/book-app-project/books.py Review this code for quality issues

# Basculer vers un autre agent
> /agent
# Sélectionne "pytest-helper"

> @samples/book-app-project/tests/test_books.py What additional tests should we add?
```

---

## Créer tes propres agents

1. Crée un nouveau fichier dans `~/.copilot/agents/` avec l'extension `.agent.md`
2. Ajoute un frontmatter YAML avec au moins un champ `description`
3. Ajoute un titre descriptif (par exemple, `# Security Agent`)
4. Définis l'expertise, les normes, et les comportements de l'agent
5. Utilise l'agent avec `/agent` ou `--agent <name>`

**Conseils pour des agents efficaces :**
- Sois précis sur les domaines d'expertise
- Inclus des normes et des modèles de code
- Définis ce que l'agent vérifie
- Inclus des préférences de format de sortie
