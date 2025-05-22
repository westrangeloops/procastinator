{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  hyprlockPackage = config.hj.rum.programs.hyprlock.package;
  hypridlePackage = config.hj.rum.programs.hypridle.package;

  cfg = config.myOptions.hypridle;
in
{
  options.myOptions.hypridle = {
    enable = mkEnableOption "hypridle service";
  };

  config = mkIf cfg.enable {
    hj.rum.programs.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 3300;
            on-timeout = "hyprctl dispatch dpms off";
          }
          {
            timeout = 5350;
            on-timeout = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off";
            on-resume = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
