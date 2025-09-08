{
  lib,
  pkgs,
  ...
}:

let
  vaspkit = pkgs.stdenv.mkDerivation rec {
    pname = "vaspkit";
    version = "1.5.1";

    src = pkgs.fetchurl {
      url = "https://sourceforge.net/projects/vaspkit/files/Binaries/vaspkit.${version}.linux.x64.tar.gz/download";
      sha256 = "QbvcB1n3LNQ+9+L1QdIopjm9lduipUk5iyj0fXYNcrE=";
    };

    nativeBuildInputs = with pkgs; [ 
      autoPatchelfHook
      gcc
      glibc
      pkgs.gzip
      pkgs.gnutar
    ];

    buildInputs = with pkgs; [
      glibc
      gcc.cc.lib
    ];

    unpackPhase = ''
      mkdir -p $sourceRoot
      tar -xzf $src -C $sourceRoot --strip-components=1
    '';

    sourceRoot = "vaspkit.${version}";

    installPhase = ''
      mkdir -p $out/bin
      cp bin/vaspkit $out/bin/
      chmod +x $out/bin/vaspkit
    '';

    meta = with lib; {
      description = "VASPKIT - A Pre- and Post-Processing Program for VASP Code";
      homepage = "https://sourceforge.net/projects/vaspkit/";
      license = licenses.unfree; # Check the actual license
      platforms = platforms.linux;
      maintainers = [ ];
    };
  };
in
{
  # Make the package available in the system
  environment.systemPackages = [ vaspkit ];
}
