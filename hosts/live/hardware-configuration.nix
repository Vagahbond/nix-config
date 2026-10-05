{
  inputs,
  config,
  lib,
  ...
}:
{
  # Live env goes in ram
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "relatime"
        "mode=755"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-partlabel/live-persist";
      fsType = "ext4";
      options = [
        "relatime"
        "mode=755"
      ];
      neededForBoot = true;
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  isoImage.volumeID = lib.mkForce "${config.networking.hostName}-live";
  isoImage.isoName = lib.mkForce "${config.networking.hostName}-nixos.iso";
}
