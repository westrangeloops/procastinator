
{ config, pkgs, ... }:

{

  # Enable hyprpanel
  rum.programs.hyprpanel = {
    enable = true;
    package = pkgs.hyprpanel; # Or your custom package
    hyprland.enable = true;

    settings = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" "windowtitle" ];
          middle = [ "media" ];
          right = [ "volume" "network" "bluetooth" "battery" "systray" "clock" "notifications" ];
        };
      };
      # Add other config as needed
      theme = {
        name = "catppuccin_mocha";
        bar = {
          location = "top";
        };
      };
    };
  };
}
