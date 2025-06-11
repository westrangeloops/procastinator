{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.hypridle;
in
{
  options.mine.hypridle = {
    enable = mkEnableOption "Enable Hypridle service";
  };

  config = mkIf cfg.enable {
    hj.rum.programs.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = ''
            sh -c '
              notify-send "Locking"
              if command -v pidoff >/dev/null; then
                pidoff hyprlock
              else
                hyprlock
              fi
            '
          '';
          unlock_cmd = ''notify-send "Unlocked"'';
          before_sleep_cmd = ''sh -c 'notify-send "Sleeping" && loginctl lock-session' '';
          after_sleep_cmd = ''sh -c 'notify-send "Woke up" && hyprctl dispatch dpms on' '';
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
        };

        listener = [
          {
            # DPMS off after 10 minutes idle
            timeout = 600;
            on-timeout = ''sh -c 'notify-send "Idle" && hyprctl dispatch dpms off' '';
            on-resume = ''sh -c 'notify-send "Resumed" && hyprctl dispatch dpms on' '';
          }
          {
            # Lock screen after 20 minutes total idle
            timeout = 1200;
            on-timeout = ''sh -c 'notify-send "Locking after idle" && loginctl lock-session' '';
          }
        ];
      };
    };

    systemd.user.services.hypridle = {
      description = "Hyprland idle daemon";
      documentation = [ "https://wiki.hyprland.org/Hypr-Ecosystem/hypridle" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.hypridle}/bin/hypridle";
        Restart = "on-failure";
        RestartSec = 1;
      };

      wantedBy = [ "graphical-session.target" ];
    };

    hj.rum.programs.hyprland.settings.misc = {
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
    };
  };
}


