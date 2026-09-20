# 14-token-consumption-analysis: /limits et --max-ai-credits — plafonner son budget nativement
# Le fichier rtk-gain-demo.gif existant est corrompu (flux GIF tronqué, ne
# s'ouvre plus) : à régénérer séparément en plus de cette nouvelle démo.

Output copilot-limits-demo.gif

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

Type "copilot"
Enter
Sleep 5s

Type "/limits"
Sleep 1s
Enter
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 2s

Ctrl+C
Sleep 1s

# Équivalent non-interactif, utile en CI
Type "copilot --max-ai-credits=500 -p \"Résume les 5 derniers commits de ce dépôt\""
Enter
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
Sleep 2s
