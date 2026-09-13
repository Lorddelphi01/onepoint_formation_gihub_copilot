# Book App - Version bogguée

Ce répertoire contient une version intentionnellement bogguée de l'application de gestion de livres, destinée aux exercices de débogage du chapitre 03.

**NE corrige PAS ces bugs directement.** Ils existent pour que les apprenants puissent s'entraîner à utiliser GitHub Copilot CLI pour identifier et déboguer des problèmes.

---

## Bugs intentionnels

### books_buggy.py

| # | Bug | Symptôme |
|---|-----|---------|
| 1 | `find_book_by_title()` utilise une correspondance exacte de casse | Rechercher "the hobbit" ne renvoie rien même si "The Hobbit" existe |
| 2 | `save_books()` n'utilise pas de gestionnaire de contexte | Fuite de descripteur de fichier ; pas de gestion d'erreur pour les problèmes de permission |
| 3 | `add_book()` n'a aucune validation de l'année | Accepte des années négatives, l'année 0, et des années très éloignées dans le futur |
| 4 | `remove_book()` utilise une vérification de sous-chaîne avec `in` | Supprimer "Dune" correspond aussi à "Dune Messiah" et le supprime |
| 5 | `mark_as_read()` marque TOUS les livres comme lus | Bug de variable de boucle - itère sur tous les livres au lieu de la seule correspondance |
| 6 | `find_by_author()` exige une correspondance exacte | "Tolkien" ne trouvera pas "J.R.R. Tolkien" (pas de correspondance partielle) |

### book_app_buggy.py

| # | Bug | Symptôme |
|---|-----|---------|
| 7 | La numérotation de `show_books()` commence à 0 | Les livres s'affichent comme "0. ...", "1. ..." au lieu de "1. ...", "2. ..." |
| 8 | `handle_add()` accepte un titre/auteur vide | Il est possible d'ajouter des livres avec des titres et auteurs vides |
| 9 | `handle_remove()` affiche toujours un succès | Indique "Book removed" même quand le livre n'a pas été trouvé |

---

## Comment l'utiliser dans le chapitre 03

```bash
copilot

> @samples/book-app-buggy/books_buggy.py Users report that searching for
> "The Hobbit" returns no results even though it's in the data. Debug why.

> @samples/book-app-buggy/book_app_buggy.py When I remove a book that
> doesn't exist, the app says it was removed. Help me find why.
```
