{
  description = "Procastinator flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:nix-community/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:pfaj/zen-browser-flake";
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

    # Others
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";  # This provides the cachyos
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs =
    { self, nixpkgs, home-manager, stylix, zen-browser, nixvim, neovim-nightly-overlay, nvchad4nix, hyprpanel, chaotic, lanzaboote, ... }@inputs:
    let
      system = "x86_64-linux";

      # Define the custom SDDM theme as an overlay
      customSddmThemeOverlay = final: prev: {
        customSddmTheme = prev.stdenv.mkDerivation {
          name = "rose-pine";
          src = ./modules/sddm-theme;
          installPhase = ''
            mkdir -p $out/share/sddm/themes/rose-pine
            cp -r $src/* $out/share/sddm/themes/rose-pine
          '';
        };
      };

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          (
            {
              config,
              pkgs,
              ...
            }:
            {
              nixpkgs.config.allowUnfree = true;

              # Add the custom theme overlay
              nixpkgs.overlays = [
                customSddmThemeOverlay
                # hyprpanel overlay is removed as it's now in nixpkgs
                inputs.neovim-nightly-overlay.overlays.default
                # Add chaotic overlay for CachyOS packages
                inputs.chaotic.overlays.default
              ];
            }
          )
          ./hosts/default/configuration.nix
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
          # Add chaotic module
          inputs.chaotic.nixosModules.default
        ];
      };
    };
}
