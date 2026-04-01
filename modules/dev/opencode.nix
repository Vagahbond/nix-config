{
  targets = [
    "air"
  ];

  sharedConfiguration =
    {
      pkgs,
      config,
      username,
      ...
    }:
    {
      age.secrets = {
        opencode = {
          file = ../../secrets/opencode_conf.age;
          path = "${config.users.users.${username}.home}/.config/opencode/opencode.jsonc";

          owner = username;

          mode = "u=r,g=,o=";

        };
      };

      environment.systemPackages = [
        pkgs.opencode
      ];
    };
}
