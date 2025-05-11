{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
    ./settings.nix
    ./binds.nix
    ./rules.nix
  ];
  home = {
    packages = with pkgs; [
      seatd
      jaq
      eww
      brillo
      cage
      qt6.qtwayland
      wl-clip-persist
      cliphist
      xwayland-satellite
      wl-clipboard
      gnome-control-center
      catppuccin-cursors.mochaGreen
    ];
    sessionVariables = {
      QT_STYLE_OVERRIDE = "kvantum";
      XDG_SESSION_TYPE = "wayland";
    };
  };
  systemd.user.services.xwayland-satalite = {
     Unit = {
       Description = "Xwayland Satalite Services";
	   After = "graphical-session.target";
	   PartOf = "graphical-session.target";
     };
     Install.WantedBy = [ "graphical-session.target" ];
     Service = {
       Type = "simple";
       ExecStart = "{pkgs.xwayland-satalite}/bin/xwayland-satalite";
       Restart = "on-failure";
       Environment = [
           "WAYLAND_DISPLAY=wayland-1"
           "XDG_RUNTIME_DIR=/run/user/%U"
      ];
  };
 };
}
