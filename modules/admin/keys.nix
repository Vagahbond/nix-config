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
        # Dead code: this whole module used to copy every priv/pub ssh key into
        # ~/.ssh (so paths like ~/.ssh/<name> and ~/.ssh/<name>.pub existed on
        # disk) and declared the matching age.secrets. Nothing needs that
        # ~/.ssh layout anymore: ssh clients and nix's distributed builds can
        # point IdentityFile/sshKey straight at the agenix-decrypted path
        # (config.age.secrets.<name>.path), so the copy step was pure overhead.
        # The age.secrets declarations moved to modules/network/ssh.nix, which
        # is the module that actually consumes those paths now.
        # Kept for reference, remove this file (and the "admin = [ \"keys\" ]"
        # entry in hosts/air.nix) once confirmed nothing else relies on it.
        #
        # keys = import ../../secrets/sshKeys.nix { inherit config pkgs username; };
        #
        # pubKeytoHomeFile = name: value: {
        #   ".ssh/${name}.pub" = {
        #     text = value.pub;
        #   };
        # };
        #
        # privKeytoHomeFile = name: _: {
        #   ".ssh/${name}" = {
        #     source = config.age.secrets.${name}.path;
        #   };
        # };
        #
        # pubKeys = pkgs.lib.foldl (a: b: a // b) { } (
        #   builtins.attrValues (builtins.mapAttrs pubKeytoHomeFile keys)
        # );
        # privKeys = pkgs.lib.foldl (a: b: a // b) { } (
        #   builtins.attrValues (builtins.mapAttrs privKeytoHomeFile keys)
        # );
        # privKeySecrets = builtins.mapAttrs (_: k: k.priv) keys;
        #
        # home-files.${username} = pubKeys // privKeys;
        # age.secrets = privKeySecrets;
      };
  }
]
