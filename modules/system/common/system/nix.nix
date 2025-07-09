{
  pkgs,
  inputs,
  system,
  config,
  lib,
  options,
  username,
  host,
  inputs',
  ...
}: {
  nix = {
    package = inputs.izlix.packages.${pkgs.system}.nix;
    channel.enable = false;
    settings = {
      nix-path = [
             "nixpkgs=${inputs.nixpkgs.outPath}"
             "nixpkgs-master=${inputs.nixpkgs-master.outPath}"
             "nixpkgs-stable=${inputs.nixpkgs-stable.outPath}"
        ];
      allowed-users = ["root" "@wheel" "dotempo"];
      trusted-users = ["root" "@wheel" "dotempo" "@builders"];
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = false;
      max-jobs = "auto";
      cores = 0;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };
}
