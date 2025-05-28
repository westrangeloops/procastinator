{
    inputs,
    config,
    pkgs,
    lib,
    ...
}:
{
   hj.rum.programs.fuzzel = {
       enable = true;
       settings = {
           main = {
               font = "JetBrainsMono Nerd Font:size=10";
               anchor = "top";
               prompt = "❯ ";
               width = "40";
               horizontal-pad = "20;";
               vertical-pad = "10";
               inner-pad = "5";
               line-height = "20";
               lines = "8";
               letter-spacing = "0.5";
               icons-enabled = "yes";
               icon-theme = "Papirus-Dark";
               image-size-ratio = "1.0";
               fuzzy="yes";
           };
           colors = {
             background = "1e1e2edd";
             text = "cdd6f4ff";
             prompt= "bac2deff";
             placeholder="7f849cff";
             input = "cdd6f4ff";
             match = "f5e0dcff";
             selection = "585b70ff";
             selection-text = "cdd6f4ff";
             selection-match = "f5e0dcff";
             counter = "7f849cff";
             border = "f5e0dcff";  
           };
       };
   };
}
