{
  inputs,
  config,
  lib,
  ...
}:
{
  # Root is already a tmpfs provided by the ISO module. The installer module overrides
  # the whole fileSystems option, so extra mounts need the same priority to be kept.
  fileSystems = lib.mkImageMediaOverride {
    "/home" = {
      device = "/dev/disk/by-label/live-persist";
      fsType = "ext4";
      options = [
        "relatime"
        "nofail"
      ];
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
  image.filename = lib.mkForce "nixos.iso";
}
