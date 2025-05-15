{
  config,
  lib,
  pkgs,
  system,
  inputs,
  options,
  ...
}: {
  services.mako.enable = false;  # Explicitly disable
  home.packages = with pkgs; [
    #rustup
    #github-cli
    neovide 
    #inputs.wezterm.packages.${pkgs.system}.default
    #inputs.astal-bar.packages.${pkgs.system}.default
    inputs.ags.packages.${pkgs.system}.agsFull
       #inputs.yazi.packages.${pkgs.system}.yazi 
  ];
}
