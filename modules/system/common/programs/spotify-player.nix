{
  config,
  pkgs,
  ...
}: let
  catppuccin-spotify-player = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "spotify-player";
    rev = "34b3d23806770185b72466d777853c73454b85a6";
    hash = "sha256-eenf1jB8b2s2qeG7wAApGwkjJZWVNzQj/wEZMUgnn5U=";
  };
in {
  hj = {
    rum.programs.spotify-player = {
      enable = true;
      settings = {
        client_id_command = "cat a9af7e8596954c9389334185e06c45be";
        theme = "Catppuccin-mocha";
        device = {
          name = "shizuru";
          device_type = "computer";
          volume = 60;
          normalization = true;
        };
      };
    };
    files.".config/spotify-player/theme.toml".source = "${catppuccin-spotify-player}/theme.toml";
  };
}
