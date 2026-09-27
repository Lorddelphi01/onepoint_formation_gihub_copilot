#!/bin/bash
# Faux `winget` utilisé uniquement par Dockerfile.windows-logic pour valider
# la LOGIQUE d'install-windows.ps1 (menu, flags, régénération du bloc de
# profil) sans jamais dépendre d'une vraie machine Windows. Il simule un
# gestionnaire de paquets en créant/supprimant de faux exécutables, pour que
# `Get-Command` (utilisé par Test-ToolInstalled) voie de vrais changements
# d'état — mais aucune installation réelle n'a lieu.
action="$1"
shift || true
id=""
while [ $# -gt 0 ]; do
    case "$1" in
        --id) id="$2"; shift 2 ;;
        *) shift ;;
    esac
done

name=""
case "$id" in
    Starship.Starship) name=starship ;;
    junegunn.fzf) name=fzf ;;
    sharkdp.bat) name=bat ;;
    ajeetdsouza.zoxide) name=zoxide ;;
    ellie.atuin) name=atuin ;;
esac

case "$action" in
    install)
        echo "[fake winget] install $id"
        if [ -n "$name" ]; then
            printf '#!/bin/bash\necho fake-%s\n' "$name" > "/usr/local/bin/$name"
            chmod +x "/usr/local/bin/$name"
        fi
        ;;
    uninstall)
        echo "[fake winget] uninstall $id"
        [ -n "$name" ] && rm -f "/usr/local/bin/$name"
        ;;
    list)
        echo ""
        ;;
esac
exit 0
