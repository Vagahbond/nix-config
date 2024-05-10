{
  config,
  pkgs,
  username,
  lib,
}: let
  privKeys =
    lib.lists.map (
      value: {"${value.name}" = value.priv;}
    )
    config.modules.network.ssh.keys;

  pubKeytoHomeFile = value: {
    ".ssh/${value.name}.pub" = {
      text = value.pub;
    };
  };

  pubKeys = lib.mkMerge (lib.lists.map pubKeytoHomeFile config.modules.network.ssh.keys);
in {
  environment.systemPackages = with pkgs; [
    sshs
  ];

  age.secrets = lib.mkMerge (privKeys
    ++ [
      {
        sshConfig = {
          file = ../../secrets/ssh_config.age;
          path = "${config.users.users.${username}.home}/.ssh/config";
          owner = username;
          group = "users";
        };
      }
    ]);

  home-manager.users.${username}.home.file = pubKeys;
}
