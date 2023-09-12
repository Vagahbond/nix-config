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
    (mkIf (cfg.kubernetes.client.enable && graphics != null) (
      let
        kubeconfig-path = "${config.users.users.${username}.home}/.kube/my-cluster.yml";
      in {
        age.secrets.kubeconfig = {
          file = ../../secrets/kubeconfig.age;
          owner = username;
          #         mode = "700";
          group = "users";
          path = kubeconfig-path;
        };

        /*
          home-manager.users.${username}.xdg.configFile = {
          #      "Lens/kubeconfigs/my-cluster.yml".source = config.age.secrets.kubeconfig.path;
          "Lens/lens-cluster-store.json".text = ''
            {
            	"clusters": [
            		{
            			"id": "2d1bfdd48fccdd8a6108e4b90270d8da",
            			"contextName": "default",
            			"kubeConfigPath": "${kubeconfig-path}",
            			"preferences": {
            				"clusterName": "Vagahbond's cluster"
            			},
            			"metadata": {
            				"version": "v1.21.1+k3s1",
            				"distribution": "k3s",
            				"id": "1756114e7e7c3c1e89eb9da820d7d01cc918e83e76709c02f9ff04ee2dba4523",
            				"lastSeen": "2023-09-11T16:55:56.740Z",
            				"nodes": 1,
            				"prometheus": {
            					"provider": "lens",
            					"autoDetected": true,
            					"success": true
            				}
            			},
            			"accessibleNamespaces": [],
            			"labels": {}
            		}
            	],
            	"__internal__": {
            		"migrations": {
            			"version": "6.5.0"
            		}
            	}
            }
          '';
        };
        */
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/Lens"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          lens
        ];
      }
    ))
  ];
}
