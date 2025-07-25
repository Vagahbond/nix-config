{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.virtualisation;
in {
  imports = [./options.nix];
  config = mkMerge [
    /*
      {
      # network used by containers
      networking.nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "ens3";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };
    }
    */
    (mkIf cfg.wine.enable {
      environment.systemPackages = with pkgs; [
        bottles
      ];

      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".local/share/bottles"
          ];
        };
      };
    })

    (mkIf cfg.docker.enable {
      environment.systemPackages = with pkgs; [
        docker-compose
        lazydocker
      ];

      virtualisation.podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };

      # Docker
      /*
      virtualisation.docker.enable = true;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      users.users.${username}.extraGroups = ["docker"];

      */
      # keep docker data
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/docker"
          "/var/lib/containers"
        ];

        users.${username} = {
          directories = [
            ".docker"
            ".local/share/docker"
            ".local/share/containers"
          ];
        };
      };
    })
    (mkIf cfg.libvirt.enable {
      environment.systemPackages = with pkgs; [
        kvmtool
      ];

      programs.dconf.enable = true;

      virtualisation = {
        libvirtd.enable = true;

        spiceUSBRedirection.enable = true;
      };

      users.users.${username}.extraGroups = ["libvirtd"];
    })
    (mkIf (cfg.libvirt.enable && graphics != null) {
      environment.systemPackages = with pkgs; [
        virt-manager
      ];

      # keep virtual machines
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/libvirt"
        ];
      };
    })
    (mkIf (cfg.virtualbox.enable && graphics != null) {
      virtualisation = {
        virtualbox.host = {
          enable = true;
          enableWebService = false;
          enableExtensionPack = true;
        };
      };

      users.users.${username}.extraGroups = ["vboxusers"];
    })
    (
      mkIf (cfg.kubernetes.client.enable && graphics != null)
      {
        age.secrets = {
          kubeconfig = {
            file = ../../secrets/kubeconfig.age;
            path = "${config.users.users.${username}.home}/.kube/kubeconfig.yml";

            mode = "440";
            owner = "vagahbond";
            group = "users";
          };
        };

        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/Lens"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          kubectl
          lens
        ];
      }
    )
  ];
}
