{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
#    ./home.nix
    ./ags 
    ./fabric
    ./niri 
    ./editors 
    ./ui 
    ./media 
    ./quickshell 
  ];
}
