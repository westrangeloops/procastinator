
{
  input = {
    keyboard = {
      xkb = {
        layout = "us";
        model = "";
        rules = "";
        variant = "";
        options = "caps:swapescape";
      };
      repeat-delay = 600;
      repeat-rate = 25;
      track-layout = "global";
    };
    touchpad = {
      tap = true;
      dwt = true;
      dwtp = true;
      middle-emulation = true;
      accel-speed = 0.0;
      accel-profile = "adaptive";
      scroll-method = "two-finger";
      click-method = "button-areas";
      tap-button-map = "left-right-middle";
      scroll-factor = 0.7;
    };
    mouse.accel-speed = 0.0;
    trackpoint.accel-speed = 0.0;
    trackball.accel-speed = 0.0;
    tablet = true;
    touch = true;
    warp-mouse-to-focus = true;
    focus-follows-mouse = true;
    workspace-auto-back-and-forth = true;
  };

  output = {
    "HDMI-A-1" = {
      scale = 1.0;
      transform = "normal";
      position = { x = 0; y = -1080; };
      mode = "1920x1080";
    };
    "eDP-1" = {
      scale = 1.0;
      transform = "normal";
      position = { x = 0; y = 0; };
      mode = "2160x1440";
    };
  };

  screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
  prefer-no-csd = true;

  overview.backdrop-color = "#11121d";

  layout = {
    background-color = "transparent";
    gaps = 6;
    struts = { left = 0; right = 0; top = 0; bottom = 0; };
    focus-ring.off = true;
    border = {
      width = 2;
      active-gradient = {
        angle = 150;
        from = "#e97078";
        relative-to = "window";
        to = "#80c8ff";
      };
      inactive-gradient = {
        angle = 180;
        from = "#414868";
        relative-to = "window";
        to = "#1e1e2e";
      };
    };
    shadow = {
      on = true;
      offset = { x = 2; y = 2; };
      softness = 40;
      spread = 6;
      draw-behind-window = false;
      color = "rgba(0, 0, 0, 0.5)";
    };
    tab-indicator = {
      hide-when-single-tab = true;
      place-within-column = true;
      gap = -12.0;
      width = 4.0;
      length = { total-proportion = 0.1; };
      position = "left";
      gaps-between-tabs = 10.0;
      corner-radius = 10.0;
    };
    insert-hint.color = "rgb(127 200 255 / 50%)";
    default-column-width.proportion = 0.75;
    preset-column-widths = [
      { proportion = 0.33; }
      { proportion = 0.5; }
      { proportion = 0.75; }
      { proportion = 1.0; }
    ];
    center-focused-column = "never";
    always-center-single-column = true;
  };

  cursor = {
    xcursor-theme = "LyraS-cursors";
    xcursor-size = 34;
  };

  hotkey-overlay.skip-at-startup = true;

  environment = {
    CLUTTER_BACKEND = "wayland";
    DISPLAY = "null";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11";
    GTK_THEME = "Material-DeepOcean-BL-LB";
    JAVA_AWT_WM_NONEREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  window-rule = [
    { draw-border-with-background = false; geometry-corner-radius = [ 5.0 5.0 5.0 5.0 ]; clip-to-geometry = true; }
    { match = { app-id = "^niri$"; }; opacity = 1.0; }
    { match = { is-focused = false; }; opacity = 0.95; }
    { match = { is-floating = true; }; shadow.on = true; }
    {
      match = { is-window-cast-target = true; };
      border.inactive-color = "#a9b1d600";
      focus-ring = { active-color = "#f38ba8"; inactive-color = "#a9b1d600"; };
      shadow.color = "#f38ba800";
      tab-indicator = { active-color = "#f38ba8"; inactive-color = "#a9b1d600"; };
    }
    { match = { app-id = "org.telegram.desktop"; }; block-out-from = "screencast"; }
    { match = { app-id = "app.drey.PaperPlane"; }; block-out-from = "screencast"; }
    { match = { app-id = "^(zen|firefox|chromium-browser|chrome-.*|zen-.*)$"; }; scroll-factor = 0.85; }
    { match = { app-id = "^(Komikku|info.febvre.Komikku.*)$"; }; scroll-factor = 0.15; }
    { match = { app-id = "^(zen|firefox|equibop|chromium-browser|edge|chrome-.*|zen-.*)$"; }; open-maximized = false; }
    {
      match = [
        { app-id = "firefox$"; title = "^Picture-in-Picture$"; }
        { app-id = "zen-.*$"; title = "^Picture-in-Picture$"; }
        { title = "^Picture in picture$"; }
        { title = "^Discord Popout$"; }
      ];
      open-floating = true;
      default-floating-position = { relative-to = "top-right"; x = 32; y = 32; };
    }
    { match = { app-id = "^(org.wezfurlong.wezterm|kitty|com.mitchellh.ghostty)$"; }; opacity = 0.96; }
    { match = { app-id = "^(pwvucontrol|Volume Control|dialog|file_progress|confirm|download|error|notification|thunar|discord|spotify)$"; }; open-floating = true; }
  ];

  layer-rule = [
    { match.namespace = "^swww-daemon$"; place-within-backdrop = true; }
  ];

  animations = {
    slowdown = 2.0;
    window-open = {
      duration-ms = 200;
      curve = "linear";
      custom-shader = "vec4 expanding_circle(vec3 coords_geo, vec3 size_geo) { ... }";
    };
    window-close = {
      duration-ms = 250;
      curve = "linear";
      custom-shader = "vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) { ... }";
    };
    window-resize = {
      spring = { damping-ratio = 1.0; epsilon = 0.0001; stiffness = 800; };
      custom-shader = "vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) { ... }";
    };
  };
}
