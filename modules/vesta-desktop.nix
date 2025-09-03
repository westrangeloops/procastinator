{
  pkgs,
  lib,
  ...
}:

let
  # Create a basic icon for VESTA
  vestaIcon = pkgs.runCommand "vesta-icon" {} ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    cat > $out/share/icons/hicolor/128x128/apps/vesta.svg << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128">
  <circle cx="64" cy="64" r="60" fill="#4d4d4d" />
  <text x="64" y="80" font-family="sans-serif" font-size="48" font-weight="bold" 
    text-anchor="middle" fill="white">VESTA</text>
</svg>
EOF
  '';

  desktopItem = pkgs.makeDesktopItem {
    name = "vesta";
    desktopName = "VESTA";
    genericName = "Crystal Structure Viewer";
    exec = "vesta %F";
    icon = "vesta";
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
  # Add the desktop item and icon to XDG data dirs
  environment.systemPackages = [ desktopItem vestaIcon ];
}
