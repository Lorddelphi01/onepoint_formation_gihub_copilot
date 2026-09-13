<!--
---
id: CopilotCLI-07-Custom-MCP-Server
title: !translate Créer un serveur MCP personnalisé
description: !translate Créez un serveur MCP personnalisé simple en Python pour connecter GitHub Copilot CLI à vos propres API.
audience: Developers / Students / Terminal users
slug: building-a-custom-mcp-server
weight: 71
---
-->

# Construire un serveur MCP personnalisé

> ⚠️ **Ce contenu est entièrement facultatif.** Vous pouvez être très productif avec Copilot CLI en utilisant uniquement les serveurs MCP préconstruits (GitHub, filesystem, Context7). Ce guide s'adresse aux développeurs qui veulent connecter Copilot à des API internes personnalisées. Consultez le [cours MCP for Beginners](https://github.com/microsoft/mcp-for-beginners) pour plus de détails.
>
> **Prérequis :**
> - À l'aise avec Python
> - Compréhension des patterns `async`/`await`
> - `pip` disponible sur votre système (inclus dans ce conteneur de développement)
>
> **[← Retour au Chapitre 07 : Serveurs MCP](README.md)**

---

Vous voulez connecter Copilot à vos propres API ? Voici comment construire un serveur MCP simple en Python qui recherche des informations sur des livres, en lien avec le projet d'application de gestion de livres que vous utilisez tout au long de ce cours.

## Configuration du projet

```bash
mkdir book-lookup-mcp-server
cd book-lookup-mcp-server
pip install mcp
```

> 💡 **Qu'est-ce que le paquet `mcp` ?** C'est le SDK Python officiel pour construire des serveurs MCP. Il gère les détails du protocole afin que vous puissiez vous concentrer sur vos outils.

## Implémentation du serveur

Créez un fichier appelé `server.py` :

```python
# server.py
import json
from mcp.server.fastmcp import FastMCP

# Créer le serveur MCP
mcp = FastMCP("book-lookup")

# Exemple de base de données de livres (dans un vrai serveur, cela pourrait interroger une API ou une base de données)
BOOKS_DB = {
    "978-0-547-92822-7": {
        "title": "The Hobbit",
        "author": "J.R.R. Tolkien",
        "year": 1937,
        "genre": "Fantasy",
    },
    "978-0-451-52493-5": {
        "title": "1984",
        "author": "George Orwell",
        "year": 1949,
        "genre": "Dystopian Fiction",
    },
    "978-0-441-17271-9": {
        "title": "Dune",
        "author": "Frank Herbert",
        "year": 1965,
        "genre": "Science Fiction",
    },
}


@mcp.tool()
def lookup_book(isbn: str) -> str:
    """Look up a book by its ISBN and return title, author, year, and genre."""
    book = BOOKS_DB.get(isbn)
    if book:
        return json.dumps(book, indent=2)
    return f"No book found with ISBN: {isbn}"


@mcp.tool()
def search_books(query: str) -> str:
    """Search for books by title or author. Returns all matching results."""
    query_lower = query.lower()
    results = [
        {**book, "isbn": isbn}
        for isbn, book in BOOKS_DB.items()
        if query_lower in book["title"].lower()
        or query_lower in book["author"].lower()
    ]
    if results:
        return json.dumps(results, indent=2)
    return f"No books found matching: {query}"


@mcp.tool()
def list_all_books() -> str:
    """List all books in the database with their ISBNs."""
    books_list = [
        {"isbn": isbn, "title": book["title"], "author": book["author"]}
        for isbn, book in BOOKS_DB.items()
    ]
    return json.dumps(books_list, indent=2)


if __name__ == "__main__":
    mcp.run()
```

**Ce qui se passe ici :**

| Élément | Ce qu'il fait |
|------|-------------|
| `FastMCP("book-lookup")` | Crée un serveur nommé « book-lookup » |
| `@mcp.tool()` | Enregistre une fonction comme un outil que Copilot peut appeler |
| Annotations de type + docstrings | Indiquent à Copilot ce que fait chaque outil et quels paramètres il nécessite |
| `mcp.run()` | Démarre le serveur et écoute les requêtes |

> 💡 **Pourquoi des décorateurs ?** Le décorateur `@mcp.tool()` est tout ce dont vous avez besoin. Le SDK MCP lit automatiquement le nom de votre fonction, ses annotations de type et sa docstring pour générer le schéma de l'outil. Aucun schéma JSON manuel nécessaire !

## Configuration

Ajoutez ceci à votre `~/.copilot/mcp-config.json` :

```json
{
  "mcpServers": {
    "book-lookup": {
      "type": "local",
      "command": "python3",
      "args": ["./book-lookup-mcp-server/server.py"],
      "tools": ["*"]
    }
  }
}
```

## Utilisation

```bash
copilot

> Look up the book with ISBN 978-0-547-92822-7

{
  "title": "The Hobbit",
  "author": "J.R.R. Tolkien",
  "year": 1937,
  "genre": "Fantasy"
}

> Search for books by Orwell

[
  {
    "title": "1984",
    "author": "George Orwell",
    "year": 1949,
    "genre": "Dystopian Fiction",
    "isbn": "978-0-451-52493-5"
  }
]

> List all available books

[Affiche tous les livres de la base de données avec leurs ISBN]
```

## Prochaines étapes

Une fois que vous avez construit un serveur basique, vous pouvez :

1. **Ajouter plus d'outils** - Chaque fonction `@mcp.tool()` devient un outil que Copilot peut appeler
2. **Connecter de vraies API** - Remplacer le faux `BOOKS_DB` par de véritables appels API ou requêtes de base de données
3. **Ajouter une authentification** - Gérer les clés API et jetons de manière sécurisée
4. **Partager votre serveur** - Publier sur PyPI pour que d'autres puissent l'installer avec `pip`

## Ressources

> 📚 **Spécification à jour** *(depuis Copilot CLI v1.0.81)* : Copilot CLI prend en charge la spécification MCP 2026-07-28 (CLI, SDK, IDE, clients en mémoire). Votre serveur personnalisé communique avec Copilot via le même protocole que les serveurs préconstruits (GitHub, filesystem, Context7).

- [SDK Python MCP](https://github.com/modelcontextprotocol/python-sdk)
- [SDK TypeScript MCP](https://github.com/modelcontextprotocol/typescript-sdk)
- [Exemples de serveurs MCP](https://github.com/modelcontextprotocol/servers)
- [Cours MCP for Beginners](https://github.com/microsoft/mcp-for-beginners)

---

**[← Retour au Chapitre 07 : Serveurs MCP](README.md)**
