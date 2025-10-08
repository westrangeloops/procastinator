{ pkgs, config, ... }: 
let
  # nvidia-offload script for running apps on dGPU
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  
  # GPU mode switcher script
  gpu-mode = pkgs.writeShellScriptBin "gpu-mode" ''
    case "$1" in
      "integrated"|"amd"|"i")
        echo "Switching to Integrated GPU (AMD) - Best for battery and low temps"
        supergfxctl -m Integrated
        ;;
      "hybrid"|"h")
        echo "Switching to Hybrid mode - AMD primary, NVIDIA on-demand"
        supergfxctl -m Hybrid
        ;;
      "dedicated"|"nvidia"|"d")
        echo "Switching to Dedicated GPU (NVIDIA) - Max performance"
        supergfxctl -m Dedicated
        ;;
      "status"|"s")
        echo "Current GPU mode: $(supergfxctl -g)"
        ;;
      *)
        echo "Usage: gpu-mode [integrated|hybrid|dedicated|status]"
        echo "  integrated/amd/i - Use AMD iGPU only (best battery)"
        echo "  hybrid/h        - AMD primary, NVIDIA on-demand"
        echo "  dedicated/nvidia/d - Use NVIDIA dGPU only (max performance)"
        echo "  status/s         - Show current mode"
        ;;
    esac
  '';
in {
  # ASUS ROG laptop support
  # Requires Linux 6.10 or newer for best compatibility
  
  # Supergfxctl - Graphics switching daemon for GPU management
  services.supergfxd = {
    enable = true;
    settings = {
      vfio_enable = true;          # Enable GPU passthrough for VMs
      vfio_save = false;
      always_reboot = false;
      no_logind = false;
      logout_timeout_s = 20;
      hotplug_type = "Asus";       # ASUS-specific GPU switching
      # Default to Integrated mode for better battery life and lower temps
      default_graphics_mode = "Integrated";
    };
  };
  
  # Fix for supergfxctl graphics card detection - add kmod for modprobe
  systemd.services.supergfxd.path = [ pkgs.pciutils pkgs.kmod ];
  
  # Asusctl - ASUS laptop control utilities (fan curves, RGB, profiles)
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  
  # ROG Control Center - GUI for ASUS laptop management
  programs.rog-control-center.enable = true;
  
  # CoreCtrl - GPU/CPU control utility (AMD GPU tuning)
  programs.corectrl.enable = true;
  
  # ACPI daemon for hardware events
  services.acpid.enable = true;
  
  # Add utilities to system packages
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
    nvidia-offload       # Custom script to run apps on NVIDIA GPU
    gpu-mode            # Easy GPU mode switching
  ];
  
  # ROG laptops benefit from killing user processes on logout
  services.logind.killUserProcesses = true;
}

