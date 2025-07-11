{
  lib,
  config,
  pkgs,
  ...
}: let
  userName = "dotempo";
  userDescription = "LetsGoAgain";
in {
  options = {
  };
  config = {
    users.users.${userName} = {
      isNormalUser = true;
      description = lib.mkForce userDescription;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "docker" "wireshark" "libvirtd" "kvm"];
    };
    programs.zsh.enable = true;
  };
}
