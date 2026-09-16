# Chapitre 09 : sandbox Docker et politique réseau restrictive
Output docker-sandbox-demo.gif

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

Type "printf '\033[1;36mSANDBOX DOCKER\033[0m\n$ sbx policy init deny-all\nNetwork policy: deny all outbound traffic\n$ sbx policy allow network api.githubcopilot.com\n$ sbx policy allow network github.com\n$ sbx policy allow network api.github.com\n\n$ sbx run copilot samples/book-app-project -- -p \"Review @book_app.py for critical issues only.\"\nSandbox started with isolated workspace\n✓ Copilot can reach its allowed services\n✓ Files outside samples/book-app-project are not accessible'"
Enter
Sleep 7s
