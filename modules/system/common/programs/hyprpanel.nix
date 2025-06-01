
{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption mkMerge isString isPath;
  inherit (lib.types) nullOr either str path attrs;
  inherit (lib.meta) getExe;

  jsonFormat = pkgs.formats.json {};

  cfg = config.rum.programs.hyprpanel;
in
{
  options.rum.programs.hyprpanel = {
    enable = mkEnableOption "HyprPanel status bar";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.hyprpanel;
      description = "HyprPanel package to use.";
    };

    extraPackages = mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra system packages for HyprPanel.";
    };

    settings = mkOption {
      type = nullOr (either path (either str attrs));
      default = null;
      description = ''
        HyprPanel JSON configuration.
        Can be:
        - Path to a JSON file
        - Raw JSON string
        - Nix attribute set (will be converted to JSON)
      '';
    };

    override = mkOption {
      type = nullOr (attrs);
      default = {};
      description = ''
        Arbitrary attribute set to override final config.
        Useful for customizing colors or theming.
      '';
    };

    systemd = {
      enable = mkEnableOption "Enable systemd user service for HyprPanel";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;

      # Write JSON config to a normal file in .config (not symlinked!)
      hj.files = lib.mkIf (cfg.settings != null) {
        ".config/hyprpanel/config.json" =
          if isString cfg.settings then {
            source = cfg.settings;
          } else if isPath cfg.settings then {
            source = cfg.settings;
          } else {
            source = jsonFormat.generate "hyprpanel-config" (lib.recursiveUpdate cfg.settings (cfg.override or {}));
          };
      };
    }

    (mkIf cfg.systemd.enable {
      systemd.user.services.hyprpanel = {
        description = "HyprPanel status bar for graphical session";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${getExe cfg.package}";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
          Restart = "on-failure";
          RestartSec = 2;
          KillMode = "mixed";
        };
      };
    })
  ]);
}
