{ config, lib, pkgs, ... }: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  cfg = config.rum.programs.hyprpanel;
in {
  options.rum.programs.hyprpanel = {
    enable = mkEnableOption "HyprPanel";

    package = mkPackageOption pkgs "hyprpanel" {
      default = if pkgs ? hyprpanel then "hyprpanel" else "hyprpanel-wrapper";
    };

    configFile = mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Path to a JSON configuration file for HyprPanel";
    };

    systemd.enable = mkEnableOption "systemd integration";
    hyprland.enable = mkEnableOption "Hyprland integration";
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".config/hyprpanel/config.json" = mkIf (cfg.configFile != null) {
      source = cfg.configFile;
      onChange = "${cfg.package}/bin/hyprpanel r";
    };

    systemd.user.services = mkIf cfg.systemd.enable {
      hyprpanel = {
        Unit = {
          Description = "A Bar/Panel for Hyprland with extensive customizability";
          Documentation = "https://hyprpanel.com";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };
        Service = {
          ExecStart = "${cfg.package}/bin/hyprpanel";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
          Restart = "on-failure";
          KillMode = "mixed";
        };
        Install = { WantedBy = [ config.wayland.systemd.target ]; };
      };
    };

    wayland.windowManager.hyprland.settings.exec-once = mkIf cfg.hyprland.enable [
      "${cfg.package}/bin/hyprpanel"
    ];
  };
}
