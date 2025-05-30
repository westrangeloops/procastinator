
{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption optionalAttrs;
  inherit (lib.types) nullOr either str path attrs;
  inherit (lib.meta) getExe;

  jsonFormat = pkgs.formats.json {};

  cfg = config.rum.programs.hyprpanel;

  defaultPackage = (pkgs.hyprpanel or null);
in
{
  options.rum.programs.hyprpanel = {
    enable = mkEnableOption "HyprPanel";

    package = mkOption {
      type = lib.types.package;
      default = defaultPackage;
      description = "HyprPanel package to use";
    };

    settings = mkOption {
      type = jsonFormat.type;
      default = {};
      example = {
        bar = {
          autoHide = "never";
          location = "top";
        };
        theme = {
          name = "catppuccin-mocha";
          font = "JetBrains Mono Nerd Font";
        };
      };
      description = ''
        Configuration written to {file}`$HOME/.config/hyprpanel/config.json`.
        Refer to [HyprPanel documentation](https://hyprpanel.com/configuration).
      '';
    };

    config = mkOption {
      type = nullOr (either path (either str attrs));
      default = null;
      description = ''
        Alternative config input (overrides settings if set):
        - Path to a JSON file
        - Raw JSON string
        - Nix attribute set (converted to JSON)
      '';
    };

    systemd = {
      enable = mkEnableOption "Enable systemd user service for HyprPanel";
    };

    hyprland = {
      enable = mkEnableOption "Enable Hyprland integration for HyprPanel";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Use hj.files for the main config.json only
    hj.files = lib.mkIf (cfg.config != null || cfg.settings != {}) {
      ".config/hyprpanel/config.json" = if cfg.config != null then
        if lib.isString cfg.config then {
          text = cfg.config;
        } else if lib.isPath cfg.config then {
          source = cfg.config;
        } else {
          text = builtins.toJSON cfg.config;
        }
      else {
        text = jsonFormat.generate "hyprpanel-config" cfg.settings;
      };
    };

    # Systemd user service for hyprpanel
    systemd.user.services.hyprpanel = mkIf cfg.systemd.enable {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${getExe cfg.package}";
        ExecReload = "${getExe cfg.package} r";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # Hyprland integration
    hj.rum.programs.hyprland.settings.exec-once = mkIf (cfg.hyprland.enable && config.hj.rum.programs.hyprland.enable) [
      "${getExe cfg.package}"
    ];
  };
}

