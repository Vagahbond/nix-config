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
      let
        keys = import ../../secrets/sshKeys.nix { inherit config pkgs username; };

        pubKeytoHomeFile = name: value: {
          ".ssh/${name}.pub" = {
            text = value.pub;
          };
        };

        privKeytoHomeFile = name: value: {
          ".ssh/${name}" = {
            source = value.priv;
          };
        };

        pubKeys = pkgs.lib.mkMerge (builtins.attrValues (builtins.mapAttrs pubKeytoHomeFile keys));
        privKeys = pkgs.lib.mkMerge (builtins.attrValues (builtins.mapAttrs privKeytoHomeFile keys));
        privKeySecrets = builtins.mapAttrs (_: k: k.priv) keys;
      in
      {
        home-files.${username} =
          pubKeys
          // privKeys
          // {
            ".ssh/config" = {
              source = config.age.secrets.sshConfig.path;
            };
          };

        age.secrets = privKeySecrets // {
          sshConfig = {
            file = ../../secrets/ssh_config.age;
            # path = "${config.users.users.${username}.home}/.ssh/config";
            mode = "600";
            owner = username;
            group = "users";
          };
        };

        environment.systemPackages = with pkgs; [
          sshs
        ];
      };
  }
  /*
    {
      targets = [ "nixosConfiguration" ];
      conf =
        { config, ... }:
        {
          environment.persistence.${config.persistence.storageLocation} = {
            directories = [
              "/root/.ssh"
            ];
          };
        };
    }
  */
]
