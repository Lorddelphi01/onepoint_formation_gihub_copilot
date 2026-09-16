# 08-putting-it-together: Démarrer Copilot en mode interactif demo
# Auto-generated from demos.json - Real copilot execution

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

# Launch copilot
Type "copilot"
Enter

# Wait for copilot to start
Sleep 5s

# Execute the prompt
Type "Generate a PR description for:"
Enter
Type "Branch: $BRANCH"
Enter
Type "Commits:"
Enter
Type "$COMMITS"
Enter
Type ""
Enter
Type "Include: Summary, Changes Made, Testing Done, Screenshots Needed"
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

# Exit cleanly
Ctrl+C
Sleep 1s
