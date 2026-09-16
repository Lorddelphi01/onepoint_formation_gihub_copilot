# Template : nouvelle fonctionnalité

Remplissez les emplacements `<...>` puis collez le résultat dans une session `copilot`.

---

Ajoute la fonctionnalité suivante à <projet/fichier, ex. samples/book-app-project/books.py> :

<description de la fonctionnalité en une ou deux phrases, ex. "une fonction find_books_by_author(author) qui retourne tous les livres du catalogue dont le champ author correspond, recherche insensible à la casse">

Contexte métier à respecter :

- Vocabulaire du domaine : <termes réels du projet, ex. "livre, catalogue, ISBN, auteur — pas de terme générique comme 'item' ou 'record'">
- Conventions existantes : <ex. "snake_case, docstrings courtes, même structure de retour que list_books()">

Contraintes :

- <contrainte 1, ex. "ne modifie pas la structure de data.json">
- <contrainte 2, ex. "réutilise les fonctions utilitaires déjà présentes dans utils.py plutôt que d'en dupliquer la logique">

Format de sortie attendu :

Le code de la fonctionnalité, un test correspondant dans tests/, et une ligne d'exemple d'utilisation en commentaire.

---

## Exemple réussi

**Prompt rempli :**

> Ajoute `find_books_by_year(year)` à `samples/book-app-project/books.py`. La méthode doit retourner les livres du catalogue dont le champ `year` correspond à l'année demandée, avec la même structure de retour que `list_books()`. Utilise le vocabulaire « livre » et « catalogue », conserve le style `snake_case`, ne modifie pas `data.json` et ajoute des tests pytest pour une année présente et une année absente. Retourne le code, les tests et un exemple d'utilisation en commentaire.

**Sortie attendue :** une méthode ciblée sur `BookCollection`, une liste de `Book` cohérente avec `list_books()`, deux tests pytest (résultat trouvé et liste vide) et aucun changement de format dans `data.json`.

## Contre-exemple

> Ajoute une recherche dans l'application.

Ce prompt échoue car « recherche » ne dit pas quel champ du catalogue utiliser, quel type de résultat retourner ni quels cas tester. Copilot CLI peut créer une recherche par titre, une interface différente ou une fonctionnalité sans tests.
