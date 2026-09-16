# Chapitre 16 : cycle de vie d'un worktree, de la création au nettoyage

Output worktree-new-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 10
Set TypingSpeed 45ms

Type "printf '\033[1;36mSECURITE\033[0m : une branche par worktree ; vérifiez les changements avant toute suppression.\n$ git status --short\n$ git branch --show-current\n'"
Enter
Sleep 3s

Type "printf '\033[1;36mCREATION\033[0m\n$ git worktree add -b feature/book-search ../book-app-search\nPreparing worktree (new branch '\''feature/book-search'\'')\n$ git worktree list\n... [main]\n... [feature/book-search]'"
Enter
Sleep 4s

Type "printf '\033[1;36mTRAVAIL\033[0m\n$ cd ../book-app-search\n$ git add samples/book-app-project/\n$ git commit -m '\''feat: add author search'\''\n[feature/book-search abc1234] feat: add author search'"
Enter
Sleep 4s

Type "printf '\033[1;36mFUSION\033[0m\n$ cd -\n$ git merge --no-ff feature/book-search\nMerge made by the '\''ort'\'' strategy.'"
Enter
Sleep 3s

Type "printf '\033[1;36mNETTOYAGE\033[0m\n$ git worktree remove ../book-app-search\n$ git worktree prune\n$ git worktree list\n... [main]\n✓ aucun worktree de démonstration restant'"
Enter
Sleep 5s

