# boot.nix - systemd-boot configuration
{ pkgs, lib, inputs, ... }:

{
  boot.loader = {
    # EFI configuration
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    
    # systemd-boot bootloader
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };
  };

  # systemd-boot automatically detects Windows
  environment.systemPackages = with pkgs; [
    os-prober   # for detecting other OSes if needed
  ];
}
