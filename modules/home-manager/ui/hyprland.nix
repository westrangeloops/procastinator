{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:{
    imports = [
      #./ags.nix
    ];
  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
  home.packages = [ pkgs.wl-clipboard ];
 
  systemd.user.services.hyprpanel = {
	Unit = {
	   Description = "hyprpanel";
	   After = "graphical-session.target";
	   PartOf = "graphical-session.target";
  };
  Install.WantedBy = [ "graphical-session.target"];
  Service = {
	Type = "simple";
    ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
    Restart = "always";
	RestartSec = 1;
	TimeoutStopSec = 10;	
  };

 }; 
    
}
