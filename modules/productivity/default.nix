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
    (mkIf (cfg.affine.enable
      && (graphics.type != null)) {
      environment = {
        systemPackages = with pkgs; [
          affine
        ];
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/AFFiNE"
            ];
          };
        };
      };
    })
    (mkIf (cfg.activityWatch.enable
      && (graphics.type != null)) {
      environment = {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".local/share/activitywatch"
            ];
          };
        };
        systemPackages = with pkgs; [
          activitywatch
          dnsproxy
        ];
      };
      networking.hosts = {
        "127.0.0.1:5600" = ["AW"];
      };
    })
    (
      mkIf cfg.pomodoro.enable {
        environment = {
          persistence.${impermanence.storageLocation} = {
            users.${username} = {
              directories = [
                ".local/share/tomato"
              ];
            };
          };
          systemPackages = with pkgs; [
            tomato-c
          ];
        };
      }
    )
    (
      mkIf cfg.nextcloudSync.enable {
        age.secrets.nextcloud-client-user = {
          file = ../../secrets/nextcloud_client_account.age;
          owner = username;
          group = "users";
        };

        home-manager.users.${username} = {
          systemd.user = {
            services.nextcloud-autosync = let
              script = ''
                ${pkgs.nextcloud-client}/bin/nextcloudcmd \
                -u $(${pkgs.gnused}/bin/sed \
                -n 1p ${config.age.secrets.nextcloud-client-user.path}) \
                -p $(${pkgs.gnused}/bin/sed \
                -n 2p ${config.age.secrets.nextcloud-client-user.path}) \
                --non-interactive -s -h \
                --path /Documents /home/${username}/Documents \
                https://nuage.vagahbond.com
              '';
            in {
              Unit = {
                Description = "Auto sync Nextcloud";
                After = "network-online.target";
              };
              Service = {
                Type = "simple";
                ExecStart = pkgs.writers.writeBash "nextcloud-sync.sh" script;
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
      }
    )
  ];
}
