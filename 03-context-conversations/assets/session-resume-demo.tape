# 03-context-conversations: Nommer une session et expliquer comment la reprendre
# Auto-generated from demos.json - Real copilot execution

Output session-resume-demo.gif

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
Type "/rename context-session-demo"
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
Type "Explain why naming a session helps, then show the command I would use later to resume it by name: copilot --resume=context-session-demo"
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
