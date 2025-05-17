{
  pkgs,
  config,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [
    ./desktop 
    ./common 
    ./drivers 
    ./nix 
    ./terminal
    ./media
    ./hyprland
  ];
}
