{
    lib,
    config,
    pkgs,
    inputs,
    ...
}:{
    hj = {
        packages = with pkgs; [
           zoxide
           fzf
           fd
           bat
           lazygit
      ];
      rum.programs = {
          lsd.enable = true;
      };
    };
}
