# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./disk-config.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIfo/yexMTRxKoHdjUdcHAD3I4rJfGHOVG4MDvqXj4G vagahbond@framework"
  ];
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"];

  # Impermanencing my whole system cause I like to suffer
  /*
    (fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      # Set mode to 755 instead of 777 or openssh no worky
      options = ["relatime" "mode=755" "size=6G"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";

      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/nix/.swapfile";
      randomEncryption.enable = true;
      size = 8 * 1024;
    }
  ];
  */

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
