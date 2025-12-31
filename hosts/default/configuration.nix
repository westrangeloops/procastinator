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
    ../../modules/boot.nix
    ../../modules/plymouth.nix
    ../../modules/wayland/security.nix
    ../../modules/vesta.nix
    ../../modules/vesta-desktop.nix
    ../../modules/vaspkit.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    # Remove NVIDIA modules from early loading - they should load automatically when needed
    # Loading them too early can cause boot failures
    kernelModules = ["amdgpu" "v4l2loopback" "i2c-dev"];
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "kernel.nmi_watchdog" = 0;
    };
    kernelParams = [
      # AMD CPU power management
      "amd_pstate=active"
      "amd_iommu"
      
      # Force enable unsupported GPUs for NVIDIA open kernel module
      "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"

      # Performance optimizations
      # Note: mitigations=off disables CPU security patches for better performance
      # Remove this if security is a concern
      "mitigations=off"
      "nvme_core.default_ps_max_latency_us=0"

      # USB autosuspend delay - 20 minutes (1200 seconds)
      "usbcore.autosuspend=600"

      # Boot parameters for smooth splash screen
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"
    '';
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
    # Plymouth is configured via modules/plymouth.nix
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      enable = true; # It's good practice to explicitly enable it
      allowedTCPPorts = [ 8003 ];
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
    image = ../../dotfiles/wallpapers/wallwhale.png;
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
    # Disable Stylix's Plymouth theming to use custom theme
    targets.plymouth.enable = false;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
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


    # Programming languages and tools
    sqlc
    lua
    uv
    clang
    mongodb-compass
    gcc
    openssl

    # Python with essential packages
    python3
    python3Packages.requests


    # Version control and development tools
    git
    gh
    lazygit
    lazydocker
    gnumake
    coreutils
    nixfmt-rfc-style

    # Shell and terminal utilities
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

    # File management and archives
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # System monitoring and management
    btop
    lm_sensors
    inxi

    # Network and internet tools
    qbittorrent

    # Audio and video
    pulseaudio
    pavucontrol
    ffmpeg
    vlc

    # Image and graphics
    gimp
    inkscape
    hyprpicker
    swww
    waypaper
    imv

    # Productivity and office
    obsidian
    smassh

    # Browsers
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
    asusctl

    # Wayland specific
    hyprshot
    grim
    slurp
    waybar
    hyprpanel
    dunst
    wl-clipboard
    swaynotificationcenter

    # File systems
    ntfs3g
    os-prober

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    fastfetch
    onefetch
    microfetch

    # Networking
    networkmanagerapplet


    # Music and streaming
    steam

    # Miscellaneous
    tuigreet
    libsForQt5.qt5.qtgraphicaleffects

    # PDF
    kdePackages.okular

    # Chinese
    noto-fonts-cjk-sans

  ];

  environment.etc."sddm/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=Hyprland
    Type=Application
  '';

  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
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
    asusd = {
      enable = true;
      enableUserService = true;
    };
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

    blueman.enable = true;

    # SCX scheduler for SSD/NVME optimization
    scx.enable = true;
    scx.scheduler = "scx_rusty";

    xserver = {
      xkb = {
        layout = "us";
        variant = "intl";
      };
      videoDrivers = [
      "modesetting"
      "nvidia"
      ];
    };

     logind = {
      settings = {
        Login = {
          HandlePowerKey = "suspend";
        };
      };
    };

    ollama = {
      enable = true;
    };

    neo4j = {
      enable = true;
      # Default port 7474 for HTTP, 7687 for Bolt
    };

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

    # Power management is now handled by TLP in power.nix module
    # auto-cpufreq conflicts with TLP, so it's disabled
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
  };

  systemd.services = {
    flatpak-repo = {
      path = [ pkgs.flatpak ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
    };

    # Power down NVIDIA GPU when not in use (for Prime offload setups)
    nvidia-power-down = {
      description = "Power down NVIDIA GPU when not in use";
      wantedBy = [ "multi-user.target" ];
      after = [ "display-manager.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "nvidia-power-down" ''
          # Wait a bit for system to stabilize
          sleep 5
          # Try to set NVIDIA GPU to D3 (powered down) if possible
          # This only works if no processes are using the GPU
          if [ -f /sys/bus/pci/devices/0000:64:00.0/power/control ]; then
            echo auto > /sys/bus/pci/devices/0000:64:00.0/power/control || true
          fi
        '';
      };
    };

    # CRITICAL: Ensure ASUS fans are enabled and running
    # This service ensures fans are active to prevent overheating
    asus-fan-control = {
      description = "Ensure ASUS fans are enabled - CRITICAL for temperature control";
      wantedBy = [ "multi-user.target" ];
      after = [ "asusd.service" "network.target" ];
      requires = [ "asusd.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
        ExecStart = pkgs.writeShellScript "asus-fan-control" ''
          # Wait for asusd to be fully ready
          sleep 5
          
          # CRITICAL: Set GPU MUX to Hybrid (dGPU available for offload) by default
          # This ensures NVIDIA dGPU is powered and available for offload
          ${pkgs.asusctl}/bin/asusctl graphics -m Hybrid || true
          
          # CRITICAL: Set profile to Balanced or Performance to ensure fans are ON
          # Quiet/Silent mode can turn fans off completely - DANGEROUS!
          ${pkgs.asusctl}/bin/asusctl profile -P Balanced || \
          ${pkgs.asusctl}/bin/asusctl profile -P Performance || true
          
          # Set fan curves to ensure active cooling
          ${pkgs.asusctl}/bin/asusctl fan-curve -m Balanced -D cpu || true
          ${pkgs.asusctl}/bin/asusctl fan-curve -m Balanced -D gpu || true
          
          # Log the current settings for debugging
          echo "ASUS GPU mode: $(asusctl graphics -g 2>/dev/null || echo 'unknown')" || true
          echo "ASUS fan profile: $(asusctl profile -p 2>/dev/null || echo 'unknown')" || true
        '';
      };
    };
  };

  # udev rules for consistent GPU device paths
  # This creates symlinks /dev/dri/amd-igpu and /dev/dri/nvidia-dgpu
  # that always point to the correct card, even if card numbers change at boot
  # PCI bus IDs from lspci: AMD at 65:00.0, NVIDIA at 64:00.0
  # Format: lspci shows "bus:device.function", udev KERNELS uses "0000:bus:device.function"
  services.udev.extraRules = ''
    # AMD iGPU at PCI:65:00.0 (from lspci: 65:00.0)
    KERNEL=="card*", KERNELS=="0000:65:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
    # NVIDIA dGPU at PCI:64:00.0 (from lspci: 64:00.0)
    KERNEL=="card*", KERNELS=="0000:64:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-dgpu"
  '';

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
      powerOnBoot = false;
    };
    # Drivers Graphical
    graphics.enable = true;
    amdgpu.opencl.enable = true;
    nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        # Enable fine-grained power management to power down GPU when not in use
        powerManagement.finegrained = true;

        # REQUIRED: RTX 50-series (and Turing+) requires open kernel modules
        # The proprietary kernel module does not support this GPU
        open = true;

        # Add parameter to enable unsupported GPUs for the open kernel module
        # This is often needed for very new hardware (like RTX 50-series) on initial driver support
        nvidiaSettings = true;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          # Updated PCI bus IDs to match actual hardware (from lspci, converted to decimal)
          # AMD iGPU: 65:00.0 (Hex) -> 101:00:0 (Decimal)
          amdgpuBusId = "PCI:101:0:0";
          # NVIDIA dGPU: 64:00.0 (Hex) -> 100:00:0 (Decimal)
          nvidiaBusId = "PCI:100:0:0";
        };

        # Use the beta driver for RTX 50-series support
        package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };


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
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/chrome" = "google-chrome.desktop";
    "text/html" = "google-chrome.desktop";
    "application/x-extension-htm" = "google-chrome.desktop";
    "application/x-extension-html" = "google-chrome.desktop";
    "application/x-extension-shtml" = "google-chrome.desktop";
    "application/x-extension-xhtml" = "google-chrome.desktop";
    "application/xhtml+xml" = "google-chrome.desktop";

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
    "application/pdf" = "okular.desktop";

    # Torrents
    "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";

    # Other handlers
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";
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
