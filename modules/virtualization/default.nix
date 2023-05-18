{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker

    lens

    virt-manager
    kvmtool
  ];
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation = {
    libvirtd.enable = true;

    spiceUSBRedirection.enable = true;

    virtualbox.host = {
      enable = true;
      enableWebService = false;
      enableExtensionPack = true;
    };
  };
}
