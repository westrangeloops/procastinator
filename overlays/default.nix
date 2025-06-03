
# overlays.nix
{ inputs, lib, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
        pname = "sf-mono-liga-bin";
        version = "dev";
        src = inputs.sf-mono-liga-src;
        dontConfigure = true;
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype/
        '';
      };

      pkgs-master = import inputs.nixpkgs-master {
        system = final.system;
        config.allowUnfree = true;
      };

      linuxPackages_cachyos = prev.linuxPackages_cachyos.extend (_: prev': {
        v4l2loopback = prev'.v4l2loopback.overrideAttrs (_: rec {
          version = "0.15.0";
          src = final.fetchFromGitHub {
            owner = "umlaeute";
            repo = "v4l2loopback";
            rev = "v${version}";
            hash = "sha256-fa3f8GDoQTkPppAysrkA7kHuU5z2P2pqI8dKhuKYh04=";
          };
        });
      });
    })
  ];
}

# This file defines overlays

