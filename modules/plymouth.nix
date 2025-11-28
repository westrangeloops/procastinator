{
  pkgs,
  config,
  ...
}: {
  boot.plymouth = {
    enable = true;
    themePackages = [ pkgs.adi1090x-plymouth-themes ];
    theme = "sphere";
  };
  
  # Enable silent boot
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}

