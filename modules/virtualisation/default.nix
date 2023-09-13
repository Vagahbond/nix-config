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
  options.modules.virtualisation = {
    docker.enable = mkEnableOption "Docker";

    libvirt.enable = mkEnableOption "libvirt";

    virtualbox.enable = mkEnableOption "VirtualBox";

    podman.enable = mkEnableOption "Podman"; # TODO: implement

    kubernetes = {
      host.enable = mkEnableOption "Kubernetes host";
      client.enable = mkEnableOption "Kubernetes client";
    };
  };

  config = mkMerge [
    (mkIf cfg.docker.enable {
      environment.systemPackages = with pkgs; [
        docker-compose
        lazydocker
      ];

      # Docker
      virtualisation.docker.enable = true;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      users.users.${username}.extraGroups = ["docker"];

      # keep docker data
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/docker"
        ];

        users.${username} = {
          directories = [
            ".docker"
          ];
        };
      };
    })
    (mkIf cfg.libvirt.enable {
      environment.systemPackages = with pkgs; [
        kvmtool
      ];
      virtualisation = {
        libvirtd.enable = true;

        spiceUSBRedirection.enable = true;
      };
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
