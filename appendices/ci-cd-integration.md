<!--
---
id: CopilotCLI-Appendix-CI-CD-Integration
title: !translate Intégration CI/CD
description: !translate Intégrez GitHub Copilot CLI dans les workflows GitHub Actions pour automatiser les revues de pull requests.
audience: Developers / Students / Terminal users
slug: ci-cd-integration
weight: 91
---
-->

# Intégration CI/CD

> 📖 **Prérequis** : terminez le [Chapitre 08 : Tout assembler](../08-putting-it-together/README.md) avant de lire cette annexe.
>
> ⚠️ **Cette annexe s'adresse aux équipes disposant déjà de pipelines CI/CD.** Si vous découvrez GitHub Actions ou les concepts de CI/CD, commencez plutôt par l'approche plus simple du hook pre-commit décrite dans la section [Automatisation de la revue de code](../08-putting-it-together/README.md#workflow-3-code-review-automation-optional) du Chapitre 08.

Cette annexe montre comment intégrer GitHub Copilot CLI dans vos pipelines CI/CD pour automatiser la revue de code sur les pull requests.

---

## Workflow GitHub Actions

Ce workflow effectue automatiquement une revue des fichiers modifiés lorsqu'une pull request est ouverte ou mise à jour :

```yaml
# .github/workflows/copilot-review.yml
name: Copilot Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Nécessaire pour comparer avec la branche main

      - name: Install Copilot CLI
        run: npm install -g @github/copilot

      - name: Review Changed Files
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          # Récupère la liste des fichiers JS/TS modifiés
          FILES=$(git diff --name-only origin/main...HEAD | grep -E '\.(js|ts|jsx|tsx)$' || true)
          
          if [ -z "$FILES" ]; then
            echo "No JavaScript/TypeScript files changed"
            exit 0
          fi
          
          echo "# Copilot Code Review" > review.md
          echo "" >> review.md
          
          for file in $FILES; do
            echo "Reviewing $file..."
            echo "## $file" >> review.md
            echo "" >> review.md
            
            # Utilise --silent pour supprimer la sortie de progression
            copilot --allow-all -p "Quick security and quality review of @$file. List only critical issues." --silent >> review.md 2>/dev/null || echo "Review skipped" >> review.md
            echo "" >> review.md
          done

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            
            // Ne poste que si le contenu est pertinent
            if (review.includes('CRITICAL') || review.includes('HIGH')) {
              github.rest.issues.createComment({
                issue_number: context.issue.number,
                owner: context.repo.owner,
                repo: context.repo.repo,
                body: review
              });
            } else {
              console.log('No critical issues found, skipping comment');
            }
```

---

## Options de configuration

### Limiter la portée de la revue

Vous pouvez concentrer la revue sur des types de problèmes spécifiques :

```yaml
# Revue axée uniquement sur la sécurité
copilot --allow-all -p "Security review of @$file. Check for: SQL injection, XSS, hardcoded secrets, authentication issues." --silent

# Revue axée uniquement sur la performance
copilot --allow-all -p "Performance review of @$file. Check for: N+1 queries, memory leaks, blocking operations." --silent
```

### Gérer les PR volumineuses

Pour les PR comportant de nombreux fichiers, envisagez un traitement par lots ou une limitation :

```yaml
# Limiter aux 10 premiers fichiers
FILES=$(git diff --name-only origin/main...HEAD | grep -E '\.(js|ts)$' | head -10)

# Ou définir un délai d'expiration par fichier
timeout 60 copilot --allow-all -p "Review @$file" --silent || echo "Review timed out"
```

### Configuration d'équipe

Pour des revues cohérentes au sein de votre équipe, créez une configuration partagée :

```json
// .copilot/config.json (versionné dans le dépôt)
{
  "model": "claude-sonnet-4.5",
  "permissions": {
    "allowedPaths": ["src/**/*", "tests/**/*"],
    "deniedPaths": [".env*", "secrets/**/*", "*.min.js"]
  }
}
```

---

## Alternative : bot de revue de PR

Pour des workflows de revue plus sophistiqués, envisagez d'utiliser l'agent cloud GitHub Copilot :

```yaml
# .github/workflows/copilot-agent-review.yml
name: Request Copilot Review

on:
  pull_request:
    types: [opened, ready_for_review]

jobs:
  request-review:
    runs-on: ubuntu-latest
    steps:
      - name: Request Copilot Review
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.pulls.requestReviewers({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: context.issue.number,
              reviewers: ['copilot[bot]']
            });
```

---

## Bonnes pratiques pour l'intégration CI/CD

1. **Utilisez l'option `--silent`** - Supprime la sortie de progression pour des logs plus propres
2. **Définissez des délais d'expiration** - Évitez que des revues bloquées n'immobilisent votre pipeline
3. **Filtrez les types de fichiers** - Ne passez en revue que les fichiers pertinents (ignorez le code généré, les dépendances)
4. **Attention aux limites de débit** - Espacez les revues pour les PR volumineuses
5. **Échouez avec élégance** - Ne bloquez pas les fusions en cas d'échec de la revue ; journalisez et continuez

---

## Dépannage

### « Authentication failed » en CI

Assurez-vous que votre workflow dispose des permissions correctes :

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
```

### Les revues expirent (timeout)

Augmentez le délai d'expiration ou réduisez la portée :

```bash
timeout 120 copilot --allow-all -p "Quick review of @$file - critical issues only" --silent
```

### Limites de tokens sur les fichiers volumineux

Ignorez les fichiers très volumineux :

```bash
if [ $(wc -l < "$file") -lt 500 ]; then
  copilot --allow-all -p "Review @$file" --silent
else
  echo "Skipping $file (too large)"
fi
```

---

**[← Retour au Chapitre 08](../08-putting-it-together/README.md)** | **[Retour aux annexes](README.md)**
