{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Main Hyprland configuration
    settings = {
      # Monitors
      monitor = [
        ",1920x1080@60,auto,1"
      ];
      
      # Variables
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      "$scrPath" = "$HOME/.dotfiles/scripts";
      
      # Autostart
      exec-once = [
        "nm-applet &"
        "hyprpanel"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hypridle &"
        "swww-daemon &"
      ];
      
      # Environment variables
      env = [
        "HYPRCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      
      # Cursor
      cursor = {
        no_hardware_cursors = true;
      };
      
      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 12;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      
      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      
      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Misc
      misc = {
        disable_hyprland_logo = true;
        disable_hyprland_qtutils_check = true;
      };
      
      # Input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "ctrl:nocaps";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        
        touchpad = {
          natural_scroll = false;
        };
      };
      
      # Gestures
      gestures = {
        workspace_swipe = false;
      };
      
      # Device specific
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
      
      # Variables for keybindings
      "$mainMod" = "SUPER";
      "$term" = "kitty";
      "$code" = "code --ozone-platform-hint=wayland --disable-gpu";
      "$file" = "thunar";
      "$brave" = "brave --ozone-platform-hint=wayland --disable-gpu";
      "$browser" = "zen";
      "$telegram" = "telegram-desktop";
      "$powermenu" = "rofi -show power-menu -modi power-menu:/home/dotempo/.local/bin/rofi-power-menu";
      "$lock" = "hyprlock";
      
      # Keybindings
      bind = [
        # Basic bindings
        "$mainMod, RETURN, exec, $term"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "Alt, Return, fullscreen,"
        "$mainMod, E, exec, $file"
        "$mainMod, F, exec, $browser"
        "$mainMod, B, exec, $brave"
        "$mainMod, T, exec, $telegram"
        "$mainMod, O, exec, $lock"
        "$mainMod, W, togglefloating,"
        "$mainMod, A, exec, $menu"
        "$mainMod, BACKSPACE, exec, wlogout"
        "$mainMod, SPACE, exec, rofimoji"
        
        # Function keys
        ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        
        # Clipboard
        "ALT, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        
        # Screenshots
        "CTRL, print, exec, hyprshot -m output -o ~/Pictures/Screenshots"
        "CTRL SHIFT, print, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        
        # Movement
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, j, movefocus, u"
        "$mainMod, k, movefocus, d"
        
        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Mouse workspace navigation
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # VM passthrough
        "$mainMod, P, submap, passthru"
      ];
      
      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Window rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "opacity 0.95 0.95,class:^(firefox)$"
        "opacity 0.95 0.95,class:^(jetbrains-idea)$"
        "opacity 0.95 0.95,class:^(zen)$"
        "opacity 0.95 0.95,class:^(obsidian)$"
        "opacity 0.95 0.95,class:^(intellij-idea-ultimate-edition)$"
      ];
      
      # Submaps
      submap = [
        "passthru"
        "SUPER, Escape, submap, reset"
        "reset"
      ];
    };
    
    # Extra config for things that don't fit in settings
    extraConfig = ''
      # VM Passthrough submap
      submap = passthru
      bind = SUPER, Escape, submap, reset
      submap = reset
    '';
  };
}