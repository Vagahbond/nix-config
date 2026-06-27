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

        privKeytoHomeFile = name: _: {
          ".ssh/${name}" = {

            source = config.age.secrets.${name}.path;
          };
        };

        pubKeys = pkgs.lib.foldl (a: b: a // b) { } (
          builtins.attrValues (builtins.mapAttrs pubKeytoHomeFile keys)
        );
        privKeys = pkgs.lib.foldl (a: b: a // b) { } (
          builtins.attrValues (builtins.mapAttrs privKeytoHomeFile keys)
        );
        privKeySecrets = builtins.mapAttrs (_: k: k.priv) keys;
      in
      {
        home-files.${username} = pubKeys // privKeys;

        age.secrets = privKeySecrets;
      };
  }
]
