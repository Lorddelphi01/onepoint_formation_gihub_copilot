# Instructions Copilot

Ces instructions guident GitHub Copilot lorsqu'il travaille dans ce dépôt.

## Contexte du projet

Il s'agit d'un **cours pédagogique pour débutants** enseignant GitHub Copilot CLI. Le dépôt contient des chapitres Markdown (00–08), des applications d'exemple en Python/C#/JavaScript, ainsi que des ressources complémentaires (images, GIFs de démonstration, glossaire). Ce n'est **pas** un produit logiciel — il s'agit de matériel pédagogique technique.

## Conventions de rédaction

- **Public visé** : Débutants sans expérience en IA/ML. Expliquez chaque terme technique lors de sa première utilisation.
- **Ton** : Amical, encourageant, pratique. Évitez le jargon sans explication.
- **Exemples** : Tous les blocs de code et commandes `copilot` doivent être prêts à copier-coller. Testez-les mentalement avant de les inclure.
- **Nommage** : Utilisez le kebab-case pour les noms de sessions, les noms de fichiers et les identifiants (par exemple, `book-app-review`, et non `book app review`).
- **Syntaxe des commandes** : Standardisez le format des options — utilisez `--flag=value` de manière cohérente lorsqu'une valeur est requise, `--flag` pour les booléens.
- **Précision** : Ne sur-spécifiez pas le comportement d'un outil qui peut varier selon les shells ou les systèmes d'exploitation. Décrivez ce que l'utilisateur verra, pas les détails d'implémentation.
- **Solutions de repli** : Lorsque vous mentionnez des exigences de version d'outil (par exemple, la version de la CLI `gh`), incluez toujours des instructions de mise à niveau ou une alternative manuelle.

## Conventions de contenu (issues des retours de revue de PR)

Ces patterns ont été extraits des retours réels de revue de PR et représentent des attentes récurrentes des mainteneurs :

- Lors de la présentation de workflows en plusieurs étapes, veillez à inclure toutes les étapes prérequises (par exemple, `git add` avant `git diff --staged`).
- Lors de l'introduction d'un concept avec un exemple, utilisez un nommage cohérent tout au long de la section — ne mélangez pas le kebab-case et les noms entre guillemets.
- Lors de la description du comportement d'une commande, alignez le niveau de précision sur celui des notes de version officielles — n'affirmez pas un comportement qui pourrait différer selon les environnements.
- Si une fonctionnalité nécessite une version minimale d'un outil, mentionnez la version ET proposez une solution de repli pour les utilisateurs qui ne peuvent pas encore effectuer la mise à niveau.

## Conventions pour le code d'exemple

- **Exemple principal** : Utilisez toujours `samples/book-app-project/` (Python) pour les exemples dans les chapitres.
- **Framework de test** : pytest — les fichiers de test se trouvent dans `samples/book-app-project/tests/` et suivent la convention de nommage `test_*.py`.
- **Version Python** : 3.10+ (selon `samples/book-app-project/pyproject.toml`).
- **Bugs intentionnels** : Les fichiers de `samples/book-app-buggy/` et `samples/buggy-code/` contiennent des **bugs délibérés** destinés aux exercices. Ne les corrigez jamais.

## Structure des chapitres

Chaque chapitre (00–08) suit le même schéma dans son `README.md` :

1. Analogie avec le monde réel
2. Concepts fondamentaux
3. Exemples pratiques
4. Exercice
5. Et ensuite ?

Ne vous écartez pas de cette structure lors de la modification ou de l'ajout de contenu de chapitre.

## Formatage Markdown

- Utilisez le Markdown GitHub-Flavored standard.
- Les images vont dans le répertoire `assets/` à la racine du dépôt.
- Utilisez des liens relatifs pour les références inter-chapitres (par exemple, `../04-development-workflows/README.md`).
- L'utilisation d'emojis est encouragée pour les titres de section (en cohérence avec le style existant).

## Matrice de maintenance

| Changement effectué | Fichiers à mettre à jour |
|---|---|
| Nouveau chapitre ajouté | `README.md` (tableau des cours), `AGENTS.md` (tableau de structure), `assets/learning-path.png` |
| Contenu de chapitre mis à jour | Le `README.md` du chapitre, vérifier les références croisées dans les chapitres adjacents |
| Nouvelle variante d'application d'exemple ajoutée | `AGENTS.md` (tableau de structure), répertoire `samples/`, références de chapitre concernées |
| Code d'application d'exemple modifié | `samples/book-app-project/tests/` (mettre à jour/ajouter des tests), chapitres référençant ce code |
| Bug ajouté intentionnellement aux exemples buggy | `samples/book-app-buggy/` ou `samples/buggy-code/` uniquement — NE PAS mettre à jour les tests |
| Nouveau skill ajouté | `.github/skills/{skill-name}/SKILL.md`, `samples/skills/` (copie d'exemple), Chapitre 06 |
| Nouveau modèle d'agent ajouté | `samples/agents/`, Chapitre 05 |
| Nouvelle configuration MCP ajoutée | `samples/mcp-configs/`, Chapitre 07 |
| Terme de glossaire introduit | `GLOSSARY.md` — ajouter la définition par ordre alphabétique |
| Scripts npm modifiés | `package.json`, `AGENTS.md` (section build) |
| Devcontainer mis à jour | `.devcontainer/devcontainer.json`, Chapitre 01 (instructions d'installation) |
| Image ou bannière modifiée | Répertoire `assets/`, tout README référençant l'image |
| Exigences de version de Copilot CLI modifiées | Chapitre 01, Chapitre 02, `.devcontainer/devcontainer.json` |
| Chapitre déplacé/reclassé entre pistes (tracks) | `README.md` (catalogue de formation), `AGENTS.md` (table « Pistes (tracks) du README ») |
