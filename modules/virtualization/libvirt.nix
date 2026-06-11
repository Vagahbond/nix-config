[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        config,
        username,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          kvmtool
          virt-manager
        ];

        programs.dconf.enable = true;

        virtualisation = {
          libvirtd.enable = true;

          spiceUSBRedirection.enable = true;
        };

        users.users.${username}.extraGroups = [ "libvirtd" ];
      };
  }
]
