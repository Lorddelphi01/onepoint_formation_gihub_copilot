<!--
---
id: CopilotCLI-Appendix-Additional-Context
title: !translate Fonctionnalités de contexte supplémentaires
description: !translate Apprendre à utiliser le contexte image et à gérer les permissions sur plusieurs répertoires dans GitHub Copilot CLI.
audience: Developers / Students / Terminal users
slug: additional-context-features
weight: 92
---
-->

# Fonctionnalités de contexte supplémentaires

> 📖 **Prérequis** : Terminez le [Chapitre 03 : Contexte et conversations](../03-context-conversations/README.md) avant de lire cette annexe.

Cette annexe couvre deux fonctionnalités de contexte supplémentaires : travailler avec des images et gérer les permissions sur plusieurs répertoires.

---

## Travailler avec des images

Vous pouvez inclure des images dans vos conversations en utilisant la syntaxe `@`. Copilot peut analyser des captures d'écran, des maquettes, des diagrammes et d'autres contenus visuels.

### Référence d'image de base

```bash
copilot

> @screenshot.png What's happening in this UI?

# Copilot analyse l'image et répond

> @mockup.png @current-design.png Compare these two designs

# Vous pouvez aussi glisser-déposer des images ou coller depuis le presse-papiers
```

### Formats d'image pris en charge

| Format | Idéal pour |
|--------|----------|
| PNG | Captures d'écran, maquettes d'interface, diagrammes |
| JPG/JPEG | Photos, images complexes |
| GIF | Diagrammes simples (première image seulement) |
| WebP | Captures d'écran web |

### Cas d'usage pratiques des images

**1. Débogage d'interface**
```bash
> @bug-screenshot.png The button doesn't align properly. What CSS might cause this?
```

**2. Implémentation de design**
```bash
> @figma-export.png Write the HTML and Tailwind CSS to match this design
```

**3. Analyse d'erreur**
```bash
> @error-screenshot.png What does this error mean and how do I fix it?
```

**4. Revue d'architecture**
```bash
> @whiteboard-diagram.png Convert this architecture diagram to a Mermaid diagram I can put in docs
```

**5. Comparaison avant/après**
```bash
> @before.png @after.png What changed between these two versions of the UI?
```

### Combiner des images avec du code

Les images deviennent encore plus puissantes lorsqu'elles sont combinées avec du contexte de code :

```bash
copilot

> @screenshot-of-bug.png @src/components/Header.jsx
> The header looks wrong in the screenshot. What's causing it in the code?
```

### Astuces sur les images

- **Recadrez les captures d'écran** pour ne montrer que les parties pertinentes (économise des jetons de contexte)
- **Utilisez un contraste élevé** pour les éléments d'interface que vous voulez faire analyser
- **Annotez si nécessaire** - entourez ou surlignez les zones problématiques avant de téléverser
- **Une image par concept** - plusieurs images fonctionnent, mais restez ciblé

---

## Schémas de permissions

Par défaut, Copilot peut accéder aux fichiers de votre répertoire courant. Pour des fichiers situés ailleurs, vous devez accorder l'accès.

### Ajouter des répertoires

```bash
# Ajouter un répertoire à la liste autorisée
copilot --add-dir /path/to/other/project

# Ajouter plusieurs répertoires
copilot --add-dir ~/workspace --add-dir /tmp
```

### Autoriser tous les chemins

```bash
# Désactiver entièrement les restrictions de chemin (à utiliser avec prudence)
copilot --allow-all-paths
```

### À l'intérieur d'une session

```bash
copilot

> /add-dir /path/to/other/project
# Vous pouvez maintenant référencer des fichiers de ce répertoire

> /list-dirs
# Voir tous les répertoires autorisés

> /yolo
# Alias rapide pour /allow-all on — approuve automatiquement toutes les invites de permission
```

### Pour l'automatisation

```bash
# Autoriser toutes les permissions pour des scripts non interactifs
copilot -p "Review @src/" --allow-all

# Ou utilisez l'alias facile à retenir
copilot -p "Review @src/" --yolo
```

### Quand vous avez besoin d'un accès multi-répertoires

Scénarios courants où vous aurez besoin de ces permissions :

1. **Travail en monorepo** - Comparer du code entre différents paquets
2. **Refactoring inter-projets** - Mettre à jour des bibliothèques partagées
3. **Projets de documentation** - Référencer plusieurs bases de code
4. **Travail de migration** - Comparer les anciennes et nouvelles implémentations

---

**[← Retour au Chapitre 03](../03-context-conversations/README.md)** | **[Retour aux annexes](README.md)**
