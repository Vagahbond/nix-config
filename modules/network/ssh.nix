[

  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        username,
        config,
        ...
      }:
      {
        home-files.${username} = {
          ".ssh/config" = {
            source = config.age.secrets.sshConfig.path;
          };
        };

        age.secrets = {
          sshConfig = {
            file = ../../secrets/ssh_config.age;
            owner = username;
            mode = "440";
          };
        };

        environment.systemPackages = with pkgs; [
          sshs
        ];
      };
  }
]
