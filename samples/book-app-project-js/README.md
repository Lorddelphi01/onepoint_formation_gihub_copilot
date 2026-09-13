# Book Collection App

*(Ce README est volontairement imparfait afin que vous puissiez l'améliorer avec GitHub Copilot CLI)*

Une application JavaScript pour gérer les livres que vous possédez ou souhaitez lire.
Elle permet d'ajouter, de supprimer et de lister des livres. Elle permet aussi de les marquer comme lus.

---

## Fonctionnalités actuelles

* Lit les livres depuis un fichier JSON (notre base de données)
* La validation des entrées est faible sur certains points
* Quelques tests existent mais probablement pas assez

---

## Fichiers

* `book_app.js` - Point d'entrée principal de la CLI
* `books.js` - Classe BookCollection contenant la logique métier
* `utils.js` - Fonctions utilitaires pour l'interface et les entrées
* `data.json` - Exemple de données de livres
* `tests/test_books.js` - Tests de base utilisant le lanceur de tests intégré de Node

---

## Lancer l'application

```bash
node book_app.js list
node book_app.js add
node book_app.js find
node book_app.js remove
node book_app.js help
```

## Lancer les tests

```bash
npm test
```

---

## Remarques

* Pas prêt pour la production (évidemment)
* Certaines parties du code pourraient être améliorées
* D'autres commandes pourraient être ajoutées plus tard
