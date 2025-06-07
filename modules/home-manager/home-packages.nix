{
  config,
  lib,
  pkgs,
  system,
  inputs,
  options,
  ...
}: {
 # Explicitly disable
  home.packages = with pkgs; [
    #rustup
    #github-cli
    neovide

    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    #inputs.wezterm.packages.${pkgs.system}.default
    #inputs.astal-bar.packages.${pkgs.system}.default
    inputs.ags.packages.${pkgs.system}.agsFull
       #inputs.yazi.packages.${pkgs.system}.yazi 
  ];
}
