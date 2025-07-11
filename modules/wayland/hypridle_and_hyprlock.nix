{
  pkgs,
  lib,
  config,
  ...
}: let
  brillo = lib.getExe pkgs.brillo;
  # timeout after which DPMS kicks in
  timeout = 300;
in {
  # screen idle
  services.hypridle = {
    enable = true;
    settings = {
      general.lock_cmd = lib.getExe config.programs.hyprlock.package;
      listener = [
        {
          timeout = timeout - 10;
          # save the current brightness and dim the screen over a period of
          # 500 ms
          on-timeout = "${brillo} -O; ${brillo} -u 500000 -S 10";
          # brighten the screen over a period of 250ms to the saved value
          on-resume = "${brillo} -I -u 250000";
        }
        {
          timeout = timeout;
          # DPMS off/on
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 10;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
  };

  # Configure hyprlock as well
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        immediate_render = true;
        hide_cursor = false;
      };
      background = [
        {
          monitor = "";
          path = "../../dotfiles/wallpapers/wallwhale.jpg";
          blur_passes = 3;
          blur_size = 12;
          noise = "0.1";
          contrast = "1.3";
          brightness = "0.2";
          vibrancy = "0.5";
          vibrancy_darkness = "0.3";
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "300, 50";
          valign = "bottom";
          position = "0%, 10%";
          outline_thickness = 1;
          font_color = "rgb(211, 213, 202)";
          outer_color = "rgba(29, 38, 33, 0.6)";
          inner_color = "rgba(15, 18, 15, 0.1)";
          check_color = "rgba(141, 186, 100, 0.5)";
          fail_color = "rgba(229, 90, 79, 0.5)";
          placeholder_text = "Enter Password";
          dots_spacing = 0.2;
          dots_center = true;
          dots_fade_time = 100;
          shadow_color = "rgba(5, 7, 5, 0.1)";
          shadow_size = 7;
          shadow_passes = 2;
        }
      ];
      label = [
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo "<span font-weight='light' >$(date +'%H %M %S')</span>"
          '';
          font_size = 300;
          font_family = "Adwaita Sans Thin";
          color = "rgb(8a9e6b)";
          position = "0%, 2%";
          valign = "center";
          halign = "center";
          shadow_color = "rgba(5, 7, 5, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
      ];
    };
  };

  # Ensure the systemd service starts after the graphical session
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
