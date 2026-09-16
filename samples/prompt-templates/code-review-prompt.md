# Template : revue de code

Remplissez les emplacements `<...>` puis collez le résultat dans une session `copilot`.

---

Relis <fichier ou module, ex. samples/book-app-project/utils.py> en te concentrant sur :

- <critère 1, ex. la gestion des erreurs et des cas limites>
- <critère 2, ex. la cohérence avec les conventions déjà utilisées dans le fichier>
- <critère 3, ex. la couverture par les tests existants dans tests/>

Contraintes :

- Ne propose pas de réécriture complète si des correctifs ciblés suffisent
- Signale explicitement si un point te semble hors du périmètre de cette revue

Format de sortie attendu :

Une liste des points relevés, classés par sévérité (bloquant / à corriger / suggestion), chacun avec le numéro de ligne concerné et une explication en une phrase.
