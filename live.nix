# nix build .#nixosConfigurations.hostName.config.system.build.isoImage
{
  lib,
  config,
  inputs,
  ...
}: {
  # TODO: Use mkForce to override settings that are not needed in live envs

  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  isoImage.volumeID = lib.mkForce "${config.networking.hostName}-live";
  isoImage.isoName = lib.mkForce "${config.networking.hostName}-nixos.iso";
}
