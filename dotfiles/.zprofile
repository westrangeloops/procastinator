# Auto-launch Hyprland on first TTY login (usually TTY1)
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec Hyprland
fi
