{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs =
    {
      self,
      nixpkgs,
      charpente,
      ...
    }@inputs:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-darwin" # Imagine nixing a mac
        ] (system: function nixpkgs.legacyPackages.${system});

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

      packages = forAllSystems (pkgs: {
        nvf =
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = inputs.nvf.inputs.nixpkgs.legacyPackages.${pkgs.system};
            modules = [
              (import ./modules/editor/nvf.nix)
            ];
          }).neovim;
      });
    };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:ryantm/agenix";

    nvf = {
      url = "github:notashelf/nvf/1bf757685b065c5aaeaf252c02457238df42ed31";
    };

    nix-cooker.url = "github:vagahbond/nix-cooker";

    website = {
      url = "github:vagahbond/website";
      flake = false;
    };

    # TODO: better package
    blog-contents = {
      url = "github:vagahbond/blog";
      flake = false;
    };

    blog-theme = {
      url = "github:athul/archie";
      flake = false;
    };

    mkReset = {
      # url = "/home/vagahbond/Projects/mk_reset_online";
      url = "github:jmsk8/mk_reset_online";
    };

    charpente = {
      url = "/Users/vagahbond/Projects/carpentry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
