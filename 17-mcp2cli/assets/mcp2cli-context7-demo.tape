# Chapitre 17 : parcours reproductible avec l'alias Context7 (mcp2cli v0.1.8)
# La version précédente fabriquait sa sortie avec `printf` (texte inventé,
# jamais exécuté) — cette version lance les vraies commandes.
# Prérequis : mcp2cli configuré au préalable avec
#   mcp2cli config init --name context7 --app bridge --link create context7 ...
# (voir la section "Configurer l'alias Context7" du README) et une connexion
# réelle au serveur MCP Context7.

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
Set TypingSpeed 60ms

# 1. Découvrir les outils exposés par l'alias
Type "context7 ls --tools"
Enter
Sleep 3s

# 2. Inspecter la signature d'un outil
Type "context7 resolve-library-id --help"
Enter
Sleep 3s

# 3. Invoquer réellement l'outil MCP, sans passer par un modèle
Type "context7 --json resolve-library-id --library-name=pytest --query=\"pytest fixture scopes\""
Enter
Sleep 3s

# 4. Comparer avec ce que Copilot recevrait pour la même requête
Type "context7 --json query-docs --library-id=/pytest-dev/pytest --query=\"pytest fixture scopes\""
Enter
Sleep 3s
