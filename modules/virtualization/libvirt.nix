{
  targets = [
    "framework"
  ];

  nixosConfiguration = {
    pkgs,
    config,
    username,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      kvmtool
      virt-manager
    ];

    # keep virtual machines
    environment.persistence.${config.persistence.storageLocation} = {
      directories = [
        "/var/lib/libvirt"
      ];
    };

    programs.dconf.enable = true;

    virtualisation = {
      libvirtd.enable = true;

      spiceUSBRedirection.enable = true;
    };

    users.users.${username}.extraGroups = ["libvirtd"];
  };
}
