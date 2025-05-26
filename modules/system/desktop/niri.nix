{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:{
    imports = [
      ./../niri
    ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  }; 
}
