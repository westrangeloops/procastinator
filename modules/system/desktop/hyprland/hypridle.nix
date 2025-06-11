{
    inputs,
    pkgs,
    configs,
    ...
}:{
    hm = {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session"; # optional
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # After 10 minutes
        {
          timeout = 60000;
          on-timeout = ''
            notify-send "Idle mode starting... Screen will turn off.";
            hyprctl dispatch dpms off
          '';
          on-resume = "hyprctl dispatch dpms on";
        }

        # After 20 minutes
        {
          timeout = 120000;
          on-timeout = ''
            notify-send -u critical "Locking session due to inactivity";
            loginctl lock-session;
            hyprctl dispatch dpms off
          '';
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
    };
}
