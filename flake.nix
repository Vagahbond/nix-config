{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    {
      self,
      charpente,
      ...
    }@inputs:
    let
      systems = charpente.lib.mkSystems {
        root = self;

        hosts = [
          "air"
          "framework"
          "live"
          "platypute"
        ];

        modules = import ./charpenteModules.nix;

        extraArgs = {
          username = "vagahbond";
          inherit
            inputs
            self
            ;
        };
      };
    in
    {
      nixosConfigurations = systems.nixosSystems;
      darwinConfigurations = systems.darwinSystems;

    };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    # pin nixpkgs to switch to stable later
    nixpkgs.url = "github:NixOS/nixpkgs";

    nix-darwin.url = "github:nix-darwin/nix-darwin";

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:yaxitech/ragenix";

    nvf = {
      url = "github:notashelf/nvf";
      # url = "/Users/vagahbond/Projects/nvf";
    };

    autoDarkModeNvim = {
      url = "github:f-person/auto-dark-mode.nvim";
      flake = false;
    };

    nix-cooker.url = "github:vagahbond/nix-cooker";

    website = {
      url = "github:vagahbond/homepage";
    };

    audio-experiments = {
      url = "github:vagahbond/audio-experiments";
    };

    blog = {
      url = "github:vagahbond/blog";
    };

    mkReset = {
      # url = "/home/vagahbond/Projects/mk_reset_online";
      url = "github:jmsk8/mk_reset_online";
    };

    charpente = {
      url = "github:vagahbond/charpente";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

  };
}
