{
  config,
  pkgs,
  inputs,
  ...
}: let
  userName = "dotempo";
  homeDirectory = "/home/${userName}";
  stateVersion = "25.05";
in {
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    file = {
      # Remove the .config/hypr directory linking since we're using the module

      # wlogout icons
      ".config/wlogout/icons".source = ../../config/wlogout;

      # Top Level Files symlinks
      ".zshrc".source = ../../dotfiles/.zshrc;
      ".zprofile".source = ../../dotfiles/.zprofile;
      ".gitconfig".source = ../../dotfiles/.gitconfig;
      ".nirc".source = ../../dotfiles/.nirc;
      ".local/bin/wallpaper".source = ../../dotfiles/.local/bin/wallpaper;

      # Config directories
      ".config/alacritty".source = ../../dotfiles/.config/alacritty;
      ".config/dunst".source = ../../dotfiles/.config/dunst;
      ".config/fastfetch".source = ../../dotfiles/.config/fastfetch;
      ".config/kitty".source = ../../dotfiles/.config/kitty;
      ".config/mpv".source = ../../dotfiles/.config/mpv;
      ".config/tmux/tmux.conf".source = ../../dotfiles/.config/tmux/tmux.conf;
      ".config/waybar".source = ../../dotfiles/.config/waybar;
      ".config/yazi".source = ../../dotfiles/.config/yazi;
      ".config/wezterm".source = ../../dotfiles/.config/wezterm;
      ".config/ghostty".source = ../../dotfiles/.config/ghostty;

      # Individual config files
      ".config/kwalletrc".source = ../../dotfiles/.config/kwalletrc;
      ".config/starship.toml".source = ../../dotfiles/.config/starship.toml;

      # Wallpapers
      "Pictures/wallpapers".source = ../../dotfiles/wallpapers;
    };
    sessionVariables = {
      # Default applications
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "zen";
      # XDG Base Directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      # Wayland and Hyprland specific
      JAVA_AWT_WM_NOREPARENTING = 1;
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      # NVIDIA specific
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      # Localization
      LC_ALL = "en_US.UTF-8";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    packages = [
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
      # Add packages that might be needed for hypridle/hyprlock
      pkgs.brillo  # for brightness control
    ];
  };

  imports = [
    ../../config/rofi/rofi.nix
    ../../config/wlogout.nix
    ../../modules/nvchad.nix
    # Use the hypridle and hyprlock
    ../../modules/wayland/hypridle_and_hyprlock.nix
    # Use the new hyprland module
    ../../modules/wayland/hyprland.nix
  ];

  # Styling
  stylix.targets.waybar.enable = false;
  stylix.targets.hyprlock.enable = false;

  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";
  };

  programs.home-manager.enable = true;
}
