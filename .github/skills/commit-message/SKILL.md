---
name: commit-message
description: Génère des messages de commit conventionnels - à utiliser lors de la création de commits, de la rédaction de messages de commit, ou pour toute aide liée à git commit
---

# Skill Message de commit

Génère des messages de commit en suivant la spécification Conventional Commits.

## Format

```
<type>(<scope>): <description>

[corps optionnel]

[footer optionnel]
```

## Types

| Type | Quand l'utiliser |
|------|-------------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `docs` | Documentation uniquement |
| `style` | Mise en forme (sans changement de code) |
| `refactor` | Changement de code qui ne corrige ni n'ajoute rien |
| `perf` | Amélioration de performance |
| `test` | Ajout ou mise à jour de tests |
| `chore` | Tâches de maintenance |

## Règles

1. La ligne de sujet fait au maximum 72 caractères
2. Utilisez l'impératif ("add" et non "added" ou "adds")
3. Pas de point final sur la ligne de sujet
4. Séparez le sujet du corps par une ligne vide
5. Le corps explique le **quoi** et le **pourquoi**, pas le comment

## Exemples

Simple :
```
fix(auth): prevent redirect loop on expired sessions
```

Avec corps :
```
feat(api): add rate limiting to public endpoints

- Limits requests to 100/minute per IP
- Returns 429 status with retry-after header
- Configurable via RATE_LIMIT_MAX env variable

Closes #234
```
