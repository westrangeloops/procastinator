{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      app_launch_prefix = " ";
      close_when_open = true;
      as_window = false;
      disable_click_to_close = true;
      force_keyboard_focus = true;
      hotreload_theme = true;
      locale = "";
      monitor = "";
      terminal_title_flag = "";
      theme = "base16";
      timeout = 0;

      activation_mode.labels = "jkl;as";

      builtins = {
        ai = {
          icon = "help-browser";
          name = "ai";
          placeholder = "AI";
          switcher_only = true;
          weight = 5;
          anthropic.prompts = [
            {
              label = "Artificial Intelligence";
              max_tokens = 1000;
              model = "claude-3-5-sonnet-20241022";
              prompt = "You are a helpful general assistant. Keep your answers short and precise.";
              temperature = 1;
            }
          ];
        };

        applications = {
          context_aware = true;
          hide_actions_with_empty_query = true;
          history = true;
          name = "applications";
          placeholder = "Search..";
          prioritize_new = true;
          refresh = true;
          show_generic = true;
          show_icon_when_single = true;
          show_sub_when_single = true;
          weight = 5;
          theme = "base16_apps";
          actions = {
            enabled = true;
            hide_category = false;
            hide_without_query = true;
          };
        };

        bookmarks = {
          icon = "bookmark";
          name = "bookmarks";
          placeholder = "Bookmarks";
          switcher_only = true;
          weight = 5;
          entries = [
            {
              keywords = ["walker" "github"];
              label = "Walker";
              url = "https://github.com/abenz1267/walker";
            }
          ];
        };

        calc = {
          icon = "accessories-calculator";
          min_chars = 4;
          name = "calc";
          placeholder = "Calculator";
          require_number = true;
          weight = 5;
        };

        clipboard = {
          avoid_line_breaks = true;
          exec = "wl-copy";
          image_height = 300;
          max_entries = 100;
          name = "clipboard";
          placeholder = "Clipboard";
          switcher_only = true;
          weight = 5;
          theme = "base16";
        };

        commands = {
          icon = "utilities-terminal";
          name = "commands";
          placeholder = "Commands";
          switcher_only = true;
          weight = 5;
        };

        custom_commands = {
          icon = "utilities-terminal";
          name = "custom_commands";
          placeholder = "Custom Commands";
          weight = 5;
        };

        dmenu = {
          hidden = true;
          name = "dmenu";
          placeholder = "Dmenu";
          switcher_only = true;
          weight = 5;
        };

        emojis = {
          exec = "wl-copy";
          history = true;
          name = "emojis";
          placeholder = "Emojis";
          show_unqualified = false;
          switcher_only = true;
          typeahead = true;
          weight = 5;
        };

        finder = {
          concurrency = 8;
          icon = "file";
          ignore_gitignore = true;
          name = "finder";
          placeholder = "Finder";
          refresh = true;
          show_icon_when_single = true;
          switcher_only = true;
          use_fd = true;
          weight = 5;
        };

        runner = {
          generic_entry = false;
          history = true;
          icon = "utilities-terminal";
          name = "runner";
          placeholder = "Runner";
          refresh = true;
          typeahead = true;
          weight = 5;
        };

        ssh = {
          history = true;
          icon = "preferences-system-network";
          name = "ssh";
          placeholder = "SSH";
          refresh = true;
          switcher_only = true;
          weight = 5;
        };

        switcher = {
          name = "switcher";
          placeholder = "Switcher";
          prefix = "/";
          weight = 5;
        };

        symbols = {
          after_copy = "";
          history = true;
          name = "symbols";
          placeholder = "Symbols";
          switcher_only = true;
          typeahead = true;
          weight = 5;
        };

        websearch = {
          icon = "applications-internet";
          name = "websearch";
          placeholder = "Websearch";
          weight = 5;
          entries = [
            {
              name = "Google";
              url = "https://www.google.com/search?q=%TERM%";
            }
            {
              name = "Elden Ring Wiki";
              switcher_only = true;
              url = "https://eldenring.wiki.fextralife.com/Elden+Ring+Wiki#gsc.tab=0&gsc.q=%TERM%&gsc.sort=";
            }
          ];
        };

        windows = {
          icon = "view-restore";
          name = "windows";
          placeholder = "Windows";
          show_icon_when_single = true;
          weight = 5;
        };

        xdph_picker = {
          hidden = true;
          name = "xdphpicker";
          placeholder = "Screen/Window Picker";
          theme = "base16";
          show_sub_when_single = true;
          switcher_only = true;
          weight = 5;
        };
      };

      events = {
        on_activate = "";
        on_exit = "";
        on_launch = "";
        on_query_change = "";
        on_selection = "";
      };

      keys = {
        accept_typeahead = ["tab"];
        close = ["esc"];
        next = ["down tab"];
        prev = ["up"];
        remove_from_history = ["shift backspace"];
        resume_query = ["ctrl r"];
        toggle_exact_search = ["ctrl m"];
        trigger_labels = "lalt";
        activation_modifiers = {
          alternate = "alt";
          keep_open = "shift";
        };
        ai = {
          clear_session = ["ctrl x"];
          copy_last_response = ["ctrl c"];
          resume_session = ["ctrl r"];
          run_last_response = ["ctrl e"];
        };
      };

      list = {
        dynamic_sub = true;
        keyboard_scroll_style = "neovim";
        max_entries = 1000;
        placeholder = "No Results";
        show_initial_entries = true;
        single_click = true;
        visibility_threshold = 20;
      };

      plugins = [
        {
          name = "wallpaper";
          placeholder = "Wallpapers";
          theme = "base16_wall";
          switcher_only = false;
          refresh = true;
          src = "bash -c ~/.config/walker/scripts/wallpaper.sh";
          parser = "kv";
        }
        {
          name = "themes";
          placeholder = "Color Scheme";
          theme = "base16";
          switcher_only = false;
          refresh = true;
          src = "bash -c ~/.config/walker/scripts/themes.sh";
          parser = "kv";
        }
        {
          name = "power";
          placeholder = "System";
          theme = "base16_power";
          switcher_only = true;
          keep_sort = true;
          recalculate_score = true;
          show_icon_when_single = true;
          entries = [
            {
              label = "Change Wallpaper";
              icon = "preferences-desktop-wallpaper";
              exec = "walker -n -m wallpaper";
            }
            {
              label = "Change Color Scheme";
              icon = "gpaint";
              exec = "walker -n -m themes";
            }
            {
              label = "Lock Screen";
              icon = "system-lock-screen";
              exec = "hyprlock";
            }
            {
              label = "Reboot";
              icon = "system-reboot";
              exec = "reboot";
            }
            {
              label = "Shutdown";
              icon = "system-shutdown";
              exec = "shutdown now";
            }
          ];
        }
        {
          name = "screenshot";
          placeholder = "Screenshot";
          theme = "base16_popup";
          switcher_only = false;
          recalculate_score = true;
          show_icon_when_single = true;
          entries = [
            {
              label = "Region";
              icon = "region";
              exec = ''hyprshot -m region -z -o ~/Pictures/Screenshots -f "screenshot_$(date +%d%m%Y_%H%M%S).png"'';
            }
            {
              label = "Window";
              icon = "window";
              exec = ''hyprshot -m window -z -o ~/Pictures/Screenshots -f "screenshot_$(date +%d%m%Y_%H%M%S).png"'';
            }
            {
              label = "Screen";
              icon = "preferences-system-windows";
              exec = ''hyprshot -m output -z -o ~/Pictures/Screenshots -f "screenshot_$(date +%d%m%Y_%H%M%S).png"'';
            }
          ];
        }
      ];

      search = {
        delay = 0;
        placeholder = "Search...";
        resume_last_query = false;
      };
    };
  };
}
