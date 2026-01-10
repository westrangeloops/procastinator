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
      url = "https://sourceforge.net/projects/vaspkit/files/Binaries/vaspkit.1.5.1.linux.x64.tar.gz/download";
      sha256 = "sha256-QbvcB1n3LNQ+9+L1QdIopjm9lduipUk5iyj0fXYNcrE=";
    };

    # Add this phase to manually unpack the tarball
    unpackPhase = ''
      runHook preUnpack
      tar -xzvf $src --strip-components=1
      runHook postUnpack
    '';

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      # gcc and glibc are not needed here, autoPatchelfHook finds them
    ];

    # These are runtime dependencies that autoPatchelfHook will find
    buildInputs = with pkgs; [
      glibc
      gcc.cc.lib
    ];

    # sourceRoot is no longer needed because unpackPhase handles changing into the directory

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp bin/vaspkit $out/bin/
      chmod +x $out/bin/vaspkit
      runHook postInstall
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
