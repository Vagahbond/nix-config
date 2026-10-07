{
  pkgs,
  config,
  inputs,
  lib,
  architecture,
  ...
}:
{

  assertions = [
    {
      assertion = architecture != null;
      message = "Architecture must be set for live environments. (as as hostExtraArg or extraArg)";
    }
  ];

  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    inputs.disko.nixosModules.disko
  ];

  fileSystems = pkgs.lib.mkImageMediaOverride {
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
    useDHCP = pkgs.lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkForce "${architecture}-linux";

  persistence.enable = lib.mkForce false;

  isoImage.volumeID = lib.mkForce "${config.networking.hostName}-live";
  image.fileName = lib.mkForce "nixos.iso";

  services.getty.autologinUser = pkgs.lib.mkForce null;
}
