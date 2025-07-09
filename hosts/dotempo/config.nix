# Main default config
{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  outputs,
  system,
  ...
}: let
  inherit (import ./variables.nix) keyboardLayout;
  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
      ]
  );
in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./hjem.nix
    ./themes.nix
    ../../modules
  ];

  # System services
  vm.guest-services.enable = false;
  local.hardware-clock.enable = true;
  system.packages.enable = true;
  system.kernel.enable = true;
  system.bootloader-systemd.enable = true;
  system.bootloader-grub.enable = false;
  system.plymouth.enable = true;
  system.audio.enable = true;
  system.displayManager.enable = true;
  system.greetd.enable = false;
  system.powermanagement.enable = true;
  system.scheduler.enable = true;
  mine.hypridle.enable = false;
  system.zfs.enable = true;
  system.zram.enable = true;
  catppuccin.tty.enable = true;

  # Nixpkgs and users
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  users.mutableUsers = true;
  programs.command-not-found.enable = true;
  
  # Packages
  environment.systemPackages =
    (with pkgs; [
      mesa
      master.waybar
      google-chrome
      code-cursor
    ]) ++ [ python-packages ];

  # AMD graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Console
  console.keyMap = "${keyboardLayout}";

  # Wayland support for apps like Electron
  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
    VISUAL = "vscodium";
    GSK_RENDERER = "gl";
    NIXPKGS_ALLOW_UNFREE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    ZDOTDIR = "$HOME/.config/zsh";
  };

  system.stateVersion = "25.05";
}
