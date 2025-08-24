{
  pkgs,
  lib,
  ...
}:

let
  desktopItem = pkgs.makeDesktopItem {
    name = "vesta";
    desktopName = "VESTA";
    genericName = "Crystal Structure Viewer";
    exec = "vesta %F";
    icon = "${pkgs.fetchurl {
      url = "https://jp-minerals.org/vesta/images/VESTAIcon.png";
      sha256 = "sha256-WmNoF/TuHGp7WrmHEM+LHgcg5CrYdOuEz00TXAK1BdY=";
    }}";
    comment = "Visualization for Electronic and STructural Analysis";
    categories = [ "Science" "Education" "Graphics" ];
    mimeTypes = [ 
      "application/x-vesta"
      "chemical/x-cif"
      "chemical/x-pdb"
      "chemical/x-xyz"
    ];
  };
in
{
  # Add the desktop item to XDG data dirs
  environment.systemPackages = [ desktopItem ];
}
