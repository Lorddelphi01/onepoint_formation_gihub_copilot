# 03-context-conversations: Autoriser un répertoire supplémentaire avant de le référencer
# Auto-generated from demos.json - Real copilot execution

Output add-dir-context-demo.gif

Set FontSize 18
Set Width 1000
Set Height 600
Set Theme "Dracula"
Set Padding 20
Set BorderRadius 8
Set Margin 10
Set MarginFill "#282a36"
Set Framerate 10

# Human typing speed
Set TypingSpeed 60ms

# Launch copilot
Type "copilot"
Enter

# Wait for copilot to start
Sleep 5s

# Prompt 1
Type "/add-dir .."
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

# Prompt 2
Type "Explain the difference between the current working directory, @ references, and --add-dir. Give one safe example of referencing a file in the added parent directory."
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

# Nudge TUI to scroll to input area
Type " "
Backspace
Sleep 2s

# Exit cleanly
Ctrl+C
Sleep 1s
