{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

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

  config =
    {}
    // mkIf cfg.docker.enable {
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
    }
    // mkIf cfg.libvirt.enable {
      environment.systemPackages = with pkgs; [
        kvmtool
      ];
      virtualisation = {
        libvirtd.enable = true;

        spiceUSBRedirection.enable = true;
      };
    }
    // mkIf (cfg.libvirt.enable && graphics != null) {
      environment.systemPackages = with pkgs; [
        virt-manager
      ];
    }
    // mkIf (cfg.virtualbox.enable && graphics != null) {
      virtualisation = {
        virtualbox.host = {
          enable = true;
          enableWebService = false;
          enableExtensionPack = true;
        };
      };

      users.users.${username}.extraGroups = ["vboxusers"];
    }
    // mkIf (cfg.kubernetes.client.enable && graphics != null) {
      environment.systemPackages = with pkgs; [
        lens
      ];
    };
}
