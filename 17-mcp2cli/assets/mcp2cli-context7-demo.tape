# Chapitre 17 : parcours reproductible avec le profil Context7

Output mcp2cli-context7-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 10
Set TypingSpeed 35ms

Type "printf '\033[1;36m1. DECOUVRIR\033[0m\n$ context7 ls --tools\nresolve-library-id  Resolves a package name to a Context7 library ID\nquery-docs          Retrieves Context7 documentation\n'"
Enter
Sleep 3s

Type "printf '\033[1;36m2. INSPECTER LA SIGNATURE\033[0m\n$ context7 resolve-library-id --help\n--library-name LIBRARY_NAME\n--query QUERY\n'"
Enter
Sleep 3s

Type "printf '\033[1;36m3. INVOQUER\033[0m\n$ context7 --json resolve-library-id --library-name=pytest --query=\"pytest fixture scopes\"\nContext7-compatible library ID: /pytest-dev/pytest\n'"
Enter
Sleep 3s

Type "printf '\033[1;36m4. COMPARER AVEC COPILOT\033[0m\n$ copilot\n> Use Context7 resolve-library-id for pytest / pytest fixture scopes.\n/pytest-dev/pytest\n\nMeme outil, meme requete, meme identifiant.\n'"
Enter
Sleep 4s
