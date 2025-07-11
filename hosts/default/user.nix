{
  lib,
  config,
  pkgs,
  ...
}: let
  userName = "dotempo";
  userDescription = "dotempo";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = userDescription;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "docker" "wireshark" "libvirtd" "kvm"];
    };
    programs.zsh.enable = true;
  # Enable auto-login to TTY1 (optional, for convenience)
  services.getty.autologinUser = "dotempo";

  };
}
