{
  description = "My modular NixOS configuration that totally did not take countless hours to make.";

  outputs =
    {
      self,
      nixpkgs,
      carpentry,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin" # Imagine nixing a mac
      ];

      forAllSystems =
        function: nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});

      mSystems = carpentry.lib.mkSystems {
        root = self;
        hosts = [
          ./hosts/air
        ];

        modules = [
          ./modules/test
          ./modules/othertest.nix
        ];
      };
    in
    {
      nixosConfigurations = mSystems.nixosSystems;

      darwinConfigurations = mSystems.darwinSystems;
      /*
        .air = inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs self;
          };
          modules = [
            inputs.agenix.darwinModules.default
            (import ./hosts/air/features.nix)
          ];
        };
      */

      packages = forAllSystems (pkgs: {
        doc = import ./doc {
          inherit inputs self pkgs;
        };

        nvf =
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = inputs.nvf.inputs.nixpkgs.legacyPackages.${pkgs.system};
            # inherit pkgs;
            modules = [
              (import ./modules/editor/nvf.nix)
            ];
          }).neovim;
      });
    };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:ryantm/agenix";

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/1bf757685b065c5aaeaf252c02457238df42ed31";
    };

    anyrun.url = "github:anyrun-org/anyrun";

    nix-cooker.url = "github:vagahbond/nix-cooker";

    ags.url = "github:vagahbond/ags-bar";

    universe.url = "github:uni-verse-fm/uni-verse-production";

    #learnify = {
    #  url = "git+ssh://git@github.com/vagahbond/learnify-platform";
    #};

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

    affine = {
      url = "github:toeverything/AFFiNE";
      flake = false;
    };

    matui = {
      url = "github:pkulak/matui";
    };

    mkReset = {
      # url = "/home/vagahbond/Projects/mk_reset_online";
      url = "github:jmsk8/mk_reset_online";
    };

    carpentry = {
      url = "/Users/vagahbond/Projects/carpentry";
    };
  };
}
