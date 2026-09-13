---
name: code-checklist
description: Checklist qualité de code d'équipe - à utiliser pour vérifier la qualité du code Python, les bugs, les problèmes de sécurité et les bonnes pratiques
---

# Skill Checklist de code

Appliquez cette checklist lors de la vérification de code Python.

## Checklist qualité de code

- [ ] Toutes les fonctions ont des annotations de type (type hints)
- [ ] Aucune clause except nue
- [ ] Aucun argument par défaut mutable
- [ ] Des gestionnaires de contexte sont utilisés pour les entrées/sorties fichier
- [ ] Les fonctions font moins de 50 lignes
- [ ] Les noms de variables et de fonctions suivent la PEP 8 (snake_case)

## Checklist de validation des entrées

- [ ] Les entrées utilisateur sont validées avant traitement
- [ ] Les cas limites sont gérés (chaînes vides, None, valeurs hors plage)
- [ ] Les messages d'erreur sont clairs et utiles

## Checklist de tests

- [ ] Le nouveau code dispose de tests pytest correspondants
- [ ] Les cas limites sont couverts
- [ ] Les tests utilisent des noms explicites

## Format de sortie

Présentez les résultats comme suit :

```
## Code Checklist: [filename]

### Code Quality
- [PASS/FAIL] Description of finding

### Input Validation
- [PASS/FAIL] Description of finding

### Testing
- [PASS/FAIL] Description of finding

### Summary
[X] items need attention before merge
```
