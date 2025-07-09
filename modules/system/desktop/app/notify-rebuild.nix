{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.services.notify-rebuild = {
    description = "Send notification after system rebuild";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "dotempo";
      ExecStart = pkgs.writeShellScript "notify-rebuild" ''
        USER="dotempo"
        USERID=$(id -u $USER)
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USERID/bus"
        
        # Create XDG_RUNTIME_DIR if it doesn't exist
        if [ ! -d "/run/user/$USERID" ]; then
          mkdir -p "/run/user/$USERID"
          chmod 700 "/run/user/$USERID"
          chown "$USER:users" "/run/user/$USERID"
        fi
        
        # Set permissions for XDG_RUNTIME_DIR
        systemd-tmpfiles --create --prefix=/run/user <<EOF
        "d /run/user/$(id -u dotempo) 0755 dotempo users -" # Replace with actual UID
        EOF
        
        # Send notification
        ${pkgs.libnotify}/bin/notify-send -u normal "System Update" "NixOS system was successfully rebuilt!" -i "system-software-update"
      '';
    };
  };
}
