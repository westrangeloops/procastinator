{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:{
      hj.rum.programs.hyprland.settings = {
          exec-once = [
             "uwsm finalize"
             "hyprctl setcursor LyraR-cursors 34"
             "wl-paste --type text --watch cliphist store"  
             "wl-paste --type image --watch cliphist store" 
          ];
          bind = [
             "SUPER, tab, exec, ${pkgs.ags_1}/bin/ags -t 'overview' "
          ];
           plugin = [
              pkgs.hyprlandPlugins.borders-plus-plus
              pkgs.hyprlandPlugins.hyprscroller
          ];

          extraConfig = ''
                $configs = $HOME/.config/hypr/configs
                source=$configs/Settings.conf
                source=$configs/Keybinds.conf
                $UserConfigs = $HOME/.config/hypr/UserConfigs
                source= $UserConfigs/Startup_Apps.conf
                source= $UserConfigs/ENVariables.conf
                source= $UserConfigs/Monitors.conf
                source= $UserConfigs/Laptops.conf
                source= $UserConfigs/LaptopDisplay.conf
                source= $UserConfigs/WindowRules.conf
                source= $UserConfigs/UserDecorAnimations.conf
                source= $UserConfigs/UserKeybinds.conf
                source= $UserConfigs/UserSettings.conf
                source= $UserConfigs/WorkspaceRules.conf
                source= $HOME/.config/hypr/themes/mocha.conf
      '';

      };
   
      systemd.user.services.hyprpanel = {
            enable = true;
            description = "hypridle service";
            after = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            serviceConfig = {
            Type = "simple";
            Restart = "always";
            ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
         };
      };
}
