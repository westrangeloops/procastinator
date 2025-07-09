{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  wezterm = inputs.wezterm.packages.${pkgs.system}.default;
in
{
  hj = {
    packages = [ wezterm ];
    files = {
      ".config/wezterm/utils.lua".text = ''
        local wezterm = require("wezterm")
        local M = {}

        M.is_windows = function()
          return wezterm.target_triple:find("windows") ~= nil
        end

        ---@return boolean
        M.is_linux = function()
          return wezterm.target_triple:find("linux") ~= nil
        end

        ---@return boolean
        M.is_darwin = function()
          return wezterm.target_triple:find("darwin") ~= nil
        end

        return M
      '';
      
      ".config/wezterm/bar.lua".text = ''
        -- https://github.com/nekowinston/wezterm-bar
        local wezterm = require("wezterm")

        local M = {}

        -- default configuration
        local config = {
          position = "top", -- or "bottom"
          max_width = 32,
          dividers = "slant_right", -- "slant_right" or "slant_left", "arrows", "rounded", false
          indicator = {
            leader = {
              enabled = true,
              off = " ",
              on = " ",
            },
            mode = {
              enabled = true,
              names = {
                resize_mode = "RESIZE",
                copy_mode = "VISUAL",
                search_mode = "SEARCH",
              },
            },
          },
          tabs = {
            numerals = "arabic", -- or "roman"
            pane_count = "superscript", -- or "subscript", false
            brackets = {
              active = { "", ":" },
              inactive = { "", ":" },
            },
          },
          clock = {
            enabled = false,
            format = "%I:%M %P", -- https://docs.rs/chrono/latest/chrono/format/strftime/index.html
          },
        }

        -- parsed config
        local C = {}

        local function tableMerge(t1, t2)
          for k, v in pairs(t2) do
            if type(v) == "table" then
              if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
              else
                t1[k] = v
              end
            else
              t1[k] = v
            end
          end
          return t1
        end

        local dividers = {
          slant_right = {
            left = utf8.char(0xe0be),
            right = utf8.char(0xe0bc),
          },
          slant_left = {
            left = utf8.char(0xe0bb),
            right = utf8.char(0xe0b8),
          },
          arrows = {
            left = utf8.char(0xe0b2),
            right = utf8.char(0xe0b0),
          },
          rounded = {
            left = utf8.char(0xe0b6),
            right = utf8.char(0xe0b4),
          },
        }

        -- conforming to https://github.com/wez/wezterm/commit/e4ae8a844d8feaa43e1de34c5cc8b4f07ce525dd
        -- exporting an apply_to_config function, even though we don't change the users config
        M.apply_to_config = function(c, opts)
          -- make the opts arg optional
          if not opts then
            opts = {}
          end

          -- combine user config with defaults
          config = tableMerge(config, opts)
          C.div = {
            l = "",
            r = "",
          }

          if config.dividers then
            C.div.l = dividers[config.dividers].left
            C.div.r = dividers[config.dividers].right
          end

          C.leader = {
            enabled = config.indicator.leader.enabled and true,
            off = config.indicator.leader.off,
            on = config.indicator.leader.on,
          }

          C.mode = {
            enabled = config.indicator.mode.enabled,
            names = config.indicator.mode.names,
          }

          C.tabs = {
            numerals = config.tabs.numerals,
            pane_count_style = config.tabs.pane_count,
            brackets = {
              active = config.tabs.brackets.active,
              inactive = config.tabs.brackets.inactive,
            },
          }

          C.clock = {
            enabled = config.clock.enabled,
            format = config.clock.format,
          }

          -- set the right-hand padding to 0 spaces, if the rounded style is active
          C.p = (config.dividers == "rounded") and "" or " "

          -- set wezterm config options according to the parsed config
          c.use_fancy_tab_bar = false
          c.tab_bar_at_bottom = config.position == "bottom"
          c.tab_max_width = config.max_width
        end

        return M
      '';
      
      ".config/wezterm/catppuccin.lua".text = ''
        local wezterm = require("wezterm")

        local M = {}

        local colors = {
          latte = {
            rosewater = "#dc8a78",
            flamingo = "#dd7878",
            pink = "#ea76cb",
            mauve = "#8839ef",
            red = "#d20f39",
            maroon = "#e64553",
            peach = "#fe640b",
            yellow = "#df8e1d",
            green = "#40a02b",
            teal = "#179299",
            sky = "#04a5e5",
            sapphire = "#209fb5",
            blue = "#1e66f5",
            lavender = "#7287fd",
            text = "#4c4f69",
            subtext1 = "#5c5f77",
            subtext0 = "#6c6f85",
            overlay2 = "#7c7f93",
            overlay1 = "#8c8fa1",
            overlay0 = "#9ca0b0",
            surface2 = "#acb0be",
            surface1 = "#bcc0cc",
            surface0 = "#ccd0da",
            crust = "#dce0e8",
            mantle = "#e6e9ef",
            base = "#eff1f5",
          },
          frappe = {
            rosewater = "#f0c6c6",
            flamingo = "#f0c6c6",
            pink = "#c0a7e1",
            mauve = "#bb9af7",
            red = "#f7768e",
            maroon = "#ff9e64",
            peach = "#ff9e64",
            yellow = "#e0af68",
            green = "#9ece6a",
            teal = "#73daca",
            sky = "#7dcfff",
            sapphire = "#7aa2f7",
            blue = "#7aa2f7",
            lavender = "#a9b1d6",
            text = "#a9b1d6",
            subtext1 = "#9aa5ce",
            subtext0 = "#8c96c6",
            overlay2 = "#7e88bd",
            overlay1 = "#7179b5",
            overlay0 = "#636bae",
            surface2 = "#565f89",
            surface1 = "#414868",
            surface0 = "#24283b",
            base = "#11121D",
            mantle = "#16161e",
            crust = "#0f0f14",
          },
          macchiato = {
            rosewater = "#f4dbd6",
            flamingo = "#f0c6c6",
            pink = "#f5bde6",
            mauve = "#c6a0f6",
            red = "#ed8796",
            maroon = "#ee99a0",
            peach = "#f5a97f",
            yellow = "#eed49f",
            green = "#a6da95",
            teal = "#8bd5ca",
            sky = "#91d7e3",
            sapphire = "#7dc4e4",
            blue = "#8aadf4",
            lavender = "#b7bdf8",
            text = "#cad3f5",
            subtext1 = "#b8c0e0",
            subtext0 = "#a5adcb",
            overlay2 = "#939ab7",
            overlay1 = "#8087a2",
            overlay0 = "#6e738d",
            surface2 = "#5b6078",
            surface1 = "#494d64",
            surface0 = "#363a4f",
            base = "#24273a",
            mantle = "#1e2030",
            crust = "#181926",
          },
          mocha = {
            rosewater = "#f5e0dc",
            flamingo = "#f2cdcd",
            pink = "#f5c2e7",
            mauve = "#cba6f7",
            red = "#f38ba8",
            maroon = "#eba0ac",
            peach = "#fab387",
            yellow = "#f9e2af",
            green = "#a6e3a1",
            teal = "#94e2d5",
            sky = "#89dceb",
            sapphire = "#74c7ec",
            blue = "#89b4fa",
            lavender = "#b4befe",
            text = "#cdd6f4",
            subtext1 = "#bac2de",
            subtext0 = "#a6adc8",
            overlay2 = "#9399b2",
            overlay1 = "#7f849c",
            overlay0 = "#6c7086",
            surface2 = "#585b70",
            surface1 = "#45475a",
            surface0 = "#313244",
            base = "#1e1e2e",
            mantle = "#181825",
            crust = "#11111b",
          },
        }

        function M.apply_to_config(c)
          c.color_scheme = "Catppuccin Mocha"
          
          local accent = "mauve"
          
          -- Register all color schemes
          for flavor, palette in pairs(colors) do
            local name = "Catppuccin " .. flavor:gsub("^%l", string.upper)
            wezterm.color.get_builtin_schemes()[name] = {
              foreground = palette.text,
              background = palette.base,
              cursor_fg = flavor == "latte" and palette.base or palette.crust,
              cursor_bg = palette.rosewater,
              cursor_border = palette.rosewater,
              selection_fg = palette.text,
              selection_bg = palette.surface2,
              scrollbar_thumb = palette.surface2,
              split = palette.overlay0,
              ansi = {
                flavor == "latte" and palette.subtext1 or palette.surface1,
                palette.red,
                palette.green,
                palette.yellow,
                palette.blue,
                palette.pink,
                palette.teal,
                flavor == "latte" and palette.surface2 or palette.subtext1,
              },
              brights = {
                flavor == "latte" and palette.subtext0 or palette.surface2,
                palette.red,
                palette.green,
                palette.yellow,
                palette.blue,
                palette.pink,
                palette.teal,
                flavor == "latte" and palette.surface1 or palette.subtext0,
              },
              indexed = { [16] = palette.peach, [17] = palette.rosewater },
              tab_bar = {
                background = palette.crust,
                active_tab = {
                  bg_color = palette[accent],
                  fg_color = palette.crust,
                },
                inactive_tab = {
                  bg_color = palette.mantle,
                  fg_color = palette.text,
                },
                inactive_tab_hover = {
                  bg_color = palette.base,
                  fg_color = palette.text,
                },
                new_tab = {
                  bg_color = palette.surface0,
                  fg_color = palette.text,
                },
                new_tab_hover = {
                  bg_color = palette.surface1,
                  fg_color = palette.text,
                },
              },
            }
          end
        end

        return M
      '';
      
      ".config/wezterm/keybinds.lua".text = ''
        local wezterm = require("wezterm")
        local act = wezterm.action

        local utils = require("utils")

        local M = {}

        local openUrl = act.QuickSelectArgs({
          label = "open url",
          patterns = { "https?://\\S+" },
          action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.open_with(url)
          end),
        })

        local changeCtpFlavor = act.InputSelector({
          title = "Change Catppuccin flavor",
          choices = {
            { label = "Mocha" },
            { label = "Macchiato" },
            { label = "Frappe" },
            { label = "Latte" },
          },
          action = wezterm.action_callback(function(window, _, _, label)
            if label then
              window:set_config_overrides({ color_scheme = "Catppuccin " .. label })
            end
          end),
        })

        local getNewName = act.PromptInputLine({
          description = "Enter new name for tab",
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              window:active_tab():set_title(line)
            end
          end),
        })

        local keys = {
          {key="Tab", mods="CTRL", action=wezterm.action{ActivateTabRelative=1}},
          {key="Tab", mods="CTRL|SHIFT", action=wezterm.action{ActivateTabRelative=-1}},
          {key="Enter", mods="ALT", action="ToggleFullScreen"},
          {
            key = "n",
            mods = "LEADER",
            action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
          },
          {key="Insert", mods="SHIFT", action=wezterm.action{PasteFrom="PrimarySelection"}},
          {key="Insert", mods="CTRL", action=wezterm.action{CopyTo="PrimarySelection"}},
          {key="v", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
          {key="s", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
          {key="h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
          {key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
          {key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
          {key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
          {key="z", mods="LEADER", action="TogglePaneZoomState"},
          {key="/", mods="LEADER", action=wezterm.action{Search={CaseInSensitiveString=""}}},
          {key="q", mods="LEADER", action="QuickSelect"},
          {key="1", mods="LEADER", action=wezterm.action{ActivateTab=0}},
          {key="2", mods="LEADER", action=wezterm.action{ActivateTab=1}},
          {key="3", mods="LEADER", action=wezterm.action{ActivateTab=2}},
          {key="4", mods="LEADER", action=wezterm.action{ActivateTab=3}},
          {key="5", mods="LEADER", action=wezterm.action{ActivateTab=4}},
          {key="6", mods="LEADER", action=wezterm.action{ActivateTab=5}},
          {key="7", mods="LEADER", action=wezterm.action{ActivateTab=6}},
          {key="8", mods="LEADER", action=wezterm.action{ActivateTab=7}},
          {key="9", mods="LEADER", action=wezterm.action{ActivateTab=8}},
          {key="o", mods="LEADER", action="ActivateLastTab"},
          {key="g", mods="LEADER", action="ShowTabNavigator"},
          {key="c", mods="LEADER", action="ShowLauncher"},
          {key="r", mods="LEADER", action="ReloadConfiguration"},
          {key="x", mods="LEADER", action=wezterm.action{CloseCurrentPane={confirm=true}}},
          {key="x", mods="LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
          {key="`", mods="LEADER", action=wezterm.action{SendString="`"}},
        }
        
        local map = function(key, mods, action)
          if type(mods) == "string" then
            table.insert(keys, { key = key, mods = mods, action = action })
          elseif type(mods) == "table" then
            for _, mod in pairs(mods) do
              table.insert(keys, { key = key, mods = mod, action = action })
            end
          end
        end

        map("Enter", "ALT", act.ToggleFullScreen)
        map("e", "CTRL|SHIFT", getNewName)
        map("o", { "LEADER", "SUPER" }, openUrl)
        map("t", "ALT", changeCtpFlavor)

        local mods
        if utils.is_windows() then
          mods = "ALT"
        else
          mods = "CTRL"
        end

        M.apply = function(c)
          c.leader = {
            key = " ",
            mods = mods,
            timeout_milliseconds = math.maxinteger,
          }
          c.keys = keys
        end
        
        return M
      '';
      
      ".config/wezterm/wezterm.lua".text = ''
                           local utils = require("utils")
        local wezterm = require("wezterm")

        local c = {}
        if wezterm.c_builder then
          c = wezterm.config_builder()
        end

        c.enable_wayland = true

        -- theme
        require("catppuccin").apply_to_config(c)
        require("bar").apply_to_config(c)

        -- if utils.is_linux() then
        --   c.window_background_opacity = 0.90
        -- elseif utils.is_darwin() then
        --   c.window_background_opacity = 0.95
        --   c.macos_window_background_blur = 15
        -- elseif utils.is_windows() then
        --   c.window_background_image = "C:\\Users\\Isabel\\Pictures\\wallpapers\\catgirl.jpg"
        --   c.window_background_image_hsb = {
        --   	brightness = 0.03, -- make the bg darker so we can see what we are doing
        --   }
        --   -- c.win32_system_backdrop = "Tabbed"
        --   -- c.window_background_opacity = 0.95
        -- end

        -- load my keybinds
        require("keybinds").apply(c)

        -- default shell
        if utils.is_linux() or utils.is_darwin() then
          c.default_prog = { "fish", "--login" }
        elseif utils.is_windows() then
          c.default_prog = { "wsl.exe" }
          c.default_domain = "WSL:NixOS"
          c.launch_menu = {
            {
              label = "PowerShell",
              args = { "pwsh.exe", "-NoLogo" },
              domain = { DomainName = "local" },
            },
          }
        end

        -- window stuff
        if utils.is_linux() then
          c.window_decorations = "TITLE | RESIZE"
        else
          c.window_decorations = "RESIZE"
        end

        if utils.is_windows() then
          c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
        else
          c.window_padding = { left = 10, right = 10, top = 20, bottom = 10 }
        end

        -- fonts
        c.font = wezterm.font_with_fallback({
           "IoshelfkaMono Nerd Font",
          "JetBrainsMono Nerd Font",
        })
        c.font_size = 14
        c.adjust_window_size_when_changing_font_size = false
        c.window_frame = {
          font = wezterm.font("IoshelfkaMono Nerd Font"),
          font_size = c.font_size,
        }

        -- QOL
        c.audible_bell = "Disabled"
        c.default_cursor_style = "BlinkingBar"
        c.window_close_confirmation = "NeverPrompt"
        -- c.prefer_to_spawn_tabs = true

        if utils.is_windows() then
          c.front_end = "OpenGL"
        else
          c.front_end = "WebGpu"
        end

        -- this is nix so lets not do it
        -- enable this if i ever setup nix to statically link
        -- c.automatically_reload_config = false
        c.check_for_updates = false

        -- TODO:
        -- https://wezfurlong.org/wezterm/config/lua/config/tiling_desktop_environments.html

        return c


      '';
    };
  };
}
