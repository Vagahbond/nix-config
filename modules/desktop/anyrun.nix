{
  config,
  inputs,
  pkgs,
  username,
  ...
}: {
  nix.settings = {
    substituters = [
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  home-manager.users.${username} = {
    imports = [inputs.anyrun.homeManagerModules.default];

    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          rink
          websearch
          shell
          translate
          dictionary
        ];

        y.fraction = 0.3;
        width.fraction = 0.3;
        closeOnClick = true;
        hidePluginInfo = true;
        showResultsImmediately = true;
        maxEntries = 10;
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
      };

      extraCss = config.theme.templates.anyrunCss;
      extraConfigFiles = {
        "dictionary.ron".text = ''
          Config(
            prefix: ":def",
          )
        '';
        "applications.ron".text = ''
          Config(
            desktop_actions: true,
            max_entries: 10,
          )
        '';
        "websearch.ron".text = ''
          Config(
            prefix: "?",
            engines: [
              DuckDuckGo,
              Custom(
                name: "nix packages",
                url: "search.nixos.org/packages?query={}&channel=unstable",
              ),
            ],
          )
        '';
      };
    };
  };
}
