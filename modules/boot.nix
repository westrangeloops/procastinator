{
  pkgs,
  lib,
  inputs,
  ...
}:
# GRUB bootloader config
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  environment.systemPackages = [pkgs.grub2_efi];
}
