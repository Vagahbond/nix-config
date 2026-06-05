{
  config,
  username,
  lib,
  ...
}:
let
  mConfig = config;
in
{

  options = {
    users.users.${username}.home = lib.mkOption {
      type = lib.types.path;
      default = config.user.home;
      description = ''
        The home directory of the user.
      '';
    };

    environment.systemPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        The system packages to install.
      '';
    };

    # Suppress error on age config definition
    age.secrets = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        The age secrets to use (Ignored on Android systems).
      '';
    };
  };

  config = {
    environment.packages = mConfig.environment.systemPackages;
  };

}
