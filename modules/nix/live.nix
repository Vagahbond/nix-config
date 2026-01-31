# nix build .#nixosConfigurations.hostName.config.system.build.isoImage
{
  targets = [
    "live"
  ];

  nixosConfiguration =
    {
      pkgs,
      config,
      inputs,
      username,
      ...
    }:
    {
      users.users.${username}.hashedPassword =
        "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];

      isoImage.volumeID = pkgs.lib.mkForce "${config.networking.hostName}-live";
      isoImage.isoName = pkgs.lib.mkForce "${config.networking.hostName}-nixos.iso";
    };
}
