# nix build .#nixosConfigurations.hostName.config.system.build.isoImage
[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        config,
        inputs,
        username,
        ...
      }:
      {

        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        ];

        isoImage.volumeID = pkgs.lib.mkForce "${config.networking.hostName}-live";
        image.fileName = pkgs.lib.mkForce "nixos.iso";
      };
  }
]
