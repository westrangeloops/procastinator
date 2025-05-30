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
  }; 
}
