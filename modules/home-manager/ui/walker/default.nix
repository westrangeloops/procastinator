{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: 
{
    imports = [
       inputs.walker.homeManagerModules.default
    ];
    
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
        anthropic = {
          prompts = [
            {
              label = "Artificial Intelligence";
              max_tokens = 1000;
              model = "claude-3-5-sonnet-20241022";
              prompt = "You are a helpful general assistant. Keep your answers short and precise.";
              temperature = 1;
            }
          ];
        };
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
            keywords = [ "walker" "github" ];
            label = "Walker";
            url = "https://github.com/abenz1267/walker";
          }
        ];
      };
clipboard = {
  avoid_line_breaks = true;
  exec = "wl-copy";
  image_height = 300;
  max_entries = 30;
  name = "clipboard";
  placeholder = "Clipboard";
  switcher_only = true;
  weight = 5;
};
      calc = {
        icon = "accessories-calculator";
        min_chars = 4;
        name = "calc";
        placeholder = "Calculator";
        require_number = true;
        weight = 5;
      };
      # ... continue this way for the rest!
    };

    keys = {
      accept_typeahead = [ "tab" ];
      close = [ "esc" ];
      next = [ "down tab" ];
      prev = [ "up" ];
      remove_from_history = [ "shift backspace" ];
      resume_query = [ "ctrl r" ];
      toggle_exact_search = [ "ctrl m" ];
      trigger_labels = "lalt";
      activation_modifiers = {
        alternate = "alt";
        keep_open = "shift";
      };
      ai = {
        clear_session = [ "ctrl x" ];
        copy_last_response = [ "ctrl c" ];
        resume_session = [ "ctrl r" ];
        run_last_response = [ "ctrl e" ];
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
      # And so on for the remaining plugins...
    ];

    search = {
      delay = 0;
      placeholder = "Search...";
      resume_last_query = false;
    };

    events = {
      on_activate = "";
      on_exit = "";
      on_launch = "";
      on_query_change = "";
      on_selection = "";
    };
  };
};
}
