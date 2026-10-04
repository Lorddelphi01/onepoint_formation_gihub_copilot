---
applyTo: "**/*.py"
---

# Standards Python

Ces règles s'appliquent automatiquement chaque fois que Copilot travaille sur un
fichier Python dans ce projet. Elles ne se chargent jamais pour les autres types
de fichiers, afin qu'une conversation sur un Dockerfile ou un fichier JSON reste
dépourvue de bruit inutile.

## Style

- Respecte les conventions de style PEP 8.
- Ajoute des type hints à chaque signature de fonction.
- Préfère les f-strings au formatage `%` ou à `str.format()`.

## Gestion des erreurs

- Capture des exceptions spécifiques ; n'utilise jamais un `except:` nu.
- Valide les entrées aux limites des fonctions et échoue avec un message clair.

## Tests

- Place les tests pytest dans `samples/book-app-project/tests/` en suivant la
  convention de nommage `test_*.py`.
- Couvre le cas nominal ainsi que les cas limites (entrée vide, données manquantes).
