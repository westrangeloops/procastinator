{
    config,
    pkgs,
    inputs,
    ...
}:
    { 

        hj = {
           packages = [ pkgs.niri-unstable ];
           files = {
               ".config/niri/config.kdl".text = ''
                    ${import ./settings.nix { inherit config pkgs inputs; }}
                    ${import ./binds.nix { inherit config pkgs inputs; }}
                    ${import ./startup.nix { inherit config pkgs inputs; }}
               '';
               };
            };
       }

