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

      age.identityPaths = [
        "${config.users.users.${username}.home}/.ssh/id_ed25519"
      ];

      environment = {
        systemPackages = [
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };

  nixosConfiguration =
    {
      inputs,
      config,
      useername,
      ...
    }:
    {
      imports = [ inputs.agenix.nixosModules.default ];
      environment.persistence.${config.impermanence.storageLocation} = {
        directories = [ "/run/agenix.d" ];
      };

    };

  darwinConfiguration =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.agenix.darwinModules.default ];
    };
}
