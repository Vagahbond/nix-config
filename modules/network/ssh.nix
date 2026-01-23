{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    {
      pkgs,
      keys,
      config,
      username,
      ...
    }:
    let
      inherit (pkgs.lib)
        mkOption
        types
        mkMerge
        ;

      # privKeys = map (value: { "${value.name}" = value.priv; }) config.network.ssh.keys;
      privKeys = import ../../secrets/sshKeys.nix { inherit pkgs username; };
    in
    {
      options = {
        network.ssh.keys = mkOption {
          description = "Installed SSH keys";
          default = [ ];
          type = types.listOf types.attrs;
          example = [ keys.dedistonks_access ];
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          sshs
        ];

        age.secrets = mkMerge (
          privKeys
          ++ [
            {
              sshConfig = {
                file = ../../secrets/ssh_config.age;
                path = "/home/${username}/.ssh/config";
                owner = username;
                group = "users";
              };
            }
          ]
        );

      };
    };
  nixosConfiguration =
    {
      config,
      pkgs,
      username,
    }:
    let
      pubKeytoHomeFile = value: {
        ".ssh/${value.name}.pub" = {
          text = value.pub;
        };
      };

      pubKeys = pkgs.lib.mkMerge (pkgs.lib.lists.map pubKeytoHomeFile config.modules.network.ssh.keys);

    in

    {
      # WARN: Remove home-manager, also every system needs those public keys
      home-manager.users.${username}.home.file = pubKeys;

    };
}
