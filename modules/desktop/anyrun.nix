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
          randr
          websearch
          shell
          # symbols
          translate
          dictionary
          #         inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        ];
        # position = "top";
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
        /*
          "nixos-options.ron".text = let
          nixos-options = config.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
          hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
          options = builtins.toJSON {
            ":nix" = [nixos-options];
            ":hm" = [hm-options];
          };
        in ''
          Config(
            options: ${options},
            max_entries: 5
          )
        '';
        */

        "dictionary.ron".text = ''
          Config(
            prefix: ":def",
          )
        '';
        "randr.ron".text = ''
          Config(
            prefix: ":dp",
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
