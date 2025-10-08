{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia-prime;
in
{
  options.drivers.nvidia-prime = {
    enable = mkEnableOption "Enable Nvidia Prime Hybrid GPU Offload";
    amdBusID = mkOption {
      type = types.str;
      default = "PCI:75:0:0";  # Updated for ASUS ROG laptop
    };
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";   # Updated for ASUS ROG laptop
    };
  };

  config = mkIf cfg.enable {
    # Boot configuration for hybrid graphics
    boot.initrd.kernelModules = [ "amdgpu" "nvidia" "nvidia-drm" "nvidia-modeset" ];
    boot.kernelParams = [ 
      "nvidia-drm.modeset=1" 
      "mem_sleep_default=deep"
      "amdgpu.dcdebugmask=0x10"
    ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    
    # Kernel sysctl for better memory management
    boot.kernel.sysctl."vm.max_map_count" = 2147483642;
    
    # Video drivers
    services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
    services.udev.packages = with pkgs; [ linuxPackages.nvidia_x11 ];
    
    # AMD GPU initialization
    hardware.amdgpu.initrd.enable = lib.mkDefault true;
    
    # NVIDIA configuration
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;
      nvidiaSettings = true;
      
      # Fine-grained power management for better battery life
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      
      # PRIME offload configuration
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        sync.enable = false;  # Offload mode, not sync
        # Bus IDs - verify with: lspci | grep -E "VGA|3D"
        amdgpuBusId = "${cfg.amdBusID}";
        nvidiaBusId = "${cfg.nvidiaBusID}";
      };
    };
    
    # Graphics drivers
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
  };
}
