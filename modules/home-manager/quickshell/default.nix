{ inputs, pkgs, config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf;

  quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;

  qtDeps = with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtmultimedia
    qtstyleplugin-kvantum
  ];

  qsWrapper = pkgs.symlinkJoin {
    name = "qs-wrapper";
    paths = [ quickshellPackage ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = let
      qt6Qml = lib.concatMapStringsSep ":" (pkg: "${pkg}/lib/qt-6/qml") qtDeps;
      qt5Qml = "${pkgs.libsForQt5.qtstyleplugin-kvantum}/lib/qt-5/qml";
      qmlPath = "${qt6Qml}:${qt5Qml}";
    in ''
      wrapProgram $out/bin/quickshell \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --add-flags '-c ${../../../configs/quickshell/qml}'
    '';
    meta.mainProgram = "quickshell";
  };
in {
  home.packages = [
    qsWrapper
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.kdePackages.qtstyleplugin-kvantum
    pkgs.wlsunset
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtmultimedia
    pkgs.libqalculate
    pkgs.colloid-kde
  ];

  home.activation.installQuickshell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "$HOME/.config/quickshell" ]; then
      chmod -R u+w "$HOME/.config/quickshell"
      rm -rf "$HOME/.config/quickshell"
    fi

    mkdir -p "$HOME/.config/quickshell"
    cp -r ${../../../configs/quickshell}/* "$HOME/.config/quickshell"
    chmod -R u+w "$HOME/.config/quickshell"
  '';
}


