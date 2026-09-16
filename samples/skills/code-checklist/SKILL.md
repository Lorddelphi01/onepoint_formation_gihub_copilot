---
name: code-checklist
description: Checklist qualité de code de l'équipe - à utiliser pour vérifier la qualité du code Python, les bugs, les problèmes de sécurité et les bonnes pratiques
---

# Skill Checklist de code

Appliquez cette checklist lors de la vérification du code Python.

## Checklist qualité de code

- [ ] Toutes les fonctions ont des type hints
- [ ] Aucune clause except nue
- [ ] Aucun argument par défaut mutable
- [ ] Des gestionnaires de contexte sont utilisés pour les entrées/sorties de fichiers
- [ ] Les fonctions font moins de 50 lignes
- [ ] Les noms de variables et de fonctions respectent la convention PEP 8 (snake_case)

## Checklist de validation des entrées

- [ ] Les entrées utilisateur sont validées avant traitement
- [ ] Les cas limites sont gérés (chaînes vides, None, valeurs hors limites)
- [ ] Les messages d'erreur sont clairs et utiles

## Checklist de tests

- [ ] Le nouveau code dispose de tests pytest correspondants
- [ ] Les cas limites sont couverts
- [ ] Les tests utilisent des noms descriptifs

## Format de sortie

Présentez les résultats sous la forme suivante :

```
## Checklist de code : [filename]

### Qualité du code
- [PASS/FAIL] Description du constat

### Validation des entrées
- [PASS/FAIL] Description du constat

### Tests
- [PASS/FAIL] Description du constat

### Résumé
[X] éléments nécessitent une attention avant la fusion (merge)
```
