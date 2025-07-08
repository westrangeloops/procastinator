{
  config,
  pkgs,
  theme,
  lib,
  inputs,
  ...
}: let
  inherit (theme) fonts;
  inherit (lib.strings) optionalString;
  inherit (builtins) readFile toString;

  packages = {
    theme = pkgs.catppuccin-gtk.override {
      accents = ["green"];
      variant = "mocha";
      size = "standard";
      tweaks = ["normal"];
    };
    iconTheme = pkgs.catppuccin-papirus-folders.override {
      accent = "green";
      flavor = "mocha";
    };
    cursorTheme = inputs.waifu-cursors.packages.${pkgs.system}.Reichi-Shinigami;
  };

  cfg = config.hj.rum.misc.gtk;
in {
  hj.rum.misc.gtk = {
    enable = true;
    packages = [
      packages.theme
      packages.iconTheme
      packages.cursorTheme
    ];
    settings = {
      application-prefer-dark-theme = true;
      theme-name = "catppuccin-mocha-green-standard+normal";
      icon-theme-name = "Papirus-Dark";
      font-name = "JetBrainsMono Nerd Font ${toString 13}";
      cursor-theme-name = "Reichi-Shinigami";
    };
    css = let
      darkTheme = cfg.settings.application-prefer-dark-theme;
      fileCSS = ver: "${packages.theme}/share/themes/${cfg.settings.theme-name}/gtk-${ver}/gtk${optionalString darkTheme "-dark"}.css";
    in {
      gtk3 = readFile (fileCSS "3.0");
      gtk4 = readFile (fileCSS "4.0");
    };
  };
}
