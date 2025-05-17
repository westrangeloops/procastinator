{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStrings;
in {
  hj.rum.programs.starship = {
    enable = true;
    setting = {
      character = {
        success_symbol = "[ •   ](#8caaee bold)"; # Added spaces between symbols
        error_symbol = "[ •  󰅙 ](#e78284 bold)";
      };
      hostname = {
        format = "[ $ssh_symbol$hostname ](bold bg:#24273a fg:#E8E3E3)";
        disabled = false;
      };
      format = concatStrings [
        "$hostname"
        "$directory"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$vcsh"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$custom"
        "$sudo"
        "$fill"
        "$git_branch"
        "$git_status"
        "$git_commit"
        "$cmd_duration"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$os"
        "$container"
        "$shell"
        "$line_break"
        "$character"
      ];
      os = {
        style = "bold white";
        format = "[$symbol]($style)";

        symbols = {
          Arch = "";
          Artix = "";
          Debian = "";
          # Kali = "󰠥";
          EndeavourOS = "";
          Fedora = "";
          NixOS = "";
          openSUSE = "";
          SUSE = "";
          Ubuntu = "";
          Raspbian = "";
          #elementary = "";
          #Coreos = "";
          Gentoo = "";
          #mageia = ""
          CentOS = "";
          #sabayon = "";
          #slackware = "";
          Mint = "";
          Alpine = "";
          #aosc = "";
          #devuan = "";
          Manjaro = "";
          #rhel = "";
          Macos = "󰀵";
          Linux = "";
          Windows = "";
        };
      };
      nix_shell.symbol = " ";
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = "󰋞 ";
        read_only_style = "197";
        read_only = "  ";
        format = "at [$path]($style)[$read_only]($read_only_style) ";

        substitutions = {
          "󰋞 /Documents" = "󰈙 ";
          "󰋞 /documents" = "󰈙 ";

          "󰋞 /Downloads" = " ";
          "󰋞 /downloads" = " ";

          "󰋞 /Music" = " ";
          "󰋞 /Pictures" = " ";
          "󰋞 /Videos" = " ";

          "󰋞 /Projects" = "󱌢 ";

          "󰋞 /.config" = " ";
        };
      };
      cmd_duration = {
        format = "[ $duration ]($style)[ 󱑂  ](bg:#ca9ee6 fg:#24273a)";
      };
      git_branch = {
        format = "[ $branch ]($style) [  ](bg:#81C19B fg:#24273a)";
        style = "bg:#24273a fg:#E8E3E3";
        symbol = " ";
      }; 
      git_status = {
          format = "[\\($all_status$ahead_behind\\)]($style) ";
          style = "bold green";
          conflicted = "🏳";
          up_to_date = " ";
          untracked = " ";
          ahead = "⇡\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣\${count}";
          stashed = "󰏗 ";
          modified = " ";
          staged = "[++\\($count\\)](green)";
          renamed = "󰖷 ";
          deleted = " ";
        };
      battery = {
        format = "[ $symbol$percentage ](bold fg:#a6e3a1)";
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        display = [
          {
            threshold = 10;
            style = "bold fg:#e78284";
          } # Red when critical
          {
            threshold = 30;
            style = "bold fg:#ef9f76";
          } # Orange when low
          {
            threshold = 100;
            style = "bold fg:#a6e3a1";
          } # Green otherwise
        ];
      };
    };
  };
}
