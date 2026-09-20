# 16-parallel-worktrees: git worktree lock/unlock — protéger un worktree en cours d'usage
# Commandes git natives, aucune dépendance à Copilot CLI. Entièrement rejouable.

Output worktree-lock-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 10
Set TypingSpeed 60ms

Type "git worktree add -b fix/isbn-validation-lock-demo ../book-app-hotfix"
Enter
Sleep 2s

Type "git worktree lock ../book-app-hotfix --reason 'Session Copilot CLI en cours'"
Enter
Sleep 1s

Type "git worktree remove ../book-app-hotfix"
Enter
Sleep 2s

Type "git worktree unlock ../book-app-hotfix"
Enter
Sleep 1s

Type "git worktree remove ../book-app-hotfix"
Enter
Sleep 2s
