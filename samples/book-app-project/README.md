# Book Collection App

*(Ce README est volontairement imparfait afin que vous puissiez l'améliorer avec GitHub Copilot CLI)*

Une application Python pour gérer les livres que vous possédez ou souhaitez lire.
Elle permet d'ajouter, de supprimer et de lister des livres. Elle permet aussi de les marquer comme lus.

---

## Fonctionnalités actuelles

* Lit les livres depuis un fichier JSON (notre base de données)
* La validation des entrées est faible sur certains points
* Quelques tests existent mais probablement pas assez

---

## Fichiers

* `book_app.py` - Point d'entrée principal de la CLI
* `books.py` - Classe BookCollection contenant la logique métier
* `utils.py` - Fonctions utilitaires pour l'interface et les entrées
* `data.json` - Exemple de données de livres
* `tests/test_books.py` - Tests pytest de base

---

## Lancer l'application

```bash
python book_app.py list
python book_app.py add
python book_app.py find
python book_app.py remove
python book_app.py help
```

## Lancer les tests

```bash
python -m pytest tests/
```

---

## Remarques

* Pas prêt pour la production (évidemment)
* Certaines parties du code pourraient être améliorées
* D'autres commandes pourraient être ajoutées plus tard
