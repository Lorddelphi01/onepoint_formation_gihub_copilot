# Templates de prompts réutilisables

Trois templates de prompts prêts à remplir, utilisés par le [Chapitre 15 : Rédiger des instructions IA efficaces et réutilisables](../../15-prompt-engineering/README.md). Chacun cible `samples/book-app-project/`, mais la structure (objectif / contraintes / format de sortie attendu) est pensée pour être copiée et adaptée à n'importe quel projet.

## Comment les utiliser

1. Ouvrez le fichier du template concerné
2. Remplissez chaque emplacement entre `<...>`
3. Collez le résultat dans une session `copilot`

```bash
cat code-review-prompt.md
# remplissez les emplacements <...> dans un éditeur, puis :
copilot
> <collez ici le contenu rempli>
```

## Templates disponibles

| Fichier | Usage |
|---|---|
| [`code-review-prompt.md`](./code-review-prompt.md) | Cadrer une revue de code sur un fichier ou un module précis |
| [`bug-fix-prompt.md`](./bug-fix-prompt.md) | Décrire un bug avec des critères d'acceptation avant de demander un correctif |
| [`feature-request-prompt.md`](./feature-request-prompt.md) | Cadrer une nouvelle fonctionnalité avec son contexte métier et le format de sortie attendu |

> 💡 Ces templates ne modifient aucun fichier de `samples/book-app-project/` — ce sont de simples fichiers Markdown à copier-coller dans Copilot CLI.
