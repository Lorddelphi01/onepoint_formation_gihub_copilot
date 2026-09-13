---
applyTo: "**/*.py"
---

# Standards Python

Ces règles s'appliquent automatiquement chaque fois que Copilot travaille sur un
fichier Python dans ce projet. Elles ne se chargent jamais pour les autres types
de fichiers, afin qu'une conversation sur un Dockerfile ou un fichier JSON reste
dépourvue de bruit inutile.

## Style

- Respectez les conventions de style PEP 8.
- Ajoutez des type hints à chaque signature de fonction.
- Préférez les f-strings au formatage `%` ou à `str.format()`.

## Gestion des erreurs

- Capturez des exceptions spécifiques ; n'utilisez jamais un `except:` nu.
- Validez les entrées aux limites des fonctions et échouez avec un message clair.

## Tests

- Placez les tests pytest dans `samples/book-app-project/tests/` en suivant la
  convention de nommage `test_*.py`.
- Couvrez le cas nominal ainsi que les cas limites (entrée vide, données manquantes).
