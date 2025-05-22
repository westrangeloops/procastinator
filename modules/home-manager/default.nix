{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home.nix
    ./scripts/scripts.nix
    ./niri 
    ./editors 
    ./terminal 
    ./ui 
    ./media 
  ];
}
