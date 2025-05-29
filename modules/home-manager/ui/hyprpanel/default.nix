{
    inputs,
    config,
    pkgs,
    ...
}:
{
    imports = [
     ./moduels.nix
    ];

  rum.programs.hyprpanel = {
      enable = false;
      configFile = ./config.json;
      systemd.enable = true;
      hyprland.enable = true; 
  };
}
