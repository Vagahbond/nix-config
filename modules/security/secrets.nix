{

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

  nixOnDroidConfiguration =
    { inputs, ... }:
    {
      imports = [ inputs.agenix.nixosModules.default ];

    };

  nixosConfiguration =
    {
      inputs,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.nixosModules.default ];

      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          "/run/agenix.d"
          "agenix"
        ];
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
