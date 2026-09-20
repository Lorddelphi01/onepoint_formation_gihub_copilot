# 08-putting-it-together: Générateur de description de PR (Bonus : modèles de production)
# Corrige la version précédente : $BRANCH/$COMMITS étaient tapés littéralement
# DANS le TUI interactif de copilot (jamais expansés par bash). Ici la commande
# `copilot -p "..."` est tapée au shell externe, comme dans le README : bash
# expanse réellement les variables avant que copilot ne les voie.
# Prérequis : exécuté depuis la racine du dépôt. Crée une branche jetable avec
# un vrai commit dans samples/book-app-project pour que $COMMITS ne soit pas vide.

Output putting-it-together-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 15

# Human typing speed
Set TypingSpeed 60ms

# Préparer un vrai diff à décrire
Type "cd samples/book-app-project"
Enter
Sleep 1s
Type "git checkout -b demo/pr-description-bonus"
Enter
Sleep 1s
Type "sed -i '1i # TODO: valider les années de publication hors plage' books.py"
Enter
Type "git add -A && git commit -m 'Add TODO marker for year validation'"
Enter
Sleep 2s

# Résoudre BRANCH et COMMITS au shell externe (vraie expansion, pas dans le TUI)
Type "BRANCH=$(git branch --show-current)"
Enter
Type "COMMITS=$(git log main..$BRANCH --oneline)"
Enter
Sleep 1s

# Appel non-interactif copilot -p, comme dans le README
Type "copilot -p \"Generate a PR description for:"
Enter
Type "Branch: $BRANCH"
Enter
Type "Commits:"
Enter
Type "$COMMITS"
Enter
Type ""
Enter
Type "Include: Summary, Changes Made, Testing Done, Screenshots Needed\""
Sleep 2s
Enter

# Wait for response (with periodic nudges to keep input visible)
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 1s

# Nudge TUI to scroll to input area
Type " "
Backspace
Sleep 2s

# Nettoyage : revenir sur main, supprimer la branche jetable
Ctrl+C
Sleep 1s
Type "cd - && git -C samples/book-app-project checkout main && git -C samples/book-app-project branch -D demo/pr-description-bonus"
Enter
