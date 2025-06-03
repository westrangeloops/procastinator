{  
   imports = [
      ../../common/programs/niri.nix
   ];
   rum.programs.niri.enable = true;
   rum.programs.niri = {
       #extraPackages = [ inputs.kaneru.packages.${pkgs.system}.default pkgs.xwayland-satalite ];
       settings = (import ./setting.nix) // (import ./startup.nix) // (import ./binds.nix);
   };
}
