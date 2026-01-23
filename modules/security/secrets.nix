{
  targets = [
    "air"
    "framework"
    "platypute"
  ];

  sharedConfiguration =
    {
      inputs,
      pkgs,
      username,
      ...
    }:
    {

      network.ssh.keys = (import ../../secrets/sshKeys.nix) { inherit username pkgs; };

      environment = {
        systemPackages = [
          inputs.agenix.packages.${pkgs.stdenv.system}.default
        ];

      };

    };

  nixosConfiguration =
    { username, inputs, ... }:
    {

      imports = [ inputs.agenix.nixosModules.default ];

      age.identityPaths = [
        "/home/${username}/.ssh/id_ed25519"
      ];
    };

  darwinConfiguration =
    { username, inputs, ... }:
    {

      imports = [ inputs.agenix.darwinModules.default ];

      age.identityPaths = [
        "/Users/${username}/.ssh/id_ed25519"
      ];
    };

}
