{ config, pkgs, inputs, ... }:
let
  ax-shell = pkgs.fetchFromGitHub {
        owner = "maotseantonio";
        repo = "Ax-Shell";
        rev = "15f6147d046d44073c62f8e50a64cbb7ab2aa13f";
        hash = "sha256-KsFOZ6S+e9GMiWsz+9FXoLwWkTQPSKmO79b7WG17rFU=";
    };

   fabric-bar = pkgs.writeScriptBin "fabric-bar" (builtins.readFile ./fabric.sh);

in
{
  home.file."${config.xdg.configHome}/Ax-Shell" = {
    source = ax-shell;
  };

  home.file.".local/share/fonts/tabler-icons.ttf" = {
    source = "${ax-shell}/assets/fonts/tabler-icons/tabler-icons.ttf";
  };

  home.file."${config.xdg.configHome}/matugen/config.toml" = {
    source = ./matugen.toml;
  };
   
  home.packages = with pkgs; [
    matugen
    cava
    fabric-bar
    #hyprsunset
    wlinhibit
    tesseract
    imagemagick
    nur.repos.HeyImKyu.fabric-cli
    (nur.repos.HeyImKyu.run-widget.override {
      extraPythonPackages = with python3Packages; [
        ijson
        pillow
        psutil
        requests
        setproctitle
        toml
        watchdog
        thefuzz
        numpy
        chardet
      ];
      extraBuildInputs = [
        nur.repos.HeyImKyu.fabric-gray
        networkmanager
        networkmanager.dev
        playerctl
      ];
    })
  ];
  

  wayland.windowManager.hyprland.settings.layerrule = [
    "noanim, fabric"
  ];
}
