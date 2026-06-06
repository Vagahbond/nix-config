# Get the latest models
# curl -X GET https://api.mammouth.ai/v1/models -H "Authorization: Bearer sk-k-h7hhruqwd998KWSFrx_g" | jq '.data | map_values(.id) | reduce .[] as $item ({}; . + { ($item): { name: ($item + " - Mammouth.ai")}})'
[

  {
    targets = [ "androidConfiguration" ];

    conf =
      { pkgs, ... }:
      {
        environment.packages = with pkgs; [
          crush
        ];
      };
  }
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        ...
      }:
      {

        environment.systemPackages = [
          pkgs.crush
        ];
      };
  }
]
