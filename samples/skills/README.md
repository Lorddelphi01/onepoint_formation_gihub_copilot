# Exemples de skills

Modèles de skills prêts à l'emploi pour GitHub Copilot CLI. Copie n'importe quel dossier de skill pour commencer à l'utiliser immédiatement.

## Démarrage rapide

```bash
# Copier un skill dans ton dossier de skills personnel
cp -r hello-world ~/.copilot/skills/

# Ou copier dans ton projet pour un partage en équipe
cp -r code-checklist .github/skills/
```

## Skills disponibles

| Skill | Description | Idéal pour |
|-------|-------------|----------|
| `hello-world` | Exemple minimal (apprentissage du format) | Premiers pas dans la création de skills |
| `code-checklist` | Checklist qualité de code Python (PEP 8, annotations de type, validation) | Vérifications de qualité cohérentes |
| `pytest-gen` | Génère des tests pytest complets | Génération de tests structurée |
| `commit-message` | Messages de commit conventionnels | Historique git standardisé |

## Fonctionnement des skills

Les skills se déclenchent **automatiquement** lorsque ta requête correspond au champ `description` du skill. Tu n'as pas besoin de les invoquer manuellement.

```bash
copilot

> Check this code for quality issues
# Copilot détecte que cela correspond au skill "code-checklist" et le charge automatiquement

> Generate a commit message
# Copilot charge le skill "commit-message"
```

Tu peux aussi invoquer les skills directement :
```bash
> /code-checklist Check books.py
> /pytest-gen Generate tests for BookCollection
> /commit-message
```

## Structure d'un skill

Chaque skill est un dossier contenant un fichier `SKILL.md` :

```
skill-name/
└── SKILL.md    # Obligatoire : contient le frontmatter + les instructions
```

Le fichier `SKILL.md` possède un frontmatter YAML avec `name` et `description` (tous deux obligatoires) :

```markdown
---
name: my-skill
description: What this skill does and when to use it
---

# Skill Instructions

Your instructions here...
```

## Trouver d'autres skills

- **[github/awesome-copilot](https://github.com/github/awesome-copilot)** - Ressources officielles de GitHub avec des skills communautaires
- **`/plugin marketplace`** - Parcourir et installer des skills directement depuis Copilot CLI

## Créer tes propres skills

1. Crée un dossier : `mkdir ~/.copilot/skills/my-skill`
2. Crée `SKILL.md` avec le frontmatter
3. Ajoute tes instructions
4. Teste en demandant à Copilot quelque chose qui correspond à ta description

Voir [Chapitre 06 : Skills](../../06-skills/README.md) pour des conseils détaillés.
