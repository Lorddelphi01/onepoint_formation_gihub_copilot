# 16-parallel-worktrees: /fork — fourcher la conversation sans nouveau dossier disque
# Montre l'absence de nouveau worktree sur disque, contrairement à /worktree new.

Output fork-demo.gif

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

Type "cd samples/book-app-project"
Enter
Type "git worktree list"
Enter
Sleep 2s

Type "copilot"
Enter
Sleep 5s

Type "/fork exploration-tri-par-date"
Sleep 1s
Enter
Sleep 6s
Hide
Type " "
Backspace
Show
Sleep 2s

Ctrl+C
Sleep 1s

# Aucun nouveau dossier n'est apparu
Type "git worktree list"
Enter
Sleep 2s
