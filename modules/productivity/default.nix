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
    (mkIf (cfg.maps.enable
      && (graphics.type != null)) {
      environment = {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/OMaps"
            ];
          };
        };

        systemPackages = with pkgs; [
          organicmaps
        ];
      };
    })
    (
      mkIf cfg.pomodoro.enable {
        environment.systemPackages = with pkgs; [
          tomato-c
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
      mkIf cfg.musicProduction.enable {
        environment = {
          systemPackages = with pkgs; [
            reaper
          ];
          persistence.${impermanence.storageLocation} = {
            users.${username} = {
              directories = [
                ".config/REAPER"
              ];
            };
          };
        };
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
        owner = username;
        group = "users";
      };

      home-manager.users.${username} = {
        systemd.user = {
          services.nextcloud-autosync = {
            Unit = {
              Description = "Auto sync Nextcloud";
              After = "network-online.target";
            };
            Service = {
              Type = "simple";
              ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -u $(sed -n 1p ${config.age.secrets.nextcloud-client-user.path}) -p $(sed -n 2p ${config.age.secrets.nextcloud-client-user.path}) --non-interactive -s -h  --path /Documents /home/${username}/Documents https://cloud.vagahbond.com";
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
