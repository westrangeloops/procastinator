{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) nullOr either str path attrs;
  inherit (lib.meta) getExe;

  tomlFormat = pkgs.formats.toml {};

  cfg = config.rum.programs.walker;

  # Resolve default package from flake input
  defaultPackage = (inputs.walker.packages.${pkgs.system}.default or null)
    // pkgs.walker // (throw "walker package not found in inputs or pkgs");
in
{
  options.rum.programs.walker = {
    enable = mkEnableOption "Walker application launcher";

    package = mkOption {
      type = lib.types.package;
      default = defaultPackage;
      description = "Walker package to use";
    };

    config = mkOption {
      type = nullOr (either path (either str attrs));
      default = null;
      description = ''
        Walker configuration can be provided as:
        - Path to a TOML file
        - Raw TOML string
        - Nix attribute set (will be converted to TOML)
      '';
    };

    theme = mkOption {
      type = nullOr {
        layout = nullOr (either path attrs);
        style = nullOr (either path str);
      };
      default = null;
      description = ''
        Optional theme configuration:
        - layout: path to TOML file or attribute set (converted to TOML)
        - style: path to CSS file or raw CSS string
      '';
    };

    systemd = {
      enable = mkEnableOption "Enable systemd user service for Walker";
    };

    runAsService = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run Walker as systemd user service";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Deploy main config file to ~/.config/walker/config.toml
    environment.etc."xdg/walker/config.toml" = mkIf (cfg.config != null) (
      if lib.isString cfg.config then {
        text = cfg.config;
      } else if lib.isPath cfg.config then {
        source = cfg.config;
      } else {
        text = tomlFormat.generate "walker-config" cfg.config;
      }
    );

    # Deploy theme files if provided
    environment.etc = lib.optionalAttr (cfg.theme != null) (
      let
        # Layout deployment: if path, source; else generate TOML from attrset
        layoutEntry = if cfg.theme.layout == null then null else
          if lib.isPath cfg.theme.layout then
            { source = cfg.theme.layout; }
          else
            { text = tomlFormat.generate "walker-theme-layout" cfg.theme.layout; };

        # Style deployment: if path, source; else raw string
        styleEntry = if cfg.theme.style == null then null else
          if lib.isPath cfg.theme.style then
            { source = cfg.theme.style; }
          else
            { text = cfg.theme.style; };
      in
      {
        "xdg/walker/themes/default.toml" = layoutEntry;
        "xdg/walker/themes/default.css" = styleEntry;
      }
    );

    # systemd user service for walker
    systemd.user.services.walker = mkIf (cfg.systemd.enable && cfg.runAsService) {
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${getExe cfg.package} --gapplication-service";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
