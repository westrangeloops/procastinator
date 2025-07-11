{config, lib, pkgs, ...}
{
  services = {
    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };
    # battery info
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "Hibernate";
    };
  };

  # Enable auto-login to TTY1 (optional, for convenience)
  services.getty.autologinUser = "your-username"; # Replace with your actual username

  # Make sure Hyprland is available
  programs.hyprland.enable = true;

  # Environment variables needed for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Your user configuration
  users.users.dotempo = { # Replace with your actual username
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    shell = pkgs.bash;
  };
}
