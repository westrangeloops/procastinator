{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) nullOr either str path attrs;

  cfg = config.rum.programs.hyprpanel;
  defaultPackage = pkgs.symlinkJoin {
    name = "hyprpanel-with-deps";
    paths = [
      (pkgs.hyprpanel or (throw "hyprpanel package not found"))
      pkgs.sass
      pkgs.sassc
    ];
  };
in {
  options.rum.programs.hyprpanel = {
    enable = mkEnableOption "HyprPanel";

    package = mkOption {
      type = lib.types.package;
      default = defaultPackage;
      description = "HyprPanel package to use";
    };

    config = mkOption {
      type = nullOr (either path (either str attrs));
      default = null;
      description = ''
        HyprPanel configuration as:
        - Path to JSON file
        - Raw JSON string
        - Nix attribute set
      '';
    };

    systemd.enable = mkEnableOption "systemd integration";
    hyprland.enable = mkEnableOption "Hyprland integration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Handle configuration file
    environment.etc."xdg/hyprpanel/config.json" = mkIf (cfg.config != null) (
      if lib.isString cfg.config then {
        text = cfg.config;
      } else if lib.isPath cfg.config then {
        source = cfg.config;
      } else {
        text = builtins.toJSON cfg.config;
      }
    );

    # Systemd user service
    systemd.user.services.hyprpanel = mkIf cfg.systemd.enable {
      enable = true;
      wantedBy = [ "config.wayland.systemd.target" ];
      partOf = [ "config.wayland.systemd.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hyprpanel";
        ExecReload = "${cfg.package}/bin/hyprpanel r";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    # Hyprland integration
    hj.rum.programs.hyprland.settings.exec-once = mkIf (cfg.hyprland.enable && config.hj.rum.programs.hyprland.enable) [
      "${cfg.package}/bin/hyprpanel"
    ];
  };
}

