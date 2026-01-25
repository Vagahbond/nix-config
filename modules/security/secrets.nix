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
      config,
      ...
    }:
    {

      home-manager.users.${username} = {
        imports = [ inputs.agenix.homeManagerModules.default ];

        age.identityPaths = [
          "${config.users.users.${username}.home}/.ssh/id_ed25519"
        ];

      };

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
