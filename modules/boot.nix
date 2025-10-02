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
      gfxmodeEfi = pkgs.lib.mkForce "2560x1440"; # QHD resolution

      # Your custom splash image
      splashImage = pkgs.lib.mkForce ../dotfiles/wallpapers/lockwhale.jpg;
    };

    # Enable grub2-themes (choose theme: tela, stylish, vimix, whitesur, etc.)
    grub2-theme = {
      enable = true;
      theme = "vimix";
      footer = true;
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


