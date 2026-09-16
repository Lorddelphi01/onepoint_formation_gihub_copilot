# Template : correction de bug

Remplissez les emplacements `<...>` puis collez le résultat dans une session `copilot`.

---

Il y a un bug dans <fichier, ex. samples/book-app-project/books.py>, dans la fonction <nom de la fonction>.

Comportement observé : <ce qui se passe actuellement, ex. "add_book() accepte un ISBN vide sans erreur">

Comportement attendu : <ce qui devrait se passer, ex. "add_book() doit lever une ValueError si l'ISBN est vide ou mal formé">

Critères d'acceptation :

- <critère 1, ex. "un ISBN vide déclenche une ValueError avec un message explicite">
- <critère 2, ex. "un ISBN valide continue de fonctionner sans régression">
- <critère 3, ex. "un test dans tests/test_books.py couvre le nouveau cas">

Contraintes :

- Ne modifie pas la signature de <nom de la fonction>
- N'introduis pas de nouvelle dépendance externe

Format de sortie attendu :

Le correctif appliqué directement au fichier, accompagné du nouveau test, avec un court résumé de ce qui a changé et pourquoi.

---

## Exemple réussi

**Prompt rempli :**

> Il y a un bug dans `samples/book-app-project/utils.py`, dans `get_book_details()`. Quand la personne saisit une année qui n'est pas un nombre, l'application enregistre silencieusement l'année `0`. Corrige ce comportement pour que la saisie soit redemandée avec un message explicite. Garde la signature de `get_book_details()` inchangée, n'ajoute aucune dépendance externe et ajoute des tests couvrant une année invalide puis une année valide. Applique le correctif et résume les changements.

**Sortie attendue :** le correctif limite son périmètre à la lecture de l'année, redemande une valeur après une saisie invalide, préserve les autres champs du livre et ajoute des tests couvrant le rejet puis l'acceptation d'une année.

## Contre-exemple

> Le programme gère mal les années. Corrige-le.

Ce prompt échoue car il ne précise ni le fichier, ni le comportement observé, ni le comportement attendu. Copilot CLI peut modifier une autre partie de l'application, choisir une règle métier différente ou ne pas ajouter de test.
