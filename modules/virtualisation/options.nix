{lib, ...}:
with lib; {
  options.modules.virtualisation = {
    docker.enable = mkEnableOption "Docker";

    libvirt.enable = mkEnableOption "libvirt";

    virtualbox.enable = mkEnableOption "VirtualBox";

    podman.enable = mkEnableOption "Podman"; # TODO: implement

    # I know it's not virtualisation
    wine.enable = mkEnableOption "wine";

    kubernetes = {
      host.enable = mkEnableOption "Kubernetes host";
      client.enable = mkEnableOption "Kubernetes client";
    };
  };
}
