{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:

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
