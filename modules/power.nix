{ pkgs, ... }: {
  services = {
    # Login daemon settings
    logind = {
      settings = {
        Login = {
          HandlePowerKey = "suspend";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "lock";
        };
      };
    };
    
    # Battery info
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "Hibernate";
    };
    
    # Thermald for CPU thermal management
    thermald.enable = true;
  };
  
  # Basic power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powerDownCommands = ''
      # Lock all sessions before suspend
      loginctl lock-sessions
      sleep 1
    '';
  };
  
  # Useful power monitoring tools
  environment.systemPackages = with pkgs; [
    powertop
    acpi
  ];
}
