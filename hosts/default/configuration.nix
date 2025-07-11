{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  username = "dotempo";
  userDescription = "dotempo";
  homeDirectory = "/home/${username}";
  hostName = "dotempo";
  timeZone = "America/Sao_Paulo";
in
{
  imports = [
    ./hardware-configuration.nix
    ./user.nix
    ../../modules/amd-drivers.nix
    ../../modules/boot.nix
    ../../modules/wayland/security.nix
    ../../modules/power.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelModules = ["amdgpu" "v4l2loopback" "i2c-dev"];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "kernel.nmi_watchdog" = 0;
    };
    kernelParams = [
      "amd_pstate=active"
      "amd_iommu"
      "mitigations=off"
      "nvme_core.default_ps_max_latency_us=0"
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"
    '';
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "16G";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      allowedTCPPorts = [ 8003 ];
    };
    firewall = {
      checkReversePath = "loose";
    };
  };

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };
    image = ../../dotfiles/wallpapers/wallwhale.jpg;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        runAsRoot = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    firefox.enable = false;
    dconf.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
    users.${username} = {
      isNormalUser = true;
      description = userDescription;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        firefox
        thunderbird
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Text editors and IDEs
    nano
    code-cursor-fhs

    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    # Programming languages and tools
    go
    go-blueprint
    go-migrate
    sqlc
    goose
    air
    lua
    uv
    clang
    zig
    rustup
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    fnm
    bun
    maven
    mongodb-compass
    gcc
    openssl
    nodePackages_latest.live-server


    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    bruno
    postman
    bruno-cli
    gnumake
    coreutils
    nixfmt-rfc-style
    meson
    ninja

    # Shell and terminal utilities
    stow
    wget
    killall
    eza
    starship
    kitty
    zoxide
    fzf
    tmux
    progress
    tree
    alacritty
    exfatprogs

    # inputs.ghostty.packages.${pkgs.system}.default

    # File management and archives
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # System monitoring and management
    htop
    btop
    lm_sensors
    inxi
    # nvtopPackages.nvidia
    anydesk

    # Network and internet tools
    aria2
    qbittorrent
    cloudflare-warp
    tailscale


    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    mpv
    deadbeef-with-plugins

    # Image and graphics
    imagemagick
    gimp
    hyprpicker
    swww
    waypaper
    imv

    # Productivity and office
    obsidian


    # Communication and social
    zoom-us
    vesktop

    # Browsers
    firefox
    google-chrome

    # System utilities
    libgcc
    bc
    kdePackages.dolphin
    lxqt.lxqt-policykit
    libnotify
    v4l-utils
    ydotool
    pciutils
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    yad
    playerctl
    nh
    ansible

    # Wayland specific
    hyprshot
    grim
    slurp
    waybar
    hyprpanel
    dunst
    wl-clipboard
    swaynotificationcenter

    # Virtualization
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # File systems
    ntfs3g
    os-prober

    # Downloaders
    yt-dlp
    localsend

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet


    # Music and streaming
    spotify

    # Miscellaneous
    greetd.tuigreet
    libsForQt5.qt5.qtgraphicaleffects
  ];

  environment.etc."sddm/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=Hyprland
    Type=Application
  '';

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    fira-sans
    roboto
    noto-fonts-cjk-sans
    font-awesome
    material-icons
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  services = {
    # Ananicy - process scheduler enhancer
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git.overrideAttrs (prevAttrs: {
        patches = [
          (pkgs.fetchpatch {
            # Revert removal of Compiler rules
            url = "https://github.com/CachyOS/ananicy-rules/commit/5459ed81c0e006547b4f3a3bc40c00d31ad50aa9.patch";
            revert = true;
            hash = "sha256-vc6FDwsAA6p5S6fR1FSdIRC1kCx3wGoeNarG8uEY2xM=";
          })
        ];
      });
    };

    # SCX scheduler for SSD/NVME optimization
    scx.enable = true;
    scx.scheduler = "scx_rusty";

    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "intl";
      };
      videoDrivers = [ "modesetting" ];
    };
    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };
    cloudflare-warp.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    # ollama = {
    #   enable=true;
    #   acceleration = "cuda";
    # };
    cron = {
      enable = true;
    };
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = true;
      user = username;
      dataDir = homeDirectory;
      configDir = "${homeDirectory}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;
  };

  powerManagement = {
    enable = true;
    powerDownCommands = ''
      # Lock all sessions
      loginctl lock-sessions

      # Wait for lockscreen(s) to be up
      sleep 1
    '';
  };

  systemd.services = {
    flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };
    libvirtd = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      requires = [ "virtlogd.service" ];
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  services.blueman.enable = true;

  security = {
    rtkit.enable = true;
    tpm2.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = "auth include login";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  programs.hyprland.enable = true;

  xdg.mime.defaultApplications = {
    # Web and HTML
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/chrome" = "zen.desktop";
    "text/html" = "zen.desktop";
    "application/x-extension-htm" = "zen.desktop";
    "application/x-extension-html" = "zen.desktop";
    "application/x-extension-shtml" = "zen.desktop";
    "application/x-extension-xhtml" = "zen.desktop";
    "application/xhtml+xml" = "zen.desktop";

    # File management
    "inode/directory" = "org.kde.dolphin.desktop";

    # Text editor
    "text/plain" = "nvim.desktop";

    # Terminal
    "x-scheme-handler/terminal" = "kitty.desktop";

    # Videos
    "video/quicktime" = "mpv-2.desktop";
    "video/x-matroska" = "mpv-2.desktop";

    # LibreOffice formats
    "application/vnd.oasis.opendocument.text" = "libreoffice-writer.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice-calc.desktop";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice-impress.desktop";
    "application/vnd.ms-excel" = "libreoffice-calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice-calc.desktop";
    "application/msword" = "libreoffice-writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
      "libreoffice-writer.desktop";
    "application/vnd.ms-powerpoint" = "libreoffice-impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
      "libreoffice-impress.desktop";

    # PDF
    "application/pdf" = "zen.desktop";

    # Torrents
    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

    # Other handlers
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
    "x-scheme-handler/postman" = "Postman.desktop";
    "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.${username} = import ./home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  system.stateVersion = "25.05";
}
