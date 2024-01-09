{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.productivity;
in {
  imports = [./options.nix];

  config = mkMerge [
    (mkIf (cfg.notion.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        notion-app-enhanced
      ];
    })
    (mkIf (cfg.appflowy.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        appflowy
      ];
    })
    (mkIf (cfg.activityWatch.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        activitywatch
      ];
    })
    (
      mkIf cfg.pomodoro.enable {
        environment.systemPackages = with pkgs; [
          gnome.pomodoro
        ];
      }
    )
    (
      mkIf cfg.logseq.enable {
        environment.systemPackages = with pkgs; [
          logseq
        ];
      }
    )
    (
      mkIf cfg.anytype.enable {
        environment.systemPackages = with pkgs; [
          anytype
        ];
      }
    )

    (mkIf (cfg.nextcloudSync.enable
      && (graphics.type != null)) {
      age.secrets.nextcloud-client-user = {
        file = ../../secrets/nextcloud_client_account.age;
        path = "${config.users.users.${username}.home}/.netrc";
        owner = username;
        group = "users";
      };

      home-manager.users.${username} = {
        # home.file.".netrc".text = ''          default
        #                  login example
        #                  password test123
        # '';

        systemd.user = {
          services.nextcloud-autosync = {
            Unit = {
              Description = "Auto sync Nextcloud";
              After = "network-online.target";
            };
            Service = {
              Type = "simple";
              ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd --non-interactive -s -h -n --path /Documents /home/${username}/Documents https://cloud.vagahbond.com";
              TimeoutStopSec = "180";
              KillMode = "process";
              KillSignal = "SIGINT";
            };
            Install.WantedBy = ["multi-user.target"];
          };
          timers.nextcloud-autosync = {
            Unit.Description = "Automatic sync files with Nextcloud when booted up after 2 minutes then rerun every 30 minutes";
            Timer.OnBootSec = "2min";
            Timer.OnUnitActiveSec = "30min";
            Install.WantedBy = ["multi-user.target" "timers.target"];
          };
          startServices = true;
        };
      };
    })
  ];
}
