{ pkgs, ... }: {
  services = {
    logind = {
      settings = {
        Login = {
          HandlePowerKey = "suspend";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "lock";
        };
      };
    };
    
    # Battery info and power management
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "Hibernate";
    };
    
    # TLP - Advanced power management (better than auto-cpufreq for laptops)
    # Disabled: Conflicts with power-profiles-daemon which is required by asusd
    tlp = {
      enable = false;
      settings = {
        # CPU settings - More aggressive thermal management
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";  # Better thermal management than performance
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        # AMD P-State EPP (Energy Performance Preference)
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";  # Balanced for thermals
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 80;  # Limit to 80% even on AC to reduce heat
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;  # Limit CPU to 30% on battery
        
        # Boost settings
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;  # Disable turbo boost on battery
        
        # AMD GPU power management
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";
        
        # Platform profile (ASUS laptop specific)
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        
        # Battery charge thresholds (prolongs battery life)
        START_CHARGE_THRESH_BAT0 = 75;  # Start charging at 75%
        STOP_CHARGE_THRESH_BAT0 = 80;   # Stop charging at 80%
        
        # Runtime power management for devices
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        
        # PCIe Active State Power Management
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
        
        # USB autosuspend
        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_BTUSB = 1;  # Don't autosuspend Bluetooth
        USB_EXCLUDE_PHONE = 1;
        
        # Wi-Fi power saving
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        
        # Disable Wake-on-LAN
        WOL_DISABLE = "Y";
        
        # Audio power saving
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        
        # NVMe power management
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";
      };
    };
    
    # Power profiles daemon is required by asusd (ASUS laptop control)
    # Note: This conflicts with TLP, but asusd needs it
    # We disable TLP's conflicting features and let power-profiles-daemon
    # work with asusd for ASUS-specific power management
    power-profiles-daemon.enable = true;
    
    # Thermald for thermal management with aggressive cooling
    thermald = {
      enable = true;
      # More aggressive thermal management
      configFile = pkgs.writeText "thermald.conf" ''
        <?xml version="1.0"?>
        <ThermalConfiguration>
          <Platform>
            <Name>ASUS ROG Laptop</Name>
            <ProductName>*</ProductName>
            <Preference>QUIET</Preference>
            <ThermalZones>
              <ThermalZone>
                <Type>cpu</Type>
                <TripPoints>
                  <TripPoint>
                    <Temperature>60000</Temperature>
                    <Type>passive</Type>
                    <SensorType>cpu</SensorType>
                    <CoolingDevice>cpufreq</CoolingDevice>
                    <TargetState>1</TargetState>
                  </TripPoint>
                  <TripPoint>
                    <Temperature>70000</Temperature>
                    <Type>passive</Type>
                    <SensorType>cpu</SensorType>
                    <CoolingDevice>cpufreq</CoolingDevice>
                    <TargetState>2</TargetState>
                  </TripPoint>
                  <TripPoint>
                    <Temperature>80000</Temperature>
                    <Type>passive</Type>
                    <SensorType>cpu</SensorType>
                    <CoolingDevice>cpufreq</CoolingDevice>
                    <TargetState>3</TargetState>
                  </TripPoint>
                </TripPoints>
              </ThermalZone>
            </ThermalZones>
          </Platform>
        </ThermalConfiguration>
      '';
    };
  };
  
  # PowerTop for additional power savings
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";  # Default governor
  };
  
  # Additional power-saving packages
  environment.systemPackages = with pkgs; [
    powertop
    acpi
    tlp
  ];
}
