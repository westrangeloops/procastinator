{
    inputs,
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        inputs.illogical-impulse.homeManagerModules.default
    ]; 
    illogical-impulse = {
        enable = true;
       
     };
}
