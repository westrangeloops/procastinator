# boot.nix
{ pkgs, lib, inputs, ... }:

{
  # Import grub2-themes module (provides Vimix, Tela, Stylish, etc.)
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  boot.loader = {
    # Enable GRUB with EFI and Windows detection
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";                 # EFI only, no MBR
      useOSProber = pkgs.lib.mkForce true;   # detect Windows
      gfxmodeEfi = "2880x1800"; # Match your laptop's native resolution

      # Use theme background instead of custom splash to avoid flickering
      splashImage = null;
    };

    # Enable grub2-themes (choose theme: tela, stylish, vimix, whitesur, etc.)
    grub2-theme = {
      enable = true;
      theme = "vimix";
      footer = true;
      # The vimix theme has its own background that will be used consistently
    };
  };

  # Needed packages
  environment.systemPackages = with pkgs; [
    os-prober   # auto-detect Windows
    sbctl       # optional: secure boot helper
  ];

  # Disable Stylix's grub theming to avoid conflicts
  stylix.targets.grub.enable = false;
}


