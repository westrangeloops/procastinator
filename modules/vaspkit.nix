{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "vaspkit";
  version = "1.5.1";

  src = pkgs.fetchurl {
    url = "https://sourceforge.net/projects/vaspkit/files/Binaries/vaspkit.${version}.linux.x64.tar.gz/download";
    sha256 = "sha256-41bbdc0759f72cd43ef7e2f541d228a639bd95dba2a549398b28f47d760d72b1";
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

  meta = with pkgs.lib; {
    description = "VASPKIT - A Pre- and Post-Processing Program for VASP Code";
    homepage = "https://sourceforge.net/projects/vaspkit/";
    license = licenses.unfree; # Check the actual license
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
