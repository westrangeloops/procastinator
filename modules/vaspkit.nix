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
      sha256 = "09yda5ks62icv1sx0vh0fnrzrv0a8blp5mzhhnaxw15d0i26z3ny";
    };

    nativeBuildInputs = with pkgs; [ 
      autoPatchelfHook
      gcc
      glibc
    ];

    buildInputs = with pkgs; [
      glibc
      gcc.cc.lib
    ];

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
