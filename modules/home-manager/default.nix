{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home.nix
    ./ags 
    ./fabric
    #./scripts
    ./niri 
    ./editors 
    #./terminal 
    ./ui 
    ./media 
  ];
}
