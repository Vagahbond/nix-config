# Get the latest models
# curl -X GET https://api.mammouth.ai/v1/models -H "Authorization: Bearer sk-k-h7hhruqwd998KWSFrx_g" | jq '.data | map_values(.id) | reduce .[] as $item ({}; . + { ($item): { name: ($item + " - Mammouth.ai")}})'
[

  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        inputs,
        ...
      }:
      {

        environment.systemPackages = [
          inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.crush
        ];
      };
  }
]
