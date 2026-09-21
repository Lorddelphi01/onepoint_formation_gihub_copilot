# 10-obsidian-rag: vérifier la connexion des serveurs MCP obsidian + smart-connections
# Prérequis externes : un vault Obsidian réel avec le plugin Local REST API
# actif, OBSIDIAN_API_KEY exporté, et smart-connections-mcp installable via npx.
# Sans ces prérequis, /mcp show n'affichera pas les deux serveurs "activés".

Output obsidian-mcp-config-demo.gif

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

Type "/mcp config"
Sleep 1s
Enter
Sleep 8s
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

Type "/mcp show"
Enter
Sleep 3s
Hide
Type " "
Backspace
Show
Sleep 2s

Ctrl+C
Sleep 1s
