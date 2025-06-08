
pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property color background: "#1a1b26"
  readonly property color error: "#f7768e"
  readonly property color error_container: "#c53b53"
  readonly property color inverse_on_surface: "#a9b1d6"
  readonly property color inverse_primary: "#11121d"
  readonly property color inverse_surface: "#2e3440"
  readonly property color on_background: "#c0caf5"
  readonly property color on_error: "#1f0f16"
  readonly property color on_error_container: "#f7768e"
  readonly property color on_primary: "#1a1b26"
  readonly property color on_primary_container: "#11121d"
  readonly property color on_primary_fixed: "#16161e"
  readonly property color on_primary_fixed_variant: "#f7768e"
  readonly property color on_secondary: "#1a1b26"
  readonly property color on_secondary_container: "#11121d"
  readonly property color on_secondary_fixed: "#16161e"
  readonly property color on_secondary_fixed_variant: "#4b547e"
  readonly property color on_surface: "#c0caf5"
  readonly property color on_surface_variant: "#a9b1d6"
  readonly property color on_tertiary: "#1a1b26"
  readonly property color on_tertiary_container: "#bb9af7"
  readonly property color on_tertiary_fixed: "#1f1d30"
  readonly property color on_tertiary_fixed_variant: "#6e5c99"
  readonly property color outline: "#565f89"
  readonly property color outline_variant: "#3b4261"
  readonly property color primary: "#f7768e"
  readonly property color primary_container: "#f7768e"
  readonly property color primary_fixed: "#11121d"
  readonly property color primary_fixed_dim: "#11121d"
  readonly property color scrim: "#000000"
  readonly property color secondary: "#11121d"
  readonly property color secondary_container: "#4b547e"
  readonly property color secondary_fixed: "#9aa5ce"
  readonly property color secondary_fixed_dim: "#6e789c"
  readonly property color shadow: "#000000"
  readonly property color surface: "#1a1b26"
  readonly property color surface_bright: "#2e3440"
  readonly property color surface_container: "#1f2335"
  readonly property color surface_container_high: "#24283b"
  readonly property color surface_container_highest: "#2e3440"
  readonly property color surface_container_low: "#1c1e2a"
  readonly property color surface_container_lowest: "#16161e"
  readonly property color surface_dim: "#1a1b26"
  readonly property color surface_tint: "#11121d"
  readonly property color surface_variant: "#3b4261"
  readonly property color tertiary: "#11121d"
  readonly property color tertiary_container: "#6e5c99"
  readonly property color tertiary_fixed: "#11121d"
  readonly property color tertiary_fixed_dim: "#11121d"

  function withAlpha(color: color, alpha: real): color {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}


