{
    lib,
    pkgs,
    config,
    inputs,
    ...
}:
{
    hj.rum.programs.starship = {
        enable = true;
        setting = {
            character = {
                   success_symbol = "[ •   ](#8caaee bold)";  # Added spaces between symbols
                   error_symbol = "[ •  󰅙 ](#e78284 bold)";
            };
            hostname = {  
                    format = "[ $ssh_symbol$hostname ](bold bg:#24273a fg:#E8E3E3)";  # Added spaces inside brackets
                    disabled = false;
            };
        };
    };
}  
