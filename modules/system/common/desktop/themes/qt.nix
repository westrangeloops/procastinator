{pkgs, ...}: let
  envVars = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
in {
  qt.enable = true;
  environment.variables = envVars;
  hj = {
    packages = [
      (pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["green"];
      })
    ];
    environment.sessionVariables = envVars;
  };
}
