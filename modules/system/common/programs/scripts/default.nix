{pkgs, ...}: let
  #wall-change = pkgs.writeShellScriptBin "wall-change" (builtins.readFile ./scripts/wall-change.sh);
  #wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (builtins.readFile ./scripts/wallpaper-picker.sh);
  runbg = pkgs.writeShellScriptBin "runbg" (builtins.readFile ./scripts/runbg.sh);
  music = pkgs.writeShellScriptBin "music" (builtins.readFile ./scripts/music.sh);
  lofi = pkgs.writeScriptBin "lofi" (builtins.readFile ./scripts/lofi.sh);

  toggle_blur = pkgs.writeScriptBin "toggle_blur" (builtins.readFile ./scripts/toggle_blur.sh);
  toggle_oppacity = pkgs.writeScriptBin "toggle_oppacity" (builtins.readFile ./scripts/toggle_oppacity.sh);
  toggle_waybar = pkgs.writeScriptBin "toggle_waybar" (builtins.readFile ./scripts/toggle_waybar.sh);
  toggle_float = pkgs.writeScriptBin "toggle_float" (builtins.readFile ./scripts/toggle_float.sh);

  maxfetch = pkgs.writeScriptBin "maxfetch" (builtins.readFile ./scripts/maxfetch.sh);
#  rxfetch = pkgs.writeScriptBin "rxfetch" (builtins.readFile ./scripts/rxfetch.sh);
  compress = pkgs.writeScriptBin "compress" (builtins.readFile ./scripts/compress.sh);
  extract = pkgs.writeScriptBin "extract" (builtins.readFile ./scripts/extract.sh);

  shutdown-script = pkgs.writeScriptBin "shutdown-script" (builtins.readFile ./scripts/shutdown-script.sh);

  show-keybinds = pkgs.writeScriptBin "show-keybinds" (builtins.readFile ./scripts/keybinds.sh);

  vm-start = pkgs.writeScriptBin "vm-start" (builtins.readFile ./scripts/vm-start.sh);

  ascii = pkgs.writeScriptBin "ascii" (builtins.readFile ./scripts/ascii.sh);
  cli-convert = pkgs.writeScriptBin "cli-convert" (builtins.readFile ./scripts/cli-convert.sh);
  record = pkgs.writeScriptBin "record" (builtins.readFile ./scripts/record.sh);
  statusbar = pkgs.writeScriptBin "statusbar" (builtins.readFile ./scripts/statusbar);
  apply-config = pkgs.writeScriptBin "apply-config" (builtins.readFile ./scripts/apply-config.sh);
  fuzzel-clip = pkgs.writeScriptBin "fuzzel-clip" (builtins.readFile ./scripts/fuzzel-clip.sh);
  cliphist-rofi-img = pkgs.writeScriptBin "cliphist-rofi-img" (builtins.readFile ./scripts/rofi-clip-img.sh);
  eww-bar = pkgs.writeScriptBin "eww-bar" (builtins.readFile ./scripts/eww-bar);
  niri-edit = pkgs.writeScriptBin "niri-edit" (builtins.readFile ./scripts/niri-edit);
  wlogout-new = pkgs.writeScriptBin "wlogout-new" (builtins.readFile ./scripts/wlogout-new);
  brightness = pkgs.writeScriptBin "brightness" (builtins.readFile ./scripts/brightness);
in {
  hj.packages = with pkgs; [
    # wall-change
    # wallpaper-picker
    runbg
    music
    lofi
    toggle_blur
    toggle_oppacity
    toggle_waybar
    toggle_float
    maxfetch
#    rxfetch
    compress
    extract
    shutdown-script
    vm-start
    ascii
    record
    statusbar
    apply-config
    fuzzel-clip
    eww-bar
    wlogout-new
    niri-edit
    brightness
    cliphist-rofi-img
  ];
}
