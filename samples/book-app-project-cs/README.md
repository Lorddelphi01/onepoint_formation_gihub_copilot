# Application de gestion de livres

*(Ce README est volontairement rudimentaire afin que tu puisses l'améliorer avec GitHub Copilot CLI)*

Une application console C# pour gérer les livres que tu as ou que tu veux lire.
Elle peut ajouter, supprimer, et lister des livres. Elle peut aussi les marquer comme lus.

---

## Fonctionnalités actuelles

* Lit les livres depuis un fichier JSON (notre base de données)
* La vérification des entrées est faible dans certains cas
* Quelques tests existent mais probablement pas assez

---

## Fichiers

* `Program.cs` - Point d'entrée principal du CLI
* `Models/Book.cs` - Classe modèle Book
* `Services/BookCollection.cs` - Classe BookCollection contenant la logique de données
* `data.json` - Exemple de données de livres
* `Tests/BookCollectionTests.cs` - Tests xUnit

---

## Exécuter l'application

```bash
dotnet run -- list
dotnet run -- add
dotnet run -- find
dotnet run -- remove
dotnet run -- help
```

## Exécuter les tests

```bash
cd Tests
dotnet test
```

---

## Remarques

* Pas prêt pour la production (évidemment)
* Certaines parties du code pourraient être améliorées
* Des commandes supplémentaires pourraient être ajoutées plus tard
