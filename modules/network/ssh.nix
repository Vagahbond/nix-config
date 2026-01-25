{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
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

      pubKeys = pkgs.lib.mkMerge (builtins.attrValues (builtins.mapAttrs pubKeytoHomeFile keys));
      privKeys = builtins.mapAttrs (_: k: k.priv) keys;
    in
    {
      /*
        options.network.ssh.keys = mkOption {
          description = "Installed SSH keys";
          default = [ ];
          type = types.attrs;
          example = [ keys.dedistonks_access ];
        };
      */
      config = {
        # WARN: Remove home-manager, also every system needs those public keys
        home-manager.users.${username} = {
          home.file = pubKeys;

          age.secrets = privKeys // {
            sshConfig = {
              file = ../../secrets/ssh_config.age;
              path = "${config.users.users.${username}.home}/.ssh/config";
              mode = "644";
              # owner = username;
              # group = "users";
            };
          };
        };
        environment.systemPackages = with pkgs; [
          sshs
        ];

      };
    };

  nixosConfiguration =
    {
      config,
      ...
    }:
    {

      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          "/root/.ssh"
        ];
      };
    };

}
