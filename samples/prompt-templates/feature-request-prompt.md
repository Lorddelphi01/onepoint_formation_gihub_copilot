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
