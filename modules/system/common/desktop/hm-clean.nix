{
  config,
  lib,
  pkgs,
  ...
}: {
  # Temporarily disable the cleanup service until we fix the user session issues
  systemd.services.cleanup-hm-services = {
    enable = false;
    description = "Clean up stale Home Manager systemd user services";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "dotempo";
      ExecStart = pkgs.writeScript "cleanup-hm-services" ''
        #!/bin/sh
        echo "Home Manager cleanup disabled"
        exit 0
      '';
    };
  };
}
