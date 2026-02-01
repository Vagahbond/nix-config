{
  targets = [
    "platypute"
  ];

  nixosConfiguration = {
    pkgs,
    config,
    username,
    ...
  }: let
    keys = import ../../secrets/sshKeys.nix {inherit pkgs config username;};
  in {
    users.groups.builder = {};

    users.users.builder = {
      isNormalUser = true;
      group = "builder";
      createHome = false;

      description = "This user is gonna be used especially for the remote building for security reasons";

      openssh.authorizedKeys.keys = with keys; [
        builder_access.pub
      ];
    };

    nix.settings.trusted-users = ["builder"];
  };
}
