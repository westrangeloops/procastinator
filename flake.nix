{
  description = "Procastinator flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # CachyOS req
    stylix.url = "github:nix-community/stylix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VIM
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nvchad4nix = {
      url = "github:MOIS3Y/nvchad4nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GRUB2 themes
    grub2-themes.url = "github:vinceliuice/grub2-themes";

    # HYPRLAND
    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprsunset.url = "github:hyprwm/hyprsunset";
    hyprland-qt-support.url = "github:hyprwm/hyprland-qt-support";
    hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";

    hyprland-plugins = {
      url = "github:ItsOhen/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    neovim-nightly-overlay,
    nvchad4nix,
    hyprland,
    hyprlock,
    hyprsunset,
    hyprland-qt-support,
    hyprland-qtutils,
    hyprland-plugins,
    hyprpanel,
    chaotic,
    grub2-themes,
    ...
  }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        (
          { config, pkgs, ... }:
          {
            nixpkgs.config.allowUnfree = true;

            # Add the custom overlays
            nixpkgs.overlays = [
              neovim-nightly-overlay.overlays.default
              chaotic.overlays.default
            ];
          }
        )
        ./hosts/default/configuration.nix
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        inputs.chaotic.nixosModules.default
      ];
    };
  };
}
