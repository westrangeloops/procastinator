{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) mkIf mkEnableOption optionalAttrs;
  inherit (lib.options) mkOption mkPackageOption;
  inherit (lib.types) nullOr either str path attrs;

  jsonFormat = pkgs.formats.json {};

  cfg = config.rum.programs.hyprpanel;

  defaultPackage = pkgs.symlinkJoin {
    name = "hyprpanel-with-deps";
    paths = [
      (inputs.hyprpanel.packages.${pkgs.system}.default or (throw "hyprpanel package not found"))
      pkgs.sass
      pkgs.sassc
      pkgs.libgtop
    ];
  };

in {
  options.rum.programs.hyprpanel = {
    enable = mkEnableOption "HyprPanel";

    package = mkPackageOption pkgs "hyprpanel" {
      default = if pkgs ? hyprpanel then "hyprpanel" else "hyprpanel-wrapper";
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
      description = "Alternative config input (overrides settings if set)";
    };

    systemd.enable = mkEnableOption "systemd user service";
    hyprland.enable = mkEnableOption "Hyprland integration";

    user = mkOption {
      type = lib.types.str;
      default = "";
      description = "Username to configure (leave empty for current user)";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Create user config file during activation
    system.activationScripts.hyprpanelConfig = let
      configContent = if cfg.config != null then
        if lib.isString cfg.config then cfg.config
        else if lib.isPath cfg.config then builtins.readFile cfg.config
        else builtins.toJSON cfg.config
      else jsonFormat.generate "hyprpanel-config" cfg.settings;
      userHome = if cfg.user != "" then "/home/${cfg.user}" else "$HOME";
    in ''
      mkdir -p "${userHome}/.config/hyprpanel"
      cat > "${userHome}/.config/hyprpanel/config.json" <<EOF
      ${configContent}
      EOF
      chmod 600 "${userHome}/.config/hyprpanel/config.json"
    '';

    # Systemd user service
    systemd.user.services.hyprpanel = mkIf cfg.systemd.enable {
      enable = true;
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hyprpanel";
        ExecReload = "${cfg.package}/bin/hyprpanel r";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # Hyprland integration
    hj.rum.programs.hyprland.settings.exec-once = mkIf (cfg.hyprland.enable && config.hj.rum.programs.hyprland.enable) [
      "${cfg.package}/bin/hyprpanel"
    ];
  };
}

