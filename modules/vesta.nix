{
  lib,
  pkgs,
  ...
}:

let
  vesta = pkgs.stdenv.mkDerivation rec {
    name = "VESTA-gtk3";
    version = "3.5.8";

    src = pkgs.fetchurl {
      url = "https://jp-minerals.org/vesta/archives/${version}/VESTA-gtk3.tar.bz2";
      sha256 = "sha256-eL7wJcKzHx1kycfgatKxOdJSs6aGiT7nmsdLMCGGjfg=";
    };
    
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];
    
    buildInputs = with pkgs; [
      fontconfig.lib
      gcc-unwrapped.lib
      gcc-unwrapped.libgcc 
      gdk-pixbuf 
      glib
      gtk2 
      gtk3 
      iconv 
      libGLU 
      libglvnd 
      pango 
      xorg.libX11 
      xorg.libXxf86vm
      xorg.libXtst
      jdk8
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -ar * $out
      rm -rf $out/PowderPlot
    '';

    preFixup = let
      libPath = pkgs.lib.makeLibraryPath (with pkgs; [ 
        cairo
        fontconfig.lib 
        gcc-unwrapped.lib 
        gcc-unwrapped.libgcc 
        gdk-pixbuf     
        glib
        gtk2           
        gtk3           
        iconv          
        libGLU         
        libglvnd       
        pango          
        xorg.libX11    
        xorg.libXxf86vm
        xorg.libXtst
        jdk8
      ]);
    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/VESTA
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/VESTA-core
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/VESTA-gui
    '';

    meta = with lib; {
      homepage = "https://jp-minerals.org/vesta/en/";
      description = "Visualization for Electronic and STructural Analysis";
      license = licenses.free;
      mainProgram = "VESTA";
      platforms = platforms.linux;
      architectures = [ "amd64" ];
    };
  };

  # This script creates the necessary GTK schema directory and copies GTK3 schemas
  setupVestaSchema = pkgs.writeShellScriptBin "setup-vesta-schema" ''
    mkdir -p ~/.local/share/glib-2.0/schemas
    cp -p "${pkgs.gtk3}/share/gsettings-schemas/gtk+3"*/glib-2.0/schemas/gschemas.compiled ~/.local/share/glib-2.0/schemas/ -iv
    echo "GTK schemas have been set up for VESTA"
  '';

  # This script launches VESTA with the correct environment
  vestaLauncher = pkgs.writeShellScriptBin "vesta" ''
    # Check if GTK schemas directory exists, if not create it
    if [ ! -f ~/.local/share/glib-2.0/schemas/gschemas.compiled ]; then
      setup-vesta-schema
    fi
    
    # Launch VESTA
    exec ${vesta}/VESTA "$@"
  '';
in
{
  # Make the package and launcher available in the system
  environment.systemPackages = [ 
    vesta 
    setupVestaSchema
    vestaLauncher
  ];
}
