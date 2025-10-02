{ pkgs, ... }: {
  # ASUS ROG laptop support
  # Requires Linux 6.10 or newer for best compatibility
  
  # Supergfxctl - Graphics switching daemon
  services.supergfxd = {
    enable = true;
  };
  
  # Fix for supergfxctl graphics card detection
  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  
  # Asusctl - ASUS laptop control utilities
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  
  # Add asusctl and supergfxctl to system packages for CLI access
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];
}

