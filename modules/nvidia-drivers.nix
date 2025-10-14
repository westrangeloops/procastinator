{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.drivers.nvidia;
in {
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nouveau Drivers (Open-Source NVIDIA)";
  };

  config = mkIf cfg.enable {
    # Enable graphics - Nouveau is enabled by default when graphics are enabled
    hardware.graphics.enable = true;
    
    # Don't specify videoDrivers - let Nouveau be used by default
    # services.xserver.videoDrivers = []; # Nouveau is the default
    
    # Blacklist all proprietary NVIDIA drivers to ensure Nouveau is used
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidiafb"
      "nvidia-drm"
      "nvidia-uvm"
      "nvidia-modeset"
      "nvidia-peermem"
      "nvidia-utils"
    ];
    
    # Environment variables for Nouveau
    environment.variables = {
      "LIBVA_DRIVER_NAME" = "nouveau";
      "GBM_BACKEND" = "nouveau";
    };
    
    # Kernel parameters for Nouveau stability and performance
    boot.kernelParams = [
      "nouveau.modeset=1" # Enable modesetting for proper Wayland support
      "nouveau.config=NvClkMode=3" # Try to enable higher performance mode
      "nouveau.config=NvFBC=1" # Enable framebuffer compression if available
      "nouveau.config=NvMSI=1" # Enable MSI interrupts for better performance
      "nouveau.config=NvReg=EnableVgaScaler=1" # Enable VGA scaler
      "nouveau.config=NvReg=EnableHeadless=0" # Disable headless mode
      "nouveau.config=NvReg=UseVBios=1" # Use VBIOS for initialization
      "nouveau.config=NvReg=PowerManagement=0" # Disable power management for max performance
      "nouveau.config=NvReg=ForceMonitors=1" # Force monitor detection
    ];
    
    # Additional Nouveau optimization
    boot.extraModprobeConfig = ''
      options nouveau modeset=1
      options nouveau config=NvClkMode=3
      options nouveau config=NvFBC=1
      options nouveau config=NvMSI=1
      options nouveau config=NvReg=EnableVgaScaler=1
      options nouveau config=NvReg=EnableHeadless=0
      options nouveau config=NvReg=UseVBios=1
      options nouveau config=NvReg=PowerManagement=0
      options nouveau config=NvReg=ForceMonitors=1
    '';
  };
}
