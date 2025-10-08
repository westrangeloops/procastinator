{ pkgs }:

pkgs.writeShellScriptBin "oled-theme-rotate" ''
  # OLED Burn-in Protection - Theme Rotation
  # Alternates between two color themes every 15 minutes
  
  THEME=1
  
  apply_theme1() {
    echo "Applying Theme 1 (Rose Pine)"
    
    # Hyprland borders and colors
    hyprctl keyword general:col.active_border "rgba(c4a7e7ee) rgba(9ccfd8ee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(26233a99)"
    hyprctl keyword decoration:active_opacity "0.98"
    hyprctl keyword decoration:inactive_opacity "0.95"
    
    # HyprPanel theme (if using)
    # hyprctl keyword plugin:hyprpanel:bar.background "rgba(49, 50, 68, 0.7)"
  }
  
  apply_theme2() {
    echo "Applying Theme 2 (Rose Pine Dawn)"
    
    # Hyprland borders and colors (lighter variant)
    hyprctl keyword general:col.active_border "rgba(eb6f92ee) rgba(f6c177ee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(dfdad9aa)"
    hyprctl keyword decoration:active_opacity "0.96"
    hyprctl keyword decoration:inactive_opacity "0.93"
    
    # HyprPanel theme (if using)
    # hyprctl keyword plugin:hyprpanel:bar.background "rgba(250, 244, 237, 0.7)"
  }
  
  # Main loop
  while true; do
    if [ "$THEME" -eq 1 ]; then
      apply_theme1
      THEME=2
    else
      apply_theme2
      THEME=1
    fi
    
    # Wait 15 minutes (900 seconds)
    sleep 900
  done
''
