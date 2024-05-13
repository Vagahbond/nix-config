{lib, ...}:
with lib; {
  options.modules.virtualisation = {
    docker.enable = mkEnableOption "Docker";
    containers.enable = mkEnableOption "native containers";

    libvirt.enable = mkEnableOption "libvirt";

    virtualbox.enable = mkEnableOption "VirtualBox";

    podman.enable = mkEnableOption "Podman"; # TODO: implement

    kubernetes = {
      host.enable = mkEnableOption "Kubernetes host";
      client.enable = mkEnableOption "Kubernetes client";
    };
  };
}
