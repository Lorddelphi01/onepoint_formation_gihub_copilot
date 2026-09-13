# Exemples de code bugué

Ce dossier contient du code volontairement bugué pour s'entraîner à la revue de code et au débogage avec GitHub Copilot CLI.

## Structure du dossier

```
buggy-code/
├── js/                    # Exemples JavaScript
│   ├── userService.js     # Gestion des utilisateurs avec 8 bugs
│   └── paymentProcessor.js # Traitement des paiements avec 8 bugs
└── python/                # Exemples Python
    ├── user_service.py    # Gestion des utilisateurs avec 10 bugs
    └── payment_processor.py # Traitement des paiements avec 12 bugs
```

## Démarrage rapide

### JavaScript

```bash
copilot

# Audit de sécurité
> Review @samples/buggy-code/js/userService.js for security issues

# Trouver tous les bugs
> Find all bugs in @samples/buggy-code/js/paymentProcessor.js
```

### Python

```bash
copilot

# Audit de sécurité
> Review @samples/buggy-code/python/user_service.py for security issues

# Trouver tous les bugs
> Find all bugs in @samples/buggy-code/python/payment_processor.py
```

## Catégories de bugs

### Communs aux deux langages

| Type de bug | Description |
|----------|-------------|
| Injection SQL | Entrées utilisateur directement intégrées dans les requêtes SQL |
| Secrets en dur | Clés API et mots de passe dans le code source |
| Conditions de concurrence | État partagé sans synchronisation adéquate |
| Journalisation de données sensibles | Mots de passe et numéros de carte dans les logs |
| Validation des entrées manquante | Aucune vérification sur les données fournies par l'utilisateur |
| Gestion des erreurs absente | Blocs try/catch ou try/except manquants |
| Comparaison de mots de passe faible | Comparaisons en clair ou vulnérables aux attaques temporelles |
| Vérifications d'autorisation manquantes | Opérations sans vérification des droits |

### Bugs spécifiques à Python

| Type de bug | Description |
|----------|-------------|
| Désérialisation Pickle | `pickle.loads()` sur des données non fiables |
| Injection via eval() | Entrées utilisateur passées à `eval()` |
| Chargement YAML non sécurisé | `yaml.load()` sans loader sécurisé |
| Injection de commande shell | Entrées utilisateur dans des appels `os.system()` |
| Hachage faible | MD5 pour le hachage des mots de passe |
| Générateur aléatoire non sécurisé | Module `random` utilisé à des fins de sécurité |

## Exercices pratiques

1. **Audit de sécurité** : Effectuez une revue de sécurité complète et listez toutes les vulnérabilités par niveau de gravité
2. **Corriger un bug** : Choisissez un bug critique, obtenez la correction proposée par Copilot, et comprenez pourquoi elle fonctionne
3. **Générer des tests** : Créez des tests qui détecteraient ces bugs avant le déploiement
4. **Refactoriser en toute sécurité** : Corrigez les bugs d'injection SQL tout en conservant les fonctionnalités
