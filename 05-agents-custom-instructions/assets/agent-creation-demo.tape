# 05-agents-custom-instructions: Créer un agent personnalisé doc-writer puis le retrouver dans /agent
# Auto-generated from demos.json - Real copilot execution

Output agent-creation-demo.gif

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

# Prompt 1
Type "Create a new agent file at .github/agents/doc-writer.agent.md with YAML frontmatter (name: doc-writer, description: Technical writer for clear Python documentation) and instructions to always write Google-style docstrings with parameter types, return values, and one usage example"
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
Sleep 2s

# Prompt 2
Type "/agent"
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
Sleep 2s

# Nudge TUI to scroll to input area
Type " "
Backspace
Sleep 2s

# Exit cleanly
Ctrl+C
Sleep 1s
