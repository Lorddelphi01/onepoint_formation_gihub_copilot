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

---

## Exemple réussi

**Prompt rempli :**

> Relis `samples/book-app-project/utils.py` en te concentrant sur la validation de l'année saisie, le comportement lorsque la saisie n'est pas un nombre, et la cohérence avec les messages affichés à l'utilisateur. Ne propose pas de réécriture complète si des correctifs ciblés suffisent. Retourne une liste classée par sévérité, avec le numéro de ligne et une explication par point.

**Sortie attendue :** une liste courte et vérifiable, par exemple un point « à corriger » qui indique que la saisie non numérique est remplacée par `0`, son numéro de ligne et la conséquence pour l'utilisateur. Si aucun point n'est bloquant, la réponse le dit explicitement.

## Contre-exemple

> Relis `utils.py` et améliore tout ce qui ne va pas.

Ce prompt échoue car ni le périmètre, ni les critères, ni le format de réponse ne sont définis. Copilot CLI peut proposer une réécriture complète, ignorer la validation de l'année ou fournir une réponse impossible à vérifier.
