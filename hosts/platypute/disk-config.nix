{
  lib,
  inputs,
  ...
}:
{

  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "relatime"
          "mode=755"
          "size=6G"
        ];
      };
    };

    disk = {
      main = {
        device = lib.mkDefault "/dev/vda";
        type = "disk";

        content = {
          type = "gpt";

          partitions = {
            boot = {
              name = "boot";
              size = "200M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            root = {
              name = "root";
              size = "100%";
              content = {
                format = "ext4";
                mountpoint = "/nix";
                type = "filesystem";
              };
            };
            encryptedSwap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
  };
}
