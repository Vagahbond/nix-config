      ssh = {
        enable = mkEnableOption "ssh client";
        keys = mkOption {
          description = "Installed SSH keys";
          default = [];
          type = types.listOf (types.attrs);
          example = [keys.dedistonks_access];
        };
      };
{
  config,
  pkgs,
  username,
  lib,
  options,
}:
let
  privKeys = lib.lists.map (value: { "${value.name}" = value.priv; }) config.modules.network.ssh.keys;

  pubKeytoHomeFile = value: {
    ".ssh/${value.name}.pub" = {
      text = value.pub;
    };
  };

  pubKeys = lib.mkMerge (lib.lists.map pubKeytoHomeFile config.modules.network.ssh.keys);
in
{
  environment.systemPackages = with pkgs; [
    sshs
  ];

  age.secrets = lib.mkMerge (
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

}
// lib.optionalAttrs (builtins.hasAttr "home-manager" options) {
  home-manager.users.${username}.home.file = pubKeys;

}
