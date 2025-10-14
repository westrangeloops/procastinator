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
    ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    
    # Kernel sysctl for better memory management
    boot.kernel.sysctl."vm.max_map_count" = 2147483642;
    
    # Video drivers
    # Per NVIDIA wiki: For offload mode, "modesetting" is needed for the iGPU
    # to prevent X-server from running permanently on nvidia
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    services.udev.packages = with pkgs; [ linuxPackages.nvidia_x11 ];
    
    # AMD GPU initialization
    hardware.amdgpu.initrd.enable = lib.mkDefault true;
    
    # NVIDIA configuration
    hardware.nvidia = {
      # Use latest driver for RTX 5070 Ti Mobile (Blackwell architecture)
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      
      # RTX 5070 Ti requires open-source kernel modules (Blackwell and newer)
      # Per NVIDIA wiki: "Data center GPUs starting from Grace Hopper or Blackwell 
      # must use open-source modules — proprietary modules are no longer supported"
      open = true;
      
      # Modesetting is required
      modesetting.enable = true;
      
      # Enable nvidia-settings GUI
      nvidiaSettings = true;
      
      # Power management for laptops
      # Enable basic power management (recommended for laptops)
      powerManagement = {
        enable = true;
        # Fine-grained power management - turns off GPU when not in use
        # Works with Turing and newer (your RTX 5070 Ti is Blackwell)
        finegrained = true;
      };
      
      # PRIME Reverse Sync mode for hybrid graphics
      # Uses dGPU as primary for external displays (HDMI wired to dGPU)
      # Note: This is experimental but necessary when HDMI is wired to dGPU
      prime = {
        # Reverse sync: dGPU renders, displays on both internal and external
        reverseSync.enable = true;
        
        # Offload and sync modes are incompatible with reverseSync
        offload.enable = false;
        sync.enable = false;
        
        # Bus IDs - verified with: lspci | grep -E "VGA|3D"
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
