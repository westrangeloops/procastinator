{
    pkgs,
    config,
    lib,
    inputs,
    ...
}:
{
  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTarget = "graphical-session.target";
  }; 
}
