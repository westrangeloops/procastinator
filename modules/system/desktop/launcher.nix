{
    inputs,
    lib,
    config,
    pkgs,
    ...
}: 
{
    rum.programs.walker = {
        enable = true;
        systemd.enable = true;
        runAsServices = true;
        config = ./../../../configs/walker/config.toml;
        theme = {
            layout = ./../../../configs/walker/themes/base16.toml;
            style = ./../../../configs/walker/themes/base16.css;
        };
    };
}
