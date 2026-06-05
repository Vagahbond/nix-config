{
  config,
  pkgs,
  username,
  lib,
}:
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
  };

  config = {

    config.user.home = config.users.users.${username}.home;

    config.environment.packages = config.environment.systemPackages;

  };

}
