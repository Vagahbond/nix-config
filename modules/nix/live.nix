# nix build .#nixosConfigurations.hostName.config.system.build.isoImage
{
  targets = [
    "platypute"
    "framework"
  ];

  nixosConfiguration =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {

      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];

      isoImage.volumeID = pkgs.lib.mkForce "${config.networking.hostName}-live";
      isoImage.isoName = pkgs.lib.mkForce "${config.networking.hostName}-nixos.iso";
    };
}
