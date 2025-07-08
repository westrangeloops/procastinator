#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\
#


config="$HOME/.config/gtk-3.0/settings.ini"
if [ ! -f $HOME/.config/ml4w/settings/dock-disabled ]; then
    killall nwg-dock-hyprland
    sleep 0.5
    prefer_dark_theme="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//')"
    if [ $prefer_dark_theme == 0 ]; then
        style="style.css"
    else
        style="style.css"
    fi
    nwg-dock-hyprland -lp start -i 28 -w 10 -mb 6 -ml 10 -mr 10  -x -r -s $style -c  "rofi -show drun"
else
    echo ":: Dock disabled"
fi
