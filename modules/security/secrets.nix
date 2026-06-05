[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
      "androidConfiguration"
    ];
    conf =
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
  }
  {
    targets = [ "nixosConfiguration" ];
    conf =
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
  }
  {
    targets = [ "darwinConfiguration" ];
    conf =
      {
        inputs,
        ...
      }:
      {
        imports = [ inputs.agenix.darwinModules.default ];
      };
  }
]
