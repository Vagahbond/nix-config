# Get the latest models
# curl -X GET https://api.mammouth.ai/v1/models -H "Authorization: Bearer sk-k-h7hhruqwd998KWSFrx_g" | jq '.data | map_values(.id) | reduce .[] as $item ({}; . + { ($item): { name: ($item + " - Mammouth.ai")}})'
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
          path = "${config.users.users.${username}.home}/.config/opencode/opencode.json";

          owner = username;

          mode = "u=r,g=,o=";

        };
      };

      environment.systemPackages = [
        pkgs.opencode
      ];
    };
}
