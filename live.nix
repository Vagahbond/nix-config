# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/installation-device.nix
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
    inputs.disko.nixosModules.disko
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];

  users = {
    users = {
      nixos = lib.mkImageMediaOverride {
        isSystemUser = true;
        group = "nixos";
      };
      root = {
        # no login on root !
        hashedPassword = "!";
      };
    };
    groups.nixos = { };
  };

  security.sudo = {
    wheelNeedsPassword = lib.mkImageMediaOverride false;
  };

  fileSystems = pkgs.lib.mkImageMediaOverride {
    "/nix" = {
      device = "/dev/disk/by-label/live-persist";
      fsType = "ext4";
      options = [
        "relatime"
        "nofail"
      ];
      neededForBoot = true;
    };
  };

  environment.persistence.${config.persistence.storageLocation} = lib.mkForce {
    enable = lib.mkForce true;
    directories = [
      "/var/cache"
      "/var/log"
      "/var/lib"
      "/var/tmp"
      "/home"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  networking = {
    useDHCP = pkgs.lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkForce "${architecture}-linux";

  persistence.enable = lib.mkForce true;

  isoImage.volumeID = lib.mkForce "${config.networking.hostName}-live";
  image.fileName = lib.mkForce "nixos.iso";

  services = {
    openssh = {
      enable = pkgs.lib.mkDefault true;
      settings.PermitRootLogin = pkgs.lib.mkForce "no";
    };

    getty = {
      autologinUser = pkgs.lib.mkForce null;
      helpLine = pkgs.lib.mkForce ''
        Youre logging into ${config.networking.hostName}
      '';
    };
  };

}
