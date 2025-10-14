{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia-prime-offload;
in
{
  options.drivers.nvidia-prime-offload = {
    enable = mkEnableOption "Enable Nvidia Prime Offload (Alternative to ReverseSync)";
    amdBusID = mkOption {
      type = types.str;
      default = "PCI:101:0:0";  # AMD Radeon 890M (65:00.0 in hex)
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:100:0:0";  # NVIDIA RTX 5070 Ti (64:00.0 in hex)
    };
  };

  config = mkIf cfg.enable {
    # Boot configuration for hybrid graphics
    boot.initrd.kernelModules = [ "amdgpu" "nvidia" "nvidia-drm" "nvidia-modeset" ];
    boot.kernelParams = [ 
      "nvidia-drm.modeset=1" 
      "mem_sleep_default=deep"
      "amdgpu.dcdebugmask=0x10"
      # Offload mode parameters
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      # Force NVIDIA to create DRM devices
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_EnableMSI=1"
    ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    
    # Kernel sysctl for better memory management
    boot.kernel.sysctl."vm.max_map_count" = 2147483642;
    
    # Video drivers
    # For offload mode, "modesetting" is needed for the iGPU
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    services.udev.packages = with pkgs; [ linuxPackages.nvidia_x11 ];
    
    # AMD GPU initialization
    hardware.amdgpu.initrd.enable = lib.mkDefault true;
    
    # NVIDIA configuration for offload mode
    hardware.nvidia = {
      # Use latest driver for RTX 5070 Ti Mobile (Blackwell architecture)
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      
      # RTX 5070 Ti requires open-source kernel modules (Blackwell and newer)
      open = true;
      
      # Modesetting is required
      modesetting.enable = true;
      
      # Enable nvidia-settings GUI
      nvidiaSettings = true;
      
      # Power management for laptops
      powerManagement = {
        enable = true;
        # Fine-grained power management is compatible with offload mode
        finegrained = true;
      };
      
      # PRIME Offload mode for hybrid graphics
      # Uses iGPU for display, dGPU for rendering when requested
      prime = {
        # Offload mode: iGPU handles display, dGPU handles rendering
        offload.enable = true;
        
        # Reverse sync and sync modes are incompatible with offload
        reverseSync.enable = false;
        sync.enable = false;
        
        # Bus IDs - verified with: lspci | grep -E "VGA|3D"
        amdgpuBusId = "${cfg.amdBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";
      };
      
      # Additional configuration for external monitor support
      forceFullCompositionPipeline = true;
      
      # Additional options to force DRM device creation
      # These options help with external monitor detection
      options = {
        "NVreg_EnableGpuFirmware" = "1";
        "NVreg_UsePageAttributeTable" = "1";
        "NVreg_EnableMSI" = "1";
      };
    };
    
    # Graphics drivers
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # AMD ROCm OpenCL support for compute workloads
        rocmPackages.clr.icd
      ];
    };
  };
}
