# 16-parallel-worktrees: /worktree vs /move — laisser ou emporter les modifs non committées
# Prérequis : nécessite Copilot CLI v1.0.79+ pour les commandes /worktree et /move.
# Montre la différence documentée dans le README : /worktree laisse les modifs
# non committées derrière, /move les emporte dans le nouveau worktree.

Output worktree-vs-move-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 15
Set TypingSpeed 60ms

# Une modification non committée, à observer avant/après
Type "cd samples/book-app-project"
Enter
Type "sed -i '1i # WIP: validation ISBN en cours' books.py"
Enter
Type "git status --short"
Enter
Sleep 2s

Type "copilot"
Enter
Sleep 5s

Type "/worktree fix/isbn-validation"
Sleep 1s
Enter
Sleep 8s
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

Ctrl+C
Sleep 1s

# Retour dans le worktree d'origine : la modif est restée derrière
Type "git status --short"
Enter
Sleep 2s

Type "copilot"
Enter
Sleep 5s

Type "/move fix/isbn-validation-v2"
Sleep 1s
Enter
Sleep 8s
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

Ctrl+C
Sleep 1s

# Nettoyage
Type "git status --short"
Enter
Sleep 1s
