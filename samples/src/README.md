# Exemple de code source (Héritage - Référence optionnelle)

> **Remarque** : L'exemple principal de ce cours est l'**application Python de collection de livres** dans `../book-app-project/`. Ces fichiers JS/React proviennent d'une version antérieure du cours et sont conservés comme matériel de référence optionnel pour les apprenants souhaitant des exemples en JS.

Ce dossier contient des fichiers source d'exemple. Ce ne sont que des échantillons, pas une application complète destinée à être exécutée.

## Structure

```
src/
├── api/           # Gestionnaires de routes API
│   ├── auth.js    # Points d'accès d'authentification
│   └── users.js   # Points d'accès CRUD utilisateurs
├── auth/          # Gestionnaires d'authentification côté client
│   ├── login.js   # Logique du formulaire de connexion
│   └── register.js # Logique du formulaire d'inscription
├── components/    # Composants React
│   ├── Button.jsx # Bouton réutilisable
│   └── Header.jsx # En-tête de l'application avec navigation
├── models/        # Modèles de données
│   └── User.js    # Modèle utilisateur
├── services/      # Logique métier
│   ├── productService.js
│   └── userService.js
├── utils/         # Fonctions utilitaires
│   └── helpers.js
├── index.js       # Point d'entrée de l'application
└── refactor-me.js # Exercice de refactoring pour débutant (Chapitre 04)
```

## Utilisation

Ces fichiers sont référencés dans les exemples du cours à l'aide de la syntaxe `@` :

```bash
copilot

> Explain what @samples/src/utils/helpers.js does
> Review @samples/src/api/ for security issues
> Compare @samples/src/auth/login.js and @samples/src/auth/register.js
```

## Exercice de refactoring

Le fichier `refactor-me.js` est spécifiquement conçu pour les exercices de refactoring du Chapitre 04 :

```bash
copilot

> @samples/src/refactor-me.js Rename the variable 'x' to something more descriptive
> @samples/src/refactor-me.js This function is too long. Split it into smaller functions.
> @samples/src/refactor-me.js Remove any unused variables
```

## Remarques

- Les fichiers contiennent des TODO volontaires et de petits problèmes à faire découvrir par Copilot lors des revues
- Il s'agit de code de démonstration qui n'est pas conçu pour réellement s'exécuter. PAS prêt pour la production
- Utilisé pour apprendre la syntaxe de référence de fichier `@`
