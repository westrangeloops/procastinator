{pkgs, ...}:
let 
  wallpaperScript = pkgs.writeScriptBin "niri-wallpaper" (builtins.readFile ./wallpaperAutoChange.sh);
in
{
  spawn-at-startup = [
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
    "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
    "${pkgs.wl-clipboard}/bin/wl-paste --watch walker --update-clipboard"
    "${pkgs.swww}/bin/swww-daemon"
    "kaneru"
    "uwsm finalize"
    "${wallpaperScript}/bin/niri-wallpaper"
    "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "${pkgs.dbus}/bin/dbus-update-activation-environment --all"
    "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome"
    "systemctl --user start hypridle"
    "systemctl --user restart arRPC.service"
    "systemctl --user start walker"
    "systemctl --user start cliphist"
  ];
}
