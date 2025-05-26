{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vscode;

  jsonFormat = pkgs.formats.json { };

  # Determine config directory based on package
  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
    "openvscode-server" = "OpenVSCode Server";
  }.${cfg.package.pname or "vscode"};

  # Determine extension directory based on package
  extensionDir = {
    "vscode" = "vscode";
    "vscode-insiders" = "vscode-insiders";
    "vscodium" = "vscode-oss";
    "openvscode-server" = "openvscode-server";
  }.${cfg.package.pname or "vscode"};

  userDir = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/${configDir}/User"
  else
    ".config/${configDir}/User";

  settingsPath = "${userDir}/settings.json";
  keybindingsPath = "${userDir}/keybindings.json";
  tasksPath = "${userDir}/tasks.json";
  snippetsPath = "${userDir}/snippets";
  extensionPath = ".${extensionDir}/extensions";

  isPath = p: builtins.isPath p || lib.isStorePath p;

  extensionJson = ext: {
    identifier = {
      id = ext.vscodeExtUniqueId or (builtins.unsafeDiscardStringContext (builtins.baseNameOf ext));
    };
    version = ext.version;
    location = {
      $mid = 1;
      fsPath = ext;
      path = ext;
      scheme = "file";
    };
  };

in {
  options.programs.vscode = {
    enable = mkEnableOption "Visual Studio Code";

    package = mkOption {
      type = types.package;
      default = pkgs.vscode;
      defaultText = literalExpression "pkgs.vscode";
      description = "The VSCode package to use";
    };

    userSettings = mkOption {
      type = types.either types.path jsonFormat.type;
      default = {};
      description = "VSCode user settings (written to settings.json)";
    };

    keybindings = mkOption {
      type = types.either types.path (types.listOf (types.submodule {
        options = {
          key = mkOption { type = types.str; description = "Key combination"; };
          command = mkOption { type = types.str; description = "Command to execute"; };
          when = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Context filter";
          };
          args = mkOption {
            type = types.nullOr jsonFormat.type;
            default = null;
            description = "Command arguments";
          };
        };
      }));
      default = [];
      description = "VSCode keybindings (written to keybindings.json)";
    };

    tasks = mkOption {
      type = types.either types.path jsonFormat.type;
      default = {};
      description = "VSCode tasks configuration (written to tasks.json)";
    };

    extensions = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ pkgs.vscode-extensions.bbenoist.nix ]";
      description = "List of VSCode extensions to install";
    };

    mutableExtensionsDir = mkOption {
      type = types.bool;
      default = true;
      description = "Whether extensions can be manually installed/updated";
    };

    enableUpdateCheck = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable VSCode update checks";
    };

    enableExtensionUpdateCheck = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable extension update checks";
    };

    languageSnippets = mkOption {
      type = types.attrsOf jsonFormat.type;
      default = {};
      description = "Language-specific snippets configuration";
    };

    globalSnippets = mkOption {
      type = jsonFormat.type;
      default = {};
      description = "Global snippets configuration";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.vscode-setup = {
      description = "VSCode configuration setup";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = let
        settingsContent = if isPath cfg.userSettings then cfg.userSettings else
          jsonFormat.generate "vscode-settings" (cfg.userSettings // {
            "update.mode" = if cfg.enableUpdateCheck then null else "none";
            "extensions.autoCheckUpdates" = cfg.enableExtensionUpdateCheck;
          });

        keybindingsContent = if isPath cfg.keybindings then cfg.keybindings else
          jsonFormat.generate "vscode-keybindings" (map (filterAttrs (_: v: v != null)) cfg.keybindings);

        tasksContent = if isPath cfg.tasks then cfg.tasks else
          jsonFormat.generate "vscode-tasks" cfg.tasks;

        extensionsJson = jsonFormat.generate "vscode-extensions" (map extensionJson cfg.extensions);
      in ''
        # Create user directory
        mkdir -p "${userDir}"

        # Write settings
        ${if cfg.userSettings != {} then "cp ${settingsContent} ${settingsPath}" else ""}

        # Write keybindings
        ${if cfg.keybindings != [] then "cp ${keybindingsContent} ${keybindingsPath}" else ""}

        # Write tasks
        ${if cfg.tasks != {} then "cp ${tasksContent} ${tasksPath}" else ""}

        # Create snippets directory
        mkdir -p "${snippetsPath}"

        # Write language snippets
        ${concatStringsSep "\n" (mapAttrsToList (name: snippet: ''
          cp ${jsonFormat.generate "vscode-snippet-${name}" snippet} "${snippetsPath}/${name}.json"
        '') cfg.languageSnippets)}

        # Write global snippets
        ${if cfg.globalSnippets != {} then
          "cp ${jsonFormat.generate "vscode-global-snippets" cfg.globalSnippets} \"${snippetsPath}/global.code-snippets\"" else ""}

        # Handle extensions
        if ${boolToString cfg.mutableExtensionsDir}; then
          # For mutable extensions dir
          mkdir -p "${extensionPath}"
          cp ${extensionsJson} "${extensionPath}/extensions.json"
        else
          # For immutable extensions dir
          rm -rf "${extensionPath}"
          mkdir -p "${extensionPath}"
          
          ${concatMapStringsSep "\n" (ext: ''
            for extdir in "${ext}/share/vscode/extensions"/*; do
              ln -s "$extdir" "${extensionPath}/$(basename "$extdir")"
            done
          '') cfg.extensions}
          
          cp ${extensionsJson} "${extensionPath}/extensions.json"
        fi
      '';
    };
  };
}
