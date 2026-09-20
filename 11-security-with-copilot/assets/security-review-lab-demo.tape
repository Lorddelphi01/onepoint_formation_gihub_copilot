# 11-security-with-copilot: labo complet /security-review sur samples/buggy-code
# Remplace security-review-demo.gif, qui était une illustration fabriquée
# (voir sa légende "Illustration : les résultats réels peuvent varier").
# Entièrement autonome : copie le fichier vulnérable dans un dossier temporaire,
# ne modifie jamais samples/buggy-code/.
# Prérequis : Copilot CLI avec le mode expérimental activé (/experimental)
# si /security-review n'apparaît pas dans /help.

Output security-review-lab-demo.gif

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

Type `LAB_DIR="$(mktemp -d)"`
Enter
Type `git init "$LAB_DIR"`
Enter
Type `cp samples/buggy-code/python/user_service.py "$LAB_DIR/user_service.py"`
Enter
Type "cd \"$LAB_DIR\""
Enter
Type "git add user_service.py"
Enter
Sleep 2s

Type "copilot"
Enter
Sleep 5s

Type "/security-review"
Sleep 1s
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

Type " "
Backspace
Sleep 2s

Ctrl+C
Sleep 1s
