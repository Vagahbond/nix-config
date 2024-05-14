{config}: {
  ###################################################
  # BACKUP (WIP)                                    #
  ###################################################
  systemd = {
    services.nextcloud-backup = {
      unitConfig = {
        Description = "Auto backup Nextcloud";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = ''
          sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --on
          sudo -u nextcloud mkdir -p /nix/persistent/nextcloud/
        '';
        ExecStart = ''
          rsync -Aavx /var/lib/nextcloud /nix/persistent/nextcloud_backup_`date +"%Y%m%d"`/ > /nix/persistent/nextcloud-backup.logs
          sudo -u postgres pg_dump nextcloud  -U postgres -f /nix/persistent/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
        '';
        ExecPost = ''
          sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --off
        '';
        TimeoutStopSec = "600";
        KillMode = "process";
        KillSignal = "SIGINT";
        # RemainAfterExit = true;
      };
      WantedBy = ["multi-user.target"];
    };
    timers.nextcloud-backup = {
      description = "Automatic files backup for Nextcloud when booted up after 2 minutes then rerun every week ";
      timerConfig = {
        onCalendar = "weekly";
      };
      wantedBy = ["multi-user.target" "timers.target"];
    };
    # startServices = true;
  };
}
