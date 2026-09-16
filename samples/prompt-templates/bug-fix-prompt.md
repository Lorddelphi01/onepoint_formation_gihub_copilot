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
