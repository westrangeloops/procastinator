{ pkgs, lib, config, ... }:
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
in
{
  # ASUS G14/G16 Patched Kernel based off of Arch Linux Kernel
  # Source: https://github.com/Kamokuma5/nix_config/blob/main/nixos_config/nixos_modules/asus-kernel.nix
  # This kernel includes patches specifically for ASUS ROG laptops
  
  boot.kernelPackages =
    let
      linux_g14_pkg =
        {
          fetchzip,
          fetchgit,
          buildLinux,
          ...
        }@args:
        let
          # Get all patches from the asus-linux for Arch project
          patch_dir = fetchgit {
            fetchSubmodules = false;
            url = "https://gitlab.com/dragonn/linux-g14.git/";
            rev = "83010b4bc2a12fe18ab3532b6eea60e90db18d91";
            hash = "sha256-ShKxLGb7tO97onL3AopNBMnN6Yoa0Eri2eHct0zS9y0=";
          };

          ## Get all top-level patch files from patch_dir
          patchFiles = builtins.readDir patch_dir;

          ## Filter for only `.patch` files
          unsortedPatchList = lib.mapAttrsToList (
            name: _:
            builtins.trace "Found patch: ${name}" {
              inherit name;
              patch = "${patch_dir}/${name}";
            }
          ) (lib.filterAttrs (name: _type: lib.hasSuffix ".patch" name) patchFiles);

          patchList = builtins.sort (a: b: a.name < b.name) unsortedPatchList;
        in
        buildLinux (
          args
          // rec {
            inherit patchList;

            version = "6.13.8-arch1";

            # Get kernel source from arch GitHub repo
            defconfig = "${patch_dir}/config";

            src = fetchzip {
              url = "https://github.com/archlinux/linux/archive/refs/tags/v${version}.tar.gz";
              hash = "sha256-VzKdm8pHbeRk099IIddDlWNldAG8iYyF7K6lExmFRQE=";
            };
          }
          // (args.argsOverride or { })
        );
      linux_g14 = pkgs.callPackage linux_g14_pkg { };
    in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_g14);
  
  # ASUS ROG Laptop Services and Configuration
  
  # Supergfxctl - Graphics switching daemon
  # Note: With HDMI wired to dGPU, keep in Hybrid or higher modes for external displays
  services.supergfxd = {
    enable = true;
    settings = {
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = false;
      logout_timeout_s = 20;
      hotplug_type = "Asus";
    };
  };
  
  systemd.services.supergfxd.path = [ pkgs.pciutils pkgs.kmod ];
  
  # Asusctl - ASUS laptop control (fan curves, RGB, profiles)
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  
  # ROG Control Center - GUI
  programs.rog-control-center.enable = true;
  
  # CoreCtrl - GPU/CPU control
  programs.corectrl.enable = true;
  
  # ACPI daemon for hardware events
  services.acpid.enable = true;
  
  # Power profiles daemon - required by asusd
  services.power-profiles-daemon.enable = true;
  
  # ROG laptops benefit from killing user processes on logout
  services.logind.settings.Login.KillUserProcesses = true;
  
  # Add utilities to system
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
    nvidia-offload
    gpu-mode
  ];
}

